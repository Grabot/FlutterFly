import 'package:flutter/material.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/services/game_settings.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/util/box_window_painter.dart';
import 'package:flutterfly/util/change_notifiers/game_settings_change_notifier.dart';
import 'package:flutterfly/util/util.dart';
import 'package:themed/themed.dart';


class GameSettingsBox extends StatefulWidget {

  final FlutterFly game;

  const GameSettingsBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  GameSettingsBoxState createState() => GameSettingsBoxState();
}

class GameSettingsBoxState extends State<GameSettingsBox> {

  // Used if any text fields are added to the profile.
  late GameSettingsChangeNotifier gameSettingsChangeNotifier;

  bool showGameSettings = false;
  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;
  bool normalMode = true;

  late GameSettings gameSettings;

  @override
  void initState() {
    gameSettingsChangeNotifier = GameSettingsChangeNotifier();
    gameSettingsChangeNotifier.addListener(gameSettingsChangeListener);

    // _focusGameSettingsBox.addListener(_onFocusChange);
    _controller.addListener(() {
      checkTopBottomScroll();
    });

    gameSettings = GameSettings();
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

  goBack() {
    setState(() {
      gameSettingsChangeNotifier.setGameSettingsVisible(false);
    });
  }

  gameSettingsChangeListener() {
    if (mounted) {
      if (!showGameSettings && gameSettingsChangeNotifier.getGameSettingsVisible()) {
        showGameSettings = true;
      }
      if (showGameSettings && !gameSettingsChangeNotifier.getGameSettingsVisible()) {
        showGameSettings = false;
      }
      setState(() {});
    }
  }

  Widget gameSettingsHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
                "Game settings",
                style: simpleTextStyle(fontSize)
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

  pressedPlayerChange(int playerType) {
    if (playerType == 1) {
      Settings().getLeaderBoardsOnePlayer();
    } else {
      Settings().getLeaderBoardsTwoPlayer();
    }
    if (gameSettings.getPlayerType() != playerType) {
      if (gameSettings.getButterflyType1() == gameSettings.getButterflyType2()) {
        if (gameSettings.getButterflyType2() == 0) {
          gameSettings.setButterflyType2(1);
          widget.game.changeButterfly2(1);
        } else {
          gameSettings.setButterflyType2(0);
          widget.game.changeButterfly2(0);
        }
      }
      gameSettings.setPlayerType(playerType);
      widget.game.changePlayer(playerType);
    }
  }

  pressedButterfly1Change(int butterflyType1) {
    if (gameSettings.getButterflyType1() != butterflyType1) {
      gameSettings.setButterflyType1(butterflyType1);
      widget.game.changeButterfly1(butterflyType1);
    }
  }

  pressedButterfly2Change(int butterflyType2) {
    if (gameSettings.getButterflyType2() != butterflyType2) {
      gameSettings.setButterflyType2(butterflyType2);
      widget.game.changeButterfly2(butterflyType2);
    }
  }

  Widget selectionButton(String imagePath, double imageWidth, double imageHeight, int selectionType, int category, bool selected) {
    double buttonWidth = imageWidth + 20;
    double buttonHeight = imageWidth + 20;
    double widthDiff = buttonWidth - imageWidth;
    double heightDiff = buttonHeight - imageHeight;

    return InkWell(
      onHover: (value) {
        setState(() {
        });
      },
      onTap: () {
        setState(() {
          if (category == 0) {
            _controller.jumpTo(0);
            pressedPlayerChange(selectionType);
          } else if (category == 1) {
            pressedButterfly1Change(selectionType);
          } else if (category == 2) {
            pressedButterfly2Change(selectionType);
          }
        });
      },
      child: Container(
        child: Stack(
          children: [
            Container(
              width: buttonWidth,
              height: buttonHeight,
              color: selected
                  ? Colors.blue[300]
                  : Colors.transparent,
            ),
            Row(
              children: [
                Container(
                  width: widthDiff/2,
                ),
                Column(
                    children: [
                      Container(
                          height: heightDiff/2
                      ),
                      SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ]
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }

  Widget nonSelectionButton(String imagePath, double imageWidth, double imageHeight) {
    double buttonWidth = imageWidth + 20;
    double buttonHeight = imageWidth + 20;
    double widthDiff = buttonWidth - imageWidth;
    double heightDiff = buttonHeight - imageHeight;

    return Container(
      child: Stack(
        children: [
          Container(
            width: buttonWidth,
            height: buttonHeight,
            color: Colors.transparent,
          ),
          Row(
              children: [
                Container(
                  width: widthDiff/2,
                ),
                Column(
                    children: [
                      Container(
                          height: heightDiff/2
                      ),
                      ChangeColors(
                        saturation: -1,
                        child: SizedBox(
                          width: imageWidth,
                          height: imageHeight,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ]
                ),
              ]
          ),
        ]
      ),
    );
  }

  List<String> playerImagePath = [
    'assets/images/ui/game_settings/player/2_butterflies.png',
    'assets/images/ui/game_settings/player/1_butterfly.png',
  ];

  Widget playerSelection(double gameSettingsWidth, double fontSize) {
    double imageSize = gameSettingsWidth / 6;
    if (imageSize > 100) {
      imageSize = 100;
    }
    return SizedBox(
      width: gameSettingsWidth,
      height: imageSize + 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(2, (int playerType) {
          bool selected = gameSettings.getPlayerType() == playerType;
          return selectionButton(playerImagePath[playerType], imageSize, imageSize, playerType, 0, selected);
        }),
      ),
    );
  }

  List<String> flutterFlyImagePath = [
    'assets/images/butterfly/settings/flutter_fly_red_settings.png',
    'assets/images/butterfly/settings/flutter_fly_blue_settings.png',
    'assets/images/butterfly/settings/flutter_fly_green_settings.png',
    'assets/images/butterfly/settings/flutter_fly_yellow_settings.png',
    'assets/images/butterfly/settings/flutter_fly_purple_settings.png',
    'assets/images/butterfly/settings/flutter_fly_white_settings.png',
    'assets/images/butterfly/settings/flutter_fly_black_settings.png',
  ];

  Widget butterflySelection1(double gameSettingsWidth, double fontSize) {
    double imageWidth = gameSettingsWidth / 6;
    if (imageWidth > 100) {
      imageWidth = 100;
    }
    double imageHeight = imageWidth * 0.71;
    return SizedBox(
      width: gameSettingsWidth,
      height: imageWidth + 20,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(flutterFlyImagePath.length, (int butterflyType1) {
            bool selected = gameSettings.getButterflyType1() == butterflyType1;
            if (gameSettings.getButterflyType2() == butterflyType1 && gameSettings.getPlayerType() == 0) {
              return nonSelectionButton(flutterFlyImagePath[butterflyType1], imageWidth, imageHeight);
            } else {
              return selectionButton(flutterFlyImagePath[butterflyType1], imageWidth, imageHeight,butterflyType1, 1, selected);
            }
          }),
      ),
    );
  }

  Widget butterflySelection2(double gameSettingsWidth, double fontSize) {
    int playerType = gameSettings.getPlayerType();
    // If the user has selected 2 butterflies, we don't want to show the same butterflies twice.
    double imageWidth = gameSettingsWidth / 6;
    if (imageWidth > 100) {
      imageWidth = 100;
    }
    double imageHeight = imageWidth * 0.71;
    if (playerType == 1) {
      if (gameSettings.getButterflyType1() == gameSettings.getButterflyType2()) {
        if (gameSettings.getButterflyType1() == 0) {
          pressedButterfly2Change(1);
        } else {
          pressedButterfly2Change(gameSettings.getButterflyType1()-1);
        }
      }
    }
    return SizedBox(
      width: gameSettingsWidth,
      height: imageWidth + 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(flutterFlyImagePath.length, (int butterflyType2) {
          bool selected = gameSettings.getButterflyType2() == butterflyType2;
          if (gameSettings.getButterflyType1() == butterflyType2) {
            return nonSelectionButton(flutterFlyImagePath[butterflyType2], imageWidth, imageHeight);
          } else {
            return selectionButton(
                flutterFlyImagePath[butterflyType2], imageWidth, imageHeight, butterflyType2, 2, selected);
          }
        }),
      ),
    );
  }

  List<String> pipeImagePath = [
    'assets/images/ui/game_settings/pipes/green_pipe.png',
    'assets/images/ui/game_settings/pipes/red_pipe.png',
  ];

  Widget playerSelectionRow(double gameSettingsWidth, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              const SizedBox(width: 20),
              Text(
                  "Player selection",
                  style: simpleTextStyle(fontSize)
              ),
            ]
        ),
        const SizedBox(height: 20),
        playerSelection(gameSettingsWidth, fontSize),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget flutterFly1SelectionRow(double gameSettingsWidth, double fontSize) {
    String flutterFlyText = "Butterfly selection";
    if (gameSettings.getPlayerType() == 0) {
      flutterFlyText = "Butterfly 1";
    }
    return Column(
        children: [
          Row(
              children: [
                const SizedBox(width: 20),
                Text(
                    flutterFlyText,
                    style: simpleTextStyle(fontSize)
                ),
              ]
          ),
          const SizedBox(height: 20),
          butterflySelection1(gameSettingsWidth, fontSize),
          const SizedBox(height: 40),
        ],
    );
  }

  Widget flutterFly2SelectionRow(double gameSettingsWidth, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              const SizedBox(width: 20),
              Text(
                  "Butterfly 2",
                  style: simpleTextStyle(fontSize)
              ),
            ]
        ),
        const SizedBox(height: 20),
        butterflySelection2(gameSettingsWidth, fontSize),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget gameSettingContent(double gameSettingsWidth, double fontSize) {

    return Column(
      children: [
        playerSelectionRow(gameSettingsWidth, fontSize),
        flutterFly1SelectionRow(gameSettingsWidth, fontSize),
        gameSettings.getPlayerType() == 0
            ? flutterFly2SelectionRow(gameSettingsWidth, fontSize) : Container(),
      ]
    );
  }

  Widget gameSettingsWindow(double totalWidth, double totalHeight) {
    // normal mode is for desktop, mobile mode is for mobile.
    normalMode = true;
    double heightScale = totalHeight / 800;
    double fontSize = 20 * heightScale;
    double width = 800;
    double height = (totalHeight / 10) * 6;
    // When the width is smaller than this we assume it's mobile.
    // If it's a mobile but it's landscaped, we also use normal mode.
    if (totalWidth <= 800) {
      width = totalWidth - 50;
      normalMode = false;
      // double newHeightScaleFont = width / 800;
      // fontSize = 20 * newHeightScaleFont;
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
                        gameSettingsHeader(width-80, headerHeight, fontSize),
                        const SizedBox(height: 20),
                        gameSettingContent(width-80, fontSize),
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

  Widget gameSettingsBoxScreen(BuildContext context) {
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
                      gameSettingsWindow(screenWidth, screenHeight),
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
      child: showGameSettings ? gameSettingsBoxScreen(context) : Container(),
    );
  }

}
