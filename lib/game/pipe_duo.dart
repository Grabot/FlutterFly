import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/game/pipe.dart';

class PipeDuo extends PositionComponent with HasGameRef<FlutterFly> {

  int butterflyType;

  PipeDuo({
    super.position,
    required this.butterflyType,
  });

  double pipe_gap = 300;
  double pipe_x = 0;

  double pipe_width = 52;
  double pipe_height = 400;

  static final Random _rng = Random();

  double heightScale = 1;

  Pipe? upper;
  Pipe? lower;

  double randomNumber = 0;

  double totalShiftX = 0;

  bool passedButterfly1 = false;
  bool passedButterfly2 = false;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    heightScale = gameRef.size.y / 800;

    pipe_height = (400 * heightScale) * 1.5;
    pipe_width = (52 * heightScale) * 1.5;

    randomNumber = _rng.nextDouble();

    spawnNewPipes();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (gameRef.gameStarted) {
      if (position.x < -(pipe_x + pipe_width)) {
        gameRef.removePipe(this);
      }
      double change = (gameRef.speed * dt) * heightScale;
      position.x -= change;
      totalShiftX += change;
    }
    super.update(dt);
  }

  pipePassedButterfly1() {
    passedButterfly1 = true;
  }
  pipePassedButterfly2() {
    passedButterfly2 = true;
  }

  spawnNewPipes() {
    addAll(createRandomPipes());
  }

  List<Pipe> createRandomPipes() {

    double gapY = randomNumber * (800 * heightScale) * 0.45 - (pipe_gap * heightScale);
    gapY += ((800 * heightScale) * 0.5).toInt();

    pipe_x = position.x + pipe_width + pipe_gap;

    double uLower = (800 * heightScale) + (gapY - (pipe_gap * heightScale));

    Pipe lowerPipe = Pipe(
      position: Vector2(0, uLower),
      butterflyType: butterflyType,
    )..priority = priority;

    double yUpper = uLower - (pipe_gap * heightScale) - pipe_height;
    Pipe upperPipe = Pipe(
      position: Vector2(0, yUpper),
      butterflyType: butterflyType,
    )..priority = priority;

    upper = upperPipe;
    lower = lowerPipe;
    return [lower!, upper!];
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;

    pipe_height = (400 * heightScale) * 1.5;
    pipe_width = (52 * heightScale) * 1.5;
    super.onGameResize(gameSize);
  }

}