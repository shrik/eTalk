import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:async/async.dart';



class TestCancelabelOperationPage extends StatefulWidget {
  const TestCancelabelOperationPage({Key? key}) : super(key: key);

  @override
  State<TestCancelabelOperationPage> createState() => _TestCancelabelOperationPageState();
}

class _TestCancelabelOperationPageState extends State<TestCancelabelOperationPage> {
  String data = "";
  late CancelableOperation op;
  late Future f;
  bool _terminated = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("test cancelable"),),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            InkWell(
              child: Text("Start"),
              onTap: () async {
                _terminated = false;
                setState(() {
                  data = "start";
                });
                f = Future(() async {
                  while(!_terminated){
                    await Future.delayed(Duration(milliseconds: 50));
                  }
                });
                await f;
                setState(() {
                  data = "terminated";
                });
              },
            ),
            SizedBox(height: 30,),
            InkWell(
              child: Text("cancel"),
              onTap: () async {
                _terminated = true;
              },
            ),
            SizedBox(height: 30,),
            Text(data)
          ],
        ),
      ),
    );
  }
}
