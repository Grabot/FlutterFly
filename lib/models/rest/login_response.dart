import 'package:flutterfly/models/user.dart';
import 'package:flutterfly/services/user_achievements.dart';
import 'package:flutterfly/services/user_score.dart';

class LoginResponse {
  late bool result;
  late String message;
  String? accessToken;
  String? refreshToken;
  User? user;
  Score? score;
  Achievements? achievement;

  LoginResponse(this.result, this.message, this.accessToken, this.refreshToken, this.user);

  bool getResult() {
    return result;
  }

  String getMessage() {
    return message;
  }

  String? getAccessToken() {
    return accessToken;
  }

  String? getRefreshToken() {
    return refreshToken;
  }

  User? getUser() {
    return user;
  }

  Score? getScore() {
    return score;
  }

  Achievements? getAchievements() {
    return achievement;
  }

  LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("result") &&
        json.containsKey("message")) {
      result = json["result"];
      message = json["message"];
      if (result) {
        accessToken = json["access_token"];
        refreshToken = json["refresh_token"];
        if (json.containsKey("user")) {
          Map<String, dynamic> userJson = json["user"];
          user = User.fromJson(userJson);

          if (userJson.containsKey("score")) {
            Map<String, dynamic> scoreJson = userJson["score"];
            score = Score.fromJson(scoreJson);
          }
          if (userJson.containsKey("achievements")) {
            Map<String, dynamic> achievementJson = userJson["achievements"];
            achievement = Achievements.fromJson(achievementJson);
          }
        }
        if (json.containsKey("platform_achievement")) {
          if (json["platform_achievement"]) {
            // The user has achieved the platform achievement
            UserAchievements userAchievements = UserAchievements();
            if (!userAchievements.getPlatforms()) {
              userAchievements.achievedPlatforms();
            }
          }
        }
      }
    }
  }
}
