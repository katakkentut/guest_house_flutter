import 'dart:convert';

import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HomePageService {
  Future getHomePageData() async {

    final response = await http.get(Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.userProfile ));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> addFavourite(String houseId) async {
    try {

      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.favourite),
        body: jsonEncode({
          'house_id': houseId,
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
          'message': responseBody['message']
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
