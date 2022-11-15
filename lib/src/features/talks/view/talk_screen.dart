import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/view/widgets/buy_textbook.dart';
import 'package:myartist/src/features/talks/view/widgets/conversation_button.dart';
import 'package:myartist/src/features/talks/view/widgets/play_button.dart';
import 'package:myartist/src/features/talks/view/widgets/tail_button.dart';

import 'widgets/listen_button.dart';
import 'widgets/upload_button.dart';

class TalkScreen extends StatelessWidget {
  const TalkScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        primary: false,
        appBar: AppBar(
          title: const Text('Talking'),
          toolbarHeight: kToolbarHeight * 2,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BuyTextbookButton(),
              Text("----"),
              // ListenButton(),
              // Text("----"),
              // TailButton(),
              // Text("----"),
              // UploadButton(),
              // Text("----"),
              // ConversationButton()
            ],
          ),
        )
      );
    });
  }
}
