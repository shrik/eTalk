import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/view/conversation/part/caption_display_widget.dart';
import 'package:myartist/src/features/talks/view/conversation/part/person_icon_widget.dart';
import 'package:myartist/src/features/talks/view/conversation/part/prompt_widget.dart';
import 'package:myartist/src/features/talks/view/conversation/part/section_toolbox.dart';
import '../../../../../shared/classes/classes.dart';
import '../../../talks.dart';

class ActiveSection extends StatelessWidget{
  final Sentence sentenceInfo;
  final int index;
  static final nameStyle = TextStyle(fontSize: 12, color: Colors.black);

  const ActiveSection({required this.sentenceInfo, required this.index, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                children: [
                  PersonIconWidget(speaker: sentenceInfo.speaker),
                  Text(sentenceInfo.speaker, style: nameStyle)
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          children: [
                            CaptionDisplayWidget(sentenceInfo: sentenceInfo,
                              captionOptionNotifier: ConversationInheried.of(context).captionValueNotifier,
                              userRoleNotifier: ConversationInheried.of(context).userRoleNotifier,
                              activeIndexNotifier: ConversationInheried.of(context).activeIndexNotifier,
                              conversationStatusNotifier: ConversationInheried.of(context).currentStateNotifier,
                              index: index
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: PromptWidget(sentenceInfo: sentenceInfo,
                                initPromptType: ConversationInheried.of(context).captionValueNotifier.value,),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: SectionToolbox(index: index,)
                            )
                          ],
                        )))
              ]),
            ],
          )),
    );
  }

}