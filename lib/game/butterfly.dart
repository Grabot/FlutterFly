import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutterfly/game/bird_outline.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/game/pipe.dart';
import 'package:flutterfly/services/game_settings.dart';

class Butterfly extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<FlutterFly> {

  int butterflyType;
  Vector2 initialPos;
  BirdOutline butterflyOutline2;

  Butterfly({
    required this.butterflyType,
    required this.initialPos,
    required this.butterflyOutline2,
  }) : super(size: Vector2(85, 60));

  double heightScale = 1;

  late AudioPool wingPool;

  late GameSettings gameSettings;

  double butterflyWidth = 27;
  double butterflyHeight = 18;

  @override
  Future<void> onLoad() async {
    gameSettings = GameSettings();
    if (butterflyType == 0) {
      await loadButterfly("butterfly/flutter_fly_red.png");
    } else if (butterflyType == 1) {
      await loadButterfly("butterfly/flutter_fly_blue.png");
    } else if (butterflyType == 2) {
      await loadButterfly("butterfly/flutter_fly_green.png");
    } else if (butterflyType == 3) {
      await loadButterfly("butterfly/flutter_fly_yellow.png");
    } else if (butterflyType == 4) {
      await loadButterfly("butterfly/flutter_fly_purple.png");
    } else if (butterflyType == 5) {
      await loadButterfly("butterfly/flutter_fly_white.png");
    } else if (butterflyType == 6) {
      await loadButterfly("butterfly/flutter_fly_black.png");
    }

    return super.onLoad();
  }

  setInitialPos(Vector2 initialPosition) {
    initialPos = initialPosition;
    butterflyOutline2.setInitialPos(initialPosition);
  }

  setSize(Vector2 newSize) {
    size = newSize;
    butterflyOutline2.setSize(newSize);
  }

