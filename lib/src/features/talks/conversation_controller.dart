import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:myartist/src/features/talks/running_step.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, getTemporaryDirectory;
import 'package:http/http.dart' as http;

import '../../audio/audio_client.dart';
import '../../lib/listener_interface.dart';
import 'conversation_info.dart';
import 'package:logger/logger.dart' as logger;
import 'package:synchronized/synchronized.dart';
import 'package:just_audio/just_audio.dart';


class ConversationController {
  ConversationInfo conversationInfo = ConversationInfo();
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
  Lock lock = Lock();
  bool paused = false;
  bool finished = false;
  bool started = false;
  bool running = false;
  bool get isFinished => finished;
  bool get isPaused => paused;
  bool get isStarted => started;
  RunningStep? currentStep;
  List<String> get Speakers => conversationInfo.Speakers;

  ConversationController();

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
    File file = await AudioClient.getFileFromAssets("audios/BuyingTextBooks.mp3");
    await sectionPlayer.setFilePath(file.path);
  }


  void reset(){
    lock.synchronized(() {
      paused = false;
      finished = false;
      started = false;
      running = false;
      sectionResume = false;
      currentStep = null;
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
    SentenceInfo sentenceInfo = conversationInfo.sentences[index];
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
    SentenceInfo sentenceInfo = conversationInfo.sentences[index];
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
    try {
      await lock.synchronized(() async {
        File file = await AudioClient.getFileFromAssets("audios/BuyingTextBooks.mp3");
        await myPlayer.setFilePath(file.path);
        // print("**************=> \n" + conversationInfo.sentences.toString());
        started = true;
      });
      unawaited(run());
    } catch (e) {
      await myPlayer.stop();
      await myRecorder.closeRecorder();
      conversationInfo.reset();
      rethrow;
    }
  }

  Future<void> pause() async {
    await lock.synchronized(() async {
      if(paused || running == false || currentStep == null){
        throw Exception("not running");
      }else{
        paused = true;
          await currentStep?.stop();
      }
    });
  }

  Future<void> resume() async {
    await lock.synchronized(() async {
      if(paused && running == false){
        paused = false;
        unawaited(run());
      }else{
        throw Exception("error resuming");
      }
    });
  }


  Future<void> run() async {
    await lock.synchronized(() => running = true);
    bool hasError = false;
    while (!isFinished && !hasError && !isPaused) {
      await lock.synchronized(()  async {
        if(isPaused){return;}
        currentStep ??= await keepGoing(null);
      });
      Future? f;
      await lock.synchronized(() async {
        if(isPaused){return;}
        if(currentStep!.isFinnished){
          currentStep = await keepGoing(currentStep!);
          if(currentStep == null){
            finished = true;
            unawaited(broadcast());
            return;
          }
          f = currentStep!.run();
        } else if(currentStep!.isStopped){
          f = currentStep!.resume();
        }else{
          f = currentStep!.run();
        }
      });
      if(f != null){
        await f;
        await lock.synchronized(() {
          if(isPaused){return;}
          currentStep!.finish();
        });
      }
    }
    await lock.synchronized(() => running=false);
  }

  Future<RunningStep?> keepGoing(RunningStep? lastStep) async {
    RunningStep? step;
    if(lastStep == null){
      step = await nextSentenceStep();
    }
    switch (lastStep.runtimeType) {
      case CheckInputStep:{
        var checkStep = lastStep as CheckInputStep;
        if(lastStep.isMatched()){
          step = await nextSentenceStep();
        }else{
          step = CheckInputStep(checkStep.listenSpeakerStep);
        }
      }
      break;
      case ListenSpeakerStep: {
        step = CheckInputStep(lastStep as ListenSpeakerStep);
      }
      break;
      case PlayClipMusicStep: {
        step = await nextSentenceStep();
      }
      break;
    }
    return step;
  }

  Future<RunningStep?> nextSentenceStep() async {
    SentenceInfo? sentenceInfo = conversationInfo.next();
    unawaited(broadcast());
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
