import 'package:adaptive_components/adaptive_components.dart';
import 'package:flutter/material.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';
import '../../playlists/view/playlist_songs.dart';
import 'view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final PlaylistsProvider playlistProvider = PlaylistsProvider();
    final List<Playlist> playlists = playlistProvider.playlists;
    final Playlist topSongs = playlistProvider.topSongs;
    final Playlist newReleases = playlistProvider.newReleases;
    final ArtistsProvider artistsProvider = ArtistsProvider();
    final List<Artist> artists = artistsProvider.artists;
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
                          HomeContent(
                            artists: artists,
                            constraints: constraints,
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
