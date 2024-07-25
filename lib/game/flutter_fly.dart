import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfly/constants/flutterfly_constant.dart';
import 'package:flutterfly/game/butterfly.dart';
import 'package:flutterfly/game/butterfly_outline.dart';
import 'package:flutterfly/game/floor.dart';
import 'package:flutterfly/game/help_message.dart';
import 'package:flutterfly/game/pipe_duo.dart';
import 'package:flutterfly/game/score_indicator.dart';
import 'package:flutterfly/models/user.dart';
import 'package:flutterfly/services/game_settings.dart';
import 'package:flutterfly/services/rest/auth_service_flutter_fly.dart';
import 'package:flutterfly/services/rest/auth_service_leaderboard.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/services/user_achievements.dart';
import 'package:flutterfly/services/user_score.dart';
import 'package:flutterfly/util/change_notifiers/leader_board_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/score_screen_change_notifier.dart';
import 'sky.dart';

class FlutterFly extends FlameGame with MultiTouchTapDetector, HasCollisionDetection, KeyboardEvents {

  FocusNode gameFocus;
  FlutterFly(this.gameFocus);

  bool playFieldFocus = true;

  bool twoPlayers = true;
  late final Butterfly butterfly1;
  late final Butterfly butterfly2;
  late final ButterflyOutline butterflyOutlineButterfly1;
  late final ButterflyOutline butterflyOutlineButterfly2;

  bool gameStarted = false;
  bool gameEnded = false;
  double speed = 130;
  double heightScale = 1;

  PipeDuo? lastPipeDuoButterfly1;
  PipeDuo? lastPipeDuoButterfly2;
  double pipeBuffer = 1000;
  double pipeGap = 300;
  double pipeInterval = 0;

  late HelpMessage helpMessage;
  late Sky sky;
  late ScoreIndicator scoreIndicator;

  double timeSinceEnded = 0;

  double soundVolume = 1.0;

  int score = 0;

  late AudioPool pointPool;
  late AudioPool diePool;
  late AudioPool hitPool;

  double deathTimer = 1;
  bool death = false;
  bool deathTimeEnded = false;
  bool scoreRemoved = false;

  double frameTimes = 0.0;
  int frames = 0;
  int fps = 0;
  int variant = 0;

  List<PipeDuo> pipesButterfly1 = [];
  List<PipeDuo> pipesButterfly2 = [];

  late ScoreScreenChangeNotifier scoreScreenChangeNotifier;
  late LeaderBoardChangeNotifier leaderBoardChangeNotifier;
  late Settings settings;
  late GameSettings gameSettings;
  late UserScore userScore;
  late UserAchievements userAchievements;

  int flutters = 0;
  int pipesCleared = 0;
  int gameOvers = 0;
  int nightTimeScore = 0;

  bool dataLoaded = false;
  late Vector2 initialPosButterfly1;

  int pipeButterfly1Priority = 0;
  int pipeButterfly2Priority = 2;

  bool spaceBarUsed = false;

  Vector2 butterflySize = Vector2(85, 60);

  @override
  Future<void> onLoad() async {
    sky = Sky();
    heightScale = size.y / 800;

    Vector2 initialPosButterfly2 = determineButterflyPos(size);

    butterflyOutlineButterfly1 = ButterflyOutline(
        initialPos: initialPosButterfly1
    )..priority = 10;
    butterflyOutlineButterfly2 = ButterflyOutline(
        initialPos: initialPosButterfly2
    )..priority = 10;
    butterfly1 = Butterfly(
      butterflyType: 0,
      initialPos: initialPosButterfly1,
      butterflyOutline2: butterflyOutlineButterfly1,
    )..priority = 1;
    butterfly2 = Butterfly(
        butterflyType: 1,
        initialPos: initialPosButterfly2,
        butterflyOutline2: butterflyOutlineButterfly2
    )..priority = 3;

    helpMessage = HelpMessage()..priority = 10;
    scoreIndicator = ScoreIndicator();
    add(sky);
    add(butterflyOutlineButterfly1);
    add(butterflyOutlineButterfly2);
    add(butterfly1);
    add(butterfly2);
    butterfly2.turnedOn();
    add(Floor());
    add(helpMessage);
    add(ScreenHitbox());

    double pipeWidth = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipeWidth;
    pipeBuffer = size.x + pipeInterval;

    // We create a pipe off screen to the left,
    // this helps the creation of the pipes later for some reason
    double pipeX = -pipeWidth-50;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
      butterflyType: butterfly1.getButterflyType(),
    )..priority = pipeButterfly1Priority;
    newPipeDuo.pipePassedButterfly1();
    newPipeDuo.pipePassedButterfly2();
    add(newPipeDuo);

