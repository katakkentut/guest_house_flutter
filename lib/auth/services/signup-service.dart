import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:guest_house_app/utils/api-endpoint.dart';

class SignUpService {
  Future<Map<String, dynamic>> registerUser(String fullname, String email,
      String password, String phoneNumber, File profilePhoto, String country) async {
    phoneNumber = "60" + phoneNumber;
    try {
      String? attachment;
      // ignore: unnecessary_null_comparison
      if (profilePhoto != null) {
        attachment = base64Encode((profilePhoto).readAsBytesSync());
      }

      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.register),
        body: jsonEncode({
          'fullname': fullname,
          'email': email,
          'password': password,
          'userImage': attachment,
          'phoneNumber': phoneNumber,
          'country': country
        }),
        headers: {'Content-Type': 'application/json'},
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status': true, 'message': responseBody['message'], 'userid': responseBody['userid']};
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
