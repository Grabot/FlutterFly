import 'package:flutter/material.dart';


class LeaderBoardChangeNotifier extends ChangeNotifier {

  bool showLeaderBoard = false;
  int rankingSelection = 4;
  bool twoPlayer = true;

  static final LeaderBoardChangeNotifier _instance = LeaderBoardChangeNotifier._internal();

  LeaderBoardChangeNotifier._internal();

  factory LeaderBoardChangeNotifier() {
    return _instance;
  }

  setLeaderBoardVisible(bool visible) {
    showLeaderBoard = visible;
    notifyListeners();
  }

  getLeaderBoardVisible() {
    return showLeaderBoard;
  }

  setRankingSelection(int selection) {
    rankingSelection = selection;
  }

  getRankingSelection() {
    return rankingSelection;
  }

  setTwoPlayer(bool twoPlayer) {
    this.twoPlayer = twoPlayer;
  }

  bool isTwoPlayer() {
    return twoPlayer;
  }

  notify() {
    notifyListeners();
  }
}
