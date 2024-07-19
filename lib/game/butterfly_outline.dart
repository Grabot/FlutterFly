import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutterfly/constants/flutterfly_constant.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/services/game_settings.dart';

class ButterflyOutline extends SpriteAnimationComponent with HasGameRef<FlutterFly> {

  Vector2 initialPos;
  ButterflyOutline({
    required this.initialPos,
  }) : super(size: Vector2(95, 70));

  double heightScale = 1;

  late GameSettings gameSettings;

  @override
  Future<void> onLoad() async {
    gameSettings = GameSettings();
    loadButterfly("butterfly/flutter_fly_outline.png");

    return super.onLoad();
  }

  setInitialPos(Vector2 initialPosition) {
    initialPos = initialPosition;
    initialPos.x -= 1;
    initialPos.y -= 1;
  }

  setSize(Vector2 newSize) {
    size = newSize;
    size.x = (size.x / butterflyWidth) * (butterflyWidth + 2);
    size.y = (size.y / butterflyHeight) * (butterflyHeight + 2);
  }

  loadButterfly(String butterflyImageName) async {
    final image = await Flame.images.load(butterflyImageName);
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.10,
      textureSize: Vector2((butterflyWidth + 2), (butterflyHeight + 2)),
    ));
    anchor = Anchor.center;

    heightScale = gameRef.size.y / 800;

    size.y = (gameRef.size.y / 10000) * 466;
    size.x = (size.y / butterflyHeight) * butterflyWidth;
    size.x = (size.x / butterflyWidth) * (butterflyWidth + 2);
    size.y = (size.y / butterflyHeight) * (butterflyHeight + 2);

    position = Vector2(initialPos.x, initialPos.y);
  }

  double flapSpeed = 600;
  double velocityY = 0;
  double accelerationY = 5000;
  double rotation = 0;
  gameStarted() {
    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 5000;
    rotation = 0;
  }

  reset(double screenSizeY) {
    heightScale = screenSizeY / 800;

    size.y = (screenSizeY / 10000) * 466;
    size.x = (size.y / butterflyHeight) * butterflyWidth;
    size.x = (size.x / butterflyWidth) * (butterflyWidth + 2);
    size.y = (size.y / butterflyHeight) * (butterflyHeight + 2);

    position = Vector2(initialPos.x, initialPos.y);

    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 5000;
    rotation = 0;
  }

  double startupTimer = 0.5;
  @override
  void update(double dt) {
    if (startupTimer > 0) {
      startupTimer -= dt;
      return;
    }
    if (!gameRef.gameStarted && !gameRef.gameEnded) {
      super.update(dt);
    } else if (gameRef.gameEnded) {
      return;
    } else {
      super.update(dt);
    }
  }

  fly() {
    velocityY = flapSpeed * -1;
  }

  changeButterfly() {
    loadButterfly("butterfly/flutter_fly_outline.png");
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    heightScale = gameSize.y / 800;
    if (!gameRef.gameStarted) {
      position = Vector2(initialPos.x, initialPos.y);
    }
  }
}
