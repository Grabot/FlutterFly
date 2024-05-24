import 'package:flutter/material.dart';


class GameSettingsChangeNotifier extends ChangeNotifier {

  bool showGameSettings = false;

  static final GameSettingsChangeNotifier _instance = GameSettingsChangeNotifier._internal();

  GameSettingsChangeNotifier._internal();

  factory GameSettingsChangeNotifier() {
    return _instance;
  }

  setGameSettingsVisible(bool visible) {
    showGameSettings = visible;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  getGameSettingsVisible() {
    return showGameSettings;
  }
}
