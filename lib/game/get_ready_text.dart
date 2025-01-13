import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfly/game/flutter_fly.dart';

class GetReadyText extends SpriteComponent with HasGameRef<FlutterFly> {

  GetReadyText();

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
    position.y -= gameSize.y / 6;
    double heightScale = gameRef.size.y / 800;

    if (gameSize.x <= 800 || gameSize.y > gameSize.x) {
      size = Vector2(135 * heightScale * 1.2, 30 * heightScale * 1.2);
    } else {
      size = Vector2(135 * heightScale * 2, 30 * heightScale * 2);
    }

    updateMessageImage(gameSize);
  }

  updateMessageImage(Vector2 gameSize) async {
    var image = await Flame.images.load('get_ready_rework.png');
    sprite = Sprite(image);
  }
}
