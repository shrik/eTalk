import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/classes/classes.dart';


class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.lessons,
    required this.constraints,
  });

  final List<Lesson> lessons;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child:Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children:
                    [Text("轻松学", textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                      Expanded(child: SizedBox(width: 100)),
                      Text("更多", textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14, color: Colors.grey))
                    ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lessons.sublist(0, 3).map((e) => buildCard(context, e)).toList(),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lessons.sublist(3,6).map((e) => buildCard(context, e)).toList(),
                ),
                SizedBox(width: 100, height: 10,),
                Row(
                  children:
                  [Text("我的课程", textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                    Expanded(child: SizedBox(width: 100)),
                    Text("更多", textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14, color: Colors.grey))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: lessons.sublist(0,3).map((e) => buildCard(context, e)).toList(),
                ),
                SizedBox(height: 30,),
                SizedBox(
                  child: Column(children: [
                    Text("We should all start to live before we get too old.",
                      style: TextStyle(color: Colors.grey),),
                    Text("我们应该在变老之前好好活一场。",
                        style: TextStyle(color: Colors.grey)),
                    Row(children: [
                      Text(" --玛丽莲 梦露",
                          style: TextStyle(color: Colors.grey))
                    ], mainAxisAlignment: MainAxisAlignment.end,)
                  ],),
                ),

              ]),
    );
  }
  final double cardWidth = 100;
  Widget buildCard(BuildContext context, Lesson lesson) {
    return SizedBox(
      width: cardWidth,
      // height: 250,
      child: InkWell(
          onTap: () {
            GoRouter.of(context).push("/lessons/" + lesson.id.toString());
          },
          child: Column(
            children: [
              ClipRRect(
                child: Image.network(lesson.coverUrl(), width: cardWidth),
                borderRadius: BorderRadius.circular(8.0),
              ),
              SizedBox(
                width: cardWidth,
                child: Text(lesson.name, maxLines: 2,),
              ),
              SizedBox(
                width: cardWidth,
                child: Text("初级", maxLines: 1,
                  style: TextStyle(color: Colors.grey),),
              ),
            ],
          ),
        ),
    );
  }
}
