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

  bool off = false;
  turnedOff() {
    position = Vector2(-100, 0);
    off = true;
  }

  turnedOn() {
    off = false;
    reset(gameRef.size.y);
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

    if (!off) {
      position = Vector2(initialPos.x, initialPos.y);
    }
  }

  double flapSpeed = defaultFlapSpeed;
  double velocityY = resetVelocityY;
  double accelerationY = defaultAccelerationY;
  double rotation = resetRotation;
  gameStarted() {
    flapSpeed = defaultFlapSpeed;
    velocityY = resetVelocityY;
    accelerationY = defaultAccelerationY;
    rotation = resetRotation;
  }

  reset(double screenSizeY) {
    heightScale = screenSizeY / 800;

    size.y = (screenSizeY / 10000) * 466;
    size.x = (size.y / butterflyHeight) * butterflyWidth;
    size.x = (size.x / butterflyWidth) * (butterflyWidth + 2);
    size.y = (size.y / butterflyHeight) * (butterflyHeight + 2);

    if (!off) {
      position = Vector2(initialPos.x, initialPos.y);
    }

    flapSpeed = defaultFlapSpeed;
    velocityY = resetVelocityY;
    accelerationY = defaultAccelerationY;
    rotation = resetRotation;
  }

  double startupTimer = 0.5;
  @override
  void update(double dt) {
    if (off) {
      return;
    }
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
    if (off) {
      return;
    }
    super.onGameResize(gameSize);
    heightScale = gameSize.y / 800;
    if (!gameRef.gameStarted) {
      if (!off) {
        position = Vector2(initialPos.x, initialPos.y);
      }
    }
  }
}
