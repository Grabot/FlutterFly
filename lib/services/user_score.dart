import 'package:flutterfly/util/web_storage.dart';


class UserScore {
  static final UserScore _instance = UserScore._internal();

  int bestScoreSingleBird = 0;
  int bestScoreDoubleBird = 0;
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
    secureStorage.getBestScoreSingleBird().then((value) {
      if (value != null) {
        bestScoreSingleBird = int.parse(value);
      }
    });
    secureStorage.getBestScoreDoubleBird().then((value) {
      if (value != null) {
        bestScoreDoubleBird = int.parse(value);
      }
    });
  }

  factory UserScore() {
    return _instance;
  }

  int getBestScoreSingleBird() {
    return bestScoreSingleBird;
  }

  setBestScoreSingleBird(int bestScoreSingleBird) async {
    this.bestScoreSingleBird = bestScoreSingleBird;
    await secureStorage.setBestScoreSingleBird(bestScoreSingleBird.toString());
  }

  int getBestScoreDoubleBird() {
    return bestScoreDoubleBird;
  }

  setBestScoreDoubleBird(int bestScoreDoubleBird) async {
    this.bestScoreDoubleBird = bestScoreDoubleBird;
    await secureStorage.setBestScoreSingleBird(bestScoreDoubleBird.toString());
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
      bestScoreSingleBird,
      bestScoreDoubleBird,
      totalFlutters,
      totalPipesCleared,
      totalGames,
    );
  }

  logout() async {
    bestScoreSingleBird = 0;
    bestScoreDoubleBird = 0;
    totalFlutters = 0;
    totalPipesCleared = 0;
    totalGames = 0;
    await secureStorage.setTotalGames("0");
    await secureStorage.setTotalPipes("0");
    await secureStorage.setTotalFlutters("0");
    await secureStorage.setBestScoreSingleBird("0");
    await secureStorage.setBestScoreDoubleBird("0");
  }
}

class Score {

  int bestScoreSingleBird = 0;
  int bestScoreDoubleBird = 0;
  int totalFlutters = 0;
  int totalPipesCleared = 0;
  int totalGames = 0;

  Score(this.bestScoreSingleBird, this.bestScoreDoubleBird, this.totalFlutters, this.totalPipesCleared, this.totalGames);

  Score.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("best_score_single_bird")) {
      bestScoreSingleBird = json["best_score_single_bird"];
    }
    if (json.containsKey("best_score_double_bird")) {
      bestScoreDoubleBird = json["best_score_double_bird"];
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

    json['best_score_single_bird'] = bestScoreSingleBird;
    json['best_score_double_bird'] = bestScoreDoubleBird;
    json['total_flutters'] = totalFlutters;
    json['total_pipes_cleared'] = totalPipesCleared;
    json['total_games'] = totalGames;
    return json;
  }

  int getBestScoreSingleBird() {
    return bestScoreSingleBird;
  }
  int getBestScoreDoubleBird() {
    return bestScoreDoubleBird;
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
  setBestScoreSingleBird(int scoreSingleBird) {
    bestScoreSingleBird = scoreSingleBird;
  }
  setBestScoreDoubleBird(int scoreDoubleBird) {
    bestScoreDoubleBird = scoreDoubleBird;
  }
}
