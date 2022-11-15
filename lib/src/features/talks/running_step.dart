import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

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

  bool get isStopped => stopped;
  bool get isFinnished => finished;

  void finish(){
    finished = true;
  }
}

class CheckInputStep extends RunningStep {
  ListenSpeakerStep listenSpeakerStep;
  bool? result;
  Future<bool>? runningFuture;

  CheckInputStep(this.listenSpeakerStep);


  Future<bool> audioMatchContent(Uint8List bytes, String text) async {
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
    http.StreamedResponse resp = await request.send().timeout(const Duration(seconds: 1));
    String res = await resp.stream.bytesToString();
    return res.contains("true");
  }


  @override
  Future<bool> run() async {
    runningFuture = () async {
        await Future.delayed(const Duration(seconds: 1),(){});
        var bytesBuilder = listenSpeakerStep.bytesBuilder;
        var sentenceInfo = listenSpeakerStep.sentenceInfo;
        Uint8List bytes = bytesBuilder.toBytes();
        bool match;
        try{
          match = await audioMatchContent(bytes, sentenceInfo.text);
        }catch(e){
          await listenSpeakerStep.deposit();
          rethrow;
        }
        result = match;
        if(result!){
          await listenSpeakerStep.deposit();
        }
        return result!;
      }();
    return await runningFuture!;
  }

  bool isMatched() {
    return result!; //must call after finished!
  }

  @override
  Future<void> stop() async {
    await super.stop();
  }

  @override
  Future<bool> resume() async{
    await super.resume();
    if(result != null){
      return result!;
    }else{
      return await runningFuture!;
    }
  }
}

class ListenSpeakerStep extends RunningStep {
  FlutterSoundRecorder recorder;
  SentenceInfo sentenceInfo;
  StreamController<Food>? recordingDataController;
  StreamSubscription<Food>? recorderDataSubscription;
  BytesBuilder bytesBuilder = BytesBuilder();
  int tSampleRate;

  ListenSpeakerStep(this.recorder, this.sentenceInfo, this.tSampleRate);

  @override
  Future<BytesBuilder> run() async {
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
    return bytesBuilder;
  }

  @override
  Future<void> stop() async {
    await super.stop();
    await recorder.stopRecorder();
  }

  @override
  Future<BytesBuilder> resume() async {
    await super.resume();

    await recorder.resumeRecorder();
    return bytesBuilder;
  }

  Future<void> deposit() async {
    await recorderDataSubscription!.cancel();
    await recorder.closeRecorder();
  }
}

class PlayClipMusicStep extends RunningStep {
  AudioPlayer player;
  SentenceInfo sentenceInfo;
  PlayClipMusicStep(this.player, this.sentenceInfo);

  @override
  Future<void> run() async {
    await player.setClip(
        start: Duration(milliseconds: (sentenceInfo.start * 1000).round()),
        end: Duration(milliseconds: (sentenceInfo.end * 1000).round()));
    await player.play();
    await player.pause();
  }

  @override
  Future<void> stop() async {
    await super.stop();
    await player.pause();
  }

  @override
  Future<void> resume() async {
    await super.resume();
    await player.play();
    await player.pause();
  }


}