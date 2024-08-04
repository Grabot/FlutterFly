import 'package:flutterfly/models/ui/achievement.dart';
import 'package:flutterfly/util/change_notifiers/score_screen_change_notifier.dart';
import 'package:flutterfly/util/web_storage.dart';


class UserAchievements {
  static final UserAchievements _instance = UserAchievements._internal();

  bool woodSingle = false;
  bool bronzeSingle = false;
  bool silverSingle = false;
  bool goldSingle = false;
  bool woodDouble = false;
  bool bronzeDouble = false;
  bool silverDouble = false;
  bool goldDouble = false;
  bool flutterOne = false;
  bool flutterTwo = false;
  bool flutterThree = false;
  bool flutterFour = false;
  bool pipesOne = false;
  bool pipesTwo = false;
  bool pipesThree = false;
  bool perseverance = false;
  bool nightOwl = false;
  bool wingedWarrior = false;
  bool platforms = false;
  bool leaderboard = false;
  // You achieve the platforms achievement when you log in,
  // you are later show the achievement.
  // We use this variable to check if we just achieved it.
  bool justAchievedPlatforms = false;

  int lastDayPlayed = -1;
  int daysInARow = 0;

  int totalAchievementsRetrieved = 0;

  List<Achievement>? allAchievementsAvailable;

  SecureStorage secureStorage = SecureStorage();

  late Achievement woodSingleAchievement;
  late Achievement bronzeSingleAchievement;
  late Achievement silverSingleAchievement;
  late Achievement goldSingleAchievement;
  late Achievement woodDoubleAchievement;
  late Achievement bronzeDoubleAchievement;
  late Achievement silverDoubleAchievement;
  late Achievement goldDoubleAchievement;
  late Achievement flutterOneAchievement;
  late Achievement flutterTwoAchievement;
  late Achievement flutterThreeAchievement;
  late Achievement flutterFourAchievement;
  late Achievement pipesOneAchievement;
  late Achievement pipesTwoAchievement;
  late Achievement pipesThreeAchievement;
  late Achievement perseveranceAchievement;
  late Achievement nightOwlAchievement;
  late Achievement wingedWarriorAchievement;
  late Achievement platformsAchievement;
  late Achievement leaderboardAchievement;

  UserAchievements._internal() {
    createAchievementList();
    retrieveStorage();
  }

