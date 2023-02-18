import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myartist/src/features/talks/talks.dart';

import '../../../../../shared/classes/classes.dart';
import '../../../conversation_info.dart';
import 'active_section.dart';
import 'inactive_section.dart';



class SentenceSection extends StatefulWidget {
  final Sentence sentenceInfo;
  final int index;
  final ValueListenable<int> activeIndexNotifier;
  const SentenceSection({required this.sentenceInfo,
    required this.index, required this.activeIndexNotifier, Key? key}) : super(key: key);

  @override
  State<SentenceSection> createState() => _SentenceSectionState();
}

class _SentenceSectionState extends State<SentenceSection> {
  bool isActive = false;

  @override
  void initState(){
    super.initState();
    isActive = widget.index == widget.activeIndexNotifier.value;
    widget.activeIndexNotifier.addListener(_activeIndexChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(isActive){
        var _scrollCtl =  ContentViewInheried.of(context).scrollController;
        var _scrollKey = ContentViewInheried.of(context).relative_element_key;
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero,
            ancestor: _scrollKey.currentContext!.findRenderObject() as RenderBox);
        // print("${offset}  and position: ${_scrollCtl.offset}" );
        _scrollCtl.animateTo(_scrollCtl.offset + offset.dy, duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });
  }

  void _activeIndexChanged(){
    bool activeStatus = widget.index == widget.activeIndexNotifier.value;
    if(activeStatus != isActive){
      setState(() {
        isActive = activeStatus;
      });
    }
  }

  @override
  void dispose(){
    widget.activeIndexNotifier.removeListener(_activeIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isActive ? ActiveSection(sentenceInfo: widget.sentenceInfo, index: widget.index) :
    InActiveSection(sentenceInfo: widget.sentenceInfo, index: widget.index) ;
  }
}
