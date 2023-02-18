import 'package:flutter/material.dart';

import '../../../lib/caption.dart';
import '../../../talks.dart';

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
