import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:synchronized/synchronized.dart';
import '../../lib/settings.dart';
import '../../shared/classes/classes.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';


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
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://${ASR_HOST}/paddlespeech/asr/l2talk_streaming'),
  );
  int bytesBuilderLength = 0;
  Lock wslock = Lock();
  bool _terminated = false;
  ListenSpeakerStep(this.recorder, this.sentenceInfo, this.tSampleRate);

  void processStreamAudio(BytesBuilder builder){
    int chunk_size = (85 * tSampleRate ~/ 1000); // 85ms, sample_rate = 16kHz
    if(bytesBuilderLength >= chunk_size){
      Uint8List bytes = builder.takeBytes();
      int chunks_count = bytesBuilderLength ~/ chunk_size;
      Uint8List data = bytes.sublist(0, chunks_count * chunk_size);
      builder.add(bytes.sublist(chunks_count*chunk_size, bytesBuilderLength));
      bytesBuilderLength = bytesBuilderLength % chunk_size;
      channel.sink.add(data);
    }

  }

  @override
  Future<void> run() async {
    await lock.synchronized(() async {
      await soundEffectPlayer.setAsset("assets/audios/mixkit-small-door-bell-589.wav");
      soundEffectPlayer.setClip(start: Duration(milliseconds: 100), end: Duration(milliseconds: 500));
      await soundEffectPlayer.play();
      await recorder.openRecorder();
      recordingDataController = StreamController<Food>();
      channel.stream.listen((event) {
        Map res = jsonDecode(event as String);
        if(res["success"] != null && res["success"]){
          _terminated = true;
        }
      });
      channel.sink.add(jsonEncode({
        "name": "test.wav",
        "signal": "start",
        "sentence": sentenceInfo.text,
        "nbtest": 1
      }));
      recorderDataSubscription =
          recordingDataController!.stream.listen((buffer) async {
            await wslock.synchronized(() {
              if (buffer is FoodData) {
                bytesBuilder.add(buffer.data!);
                bytesBuilderLength += buffer.data!.length;
                processStreamAudio(bytesBuilder);
              };
            });
          });
      await recorder.startRecorder(
        toStream: recordingDataController!.sink,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: tSampleRate,
      );
    });
    currentRunning = await Future(() async {
      while(!_terminated){
        await Future.delayed(Duration(milliseconds: 20));
      }
      channel.sink.add(jsonEncode({
        "name": "test.wav",
        "signal": "end",
        "nbtest": 1
      }));
      await dispose();
    });
  }

  Future<void> dispose() async {
    await recorderDataSubscription?.cancel();
    await recorder.closeRecorder();
    await soundEffectPlayer.dispose();
    bytesBuilder.clear();
    bytesBuilderLength = 0;
    await channel.sink.close();
  }

  @override
  Future<void> cancel() async {
    await stop();
    await finish();
  }

  @override
  Future<void> stop() async {
    await lock.synchronized(() async {
      await super.stop();
      _terminated = true;
    });
    await currentRunning;
    currentRunning = null;
    print("Listen step Stopped");
  }

  @override
  Future<void> resume() async {
    await lock.synchronized(() async {
      await super.resume();
    });
    await run();
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