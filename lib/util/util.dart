import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutterfly/models/user.dart';
import 'package:flutterfly/services/game_settings.dart';
import 'package:flutterfly/services/navigation_service.dart';
import 'package:flutterfly/services/rest/auth_service_flutter_fly.dart';
import 'package:flutterfly/services/rest/auth_service_login.dart';
import 'package:flutterfly/models/rest/login_response.dart';
import 'package:flutterfly/services/settings.dart';
import 'package:flutterfly/services/socket_services.dart';
import 'package:flutterfly/services/user_achievements.dart';
import 'package:flutterfly/services/user_score.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';
import 'package:oktoast/oktoast.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../constants/flutterfly_constant.dart';
import 'web_storage.dart';

showToastMessage(String message) {
  showToast(
    message,
    duration: const Duration(milliseconds: 2000),
    position: ToastPosition.top,
    backgroundColor: Colors.white,
    radius: 1.0,
    textStyle: const TextStyle(fontSize: 30.0, color: Colors.black),
  );
}

ButtonStyle buttonStyle(bool active, MaterialColor buttonColor) {
  return ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return buttonColor.shade600;
          }
          if (states.contains(MaterialState.pressed)) {
            return buttonColor.shade300;
          }
          return null;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return active? buttonColor.shade800 : buttonColor;
          }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )
      )
  );
}

getScore(LoginResponse loginResponse, int userId) async {
  UserScore userScore = UserScore();
  Score? score = loginResponse.getScore();
  if (score != null) {
    bool updateScore = false;

    if (score.getBestScoreSingleButterfly() > userScore.getBestScoreSingleButterfly()) {
      userScore.setBestScoreSingleButterfly(score.getBestScoreSingleButterfly());
    } else if (userScore.getBestScoreSingleButterfly() > score.getBestScoreSingleButterfly()) {
      score.setBestScoreSingleButterfly(userScore.getBestScoreSingleButterfly());
      updateScore = true;
    }
    if (score.getBestScoreDoubleButterfly() > userScore.getBestScoreDoubleButterfly()) {
      userScore.setBestScoreDoubleButterfly(score.getBestScoreDoubleButterfly());
    } else if (userScore.getBestScoreDoubleButterfly() > score.getBestScoreDoubleButterfly()) {
      score.setBestScoreDoubleButterfly(userScore.getBestScoreDoubleButterfly());
      updateScore = true;
    }
    if (score.getTotalFlutters() > userScore.getTotalFlutters()) {
      userScore.setTotalFlutters(score.getTotalFlutters());
    } else if (userScore.getTotalFlutters() > score.getTotalFlutters()) {
      score.setTotalFlutters(userScore.getTotalFlutters());
      updateScore = true;
    }
    if (score.getTotalPipesCleared() > userScore.getTotalPipesCleared()) {
      userScore.setTotalPipesCleared(score.getTotalPipesCleared());
    } else if (userScore.getTotalPipesCleared() > score.getTotalPipesCleared()) {
      score.setTotalPipesCleared(userScore.getTotalPipesCleared());
      updateScore = true;
    }
    if (score.getTotalGames() > userScore.getTotalGames()) {
      userScore.setTotalGames(score.getTotalGames());
    } else if (userScore.getTotalGames() > score.getTotalGames()) {
      score.setTotalGames(userScore.getTotalGames());
      updateScore = true;
    }

    if (updateScore) {
      AuthServiceFlutterFly().updateUserScore(score.getBestScoreSingleButterfly(), score.getBestScoreDoubleButterfly(), score).then((result) {
        if (result.getResult()) {
          // we have updated the score in the db. Do nothing.
        }
      });
    }
  }
}

