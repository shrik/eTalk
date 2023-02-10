import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myartist/src/features/label_lessons/view/lesson_list_view.dart';

import '../../../shared/classes/classes.dart';
import 'package:quiver/iterables.dart';

class LabelLessonsHome extends StatelessWidget {
  Map data;
  LabelLessonsHome({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final List<Label> labels = this.data["labels"] as List<Label>;
    final List<Lesson> allLessons = this.data["all_lessons"] as List<Lesson>;
    return LayoutBuilder(
      builder: (context, constraints) {
        return DefaultTabController(
            length: labels.length + 1,
            child: Scaffold(
                primary: false,
                appBar: AppBar(
                    title: const Text('所有对话'),
                    toolbarHeight: kToolbarHeight * 1.3,
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: [Tab(text: "All")] +
                          labels.map((e) => Tab(text: e.name)).toList(),
                    )),
                body: LayoutBuilder(
                  builder: (context, constrains) => TabBarView(
                      children: <Widget>[
                        LessonListView(labelId: 0)
                          ] +
                          labels.map((label) => LessonListView(labelId: label.id)).toList()),
                )));
      },
    );
  }

  final double cardWidth = 100;
  Widget buildLessonCard(BuildContext context, Lesson lesson) {
    return InkWell(child: SizedBox(
      width: cardWidth,
      // height: 250,
      child: Card(
        child: Column(
          children: [
            Image.network(lesson.coverUrl(), width: cardWidth),
            SizedBox(
              width: cardWidth,
              child: Text(
                lesson.name,
                maxLines: 2,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: Text(
                "初级",
                maxLines: 1,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),

        // media: AssetImage(artist.image.image);
      ),
    ),
    onTap: (){
      GoRouter.of(context).push("/lessons/" + lesson.id.toString());
    },);
  }
}
