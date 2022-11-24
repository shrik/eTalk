import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/views/views.dart';

class HomeHighlight extends StatelessWidget {
  const HomeHighlight({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), // Modify this line
            child:  SizedBox(
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/news/concert.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ),
        ),
      ],
    );
  }
}