getAchievements(LoginResponse loginResponse, int userId) async {
  UserAchievements userAchievements = UserAchievements();
  Achievements? achievements = loginResponse.getAchievements();
  if (achievements != null) {
    bool updateAchievements = false;
    // Check if the user has achieved achievements that they don't have locally
    // This can happen if the user has logged in on another device.
    // It also checks if they have an achievement locally
    // that they don't have on the server. This can happen if they haven't
    // played in a while and then returned. They than remain logged out and play
    // Any achievement that they get is stored locally.
    // If they then log in they still get the achievement.
    await Future.delayed(const Duration(milliseconds: 200));
    if (achievements.getWoodSingle() && !userAchievements.getWoodSingle()) {
      userAchievements.achievedWoodSingle();
    } else if (!achievements.getWoodSingle() && userAchievements.getWoodSingle()) {
      achievements.setWoodSingle(userAchievements.getWoodSingle());
      updateAchievements = true;
    }
    if (achievements.getBronzeSingle() && !userAchievements.getBronzeSingle()) {
      userAchievements.achievedBronzeSingle();
    } else if (!achievements.getBronzeSingle() && userAchievements.getBronzeSingle()) {
      achievements.setBronzeSingle(userAchievements.getBronzeSingle());
      updateAchievements = true;
    }
    if (achievements.getSilverSingle() && !userAchievements.getSilverSingle()) {
      userAchievements.achievedSilverSingle();
    } else if (!achievements.getSilverSingle() && userAchievements.getSilverSingle()) {
      achievements.setSilverSingle(userAchievements.getSilverSingle());
      updateAchievements = true;
    }
    if (achievements.getGoldSingle() && !userAchievements.getGoldSingle()) {
      userAchievements.achievedGoldSingle();
    } else if (!achievements.getGoldSingle() && userAchievements.getGoldSingle()) {
      achievements.setGoldSingle(userAchievements.getGoldSingle());
      updateAchievements = true;
    }
    if (achievements.getWoodDouble() && !userAchievements.getWoodDouble()) {
      userAchievements.achievedWoodDouble();
    } else if (!achievements.getWoodDouble() && userAchievements.getWoodDouble()) {
      achievements.setWoodDouble(userAchievements.getWoodDouble());
      updateAchievements = true;
    }
    if (achievements.getBronzeDouble() && !userAchievements.getBronzeDouble()) {
      userAchievements.achievedBronzeDouble();
    } else if (!achievements.getBronzeDouble() && userAchievements.getBronzeDouble()) {
      achievements.setBronzeDouble(userAchievements.getBronzeDouble());
      updateAchievements = true;
    }
    if (achievements.getSilverDouble() && !userAchievements.getSilverDouble()) {
      userAchievements.achievedSilverDouble();
    } else if (!achievements.getSilverDouble() && userAchievements.getSilverDouble()) {
      achievements.setSilverDouble(userAchievements.getSilverDouble());
      updateAchievements = true;
    }
    if (achievements.getGoldDouble() && !userAchievements.getGoldDouble()) {
      userAchievements.achievedGoldDouble();
    } else if (!achievements.getGoldDouble() && userAchievements.getGoldDouble()) {
      achievements.setGoldDouble(userAchievements.getGoldDouble());
      updateAchievements = true;
    }
    if (achievements.getFlutterOne() && !userAchievements.getFlutterOne()) {
      userAchievements.achievedFlutterOne();
    } else if (!achievements.getFlutterOne() && userAchievements.getFlutterOne()) {
      achievements.setFlutterOne(userAchievements.getFlutterOne());
      updateAchievements = true;
    }
    if (achievements.getFlutterTwo() && !userAchievements.getFlutterTwo()) {
      userAchievements.achievedFlutterTwo();
    } else if (!achievements.getFlutterTwo() && userAchievements.getFlutterTwo()) {
      achievements.setFlutterTwo(userAchievements.getFlutterTwo());
      updateAchievements = true;
    }
    if (achievements.getFlutterThree() && !userAchievements.getFlutterThree()) {
      userAchievements.achievedFlutterThree();
    } else if (!achievements.getFlutterThree() && userAchievements.getFlutterThree()) {
      achievements.setFlutterThree(userAchievements.getFlutterThree());
      updateAchievements = true;
    }
    if (achievements.getFlutterFour() && !userAchievements.getFlutterFour()) {
      userAchievements.achievedFlutterFour();
    } else if (!achievements.getFlutterFour() && userAchievements.getFlutterFour()) {
      achievements.setFlutterFour(userAchievements.getFlutterFour());
      updateAchievements = true;
    }
    if (achievements.getPipesOne() && !userAchievements.getPipesOne()) {
      userAchievements.achievedPipesOne();
    } else if (!achievements.getPipesOne() && userAchievements.getPipesOne()) {
      achievements.setPipesOne(userAchievements.getPipesOne());
      updateAchievements = true;
    }
    if (achievements.getPipesTwo() && !userAchievements.getPipesTwo()) {
      userAchievements.achievedPipesTwo();
    } else if (!achievements.getPipesTwo() && userAchievements.getPipesTwo()) {
      achievements.setPipesTwo(userAchievements.getPipesTwo());
      updateAchievements = true;
    }
    if (achievements.getPipesThree() && !userAchievements.getPipesThree()) {
      userAchievements.achievedPipesThree();
    } else if (!achievements.getPipesThree() && userAchievements.getPipesThree()) {
      achievements.setPipesThree(userAchievements.getPipesThree());
      updateAchievements = true;
    }
    if (achievements.getPerseverance() && !userAchievements.getPerseverance()) {
      userAchievements.achievedPerseverance();
    } else if (!achievements.getPerseverance() && userAchievements.getPerseverance()) {
      achievements.setPerseverance(userAchievements.getPerseverance());
      updateAchievements = true;
    }
    if (achievements.getNightOwl() && !userAchievements.getNightOwl()) {
      userAchievements.achievedNightOwl();
    } else if (!achievements.getNightOwl() && userAchievements.getNightOwl()) {
      achievements.setNightOwl(userAchievements.getNightOwl());
      updateAchievements = true;
    }
    if (achievements.getWingedWarrior() && !userAchievements.getWingedWarrior()) {
      userAchievements.achievedWingedWarrior();
    } else if (!achievements.getWingedWarrior() && userAchievements.getWingedWarrior()) {
      achievements.setWingedWarrior(userAchievements.getWingedWarrior());
      updateAchievements = true;
    }
    if (achievements.getPlatforms() && !userAchievements.getPlatforms()) {
      userAchievements.setPlatforms(true);
    } else if (!achievements.getPlatforms() && userAchievements.getPlatforms()) {
      achievements.setPlatforms(userAchievements.getPlatforms());
      updateAchievements = true;
    }
    if (achievements.getLeaderboard() && !userAchievements.getLeaderboard()) {
      userAchievements.achievedLeaderboard();
    } else if (!achievements.getLeaderboard() && userAchievements.getLeaderboard()) {
      achievements.setLeaderboard(userAchievements.getLeaderboard());
      updateAchievements = true;
    }

    // achievement helper variables
    if (achievements.getLastDayPlayed() != userAchievements.getLastDayPlayed()) {
      userAchievements.setLastDayPlayed(achievements.getLastDayPlayed());
    }
    if (achievements.getDaysInARow() != userAchievements.getDaysInARow()) {
      userAchievements.setDaysInARow(achievements.getDaysInARow());
    }

    if (updateAchievements) {
      AuthServiceFlutterFly().updateAchievements(achievements).then((result) {
        if (result.getResult()) {
          // we have updated the score in the db. Do nothing.
        }
      });
    }
  }
}

