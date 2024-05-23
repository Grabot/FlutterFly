

class BaseResponse {
  late bool result;
  late int totalFlutters;
  late int totalPipesCleared;
  late int totalGames;

  BaseResponse(this.result, this.totalFlutters, this.totalPipesCleared, this.totalGames);

  bool getResult() {
    return result;
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

  BaseResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("result")) {
      result = json["result"];
    }
    if (json.containsKey("total_flutters")) {
      totalFlutters = json["total_flutters"];
    }
  }
}
