import 'package:flutter/material.dart';
import 'package:myartist/src/features/talks/conversation_controller.dart';
import 'package:myartist/src/features/talks/talks.dart';

import '../../../lib/caption.dart';

class MainCtlButton extends StatelessWidget{
  final ConversationStatus cStatus;
  const MainCtlButton({required this.cStatus, super.key});
  @override
  Widget build(BuildContext context) {
    ConversationController cvstCtrl = ConversationInheried.of(context).conversationControler;
    final double mainCtlBtnSize = 50;
    print("current status is ${cStatus.toString()}");
    if (cStatus == ConversationStatus.Finished) {
      return IconButton(
          icon: Icon(Icons.replay, size: mainCtlBtnSize),
          onPressed: () async {
            await cvstCtrl.reset();
            await cvstCtrl.start();
          });
    }
    if (cStatus == ConversationStatus.Running) {
      return IconButton(
          icon: Icon(Icons.pause_circle_outline, size: mainCtlBtnSize),
          onPressed: () async {
            await cvstCtrl.pause();
          });
    } else {
      return IconButton(
          icon: Icon(
            Icons.play_circle_outline_sharp,
            size: mainCtlBtnSize,
            color: Colors.black,
          ),
          onPressed: () async {
            print("cvstCtrl is started ${cvstCtrl.isStarted}");
            if (cvstCtrl.isStarted) {
              await cvstCtrl.resume();
            } else {
              await cvstCtrl.start();
            }
          });
    }
  }
}

class UserRoleCtlButton extends StatelessWidget{
  final ConversationStatus cStatus;
  final String userRole;
  const UserRoleCtlButton({required this.cStatus, required this.userRole, super.key});

  @override
  Widget build(BuildContext context) {
    ConversationController cvstCtrl = ConversationInheried.of(context).conversationControler;
    final Widget lilyIcon = Container(
        child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/artists/woman.jpeg")),
        height: 30,
        width: 30);
    final Widget tomIcon = Container(
        child: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/artists/joe.jpg")),
        height:  30,
        width: 30);
    ValueNotifier<String> userRoleNotifier = ConversationInheried.of(context).userRoleNotifier;

    return IconButton(
      onPressed: () async {
        if (cStatus == ConversationStatus.Running) {
          return;
        }
        String? role = await showDialog<String>(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Select User Role'),
                children: cvstCtrl.Speakers.map((element) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, element);
                    },
                    child: Text(element),
                  );
                }).toList(),
              );
            });
        if (role != null && role != userRole) {
          userRoleNotifier.value = role;
        }
      },
      icon: userRole == 'Tom' ? tomIcon : lilyIcon,
    );
  }

}

class CaptionCtrlButton extends StatelessWidget{

  final CaptionEnum captionOptionVal;
  const CaptionCtrlButton({required this.captionOptionVal, super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier captionValueNotifier = ConversationInheried.of(context).captionValueNotifier;
    return InkWell(
      child: DecoratedBox(
        child: Padding(
          child: Text(
            captionOptions[captionOptionVal]!,
            style:
            TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          padding: EdgeInsets.all(3),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
      ),
      onTap: () async {
        CaptionEnum? captionOptionSelected = await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                  title: const Text("选择如何提示"),
                  children: captionOptions.keys.map((e) {
                    return SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, e);
                      },
                      child: Text(captionOptions[e]!),
                    );
                  }).toList());
            });
        if (captionOptionSelected != null && captionOptionVal != captionOptionSelected) {
          captionValueNotifier.value = captionOptionSelected;
        }
      },
    );
  }
}

class StatusDisplayWidget extends StatelessWidget{
  final ConversationStatus cStatus;
  final int activeIndex;
  const StatusDisplayWidget({required this.cStatus, required this.activeIndex, super.key});
  @override
  Widget build(BuildContext context) {
    ConversationController cvstCtrl = ConversationInheried.of(context).conversationControler;
    if (cStatus == ConversationStatus.NotStarted) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: Colors.grey,
          ),
          Text(
            "未开始",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      );
    } else if (cStatus == ConversationStatus.Running) {
      if (cvstCtrl.isRecording()) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.mic_rounded,
              size: 10,
              color: Colors.cyan,
            ),
            Text(
              "录音中",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        );
      } else {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.volume_down,
              size: 10,
              color: Colors.cyan,
            ),
            Text(
              "播放中",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        );
      }
    } else if (cStatus == ConversationStatus.Paused) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: Colors.grey,
          ),
          Text(
            "已暂停",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      );
    } else if (cStatus == ConversationStatus.Finished) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: Colors.grey,
          ),
          Text(
            "已完成",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      );
    } else {
      return Text("Error Status");
    }
  }

}

class ContorllerView extends StatefulWidget {
  const ContorllerView({Key? key}) : super(key: key);

  @override
  State<ContorllerView> createState() => _ContorllerViewState();
}

class _ContorllerViewState extends State<ContorllerView> {
  @override
  Widget build(BuildContext context) {
    ConversationController cvstCtrl = ConversationInheried.of(context).conversationControler;
    // ConversationInheried.of(context).currentStateNotifier


    return  Container(
      height: 100,
      width: double.maxFinite,
      alignment: Alignment.center,
      color: Color(0xFFF0F5F7),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ValueListenableBuilder(
              valueListenable: ConversationInheried.of(context).currentStateNotifier,
              builder: (context, ConversationStatus st, child){
                return ValueListenableBuilder(
                  valueListenable: ConversationInheried.of(context).userRoleNotifier,
                  builder: (context, String userRole, chile){
                    return UserRoleCtlButton(cStatus: st, userRole: userRole);
                  },
                );
              }),
          ValueListenableBuilder(valueListenable: ConversationInheried.of(context).captionValueNotifier,
              builder: (context,CaptionEnum captionOptionVal, child){
                return CaptionCtrlButton(captionOptionVal: captionOptionVal);
              }),
          ValueListenableBuilder(
            valueListenable: ConversationInheried.of(context).currentStateNotifier,
            builder: (context, ConversationStatus st, child){
                return MainCtlButton(cStatus: st);
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_next_outlined),
            onPressed: () async {
              if(cvstCtrl.cStatus != ConversationStatus.Running){
                //pass
              }else{
                await cvstCtrl.skipCurrent();
              }
            },
          ),
          ValueListenableBuilder(valueListenable: ConversationInheried.of(context).currentStateNotifier,
              builder: (context, ConversationStatus st, child){
                return ValueListenableBuilder(
                  valueListenable: ConversationInheried.of(context).activeIndexNotifier,
                  builder: (context, int activeIndex, child){
                    return StatusDisplayWidget(cStatus: st, activeIndex: activeIndex);
                  },
                );
              })
        ],
      ),
    );

  }
}
