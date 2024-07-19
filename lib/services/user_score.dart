import 'package:flutterfly/util/web_storage.dart';


class UserScore {
  static final UserScore _instance = UserScore._internal();

  int bestScoreSingleButterfly = 0;
  int bestScoreDoubleButterfly = 0;
  int totalFlutters = 0;
  int totalPipesCleared = 0;
  int totalGames = 0;

  SecureStorage secureStorage = SecureStorage();

  UserScore._internal() {
    // retrieve storage
    retrieveStorage();
  }

  retrieveStorage() async {
    secureStorage.getTotalFlutters().then((value) {
      if (value != null) {
        totalFlutters = int.parse(value);
      }
    });
    secureStorage.getTotalPipes().then((value) {
      if (value != null) {
        totalPipesCleared = int.parse(value);
      }
    });
    secureStorage.getTotalGames().then((value) {
      if (value != null) {
        totalGames = int.parse(value);
      }
    });
    secureStorage.getBestScoreSingleButterfly().then((value) {
      if (value != null) {
        bestScoreSingleButterfly = int.parse(value);
      }
    });
    secureStorage.getBestScoreDoubleButterfly().then((value) {
      if (value != null) {
        bestScoreDoubleButterfly = int.parse(value);
      }
    });
  }

  factory UserScore() {
    return _instance;
  }

  int getBestScoreSingleButterfly() {
    return bestScoreSingleButterfly;
  }

  setBestScoreSingleButterfly(int bestScoreSingleButterfly) async {
    this.bestScoreSingleButterfly = bestScoreSingleButterfly;
    await secureStorage.setBestScoreSingleButterfly(bestScoreSingleButterfly.toString());
  }

  int getBestScoreDoubleButterfly() {
    return bestScoreDoubleButterfly;
  }

  setBestScoreDoubleButterfly(int bestScoreDoubleButterfly) async {
    this.bestScoreDoubleButterfly = bestScoreDoubleButterfly;
    await secureStorage.setBestScoreSingleButterfly(bestScoreDoubleButterfly.toString());
  }

  addTotalFlutters(int flutters) async {
    totalFlutters += flutters;
    await secureStorage.setTotalFlutters(totalFlutters.toString());
  }

  setTotalFlutters(int flutters) async {
    totalFlutters = flutters;
    await secureStorage.setTotalFlutters(totalFlutters.toString());
  }

  getTotalFlutters() {
    return totalFlutters;
  }

  addTotalPipesCleared(int pipesCleared) async {
    totalPipesCleared += pipesCleared;
    await secureStorage.setTotalPipes(totalPipesCleared.toString());
  }

  setTotalPipesCleared(int pipesCleared) async {
    totalPipesCleared = pipesCleared;
    await secureStorage.setTotalPipes(totalPipesCleared.toString());
  }

  getTotalPipesCleared() {
    return totalPipesCleared;
  }

  addTotalGames(int games) async {
    totalGames += games;
    await secureStorage.setTotalGames(totalGames.toString());
  }

  getTotalGames() {
    return totalGames;
  }

  setTotalGames(int games) async {
    totalGames = games;
    await secureStorage.setTotalGames(totalGames.toString());
  }

  getScore() {
    return Score(
      bestScoreSingleButterfly,
      bestScoreDoubleButterfly,
      totalFlutters,
      totalPipesCleared,
      totalGames,
    );
  }

  logout() async {
    bestScoreSingleButterfly = 0;
    bestScoreDoubleButterfly = 0;
    totalFlutters = 0;
    totalPipesCleared = 0;
    totalGames = 0;
    await secureStorage.setTotalGames("0");
    await secureStorage.setTotalPipes("0");
    await secureStorage.setTotalFlutters("0");
    await secureStorage.setBestScoreSingleButterfly("0");
    await secureStorage.setBestScoreDoubleButterfly("0");
  }
}

class Score {

  int bestScoreSingleButterfly = 0;
  int bestScoreDoubleButterfly = 0;
  int totalFlutters = 0;
  int totalPipesCleared = 0;
  int totalGames = 0;

  Score(this.bestScoreSingleButterfly, this.bestScoreDoubleButterfly, this.totalFlutters, this.totalPipesCleared, this.totalGames);

  Score.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("best_score_single_butterfly")) {
      bestScoreSingleButterfly = json["best_score_single_butterfly"];
    }
    if (json.containsKey("best_score_double_butterfly")) {
      bestScoreDoubleButterfly = json["best_score_double_butterfly"];
    }
    if (json.containsKey("total_flutters")) {
      totalFlutters = json["total_flutters"];
    }
    if (json.containsKey("total_pipes_cleared")) {
      totalPipesCleared = json["total_pipes_cleared"];
    }
    if (json.containsKey("total_games")) {
      totalGames = json["total_games"];
    }
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    json['best_score_single_butterfly'] = bestScoreSingleButterfly;
    json['best_score_double_butterfly'] = bestScoreDoubleButterfly;
    json['total_flutters'] = totalFlutters;
    json['total_pipes_cleared'] = totalPipesCleared;
    json['total_games'] = totalGames;
    return json;
  }

  int getBestScoreSingleButterfly() {
    return bestScoreSingleButterfly;
  }
  int getBestScoreDoubleButterfly() {
    return bestScoreDoubleButterfly;
  }
  int getTotalFlutters() {
    return totalFlutters;
  }
  int getTotalPipesCleared() {
    return totalPipesCleared;
  }
  int getTotalGames() {
    return totalGames;
  }
  setTotalGames(int games) {
    totalGames = games;
  }
  setTotalPipesCleared(int pipesCleared) {
    totalPipesCleared = pipesCleared;
  }
  setTotalFlutters(int flutters) {
    totalFlutters = flutters;
  }
  setBestScoreSingleButterfly(int scoreSingleButterfly) {
    bestScoreSingleButterfly = scoreSingleButterfly;
  }
  setBestScoreDoubleButterfly(int scoreDoubleButterfly) {
    bestScoreDoubleButterfly = scoreDoubleButterfly;
  }
}
