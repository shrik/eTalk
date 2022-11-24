

import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/conversation_info.dart';

import '../../../talks.dart';

String englishPercentPrompt(String text, int step) {
  List<String> words = text.split(" ");
  List<String> res = [];
  for (int i = 0; i < words.length; i++) {
    if (i % step == 0) {
      res.add(words[i]);
    }
  }
  return res.join("...") + "...";
}



class PromptWidget extends StatefulWidget {
  final SentenceInfo sentenceInfo;
  final int initPromptType;
  const PromptWidget({required this.sentenceInfo,
    required this.initPromptType, Key? key}) : super(key: key);

  @override
  State<PromptWidget> createState() => _PromptWidgetState();
}

class _PromptWidgetState extends State<PromptWidget> {
  int promptType = 0;
  static const int hasCaption = 0;
  static const int fiftyPercentPrompt = 1;
  static const int twentyfivePercentPrompt = 2;
  static const int chinesePrompt = 3;
  static const int noCaption = 4;

  @override
  void initState(){
    super.initState();
    promptType = widget.initPromptType;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, int captionOption, child) {
        String promptText = "";
        List<String> userRoles = ConversationInheried.of(context).conversationControler.userRoles;
        bool isSpeaker = userRoles.contains(widget.sentenceInfo.speaker);
        if(!isSpeaker){
          return SizedBox(height: 20,);
        }else{
          if(captionOption == noCaption || captionOption == hasCaption){
            return SizedBox(height: 20,);
          }
          if (captionOption == fiftyPercentPrompt) {
            promptText = englishPercentPrompt(widget.sentenceInfo.text, 2);
          }
          if (captionOption == twentyfivePercentPrompt) {
            promptText = englishPercentPrompt(widget.sentenceInfo.text, 4);
          }
          if (captionOption == chinesePrompt) {
            promptText = "这里是中文提示";
          }
          return Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                promptText,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          );
        }
      },
      valueListenable: ConversationInheried.of(context).captionValueNotifier,);
  }
}