    pointPool = await FlameAudio.createPool(
      "point.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );
    diePool = await FlameAudio.createPool(
      "die.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );
    hitPool = await FlameAudio.createPool(
      "hit.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );

    scoreScreenChangeNotifier = ScoreScreenChangeNotifier();
    leaderBoardChangeNotifier = LeaderBoardChangeNotifier();
    settings = Settings();
    gameSettings = GameSettings();
    gameSettings.addListener(settingsChangeListener);
    userScore = UserScore();
    userAchievements = UserAchievements();
    settingsChangeListener();
    dataLoaded = true;

    // to avoid any remaining issues with the outline not matching
    // We will reset the butterflies
    butterfly1.reset(size.y);
    butterfly2.reset(size.y);
    return super.onLoad();
  }

  startGame() {
    if (!scoreScreenChangeNotifier.showScoreScreen && !leaderBoardChangeNotifier.showLeaderBoard) {
      timeSinceEnded = 0;
      score = 0;
      scoreScreenChangeNotifier.clearAchievementList();
      gameEnded = false;
      add(helpMessage);
      if (!scoreRemoved) {
        scoreIndicator.scoreChange(0);
        remove(scoreIndicator);
      }
      scoreRemoved = true;
      deathTimeEnded = false;
      clearPipes();
      butterfly1.reset(size.y);
      if (twoPlayers) {
        butterfly2.reset(size.y);
      }
      sky.reset();
    }
  }

  butterflyInteraction(Butterfly butterfly) {
    if (!gameStarted && !gameEnded) {
      // start game
      gameStarted = true;
      death = false;
      deathTimer = 1;
      butterfly1.gameStarted();
      if (twoPlayers) {
        butterfly2.gameStarted();
      }
      remove(helpMessage);
      add(scoreIndicator);
      scoreRemoved = false;
      spawnInitialPipes();
      butterfly.fly();
    } else if (!gameStarted && gameEnded) {
      // go to the main screen with help message
      if (timeSinceEnded < 0.4) {
        // We assume the user tried to fly
        return;
      }
      flutters = 0;
      pipesCleared = 0;
      startGame();
    } else if (gameStarted) {
      // game running
      butterfly.fly();
      flutters += 1;
    }
  }

  @override
  Future<void> onTapUp(int pointerId, TapUpInfo tapUpInfo) async {
    Vector2 screenPos = tapUpInfo.eventPosition.global;
    if (twoPlayers) {
      // If the user has pressed the space bar
      // than the user can click anywhere for the first butterfly
      if (spaceBarUsed) {
        butterflyInteraction(butterfly1);
      } else {
        // If the user is not using the space bar we will decide they are
        // behind a mobile. Left side is left butterfly, right side is right butterfly.
        if (screenPos.x > size.x / 2) {
          butterflyInteraction(butterfly1);
        } else {
          butterflyInteraction(butterfly2);
        }
      }
    } else {
      butterflyInteraction(butterfly1);
    }
    super.onTapUp(pointerId, tapUpInfo);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is KeyDownEvent;

    if (!playFieldFocus && isKeyDown) {
      return KeyEventResult.ignored;
    } else {
      if (event.logicalKey == LogicalKeyboardKey.space && isKeyDown) {
        // If the user has pressed the space bar even once,
        // we will know they are behind a desktop
        spaceBarUsed = true;
        if (twoPlayers) {
          butterflyInteraction(butterfly2);
        } else {
          // In single butterfly mode you can use the mouse click or the space bar.
          butterflyInteraction(butterfly1);
        }
      }
      return KeyEventResult.handled;
    }
  }

  checkingAchievements() async {
    // First check the medal achievements
    if (!twoPlayers) {
      if (!userAchievements.getWoodSingle()) {
        if (score >= 10) {
          userAchievements.achievedWoodSingle();
          scoreScreenChangeNotifier.addAchievement(userAchievements.woodSingleAchievement);
        }
      }
      if (!userAchievements.getBronzeSingle()) {
        if (score >= 25) {
          userAchievements.achievedBronzeSingle();
          scoreScreenChangeNotifier.addAchievement(userAchievements.bronzeSingleAchievement);
        }
      }
      if (!userAchievements.getSilverSingle()) {
        if (score >= 50) {
          userAchievements.achievedSilverSingle();
          scoreScreenChangeNotifier.addAchievement(userAchievements.silverSingleAchievement);
        }
      }
      if (!userAchievements.getGoldSingle()) {
        if (score >= 100) {
          userAchievements.achievedGoldSingle();
          scoreScreenChangeNotifier.addAchievement(userAchievements.goldSingleAchievement);
        }
      }
    } else {
      if (!userAchievements.getWoodDouble()) {
        if (score >= 10) {
          userAchievements.achievedWoodDouble();
          scoreScreenChangeNotifier.addAchievement(userAchievements.woodDoubleAchievement);
        }
      }
      if (!userAchievements.getBronzeDouble()) {
        if (score >= 25) {
          userAchievements.achievedBronzeDouble();
          scoreScreenChangeNotifier.addAchievement(userAchievements.bronzeDoubleAchievement);
        }
      }
      if (!userAchievements.getSilverDouble()) {
        if (score >= 50) {
          userAchievements.achievedSilverDouble();
          scoreScreenChangeNotifier.addAchievement(userAchievements.silverDoubleAchievement);
        }
      }
      if (!userAchievements.getGoldDouble()) {
        if (score >= 100) {
          userAchievements.achievedGoldDouble();
          scoreScreenChangeNotifier.addAchievement(userAchievements.goldDoubleAchievement);
        }
      }
    }
    // Then check the play achievements
    if (!userAchievements.getFlutterOne()) {
      if (userScore.getTotalFlutters() > 1000) {
        userAchievements.achievedFlutterOne();
        scoreScreenChangeNotifier.addAchievement(userAchievements.flutterOneAchievement);
      }
    }
    if (!userAchievements.getFlutterTwo()) {
      if (userScore.getTotalFlutters() > 2500) {
        userAchievements.achievedFlutterTwo();
        scoreScreenChangeNotifier.addAchievement(userAchievements.flutterTwoAchievement);
      }
    }
    if (!userAchievements.getFlutterThree()) {
      if (userScore.getTotalFlutters() > 10000) {
        userAchievements.achievedFlutterThree();
        scoreScreenChangeNotifier.addAchievement(userAchievements.flutterThreeAchievement);
      }
      if (!userAchievements.getFlutterFour()) {
        if (userScore.getTotalFlutters() > 50000) {
          userAchievements.achievedFlutterFour();
          scoreScreenChangeNotifier.addAchievement(userAchievements.flutterFourAchievement);
        }
      }
    }
    if (!userAchievements.getPipesOne()) {
      if (userScore.getTotalPipesCleared() > 250) {
        userAchievements.achievedPipesOne();
        scoreScreenChangeNotifier.addAchievement(userAchievements.pipesOneAchievement);
      }
    }
    if (!userAchievements.getPipesTwo()) {
      if (userScore.getTotalPipesCleared() > 1000) {
        userAchievements.achievedPipesTwo();
        scoreScreenChangeNotifier.addAchievement(userAchievements.pipesTwoAchievement);
      }
    }
    if (!userAchievements.getPipesThree()) {
      if (userScore.getTotalPipesCleared() > 5000) {
        userAchievements.achievedPipesThree();
        scoreScreenChangeNotifier.addAchievement(userAchievements.pipesThreeAchievement);
      }
    }
    if (!userAchievements.getPerseverance()) {
      if (gameOvers >= 50) {
        userAchievements.achievedPerseverance();
        scoreScreenChangeNotifier.addAchievement(userAchievements.perseveranceAchievement);
      }
    }
    DateTime current = DateTime.now();
    if (!userAchievements.getNightOwl()) {
      if (current.hour >= 0 && current.hour <= 2) {
        // It is after midnight so check if the user got the night owl achievement
        nightTimeScore += score;
        if (nightTimeScore > 20) {
          userAchievements.achievedNightOwl();
          scoreScreenChangeNotifier.addAchievement(userAchievements.nightOwlAchievement);
        }
      }
    }
    bool updatedWingedWarrior = false;
    if (!userAchievements.getWingedWarrior()) {
      if (userAchievements.checkWingedWarrior(scoreScreenChangeNotifier)) {
        updatedWingedWarrior = true;
      }
    }
    if (userAchievements.checkPlatforms()) {
      scoreScreenChangeNotifier.addAchievement(userAchievements.platformsAchievement);
      userAchievements.platformsAchievementShown();
    }
    User? currentUser = settings.getUser();
    if (currentUser != null) {
      if (!userAchievements.getLeaderboard()) {
        if (settings.checkIfTop3(twoPlayers, score)) {
          userAchievements.achievedLeaderboard();
          scoreScreenChangeNotifier.addAchievement(userAchievements.leaderboardAchievement);
        }
      }
      if (scoreScreenChangeNotifier.getAchievementEarned().isNotEmpty || updatedWingedWarrior) {
        AuthServiceFlutterFly().updateAchievements(userAchievements.getAchievements()).then((result) {
          if (result.getResult()) {
            // we have updated the score in the db. Do nothing
          }
        });
      }
    }
  }

  gameOver() async {
    if (gameStarted && !gameEnded) {
      if (gameSettings.getSound()) {
        hitPool.start(volume: soundVolume);
        diePool.start(volume: soundVolume);
      }
      gameOvers += 1;
      death = true;
      gameStarted = false;
      gameEnded = true;
      userScore.addTotalFlutters(flutters);
      userScore.addTotalPipesCleared(pipesCleared);
      userScore.addTotalGames(1);
      User? currentUser = settings.getUser();
      if (currentUser != null) {
        if (twoPlayers) {
          AuthServiceFlutterFly().updateUserScore(null, score, userScore.getScore()).then((result) {
            if (result.getResult()) {
              // we have updated the score in the db. Do nothing
            }
          });
        } else {
          AuthServiceFlutterFly().updateUserScore(score, null, userScore.getScore()).then((result) {
            if (result.getResult()) {
              // we have updated the score in the db. Do nothing
            }
          });
        }
      }
      checkingAchievements();
      sky.gameOver();
    }
  }

  Future<void> clearPipes() async {
    for (PipeDuo pipeDuo in pipesButterfly1) {
      remove(pipeDuo);
    }
    pipesButterfly1.clear();
    for (PipeDuo pipeDuo in pipesButterfly2) {
      remove(pipeDuo);
    }
    pipesButterfly2.clear();
    lastPipeDuoButterfly1 = null;
    lastPipeDuoButterfly2 = null;

    double pipeWidth = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipeWidth;
    pipeBuffer = size.x + pipeInterval;
    // We create a pipe off screen to the left,
    // this helps the creation of the pipes later for some reason
    double pipeX = -pipeWidth-50;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
      butterflyType: butterfly1.getButterflyType(),
    )..priority = pipeButterfly1Priority;
    newPipeDuo.pipePassedButterfly1();
    newPipeDuo.pipePassedButterfly2();
    add(newPipeDuo);
    if (twoPlayers) {
      PipeDuo newPipeDuo2 = PipeDuo(
        position: Vector2(pipeX, 0),
        butterflyType: butterfly2.getButterflyType(),
      )..priority = pipeButterfly2Priority;
      newPipeDuo2.pipePassedButterfly1();
      newPipeDuo2.pipePassedButterfly2();
      add(newPipeDuo2);
    }
  }

  removePipe(PipeDuo pipeDuo) {
    if (twoPlayers) {
      if (butterfly1.getButterflyType() == pipeDuo.butterflyType) {
        pipesButterfly1.remove(pipeDuo);
        remove(pipeDuo);
      } else if (butterfly2.getButterflyType() == pipeDuo.butterflyType) {
        pipesButterfly2.remove(pipeDuo);
        remove(pipeDuo);
      } else {
        remove(pipeDuo);
      }
    } else {
      pipesButterfly1.remove(pipeDuo);
      remove(pipeDuo);
    }
  }

  Future<void> spawnInitialPipes() async {
    double pipeX = pipeBuffer;
    PipeDuo newPipeDuo1 = PipeDuo(
      position: Vector2(pipeX, 0),
      butterflyType: butterfly1.getButterflyType(),
    )..priority = pipeButterfly1Priority;
    add(newPipeDuo1);
    lastPipeDuoButterfly1 = newPipeDuo1;
    pipesButterfly1.add(newPipeDuo1);
    if (twoPlayers) {
      PipeDuo newPipeDuo2 = PipeDuo(
        position: Vector2(pipeX + 50, 0),
        butterflyType: butterfly2.getButterflyType(),
      )..priority = pipeButterfly2Priority;
      add(newPipeDuo2);
      lastPipeDuoButterfly2 = newPipeDuo2;
      pipesButterfly2.add(newPipeDuo2);
    }

    pipeX -= pipeInterval;
    while(pipeX > initialPosButterfly1.x + pipeInterval) {
      PipeDuo newPipeDuo1 = PipeDuo(
        position: Vector2(pipeX, 0),
        butterflyType: butterfly1.getButterflyType(),
      )..priority = pipeButterfly1Priority;
      add(newPipeDuo1);
      pipesButterfly1.add(newPipeDuo1);
      if (twoPlayers) {
        PipeDuo newPipeDuo2 = PipeDuo(
          position: Vector2(pipeX + 50, 0),
          butterflyType: butterfly2.getButterflyType(),
        )..priority = pipeButterfly2Priority;
        add(newPipeDuo2);
        lastPipeDuoButterfly2 = newPipeDuo2;
        pipesButterfly2.add(newPipeDuo2);
      }
      pipeX -= pipeInterval;
    }
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if (gameStarted) {
      if (lastPipeDuoButterfly1 != null) {
        if (lastPipeDuoButterfly1!.position.x < pipeBuffer - pipeInterval) {
          PipeDuo newPipeDuo = PipeDuo(
            position: Vector2(pipeBuffer, 0),
            butterflyType: butterfly1.getButterflyType(),
          )..priority = pipeButterfly1Priority;
          add(newPipeDuo);
          pipesButterfly1.add(newPipeDuo);
          lastPipeDuoButterfly1 = newPipeDuo;
          if (twoPlayers) {
            PipeDuo newPipeDuo2 = PipeDuo(
              position: Vector2(pipeBuffer + 50, 0),
              butterflyType: butterfly2.getButterflyType(),
            )..priority = pipeButterfly2Priority;
            add(newPipeDuo2);
            lastPipeDuoButterfly2 = newPipeDuo2;
            pipesButterfly2.add(newPipeDuo2);
          }
        }
      }
      checkPipePassed();
      checkOutOfBounds();
    } else if (gameEnded && !deathTimeEnded) {
      bool isHighScore = false;
      if (twoPlayers) {
        if (score > userScore.getBestScoreDoubleButterfly()) {
          isHighScore = true;
          userScore.setBestScoreDoubleButterfly(score);
        }
      } else {
        if (score > userScore.getBestScoreSingleButterfly()) {
          isHighScore = true;
          userScore.setBestScoreSingleButterfly(score);
        }
      }
      scoreScreenChangeNotifier.setScore(score, isHighScore);
      timeSinceEnded += dt;
      if (deathTimer <= 0) {
        // Show the game over screen
        if (!scoreRemoved) {
          scoreIndicator.scoreChange(0);
          remove(scoreIndicator);
        }
        scoreRemoved = true;
        if (!scoreScreenChangeNotifier.getScoreScreenVisible()) {
          scoreScreenChangeNotifier.setScoreScreenVisible(true);
          scoreScreenChangeNotifier.setTwoPlayer(twoPlayers);
          // update leaderboard score
          User? currentUser = Settings().getUser();
          if (currentUser != null) {
            if (settings.checkIfTop10(twoPlayers, score)) {
              if (!twoPlayers) {
                AuthServiceLeaderboard().updateLeaderboardOnePlayer(score).then((value) {
                  if (value.getResult()) {
                    // do nothing, should be updated with socket connection
                  }
                });
              } else {
                AuthServiceLeaderboard().updateLeaderboardTwoPlayers(score).then((value) {
                  if (value.getResult()) {
                    // do nothing, should be updated with socket connection
                  }
                });
              }
            }
          }
        }
        deathTimeEnded = true;
      }
      deathTimer -= dt;
    }
    updateFps(dt);
  }

  updateFps(double dt) {
    frameTimes += dt;
    frames += 1;

    if (frameTimes >= 1) {
      fps = frames;
      // print("fps: $fps");
      frameTimes = 0;
      frames = 0;
    }
  }

  checkPipePassed() {
    for (PipeDuo pipe in pipesButterfly1) {
      if (twoPlayers) {
        if (pipe.passedButterfly1 && pipe.passedButterfly2) {
          continue;
        }
      } else {
        if (pipe.passedButterfly1) {
          continue;
        }
      }

      if ((pipe.position.x < butterfly1.position.x) && !pipe.passedButterfly1) {
        pipe.pipePassedButterfly1();
        score += 1;
        scoreIndicator.scoreChange(score);
        pipesCleared += 1;
        if (gameSettings.getSound()) {
          pointPool.start(volume: soundVolume);
        }
      }
      if (twoPlayers) {
        if (pipe.position.x < butterfly2.position.x) {
          pipe.pipePassedButterfly2();
        }
      }
    }
    for (PipeDuo pipe in pipesButterfly2) {
      if (twoPlayers) {
        if (pipe.passedButterfly1 && pipe.passedButterfly2) {
          continue;
        }
      }

      if ((pipe.position.x < butterfly1.position.x) && !pipe.passedButterfly1) {
        pipe.pipePassedButterfly1();
      }
      if (twoPlayers) {
        if (pipe.position.x < butterfly2.position.x) {
          pipe.pipePassedButterfly2();
          score += 1;
          scoreIndicator.scoreChange(score);
          pipesCleared += 1;
          if (gameSettings.getSound()) {
            pointPool.start(volume: soundVolume);
          }
        }
      }
    }
  }

  checkOutOfBounds() {
    // There is a bug where the butterfly can go out of bounds when the frame rate drops and the
    // acceleration gets super high. The collision with the screen is not triggered and the
    // butterfly flies below all the pipes and gets all the points.
    // We add this simple check to ensure that this bug is not exploited.
    if (butterfly1.position.y < -100) {
      gameOver();
    } else if (butterfly1.position.y > (size.y + 100)) {
      gameOver();
    }
    if (twoPlayers) {
      if (butterfly2.position.y < -100) {
        gameOver();
      } else if (butterfly2.position.y > (size.y + 100)) {
        gameOver();
      }
    }
  }

  Vector2 determineButterflyPos(Vector2 gameSize) {
    butterflySize.y = (gameSize.y / 10000) * 466;
    butterflySize.x = (butterflySize.y / butterflyHeight) * butterflyWidth;

    // The butterfly is anchored in the center, so subtract half of himself.
    double butterflySeparationX = gameSize.x / 100;
    // Add separation on side of the screen for the first butterfly and the between the butterflies themselves.
    double butterfly1PosX = butterflySize.x - (butterflySize.x / 2) + butterflySeparationX;
    double butterfly2PosX = butterfly1PosX + butterflySize.x + butterflySeparationX;
    initialPosButterfly1 = Vector2(butterfly2PosX, (gameSize.y/2));
    return Vector2(butterfly1PosX, (gameSize.y/2));
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;
    double pipeWidth = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipeWidth;
    pipeBuffer = gameSize.x + pipeInterval;

    Vector2 initialPosButterfly2 = determineButterflyPos(gameSize);

    if (dataLoaded) {
      butterfly1.setInitialPos(initialPosButterfly1);
      butterfly1.reset(gameSize.y);
      if (twoPlayers) {
      butterfly2.setInitialPos(initialPosButterfly2);
      butterfly2.reset(gameSize.y);
      }
    }
    super.onGameResize(gameSize);
  }

  settingsChangeListener() {
    if (gameSettings.getPlayerType() != 0) {
      settings.getLeaderBoardsOnePlayer();
      twoPlayers = false;
      helpMessage.updateMessageImage(size);
      butterfly2.turnedOff();
      butterfly1.reset(size.y);
      clearPipes();
      speed = 160;
    }
    if (gameSettings.getPlayerType() != 1) {
      settings.getLeaderBoardsTwoPlayer();
      twoPlayers = true;
      helpMessage.updateMessageImage(size);

      butterflySize.y = (size.y / 10000) * 466;
      butterflySize.x = (butterflySize.y / butterflyHeight) * butterflyWidth;

      Vector2 initialPosButterfly2 = determineButterflyPos(size);
      butterfly2.setInitialPos(initialPosButterfly2);
      butterfly2.reset(size.y);
      butterfly2.turnedOn();
      butterfly1.reset(size.y);
      clearPipes();
      speed = 130;
    }
    if (gameSettings.getButterflyType1() != butterfly1.getButterflyType()) {
      butterfly1.changeButterfly(gameSettings.getButterflyType1());
      clearPipes();
    }
    if (gameSettings.getButterflyType2() != butterfly2.getButterflyType()) {
      if (twoPlayers) {
        butterfly2.changeButterfly(gameSettings.getButterflyType2());
        clearPipes();
      }
    }
  }

  changePlayer(int playerType) async {
    if (playerType == 0) {
      twoPlayers = true;
      speed = 130;
      helpMessage.updateMessageImage(size);
      settings.getLeaderBoardsTwoPlayer();

      butterflySize.y = (size.y / 10000) * 466;
      butterflySize.x = (butterflySize.y / butterflyHeight) * butterflyWidth;

      Vector2 initialPosButterfly2 = determineButterflyPos(size);
      butterfly2.setInitialPos(initialPosButterfly2);
      butterfly1.reset(size.y);
      butterfly2.reset(size.y);
      butterfly2.turnedOn();

      clearPipes();
    } else {
      twoPlayers = false;
      speed = 160;
      helpMessage.updateMessageImage(size);
      butterfly1.reset(size.y);
      butterfly2.turnedOff();
      clearPipes();
    }
  }

  changeButterfly1(int butterflyType1) async {
    butterfly1.changeButterfly(butterflyType1);
    clearPipes();
  }
  changeButterfly2(int butterflyType2) async {
    butterfly2.changeButterfly(butterflyType2);
    clearPipes();
  }

  focusGame() {
    gameFocus.requestFocus();
  }
}
