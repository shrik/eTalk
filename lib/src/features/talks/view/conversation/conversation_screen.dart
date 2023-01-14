import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/lib/caption.dart';
import 'package:myartist/src/features/talks/view/conversation/part/sentence_section.dart';
import 'package:myartist/src/features/talks/view/conversation/views/controller_view.dart';
import '../../../../lib/listener_interface.dart';
import '../../../../shared/classes/classes.dart';
import '../../conversation_controller.dart';
import '../../conversation_info.dart';
import 'views/content_view.dart';


class ConversationInheried extends InheritedWidget{
  final ConversationController conversationControler;
  final ValueNotifier<CaptionEnum> captionValueNotifier;
  final ValueNotifier<String> userRoleNotifier;
  final ValueNotifier<ConversationStatus> currentStateNotifier;
  final ValueNotifier<int> activeIndexNotifier;
  const ConversationInheried({required this.conversationControler,
    required this.captionValueNotifier,
    required this.userRoleNotifier,
    required this.currentStateNotifier,
    required this.activeIndexNotifier,
    super.key, required super.child});

  static ConversationInheried of(BuildContext context) {
    final ConversationInheried? result = context.dependOnInheritedWidgetOfExactType<ConversationInheried>();
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ConversationInheried oldWidget) {
    return conversationControler != oldWidget.conversationControler;
  }

}

class ContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConversationController cvstCtrl = ConversationInheried.of(context).conversationControler;
    List<Sentence> sentences = cvstCtrl.conversationInfo.sentences;
    return Column(
      children: sentences.asMap().entries.map((e) {
        return SentenceSection(sentenceInfo: e.value, index: e.key ,
            activeIndexNotifier: ConversationInheried.of(context).activeIndexNotifier);
      }).toList(),
    );
  }

}

class ConversationScreen extends StatefulWidget {
  final Conversation conversation;
  const ConversationScreen({Key? key, required this.conversation}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with ListenerInterface {
  late ConversationController cvstCtrl ;
  ValueNotifier<String> userRole = ValueNotifier("Tom");
  ValueNotifier<CaptionEnum> captionOptionValue = ValueNotifier(CaptionEnum.OriginalText);
  ValueNotifier<ConversationStatus> currentStateNotifier = ValueNotifier(ConversationStatus.NotStarted);
  ValueNotifier<int> activeIndexNotifier = ValueNotifier(-1);


  @override
  void initState() {
    cvstCtrl = ConversationController(this.widget.conversation);
    super.initState();
    cvstCtrl.initState();
    cvstCtrl.setUserRole('Tom');
    cvstCtrl.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void update(Object informer) {
    setState(() {
      currentStateNotifier.value = cvstCtrl.getStatus();
      activeIndexNotifier.value = cvstCtrl.currentIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        primary: false,
        appBar: AppBar(
          title: const Text('对话'),
          toolbarHeight: kToolbarHeight * 1.5,
        ),
        body: ConversationInheried(
          conversationControler: cvstCtrl,
          captionValueNotifier: captionOptionValue,
          userRoleNotifier: userRole,
          currentStateNotifier: currentStateNotifier,
          activeIndexNotifier: activeIndexNotifier,
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          cvstCtrl.conversation.title,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "Author: Unknown",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text("Words: 180", style: TextStyle(color: Colors.grey)),
                            Text("Time: 1m30s", style: TextStyle(color: Colors.grey))
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                        SizedBox(height: 10,),
                        ContentView()
                      ]),
                  )
                  ),
                  const ContorllerView()
            ],
          ),
        ),
      );
    });
  }
}
