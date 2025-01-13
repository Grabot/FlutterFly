

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../../game/flutter_fly.dart';
import '../../../locator.dart';
import '../../../services/navigation_service.dart';
import '../../../services/rest/auth_service_setting.dart';
import '../../../services/settings.dart';
import '../../../util/change_notifiers/are_you_sure_change_notifier.dart';
import '../../../util/util.dart';

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

  bool showAreYouSure = false;

  late AreYouSureBoxChangeNotifier areYouSureBoxChangeNotifier;

  final NavigationService _navigationService = locator<NavigationService>();

  final deleteKeyRegister = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    areYouSureBoxChangeNotifier = AreYouSureBoxChangeNotifier();
    areYouSureBoxChangeNotifier.addListener(areYouSureBoxChangeListener);

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

  cancelButtonAction() {
    areYouSureBoxChangeNotifier.setAreYouSureBoxVisible(false);
  }

  logoutAction() {
    Settings settings = Settings();
    logoutUser(settings, _navigationService);
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

  deleteUser() {
    if (deleteKeyRegister.currentState!.validate()) {
      String email = emailController.text;
      AuthServiceSetting().deleteAccountLoggedIn(email).then((response) {
        if (response.getResult()) {
          showToast("email sent to finalize account deletion");
          logoutAction();
        } else {
          showToast("Failed to delete account: ${response.getMessage()}");
        }
      }).onError((error, stackTrace) {
        showToast("Failed to delete account: ${error.toString()}");
      });
    }
  }

  Widget areYouSureDelete() {
    return TapRegion(
      onTapOutside: (tap) {
        cancelButtonAction();
      },
      child: AlertDialog(
        title: const Text("Delete account?"),
        content: Form(
          key: deleteKeyRegister,
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text("Are you sure you want to delete your account?\nFill in the email of this account and press \"Delete\" to confirm."),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    controller: emailController,
                    validator: (val) {
                      if (val != null && val.isNotEmpty) {
                        if (!emailValid(val)) {
                          return "Email not formatted correctly";
                        }
                      }
                      return val == null || val.isEmpty
                          ? "Please provide an Email"
                          : null;
                    },
                    decoration: InputDecoration(hintText: "Enter your email here"),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text("Cancel"),
            onPressed:  () {
              cancelButtonAction();
            },
          ),
          ElevatedButton(
            child: const Text("Delete"),
            onPressed:  () {
              deleteUser();
            },
          ),
        ],
      ),
    );
  }

  Widget areYouSureBox(BuildContext context) {
    bool showLogout = areYouSureBoxChangeNotifier.getShowLogout();
    bool showDelete = areYouSureBoxChangeNotifier.getShowDelete();
    Widget areYouSureBox = Container();
    if (showLogout) {
      areYouSureBox = areYouSureLogout();
    } else if (showDelete) {
      areYouSureBox = areYouSureDelete();
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: areYouSureBox
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
