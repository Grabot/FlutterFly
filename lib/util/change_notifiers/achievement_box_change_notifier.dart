import 'package:flutter/material.dart';


class AchievementBoxChangeNotifier extends ChangeNotifier {

  bool showAchievementBox = false;

  static final AchievementBoxChangeNotifier _instance = AchievementBoxChangeNotifier._internal();

  AchievementBoxChangeNotifier._internal();

  factory AchievementBoxChangeNotifier() {
    return _instance;
  }

  setAchievementBoxVisible(bool visible) {
    showAchievementBox = visible;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  getAchievementBoxVisible() {
    return showAchievementBox;
  }
}