successfulLogin(LoginResponse loginResponse) async {
  SecureStorage secureStorage = SecureStorage();
  Settings settings = Settings();

  User? user = loginResponse.getUser();
  if (user != null) {
    settings.setUser(user);
    if (user.getAvatar() != null) {
      settings.setAvatar(user.getAvatar()!);
    }
    getScore(loginResponse, user.id);
    getAchievements(loginResponse, user.id);
    SocketServices().login(user.id);
  }

  String? accessToken = loginResponse.getAccessToken();
  if (accessToken != null) {
    // the access token will be set in memory and local storage.
    settings.setAccessToken(accessToken);
    settings.setAccessTokenExpiration(Jwt.parseJwt(accessToken)['exp']);
    await secureStorage.setAccessToken(accessToken);
  }

  String? refreshToken = loginResponse.getRefreshToken();
  if (refreshToken != null) {
    // the refresh token will only be set in memory.
    settings.setRefreshToken(refreshToken);
    settings.setRefreshTokenExpiration(Jwt.parseJwt(refreshToken)['exp']);
    await secureStorage.setRefreshToken(refreshToken);
  }

  settings.setLoggingIn(false);
  UserChangeNotifier().notify();
  settings.updateRanks();
}

TextStyle simpleTextStyle(double fontSize) {
  return TextStyle(color: Colors.white, fontSize: fontSize);
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ));
}

