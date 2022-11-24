import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myartist/src/shared/extensions.dart';

class CourseDetail extends StatelessWidget {
  const CourseDetail({super.key});
  @override
  Widget build(BuildContext context) {
    var courseRow = GestureDetector(
      onTap: () {GoRouter.of(context).push("/talks/buyingtextbook/01");},
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
              Text("First Lesson"),
              Text("Some descriptions here")
            ],
          )),
          Icon(Icons.navigate_next)
        ],
      )
    ) ;
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          primary: false,
          appBar: AppBar(
            title: const Text('TODO'),
            toolbarHeight: kToolbarHeight * 2,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              children: [
                  Row(
                    children: [
                      Image.asset("assets/images/albums/artist1-album2.jpg", width: 100),
                      SizedBox(width: 20,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Buying Text Book", style: TextStyle(fontSize: 20),),
                          SizedBox(height: 10,),
                          Text("包含两接课程： 1.包含两接课程含两接课程含两接课程含两接课程含两接课程含两接课程含两接课程",
                              maxLines: 3, softWrap:true,
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 10,),
                          Text("中级  50234人正在学习", style: TextStyle(fontSize: 14, color: Colors.grey))
                        ],
                      ))
                    ],
                  ),
                SizedBox(height: 40,),
                Align(child: Text("课程列表"), alignment: Alignment.centerLeft,),
                SizedBox(height: 20,),
                courseRow,
                SizedBox(height: 20,),
                courseRow,
                SizedBox(height: 20,),
                courseRow,
                SizedBox(height: 20,),
                courseRow,
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
