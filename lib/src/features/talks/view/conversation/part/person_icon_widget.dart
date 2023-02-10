
import 'package:flutter/material.dart';

class PersonIconWidget extends StatelessWidget {
  String speaker;
  PersonIconWidget({required this.speaker, super.key});
  final Map<String, String> userIconMapping = {
    "A": "assets/images/artists/woman.jpeg",
    "B": "assets/images/artists/joe.jpg",
    "Lily": "assets/images/artists/woman.jpeg",
    "Tom": "assets/images/artists/joe.jpg"
  };
  @override
  Widget build(BuildContext context) {
    String imgUrl = userIconMapping[speaker]?? "assets/images/artists/joe.jpg";
    return Container(
      child: CircleAvatar(backgroundImage: AssetImage(imgUrl)),
      height: 40,
      width: 40,
    );
  }
}
