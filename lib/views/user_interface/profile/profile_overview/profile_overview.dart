import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/locator.dart';
import 'package:flutterfly/services/navigation_service.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';
import 'package:flutterfly/util/render_avatar.dart';
import 'package:flutterfly/util/util.dart';
import 'package:flutterfly/views/user_interface/ui_util/clear_ui.dart';


class ProfileOverview extends StatefulWidget {

  final FlutterFly game;

  const ProfileOverview({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  ProfileOverviewState createState() => ProfileOverviewState();
}

class ProfileOverviewState extends State<ProfileOverview> {

  late UserChangeNotifier profileChangeNotifier;
  Settings settings = Settings();

  int friendOverviewState = 0;
  int messageOverviewState = 0;

  bool unansweredFriendRequests = false;
  bool unreadMessages = false;

  bool showHideProfile = true;

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();

    profileChangeNotifier = UserChangeNotifier();
    profileChangeNotifier.addListener(profileChangeListener);
    settings.addListener(profileChangeListener);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    ClearUI clearUI = ClearUI();
    if (clearUI.isUiElementVisible()) {
      clearUI.clearUserInterfaces();
      return true;
    } else {
      // Ask to logout?
      showAlertDialog(context);
      return false;
    }
  }

  // Only show logout dialog when user presses back button
  showAlertDialog(BuildContext context) {  // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Logout"),
      onPressed:  () {
        Navigator.pop(context);
        logoutUser(Settings(), _navigationService);
      },
    );  // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Leave?"),
      content: const Text("Do you want to logout of FlutterBird?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  profileChangeListener() {
    if (mounted) {
      if (profileChangeNotifier.getProfileOverviewVisible()) {
        showHideProfile = true;
      } else {
        showHideProfile = false;
      }
      setState(() {});
    }
  }

  selectedTileListener() {
    if (mounted) {
      setState(() {});
    }
  }

  goToProfile() {
    if (!profileChangeNotifier.getProfileVisible()) {
      profileChangeNotifier.setProfileVisible(true);
    } else if (profileChangeNotifier.getProfileVisible()) {
      profileChangeNotifier.setProfileVisible(false);
    }
  }

  Color overviewColour(int state) {
    if (state == 0) {
      return Colors.orange;
    } else if (state == 1) {
      return Colors.orangeAccent;
    } else {
      return Colors.orange.shade800;
    }
  }

  Widget getAvatar(double avatarSize) {
    return Container(
      child: settings.getAvatar() != null ? avatarBox(avatarSize, avatarSize, settings.getAvatar()!)
          : Image.asset(
        "assets/images/default_avatar.png",
        width: avatarSize,
        height: avatarSize,
      )
    );
  }

  Widget profileWidget(double profileOverviewWidth, double profileOverviewHeight) {
    return Row(
      children: [
        Container(
          width: profileOverviewWidth,
          height: profileOverviewHeight,
          color: Colors.black26,
          child: GestureDetector(
            onTap: () {
              goToProfile();
            },
            child: Row(
              children: [
                getAvatar(profileOverviewHeight),
                const SizedBox(width: 5),
                SizedBox(
                  width: profileOverviewWidth - profileOverviewHeight - 5,
                  child: Text.rich(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: settings.getUser() != null ? settings.getUser()!.getUserName() : "Guest",
                      style: simpleTextStyle(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  showChatWindow() {
    // ChatBoxChangeNotifier().setChatBoxVisible(false);
    // ChatWindowChangeNotifier().setChatWindowVisible(true);
  }

  Widget profileOverviewNormal(double profileOverviewWidth, double profileOverviewHeight, double fontSize) {
    double profileAvatarHeight = 100;
    return Container(
      child: Column(
        children: [
          showHideProfile ? profileWidget(profileOverviewWidth, profileAvatarHeight) : Container(),
        ]
      ),
    );
  }

  Widget profileOverviewMobile(double profileOverviewWidth, double profileOverviewHeight, double statusBarPadding, double fontSize) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: statusBarPadding),
          Row(
            children: [
              Column(
                children: [
                  showHideProfile ? profileWidget(profileOverviewWidth, profileOverviewHeight) : Container(),
                ],
              ),
            ]
          ),
        ]
      ),
    );
  }

  bool normalMode = true;
  Widget tileBoxWidget() {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double heightScale = totalHeight / 800;
    double fontSize = 16 * heightScale;
    double profileOverviewWidth = 350;
    // We use the total height to hide the chatbox below
    // In NormalMode the height has the 2 buttons and some padding added.
    double profileOverviewHeight = 100;
    normalMode = true;
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    if (totalWidth <= 800) {
      profileOverviewWidth = totalWidth/2;
      if (totalHeight < totalWidth) {
        profileOverviewWidth = totalWidth/3;
      }
      profileOverviewWidth += 5;
      profileOverviewHeight = 50;
      normalMode = false;
    }
    return Align(
      alignment: FractionalOffset.topRight,
      child: SingleChildScrollView(
        child: SizedBox(
            width: profileOverviewWidth,
            height: profileOverviewHeight + statusBarPadding,
            child: normalMode
                ? profileOverviewNormal(profileOverviewWidth, profileOverviewHeight, fontSize)
                : profileOverviewMobile(profileOverviewWidth, profileOverviewHeight, statusBarPadding, fontSize)
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return tileBoxWidget();
  }
}

