import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
class ContactUs extends StatelessWidget{
  ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("联系我们"),
      ),
      body:
      Padding(
      child:MarkdownBody(data: ""
          "# 关于我们\n"
          "我们致力于打造一个全英文的学习环境，帮助大家用更少的时间学好英语，享受英语带给我们的人生中不一样的体验。\n"
          "# 联系我们\n"
          "有任何问题可以通过邮件联系我们 learntotalk@xxmail.com\n"
          "# 英语学习交流群\n"
          "* QQ群1： 123456789\n"
          "* QQ群2:  987654321\n"
          "# 商务合作\n"
          "15811045025 马老师\n"
          ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      )
    );

  }
}