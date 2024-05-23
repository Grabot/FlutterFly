import 'package:flutter/material.dart';


class UserChangeNotifier extends ChangeNotifier {

  bool showProfile = false;
  bool showProfileOverview = true;

  static final UserChangeNotifier _instance = UserChangeNotifier._internal();

  UserChangeNotifier._internal();

  factory UserChangeNotifier() {
    return _instance;
  }

  setProfileVisible(bool visible) {
    showProfile = visible;
    notifyListeners();
  }

  getProfileVisible() {
    return showProfile;
  }

  setProfileOverviewVisible(bool visible) {
    showProfileOverview = visible;
    notifyListeners();
  }

  getProfileOverviewVisible() {
    return showProfileOverview;
  }

  notify() {
    notifyListeners();
  }

}
