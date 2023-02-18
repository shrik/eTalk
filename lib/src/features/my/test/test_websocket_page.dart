import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:synchronized/synchronized.dart';

class TestWebsocketPage extends StatelessWidget{
  FlutterSoundRecorder myRecorder = FlutterSoundRecorder();
  StreamController<Food>? recordingDataController;
  StreamSubscription<Food>? recorderDataSubscription;
  BytesBuilder bytesBuilder = BytesBuilder();
  int tSampleRate = 16000;
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://39.106.81.243:8090/paddlespeech/asr/l2talk_streaming'),
  );
  int bytesBuilderLength = 0;
  Lock lock = Lock();

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

  void initState(){

  }

  void dispose() {
    myRecorder.closeRecorder();
    // recorderDataSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test WebSocket"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(child: Text("Start"),
            onTap: () async {
              // channel.sink.add("Hello world");
               await myRecorder.openRecorder();
               recordingDataController = StreamController<Food>();
               recorderDataSubscription =
                   recordingDataController!.stream.listen((buffer) async {
                     if (buffer is FoodData) {
                       await lock.synchronized(() {
                         bytesBuilder.add(buffer.data!);
                         bytesBuilderLength += buffer.data!.length;
                         processStreamAudio(bytesBuilder);
                       });
                     }
                   });
               channel.sink.add(jsonEncode({
                 "name": "test.wav",
                 "signal": "start",
                 "sentence": "Hi, my name is Tom",
                 "nbtest": 1
               }));
               await myRecorder.startRecorder(
                 toStream: recordingDataController!.sink,
                 codec: Codec.pcm16,
                 numChannels: 1,
                 sampleRate: tSampleRate,
               );
               await Future.delayed(Duration(seconds: 5), () async {
                 await myRecorder.stopRecorder();
                 recorderDataSubscription!.cancel();
                 channel.sink.add(jsonEncode({
                    "name": "test.wav",
                   "signal": "end",
                   "nbtest": 1
                 }));
               });
            }),
            SizedBox(height: 30,),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
    );
  }

}