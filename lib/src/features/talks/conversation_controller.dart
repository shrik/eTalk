import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:myartist/src/features/talks/running_step.dart';
import 'package:myartist/src/shared/providers/api_req.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import '../../lib/listener_interface.dart';
import '../../shared/classes/classes.dart';
import 'conversation_info.dart';
import 'package:logger/logger.dart' as logger;
import 'package:synchronized/synchronized.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

enum ConversationStatus{
  NotStarted,
  Running,
  Paused,
  Finished
}

class ConversationController {
  late ConversationInfo conversationInfo;
  List<String> userRoles = [];
  List<String> robotRoles = [];
  List<ListenerInterface> listeners = [];
  FlutterSoundRecorder myRecorder =
      FlutterSoundRecorder(logLevel: logger.Level.error);
  FlutterSoundRecorder sectionRecorder = FlutterSoundRecorder(logLevel: logger.Level.error);
  AudioPlayer myPlayer = AudioPlayer();
  AudioPlayer sectionPlayer = AudioPlayer();
  AudioPlayer sectionUserPlayer = AudioPlayer();
  bool sectionResume = false;
  int tSampleRate = 16000;
  bool cancelRunning = false;
  bool audioReady = false;
  Lock lock = Lock();
  Lock opLock = Lock();
  ConversationStatus cStatus = ConversationStatus.NotStarted;
  bool get isFinished => getStatus() == ConversationStatus.Finished;
  bool get isPaused => getStatus() == ConversationStatus.Paused;
  bool get isStarted => getStatus() != ConversationStatus.NotStarted;
  RunningStep? currentStep;
  List<String> get Speakers => conversationInfo.Speakers;
  Future? currentRunning;
  late Conversation conversation;
  ConversationController(Conversation conversation){
    this.conversation = conversation;
    this.conversationInfo = ConversationInfo(conversation);
  }

  ConversationStatus getStatus(){
    return cStatus;
  }

  bool isRecording(){
    return [ListenSpeakerStep].contains(currentStep.runtimeType);
  }

  void setUserRole(String name){
    robotRoles = [];
    conversationInfo.Speakers.forEach((element) {
      if(element != name){
        robotRoles.add(name);
      }
    });
    userRoles = [name];
  }

