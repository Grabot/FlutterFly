import 'package:flutter/material.dart';
import 'package:flutterfly/models/ui/achievement.dart';


class ScoreScreenChangeNotifier extends ChangeNotifier {

  bool showScoreScreen = false;

  int currentScore = 0;
  bool isHighScore = false;
  bool twoPlayer = false;

  List<Achievement> achievementEarned = [];

  static final ScoreScreenChangeNotifier _instance = ScoreScreenChangeNotifier._internal();

  ScoreScreenChangeNotifier._internal();

  factory ScoreScreenChangeNotifier() {
    return _instance;
  }

  setScoreScreenVisible(bool visible) {
    showScoreScreen = visible;
    notifyListeners();
  }

  getScoreScreenVisible() {
    return showScoreScreen;
  }

  setScore(int score, bool isHighScore) {
    currentScore = score;
    this.isHighScore = isHighScore;
    notifyListeners();
  }

  int getScore() {
    return currentScore;
  }

  bool isTwoPlayer() {
    return twoPlayer;
  }

  setTwoPlayer(bool twoPlayer) {
    this.twoPlayer = twoPlayer;
  }

  notify() {
    notifyListeners();
  }

  clearAchievementList() {
    achievementEarned.clear();
  }

  addAchievement(Achievement achievement) {
    achievementEarned.add(achievement);
  }

  List<Achievement> getAchievementEarned() {
    return achievementEarned;
  }
}
