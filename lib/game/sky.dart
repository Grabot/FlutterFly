import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutterfly/game/flutter_fly.dart';


class Sky extends ParallaxComponent<FlutterFly> with HasGameRef<FlutterFly> {

  @override
  Future<void> onLoad() async {
    await loadParallax();
  }

  loadParallax() async {

    List parallaxList = [
      "parallax/city_day/new_background_sky_day_gradient_4.png",
      "parallax/city_day/new_background_city_2_day.png",
      "parallax/city_day/new_background_city_2_day_2.png",
      "parallax/city_bg_3.png",
      "parallax/city_bg_4.png",
    ];
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData(parallaxList[0]),
        ParallaxImageData(parallaxList[1]),
        ParallaxImageData(parallaxList[2]),
        ParallaxImageData(parallaxList[3]),
        ParallaxImageData(parallaxList[4]),
      ],
      baseVelocity: Vector2(15, 0),
      velocityMultiplierDelta: Vector2(1.6, 1.0),
      filterQuality: FilterQuality.none,
    );
  }

  gameOver() {
    if (parallax != null) {
      parallax!.baseVelocity = Vector2(0, 0);
    }
  }

  reset() {
    if (parallax != null) {
      parallax!.baseVelocity = Vector2(20, 0);
    }
  }
}
