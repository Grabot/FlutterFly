import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/models/ui/achievement.dart';
import 'package:flutterfly/models/ui/tooltip.dart';
import 'package:flutterfly/models/user.dart';
import 'package:flutterfly/services/rest/auth_service_setting.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/services/user_achievements.dart';
import 'package:flutterfly/services/user_score.dart';
import 'package:flutterfly/util/box_window_painter.dart';
import 'package:flutterfly/util/change_notifiers/achievement_box_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/are_you_sure_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/change_avatar_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/login_screen_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';
import 'package:flutterfly/util/render_avatar.dart';
import 'package:flutterfly/util/util.dart';


class ProfileBox extends StatefulWidget {

  final FlutterFly game;

  const ProfileBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  ProfileBoxState createState() => ProfileBoxState();
}

class ProfileBoxState extends State<ProfileBox> {

  late UserChangeNotifier userChangeNotifier;
  Settings settings = Settings();
  UserScore userScore = UserScore();
  UserAchievements userAchievements = UserAchievements();

  User? currentUser;

  int levelClock = 0;
  bool canChangeTiles = true;

  bool showProfile = false;

  // used to get the position and place the dropdown in the right spot
  GlobalKey settingsKey = GlobalKey();
  GlobalKey cancelKey = GlobalKey();

  bool changeUserName = false;
  final GlobalKey<FormState> userNameKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();

  bool changePassword = false;
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  bool tooltipShowing = false;

