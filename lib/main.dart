import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'class/podcast_group.dart';
import 'class/audiostate.dart';
import 'class/settingstate.dart';
import 'class/download_state.dart';
import 'class/refresh_podcast.dart';
import 'class/subscribe_podcast.dart';
import 'home/home.dart';
import 'intro_slider/app_intro.dart';

final SettingState themeSetting = SettingState();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeSetting.initData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => themeSetting,
        ),
        ChangeNotifierProvider(create: (_) => AudioPlayerNotifier()),
        ChangeNotifierProvider(create: (_) => GroupList()),
        ChangeNotifierProvider(create: (_) => SubscribeWorker()),
        ChangeNotifierProvider(create: (_) => RefreshWorker()),
        ChangeNotifierProvider(
          create: (_) => DownloadState(),
        )
      ],
      child: MyApp(),
    ),
  );
  await FlutterDownloader.initialize();
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingState>(
      builder: (_, setting, __) {
        return MaterialApp(
          themeMode: setting.theme,
          debugShowCheckedModeBanner: false,
          title: 'Tsacdop',
          theme: lightTheme.copyWith(
            accentColor: setting.accentSetColor,
          ),
          darkTheme: ThemeData.dark().copyWith(
            accentColor: setting.accentSetColor,
            primaryColorDark: Colors.grey[800],
            scaffoldBackgroundColor: setting.realDark ? Colors.black87 : null,
            primaryColor: setting.realDark ? Colors.black : null,
            popupMenuTheme: PopupMenuThemeData()
                .copyWith(color: setting.realDark ? Colors.black87 : null),
            appBarTheme: AppBarTheme(elevation: 0),
          ),
          home: setting.showIntro ? SlideIntro(goto: Goto.home) : Home(),
        );
      },
    );
  }
}
