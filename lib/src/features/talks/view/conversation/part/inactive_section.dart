import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/talks.dart';
import 'package:myartist/src/features/talks/view/conversation/part/person_icon_widget.dart';
import 'package:myartist/src/features/talks/view/conversation/part/prompt_widget.dart';

import '../../../../../shared/classes/classes.dart';
import '../../../conversation_info.dart';
import 'caption_display_widget.dart';

class InActiveSection extends StatelessWidget {
  final Sentence sentenceInfo;
  final int index;
  const InActiveSection(
      {required this.sentenceInfo, required this.index, super.key});

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
                        child: IntrinsicWidth(
                          child: Column(children: [
                                  CaptionDisplayWidget(
                                    sentenceInfo: sentenceInfo,
                                      captionOptionNotifier: ConversationInheried.of(context).captionValueNotifier,
                                      userRoleNotifier: ConversationInheried.of(context).userRoleNotifier,
                                    activeIndexNotifier: ConversationInheried.of(context).activeIndexNotifier,
                                    conversationStatusNotifier: ConversationInheried.of(context).currentStateNotifier,
                                    index: index,
                                  ),
                                  SizedBox(height:5),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: PromptWidget(
                                      sentenceInfo: sentenceInfo,
                                      initPromptType: ConversationInheried.of(context)
                                          .captionValueNotifier
                                          .value,
                                    ),
                                  ),
                                ])
                        ),
                      ),
                      alignment: Alignment.centerLeft),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        )));
  }
}
