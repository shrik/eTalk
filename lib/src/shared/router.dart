import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myartist/src/features/lessons/lesson_detail.dart';
import 'package:myartist/src/features/my/login_page.dart';
import 'package:myartist/src/features/my/my_home.dart';
import 'package:myartist/src/features/my/register_page.dart';
import 'package:myartist/src/shared/providers/auth_provider.dart';
import 'package:myartist/src/shared/providers/conversations.dart';
import 'package:myartist/src/shared/providers/lessons.dart';
import 'package:provider/provider.dart';

import '../features/lessons/lesson_detail.dart';
import '../features/my_favourite/my_favourite.dart';
import '../features/my_favourite/view/not_logged.dart';
import '../features/talks/talks.dart';
import '../features/home/home.dart';
import '../features/label_lessons/playlists.dart';
import '../features/label_lessons/view/view.dart';
import 'classes/classes.dart';
import 'providers/artists.dart';
import 'providers/playlists.dart';
import 'providers/providers.dart';
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
    route: '/label_lessons',
  ),
  NavigationDestination(
    label: '收藏',
    icon: Icon(Icons.people), // Modify this line
    route: '/my_favourite',
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
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: _pageKey,
        child: LoginPage()
      ),
    ),
    GoRoute(path: "/register",
    pageBuilder: (context, state) => MaterialPage<void>(
      key: _pageKey,
      child: RegisterPage()
    )),

    // PlaylistHomeScreen
    GoRoute(
      path: '/label_lessons',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 1,
          child: FutureBuilder(
              future: LabelLessonsProvider.homeLabels(),
          builder: (context, AsyncSnapshot<Map> snapshot){
            if(snapshot.hasData){
              return LabelLessonsHome(data: snapshot.data!);
            }else if(snapshot.hasError){
              print(snapshot.stackTrace!);
              throw snapshot.error!;
            }else{
              return Text("Loading");
            }
          }),
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
      path: '/my_favourite',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 2,
          child: Builder(
            builder: (context) {
              AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
              if(auth.loggedInStatus == Status.LoggedIn){
                return FutureBuilder(
                    future: LessonProvider.getMyFavouriteLessons(user: auth.getUser()),
                    builder: (context, AsyncSnapshot<List<Lesson>> snapshot){
                      if (snapshot.hasData) {

                        return MyFavourite(lessons: snapshot.data!);
                      } else if (snapshot.hasError) {
                        print(snapshot.stackTrace!);
                        throw snapshot.error!;
                      } else {
                        return Text("Loading");
                      }
                    }
                );
              }else{
                return  NotLogged();
              }
              },
          )
        ),
      ),
    ),
    GoRoute(
      path: "/my",
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 3,
          child: MyHome(),
        ),
      ),
    ),
    GoRoute(path: "/conversations",
      pageBuilder: (context, state) => MaterialPage<void>(
        child: Text("")
      ),
      routes:[
        GoRoute(
            path: ':conversation_id',
            pageBuilder: (context, state) =>
                MaterialPage<void>(child: FutureBuilder(
                    future: ConversationProvider.getConversation(state.params["conversation_id"]!),
                    builder: (context, AsyncSnapshot<Conversation> snapshot){
                      if (snapshot.hasData) {
                        return ConversationScreen(conversation: snapshot.data!);
                      } else if (snapshot.hasError) {
                        print(snapshot.stackTrace!);
                        throw snapshot.error!;
                      } else {
                        return Text("Loading");
                      }
                    }
                ))),
      ]
    ),
    GoRoute(
      path: '/lessons',
      pageBuilder: (context, state) => MaterialPage<void>(
        child: Text("")
      ),
      routes: [
        GoRoute(path: ":lesson_id",
            pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: FutureBuilder(
                  future: LessonProvider.getLesson(state.params["lesson_id"]!),
                  builder: (context, AsyncSnapshot<Lesson> snapshot) {
                    if (snapshot.hasData) {
                      return LessonDetail(lesson: snapshot.data!);
                    } else if (snapshot.hasError) {
                      print(snapshot.stackTrace!);
                      throw snapshot.error!;
                    } else {
                      return Text("Loading");
                    }
                  },
                )
            ),
          routes:[

          ]
        ),

                // MaterialPage<void>(child: const ConversationScreen())),
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