  retrieveStorage() {
    secureStorage.getWoodSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        woodSingleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getBronzeSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        bronzeSingleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getSilverSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        silverSingleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getGoldSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        goldSingleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getWoodDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        woodDoubleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getBronzeDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        bronzeDoubleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getSilverDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        silverDoubleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getGoldDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        goldDoubleAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getFlutterOne().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        flutterOneAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getFlutterTwo().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        flutterTwoAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getFlutterThree().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        flutterThreeAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getFlutterFour().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        flutterFourAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getPipesOne().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        pipesOneAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getPipesTwo().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        pipesTwoAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getPipesThree().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        pipesThreeAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getPerseverance().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        perseveranceAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getNightOwl().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        nightOwlAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getWingedWarrior().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        wingedWarriorAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getPlatforms().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        platformsAchievement.achieved = bool.parse(value);
      }
    });
    secureStorage.getLeaderboard().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        leaderboardAchievement.achieved = bool.parse(value);
      }
    });
    // achievement assistance values
    secureStorage.getLastDayPlayed().then((value) {
      if (value != null) {
        lastDayPlayed = int.parse(value);
      }
    });
    secureStorage.getDaysInARow().then((value) {
      if (value != null) {
        daysInARow = int.parse(value);
      }
    });
  }

  createAchievementList() {
    woodSingleAchievement = Achievement(
        achievementName: "Wood single",
        imageName: "wood_single",
        tooltip: "got more than 10 points with one butterfly",
        achieved: woodSingle,
        secureStorage: secureStorage
    );
    bronzeSingleAchievement = Achievement(
        achievementName: "Bronze single",
        imageName: "bronze_single",
        tooltip: "got more than 25 points with one butterfly",
        achieved: bronzeSingle,
        secureStorage: secureStorage
    );
    silverSingleAchievement = Achievement(
        achievementName: "Silver single",
        imageName: "silver_single",
        tooltip: "got more than 50 points with one butterfly!",
        achieved: silverSingle,
        secureStorage: secureStorage
    );
    goldSingleAchievement = Achievement(
        achievementName: "Gold single",
        imageName: "gold_single",
        tooltip: "got more than 100 points with one butterfly!!!",
        achieved: goldSingle,
        secureStorage: secureStorage
    );
    woodDoubleAchievement = Achievement(
        achievementName: "Wood double",
        imageName: "wood_double",
        tooltip: "got more than 10 points with two butterflies",
        achieved: woodDouble,
        secureStorage: secureStorage
    );
    bronzeDoubleAchievement = Achievement(
        achievementName: "Bronze double",
        imageName: "bronze_double",
        tooltip: "got more than 25 points with two butterflies",
        achieved: bronzeDouble,
        secureStorage: secureStorage
    );
    silverDoubleAchievement = Achievement(
        achievementName: "Silver double",
        imageName: "silver_double",
        tooltip: "got more than 50 points with two butterflies!",
        achieved: silverDouble,
        secureStorage: secureStorage
    );
    goldDoubleAchievement = Achievement(
        achievementName: "Gold double",
        imageName: "gold_double",
        tooltip: "got more than 100 points with two butterflies!!!",
        achieved: goldDouble,
        secureStorage: secureStorage
    );
    flutterOneAchievement = Achievement(
        achievementName: "Flutter one",
        imageName: "wings_one",
        tooltip: "You have fluttered your butterflies already more than a thousand times",
        achieved: flutterOne,
        secureStorage: secureStorage
    );
    flutterTwoAchievement = Achievement(
        achievementName: "Flutter two",
        imageName: "wings_two",
        tooltip: "You have fluttered your butterflies already more than two thousand and five hundred times!",
        achieved: flutterTwo,
        secureStorage: secureStorage
    );
    flutterThreeAchievement = Achievement(
        achievementName: "Flutter three",
        imageName: "wings_three",
        tooltip: "You have fluttered your butterflies already more than ten thousand times!!",
        achieved: flutterThree,
        secureStorage: secureStorage
    );
    flutterFourAchievement = Achievement(
        achievementName: "Flutter four",
        imageName: "wings_four",
        tooltip: "You have fluttered your butterflies already more than fifty thousand times!!!",
        achieved: flutterFour,
        secureStorage: secureStorage
    );
    pipesOneAchievement = Achievement(
        achievementName: "Pipes one",
        imageName: "pipes_one",
        tooltip: "Your butterflies have passed a total of two hundred and fifty pipes",
        achieved: pipesOne,
        secureStorage: secureStorage
    );
    pipesTwoAchievement = Achievement(
        achievementName: "Pipes two",
        imageName: "pipes_two",
        tooltip: "Your butterflies have passed a total of one thousand pipes!",
        achieved: pipesTwo,
        secureStorage: secureStorage
    );
    pipesThreeAchievement = Achievement(
        achievementName: "Pipes three",
        imageName: "pipes_three",
        tooltip: "Your butterflies have passed a total of five thousand pipes!",
        achieved: pipesThree,
        secureStorage: secureStorage
    );
    perseveranceAchievement = Achievement(
        achievementName: "Perseverance",
        imageName: "perseverance",
        tooltip: "You kept playing the game even after crashing 50 times in a single session!",
        achieved: perseverance,
        secureStorage: secureStorage
    );
    nightOwlAchievement = Achievement(
        achievementName: "Night owl",
        imageName: "midnight",
        tooltip: "You scored more than 20 points in a single session between 12:00 AM and 3:00 AM!",
        achieved: nightOwl,
        secureStorage: secureStorage
    );
    wingedWarriorAchievement = Achievement(
        achievementName: "Winged warrior",
        imageName: "winged_warrior",
        tooltip: "You have played Flutter Fly for 7 days in a row!",
        achieved: wingedWarrior,
        secureStorage: secureStorage
    );
    platformsAchievement = Achievement(
        achievementName: "Platforms",
        imageName: "platforms",
        tooltip: "You have played Flutter Fly on the web at flutterfly.eu and also on IOS or Android!\n(Must be logged in to achieve this)",
        achieved: platforms,
        secureStorage: secureStorage
    );
    leaderboardAchievement = Achievement(
        achievementName: "Leaderboard",
        imageName: "leaderboard",
        tooltip: "You have reached the top 3 on the daily leaderboard!\n(Must be logged in to achieve this)",
        achieved: leaderboard,
        secureStorage: secureStorage
    );
    allAchievementsAvailable = [
      woodSingleAchievement,
      bronzeSingleAchievement,
      silverSingleAchievement,
      goldSingleAchievement,
      woodDoubleAchievement,
      bronzeDoubleAchievement,
      silverDoubleAchievement,
      goldDoubleAchievement,
      flutterOneAchievement,
      flutterTwoAchievement,
      flutterThreeAchievement,
      flutterFourAchievement,
      pipesOneAchievement,
      pipesTwoAchievement,
      pipesThreeAchievement,
      perseveranceAchievement,
      nightOwlAchievement,
      wingedWarriorAchievement,
      platformsAchievement,
      leaderboardAchievement
    ];
  }

  factory UserAchievements() {
    return _instance;
  }

  logout() async {
    woodSingle = false;
    bronzeSingle = false;
    silverSingle = false;
    goldSingle = false;
    woodDouble = false;
    bronzeDouble = false;
    silverDouble = false;
    goldDouble = false;
    flutterOne = false;
    flutterTwo = false;
    flutterThree = false;
    flutterFour = false;
    pipesOne = false;
    pipesTwo = false;
    pipesThree = false;
    perseverance = false;
    nightOwl = false;
    wingedWarrior = false;
    platforms = false;
    leaderboard = false;
    lastDayPlayed = -1;
    daysInARow = 0;
    await secureStorage.setWoodSingle("false");
    await secureStorage.setBronzeSingle("false");
    await secureStorage.setSilverSingle("false");
    await secureStorage.setGoldSingle("false");
    await secureStorage.setWoodDouble("false");
    await secureStorage.setBronzeDouble("false");
    await secureStorage.setSilverDouble("false");
    await secureStorage.setGoldDouble("false");
    await secureStorage.setFlutterOne("false");
    await secureStorage.setFlutterTwo("false");
    await secureStorage.setFlutterThree("false");
    await secureStorage.setFlutterFour("false");
    await secureStorage.setPipesOne("false");
    await secureStorage.setPipesTwo("false");
    await secureStorage.setPipesThree("false");
    await secureStorage.setPerseverance("false");
    await secureStorage.setNightOwl("false");
    await secureStorage.setWingedWarrior("false");
    await secureStorage.setPlatforms("false");
    await secureStorage.setLeaderboard("false");
    await secureStorage.setLastDayPlayed("-1");
    await secureStorage.setDaysInARow("0");
    woodSingleAchievement.achieved = false;
    bronzeSingleAchievement.achieved = false;
    silverSingleAchievement.achieved = false;
    goldSingleAchievement.achieved = false;
    woodDoubleAchievement.achieved = false;
    bronzeDoubleAchievement.achieved = false;
    silverDoubleAchievement.achieved = false;
    goldDoubleAchievement.achieved = false;
    flutterOneAchievement.achieved = false;
    flutterTwoAchievement.achieved = false;
    flutterThreeAchievement.achieved = false;
    flutterFourAchievement.achieved = false;
    pipesOneAchievement.achieved = false;
    pipesTwoAchievement.achieved = false;
    pipesThreeAchievement.achieved = false;
    perseveranceAchievement.achieved = false;
    nightOwlAchievement.achieved = false;
    wingedWarriorAchievement.achieved = false;
    platformsAchievement.achieved = false;
    leaderboardAchievement.achieved = false;
  }

  getWoodSingle() {
    return woodSingle;
  }
  achievedWoodSingle() async {
    woodSingle = true;
    woodSingleAchievement.achieved = true;
    await secureStorage.setWoodSingle(woodSingle.toString());
  }

  getBronzeSingle() {
    return bronzeSingle;
  }
  achievedBronzeSingle() async {
    bronzeSingle = true;
    bronzeSingleAchievement.achieved = true;
    await secureStorage.setBronzeSingle(bronzeSingle.toString());
  }

  getSilverSingle() {
    return silverSingle;
  }
  achievedSilverSingle() async {
    silverSingle = true;
    silverSingleAchievement.achieved = true;
    await secureStorage.setSilverSingle(silverSingle.toString());
  }

  getGoldSingle() {
    return goldSingle;
  }
  achievedGoldSingle() async {
    goldSingle = true;
    goldSingleAchievement.achieved = true;
    await secureStorage.setGoldSingle(goldSingle.toString());
  }

  getWoodDouble() {
    return woodDouble;
  }
  achievedWoodDouble() async {
    woodDouble = true;
    woodDoubleAchievement.achieved = true;
    await secureStorage.setWoodDouble(woodDouble.toString());
  }

  getBronzeDouble() {
    return bronzeDouble;
  }
  achievedBronzeDouble() async {
    bronzeDouble = true;
    bronzeDoubleAchievement.achieved = true;
    await secureStorage.setBronzeDouble(bronzeDouble.toString());
  }

  getSilverDouble() {
    return silverDouble;
  }
  achievedSilverDouble() async {
    silverDouble = true;
    silverDoubleAchievement.achieved = true;
    await secureStorage.setSilverDouble(silverDouble.toString());
  }

  getGoldDouble() {
    return goldDouble;
  }
  achievedGoldDouble() async {
    goldDouble = true;
    goldDoubleAchievement.achieved = true;
    await secureStorage.setGoldDouble(goldDouble.toString());
  }

  getFlutterOne() {
    return flutterOne;
  }
  achievedFlutterOne() async {
    flutterOne = true;
    flutterOneAchievement.achieved = true;
    await secureStorage.setFlutterOne(flutterOne.toString());
  }

  getFlutterTwo() {
    return flutterTwo;
  }
  achievedFlutterTwo() async {
    flutterTwo = true;
    flutterTwoAchievement.achieved = true;
    await secureStorage.setFlutterTwo(flutterTwo.toString());
  }

  getFlutterThree() {
    return flutterThree;
  }
  achievedFlutterThree() async {
    flutterThree = true;
    flutterThreeAchievement.achieved = true;
    await secureStorage.setFlutterThree(flutterThree.toString());
  }

  getFlutterFour() {
    return flutterFour;
  }
  achievedFlutterFour() async {
    flutterFour = true;
    flutterFourAchievement.achieved = true;
    await secureStorage.setFlutterFour(flutterFour.toString());
  }

  getPipesOne() {
    return pipesOne;
  }
  achievedPipesOne() async {
    pipesOne = true;
    pipesOneAchievement.achieved = true;
    await secureStorage.setPipesOne(pipesOne.toString());
  }

  getPipesTwo() {
    return pipesTwo;
  }
  achievedPipesTwo() async {
    pipesTwo = true;
    pipesTwoAchievement.achieved = true;
    await secureStorage.setPipesTwo(pipesTwo.toString());
  }

  getPipesThree() {
    return pipesThree;
  }
  achievedPipesThree() async {
    pipesThree = true;
    pipesThreeAchievement.achieved = true;
    await secureStorage.setPipesThree(pipesThree.toString());
  }

  getPerseverance() {
    return perseverance;
  }
  achievedPerseverance() async {
    perseverance = true;
    perseveranceAchievement.achieved = true;
    await secureStorage.setPerseverance(perseverance.toString());
  }

  getNightOwl() {
    return nightOwl;
  }
  achievedNightOwl() async {
    nightOwl = true;
    nightOwlAchievement.achieved = true;
    await secureStorage.setNightOwl(nightOwl.toString());
  }

  getWingedWarrior() {
    return wingedWarrior;
  }
  achievedWingedWarrior() async {
    wingedWarrior = true;
    wingedWarriorAchievement.achieved = true;
    await secureStorage.setWingedWarrior(wingedWarrior.toString());
  }

  getPlatforms() {
    return platforms;
  }
  setPlatforms(bool platforms) {
    this.platforms = platforms;
  }
  achievedPlatforms() async {
    platforms = true;
    justAchievedPlatforms = true;
    platformsAchievement.achieved = true;
    await secureStorage.setPlatforms(platforms.toString());
  }

  checkPlatforms() {
    return justAchievedPlatforms;
  }
  platformsAchievementShown() {
    justAchievedPlatforms = false;
  }

  getLeaderboard() {
    return leaderboard;
  }
  achievedLeaderboard() async {
    leaderboard = true;
    leaderboardAchievement.achieved = true;
    await secureStorage.setLeaderboard(leaderboard.toString());
  }

  getLastDayPlayed() {
    return lastDayPlayed;
  }
  setLastDayPlayed(int lastDayPlayed) {
    this.lastDayPlayed = lastDayPlayed;
  }

  getDaysInARow() {
    return daysInARow;
  }
  setDaysInARow(int daysInARow) {
    this.daysInARow = daysInARow;
  }

  List<Achievement> getAchievementsAvailable() {
    if (allAchievementsAvailable == null) {
      return [];
    } else {
      return allAchievementsAvailable!;
    }
  }

  List<Achievement> achievedAchievementList() {
    List<Achievement> achievedAchievements = [];
    if (allAchievementsAvailable == null) {
      return [];
    } else {
      for (Achievement achievement in allAchievementsAvailable!) {
        if (achievement.achieved) {
          achievedAchievements.add(achievement);
        }
      }
      return achievedAchievements;
    }
  }

  Achievements getAchievements() {
    return Achievements(
        woodSingle,
        bronzeSingle,
        silverSingle,
        goldSingle,
        woodDouble,
        bronzeDouble,
        silverDouble,
        goldDouble,
        flutterOne,
        flutterTwo,
        flutterThree,
        flutterFour,
        pipesOne,
        pipesTwo,
        pipesThree,
        perseverance,
        nightOwl,
        wingedWarrior,
        platforms,
        leaderboard,
        lastDayPlayed,
        daysInARow
    );
  }

  checkWingedWarrior(ScoreScreenChangeNotifier scoreScreenChangeNotifier) {
    if (lastDayPlayed == -1) {
      // Set the previous day to today. We just store the day, that should be sufficient.
      lastDayPlayed = DateTime.now().day;
      var _ = storeLastDayPlayed(lastDayPlayed.toString());
    } else {
      int storedPreviousDay = lastDayPlayed;
      int currentDay = DateTime.now().day;
      int yesterday = DateTime.now().subtract(const Duration(days:1)).day;
      if (storedPreviousDay == currentDay) {
        // Do nothing, we already played today.
      } else {
        // It's a different day so we update the previous day so it can check it tomorrow.
        lastDayPlayed = DateTime.now().day;
        var _ = storeLastDayPlayed(lastDayPlayed.toString());
        // the stored and previous day is different.
        // The stored has to be yesterday.
        // Otherwise the user played on a different day besides yesterday.
        if (storedPreviousDay == yesterday) {
          // We can increase the daysInARow counter
          daysInARow += 1;
          var _ = storeDaysInARow(daysInARow.toString());
          if (daysInARow >= 7) {
            // 7 days in a row, you won the achievement.
            achievedWingedWarrior();
            scoreScreenChangeNotifier.addAchievement(wingedWarriorAchievement);
            scoreScreenChangeNotifier.notify();
          }
          return true;
        } else {
          // The user did not play yesterday, so we reset the counter.
          // It's possible that the user plays once a month for 10 months
          // with the days being sequential such that it will get this
          // achievement. We don't really mind this edge case.
          var _ = storeDaysInARow("1");
        }
      }
    }
    return false;
  }

  storeDaysInARow(String daysInARowString) async {
    await secureStorage.setDaysInARow(daysInARowString);
  }
  storeLastDayPlayed(String lastDayPlayedString) async {
    await secureStorage.setLastDayPlayed(lastDayPlayedString);
  }
}

