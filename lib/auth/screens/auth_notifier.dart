import 'package:flutter/foundation.dart';

class AuthNotifier with ChangeNotifier {
  AuthNotifier(this._isLoggedIn);

  bool _isLoggedIn;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}
