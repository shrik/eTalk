
import 'package:flutter/material.dart';

class PersonIconWidget extends StatelessWidget {
  String speaker;
  PersonIconWidget({required this.speaker, super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String imgUrl = speaker == "Lily"
        ? "assets/images/artists/woman.jpeg"
        : "assets/images/artists/joe.jpg";
    return Container(
      child: CircleAvatar(backgroundImage: AssetImage(imgUrl)),
      height: 40,
      width: 40,
    );
  }
}
