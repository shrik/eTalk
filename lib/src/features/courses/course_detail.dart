import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/classes/classes.dart';

class CourseDetail extends StatelessWidget {
  final Lesson lesson;
  const CourseDetail({super.key, required this.lesson});
  @override
  Widget build(BuildContext context) {
    final List<Conversation> conversations = lesson.conversations;
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          primary: false,
          appBar: AppBar(
            title: const Text('课程详情'),
            toolbarHeight: kToolbarHeight * 2,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              children: [
                  Row(
                    children: [
                      Image.network(lesson.coverUrl(), width: 100),
                      SizedBox(width: 20,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lesson.name, style: TextStyle(fontSize: 20),),
                          SizedBox(height: 10,),
                          Text(lesson.description,
                              maxLines: 3, softWrap:true,
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 10,),
                          // Text("中级  50234人正在学习", style: TextStyle(fontSize: 14, color: Colors.grey))
                          Text("中级", style: TextStyle(fontSize: 14, color: Colors.grey))
                        ],
                      ))
                    ],
                  ),
                SizedBox(height: 40,),
                Align(child: Text("课程列表"), alignment: Alignment.centerLeft,),
                Column(children: conversations.map((e) => Column(children: [
                        SizedBox(height: 20,),
                        InkWell(
                            onTap: () {GoRouter.of(context).push("/conversations/" + e.id.toString());},
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(backgroundImage: AssetImage("assets/images/albums/artist1-album2.jpg"),),
                                ),
                                SizedBox(width: 20),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.title),
                                    Text(e.description)
                                  ],
                                )),
                                Icon(Icons.navigate_next)
                              ],
                            )
                        )
                        ],)).toList(),),
              ],
            ),
          ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 20,),
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 5, horizontal: 50))
                ),
                onPressed: () { },
                child: Text('开始对话'),
              ),
              Icon(Icons.star_border),
            ],
          ),
        )


      );
    });
  }
}
