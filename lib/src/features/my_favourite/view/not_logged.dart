import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myartist/src/features/my/login_page.dart';

import '../../home/home.dart';

class NotLogged extends StatelessWidget{
  NotLogged({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("收藏夹"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("请登录后使用收藏夹功能"),
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 5, horizontal: 50))
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  })
                );
                GoRouter.of(context).refresh();
              },
              child: Text('登录'),
            ),
            SizedBox(height: 20,),
            HomeHighlight()
          ],
        ),
      )
    );
  }

}