  @override
  void initState() {
    userChangeNotifier = UserChangeNotifier();
    userChangeNotifier.addListener(profileChangeListener);

    currentUser = settings.getUser();

    settings.addListener(settingsChangeListener);

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  checkTopBottomScroll() {
    if (_controller.hasClients) {
      double distanceToBottom =
          _controller.position.maxScrollExtent -
              _controller.position.pixels;
      double distanceToTop =
          _controller.position.minScrollExtent -
              _controller.position.pixels;
      if (distanceToBottom != 0) {
        setState(() {
          showBottomScoreScreen = false;
        });
      } else {
        setState(() {
          showBottomScoreScreen = true;
        });
      }
      if (distanceToTop != 0) {
        setState(() {
          showTopScoreScreen = false;
        });
      } else {
        setState(() {
          showTopScoreScreen = true;
        });
      }
    }
  }

  profileChangeListener() {
    if (mounted) {
      if (!showProfile && userChangeNotifier.getProfileVisible()) {
        showProfile = true;
      }
      if (showProfile && !userChangeNotifier.getProfileVisible()) {
        showProfile = false;
      }
      setState(() {});
    }
  }

  settingsChangeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget continueButton(double screenWidth, double screenHeight, double fontSize) {
    return Container(
      child: TextButton(
          onPressed: () {
            goBack();
          },
          child: Container(
            width: 150,
            height: 30,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Ok',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
          )
      ),
    );
  }

  Widget profile(double totalWidth, double totalHeight) {
    // normal mode is for desktop, mobile mode is for mobile.
    bool normalMode = true;
    double fontSize = 16;
    double width = 800;
    double height = (totalHeight / 10) * 6;
    // When the width is smaller than this we assume it's mobile.
    if (totalWidth - 50 <= 800) {
      width = totalWidth - 50;
      normalMode = false;
      double heightScale = totalHeight / 800;
      fontSize = 16 * heightScale;
    }
    double headerHeight = 40;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: BoxWindowPainter(showTop: showTopScoreScreen, showBottom: showBottomScoreScreen),
        child: NotificationListener(
          child: SingleChildScrollView(
              controller: _controller,
              child: Container(
                child: Column(
                    children:
                    [
                      profileHeader(width-30, headerHeight, fontSize),
                      const SizedBox(height: 20),
                      userInformationBox(width-30, fontSize, normalMode),
                      const SizedBox(height: 20),
                    ]
                ),
              )
          ),
          onNotification: (t) {
            checkTopBottomScroll();
            return true;
          }
        ),
      ),
    );
  }

  goBack() {
    if (tooltipShowing) {
      // Even if pressed in the profile box.
      // It will think it's outside the profile box if the tooltip is showing.
      return;
    }
    if (settingsPressed) {
      settingsPressed = false;
      return;
    }
    setState(() {
      widget.game.focusGame();
      userChangeNotifier.setProfileVisible(false);
    });
  }

  userNameChange() {
    if (userNameKey.currentState!.validate()) {
      AuthServiceSetting().changeUserName(userNameController.text).then((response) {
        if (response.getResult()) {
          setState(() {
            String newUsername = response.getMessage();
            if (settings.getUser() != null) {
              settings.getUser()!.setUsername(newUsername);
              settings.notify();
            }
            setState(() {
              userNameController.text = "";
              showToastMessage("Username changed!");
              changeUserName = false;
            });
          });
        } else {
          showToastMessage(response.getMessage());
        }
      });
    }
  }

  passwordChange() {
    if (passwordKey.currentState!.validate()) {
      AuthServiceSetting().changePassword(passwordController.text).then((response) {
        if (response.getResult()) {
          setState(() {
            setState(() {
              passwordController.text = "";
              showToastMessage("password changed!");
              changePassword = false;
            });
          });
        } else {
          showToastMessage(response.getMessage());
        }
      });
    }
  }

  openAchievementBox() {
    setState(() {
      userChangeNotifier.setProfileVisible(false);
      AchievementBoxChangeNotifier().setAchievementBoxVisible(true);
    });
  }

  Widget profileHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: settings.getUser() == null
              ? Text(
            "No user logged in",
            style: TextStyle(
                color: const Color(0xFFcba830),
                fontSize: fontSize*1.4
            ),
          )
            : Text(
            "Profile Page",
            style: TextStyle(
                color: const Color(0xFFcba830),
                fontSize: fontSize*1.4
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          color: Colors.orangeAccent.shade200,
          onPressed: () {
            setState(() {
              goBack();
            });
          }
        ),
      ]
    );
  }

  Widget userStats(double userStatsWidth, double fontSize) {
    return Column(
      children: [
        expandedText(userStatsWidth, "Best score single bird: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getBestScoreSingleButterfly()}", fontSize+6, true),
        const SizedBox(height: 20),
        expandedText(userStatsWidth, "Best score double bird: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getBestScoreDoubleButterfly()}", fontSize+6, true),
        const SizedBox(height: 20),
        expandedText(userStatsWidth, "Number of games played: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getTotalGames()}", fontSize+6, true),
        const SizedBox(height: 20),
        expandedText(userStatsWidth, "Total pipes cleared: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getTotalPipesCleared()}", fontSize+6, true),
        const SizedBox(height: 20),
        expandedText(userStatsWidth, "Total wing flutters: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getTotalFlutters()}", fontSize+6, true),
      ],
    );
  }

  Widget platformWidget(double width, double fontSize) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Expanded(
              child: Text.rich(
                  TextSpan(
                      text: kIsWeb
                          ? "Also try Flutter Fly on Android or IOS!"
                          : "Also try Flutter Fly in your browser on flutterfly.eu",
                      style: TextStyle(
                          color: const Color(0xFFcba830),
                          fontSize: fontSize*1.4
                      ),
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget achievementsWidget(double achievementWidth, double fontSize) {
    List<Achievement> achievedAchievements = userAchievements.achievedAchievementList();
    // If the length of achievementsGot is bigger than 8, 16, 24 or 32, add another row to the height
    int multiplesOfEight = (achievedAchievements.length/8).ceil();
    double achievementHeight = (achievementWidth/8) * multiplesOfEight;
    return Column(
      children: [
        SizedBox(
          width: achievementWidth,
          child: Text(
            "Achievements:",
            style: TextStyle(
                color: const Color(0xFFcba830),
                fontSize: fontSize*1.4
            ),
          ),
        ),
        achievedAchievements.isNotEmpty ? SizedBox(
          width: achievementWidth,
          height: achievementHeight,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            padding: EdgeInsets.zero,
            itemCount: achievedAchievements.length,
            itemBuilder: (context, index) {
              return achievementTile(context, achievedAchievements[index], (achievementWidth/8));
            },
          ),
        ) : SizedBox(
          width: achievementWidth,
          child: Text(
            "No achievements yet!",
            style: TextStyle(
                color: const Color(0xFFcba830),
                fontSize: fontSize*1.4
            ),
          ),
        ),
        const SizedBox(height: 10),
        checkAllAchievements(achievementWidth, fontSize),
        const SizedBox(height: 20),
      ]
    );
  }

  Widget checkAllAchievements(double width, double fontSize) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            openAchievementBox();
          });
        },
        style: buttonStyle(false, Colors.blue),
        child: Container(
          alignment: Alignment.center,
          width: width/2,
          height: fontSize,
          child: Text(
            'Check achievements',
            style: simpleTextStyle(fontSize*0.7),
          ),
        ),
      ),
    );
  }

  Widget nobodyLoggedInMobile(double width, double fontSize) {
    double widthAvatar = 300;
    if (width < widthAvatar) {
      widthAvatar = width;
    }
    return Column(
        children: [
          profileAvatar(widthAvatar, fontSize),
          const SizedBox(height: 20),
          userStats(width, fontSize),
          const SizedBox(height: 40),
          achievementsWidget(width, fontSize),
          const SizedBox(height: 20),
          platformWidget(width, fontSize),
          const SizedBox(height: 20),
          logInWidget(width, fontSize, false),
        ]
    );
  }

  Widget logInWidget(double width, double fontSize, bool normalMode) {
    if (normalMode) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                    "Save your progress by logging in!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xFFcba830),
                        fontSize: fontSize*1.4
                    ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      userChangeNotifier.setProfileVisible(false);
                      LoginScreenChangeNotifier().setLoginScreenVisible(true);
                    });
                  },
                  style: buttonStyle(false, Colors.blue),
                  child: Container(
                    alignment: Alignment.center,
                    width: width / 4,
                    height: fontSize,
                    child: Text(
                      'Log in',
                      style: simpleTextStyle(fontSize),
                    ),
                  ),
                ),
              ),
            ]
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
                "Save your progress by logging in!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xFFcba830),
                    fontSize: fontSize*1.4
                ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  userChangeNotifier.setProfileVisible(false);
                  LoginScreenChangeNotifier().setLoginScreenVisible(true);
                });
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width / 4,
                height: fontSize,
                child: Text(
                  'Log in',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      );
    }
  }

  Widget nobodyLoggedInNormal(double width, double fontSize) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            profileAvatar(300, fontSize),
            const SizedBox(width: 20),
            userStats((width - 300 - 20), fontSize),
          ],
        ),
        const SizedBox(height: 40),
        achievementsWidget(width, fontSize),
        const SizedBox(height: 40),
        platformWidget(width, fontSize),
        const SizedBox(height: 40),
        logInWidget(width, fontSize, true),
      ],
    );
  }

  Widget somebodyLoggedInNormal(double width, double fontSize) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              profileAvatar(300, fontSize),
              const SizedBox(width: 20),
              userStats((width - 300 - 20), fontSize),
            ]
        ),
        const SizedBox(height: 10),
        achievementsWidget(width, fontSize),
        const SizedBox(height: 10),
        platformWidget(width, fontSize),
        const SizedBox(height: 40),
      ]
    );
  }

  Widget changeUserNameField(double avatarWidth, double fontSize) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent)
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change username", style: simpleTextStyle(fontSize)),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.orangeAccent.shade200,
                      onPressed: () {
                        setState(() {
                          changeUserName = false;
                        });
                      }
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: userNameKey,
              child: TextFormField(
                controller: userNameController,
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "Please enter a username if you want to change it"
                      : null;
                },
                scrollPadding: const EdgeInsets.only(bottom: 120),
                decoration: const InputDecoration(
                  hintText: "New username",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: fontSize,
                    color: Colors.white
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                userNameChange();
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: avatarWidth,
                height: 50,
                child: Text(
                  'Change username',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePasswordField(double avatarWidth, double fontSize) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent)
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change password", style: simpleTextStyle(fontSize)),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.orangeAccent.shade200,
                        onPressed: () {
                          setState(() {
                            changePassword = false;
                          });
                        }
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: passwordKey,
              child: TextFormField(
                controller: passwordController,
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "fill in new password"
                      : null;
                },
                scrollPadding: const EdgeInsets.only(bottom: 120),
                decoration: const InputDecoration(
                  hintText: "New password",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                passwordChange();
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: avatarWidth,
                height: 50,
                child: Text(
                  'Change password',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileAvatar(double avatarWidth, double fontSize) {
    User? currentUser = settings.getUser();
    String userName = "";
    if (currentUser == null) {
      userName = "Guest";
    } else {
      userName = currentUser.getUserName();
    }
    return SizedBox(
        width: avatarWidth,
        child: Column(
            children: [
              avatarBox(avatarWidth, avatarWidth, settings.getAvatar()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text.rich(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text: userName,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontSize: fontSize*1.2
                        ),
                      ),
                    ),
                  ),
                  currentUser != null ? IconButton(
                      key: settingsKey,
                      iconSize: 40.0,
                      icon: const Icon(Icons.settings),
                      color: Colors.orangeAccent.shade200,
                      tooltip: 'Settings',
                      onPressed: _showPopupMenu
                  ) : Container()
                ],
              ),
              changeUserName ? changeUserNameField(avatarWidth, fontSize) : Container(),
              changePassword ? changePasswordField(avatarWidth, fontSize) : Container(),
            ]
        )
    );
  }

  Widget somebodyLoggedInMobile(double width, double fontSize) {
    double widthAvatar = 300;
    if (width < widthAvatar) {
      widthAvatar = width;
    }
    return Column(
      children: [
        profileAvatar(widthAvatar, fontSize),
        const SizedBox(height: 20),
        userStats(width, fontSize),
        const SizedBox(height: 10),
        achievementsWidget(width, fontSize),
        const SizedBox(height: 10),
        platformWidget(width, fontSize),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget normalModeProfile(double width, double fontSize) {
    return Container(
        child: settings.getUser() != null
            ? somebodyLoggedInNormal(width, fontSize)
            : nobodyLoggedInNormal(width, fontSize)
    );
  }

  Widget mobileModeProfile(double width, double fontSize) {
    return Container(
        child: settings.getUser() != null
            ? somebodyLoggedInMobile(width, fontSize)
            : nobodyLoggedInMobile(width, fontSize)
    );
  }

  Widget userInformationBox(double width, double fontSize, bool normalMode) {
    if (normalMode) {
      return normalModeProfile(width, fontSize);
    } else {
      return mobileModeProfile(width, fontSize);
    }
  }

  Widget profileBoxScreen(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  goBack();
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(),
                      profile(screenWidth, screenHeight),
                      continueButton(screenWidth, screenHeight, 16),
                    ]
                )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showProfile ? profileBoxScreen(context) : Container(),
    );
  }

  showChangeUsername() {
    setState(() {
      changeUserName = true;
      changePassword = false;
    });
  }

  showChangePassword() {
    setState(() {
      changePassword = true;
      changeUserName = false;
    });
  }

  showChangeAvatar() {
    setState(() {
      if (settings.getAvatar() == null) {
        rootBundle.load('assets/images/default_avatar.png').then((data) {
          ChangeAvatarChangeNotifier().setAvatar(data.buffer.asUint8List());
          ChangeAvatarChangeNotifier().setChangeAvatarVisible(true);
        });
      } else {
        ChangeAvatarChangeNotifier().setAvatar(settings.getAvatar()!);
        ChangeAvatarChangeNotifier().setChangeAvatarVisible(true);
      }
      changePassword = false;
      changeUserName = false;
    });
  }

  Offset? _tapPosition;

  bool settingsPressed = false;
  void _showPopupMenu() {
    settingsPressed = true;
    _storePositionSettings();
    _showChatDetailPopupMenu();
  }

  void _showChatDetailPopupMenu() {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
        context: context,
        items: [SettingPopup(key: UniqueKey())],
        position: RelativeRect.fromRect(
            _tapPosition! & const Size(40, 40), Offset.zero & overlay.size))
        .then((int? delta) {
      settingsPressed = false;
      if (delta == 0) {
        // change avatar
        showChangeAvatar();
      } else if (delta == 1) {
        // change username
        showChangeUsername();
      } else if (delta == 2) {
        // change password
        showChangePassword();
      } else if (delta == 3) {
        // logout user
        AreYouSureBoxChangeNotifier().setAreYouSureBoxVisible(true);
      }
      return;
    });
  }

  void _storePositionSettings() {
    RenderBox box = settingsKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    position = position + const Offset(0, 50);
    _tapPosition = position;
  }

  Widget achievementTile(BuildContext context, Achievement achievement, double achievementSize) {
    GlobalKey achievementsKey = GlobalKey();
    return GestureDetector(
      key: achievementsKey,
      onTap: () {
        // an ugly custom way to show tooltip, so it won't get stuck on the screen.
        // It uses the popup menu functionality.
        _showTooltip(context, achievementsKey, achievement.getTooltip());
      },
      child: Image.asset(
        achievement.getImagePath(),
        width: achievementSize,
        height: achievementSize,
        gaplessPlayback: true,
        fit: BoxFit.fill,
      ),
    );
  }

  void _showTooltip(BuildContext context, GlobalKey achievementsKey, String tooltip) {
    Offset tapPosition = _storePosition(context, achievementsKey);
    _showTooltipPopup(context, achievementsKey, tapPosition, tooltip);
  }

  Offset _storePosition(BuildContext context, GlobalKey achievementsKey) {
    RenderBox box = achievementsKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    position = position + const Offset(0, 50);
    return position;
  }

  void _showTooltipPopup(BuildContext context, GlobalKey achievementsKey, Offset tapPosition, String tooltip) {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    Future.delayed(const Duration(seconds: 2), () {
      // If the tooltip is still showing, we do a pop which will remove it.
      if (tooltipShowing) {
        Navigator.pop(context);
      }
    });
    tooltipShowing = true;
    showMenu(
        context: context,
        items: [TooltipPopup(key: UniqueKey(), tooltip: tooltip)],
        position: RelativeRect.fromRect(
            tapPosition & const Size(40, 40), Offset.zero & overlay.size))
        .then((int? delta) {
      // do nothing, this will remove the tooltip.
      tooltipShowing = false;
      return;
    });
  }
}