bool emailValid(String possibleEmail) {
  return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(possibleEmail);
}

logoutUser(Settings settings, NavigationService navigationService) async {
  if (settings.getUser() != null) {
    await AuthServiceLogin().logout();  // we assume it will work, but it doesn't matter if it doesn't
    SocketServices().logout(settings.getUser()!.id);
  }
  UserChangeNotifier().setProfileVisible(false);
  settings.logout();
  SecureStorage().logout();
  UserScore().logout();
  UserAchievements().logout();
  GameSettings().logout();
}

Widget expandedText(double width, String text, double fontSize, bool bold) {
  return SizedBox(
    width: width,
    child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ]
    ),
  );
}

Color overviewColour(int state, Color colour0, Color colour1, Color colour2) {
  if (state == 0) {
    return colour0;
  } else if (state == 1) {
    return colour1;
  } else {
    return colour2;
  }
}

int getRankingSelection(bool onePlayer, int currentScore, Settings settings) {
  if (onePlayer) {
    if (settings.rankingsOnePlayerAll.length >= 10) {
      // If the user has a larger score than what is currently in the top 10
      // then they are in the top 10. We return "4" to indicate the all leaderboard.
      if (currentScore > settings.rankingsOnePlayerAll[9].getScore()) {
        return 4;
      }
    } else {
      // If there aren't 10 scores in the leaderboard than the user has made it into the top 10.
      return 4;
    }
    if (settings.rankingsOnePlayerYear.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerYear[9].getScore()) {
        return 3;
      }
    } else {
      return 3;
    }
    if (settings.rankingsOnePlayerMonth.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerMonth[9].getScore()) {
        return 2;
      }
    } else {
      return 2;
    }
    if (settings.rankingsOnePlayerWeek.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerWeek[9].getScore()) {
        return 1;
      }
    } else {
      return 1;
    }
    if (settings.rankingsOnePlayerDay.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerDay[9].getScore()) {
        return 0;
      }
    } else {
      return 0;
    }
  } else {
    if (settings.rankingsTwoPlayerAll.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerAll[9].getScore()) {
        return 4;
      }
    } else {
      return 4;
    }
    if (settings.rankingsTwoPlayerYear.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerYear[9].getScore()) {
        return 3;
      }
    } else {
      return 3;
    }
    if (settings.rankingsTwoPlayerMonth.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerMonth[9].getScore()) {
        return 2;
      }
    } else {
      return 2;
    }
    if (settings.rankingsTwoPlayerWeek.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerWeek[9].getScore()) {
        return 1;
      }
    } else {
      return 1;
    }
    if (settings.rankingsTwoPlayerDay.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerDay[9].getScore()) {
        return 0;
      }
    } else {
      return 0;
    }
  }
  return -1;
}

Widget flutterFlyLogo(double width, bool normalMode) {
  return Container(
        padding: normalMode
            ? EdgeInsets.only(left: width/4, right: width/4)
            : EdgeInsets.only(left: width/6, right: width/6),
        alignment: Alignment.center,
        child: Image.asset("assets/images/flutterfly_banner_rework_4.png")
    );
}

Widget achievementImage(Uint8List? avatar, double achievementWidth, double achievementHeight) {
  if (avatar != null) {
    return Image.memory(
      avatar,
      width: achievementWidth,  // some scale that I determined by trial and error
      height: achievementHeight,  // some scale that I determined by trial and error
      gaplessPlayback: true,
      fit: BoxFit.cover,
    );
  } else {
    return Image.asset(
      "assets/images/default_achievement.png",
      width: achievementWidth,
      height: achievementHeight,
      gaplessPlayback: true,
      fit: BoxFit.cover,
    );
  }
}