class Achievements {

  bool woodSingle = false;
  bool bronzeSingle = false;
  bool silverSingle = false;
  bool goldSingle = false;
  bool woodDouble = false;
  bool bronzeDouble = false;
  bool silverDouble = false;
  bool goldDouble = false;
  bool flutterOne = false;
  bool flutterTwo = false;
  bool flutterThree = false;
  bool flutterFour = false;
  bool pipesOne = false;
  bool pipesTwo = false;
  bool pipesThree = false;
  bool perseverance = false;
  bool nightOwl = false;
  bool wingedWarrior = false;
  bool platforms = false;
  bool leaderboard = false;

  int lastDayPlayed = -1;
  int daysInARow = 0;

  Achievements(this.woodSingle, this.bronzeSingle, this.silverSingle, this.goldSingle, this.woodDouble, this.bronzeDouble, this.silverDouble, this.goldDouble, this.flutterOne, this.flutterTwo, this.flutterThree, this.flutterFour, this.pipesOne, this.pipesTwo, this.pipesThree, this.perseverance, this.nightOwl, this.wingedWarrior, this.platforms, this.leaderboard, this.lastDayPlayed, this.daysInARow);

  Achievements.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("wood_single")) {
      woodSingle = json["wood_single"];
    }
    if (json.containsKey("bronze_single")) {
      bronzeSingle = json["bronze_single"];
    }
    if (json.containsKey("silver_single")) {
      silverSingle = json["silver_single"];
    }
    if (json.containsKey("gold_single")) {
      goldSingle = json["gold_single"];
    }
    if (json.containsKey("wood_double")) {
      woodDouble = json["wood_double"];
    }
    if (json.containsKey("bronze_double")) {
      bronzeDouble = json["bronze_double"];
    }
    if (json.containsKey("silver_double")) {
      silverDouble = json["silver_double"];
    }
    if (json.containsKey("gold_double")) {
      goldDouble = json["gold_double"];
    }
    if (json.containsKey("flutter_one")) {
      flutterOne = json["flutter_one"];
    }
    if (json.containsKey("flutter_two")) {
      flutterTwo = json["flutter_two"];
    }
    if (json.containsKey("flutter_three")) {
      flutterThree = json["flutter_three"];
    }
    if (json.containsKey("flutter_four")) {
      flutterFour = json["flutter_four"];
    }
    if (json.containsKey("pipes_one")) {
      pipesOne = json["pipes_one"];
    }
    if (json.containsKey("pipes_two")) {
      pipesTwo = json["pipes_two"];
    }
    if (json.containsKey("pipes_three")) {
      pipesThree = json["pipes_three"];
    }
    if (json.containsKey("perseverance")) {
      perseverance = json["perseverance"];
    }
    if (json.containsKey("night_owl")) {
      nightOwl = json["night_owl"];
    }
    if (json.containsKey("winged_warrior")) {
      wingedWarrior = json["winged_warrior"];
    }
    if (json.containsKey("platforms")) {
      platforms = json["platforms"];
    }
    if (json.containsKey("leaderboard")) {
      leaderboard = json["leaderboard"];
    }
    if (json.containsKey("last_day_played")) {
      lastDayPlayed = json["last_day_played"];
    }
    if (json.containsKey("days_in_a_row")) {
      daysInARow = json["days_in_a_row"];
    }
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    if (woodSingle) {
      json['wood_single'] = woodSingle;
    }
    if (bronzeSingle) {
      json['bronze_single'] = bronzeSingle;
    }
    if (silverSingle) {
      json['silver_single'] = silverSingle;
    }
    if (goldSingle) {
      json['gold_single'] = goldSingle;
    }
    if (woodDouble) {
      json['wood_double'] = woodDouble;
    }
    if (bronzeDouble) {
      json['bronze_double'] = bronzeDouble;
    }
    if (silverDouble) {
      json['silver_double'] = silverDouble;
    }
    if (goldDouble) {
      json['gold_double'] = goldDouble;
    }
    if (flutterOne) {
      json['flutter_one'] = flutterOne;
    }
    if (flutterTwo) {
      json['flutter_two'] = flutterTwo;
    }
    if (flutterThree) {
      json['flutter_three'] = flutterThree;
    }
    if (flutterFour) {
      json['flutter_four'] = flutterFour;
    }
    if (pipesOne) {
      json['pipes_one'] = pipesOne;
    }
    if (pipesTwo) {
      json['pipes_two'] = pipesTwo;
    }
    if (pipesThree) {
      json['pipes_three'] = pipesThree;
    }
    if (perseverance) {
      json['perseverance'] = perseverance;
    }
    if (nightOwl) {
      json['night_owl'] = nightOwl;
    }
    if (wingedWarrior) {
      json['winged_warrior'] = wingedWarrior;
    }
    if (platforms) {
      json['platforms'] = platforms;
    }
    if (leaderboard) {
      json['leaderboard'] = leaderboard;
    }
    if (lastDayPlayed != -1) {
      json['last_day_played'] = lastDayPlayed;
    }
    if (daysInARow != 0) {
      json['days_in_a_row'] = daysInARow;
    }
    return json;
  }

  bool getWoodSingle() {
    return woodSingle;
  }
  setWoodSingle(bool woodSingle) {
    this.woodSingle = woodSingle;
  }

  bool getBronzeSingle() {
    return bronzeSingle;
  }
  setBronzeSingle(bool bronzeSingle) {
    this.bronzeSingle = bronzeSingle;
  }

  bool getSilverSingle() {
    return silverSingle;
  }
  setSilverSingle(bool silverSingle) {
    this.silverSingle = silverSingle;
  }

  bool getGoldSingle() {
    return goldSingle;
  }
  setGoldSingle(bool goldSingle) {
    this.goldSingle = goldSingle;
  }

  bool getWoodDouble() {
    return woodDouble;
  }
  setWoodDouble(bool woodDouble) {
    this.woodDouble = woodDouble;
  }

  bool getBronzeDouble() {
    return bronzeDouble;
  }
  setBronzeDouble(bool bronzeDouble) {
    this.bronzeDouble = bronzeDouble;
  }

  bool getSilverDouble() {
    return silverDouble;
  }
  setSilverDouble(bool silverDouble) {
    this.silverDouble = silverDouble;
  }

  bool getGoldDouble() {
    return goldDouble;
  }
  setGoldDouble(bool goldDouble) {
    this.goldDouble = goldDouble;
  }

  bool getFlutterOne() {
    return flutterOne;
  }
  setFlutterOne(bool flutterOne) {
    this.flutterOne = flutterOne;
  }

  bool getFlutterTwo() {
    return flutterTwo;
  }
  setFlutterTwo(bool flutterTwo) {
    this.flutterTwo = flutterTwo;
  }

  bool getFlutterThree() {
    return flutterThree;
  }
  setFlutterThree(bool flutterThree) {
    this.flutterThree = flutterThree;
  }

  bool getFlutterFour() {
    return flutterFour;
  }
  setFlutterFour(bool flutterFour) {
    this.flutterFour = flutterFour;
  }

  bool getPipesOne() {
    return pipesOne;
  }
  setPipesOne(bool pipesOne) {
    this.pipesOne = pipesOne;
  }

  bool getPipesTwo() {
    return pipesTwo;
  }
  setPipesTwo(bool pipesTwo) {
    this.pipesTwo = pipesTwo;
  }

  bool getPipesThree() {
    return pipesThree;
  }
  setPipesThree(bool pipesThree) {
    this.pipesThree = pipesThree;
  }

  bool getPerseverance() {
    return perseverance;
  }
  setPerseverance(bool perseverance) {
    this.perseverance = perseverance;
  }

  bool getNightOwl() {
    return nightOwl;
  }
  setNightOwl(bool nightOwl) {
    this.nightOwl = nightOwl;
  }

  bool getWingedWarrior() {
    return wingedWarrior;
  }
  setWingedWarrior(bool wingedWarrior) {
    this.wingedWarrior = wingedWarrior;
  }

  bool getPlatforms() {
    return platforms;
  }
  setPlatforms(bool platforms) {
    this.platforms = platforms;
  }

  bool getLeaderboard() {
    return leaderboard;
  }
  setLeaderboard(bool leaderboard) {
    this.leaderboard = leaderboard;
  }

  int getLastDayPlayed() {
    return lastDayPlayed;
  }
  setLastDayPlayed(int lastDayPlayed) {
    this.lastDayPlayed = lastDayPlayed;
  }

  int getDaysInARow() {
    return daysInARow;
  }
  setDaysInARow(int daysInARow) {
    this.daysInARow = daysInARow;
  }
}
