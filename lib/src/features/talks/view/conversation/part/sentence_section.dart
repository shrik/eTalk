import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
