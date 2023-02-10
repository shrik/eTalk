import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myartist/src/features/my/login_page.dart';
import 'package:myartist/src/features/my/utility/shared_preference.dart';
import 'package:myartist/src/features/my/views/contact_us.dart';
import 'package:myartist/src/shared/classes/classes.dart';
import 'package:myartist/src/shared/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我的"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      if (auth.loggedInStatus == Status.LoggedIn) {
                          User user = auth.getUser();
                          return Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    "assets/images/albums/artist1-album2.jpg"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                user.name,
                                style: TextStyle(fontSize: 18),
                              ),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        child: Text("退出登录"),
                                        onTap: () {
                                          auth.logout();
                                        },
                                      ))),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          );
                      } else {
                        return Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/albums/artist1-album2.jpg"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "未登录",
                              style: TextStyle(fontSize: 18),
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: Text("登录"),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return LoginPage();
                                    })
                                  );
                                },
                              ),
                            )),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        );
                      }
                    },
                  )),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Divider(
                    thickness: 1,
                    height: 10,
                    indent: 15,
                    endIndent: 15,
                  ),
                  InkWell(
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                             child: Text(
                               "我的收藏",
                               style: TextStyle(fontSize: 16),
                             ), onTap: (){
                               GoRouter.of(context).go("/my_favourite");
                            },
                            ),
                          ],
                        )),
                    onTap: () {},
                  ),
                  Divider(
                    thickness: 1,
                    height: 10,
                    indent: 15,
                    endIndent: 15,
                  ),
                  InkWell(
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "设置",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                    onTap: () {},
                  ),
                  Divider(
                    thickness: 1,
                    height: 10,
                    indent: 15,
                    endIndent: 15,
                  ),
                  InkWell(
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.library_books_rounded,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "建议反馈",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                    onTap: () {},
                  ),
                  Divider(
                    thickness: 1,
                    height: 10,
                    indent: 15,
                    endIndent: 15,
                  ),
                  InkWell(
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.perm_contact_cal,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              child: Text(
                                "联系我们",
                                style: TextStyle(fontSize: 16),
                              ),onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context){
                                    return ContactUs();
                                  })
                                );
                            },
                            )
                            ,
                          ],
                        )),
                    onTap: () {},
                  ),
                  Divider(
                    thickness: 1,
                    height: 10,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.green),
                        onPressed: () {},
                        child: Text("退出登录"),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
