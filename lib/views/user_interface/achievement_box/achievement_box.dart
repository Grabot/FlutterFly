import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/models/ui/achievement.dart';
import 'package:flutterfly/models/user.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/services/user_achievements.dart';
import 'package:flutterfly/util/box_window_painter.dart';
import 'package:flutterfly/util/change_notifiers/achievement_box_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/achievement_close_up_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/login_screen_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';
import 'package:flutterfly/util/util.dart';
import 'package:themed/themed.dart';


class AchievementBox extends StatefulWidget {

  final FlutterFly game;

  const AchievementBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  AchievementBoxState createState() => AchievementBoxState();
}

class AchievementBoxState extends State<AchievementBox> {

  // Used if any text fields are added to the profile.
  late AchievementBoxChangeNotifier achievementBoxChangeNotifier;

  Settings settings = Settings();
  UserAchievements userAchievements = UserAchievements();

  User? currentUser;

  bool showAchievementBox = false;

  // used to get the position and place the dropdown in the right spot
  GlobalKey cancelKey = GlobalKey();

  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  int numberOfAchievementsAchieved = 0;
  int totalOfAchievements = 0;

  @override
  void initState() {
    achievementBoxChangeNotifier = AchievementBoxChangeNotifier();
    achievementBoxChangeNotifier.addListener(achievementBoxChangeListener);

    currentUser = settings.getUser();

    totalOfAchievements = userAchievements.getAchievementsAvailable().length;
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

  achievementBoxChangeListener() {
    if (mounted) {
      if (!showAchievementBox && achievementBoxChangeNotifier.getAchievementBoxVisible()) {
        showAchievementBox = true;
        numberOfAchievementsAchieved = userAchievements.achievedAchievementList().length;
      }
      if (showAchievementBox && !achievementBoxChangeNotifier.getAchievementBoxVisible()) {
        showAchievementBox = false;
      }
      setState(() {});
    }
  }

  tappedAchievements(Achievement achievement) {
    AchievementCloseUpChangeNotifier achievementCloseUpChangeNotifier = AchievementCloseUpChangeNotifier();
    achievementCloseUpChangeNotifier.setAchievement(achievement);
    achievementCloseUpChangeNotifier.setAchievementCloseUpVisible(true);
    achievementBoxChangeNotifier.setAchievementBoxVisible(false);
  }

  AutoSizeGroup sizeGroupAchievements = AutoSizeGroup();

  Widget achievementItem(Achievement achievement, double achievementWindowWidth, double achievementSize, double fontSize) {
    double marginWidth = 20;
    return GestureDetector(
      onTap: () {
        tappedAchievements(achievement);
      },
      child: SizedBox(
        width: achievementWindowWidth,
        height: achievementSize,
        child: Row(
          children: [
            ChangeColors(
              saturation: achievement.achieved ? 0 : -1,
              child: Image.asset(
                achievement.getImagePath(),
                width: achievementSize,
                height: achievementSize,
                gaplessPlayback: true,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
                width: achievementWindowWidth - achievementSize - marginWidth - 10,
                child: AutoSizeText(
                  achievement.getTooltip(),
                  style: const TextStyle(
                    color: Color(0xFFcba830),
                    fontSize: 50,
                  ),
                  group: sizeGroupAchievements,
                  maxLines: 3,
                )
            ),
          ],
        )
      ),
    );
  }

  Widget achievementTableHeader(double achievementWindowWidth, double fontSize) {
    return Row(
      children: [
        const SizedBox(width: 10),
        SizedBox(
            width: achievementWindowWidth - 20,
            child:Text.rich(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                text: "Total achievements achieved $numberOfAchievementsAchieved/$totalOfAchievements",
                style: TextStyle(
                    color: const Color(0xFFcba830),
                    fontSize: fontSize*1.4
                ),
              ),
            )
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget achievementList(double achievementWindowWidth, double fontSize) {
    double achievementSize = 100;
    int itemCount = userAchievements.getAchievementsAvailable().length;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: achievementWindowWidth,
      height: achievementSize * itemCount,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),  // scrolling done in SingleScrollView
        itemCount: itemCount,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return achievementItem(userAchievements.getAchievementsAvailable()[index], achievementWindowWidth, achievementSize, fontSize);
        },
      ),
    );
  }

  Widget logInToGetAchievements(double achievementWindowWidth, double fontSize) {
    return Column(
      children: [
        Row(
            children:
            [
              const SizedBox(width: 10),
              expandedText(achievementWindowWidth-20, "Save your achievements by creating an account!", fontSize, false),
              const SizedBox(width: 10),
            ]
        ),
        const SizedBox(height: 10),
        Row(
            children: [
              const SizedBox(width: 20),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    achievementBoxChangeNotifier.setAchievementBoxVisible(false);
                    LoginScreenChangeNotifier().setLoginScreenVisible(true);
                  },
                  style: buttonStyle(false, Colors.blue),
                  child: Container(
                    alignment: Alignment.center,
                    width: achievementWindowWidth/4,
                    height: fontSize,
                    child: Text(
                      'Log in',
                      style: simpleTextStyle(fontSize),
                    ),
                  ),
                ),
              ),
            ]
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget achievementBox(double totalWidth, double totalHeight) {
    double fontSize = 16;
    double width = 800;
    double height = (totalHeight / 10) * 6;
    // When the width is smaller than this we assume it's mobile.
    if (totalWidth <= 800) {
      width = totalWidth - 50;
    }
    double headerHeight = 40;

    User? currentUser = settings.getUser();

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: BoxWindowPainter(showTop: showTopScoreScreen, showBottom: showBottomScoreScreen),
        child: NotificationListener(
          child: SingleChildScrollView(
              controller: _controller,
              child: SizedBox(
                child: Column(
                    children:
                    [
                      achievementWindowHeader(width-30, headerHeight, fontSize),
                      const SizedBox(height: 20),
                      currentUser == null ? logInToGetAchievements(width, fontSize) : Container(),
                      achievementTableHeader(width, fontSize),
                      achievementList(width, fontSize),
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
    // If you go back from this screen you should go back to the profile screen.
    // This is because you can only open the achievement screen from the profile screen.
    // So going back means you should go back to the profile screen.
    setState(() {
      achievementBoxChangeNotifier.setAchievementBoxVisible(false);
      UserChangeNotifier().setProfileVisible(true);
    });
  }

  Widget achievementWindowHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Text(
            "Achievement window",
            style: TextStyle(
                color: const Color(0xFFcba830),
                fontSize: fontSize*1.4
            ),
          )
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
                      achievementBox(screenWidth, screenHeight),
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
      child: showAchievementBox ? profileBoxScreen(context) : Container(),
    );
  }

}
