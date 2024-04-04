// ignore_for_file: non_constant_identifier_names

class ApiEndPoints {
  static const String baseUrl = 'https://nqp82lpb-5050.asse.devtunnels.ms/';

  static _UserServiceEndPoints userEndpoints = _UserServiceEndPoints();
  static _AdminServiceEndPoints adminEndpoints = _AdminServiceEndPoints();

}

class _UserServiceEndPoints {
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
  final String userBooking = 'services/user-reservation';
  final String checkUser = 'services/update-status'; 
  final String cancelService = 'services/cancel-reservation';
  final String userServiceRequest = 'services/service-request';
  final String houseFeedback = 'services/house-feedback';
  final String housePolicy = 'services/house-policy';
}

class _AdminServiceEndPoints {
 final String getAllBooking = 'services/admin/all-reservation';
 final String getUserDetail = 'services/admin/user-detail';
 final String addHouse = 'services/admin/add-house';
 final String approveBooking = 'services/admin/approve-reservation';
 final String adminServiceRequest = 'services/admin/service-request';
 final String updateUser = 'services/admin/update-user';
 final String updateHouse = 'services/admin/update-house';
 final String allHouse = 'services/admin/all-house';
}
