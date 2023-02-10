import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/classes/classes.dart';
import './lesson_card.dart';

import '../../../shared/providers/artists.dart';
import 'not_logged.dart';

class MyFavourite extends StatelessWidget {
  const MyFavourite({required this.lessons, super.key});
  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    // final artistsProvider = ArtistsProvider();
    // final artists = artistsProvider.artists;
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        primary: false,
        appBar: AppBar(
          title: const Text('收藏夹'),
          toolbarHeight: kToolbarHeight * 2,
        ),
        body: lessons.isEmpty ? Container(
          child: Text("你的收藏列表是空的，去资源区看看吧！"),
          alignment: Alignment.center,
        ) : GridView.builder(
          padding: const EdgeInsets.all(15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: max(1, (constraints.maxWidth ~/ 400).toInt()),
            childAspectRatio: 2.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return GestureDetector(
              child: LessonCard(
                lesson: lesson,
              ),
              onTap: () {
                GoRouter.of(context).push('/lessons/${lesson.id}');
              },
            );
          },
        ),
      );
    });
  }
}
