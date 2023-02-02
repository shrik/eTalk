import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myartist/src/shared/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'playback/bloc/bloc.dart';
import 'providers/theme.dart';
import 'router.dart';
import 'views/views.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final settings = ValueNotifier(ThemeSettings(
    sourceColor: Color(0xff00cbe6), // Replace this color
    themeMode: ThemeMode.system,
  ));
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaybackBloc>(
      create: (context) => PlaybackBloc(),
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) => ThemeProvider(
            lightDynamic: lightDynamic,
            darkDynamic: darkDynamic,
            settings: settings,
            child: NotificationListener<ThemeSettingChange>(
                onNotification: (notification) {
                  settings.value = notification.settings;
                  return true;
                },
                child: ValueListenableBuilder<ThemeSettings>(
                    valueListenable: settings,
                    builder: (context, value, _) {
                      // Create theme instance
                      final theme = ThemeProvider.of(context);
                      return MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        title: 'Flutter Demo',
                        theme: theme.light(settings.value.sourceColor),
                        darkTheme: theme.dark(settings.value.sourceColor),
                        themeMode: theme.themeMode(),
                        // Add theme mode
                        routeInformationParser:
                            appRouter.routeInformationParser,
                        routeInformationProvider:
                            appRouter.routeInformationProvider,
                        routerDelegate: appRouter.routerDelegate,
                        builder: (context, child) {
                          return FutureBuilder(
                            future: AuthProvider().initialize(),
                            builder: (context,
                                AsyncSnapshot<AuthProvider> authSnapShop) {
                              if (authSnapShop.hasData) {
                                AuthProvider auth = authSnapShop.data!;
                                return ChangeNotifierProvider(
                                    create: (context) => auth, child: child!);
                              } else if (authSnapShop.hasError) {
                                print("======");
                                print(authSnapShop.error!);
                                print(authSnapShop.stackTrace!);
                                print("======");
                                throw authSnapShop.error!;
                              } else {
                                return Text("Loading");
                              }
                            },
                          );
                        },
                      );
                    }))),
      ),
    );
  }
}
