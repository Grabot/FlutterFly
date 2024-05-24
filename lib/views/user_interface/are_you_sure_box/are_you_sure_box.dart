import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/locator.dart';
import 'package:flutterfly/services/navigation_service.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/util/change_notifiers/are_you_sure_change_notifier.dart';
import 'package:flutterfly/util/util.dart';


class AreYouSureBox extends StatefulWidget {

  final FlutterFly game;

  const AreYouSureBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  AreYouSureBoxState createState() => AreYouSureBoxState();
}

class AreYouSureBoxState extends State<AreYouSureBox> {

  final FocusNode _focusAreYouSureBox = FocusNode();
  bool showAreYouSure = false;

  late AreYouSureBoxChangeNotifier areYouSureBoxChangeNotifier;

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    areYouSureBoxChangeNotifier = AreYouSureBoxChangeNotifier();
    areYouSureBoxChangeNotifier.addListener(areYouSureBoxChangeListener);

    // _focusAreYouSureBox.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  areYouSureBoxChangeListener() {
    if (mounted) {
      if (!showAreYouSure && areYouSureBoxChangeNotifier.getAreYouSureBoxVisible()) {
        setState(() {
          showAreYouSure = true;
        });
      }
      if (showAreYouSure && !areYouSureBoxChangeNotifier.getAreYouSureBoxVisible()) {
        setState(() {
          showAreYouSure = false;
        });
      }
    }
  }

  // void _onFocusChange() {
  //   widget.game.loadingBoxFocus(_focusAreYouSureBox.hasFocus);
  // }

  cancelButtonAction() {
    areYouSureBoxChangeNotifier.setAreYouSureBoxVisible(false);
  }

  logoutAction() {
    logoutUser(Settings(), _navigationService);
    areYouSureBoxChangeNotifier.setAreYouSureBoxVisible(false);
  }

  Widget areYouSureLogout() {
    return TapRegion(
      onTapOutside: (tap) {
        cancelButtonAction();
      },
      child: AlertDialog(
        title: const Text("Logout?"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          ElevatedButton(
            child: const Text("Cancel"),
            onPressed:  () {
              cancelButtonAction();
            },
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed:  () {
              logoutAction();
            },
          ),
        ],
      ),
    );
  }

  Widget areYouSureBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: areYouSureLogout()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showAreYouSure ? areYouSureBox(context) : Container()
    );
  }
}
