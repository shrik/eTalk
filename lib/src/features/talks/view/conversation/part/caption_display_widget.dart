
import 'package:flutter/material.dart';

import '../../../conversation_info.dart';

class CaptionDisplayWidget extends StatefulWidget {
  SentenceInfo sentenceInfo;
  bool forcedDisplay;
  CaptionDisplayWidget({required this.sentenceInfo,
    required this.forcedDisplay, Key? key})
      : super(key: key);

  @override
  State<CaptionDisplayWidget> createState() => _CaptionDisplayWidgetState();
}

class _CaptionDisplayWidgetState extends State<CaptionDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    SentenceInfo sentenceInfo = widget.sentenceInfo;
    String speaker = sentenceInfo.speaker;
    return Text(sentenceInfo.text,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis);
  }
}