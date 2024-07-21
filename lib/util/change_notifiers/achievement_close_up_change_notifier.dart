import 'package:flutter/material.dart';
import 'package:flutterfly/models/ui/achievement.dart';


class AchievementCloseUpChangeNotifier extends ChangeNotifier {

  bool showAchievementCloseUp = false;
  Achievement? achievement;

  static final AchievementCloseUpChangeNotifier _instance = AchievementCloseUpChangeNotifier._internal();

  AchievementCloseUpChangeNotifier._internal();

  factory AchievementCloseUpChangeNotifier() {
    return _instance;
  }

  setAchievementCloseUpVisible(bool visible) {
    showAchievementCloseUp = visible;
    notifyListeners();
  }

  getAchievementCloseUpVisible() {
    return showAchievementCloseUp;
  }

  setAchievement(Achievement achievement) {
    this.achievement = achievement;
  }

  Achievement? getAchievement() {
    return achievement;
  }

  notify() {
    notifyListeners();
  }

}
