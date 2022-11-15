import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

import '../../../../audio/audio_client.dart';
//  TODO Stateful Widget
class TailButton extends StatelessWidget {
  const TailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // print("In Play");
        // String mp3file = await AudioClient.tailAudio("audios/fyekong.mp3", 10, is_asset: true);
        // FlutterSoundPlayer? myPlayer = FlutterSoundPlayer();
        // // await myPlayer?.openAudioSession();
        // // await myPlayer.startPlayer(fromURI: mp3file, whenFinished: myPlayer.closeAudioSession);
      },
      child: Container(
        height: 50.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: const Center(
          child: Text('Cut Music'),
        ),
      ),
    );
  }
}
