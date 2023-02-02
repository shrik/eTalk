
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory, getTemporaryDirectory;


import '../../../../audio/audio_client.dart';
import '../../../../lib/settings.dart';



class UploadButton extends StatefulWidget {
  const UploadButton({Key? key}) : super(key: key);

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
   static const int tSampleRate = 44000;

  String buttonText = "Upload";
  int counter = 0;
  String? _mPath;

  FlutterSoundRecorder myRecord = FlutterSoundRecorder();

  Future<String> voiceToText(Uint8List bytes) async {
    int maxLen = 2 * tSampleRate * 1 * 5;
    if(bytes.lengthInBytes > maxLen){
      bytes = bytes.sublist(bytes.lengthInBytes - maxLen);
    }
    Uri uri = Uri.http(ASR_HOST, "/asr");
    var request = new http.MultipartRequest('POST', uri);
    final httpImage = await http.MultipartFile.fromBytes("upload_file", bytes,
      filename: "audio.wav");
    // request.fields.putIfAbsent(key, () => null)
    request.files.add(httpImage);
    http.StreamedResponse resp = await request.send();
    return await resp.stream.bytesToString();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        BytesBuilder bytesBuilder = BytesBuilder();
        // await myRecord.openAudioSession();
        var recordingDataController = StreamController<Food>();
        var _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
              if (buffer is FoodData) {
                bytesBuilder.add(buffer.data!);
                counter += buffer.data!.length;
              }
            });

        await myRecord!.startRecorder(
          toStream: recordingDataController.sink,
          codec: Codec.pcm16,
          numChannels: 1,
          sampleRate: tSampleRate,
        );
        Future.delayed(const Duration(seconds: 30), (){
          // myRecord.closeAudioSession();
          _mRecordingDataSubscription.cancel();
        });

        Future.delayed(const Duration(seconds: 5), () async {
          Uint8List bytes = bytesBuilder.toBytes();
          print(await voiceToText(bytes));
        });

        Future.delayed(const Duration(seconds: 10), () async {
          Uint8List bytes = bytesBuilder.toBytes();
          print(await voiceToText(bytes));
        });

        Future.delayed(const Duration(seconds: 15), () async {
          Uint8List bytes = bytesBuilder.toBytes();
          print(await voiceToText(bytes));
        });

        Future.delayed(const Duration(seconds: 20), () async {
          Uint8List bytes = bytesBuilder.toBytes();
          print(await voiceToText(bytes));
        });
        // Future.delayed(const Duration(seconds: 30), (){
        //   _mRecordingDataSubscription.cancel();
        // });




        // myRecord.startRecorder(toStream: audioStream, codec: Codec.amrNB);
      },
      child: Container(
        height: 50.0,

        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: Center(
          child: Text(buttonText),
        ),
      ),
    );
  }
}
