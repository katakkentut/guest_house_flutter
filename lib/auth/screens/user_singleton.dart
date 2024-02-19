// user_singleton.dart

class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();

  String? userId;

  factory UserSingleton() {
    return _instance;
  }

  UserSingleton._internal();
}