  loadButterfly(String birdImageName) async {
    add(CircleHitbox());

    final image = await Flame.images.load(birdImageName);
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.10,
      textureSize: Vector2(butterflyWidth, butterflyHeight),
    ));

    anchor = Anchor.center;

    heightScale = gameRef.size.y / 800;

    size.y = (gameRef.size.y / 10000) * 466;
    size.x = (size.y / butterflyHeight) * butterflyWidth;

    position = Vector2(initialPos.x, initialPos.y);

    wingPool = await FlameAudio.createPool(
      "wing.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );
    butterflyOutline2.loadBird("butterfly/flutter_fly_outline.png");
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
    butterflyOutline2.gameStarted();
  }

  reset(double screenSizeY) {
    heightScale = screenSizeY / 800;

    size.y = (screenSizeY / 10000) * 466;
    size.x = (size.y / butterflyHeight) * butterflyWidth;

    position = Vector2(initialPos.x, initialPos.y);
    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 5000;
    rotation = 0;
    butterflyOutline2.reset(screenSizeY);
  }

  @override
  onCollisionStart(_, PositionComponent other) async {
    if (other is Pipe) {
      if (other.birdType != butterflyType) {
        // We only want a collision with pipes that are the same colour.
        // Otherwise the bird flies behind or in front of it.
        return;
      }
    }
    if (!gameRef.gameEnded) {
      // For the death animation we set the velocity such that the bird flies up and then falls down
      velocityY = -1000;
      butterflyOutline2.velocityY = -1000;
      gameRef.gameOver();
    }
    super.onCollisionStart(_, other);
  }

  _updatePositionDeath(double dt) {
    double floorHeight = gameRef.size.y * 0.785;
    if (position.y >= floorHeight) {
      velocityY = 0;
      butterflyOutline2.velocityY = 0;
      return;
    }
    velocityY -= (((accelerationY * dt) / 2) * -1);
    position.y -= ((velocityY * dt) * heightScale) * -1;

    rotation = ((velocityY * -1) / butterflyHeight).clamp(-90, 90);
    angle = radians(rotation * -1);

    // There were issues syncing the position and rotation of the bird and the outline.
    // So we will decide these values here and set it on the outline.
    butterflyOutline2.angle = angle;
    butterflyOutline2.rotation = rotation;
    butterflyOutline2.position.y -= ((velocityY * dt) * heightScale) * -1;
  }

  _updatePositionGame(double dt) {
    velocityY -= (((accelerationY * dt) / 2) * -1);
    position.y -= ((velocityY * dt) * heightScale) * -1;

    rotation = ((velocityY * -1) / butterflyHeight).clamp(-90, 20);
    angle = radians(rotation * -1);

    // There were issues syncing the position and rotation of the bird and the outline.
    // So we will decide these values here and set it on the outline.
    butterflyOutline2.angle = angle;
    butterflyOutline2.rotation = rotation;
    butterflyOutline2.position.y -= ((velocityY * dt) * heightScale) * -1;
  }

  _updatePositionMenu(double dt) {
    if ((position.y > ((gameRef.size.y/2) + (20 * heightScale))) && accelerationY > 0) {
      accelerationY *= -1;
    }
    if ((position.y < ((gameRef.size.y/2) - (20 * heightScale))) && accelerationY < 0) {
      accelerationY *= -1;
    }
    velocityY -= (((accelerationY * dt) / 2) * -1);
    velocityY = velocityY.clamp(-250, 250);
    position.y -= ((velocityY * dt) * heightScale) * -1;

    rotation = ((velocityY * -1) / butterflyHeight).clamp(-90, 90);
    angle = radians(rotation * -1);

    // There were issues syncing the position and rotation of the bird and the outline.
    // So we will decide these values here and set it on the outline.
    butterflyOutline2.angle = angle;
    butterflyOutline2.rotation = rotation;
    butterflyOutline2.position.y -= ((velocityY * dt) * heightScale) * -1;
  }

  double startupTimer = 0.5;
  @override
  void update(double dt) {
    if (startupTimer > 0) {
      startupTimer -= dt;
      return;
    }
    if (!gameRef.gameStarted && !gameRef.gameEnded) {
      _updatePositionMenu(dt);
      super.update(dt);
    } else if (gameRef.gameEnded) {
      _updatePositionDeath(dt);
    } else {
      _updatePositionGame(dt);
      super.update(dt);
    }
  }

  fly() {
    velocityY = flapSpeed * -1;
    butterflyOutline2.velocityY = flapSpeed * -1;
    if (gameSettings.getSound()) {
      wingPool.start(volume: gameRef.soundVolume);
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    heightScale = gameSize.y / 800;
    if (!gameRef.gameStarted) {
      position = Vector2(initialPos.x, initialPos.y);
    }
  }

  changeBird(int newBirdType) async {
    if (newBirdType == 0 && newBirdType != butterflyType) {
      butterflyType = newBirdType;
      await loadButterfly("butterfly/flutter_fly_red.png");
    } else if (newBirdType == 1 && newBirdType != butterflyType) {
      butterflyType = newBirdType;
      await loadButterfly("butterfly/flutter_fly_blue.png");
    } else if (newBirdType == 2 && newBirdType != butterflyType) {
      butterflyType = newBirdType;
      await loadButterfly("butterfly/flutter_fly_green.png");
    } else if (newBirdType == 3 && newBirdType != butterflyType) {
      butterflyType = newBirdType;
      await loadButterfly("butterfly/flutter_fly_yellow.png");
    } else if (newBirdType == 4 && newBirdType != butterflyType) {
      butterflyType = newBirdType;
      await loadButterfly("butterfly/flutter_fly_purple.png");
    } else if (newBirdType == 5 && newBirdType != butterflyType) {
      butterflyType = newBirdType;
      await loadButterfly("butterfly/flutter_fly_white.png");
    } else if (newBirdType == 6 && newBirdType != butterflyType) {
      butterflyType = newBirdType;
      await loadButterfly("butterfly/flutter_fly_black.png");
    }
    butterflyOutline2.changeBird();
  }

  int getBirdType() {
    return butterflyType;
  }
}
