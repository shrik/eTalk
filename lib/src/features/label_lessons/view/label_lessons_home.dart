import 'package:flutter/material.dart';
import 'package:myartist/src/shared/providers/api_req.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';

class LabelLessonsHome extends StatelessWidget {
  Map data;
  LabelLessonsHome({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    ArtistsProvider artistsProvider = ArtistsProvider();
    final List<Artist> artists = artistsProvider.artists;
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
                  builder: (context, constrains) => TabBarView(children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: allLessons.map((e) =>
                                Padding(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: buildTile(context, e),)
                            )
                                .toList(),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    )] +
                    labels.map((label) =>
                           SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: label.lessons
                                      .map((e) =>
                                        Padding(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          child: buildTile(context, e),)
                                      )
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          )
                  ).toList()
                  ),
                )));
      },
    );
  }

  final double cardWidth = 100;
  Widget buildTile(BuildContext context, Lesson lesson) {
    return SizedBox(
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
    );
  }
}
