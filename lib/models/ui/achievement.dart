
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutterfly/services/rest/auth_service_setting.dart';
import 'package:flutterfly/util/change_notifiers/achievement_box_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/achievement_close_up_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/score_screen_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';
import 'package:flutterfly/util/web_storage.dart';

class Achievement {

  late String achievementName;
  late String imageName;
  late String tooltip;
  bool achieved = false;
  Uint8List? imageContent;
  bool retrieveRequested = false;

  late SecureStorage secureStorage;

  Achievement({
    required this.achievementName,
    required this.imageName,
    required this.tooltip,
    required this.achieved,
    required this.secureStorage
  });

  @override
  bool operator ==(Object other) {
    if (other is Achievement) {
      return achievementName == other.getAchievementName()
          && imageName == other.getImageName()
          && tooltip == other.getTooltip()
          && achieved == other.getAchieved();
    }
    return false;
  }

  @override
  int get hashCode => achievementName.hashCode ^ imageName.hashCode ^ tooltip.hashCode ^ achieved.hashCode;

  getAchievementName() {
    return achievementName;
  }

  getImageName() {
    return imageName;
  }

  notifyCorrectWindow(int origin) {
    if (origin == 0) {
      // It came from the achievement box window
      AchievementBoxChangeNotifier().notify();
    } else if (origin == 1) {
      // It came from the achievement close up window
      AchievementCloseUpChangeNotifier().notify();
    } else if (origin == 2) {
      // it came from the profile overview
      UserChangeNotifier().notify();
    } else {
      // it came from the score screen
      ScoreScreenChangeNotifier().notify();
    }
  }

  Uint8List? getAchievementImage(int origin) {
    // We only want to retrieve the image if it's needed.
    if (imageContent == null) {
      secureStorage.getWoodSingleImage().then((value) {
        if (value != null) {
          Uint8List avatar = base64Decode(value.replaceAll("\n", ""));
          imageContent = avatar;
          // We don't return it here, because we have already returned null
          // It took time to retrieve the image from storage.
          // We will notify the UI when the image is ready.
          notifyCorrectWindow(origin);
        } else {
          if (!retrieveRequested) {
            retrieveRequested = true;
            // Image not in storage yet, so we retrieve it from the server.
            AuthServiceSetting().getAchievementImage(imageName).then((value) {
              if (value != null) {
                // Image retrieved from server, so we store it in the storage.
                // If no image found we do nothing, since it was an error.
                secureStorage.setWoodSingleImage(value);
                Uint8List avatar = base64Decode(value.replaceAll("\n", ""));
                imageContent = avatar;
                // We don't return it here, because we have already returned null
                // It took time to retrieve the image from storage or server.
                // We will notify the UI now that the image is ready.
                notifyCorrectWindow(origin);
              }
              // reset the request flag in case it failed
              retrieveRequested = false;
            });
          }
        }
      });
    } else {
      return imageContent;
    }
    return null;
  }

  getImagePath() {
    return getDefaultImagePath();
  }

  getDefaultImagePath() {
    return "assets/images/default_achievement.png";
  }

  getTooltip() {
    return tooltip;
  }

  getAchieved() {
    return achieved;
  }
}
