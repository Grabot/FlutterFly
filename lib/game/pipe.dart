import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutterfly/game/flutter_fly.dart';

class Pipe extends SpriteComponent with HasGameRef<FlutterFly> {
  int butterflyType;

  Pipe({
    super.position,
    required this.butterflyType,
  });

  double heightScale = 1;

  double originalSizeX = 0;
  double originalSizeY = 0;

  @override
  Future<void> onLoad() async {
    await loadPipeDetails();
    return super.onLoad();
  }

  loadPipeDetails() async {
    if (butterflyType == 0) {
      final image = await Flame.images.load('pipes/pipe-red_big.png');
      sprite = Sprite(image);
    } else if (butterflyType == 1) {
      final image = await Flame.images.load('pipes/pipe-blue_big.png');
      sprite = Sprite(image);
    } else if (butterflyType == 2) {
      final image = await Flame.images.load('pipes/pipe-green_big.png');
      sprite = Sprite(image);
    } else if (butterflyType == 3) {
      final image = await Flame.images.load('pipes/pipe-yellow_big.png');
      sprite = Sprite(image);
    } else if (butterflyType == 4) {
      final image = await Flame.images.load('pipes/pipe-purple_big.png');
      sprite = Sprite(image);
    } else if (butterflyType == 5) {
      final image = await Flame.images.load('pipes/pipe-white_big.png');
      sprite = Sprite(image);
    } else if (butterflyType == 6) {
      final image = await Flame.images.load('pipes/pipe-black_big.png');
      sprite = Sprite(image);
    }
    anchor = Anchor.center;
    add(RectangleHitbox());
    heightScale = gameRef.size.y / 800;
    originalSizeX = size.x;
    originalSizeY = size.y;
    size.x *= 1.5;
    size.y *= 1.5;
    size.x *= heightScale;
    size.y *= heightScale;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;
    size.x = originalSizeX;
    size.y = originalSizeY;
    size.x *= 1.5;
    size.y *= 1.5;
    size.x *= heightScale;
    size.y *= heightScale;
    super.onGameResize(gameSize);
  }
}
