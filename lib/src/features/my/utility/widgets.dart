import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myartist/src/shared/providers/api_req.dart';

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Color.fromRGBO(50, 62, 72, 1.0)),
    hintText: hintText,
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

MaterialButton longButtons(String title, Function fun,
    {Color color: Colors.blue, Color textColor: Colors.white}) {
  return MaterialButton(
    onPressed: () => fun(),
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}

class SendVerificationCodeWidget extends StatefulWidget {
  final TextEditingController mobileFieldController;
  const SendVerificationCodeWidget({required this.mobileFieldController, Key? key}) : super(key: key);

  @override
  State<SendVerificationCodeWidget> createState() => _SendVerificationCodeWidgetState();
}

class _SendVerificationCodeWidgetState extends State<SendVerificationCodeWidget> {
  bool available = true;
  int seconds_left = 0;

  bool isMobile(String mobile){
    return true;
  }

  void setSendIntervalLimit() async {
    Future((){

    });
    Timer(Duration(seconds: 1), () {
      setState((){
        seconds_left -= 1;
      });
    });
    setState((){
      available = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    if(available) {
      return InkWell(
        child: Text("发送验证码"),
        onTap: () async {
          var mobile = this.widget.mobileFieldController.text;
          if (isMobile(mobile)) {
            String sendStatus = await ApiReq.sendSmsCode(mobile);
            if (sendStatus == "SUCCESS") {
              Flushbar(
                title: "成功",
                message: "短信已经发送，请注意查收！",
                duration: Duration(seconds: 3),
              ).show(context);
              setSendIntervalLimit();
            } else if (sendStatus == "SENT") {
              Flushbar(
                title: "注意",
                message: "短信发送间隔不能少于60秒，请稍后再试！",
                duration: Duration(seconds: 3),
              ).show(context);
            } else {
              Flushbar(
                title: "失败",
                message: "短信发送失败，请检查您的手机号是否正确！",
                duration: Duration(seconds: 3),
              ).show(context);
            }
          } else {
            Flushbar(
              title: "失败",
              message: "请输入11位合法的手机号!",
              duration: Duration(seconds: 3),
            ).show(context);
          }
        },
      );
    }else{
      return TimerText(callback: (){
        setState(() {
          available = true;
        });
      }, seconds: 10);
    }
  }
}


class TimerText extends StatefulWidget {
  const TimerText({required this.callback, required this.seconds, Key? key}) : super(key: key);
  final int seconds;
  final Function callback;

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  int currentSecond = 0;

  @override
  void initState(){
    super.initState();
    currentSecond = this.widget.seconds;
    countDown();
  }

  void countDown() async {
    for(int i = 0; i< this.widget.seconds; i++){
      await Future.delayed(Duration(seconds: 1), (){
        setState(() {
          currentSecond -= 1;
        });
      });
    }
    this.widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Text(currentSecond.toString());
  }
}
