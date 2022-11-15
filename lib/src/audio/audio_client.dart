library audio_cutter;

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
// import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

class AudioClient {
  /// Return audio file path after cutting
  // static Future<String> cutAudio(String path, double start, double end) async {
  //   if (start < 0 || end < 0) {
  //     throw ArgumentError('The starting and ending points cannot be negative');
  //   }
  //   if (start > end) {
  //     throw ArgumentError(
  //         'The starting point cannot be greater than the ending point');
  //   }
  //   final directory = await getApplicationDocumentsDirectory();
  //   String outPath = "${directory.path}/tmp_cut.wav";
  //   await File(outPath).create(recursive: true);
  //
  //   var cmd =
  //       "-y -i \"$path\" -vn -ss $start -to $end -ar 16k -ac 2 -b:a 96k -acodec copy $outPath";
  //   await FFmpegKit.execute(cmd);
  //
  //   return outPath;
  // }

  // static Future<double> getFileDuration(String mediaPath) async {
  //   final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
  //   final mediaInfo = mediaInfoSession.getMediaInformation()!;
  //
  //   // the given duration is in fractional seconds
  //   final duration = double.parse(mediaInfo.getDuration()!);
  //   print('Duration: $duration');
  //   return duration;
  // }

  static Future<File> getFileFromAssets(String path) async {
    final ByteData byteData = await rootBundle.load('assets/$path');
    final buffer = byteData.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return File(filePath)
        .writeAsBytes(buffer.asUint8List(byteData.offsetInBytes,
        byteData.lengthInBytes));
  }


  // static Future<String> tailAudio(String path, double start, {bool is_asset = false}) async {
  //   if(is_asset){
  //     File file = await getFileFromAssets(path);
  //     path = file.path;
  //   }
  //   double end = await getFileDuration(path);
  //   print("file path is " + path + ". audio duration is " + end.toString());
  //
  //   String outPath = await cutAudio(path, max(end-start, 0), end);
  //   return outPath;
  // }

  // static Future<String> voiceToText() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   String tmpPath = "${directory.path}/tmp.amr";
  //   // String path = tmpPath;
  //   String path = await AudioClient.tailAudio(tmpPath, 10);
  //   print({"temporary path": tmpPath, "tail path": path});
  //
  //   Uri uri = Uri.http("192.168.3.17:8888", "/asr");
  //   var request = new http.MultipartRequest('POST', uri);
  //   final httpImage = await http.MultipartFile.fromPath('upload_file', path);
  //   request.files.add(httpImage);
  //   http.StreamedResponse resp = await request.send();
  //   return await resp.stream.bytesToString();
  // }


  // static Future<bool> matchAudio(String text) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   String tmpPath = "${directory.path}/tmp.amr";
  //   // String path = tmpPath;
  //   String path = await AudioClient.tailAudio(tmpPath, 7);
  //   print({"temporary path": tmpPath, "tail path": path});
  //
  //   Uri uri = Uri.http("192.168.3.100:8888", "/asr_match");
  //   var request = new http.MultipartRequest('POST', uri);
  //   final httpImage = await http.MultipartFile.fromPath('upload_file', path);
  //   request.files.add(httpImage);
  //   request.fields.addAll({"text": text});
  //   http.StreamedResponse resp = await request.send();
  //   String ret =  await resp.stream.bytesToString();
  //   print("result from server:" + ret);
  //   return ret.contains("true");
  // }

  static Future<void> playMusic(double from, double to, FlutterSoundPlayer? myPlayer) async{
    if(myPlayer == null){
      FlutterSoundPlayer myPlayer = FlutterSoundPlayer();
      await myPlayer.openPlayer();
      File file = await AudioClient.getFileFromAssets("audios/BuyingTextBooks.mp3");
      await myPlayer.startPlayer(fromURI: file.path);
      await myPlayer.pausePlayer();
    }
    Duration duration = Duration(milliseconds: (from * 1000).round());
    await myPlayer?.seekToPlayer(duration);
    await myPlayer?.resumePlayer();
  }
}