import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter_hotel_app_ui/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpdateProfileService {
  Future<Map<String, dynamic>> fetchUser() async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.updateProfile),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status': true, 'message': responseBody};
      } else {
        return {'status': false, 'message': responseBody['message']};
      }
    } catch (error) {
      print(error);
      return {
        'status': false,
        'message': 'An error occurred. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile(String fullname, String email,
      String phoneNumber, File? profilePhoto) async {
    phoneNumber = "60" + phoneNumber;
    try {
      String? attachment;
      if (profilePhoto != null) {
        attachment = base64Encode(profilePhoto.readAsBytesSync());
      }
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');
      final response = await http.post(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.updateProfile),
        body: jsonEncode({
          'fullname': fullname,
          'email': email,
          'userImage': attachment,
          'phoneNumber': phoneNumber
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'status': true,
          'message': responseBody['message'],
        };
      } else {
        return {'status': false, 'message': responseBody['message']};
      }
    } catch (error) {
      print(error);
      return {
        'status': false,
        'message': 'An error occurred. Please try again later.'
      };
    }
  }
}
