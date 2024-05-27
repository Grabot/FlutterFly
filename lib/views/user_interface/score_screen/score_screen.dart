import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/models/ui/achievement.dart';
import 'package:flutterfly/models/ui/tooltip.dart';
import 'package:flutterfly/models/user.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/services/user_achievements.dart';
import 'package:flutterfly/services/user_score.dart';
import 'package:flutterfly/util/box_window_painter.dart';
import 'package:flutterfly/util/change_notifiers/leader_board_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/login_screen_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/score_screen_change_notifier.dart';
import 'package:flutterfly/util/util.dart';


class ScoreScreen extends StatefulWidget {

  final FlutterFly game;

  const ScoreScreen({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  ScoreScreenState createState() => ScoreScreenState();
}

class ScoreScreenState extends State<ScoreScreen> {

  bool showScoreScreen = false;

  late ScoreScreenChangeNotifier scoreScreenChangeNotifier;
  late Settings settings;
  late UserScore userScore;
  late UserAchievements userAchievements;

  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  bool tooltipShowing = false;

  @override
  void initState() {
    scoreScreenChangeNotifier = ScoreScreenChangeNotifier();
    scoreScreenChangeNotifier.addListener(chatWindowChangeListener);
    settings = Settings();
    userScore = UserScore();
    userAchievements = UserAchievements();

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  chatWindowChangeListener() {
    if (mounted) {
      if (!showScoreScreen && scoreScreenChangeNotifier.getScoreScreenVisible()) {
        showScoreScreen = true;
      }
      if (showScoreScreen && !scoreScreenChangeNotifier.getScoreScreenVisible()) {
        showScoreScreen = false;
      }
      checkTopBottomScroll();
      setState(() {});
    }
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

  Widget medalHeader(double medalWidth, double medalHeight, double fontSize) {
    return Container(
      alignment: Alignment.center,
      width: medalWidth,
      height: medalHeight,
      child: Text(
        "Achievements",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFcba830)
        )
      ),
    );
  }

  Widget achievementsOwnedGrid(double medalWidth, double medalHeight) {
    List earnedAchievements = userAchievements.achievedAchievementList();
    return SizedBox(
        width: medalWidth,
        height: medalHeight,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          padding: EdgeInsets.zero,
          physics: earnedAchievements.length <= 12
              ? const NeverScrollableScrollPhysics()  // no scrolling with less than 12 items
              : const AlwaysScrollableScrollPhysics(),
          itemCount: earnedAchievements.length,
          itemBuilder: (context, index) {
            return achievementTile(context, earnedAchievements[index], medalWidth/4);
          },
        ),
    );
  }

  Widget achievementsOwnedList(double medalWidth, double medalHeight) {
    List ownedAchievements = userAchievements.achievedAchievementList();
    // We own the newly made achievements, but we don't want to show them as owned yet.
    List achievementsEarned = scoreScreenChangeNotifier.getAchievementEarned();
    List show = ownedAchievements;
    show.removeWhere((item) => achievementsEarned.contains(item));
    return SizedBox(
        width: medalWidth,
        height: medalHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: show.length,
          itemBuilder: (context, index) {
            return achievementTile(context, show[index], medalHeight);
          },
        )
    );
  }

