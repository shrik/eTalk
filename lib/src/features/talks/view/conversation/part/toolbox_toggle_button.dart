import 'package:flutter/cupertino.dart';

class ToolboxToggleButton extends StatefulWidget {
  Widget icon1, icon2;
  int curState = 1;
  Function(Widget self) onTap1, onTap2;
  bool successE1 = true;
  bool successE2 = true;
  ToolboxToggleButton({required this.icon1,
    required this.icon2,
    required this.onTap1,
    required this.onTap2,
    Key? key}) : super(key: key);

  void setSuccess(bool isSuccess){
    if(curState == 1){
      successE1 = isSuccess;
    }else{
      successE2 = isSuccess;
    }
  }

  void toggle(){
    int nextState = curState == 1 ? 2 : 1;
    curState = nextState;
    successE2 = true;
    successE1 = true;
  }

  bool shouldToggle(){
    return curState == 1 ? successE1 : successE2;
  }

  @override
  State<ToolboxToggleButton> createState() => _ToolboxToggleButtonState();
}

class _ToolboxToggleButtonState extends State<ToolboxToggleButton> {
  @override
  Widget build(BuildContext context) {
    Widget icon = widget.curState == 1 ? widget.icon1 : widget.icon2;
    Function(Widget self) onTap = widget.curState == 1 ? widget.onTap1: widget.onTap2;
    return GestureDetector(
      onTap: () async {
        await onTap(widget);
        if(widget.shouldToggle()){
          setState(() {
            widget.toggle();
          });
        }
      },
      child: icon,
    );
  }
}
