import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myartist/src/features/courses/course_detail.dart';
import 'package:myartist/src/features/my/my_home.dart';

import '../features/artists/artists.dart';
import '../features/talks/talks.dart';
import '../features/home/home.dart';
import '../features/playlists/playlists.dart';
import '../features/playlists/view/view.dart';
import 'providers/artists.dart';
import 'providers/playlists.dart';
import 'views/views.dart';

const _pageKey = ValueKey('_pageKey');
const _scaffoldKey = ValueKey('_scaffoldKey');

final artistsProvider = ArtistsProvider();
final playlistsProvider = PlaylistsProvider();

const List<NavigationDestination> destinations = [
  NavigationDestination(
    label: '首页',
    icon: Icon(Icons.home), // Modify this line
    route: '/',
  ),
  NavigationDestination(
    label: '资源',
    icon: Icon(Icons.playlist_add_check), // Modify this line
    route: '/playlists',
  ),
  NavigationDestination(
    label: '收藏',
    icon: Icon(Icons.people), // Modify this line
    route: '/artists',
  ),
  NavigationDestination(
    label: '我的',
    icon: Icon(Icons.chat_bubble_outline), // Modify this line
    route: '/my',
  ),
];

class NavigationDestination {
  const NavigationDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

final appRouter = GoRouter(
  routes: [
    // HomeScreen
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 0,
          child: HomeScreen(),
        ),
      ),
    ),

    // PlaylistHomeScreen
    GoRoute(
      path: '/playlists',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 1,
          child: PlaylistHomeScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: ':pid',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: RootLayout(
              key: _scaffoldKey,
              currentIndex: 1,
              child: PlaylistScreen(
                playlist: playlistsProvider.getPlaylist(state.params['pid']!)!,
              ),
            ),
          ),
        ),
      ],
    ),

    // ArtistHomeScreen
    GoRoute(
      path: '/artists',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 2,
          child: ArtistsScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: ':aid',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: RootLayout(
              key: _scaffoldKey,
              currentIndex: 2,
              child: ArtistScreen(
                artist: artistsProvider.getArtist(state.params['aid']!)!,
              ),
            ),
          ),
          // builder: (context, state) => ArtistScreen(
          //   id: state.params['aid']!,
          // ),
        ),
      ],
    ),
    GoRoute(path: "/my",
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 3,
          child: MyHome(),
        ),
      ),
    ),
    GoRoute(
        path: '/talks/buyingtextbook',
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey, child: const CourseDetail()),
        routes: [
          GoRoute(
              path: '01',
              pageBuilder: (context, state) =>
                  MaterialPage<void>(child: const ConversationScreen())),
        ],
        ),

    // for (final route in destinations.skip(3))
    //   GoRoute(
    //     path: route.route,
    //     pageBuilder: (context, state) => MaterialPage<void>(
    //       key: _pageKey,
    //       child: RootLayout(
    //         key: _scaffoldKey,
    //         currentIndex: destinations.indexOf(route),
    //         child: const SizedBox(),
    //       ),
    //     ),
    //   ),
  ],
);
