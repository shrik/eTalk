import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';

class PlaylistHomeScreen extends StatelessWidget {
  const PlaylistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider playlistProvider = PlaylistsProvider();
    ArtistsProvider artistsProvider = ArtistsProvider();
    List<Playlist> playlists = playlistProvider.playlists;
    final List<Artist> artists = artistsProvider.artists;
    return LayoutBuilder(
      builder: (context, constraints) {
        return DefaultTabController(
            length: 6,
            child: Scaffold(
                primary: false,
                appBar: AppBar(
                    title: const Text('所有对话'),
                    toolbarHeight: kToolbarHeight * 2,
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: "All"),
                        Tab(text: "购物"),
                        Tab(text: "点餐"),
                        Tab(text: "酒店"),
                        Tab(text: "订票"),
                        Tab(text: "问路")
                      ],
                    )),
                body: LayoutBuilder(
                  builder: (context, constrains) => TabBarView(children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: artists
                                .map((e) => buildTile(context, e))
                                .toList(),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [Text("shopping")],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [Text("food")],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [Text("hotel")],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [Text("ticket")],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [Text("traffic")],
                      ),
                    ),
                  ]),
                )));
      },
    );
  }

  final double cardWidth = 100;
  Widget buildTile(BuildContext context, Artist artist) {
    return SizedBox(
      width: cardWidth,
      // height: 250,
      child: Card(
        child: Column(
          children: [
            Image(image: AssetImage(artist.image.image), width: cardWidth),
            SizedBox(
              width: cardWidth,
              child: Text(
                "Some Description Here",
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
