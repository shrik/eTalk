
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

import '../../conversation_controller.dart';
import '../../conversation_info.dart';


class ConversationButton extends StatefulWidget {
  const ConversationButton({Key? key}) : super(key: key);

  @override
  State<ConversationButton> createState() => _ConversationButtonState();
}

class _ConversationButtonState extends State<ConversationButton> {
  String buttonText = "Conversation";
  ConversationController conversationController = ConversationController();


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        conversationController.start();
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
