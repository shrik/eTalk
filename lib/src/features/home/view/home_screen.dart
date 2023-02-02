import 'package:flutter/material.dart';
import 'package:myartist/src/shared/providers/lessons.dart';

import '../../../shared/classes/classes.dart';
import 'view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Lesson>>? lessons;

  @override
  void initState() {
    super.initState();
    lessons = LessonProvider.getEasyLearningLessons();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Add conditional mobile layout
          return  Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    SizedBox(
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/albums/artist1-album2.jpg"),
                      ),
                      width: 25,
                      height: 25,
                    ),
                    SizedBox(width: 5),
                    Text("Learn to talk")
                  ])),
              body: LayoutBuilder(
                builder: (context, constraints) =>
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const HomeHighlight(),
                          FutureBuilder(
                            future: lessons,
                            builder: (context, AsyncSnapshot<List<Lesson>> snapshot) {
                              if(snapshot.hasData){
                                return HomeContent(lessons: snapshot.data!,
                                    constraints: constraints);
                              }else if(snapshot.hasError){
                                print(snapshot.stackTrace!);
                                throw snapshot.error!;
                              } else{
                                return Text("Loading");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          );
        }
    );
  }
}
