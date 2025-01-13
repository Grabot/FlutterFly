import 'package:flutter/material.dart';


class AreYouSureBoxChangeNotifier extends ChangeNotifier {

  bool showAreYouSure = false;

  int? userId;

  bool showLogout = false;
  bool showDelete = false;

  static final AreYouSureBoxChangeNotifier _instance = AreYouSureBoxChangeNotifier._internal();

  AreYouSureBoxChangeNotifier._internal();

  factory AreYouSureBoxChangeNotifier() {
    return _instance;
  }

  setAreYouSureBoxVisible(bool visible) {
    showAreYouSure = visible;
    notifyListeners();
  }

  getAreYouSureBoxVisible() {
    return showAreYouSure;
  }

  setUserId(int? userId) {
    this.userId = userId;
  }

  int? getUserId() {
    return userId;
  }

  setShowLogout(bool showLogout) {
    this.showLogout = showLogout;
  }

  getShowLogout() {
    return showLogout;
  }

  setShowDelete(bool showDelete) {
    this.showDelete = showDelete;
  }

  getShowDelete() {
    return showDelete;
  }
}
