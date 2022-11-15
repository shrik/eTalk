import 'package:flutter/material.dart';
import '../../../../lib/listener_interface.dart';
import '../../conversation_controller.dart';
import 'part/toolbox_toggle_button.dart';
import 'views/content_view.dart';


class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> with ListenerInterface {
  ConversationController cvstCtrl = ConversationController();
  bool isRunning = false;
  bool isFinnished = false;
  String userRole = 'Tom';
  bool hasCaption = false;

  void setUserRole(String name){
    print('set user role: ${name}');
    setState(() {
      userRole = name;
      cvstCtrl.setUserRole(name);
      cvstCtrl.reset();
      isRunning = false;
      isFinnished = false;
    });
  }

  @override
  void initState(){
    super.initState();
    cvstCtrl.initState();
    cvstCtrl.setUserRole('Tom');
    cvstCtrl.addListener(this);
    print("&&&***&&& init state");
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void update(Object informer){
    setState(() {
      isFinnished = cvstCtrl.isFinished;
      if(isFinnished == true){
        isRunning = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainCtlBtn;
    if(isRunning){
      mainCtlBtn = IconButton(
          icon: Icon(Icons.pause_circle_outline, size: 40),
          onPressed: () async {
            bool success = true;
            await cvstCtrl.pause().onError((error, stackTrace) => success=false);
            if(success){
              setState(() {
                isRunning = false;
              });
            }
          }
      );
    }else{
      mainCtlBtn = IconButton(
          icon: const Icon(Icons.play_circle_outline_sharp, size: 40),
          onPressed: () async {
            var success = true;
            if(cvstCtrl.isStarted){
              await cvstCtrl.resume().onError((error, stackTrace) => success = false);
            }else{
              await cvstCtrl.start().onError((error, stackTrace) => success = false);
            }
            if(success){setState(() {isRunning = true;});}
          }
      );
    }
    if(isFinnished){
      mainCtlBtn = IconButton(
          icon: const Icon(Icons.replay, size: 40),
          onPressed: ()  async {
            bool success = true;
            cvstCtrl.reset();
            await cvstCtrl.start();
            if(success){
              setState(() {
                isRunning = true;
              });
            }
          }
      );
    }
    Widget captionButton;
    if(hasCaption){
      captionButton = IconButton(onPressed: (){
        setState((){hasCaption = false;});
      }, icon: Icon(Icons.abc_rounded));

    }else{
      captionButton = IconButton(onPressed: (){
        setState((){hasCaption = true;});
      }, icon: Icon(Icons.strikethrough_s));
    }
    print("has caption result is ${hasCaption}");
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          primary: false,
          appBar: AppBar(
            title: const Text('Talking'),
            toolbarHeight: kToolbarHeight * 2,
          ),
          body: Column(
              children: [
                Text("Conversation | Learning | AI"),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ContentView(
                          conversationController: this.cvstCtrl,
                          userRole: userRole,
                          hasCaption: hasCaption,
                        ))),
                Container(
                  height: 100,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(onPressed: () async {
                        if(isRunning){
                          return;
                        }
                        String? role = await showDialog<String>(
                            context: context,
                            builder: (context){
                              return SimpleDialog(
                                title: const Text('Select User Role'),
                                children: cvstCtrl.Speakers.map((element){
                                    return SimpleDialogOption(
                                      onPressed: () { Navigator.pop(context, element);},
                                      child: Text(element),
                                    );
                                }).toList(),
                              );
                            }
                        );
                        if(role != null && role != userRole){
                          setUserRole(role);
                        }
                      },
                          icon: Icon(Icons.person_outline_rounded,
                          color: userRole == 'Tom' ? Colors.black : Colors.pink)),
                      captionButton,
                      mainCtlBtn,
                      IconButton(icon:
                        const Icon(Icons.water_rounded, size: 60,),
                             onPressed: (){},),
                      IconButton(icon: const Icon(Icons.skip_next_outlined), onPressed: (){},),
                    ],
                  ),
                )
              ],
            ),
      );
    });
  }
}
