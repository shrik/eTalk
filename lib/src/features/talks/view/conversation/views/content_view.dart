
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../lib/listener_interface.dart';
import '../../../conversation_controller.dart';
import '../../../conversation_info.dart';
import '../part/toolbox_toggle_button.dart';

class Subtitle{
  String roleName;
  String text;
  Subtitle(this.roleName, this.text);
}

class Caption extends StatefulWidget {
  final bool isSpeaker;
  final bool hasCaption;
  const Caption({required this.hasCaption, required this.isSpeaker, Key? key}) : super(key: key);

  @override
  State<Caption> createState() => _CaptionState();
}

class _CaptionState extends State<Caption> {

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}


class ContentView extends StatefulWidget {
  final ConversationController conversationController;
  final String userRole;
  final bool hasCaption;
  const ContentView({required this.conversationController, required this.userRole, required this.hasCaption, super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}
GlobalKey listKey = GlobalKey();

class _ContentViewState extends State<ContentView> with ListenerInterface {
  int  activeIndex = -1;
  double fontSize = 18;
  Map<int, bool> recordedIndexMap = {};
  Map<int, GlobalKey> itemGKeyMap = {};
  Map<int, bool> showCaption= {};



  void setActiveIndex(int val){
    setState((){
      activeIndex = val;
    });
  }
  @override
  void initState(){
    super.initState();
    widget.conversationController.addListener(this);
  }

  Widget captionWidget(int index, bool isActive){
    SentenceInfo sentenceInfo = widget.conversationController.conversationInfo.sentences[index];
    String speaker = sentenceInfo.speaker;
    Widget captionText = Text(
        sentenceInfo.text, style: TextStyle(fontSize: fontSize, color: isActive==true ? Colors.black: Colors.grey),
        maxLines: 2,
        overflow: TextOverflow.ellipsis);
    if(activeIndex == -1){
      return captionText;
    }else if(widget.hasCaption){
      return captionText;
    }else if(showCaption[index] != null && showCaption[index]! == true){
      return captionText;
    }else if(index < activeIndex){
      return captionText;
    }else if(widget.userRole.contains(speaker)){
      return GestureDetector(
        onTap: (){
          setState(() {
            showCaption[index] = true;
          });
        },
        child: const Text('Click to Show!'),
      );
    } else{
        return captionText;
    }
  }

  @override
  void update(Object informer){
    ConversationController conversationController = informer as ConversationController;
    setActiveIndex(conversationController.currentIndex());
    int index = min(activeIndex + 2, itemGKeyMap.length - 1);
    RenderBox box = itemGKeyMap[index]!.currentContext!.findRenderObject()! as RenderBox;
    box.showOnScreen(curve: Curves.fastLinearToSlowEaseIn, duration: const Duration(milliseconds: 200));
    print("Listner update, index val is: " + activeIndex.toString());
  }

  Widget personIcon(SentenceInfo sentenceInfo){
    if(["Lily"].contains(sentenceInfo.speaker)){
      return const Icon(Icons.person_outline_rounded, color: Colors.pink,
          size: 24, semanticLabel: 'RoleIcon');
    }else{
      return const Icon(Icons.person_outline_rounded, color: Colors.black,
          size: 24, semanticLabel: 'RoleIcon');
    }
  }

  Widget activeSection(SentenceInfo sentenceInfo, int currentIndex, {required GlobalKey gKey}){
    List<Widget> toolBox = [GestureDetector(child: Icon(Icons.circle_outlined, size: 25),
                                  onTap: () async {
                                      widget.conversationController.playSentence(currentIndex);
                                  }),
      const SizedBox(width: 20,height: 20),
      GestureDetector(child: Icon(Icons.play_arrow_outlined, size: 25),
        onTap: () async {
          if(recordedIndexMap[currentIndex] == true){
            unawaited(widget.conversationController.playUserSentence(currentIndex));
          }
        }),
      const SizedBox(width: 20,height: 20),
      ToolboxToggleButton(icon1: Icon(Icons.mic_rounded, size: 25),
          icon2: Icon(Icons.pause_circle_filled_sharp, size: 25),
          onTap1: (Widget w) async {
            widget.conversationController.recordSentence(currentIndex);
          },
          onTap2: (Widget w) async {
            await widget.conversationController.stopRecordSentence();
            recordedIndexMap[currentIndex] = true;
          })];
    Widget rightWidget = Row(children: [
      Expanded(
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                children: [
                  captionWidget(currentIndex, true),
                  Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: toolBox,
                    ),
                  )
                ],
              )
          )
      )
    ]);

    return Padding(
        key: gKey,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Column(
              children: [
                personIcon(sentenceInfo),
                Text(sentenceInfo.speaker, style: TextStyle(fontSize: 12, color: Colors.grey))
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            rightWidget,
          ],
        )
    );
  }

  Widget unactivateSection(SentenceInfo sentenceInfo, int currentIndex, {required GlobalKey gKey}){
    Widget content = Row(children: [
      Column(
        children: [
          personIcon(sentenceInfo),
          Text(sentenceInfo.speaker, style: TextStyle(fontSize: 12, color: Colors.grey))
        ],
      ),
      Expanded(
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                children: [captionWidget(currentIndex, false)],
              )
          )
      )
    ]);
    return GestureDetector(key: gKey,
        onTap: (){
          setState(() {
            activeIndex = currentIndex;
          });
        },
        child: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: content,
          )
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<SentenceInfo> sentences = widget.conversationController.conversationInfo.sentences;
    List<Widget> sentencesWidget = [];
      // if(sentencesWidget.isEmpty){
        sentences.asMap().forEach((index, sentenceInfo) {
          if(index == activeIndex){
            itemGKeyMap[index] = GlobalKey();
            sentencesWidget.add(activeSection(
                sentenceInfo, index, gKey: itemGKeyMap[index]!));

          }else{
            itemGKeyMap[index] = GlobalKey();
            sentencesWidget.add(unactivateSection(
                sentenceInfo, index, gKey: itemGKeyMap[index]!));
          }
        });
    return ListView(
            key: listKey,
            children: sentencesWidget,
          );
  }
}
