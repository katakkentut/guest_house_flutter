import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:http/http.dart' as http;

class UpdateHouseService {
  Future<Map<String, dynamic>> editHouse(String houseId, String price) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.post(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.updateHouse),
        body: jsonEncode({
          'service': 'updateHousePrice',
          'houseId': houseId,
          'housePrice': price,
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

  Future<Map<String, dynamic>> deleteHouse(String houseId) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.post(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.updateHouse),
        body: jsonEncode({'service': 'deleteHouse', 'houseId': houseId}),
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
