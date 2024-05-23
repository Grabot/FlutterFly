import 'dart:ui';

import 'package:flutterfly/constants/route_paths.dart' as routes;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/locator.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_strategy/url_strategy.dart';
import 'services/game_settings.dart';
import 'services/navigation_service.dart';
import 'services/settings.dart';
import 'services/socket_services.dart';
import 'services/user_score.dart';
import 'views/bird_access_page.dart';
import 'views/password_reset_page.dart';
import 'views/privacy_page.dart';
import 'views/terms_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  setupLocator();

  // initialize the settings and users score singleton
  Settings settings = Settings();
  GameSettings();
  UserScore();
  // We also initialize the socket services singleton, so we can receive leaderboard updates.
  SocketServices socketServices = SocketServices();
  socketServices.setSettings(settings);
  Flame.images.loadAll(<String>[]);

  FocusNode gameFocus = FocusNode();

  final game = FlutterFly(gameFocus);

  Widget gameWidget = Scaffold(
      body: GameWidget(
        focusNode: gameFocus,
        game: game,
        // overlayBuilderMap: const {
          // 'profileOverview': _profileOverviewBuilder,
          // 'gameSettingsButton': _gameSettingsButtonBuilder,
          // 'scoreScreen': _scoreScreenBuilder,
          // 'leaderBoard': _leaderBoardBuilder,
          // 'profileBox': _profileBoxBuilder,
          // 'loginScreen': _loginScreenBuilder,
          // 'changeAvatar': _changeAvatarBoxBuilder,
          // 'gameSettingsBox': _gameSettingsBoxBuilder,
          // 'areYouSureBox': _areYouSureBoxBuilder,
          // 'achievementBox': _achievementBoxBuilder,
          // 'achievementCloseUpBox': _achievementCloseUpBoxBuilder,
        // },
        // initialActiveOverlays: const [
          // 'profileOverview',
          // 'gameSettingsButton',
          // 'scoreScreen',
          // 'profileBox',
          // 'loginScreen',
          // 'changeAvatar',
          // 'gameSettingsBox',
          // 'areYouSureBox',
          // 'leaderBoard',
          // 'achievementBox',
          // 'achievementCloseUpBox',
        // ],
      )
  );

  Widget birdAccess = BirdAccess(key: UniqueKey(), game: game);
  Widget passwordReset = PasswordReset(key: UniqueKey(), game: game);
  Widget privacy = PrivacyPage(key: UniqueKey());
  Widget terms = TermsPage(key: UniqueKey());

  runApp(
      OKToast(
        child: MaterialApp(
          title: "Flutter Fly",
          navigatorKey: locator<NavigationService>().navigatorKey,
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.dark,
            primaryColor: Colors.lightBlue,
            // Define the default font family.
            fontFamily: 'visitor',
          ),
          initialRoute: '/',
          routes: {
            routes.HomeRoute: (context) => gameWidget,
            routes.BirdAccessRoute: (context) => birdAccess,
            routes.PasswordResetRoute: (context) => passwordReset,
            routes.PrivacyRoute: (context) => privacy,
            routes.TermsRoute: (context) => terms,
          },
          scrollBehavior: MyCustomScrollBehavior(),
          onGenerateRoute: (settings) {
            if (settings.name != null && settings.name!.startsWith(routes.BirdAccessRoute)) {
              return MaterialPageRoute(
                  builder: (context) {
                    return birdAccess;
                  }
              );
            } else if (settings.name!.startsWith(routes.PasswordResetRoute)) {
              return MaterialPageRoute(
                  builder: (context) {
                    return passwordReset;
                  }
              );
            } else if (settings.name!.startsWith(routes.PrivacyRoute)) {
              return MaterialPageRoute(
                  builder: (context) {
                    return privacy;
                  }
              );
            } else if (settings.name!.startsWith(routes.TermsRoute)) {
              return MaterialPageRoute(
                  builder: (context) {
                    return terms;
                  }
              );
            } else {
              return MaterialPageRoute(
                  builder: (context) {
                    return gameWidget;
                  }
              );
            }
          },
        ),
      )
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
