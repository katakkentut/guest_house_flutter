import 'package:flutter/foundation.dart';

class AuthNotifier with ChangeNotifier {
  AuthNotifier(this._isLoggedIn, this._userType);

  bool _isLoggedIn;
  String _userType;

  bool get isLoggedIn => _isLoggedIn;
  String get userType => _userType;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setUserType(String value) {
    _userType = value;
    notifyListeners();
  }
}