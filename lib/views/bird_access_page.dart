import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterfly/constants/route_paths.dart' as routes;
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/locator.dart';
import 'package:flutterfly/services/navigation_service.dart';
import 'package:flutterfly/services/rest/auth_service_login.dart';
import 'package:flutterfly/util/util.dart';



class BirdAccess extends StatefulWidget {

  final FlutterFly game;

  const BirdAccess({
    super.key,
    required this.game
  });

  @override
  State<BirdAccess> createState() => _BirdAccessState();
}

class _BirdAccessState extends State<BirdAccess> {

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    // String baseUrl = Uri.base.toString();
    // String path = Uri.base.path;
    String? accessToken = Uri.base.queryParameters["access_token"];
    String? refreshToken = Uri.base.queryParameters["refresh_token"];

    // Use the tokens to immediately refresh the access token
    if (accessToken != null && refreshToken != null) {
      AuthServiceLogin authService = AuthServiceLogin();
      authService.getRefresh(accessToken, refreshToken).then((loginResponse) {
        if (loginResponse.getResult()) {
          // We navigate to the home screen and it should be logged in.
          _navigationService.navigateTo(routes.HomeRoute);
        } else {
          showToastMessage("something went wrong with logging in");
          _navigationService.navigateTo(routes.HomeRoute);
        }
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _navigationService.navigateTo(routes.HomeRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
        ),
      ),
    );
  }
}
