
import 'package:flutter/material.dart';

import '../helpers.dart';

class PersonIconWidget extends StatelessWidget {
  String speaker;
  PersonIconWidget({required this.speaker, super.key});
  @override
  Widget build(BuildContext context) {
    String imgUrl = getUserAvatarUrl(speaker);
    return Container(
      child: CircleAvatar(backgroundImage: AssetImage(imgUrl)),
      height: 40,
      width: 40,
    );
  }
}
