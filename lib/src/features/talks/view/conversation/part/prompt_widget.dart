

import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/conversation_info.dart';

import '../../../../../shared/classes/classes.dart';
import '../../../lib/caption.dart';
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
  final Sentence sentenceInfo;
  final CaptionEnum initPromptType;
  const PromptWidget({required this.sentenceInfo,
    required this.initPromptType, Key? key}) : super(key: key);

  @override
  State<PromptWidget> createState() => _PromptWidgetState();
}

class _PromptWidgetState extends State<PromptWidget> {
  CaptionEnum promptType = CaptionEnum.OriginalText;

  @override
  void initState(){
    super.initState();
    promptType = widget.initPromptType;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, CaptionEnum captionOption, child) {
        return ValueListenableBuilder(valueListenable: ConversationInheried.of(context).userRoleNotifier, builder: (context, String userRole, childe){
          String promptText = "";
          bool isSpeaker = userRole == widget.sentenceInfo.speaker;
          if(!isSpeaker){
            return SizedBox(height: 20,);
          }else{
            if(captionOption == CaptionEnum.HideOriginalText || captionOption == CaptionEnum.OriginalText){
              return SizedBox(height: 20,);
            }
            if (captionOption == CaptionEnum.FiftyPercentPrompt) {
              promptText = englishPercentPrompt(widget.sentenceInfo.text, 2);
            }
            if (captionOption == CaptionEnum.TwentyFivePercentPrompt) {
              promptText = englishPercentPrompt(widget.sentenceInfo.text, 4);
            }
            if (captionOption == CaptionEnum.ChinesePrompt) {
              promptText = widget.sentenceInfo.translation;
            }
            return IntrinsicWidth(child: Row(
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
              // mainAxisAlignment: MainAxisAlignment.center,
            ),
            );
          }
        });
      },
      valueListenable: ConversationInheried.of(context).captionValueNotifier,);
  }
}