  Widget achievementsEarnedList(double medalWidth, double medalHeight) {
    List achievementsEarned = scoreScreenChangeNotifier.getAchievementEarned();
    return SizedBox(
      width: medalWidth,
      height: medalHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievementsEarned.length,
        itemBuilder: (context, index) {
          return achievementTile(context, achievementsEarned[index], medalHeight);
        },
      )
    );
  }

  Widget achievementsList(double medalWidth, double medalHeight, double fontSize) {
    List achievementsEarned = scoreScreenChangeNotifier.getAchievementEarned();
    double achievementGridHeight = medalHeight;
    double textHeight = achievementGridHeight / 10;
    if (achievementsEarned.isEmpty) {
      // no new achievements earned, show only the achievements owned.
      return Column(
          children: [
            SizedBox(
                height: textHeight,
                width: medalWidth,
                child: Text(
                    "Achievements owned",
                    style: TextStyle(
                        fontSize: (fontSize/4)*3,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFcba830)
                    )
                )
            ),
            achievementsOwnedGrid(medalWidth, achievementGridHeight - textHeight)
          ]
      );
    } else {
      double achievementEarnedHeight = ((achievementGridHeight / 3) * 2) - textHeight;
      double achievementOwnedHeight = (achievementGridHeight / 3) - textHeight;
      return Column(
        children: [
          SizedBox(
              height: textHeight,
              width: medalWidth,
              child: Text(
                  "New achievements!",
                  style: TextStyle(
                      fontSize: (fontSize/4)*3,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFcba830)
                  )
              )
          ),
          achievementsEarnedList(medalWidth, achievementEarnedHeight),
          SizedBox(
              height: textHeight,
              width: medalWidth,
              child: Text(
                  "Achievements owned",
                  style: TextStyle(
                      fontSize: (fontSize/4)*3,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFcba830)
                  )
              )
          ),
          achievementsOwnedList(medalWidth, achievementOwnedHeight),
        ],
      );
    }
  }

  Widget medalImage(double medalWidth, double medalHeight, double fontSize) {
    return Container(
      alignment: Alignment.center,
      width: medalWidth,
      height: medalHeight-10, // subtract the margin for the outer line.
      child: achievementsList(medalWidth, medalHeight-10, fontSize),
    );
  }

  Widget scoreSingleBirdDoubleBirdHeader(double scoreWidth, double scoreHeight, double fontSize) {
    String birdHeader = "single bird";
    if (scoreScreenChangeNotifier.isTwoPlayer()) {
      birdHeader = "double bird";
    }
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: Text(
          birdHeader,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFcba830)
          )
      ),
    );
  }

  Widget scoreNowHeader(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: Text(
        "Score",
        style: TextStyle(
          fontSize: fontSize*1.5,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFcba830)
        )
      ),
    );
  }

  Widget textWithBlackBorders(String text, double fontSize) {
    return Stack(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize*2-5,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = (fontSize / 2)
                ..color = Colors.black,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize*2-5,
            ),
          ),
        ]
    );
  }

  Widget scoreNow(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: textWithBlackBorders("${scoreScreenChangeNotifier.getScore()}", fontSize)
    );
  }

  Widget scoreBestHeader(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: Text(
        "Best",
        style: TextStyle(
          fontSize: fontSize*1.5,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFcba830)
        )
      ),
    );
  }

  Widget scoreBestDoubleBird(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: textWithBlackBorders("${userScore.getBestScoreDoubleBird()}", fontSize)
    );
  }

  Widget scoreBestSingleBird(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: textWithBlackBorders("${userScore.getBestScoreSingleBird()}", fontSize)
    );
  }

  Widget loginReminder(double width, double fontSize) {
    return Column(
      children: [
        expandedText(width, "Save your progress by logging in!", fontSize, false),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 20),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  _controller.jumpTo(0);
                  LoginScreenChangeNotifier().setLoginScreenVisible(true);
                },
                style: buttonStyle(false, Colors.blue),
                child: Container(
                  alignment: Alignment.center,
                  width: width/4,
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
        const SizedBox(height: 10),
        SizedBox(
          width: width,
          child: Row(
            children: [
              Expanded(
                  child: Text.rich(
                      TextSpan(
                          text: kIsWeb
                              ? "Also try Flutter Fly on Android or IOS!"
                              : "Also try Flutter Fly in your browser on flutterfly.eu",
                          style: simpleTextStyle(fontSize)
                      )
                  )
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget scoreScreenContent(double scoreWidth, double fontSize, double heightScale) {
    double leftWidth = (scoreWidth/2) - 30;
    double rightWidth = (scoreWidth/2) - 30;
    double totalHeight = scoreWidth/2;
    double medalHeaderHeight = totalHeight/6;
    double achievementHeight = (totalHeight/6)*5;
    User? currentUser = settings.getUser();

    double scoreHeight = (rightWidth/12)*3;
    return Column(
      children: [
        SizedBox(
          height: totalHeight,
          child:
          Row(
            children: <Widget>[
              Expanded(
                flex: 7, // 30%
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    medalHeader(leftWidth, medalHeaderHeight, fontSize),
                    medalImage(leftWidth, achievementHeight, fontSize),
                  ],
                ),
              ),
              Expanded(
                flex: 3, // 70%
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    scoreSingleBirdDoubleBirdHeader(rightWidth, (2*rightWidth)/12, fontSize),
                    scoreNowHeader(rightWidth, rightWidth/6, fontSize),
                    scoreNow(rightWidth, scoreHeight, fontSize),
                    scoreBestHeader(rightWidth, rightWidth/6, fontSize),
                    scoreScreenChangeNotifier.isTwoPlayer()
                        ? scoreBestDoubleBird(rightWidth, scoreHeight, fontSize)
                        : scoreBestSingleBird(rightWidth, scoreHeight, fontSize),
                  ],
                ),
              ),
            ],
          )
        ),
        currentUser == null ? loginReminder(scoreWidth-60, fontSize) : Container()
      ]
    );
  }

  Widget gameOverMessage(double heighScale) {
    double gameOverMessageWidth = 192 * heighScale * 1.5;
    double gameOverMessageHeight = 42 * heighScale * 1.5;
    return SizedBox(
      width: gameOverMessageWidth,
      height: gameOverMessageHeight,
      child: Image.asset(
        "assets/images/gameover.png",
        width: gameOverMessageWidth,
        height: gameOverMessageHeight,
        gaplessPlayback: true,
        fit: BoxFit.fill,
      )
    );
  }

  Widget userInteractionButtons(double scoreWidth, double fontSize) {
    double buttonHeight = 40;
    if (fontSize > 25) {
      buttonHeight = 60;
    }
    return SizedBox(
      width: scoreWidth,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: TextButton(
                onPressed: () {
                  nextScreen(false);
                },
                child: Container(
                  width: scoreWidth/3,
                  height: buttonHeight,
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
          ),
          Container(
            child: TextButton(
                onPressed: () {
                  getLeaderBoardSettings();
                  nextScreen(true);
                },
                child: Container(
                  width: scoreWidth/3,
                  height: buttonHeight,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Leaderboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget scoreContent(double scoreWidth, double fontSize, double heightScale) {
    return SizedBox(
      width: scoreWidth,
      height: scoreWidth/2,
      child: CustomPaint(
          painter: BoxWindowPainter(showTop: showTopScoreScreen, showBottom: showBottomScoreScreen),
          child: NotificationListener(
              child: SingleChildScrollView(
                  controller: _controller,
                  child: scoreScreenContent(scoreWidth, fontSize, heightScale)
              ),
              onNotification: (t) {
                checkTopBottomScroll();
                return true;
              }
          )
      ),
    );
  }

  nextScreen(bool goToLeaderboard) {
    setState(() {
      if (goToLeaderboard) {
        scoreScreenChangeNotifier.setScoreScreenVisible(false);
        LeaderBoardChangeNotifier leaderBoardChangeNotifier = LeaderBoardChangeNotifier();
        leaderBoardChangeNotifier.setTwoPlayer(scoreScreenChangeNotifier.isTwoPlayer());
        leaderBoardChangeNotifier.setLeaderBoardVisible(true);
      } else {
        scoreScreenChangeNotifier.setScoreScreenVisible(false);
        widget.game.startGame();
      }
    });
  }

  Widget scoreScreenWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double heightScale = height / 800;
    double scoreWidth = 800 * heightScale;
    double fontSize = 20 * heightScale;
    if (width < scoreWidth) {
      scoreWidth = width-100;
      // double newHeightScaleFont = width / 800;
      fontSize = 12 * heightScale;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        gameOverMessage(heightScale),
        scoreContent(scoreWidth, fontSize, heightScale),
        userInteractionButtons(scoreWidth, fontSize),
      ]
    );
  }

  getLeaderBoardSettings() {
    // Check if the user made the leaderboard of the week or month or even of all time.
    // If this is the case we want to automatically open on that selection.
    User? currentUser = settings.getUser();
    if (currentUser != null) {
      int currentScore = scoreScreenChangeNotifier.getScore();
      int rankingSelection = 4;
      if (!scoreScreenChangeNotifier.isTwoPlayer()) {
        rankingSelection = getRankingSelection(true, currentScore, settings);
      } else {
        rankingSelection = getRankingSelection(false, currentScore, settings);
      }
      LeaderBoardChangeNotifier().setRankingSelection(rankingSelection);
    }
  }

  tappedOutside() {
    if (tooltipShowing) {
      // Even if pressed in the score screen.
      // It will think it's outside the score screen if the tooltip is showing.
      return;
    }
    User? currentUser = settings.getUser();
    if (currentUser != null) {
      int tenthPosDayScore = -1;
      // If there aren't 10 scores yet, we will just set it to -1
      // so the current score is always higher. The user will have made the leaderboard
      if (settings.rankingsOnePlayerDay.length >= 10) {
        tenthPosDayScore = settings.rankingsOnePlayerDay[9].getScore();
        getLeaderBoardSettings();
      }
      if (scoreScreenChangeNotifier.getScore() > tenthPosDayScore) {
        // The user is now on the leaderboard so we will show it.
        nextScreen(true);
      } else {
        nextScreen(false);
      }
    } else {
      nextScreen(false);
    }
  }

  Widget scoreScreenOverlay(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  tappedOutside();
                },
                child: scoreScreenWidget(context)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: FractionalOffset.center,
        child: showScoreScreen ? scoreScreenOverlay(context) : Container()
    );
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
