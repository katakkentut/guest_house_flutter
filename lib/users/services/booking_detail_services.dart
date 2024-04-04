import 'dart:convert';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BookingDetailService {
  Future<Map<String, dynamic>> deleteReservation(String bookId) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.post(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.cancelService),
        body: jsonEncode({
          'reservationId': bookId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status': true, 'message': responseBody['message']};
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

  Future<Map<String, dynamic>> userServiceRequest(
      String bookId, String serviceNote) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl +
            ApiEndPoints.userEndpoints.userServiceRequest),
        body: jsonEncode({
          'reservationId': bookId,
          'serviceNote': serviceNote,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status': true, 'message': responseBody['message']};
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
