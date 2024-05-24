import 'package:flutter/material.dart';
import 'package:flutterfly/util/change_notifiers/change_avatar_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/loading_box_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/login_screen_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';


class ClearUI extends ChangeNotifier {

  static final ClearUI _instance = ClearUI._internal();

  ClearUI._internal();

  factory ClearUI() {
    return _instance;
  }

  isUiElementVisible() {
    if (UserChangeNotifier().getProfileVisible()
        || ChangeAvatarChangeNotifier().getChangeAvatarVisible()
        || LoadingBoxChangeNotifier().getLoadingBoxVisible()
        || LoginScreenChangeNotifier().getLoginScreenVisible()
    ) {
      return true;
    }
    return false;
  }

  clearUserInterfaces() {
    if (ChangeAvatarChangeNotifier().getChangeAvatarVisible()) {
      ChangeAvatarChangeNotifier().setChangeAvatarVisible(false);
    }
    if (LoadingBoxChangeNotifier().getLoadingBoxVisible()) {
      LoadingBoxChangeNotifier().setLoadingBoxVisible(false);
    }
    if (UserChangeNotifier().getProfileVisible()) {
      UserChangeNotifier().setProfileVisible(false);
    }
    if (LoginScreenChangeNotifier().getLoginScreenVisible()) {
      LoginScreenChangeNotifier().setLoginScreenVisible(false);
    }
  }
}
