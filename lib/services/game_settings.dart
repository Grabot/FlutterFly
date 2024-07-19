import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfly/util/change_notifiers/leader_board_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';
import 'package:flutterfly/util/web_storage.dart';


class GameSettings extends ChangeNotifier {
  static final GameSettings _instance = GameSettings._internal();

  int butterflyType1 = 0;
  int butterflyType2 = 1;
  int pipeType = 0;
  int playerType = 0;

  int storageLoaded = 0;

  bool sound = true;
  bool buttonVisibility = true;

  SecureStorage secureStorage = SecureStorage();

  GameSettings._internal() {
    // Retrieve game settings
    secureStorage.getPlayerType().then((value) {
      if (value != null) {
        int newPlayerType = int.parse(value);
        if (newPlayerType != playerType) {
          playerType = newPlayerType;
          LeaderBoardChangeNotifier().setTwoPlayer(playerType == 0);
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getButterflyType1().then((value) {
      if (value != null) {
        int newButterflyType1 = int.parse(value);
        if (newButterflyType1 != butterflyType1) {
          butterflyType1 = newButterflyType1;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getButterflyType2().then((value) {
      if (value != null) {
        int newButterflyType2 = int.parse(value);
        if (newButterflyType2 != butterflyType2) {
          butterflyType2 = newButterflyType2;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getPipeType().then((value) {
      if (value != null) {
        int newPipeType = int.parse(value);
        if (newPipeType != pipeType) {
          pipeType = newPipeType;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getSound().then((value) {
      if (value != null) {
        bool soundType = bool.parse(value);
        if (soundType != sound) {
          sound = soundType;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getButtonVisibility().then((value) {
      if (value != null) {
        bool buttonVisibilityType = bool.parse(value);
        if (buttonVisibilityType != buttonVisibility) {
          buttonVisibility = buttonVisibilityType;
          UserChangeNotifier().setProfileOverviewVisible(buttonVisibility);
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
  }

  checkIfShouldNotify() {
    if (storageLoaded == 6) {
      // quick check to see if both butterfly types are given the same value.
      if (butterflyType1 == butterflyType2) {
        if (butterflyType1 != 0) {
          butterflyType1 = 0;
        } else {
          butterflyType1 = 1;
        }
        secureStorage.setButterflyType1(butterflyType1.toString());
      }
      notify();
    }
  }

  factory GameSettings() {
    return _instance;
  }

  notify() {
    notifyListeners();
  }

  setButterflyType1(int butterflyType1) {
    this.butterflyType1 = butterflyType1;
    secureStorage.setButterflyType1(butterflyType1.toString());
  }

  int getButterflyType1() {
    return butterflyType1;
  }

  setButterflyType2(int butterflyType2) {
    this.butterflyType2 = butterflyType2;
    secureStorage.setButterflyType2(butterflyType2.toString());
  }

  int getButterflyType2() {
    return butterflyType2;
  }

  setPipeType(int pipeType) {
    this.pipeType = pipeType;
    secureStorage.setPipeType(pipeType.toString());
  }

  int getPipeType() {
    return pipeType;
  }

  int getPlayerType() {
    return playerType;
  }

  setPlayerType(int playerType) {
    this.playerType = playerType;
    secureStorage.setPlayerType(playerType.toString());
  }

  setSound(bool sound) {
    this.sound = sound;
    secureStorage.setSound(sound.toString());
  }

  bool getSound() {
    return sound;
  }

  setButtonVisibility(bool buttonVisibility) {
    this.buttonVisibility = buttonVisibility;
    secureStorage.setButtonVisibility(buttonVisibility.toString());
  }

  bool getButtonVisibility() {
    return buttonVisibility;
  }

  logout() {
    butterflyType1 = 0;
    butterflyType2 = 1;
    pipeType = 0;
    playerType = 0;
    sound = false;
    buttonVisibility = false;
    notifyListeners();
  }
}
