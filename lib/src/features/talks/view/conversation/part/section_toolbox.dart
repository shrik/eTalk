import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/conversation_controller.dart';
import 'package:myartist/src/features/talks/talks.dart';
import 'package:myartist/src/features/talks/view/conversation/part/toolbox_toggle_button.dart';
import 'dart:async';

class SectionToolbox extends StatelessWidget {
  final int index;
  const SectionToolbox({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    ConversationController cvstCtrl = ConversationInheried.of(context).conversationControler;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Color(0xFF616161))),
              child: Padding(
                child: Text(
                  "原",
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                padding: EdgeInsets.fromLTRB(3, 3, 3, 5),
              ),
            ),
            onTap: () async {
              cvstCtrl.playSentence(index);
            }),
        const SizedBox(width: 20, height: 20),
        GestureDetector(
            child: Icon(
              Icons.play_circle_outline_sharp,
              size: 25,
              color: Colors.grey[700],
            ),
            onTap: () async {
              unawaited(cvstCtrl.playUserSentence(index));
            }),
        const SizedBox(width: 20, height: 20),
        ToolboxToggleButton(
            icon1: Icon(
              Icons.mic_none_rounded,
              size: 25,
              color: Colors.grey[700],
            ),
            icon2: Icon(Icons.pause_circle_outline_rounded,
                size: 25, color: Colors.grey[700]),
            onTap1: (Widget w) async {
              cvstCtrl.recordSentence(index);
            },
            onTap2: (Widget w) async {
              await cvstCtrl.stopRecordSentence();
            })
      ],
    );
  }
}
