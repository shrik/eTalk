// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_sound/flutter_sound.dart';
//
// import '../../../../audio/audio_client.dart';
// //  TODO Stateful Widget
// class PlayButton extends StatelessWidget {
//   const PlayButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         print("In Play");
//         await AudioClient.playMusic(7, 9, null);
//       },
//       child: Container(
//         height: 50.0,
//         padding: const EdgeInsets.all(8.0),
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.0),
//           color: Colors.lightGreen[500],
//         ),
//         child: const Center(
//           child: Text('Play Music'),
//         ),
//       ),
//     );
//   }
// }