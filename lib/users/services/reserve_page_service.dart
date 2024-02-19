import 'dart:convert';

import 'package:flutter_hotel_app_ui/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ReservePageService {
  Future<List<String>> getReservation(String houseId) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl +
            ApiEndPoints.authEndpoints.reservation +
            '?houseId=$houseId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        List<String> responseBody =
            List<String>.from(jsonDecode(response.body));
        return responseBody;
      } else {
        throw Exception('Failed to load reservation');
      }
    } catch (error) {
      print(error);
    throw Exception('An error occurred. Please try again later.');
    }
  }
}
