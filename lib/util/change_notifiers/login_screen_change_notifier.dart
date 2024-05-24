import 'package:flutter/material.dart';


class LoginScreenChangeNotifier extends ChangeNotifier {

  bool showLoginScreen = false;

  static final LoginScreenChangeNotifier _instance = LoginScreenChangeNotifier._internal();

  LoginScreenChangeNotifier._internal();

  factory LoginScreenChangeNotifier() {
    return _instance;
  }

  setLoginScreenVisible(bool visible) {
    showLoginScreen = visible;
    notifyListeners();
  }

  getLoginScreenVisible() {
    return showLoginScreen;
  }
}
