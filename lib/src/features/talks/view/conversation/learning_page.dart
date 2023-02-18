import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/view/conversation/part/active_section.dart';
import 'package:myartist/src/features/talks/view/conversation/part/person_icon_widget.dart';
import 'package:myartist/src/features/talks/view/conversation/part/section_toolbox.dart';
import 'package:myartist/src/features/talks/view/conversation/part/sentence_section.dart';

import '../../../../shared/classes/classes.dart';
import '../../conversation_controller.dart';

class LearningPage extends StatelessWidget {
  final ConversationController cvstCtrl;
  LearningPage({super.key, required this.cvstCtrl});
  @override
  Widget build(BuildContext context) {
    List<Sentence> sentences = cvstCtrl.conversationInfo.sentences;

    return Column(
        children: [
      Expanded(
        child: SingleChildScrollView(
            child: Column(children: [
          Text(
            cvstCtrl.conversation.title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Author: Unknown",
                style: TextStyle(color: Colors.grey),
              ),
              Text("Words: 180", style: TextStyle(color: Colors.grey)),
              Text("Time: 1m30s", style: TextStyle(color: Colors.grey))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
              children: sentences.asMap().entries.map((e) {
            return LearningCard(sentence: e.value, index: e.key);
          }).toList()),
        ])),
      ),
    ]);
  }
}

class LearningCard extends StatelessWidget {
  final Sentence sentence;
  final int index;
  LearningCard({super.key, required this.sentence, required this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
    Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Card(
      color: Colors.white70,
      // color: Colors.blue[50],
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      PersonIconWidget(speaker: sentence.speaker),
                      Text(sentence.speaker,
                          style: TextStyle(fontSize: 12, color: Colors.black))
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(sentence.text,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: SectionToolbox(
                                  index: index,
                                ))
                          ],
                        )))
              ]),
            ],
          )),
    ));
  }
}
