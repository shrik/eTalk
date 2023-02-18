import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/lib/caption.dart';
import 'package:myartist/src/features/talks/view/conversation/learning_page.dart';
import 'package:myartist/src/features/talks/view/conversation/part/sentence_section.dart';
import 'package:myartist/src/features/talks/view/conversation/views/controller_view.dart';
import '../../../../lib/listener_interface.dart';
import '../../../../shared/classes/classes.dart';
import '../../conversation_controller.dart';


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
    assert(result != null, 'Not type of ConversationInheried');
    return result!;
  }

  @override
  bool updateShouldNotify(ConversationInheried oldWidget) {
    return conversationControler != oldWidget.conversationControler;
  }

}

class ContentViewInheried extends InheritedWidget {
  final ScrollController scrollController;
  final GlobalKey relative_element_key;
  ContentViewInheried({super.key, required this.scrollController, required this.relative_element_key, required super.child});
  //
  // Widget build(BuildContext context) {
  //   final ConversationController cvstCtrl = ConversationInheried.of(context).conversationControler;
  //   List<Sentence> sentences = cvstCtrl.conversationInfo.sentences;
  //   return Column(
  //     children: sentences.asMap().entries.map((e) {
  //       return SentenceSection(sentenceInfo: e.value, index: e.key ,
  //           activeIndexNotifier: ConversationInheried.of(context).activeIndexNotifier);
  //     }).toList(),
  //   );
  // }

  static ContentViewInheried of(BuildContext context) {
    final ContentViewInheried? result = context.dependOnInheritedWidgetOfExactType<ContentViewInheried>();
    assert(result != null, 'Not type of ContentViewInheried');
    return result!;
  }

  @override
  bool updateShouldNotify(ContentViewInheried oldWidget) {
    return scrollController != oldWidget.scrollController;
  }}

class ConversationScreen extends StatefulWidget {
  final Conversation conversation;
  const ConversationScreen({Key? key, required this.conversation}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with ListenerInterface {
  late ConversationController cvstCtrl ;
  ValueNotifier<String> userRole = ValueNotifier("");
  ValueNotifier<CaptionEnum> captionOptionValue = ValueNotifier(CaptionEnum.OriginalText);
  ValueNotifier<ConversationStatus> currentStateNotifier = ValueNotifier(ConversationStatus.NotStarted);
  ValueNotifier<int> activeIndexNotifier = ValueNotifier(-1);
  GlobalKey _scrollViewKey = GlobalKey();
  ScrollController _scrollController = ScrollController();
  var _selectedFruits = <bool>[true, false];

  @override
  void initState() {
    cvstCtrl = ConversationController(this.widget.conversation);
    super.initState();
    cvstCtrl.initState();
    String defaultUserRole = cvstCtrl.conversationInfo.speakers[1];
    cvstCtrl.setUserRole(defaultUserRole);
    userRole.value = defaultUserRole;
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
          title: Row(
            children: [
              const Text('对话'),
              const SizedBox(width: 30),
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedFruits.length; i++) {
                      _selectedFruits[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedFruits,
                children: <Widget>[
                  Text('学习模式'),
                  Text('对话模式')
                ],
              )
            ],
          ),
          toolbarHeight: kToolbarHeight * 1.5,
        ),
        body: _selectedFruits[0] ?
        ConversationInheried(
          conversationControler: cvstCtrl,
          captionValueNotifier: captionOptionValue,
          userRoleNotifier: userRole,
          currentStateNotifier: currentStateNotifier,
          activeIndexNotifier: activeIndexNotifier,
          child: LearningPage(cvstCtrl: cvstCtrl) ):

        ConversationInheried(
          conversationControler: cvstCtrl,
          captionValueNotifier: captionOptionValue,
          userRoleNotifier: userRole,
          currentStateNotifier: currentStateNotifier,
          activeIndexNotifier: activeIndexNotifier,
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                    key: _scrollViewKey,
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Text(
                          cvstCtrl.conversation.title,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            // Text(
                            //   "Author: Unknown",
                            //   style: TextStyle(color: Colors.grey),
                            // ),
                            Text("Words: 180", style: TextStyle(color: Colors.grey)),
                            Text("Time: 1m30s", style: TextStyle(color: Colors.grey))
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                        SizedBox(height: 10,),
                        ContentViewInheried(scrollController: _scrollController, relative_element_key: _scrollViewKey,
                            child:
                             Column(children: cvstCtrl.conversationInfo.sentences.asMap().entries.map((e) {
                                return SentenceSection(sentenceInfo: e.value, index: e.key ,
                                    activeIndexNotifier: activeIndexNotifier);
                              }).toList(),
                            )
                        ),
                        SizedBox(height: 200,) // TODO Scroll时，防止底部无内容时，被拉扯。 产生视觉BUG。
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
