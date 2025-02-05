import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfly/game/flutter_fly.dart';

class HelpMessage extends SpriteComponent with HasGameRef<FlutterFly> {

  HelpMessage();

  bool showSingleWeb = false;
  bool showSinglePhone = false;
  bool showDoubleWeb = false;
  bool showDoublePhone = false;

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
    position.y += gameSize.y / 8;
    double heightScale = gameRef.size.y / 800;

    if (gameSize.x <= 800 || gameSize.y > gameSize.x) {
      size = Vector2(200 * heightScale * 1.2, 127 * heightScale * 1.2);
    } else {
      size = Vector2(200 * heightScale * 2, 127 * heightScale * 2);
    }

    updateMessageImage(gameSize);
  }

  updateMessageImage(Vector2 gameSize) async {

    bool isPhone = false;
    if (kIsWeb) {
      // here it is a web app, but might be web app on a phone
      if (gameSize.x <= 800) {
        isPhone = true;
      } else {
        isPhone = false;
      }
    } else {
      isPhone = true;
    }
    if (gameRef.spaceBarUsed) {
      // If the user has pressed the space bar, we know it's a desktop
      isPhone = false;
    }
    if (gameRef.twoPlayers && isPhone) {
      // two players and the width is less or equal to 800.
      // We think this is a phone. (or it is a phone, indicated by !kIsWeb)
      if (!showDoublePhone) {
        showDoublePhone = true;
        showSinglePhone = false;
        showDoubleWeb = false;
        showSingleWeb = false;
        var image = await Flame.images.load('help_messages/message_phone_double_rework.png');
        sprite = Sprite(image);
      }
    } else if (gameRef.twoPlayers && !isPhone) {
      if (!showDoubleWeb) {
        showDoublePhone = false;
        showSinglePhone = false;
        showDoubleWeb = true;
        showSingleWeb = false;
        var image = await Flame.images.load('help_messages/message_web_double_rework.png');
        sprite = Sprite(image);
      }
    } else if (!gameRef.twoPlayers && isPhone) {
      // single players and the width is less or equal to 800.
      // We think this is a phone.
      if (!showSinglePhone) {
        showDoublePhone = false;
        showSinglePhone = true;
        showDoubleWeb = false;
        showSingleWeb = false;
        var image = await Flame.images.load('help_messages/message_phone_single_rework.png');
        sprite = Sprite(image);
      }
    } else if (!gameRef.twoPlayers && !isPhone) {
      if (!showSingleWeb) {
        showDoublePhone = false;
        showSinglePhone = false;
        showDoubleWeb = false;
        showSingleWeb = true;
        var image = await Flame.images.load('help_messages/message_web_single_rework.png');
        sprite = Sprite(image);
      }
    }
  }
}
