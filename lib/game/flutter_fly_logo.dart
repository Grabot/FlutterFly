import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfly/game/flutter_fly.dart';

class FlutterFlyLogo extends SpriteComponent with HasGameRef<FlutterFly> {

  FlutterFlyLogo();

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    updateMessageImage(gameRef.size);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) async {
    super.onGameResize(gameSize);
    position = Vector2(gameSize.x / 2, gameSize.y / 2);
    position.y -= gameSize.y / 3;
    double heightScale = gameRef.size.y / 800;

    if (gameSize.x <= 800 || gameSize.y > gameSize.x) {
      size = Vector2(330 * heightScale * 1.2, 90 * heightScale * 1.2);
    } else {
      size = Vector2(330 * heightScale * 2, 90 * heightScale * 2);
    }

    updateMessageImage(gameSize);
  }

  updateMessageImage(Vector2 gameSize) async {
    var image = await Flame.images.load('new_logo_text_rework_5.png');
    sprite = Sprite(image);
  }
}
