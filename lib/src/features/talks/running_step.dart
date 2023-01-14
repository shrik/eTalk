import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:synchronized/synchronized.dart';
import 'package:async/async.dart';
import '../../shared/classes/classes.dart';
import 'conversation_info.dart';

abstract class RunningStep{
  bool stopped = false;
  bool finished = false;
  Future<dynamic> run() async {

  }

  Future<dynamic> stop() async {
    stopped=true;
  }

  Future<dynamic> resume() async {
    stopped=false;
  }

  Future<dynamic> cancel() async {
    throw Exception("please implement this function");
  }

  bool get isStopped => stopped;
  bool get isFinnished => finished;

  Future<dynamic> finish() async {
    finished = true;
  }
}

class CheckInputStep{
  bool? result;

  Future<bool> audioMatchContent(Uint8List bytes, String text, ListenSpeakerStep listenSpeakerStep) async {
    int seconds = 7;
    int channel = 1;
    int bytesPerSignal = 2;
    int maxLen = bytesPerSignal * listenSpeakerStep.tSampleRate * channel * seconds;
    if (bytes.lengthInBytes > maxLen) {
      bytes = bytes.sublist(bytes.lengthInBytes - maxLen);
    }
    Uri uri = Uri.http("192.168.3.17:8888", "/asr_match");
    var request = new http.MultipartRequest('POST', uri);
    final httpImage = await http.MultipartFile.fromBytes("upload_file", bytes,
        filename: "audio.wav");
    // request.fields.putIfAbsent(key, () => null)
    request.files.add(httpImage);
    request.fields.addAll({"text": text});
    http.StreamedResponse resp;
    try{
      resp = await request.send().timeout(const Duration(seconds: 1));
      String res = await resp.stream.bytesToString();
      return res.contains("true");
    }on TimeoutException catch(e){
      return false;
    }catch(e){
      print("Error Please Handle this Error");
      return false;
    }

  }


  @override
  Future<bool> run(ListenSpeakerStep listenSpeakerStep) async {
      var bytesBuilder = listenSpeakerStep.bytesBuilder;
      var sentenceInfo = listenSpeakerStep.sentenceInfo;
      Uint8List bytes = bytesBuilder.toBytes();
      bool match;
      try{
        match = await audioMatchContent(bytes, sentenceInfo.text, listenSpeakerStep);
      }catch(e){
        rethrow;
      }
      result = match;
      return result!;
  }
}

class ListenSpeakerStep extends RunningStep {
  FlutterSoundRecorder recorder;
  Sentence sentenceInfo;
  StreamController<Food>? recordingDataController;
  StreamSubscription<Food>? recorderDataSubscription;
  BytesBuilder bytesBuilder = BytesBuilder();
  int tSampleRate;
  AudioPlayer soundEffectPlayer = AudioPlayer();
  bool checkSuccessed = false;
  Lock lock = Lock();
  Future? currentRunning;
  CancelableOperation<bool>? checkingOp;


  ListenSpeakerStep(this.recorder, this.sentenceInfo, this.tSampleRate);

  @override
  Future<void> run() async {
    await lock.synchronized(() async {
      await soundEffectPlayer.setAsset("assets/audios/mixkit-small-door-bell-589.wav");
      soundEffectPlayer.setClip(start: Duration(milliseconds: 100), end: Duration(milliseconds: 500));
      await soundEffectPlayer.play();
      await recorder.openRecorder();
      recordingDataController = StreamController<Food>();
      recorderDataSubscription =
          recordingDataController!.stream.listen((buffer) {
            if (buffer is FoodData) {
              bytesBuilder.add(buffer.data!);
            }
          });
      await recorder.startRecorder(
        toStream: recordingDataController!.sink,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: tSampleRate,
      );
      currentRunning = check();
    });
    await currentRunning;
  }

  @override
  Future<void> cancel() async {
    await stop();
    await lock.synchronized(() async {
      await recorderDataSubscription?.cancel();
      await recorder.closeRecorder();
      await soundEffectPlayer.dispose();
    });
    await finish();
  }

  Future<void> check() async {
      while(!checkSuccessed && !stopped){
        await lock.synchronized(() {
          if(!stopped){
            checkingOp = CancelableOperation.fromFuture(Future(() async {
              await Future.delayed(const Duration(seconds: 1),(){});
              print("In checking Input");
              CheckInputStep checkInputStep = CheckInputStep();
              bool result = await checkInputStep!.run(this);
              return result;
            }), onCancel: () => false);
          }else{
            checkingOp = null;
          }
        });
        if(checkingOp == null){
          return;
        }else{
          checkSuccessed = (await checkingOp!.valueOrCancellation(false))!;
          checkingOp = null;
        }
      }
      if(checkSuccessed){
        await lock.synchronized(() async {
          await recorderDataSubscription!.cancel();
          await recorder.closeRecorder();
          await soundEffectPlayer.dispose();
        });
      }
  }

  @override
  Future<void> stop() async {
    await lock.synchronized(() async {
      await super.stop();
      checkingOp?.cancel();
      await recorder.pauseRecorder();
    });
    await currentRunning;
    currentRunning = null;
    print("Listen step Stopped");
  }

  @override
  Future<void> resume() async {
    await lock.synchronized(() async {
      await super.resume();
      await recorder.resumeRecorder();
      currentRunning = check();
    });
    await currentRunning;
  }
}

class PlayClipMusicStep extends RunningStep {
  AudioPlayer player;
  Sentence sentenceInfo;
  PlayClipMusicStep(this.player, this.sentenceInfo);
  Future? currentRunning;
  Lock lock = Lock();

  @override
  Future<void> run() async {
    await lock.synchronized(() async {
      await player.setClip(
          start: Duration(milliseconds: (sentenceInfo.start * 1000).round()),
          end: Duration(milliseconds: (sentenceInfo.end * 1000).round()));
      currentRunning = Future(() async{
        await player.play();
        await player.pause();
      });
    });
    await currentRunning;
  }

  @override
  Future<void> stop() async {
    await lock.synchronized(() async {
      await super.stop();
      await player.pause();
      await currentRunning;
    });
  }

  @override
  Future<void> cancel() async {
    await stop();
    await finish();
  }

  @override
  Future<void> resume() async {
    await lock.synchronized(() async {
      await super.resume();
      currentRunning = Future(() async {
        await player.play();
        await player.pause();
      });
    });
    await currentRunning;
  }


}