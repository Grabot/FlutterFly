import 'dart:ui';

import 'package:flutterfly/constants/route_paths.dart' as routes;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/locator.dart';
import 'package:flutterfly/views/delete_page.dart';
import 'package:flutterfly/views/user_interface/achievement_box/achievement_box.dart';
import 'package:flutterfly/views/user_interface/achievement_close_up/achievement_close_up_box.dart';
import 'package:flutterfly/views/user_interface/are_you_sure_box/are_you_sure_box.dart';
import 'package:flutterfly/views/user_interface/change_avatar_box/change_avatar_box.dart';
import 'package:flutterfly/views/user_interface/game_settings/game_settings_box/game_settings_box.dart';
import 'package:flutterfly/views/user_interface/game_settings/game_settings_buttons/game_settings_buttons.dart';
import 'package:flutterfly/views/user_interface/leader_board/leader_board.dart';
import 'package:flutterfly/views/user_interface/login_screen/login_screen.dart';
import 'package:flutterfly/views/user_interface/profile/profile_box/profile_box.dart';
import 'package:flutterfly/views/user_interface/profile/profile_overview/profile_overview.dart';
import 'package:flutterfly/views/user_interface/score_screen/score_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_strategy/url_strategy.dart';
import 'services/game_settings.dart';
import 'services/navigation_service.dart';
import 'services/settings.dart';
import 'services/socket_services.dart';
import 'services/user_score.dart';
import 'views/butterfly_access_page.dart';
import 'views/delete_account_page.dart';
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
        overlayBuilderMap: const {
          'profileOverview': _profileOverviewBuilder,
          'gameSettingsButton': _gameSettingsButtonBuilder,
          'scoreScreen': _scoreScreenBuilder,
          'leaderBoard': _leaderBoardBuilder,
          'profileBox': _profileBoxBuilder,
          'loginScreen': _loginScreenBuilder,
          'changeAvatar': _changeAvatarBoxBuilder,
          'gameSettingsBox': _gameSettingsBoxBuilder,
          'areYouSureBox': _areYouSureBoxBuilder,
          'achievementBox': _achievementBoxBuilder,
          'achievementCloseUpBox': _achievementCloseUpBoxBuilder,
        },
        initialActiveOverlays: const [
          'profileOverview',
          'gameSettingsButton',
          'scoreScreen',
          'profileBox',
          'loginScreen',
          'changeAvatar',
          'gameSettingsBox',
          'areYouSureBox',
          'leaderBoard',
          'achievementBox',
          'achievementCloseUpBox',
        ],
      )
  );

  Widget butterflyAccess = ButterflyAccess(key: UniqueKey(), game: game);
  Widget passwordReset = PasswordReset(key: UniqueKey(), game: game);
  Widget privacy = PrivacyPage(key: UniqueKey());
  Widget terms = TermsPage(key: UniqueKey());
  Widget delete = DeletePage(key: UniqueKey());
  Widget deleteAccount = DeleteAccountPage(key: UniqueKey());

  runApp(
      OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
            routes.ButterflyAccessRoute: (context) => butterflyAccess,
            routes.PasswordResetRoute: (context) => passwordReset,
            routes.PrivacyRoute: (context) => privacy,
            routes.TermsRoute: (context) => terms,
            routes.DeleteRoute: (context) => delete,
            routes.DeleteAccountRoute: (context) => deleteAccount,
          },
          scrollBehavior: MyCustomScrollBehavior(),
          onGenerateRoute: (settings) {
            if (settings.name != null && settings.name!.startsWith(routes.ButterflyAccessRoute)) {
              return MaterialPageRoute(
                  builder: (context) {
                    return butterflyAccess;
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
            } else if (settings.name!.startsWith(routes.DeleteRoute)) {
              return MaterialPageRoute(
                  builder: (context) {
                    return delete;
                  }
              );
            } else if (settings.name!.startsWith(routes.DeleteAccountRoute)) {
              return MaterialPageRoute(
                  builder: (context) {
                    return deleteAccount;
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

Widget _scoreScreenBuilder(BuildContext buildContext, FlutterFly game) {
  return ScoreScreen(key: UniqueKey(), game: game);
}

Widget _leaderBoardBuilder(BuildContext buildContext, FlutterFly game) {
  return LeaderBoard(key: UniqueKey(), game: game);
}

Widget _profileBoxBuilder(BuildContext buildContext, FlutterFly game) {
  return ProfileBox(key: UniqueKey(), game: game);
}

Widget _profileOverviewBuilder(BuildContext buildContext, FlutterFly game) {
  return ProfileOverview(key: UniqueKey(), game: game);
}

Widget _loginScreenBuilder(BuildContext buildContext, FlutterFly game) {
  return LoginScreen(key: UniqueKey(), game: game);
}

Widget _changeAvatarBoxBuilder(BuildContext buildContext, FlutterFly game) {
  return ChangeAvatarBox(key: UniqueKey(), game: game);
}

Widget _gameSettingsButtonBuilder(BuildContext buildContext, FlutterFly game) {
  return GameSettingsButtons(key: UniqueKey(), game: game);
}

Widget _gameSettingsBoxBuilder(BuildContext buildContext, FlutterFly game) {
  return GameSettingsBox(key: UniqueKey(), game: game);
}

Widget _areYouSureBoxBuilder(BuildContext buildContext, FlutterFly game) {
  return AreYouSureBox(key: UniqueKey(), game: game);
}

Widget _achievementBoxBuilder(BuildContext buildContext, FlutterFly game) {
  return AchievementBox(key: UniqueKey(), game: game);
}

Widget _achievementCloseUpBoxBuilder(BuildContext buildContext, FlutterFly game) {
  return AchievementCloseUpBox(key: UniqueKey(), game: game);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
