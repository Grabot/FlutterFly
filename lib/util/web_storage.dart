import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorage {

  final storage = const FlutterSecureStorage();

  final String _keyAccessToken = 'accessToken';
  final String _keyRefreshToken = 'refreshToken';

  Future setAccessToken(String accessToken) async {
    await storage.write(key: _keyAccessToken, value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: _keyAccessToken);
  }

  Future setRefreshToken(String refreshToken) async {
    await storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: _keyRefreshToken);
  }

  final String _keyBestScoreSingleButterfly = 'bestScoreSingleButterfly';
  final String _keyBestScoreDoubleButterfly = 'bestScoreDoubleButterfly';
  final String _keyTotalFluttersToken = 'totalFlutterToken';
  final String _keyTotalPipesToken = 'totalPipesToken';
  final String _keyTotalGamesToken = 'totalGamesToken';

  Future setTotalFlutters(String totalFlutters) async {
    await storage.write(key: _keyTotalFluttersToken, value: totalFlutters);
  }

  Future<String?> getTotalFlutters() async {
    return await storage.read(key: _keyTotalFluttersToken);
  }

  Future setTotalPipes(String totalPipes) async {
    await storage.write(key: _keyTotalPipesToken, value: totalPipes);
  }

  Future<String?> getTotalPipes() async {
    return await storage.read(key: _keyTotalPipesToken);
  }

  Future setTotalGames(String totalGames) async {
    await storage.write(key: _keyTotalGamesToken, value: totalGames);
  }

  Future<String?> getTotalGames() async {
    return await storage.read(key: _keyTotalGamesToken);
  }

  Future setBestScoreSingleButterfly(String bestScoreSingleButterfly) async {
    await storage.write(key: _keyBestScoreSingleButterfly, value: bestScoreSingleButterfly);
  }

  Future<String?> getBestScoreSingleButterfly() async {
    return await storage.read(key: _keyBestScoreSingleButterfly);
  }

  Future setBestScoreDoubleButterfly(String bestScoreDoubleButterfly) async {
    await storage.write(key: _keyBestScoreDoubleButterfly, value: bestScoreDoubleButterfly);
  }

  Future<String?> getBestScoreDoubleButterfly() async {
    return await storage.read(key: _keyBestScoreDoubleButterfly);
  }

  final String _keyButterflyType1 = 'butterflyType1';
  final String _keyButterflyType2 = 'butterflyType2';
  final String _keyPipeType = 'pipeType';
  final String _keyPlayerType = 'playerType';
  final String _keySound = 'sound';
  final String _keyButtonVisibility = 'buttonVisibility';

  Future setButterflyType1(String butterflyType1) async {
    await storage.write(key: _keyButterflyType1, value: butterflyType1);
  }

  Future<String?> getButterflyType1() async {
    return await storage.read(key: _keyButterflyType1);
  }

  Future setButterflyType2(String butterflyType2) async {
    await storage.write(key: _keyButterflyType2, value: butterflyType2);
  }

  Future<String?> getButterflyType2() async {
    return await storage.read(key: _keyButterflyType2);
  }

  Future setPipeType(String pipeType) async {
    await storage.write(key: _keyPipeType, value: pipeType);
  }

  Future<String?> getPipeType() async {
    return await storage.read(key: _keyPipeType);
  }

  Future setPlayerType(String playerType) async {
    await storage.write(key: _keyPlayerType, value: playerType);
  }

  Future<String?> getPlayerType() async {
    return await storage.read(key: _keyPlayerType);
  }

  Future setSound(String sound) async {
    await storage.write(key: _keySound, value: sound);
  }

  Future<String?> getSound() async {
    return await storage.read(key: _keySound);
  }

  Future setButtonVisibility(String buttonVisibility) async {
    await storage.write(key: _keyButtonVisibility, value: buttonVisibility);
  }

  Future<String?> getButtonVisibility() async {
    return await storage.read(key: _keyButtonVisibility);
  }

  final String _keyWoodSingle = 'woodSingle';
  final String _keyBronzeSingle = 'bronzeSingle';
  final String _keySilverSingle = 'silverSingle';
  final String _keyGoldSingle = 'goldSingle';
  final String _keyWoodDouble = 'bronzeDouble';
  final String _keyBronzeDouble = 'bronzeDouble';
  final String _keySilverDouble = 'silverDouble';
  final String _keyGoldDouble = 'goldDouble';
  final String _keyFlutterOne = 'flutterOne';
  final String _keyFlutterTwo = 'flutterTwo';
  final String _keyFlutterThree = 'flutterThree';
  final String _keyFlutterFour = 'flutterFour';
  final String _keyPipesOne = 'pipesOne';
  final String _keyPipesTwo = 'pipesTwo';
  final String _keyPipesThree = 'pipesThree';
  final String _keyPerseverance = 'perseverance';
  final String _keyNightOwl = 'nightOwl';
  final String _keyWingedWarrior = 'wingedWarrior';
  final String _keyPlatforms = 'platforms';
  final String _keyLeaderboard = 'leaderboard';

  final String _keyWoodSingleImage = 'woodSingleImage';

  Future setWoodSingle(String woodSingle) async {
    await storage.write(key: _keyWoodSingle, value: woodSingle);
  }
  Future<String?> getWoodSingle() async {
    return await storage.read(key: _keyWoodSingle);
  }

  Future setWoodSingleImage(String woodSingleImage) async {
    await storage.write(key: _keyWoodSingleImage, value: woodSingleImage);
  }
  Future<String?> getWoodSingleImage() async {
    return await storage.read(key: _keyWoodSingleImage);
  }

  Future setBronzeSingle(String bronzeSingle) async {
    await storage.write(key: _keyBronzeSingle, value: bronzeSingle);
  }
  Future<String?> getBronzeSingle() async {
    return await storage.read(key: _keyBronzeSingle);
  }

  Future setSilverSingle(String silverSingle) async {
    await storage.write(key: _keySilverSingle, value: silverSingle);
  }
  Future<String?> getSilverSingle() async {
    return await storage.read(key: _keySilverSingle);
  }

  Future setGoldSingle(String goldSingle) async {
    await storage.write(key: _keyGoldSingle, value: goldSingle);
  }
  Future<String?> getGoldSingle() async {
    return await storage.read(key: _keyGoldSingle);
  }

  Future setWoodDouble(String woodDouble) async {
    await storage.write(key: _keyWoodDouble, value: woodDouble);
  }
  Future<String?> getWoodDouble() async {
    return await storage.read(key: _keyWoodDouble);
  }

  Future setBronzeDouble(String bronzeDouble) async {
    await storage.write(key: _keyBronzeDouble, value: bronzeDouble);
  }
  Future<String?> getBronzeDouble() async {
    return await storage.read(key: _keyBronzeDouble);
  }

  Future setSilverDouble(String silverDouble) async {
    await storage.write(key: _keySilverDouble, value: silverDouble);
  }
  Future<String?> getSilverDouble() async {
    return await storage.read(key: _keySilverDouble);
  }

  Future setGoldDouble(String goldDouble) async {
    await storage.write(key: _keyGoldDouble, value: goldDouble);
  }
  Future<String?> getGoldDouble() async {
    return await storage.read(key: _keyGoldDouble);
  }

  Future setFlutterOne(String flutterOne) async {
    await storage.write(key: _keyFlutterOne, value: flutterOne);
  }
  Future<String?> getFlutterOne() async {
    return await storage.read(key: _keyFlutterOne);
  }

  Future setFlutterTwo(String flutterTwo) async {
    await storage.write(key: _keyFlutterTwo, value: flutterTwo);
  }
  Future<String?> getFlutterTwo() async {
    return await storage.read(key: _keyFlutterTwo);
  }

  Future setFlutterThree(String flutterThree) async {
    await storage.write(key: _keyFlutterThree, value: flutterThree);
  }
  Future<String?> getFlutterThree() async {
    return await storage.read(key: _keyFlutterThree);
  }

  Future setFlutterFour(String flutterFour) async {
    await storage.write(key: _keyFlutterFour, value: flutterFour);
  }
  Future<String?> getFlutterFour() async {
    return await storage.read(key: _keyFlutterFour);
  }

  Future setPipesOne(String pipesOne) async {
    await storage.write(key: _keyPipesOne, value: pipesOne);
  }
  Future<String?> getPipesOne() async {
    return await storage.read(key: _keyPipesOne);
  }

  Future setPipesTwo(String pipesTwo) async {
    await storage.write(key: _keyPipesTwo, value: pipesTwo);
  }
  Future<String?> getPipesTwo() async {
    return await storage.read(key: _keyPipesTwo);
  }

  Future setPipesThree(String pipesThree) async {
    await storage.write(key: _keyPipesThree, value: pipesThree);
  }
  Future<String?> getPipesThree() async {
    return await storage.read(key: _keyPipesThree);
  }

  Future setPerseverance(String perseverance) async {
    await storage.write(key: _keyPerseverance, value: perseverance);
  }
  Future<String?> getPerseverance() async {
    return await storage.read(key: _keyPerseverance);
  }

  Future setNightOwl(String nightOwl) async {
    await storage.write(key: _keyNightOwl, value: nightOwl);
  }
  Future<String?> getNightOwl() async {
    return await storage.read(key: _keyNightOwl);
  }

  Future setWingedWarrior(String wingedWarrior) async {
    await storage.write(key: _keyWingedWarrior, value: wingedWarrior);
  }
  Future<String?> getWingedWarrior() async {
    return await storage.read(key: _keyWingedWarrior);
  }

  Future setPlatforms(String platforms) async {
    await storage.write(key: _keyPlatforms, value: platforms);
  }
  Future<String?> getPlatforms() async {
    return await storage.read(key: _keyPlatforms);
  }

  Future setLeaderboard(String leaderboard) async {
    await storage.write(key: _keyLeaderboard, value: leaderboard);
  }
  Future<String?> getLeaderboard() async {
    return await storage.read(key: _keyLeaderboard);
  }

  Future logout() async {
    await storage.write(key: _keyAccessToken, value: null);
    await storage.write(key: _keyRefreshToken, value: null);

    await storage.write(key: _keyBestScoreSingleButterfly, value: null);
    await storage.write(key: _keyBestScoreDoubleButterfly, value: null);
    await storage.write(key: _keyTotalFluttersToken, value: null);
    await storage.write(key: _keyTotalPipesToken, value: null);
    await storage.write(key: _keyTotalGamesToken, value: null);

    await storage.write(key: _keyButterflyType1, value: null);
    await storage.write(key: _keyButterflyType2, value: null);
    await storage.write(key: _keyPipeType, value: null);
    await storage.write(key: _keyPlayerType, value: null);
    await storage.write(key: _keySound, value: null);

    await storage.write(key: _keyWoodSingle, value: null);
    await storage.write(key: _keyBronzeSingle, value: null);
    await storage.write(key: _keySilverSingle, value: null);
    await storage.write(key: _keyGoldSingle, value: null);
    await storage.write(key: _keyBronzeDouble, value: null);
    await storage.write(key: _keyWoodDouble, value: null);
    await storage.write(key: _keySilverDouble, value: null);
    await storage.write(key: _keyGoldDouble, value: null);
    await storage.write(key: _keyFlutterOne, value: null);
    await storage.write(key: _keyFlutterTwo, value: null);
    await storage.write(key: _keyFlutterThree, value: null);
    await storage.write(key: _keyFlutterFour, value: null);
    await storage.write(key: _keyPipesOne, value: null);
    await storage.write(key: _keyPipesTwo, value: null);
    await storage.write(key: _keyPipesThree, value: null);
    await storage.write(key: _keyPerseverance, value: null);
    await storage.write(key: _keyNightOwl, value: null);
    await storage.write(key: _keyWingedWarrior, value: null);
    await storage.write(key: _keyPlatforms, value: null);
    await storage.write(key: _keyLeaderboard, value: null);
    await storage.write(key: _keyLastDayPlayed, value: null);
    await storage.write(key: _keyDaysInARow, value: null);
  }

  final String _keyLastDayPlayed = 'lastDayPlayed';
  final String _keyDaysInARow = 'daysInARow';

  Future setLastDayPlayed(String lastDayPlayed) async {
    await storage.write(key: _keyLastDayPlayed, value: lastDayPlayed);
  }
  Future<String?> getLastDayPlayed() async {
    return await storage.read(key: _keyLastDayPlayed);
  }

  Future setDaysInARow(String daysInARow) async {
    await storage.write(key: _keyDaysInARow, value: daysInARow);
  }
  Future<String?> getDaysInARow() async {
    return await storage.read(key: _keyDaysInARow);
  }
}
