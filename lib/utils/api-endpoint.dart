// ignore_for_file: non_constant_identifier_names

class ApiEndPoints {
  static const String baseUrl = 'https://nqp82lpb-5050.asse.devtunnels.ms/';

  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'authenticate/login';
  final String register = 'authenticate/register';
  final String homepage = 'services/homepage';
  final String userProfile = 'images/';
  final String houseImages = 'house/images/';
  final String favourite = 'services/favourite';
  final String updateProfile = 'services/update-profile';
  final String resetPassword = 'services/reset-password';
  final String favouriteList = 'services/favourite';
  final String reservation = 'services/house-reservation';
  final String selectedHouse = 'services/get-house';
}
