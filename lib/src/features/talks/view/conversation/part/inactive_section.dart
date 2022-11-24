
import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/talks.dart';
import 'package:myartist/src/features/talks/view/conversation/part/person_icon_widget.dart';

import '../../../conversation_info.dart';
import 'caption_display_widget.dart';

class InActiveSection extends StatelessWidget{
  final SentenceInfo sentenceInfo;
  final int index;
  const InActiveSection({required this.sentenceInfo, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          ConversationInheried.of(context).activeIndexNotifier.value = index;
        },
        child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      children: [
                        PersonIconWidget(
                          speaker: sentenceInfo.speaker,
                        ),
                        Text(sentenceInfo.speaker,
                            style: TextStyle(fontSize: 12, color: Colors.black))
                      ],
                    ),
                    Expanded(
                        child: Align(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                child: CaptionDisplayWidget(sentenceInfo: sentenceInfo, forcedDisplay: true,)),
                            alignment: Alignment.topLeft))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
              ),
            )));
  }
}
