import 'package:flutter/material.dart';

class TestListPage extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   return ListView.builder(
  //     itemCount: 25,
  //     itemBuilder: (BuildContext context, int index) {
  //     return SizedBox(height: 40, width: 300,
  //     child: Text("List item ${index}"),);
  //   },
  //   );
  // }
  final ScrollController controller = ScrollController();
  final GlobalKey _scrollListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var numbers = <int>[
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      0
    ];
    return  Scaffold(
      appBar: AppBar(
        title: Text("Test List View"),
      ),
      body: SingleChildScrollView(
        key: _scrollListKey,
        controller: controller,
        child: Column(
          children: numbers
              .map((e) {
            var childKey = GlobalKey();
            return InkWell(
              key: childKey,
              child: SizedBox(
                width: 300,
                height: 60,
                child: Text("List item ${e.toString()}"),
              ),
              onTap: (){
                RenderBox renderBox = childKey.currentContext!.findRenderObject() as RenderBox;
                final Offset offset = renderBox.localToGlobal(Offset.zero,
                    ancestor: _scrollListKey.currentContext!.findRenderObject() as RenderBox);
                // final Offset offset = renderBox.localToGlobal(Offset.zero);
                print("${offset}  and position: ${controller.offset}" );
                controller.animateTo(controller.offset + offset.dy, duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
            );
          })
              .toList(),
        ),
      ),
    );
  }
}