class SettingPopup extends PopupMenuEntry<int> {

  const SettingPopup({required Key key}) : super(key: key);

  @override
  bool represents(int? n) => n == 1 || n == -1;

  @override
  SettingPopupState createState() => SettingPopupState();

  @override
  double get height => 1;
}

class SettingPopupState extends State<SettingPopup> {
  @override
  Widget build(BuildContext context) {
    return getPopupItems(context);
  }
}

void buttonChangeProfile(BuildContext context) {
  Navigator.pop<int>(context, 0);
}

void buttonChangeUsername(BuildContext context) {
  Navigator.pop<int>(context, 1);
}

void buttonChangePassword(BuildContext context) {
  Navigator.pop<int>(context, 2);
}

void buttonLogout(BuildContext context) {
  Navigator.pop<int>(context, 3);
}

Widget getPopupItems(BuildContext context) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonChangeProfile(context);
            },
            child: const Row(
              children:[
                Text(
                  'Change avatar',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ] ,
            )
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonChangeUsername(context);
            },
            child: const Row(
              children: [
                Text(
                  "Change username",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ]
            )
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonChangePassword(context);
            },
            child: const Row(
              children: [
                Text(
                  "Change password",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ]
          )
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonLogout(context);
            },
            child: const Row(
              children: [
                Text(
                  "Logout",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            )
        ),
      ),
    ]
  );
}
