import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hotel_app_ui/utils/api-endpoint.dart';

class SignInService {
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.login),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final storage = FlutterSecureStorage();
        await storage.write(key: 'accessToken', value: responseBody['token']);
        await storage.write(
            key: 'userid', value: responseBody['userid'].toString());
        return {'status': true, 'message': 'Login successful'};
      } else {
        return {'status': false, 'message': responseBody['message']};
      }
    } catch (error) {
      print(error);
      return {'status': false, 'message': 'Invalid email or password.'};
    }
  }
}
