import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/view/widgets/buy_textbook.dart';

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
              // BuyTextbookButton(),
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
