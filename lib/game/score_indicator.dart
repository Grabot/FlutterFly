import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutterfly/game/flutter_fly.dart';

class ScoreIndicator extends PositionComponent with HasGameRef<FlutterFly> {

  ScoreIndicator();

  List<ScoreNumber> scoreNumbers = [];

  double scoreNumberWidth = 24;
  @override
  Future<void> onLoad() async {
    double heightScale = gameRef.size.y / 800;
    scoreNumberWidth = 24 * heightScale * 1.5;

    Vector2 pos0 = Vector2(gameRef.size.x/2, gameRef.size.y/2);
    pos0.y -= gameRef.size.y/3;
    ScoreNumber scoreNumber2 = ScoreNumber(
      'score/0.png',
      position: pos0,
    );
    scoreNumbers.add(scoreNumber2);
    add(scoreNumber2);

    priority = 10;
    return super.onLoad();
  }

  scoreChange(int newScore) {
    // We clone the old numbers so we can remove them at the end
    List<ScoreNumber> oldScoreNumbers = List.from(scoreNumbers);
    scoreNumbers.clear();

    List<String> scoreString = newScore.toString().split('');

    double xOffset = 0;
    for (int i = 1; i < scoreNumbers.length; i++) {
      xOffset -= (scoreNumberWidth / 2);
    }

    for (String score in scoreString) {
      Vector2 posScore = Vector2(gameRef.size.x/2, gameRef.size.y/2);
      posScore.x += xOffset;
      posScore.y -= gameRef.size.y/3;
      ScoreNumber scoreNumber = ScoreNumber(
        'score/$score.png',
        position: posScore,
      );
      xOffset += scoreNumberWidth;

      scoreNumbers.add(scoreNumber);
      add(scoreNumber);
    }
    // We remove the old numbers at the end so it doesn't flicker when the numbers change
    for (ScoreNumber scoreNumber in oldScoreNumbers) {
      remove(scoreNumber);
    }
  }

  @override
  void onGameResize(Vector2 gameSize) async {
    double heightScale = gameRef.size.y / 800;
    scoreNumberWidth = 24 * heightScale * 1.5;
    super.onGameResize(gameSize);
  }
}

class ScoreNumber extends SpriteComponent with HasGameRef<FlutterFly> {

  String numberImage;
  ScoreNumber(
      this.numberImage,
      {
        super.position
      }
    );

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    double heightScale = gameRef.size.y / 800;
    size = Vector2(24 * heightScale * 1.5, 36 * heightScale * 1.5);

    var image = await Flame.images.load(numberImage);
    sprite = Sprite(image);
    priority = 10;

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) async {
    super.onGameResize(gameSize);
    double heightScale = gameRef.size.y / 800;
    size = Vector2(24 * heightScale * 1.5, 36 * heightScale * 1.5);
  }
}

