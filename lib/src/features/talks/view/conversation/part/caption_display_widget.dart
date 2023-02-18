
import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/conversation_controller.dart';

import '../../../../../shared/classes/classes.dart';
import '../../../lib/caption.dart';

class CaptionDisplayWidget extends StatefulWidget {
  Sentence sentenceInfo;
  ValueNotifier<CaptionEnum> captionOptionNotifier;
  ValueNotifier<String> userRoleNotifier;
  ValueNotifier<int> activeIndexNotifier;
  ValueNotifier<ConversationStatus> conversationStatusNotifier;
  int index;
  CaptionDisplayWidget({required this.sentenceInfo,
    required this.captionOptionNotifier,
    required this.userRoleNotifier,
    required this.activeIndexNotifier,
    required this.conversationStatusNotifier,
    required this.index,
    Key? key})
      : super(key: key);

  @override
  State<CaptionDisplayWidget> createState() => _CaptionDisplayWidgetState();
}

class _CaptionDisplayWidgetState extends State<CaptionDisplayWidget> {
  bool hide = false;
  String userRole = "";
  bool clicked = false;
  @override
  void initState(){
    super.initState();
      widget.captionOptionNotifier.addListener(_captionOptionChanged);
      widget.userRoleNotifier.addListener(_userRoleChanged);
      widget.activeIndexNotifier.addListener(_activeIndexChanged);
      widget.conversationStatusNotifier.addListener(_conversationStatusChanged);
  }

  void _conversationStatusChanged(){
    // setState(() { });
  }

  void _userRoleChanged(){
    setState(() {
      userRole = widget.userRoleNotifier.value;
    });
  }

  void _activeIndexChanged(){
    bool new_hide_value;
    if(widget.activeIndexNotifier.value > widget.index) {
      new_hide_value = false;
    }else{
      new_hide_value = true;
    }
    if(new_hide_value != hide){
      setState((){
        hide = new_hide_value;
      });
    }
  }

  void _captionOptionChanged(){
    bool shouldHide = widget.captionOptionNotifier.value != CaptionEnum.OriginalText;
    if(hide != shouldHide){
      setState(() {
        hide = shouldHide;
      });
    }
  }
  
  @override
  void dispose(){
    widget.userRoleNotifier.removeListener(_userRoleChanged);
    widget.captionOptionNotifier.removeListener(_captionOptionChanged);
    widget.activeIndexNotifier.removeListener(_activeIndexChanged);
    widget.conversationStatusNotifier.removeListener(_conversationStatusChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    userRole = widget.userRoleNotifier.value;
    Sentence sentenceInfo = widget.sentenceInfo;
    String speaker = sentenceInfo.speaker;
    // print("speaker is ${speaker} and userRole is ${userRole}");
    // print("widget.captionOptionNotifier.value is ${widget.captionOptionNotifier.value} and "
    //     "CaptionEnum.OriginalText is ${CaptionEnum.OriginalText}");
    Widget showText = Text(sentenceInfo.text,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        maxLines: 5,
        overflow: TextOverflow.ellipsis);
    if(clicked){
      return showText;
    }
    if(speaker == userRole && widget.captionOptionNotifier.value != CaptionEnum.OriginalText){
      hide = true;
    }else{
      hide = false;
    }
    if(hide){
      return InkWell(
        child: Text("---已隐藏，点击显示---", style: TextStyle(fontSize: 14, color: Colors.grey[600]),),
        onTap: (){
          setState(() {
            clicked = true;
          });
        },
      );
    }
    return showText;
  }
}