  void addListener(ListenerInterface listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  Future<void> initState() async {
    String filePath = await downloadAudio();
    conversation.setLocalAudioPath(filePath);
    await sectionPlayer.setFilePath(filePath);
    audioReady = true;
  }
  
  Future<String> downloadAudio() async {
    // print("****" + conversation.audio_path);
    http.Response resp =  await ApiReq.download(conversation.audio_path);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filename =  "$appDocPath/assets/conversations/" + "conversation_"
        + conversation.id.toString() + ".mp3";
    File file = await File(filename).create(recursive: true);
    file.writeAsBytesSync(resp.bodyBytes);
    return filename;
  }


  Future<void> reset() async {
    await lock.synchronized(() async {
      setCurrentStatus(ConversationStatus.NotStarted);
      sectionResume = false;
      currentStep = null;
      await sectionRecorder.closeRecorder();
      await myRecorder.closeRecorder();
      conversationInfo.reset();
    });
  }

  int currentIndex() {
    return conversationInfo.currentIndex();
  }

  Future<void> broadcast() async {
    listeners.forEach((listner) {
      listner.update(this);
    });
  }

  Future<void> recordSentence(int index) async {
    Sentence sentenceInfo = conversationInfo.sentences[index];
    final directory = await getApplicationDocumentsDirectory();
    String audioPath = "${directory.path}/conversationID_${index}.amr";
    await sectionRecorder.openRecorder();
    await sectionRecorder.startRecorder(toFile: audioPath, codec: Codec.amrNB);
  }

  Future<void> stopRecordSentence() async {
    await sectionRecorder.closeRecorder();
  }

  Future<void> playUserSentence(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    String audioPath = "${directory.path}/conversationID_${index}.amr";
    await sectionUserPlayer.setFilePath(audioPath);
    await sectionUserPlayer.play();
  }

  Future<void> playSentence(int index) async {
    Sentence sentenceInfo = conversationInfo.sentences[index];
    await sectionPlayer.setClip(
        start: Duration(milliseconds: (sentenceInfo.start * 1000).round()) ,
        end: Duration(milliseconds: (sentenceInfo.end * 1000).round()));
    await sectionPlayer.play();
    // await sectionPlayer.pause();
  }

  Future<void> pausePlaySentence() async {
    await sectionPlayer.pause();
    // sectionResume = true;
  }

  Future<void> start() async {
    if(!audioReady){
      throw Exception("Audio has not been downloaded!!");
    }
    try {
      await lock.synchronized(() async {
        await myPlayer.setFilePath(conversation.local_audio_path);
        setCurrentStatus(ConversationStatus.Running);
      });
      currentRunning = run();
    } catch (e) {
      await myPlayer.stop();
      await myRecorder.closeRecorder();
      conversationInfo.reset();
      rethrow;
    }
  }

  Future<void> pause() async {
    await opLock.synchronized(()  async {
      await lock.synchronized(() async {
        if (getStatus() != ConversationStatus.Running || currentStep == null) {
          throw Exception("not running");
        } else {
          setCurrentStatus(ConversationStatus.Paused);
          unawaited(broadcast());
          await currentStep?.stop();
        }
      });
      await currentRunning;
      await lock.synchronized(() {
        currentRunning = null;
      });
      print("controller pause successed");
    });
  }


  Future<void> skipCurrent() async {
    await opLock.synchronized(()  async {
      if(cStatus != ConversationStatus.Running){
        print("Not running, no next step");
        return;
      }
      await lock.synchronized(() async {
        await currentStep?.cancel();
        cancelRunning = true;
      });
      await currentRunning;
      await lock.synchronized(() async{
        currentStep = await nextSentenceStep();
        cancelRunning = false;
      });
      currentRunning = run();
      unawaited(broadcast());
      print("controller Skip successed");
    });
  }

  Future<void> resume() async {
    await opLock.synchronized(()  async {
      await lock.synchronized(() async {
        if (currentRunning != null) {
          throw Exception("error resuming, current running is not null!");
        }
        if (getStatus() == ConversationStatus.Paused &&
            currentStep!.isStopped) {
          currentRunning = run();
        } else {
          throw Exception("error resuming");
        }
      });
      print("controller resume successed");
    });
  }

  void setCurrentStatus(ConversationStatus st){
    cStatus = st;
  }

  Future<void> finishAll()async {
    var player = await AudioPlayer();
    await player.setAsset("assets/audios/mixkit-fairy-arcade-sparkle-866.wav");
    await player.play();
    await player.dispose();
    setCurrentStatus(ConversationStatus.Finished);
    unawaited(broadcast());
  }


  Future<void> run() async {
    await lock.synchronized(() => setCurrentStatus(ConversationStatus.Running));
    unawaited(broadcast());
    while (!isFinished  && !isPaused && !cancelRunning) {
      bool shouldReturn = await lock.synchronized(()  async {
        if(isPaused){return true;}
        if(currentStep?.isFinnished == true){
          currentStep = await nextSentenceStep();
        }
        currentStep ??= await nextSentenceStep();
        if(currentStep == null){
          await finishAll();
          return true;
        }
        return false;
      });
      if(shouldReturn){return;}
      Future? f;
      await lock.synchronized(() async {
        if(isPaused){return;}
        if(currentStep!.isStopped){
          f = currentStep!.resume();
        }else{
          f = currentStep!.run();
        }
        unawaited(broadcast());
      });
      if(f != null){
        await f;
        await lock.synchronized(() async {
          if(cancelRunning){return;}
          if(isPaused){return;}
          await currentStep!.finish();
        });
      }
    }
  }

  Future<RunningStep?> nextSentenceStep() async {
    Sentence? sentenceInfo = conversationInfo.next();
    if(sentenceInfo == null){
      return null;
    }else{
      if(userRoles.contains(sentenceInfo!.speaker)){
        return ListenSpeakerStep(myRecorder, sentenceInfo, tSampleRate);
      }else{
        return PlayClipMusicStep(myPlayer, sentenceInfo);
      }
    }
  }
}
