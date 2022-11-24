import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/talks.dart';

import '../../../conversation_controller.dart';
import '../../../conversation_info.dart';
import '../part/sentence_section.dart';

//
// class _ContentViewState extends State<ContentView> with ListenerInterface {
//   int hasCaption = 0;
//   int fiftyPercentPrompt = 1;
//   int twentyfivePercentPrompt = 2;
//   int chinesePrompt = 3;
//   int noCaption = 4;
//   TextStyle nameStyle = TextStyle(fontSize: 12, color: Colors.black);
//   TextStyle promptStyle = TextStyle(fontSize: 12, color: Colors.grey);
//   TextStyle captionStyle = TextStyle(fontSize: 16, color: Colors.black);
//   TextStyle unactiveCaptionStyle =
//       TextStyle(fontSize: 16, color: Colors.grey[800]);
//   ValueNotifier<int> activeIndex = ValueNotifier(-1);
//
//   void setActiveIndex(int val) {
//     setState(() {
//       activeIndex.value = val;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     widget.conversationController.addListener(this);
//   }
//
//   @override
//   void update(Object informer) {
//     ConversationController conversationController =
//         informer as ConversationController;
//     setActiveIndex(conversationController.currentIndex());
//     int index = min(activeIndex.value + 2, itemGKeyMap.length - 1);
//     RenderBox box =
//         itemGKeyMap[index]!.currentContext!.findRenderObject()! as RenderBox;
//     box.showOnScreen(
//         curve: Curves.fastLinearToSlowEaseIn,
//         duration: const Duration(milliseconds: 200));
//     print("Listner update, index val is: " + activeIndex.value.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<SentenceInfo> sentences =
//         widget.conversationController.conversationInfo.sentences;
//     List<Widget> sentencesWidget = [];
//     // if(sentencesWidget.isEmpty){
//     sentences.asMap().forEach((index, sentenceInfo) {
//       if (index == activeIndex.value) {
//         itemGKeyMap[index] = GlobalKey();
//         sentencesWidget
//             .add(activeSection(sentenceInfo, index, gKey: itemGKeyMap[index]!));
//       } else {
//         itemGKeyMap[index] = GlobalKey();
//         sentencesWidget.add(ValueListenableBuilder(
//           valueListenable: activeIndex,
//           builder: (context, int activeIndex, child) {
//             bool forceDisplay = activeIndex > index;
//             return DisplaySentenceSection(
//               sentenceInfo: sentenceInfo,
//               gKey: itemGKeyMap[index]!,
//                 forceDisplay: forceDisplay,
//             );
//           }
//         ));
//       }
//     });
//     return Column(
//       children: sentencesWidget,
//     );
//   }
// }
