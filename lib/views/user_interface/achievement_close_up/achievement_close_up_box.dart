import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/models/ui/achievement.dart';
import 'package:flutterfly/util/box_window_painter.dart';
import 'package:flutterfly/util/change_notifiers/achievement_box_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/achievement_close_up_change_notifier.dart';
import 'package:flutterfly/util/util.dart';
import 'package:themed/themed.dart';

import '../../../constants/flutterfly_constant.dart';


class AchievementCloseUpBox extends StatefulWidget {

  final FlutterFly game;

  const AchievementCloseUpBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  AchievementCloseUpBoxState createState() => AchievementCloseUpBoxState();
}

class AchievementCloseUpBoxState extends State<AchievementCloseUpBox> {

  bool showAchievementCloseUp = false;

  late AchievementCloseUpChangeNotifier achievementCloseUpChangeNotifier;

  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  Achievement? closeUpAchievement;

  @override
  void initState() {
    achievementCloseUpChangeNotifier = AchievementCloseUpChangeNotifier();
    achievementCloseUpChangeNotifier.addListener(achievementCloseUpBoxChangeListener);

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  @override
  void dispose() {
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

  achievementCloseUpBoxChangeListener() {
    if (mounted) {
      if (!showAchievementCloseUp && achievementCloseUpChangeNotifier.getAchievementCloseUpVisible()) {
        setState(() {
          closeUpAchievement = achievementCloseUpChangeNotifier.getAchievement();
          showAchievementCloseUp = true;
        });
      }
      if (showAchievementCloseUp && !achievementCloseUpChangeNotifier.getAchievementCloseUpVisible()) {
        setState(() {
          showAchievementCloseUp = false;
        });
      }
    }
  }

  goBack() {
    setState(() {
      cancelButtonAction();
    });
  }

  cancelButtonAction() {
    setState(() {
      achievementCloseUpChangeNotifier.setAchievementCloseUpVisible(false);
      AchievementBoxChangeNotifier().setAchievementBoxVisible(true);
    });
  }

  Widget achievementWindowHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                "Achievement",
                style: TextStyle(
                    color: textColor,
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

  Widget achievementName(double fontSize) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.getAchievementName(),
        style: TextStyle(
            color: textColor,
            fontSize: fontSize*1.4
        ),
      ),
    );
  }

  achievementImageCloseUp(double width) {
    return Container(
      child: ChangeColors(
        saturation: closeUpAchievement!.achieved ? 0 : -1,
        child: achievementImage(
          closeUpAchievement!.getAchievementImage(0),
          width,
          width,
        ),
      ),
    );
  }

  Widget achievementAchieved(double fontSize) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.achieved ? "Achieved" : "Not achieved",
        style: TextStyle(
            color: textColor,
            fontSize: fontSize*1.2
        ),
      ),
    );
  }

  Widget achievementInformation(double fontSize) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.getTooltip(),
        style: TextStyle(
            color: textColor,
            fontSize: fontSize*1.2
        ),
      ),
    );
  }

  Widget achievementDetail(double width, double fontSize) {
    return Column(
      children: [
        achievementName(fontSize),
        achievementInformation(fontSize),
        achievementImageCloseUp(width-80),
        achievementAchieved(fontSize),
      ],
    );
  }

  Widget achievementCloseUp(double totalWidth, double totalHeight) {
    double fontSize = 16;
    double width = 800;
    double height = (totalHeight / 10) * 6;
    // When the width is smaller than this we assume it's mobile.
    if (totalWidth <= 800) {
      width = totalWidth - 50;
    }
    double headerHeight = 40;
    return TapRegion(
      onTapOutside: (tap) {
        cancelButtonAction();
      },
      child: SizedBox(
        width:width,
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
                          achievementWindowHeader(width-80, headerHeight, fontSize),
                          const SizedBox(height: 20),
                          closeUpAchievement != null ? achievementDetail(width, fontSize) : Container()
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
      )
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

  Widget achievementCloseUpBox(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      width: totalWidth,
      height: totalHeight,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(),
              achievementCloseUp(totalWidth, totalHeight),
              continueButton(totalWidth, totalHeight, 16)
            ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showAchievementCloseUp ? achievementCloseUpBox(context) : Container()
    );
  }
}
