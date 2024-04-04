// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReservePageService {
  Future<List<String>> getReservation(String houseId) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl +
            ApiEndPoints.userEndpoints.reservation +
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
      return [];
    }
  }

  Future<Map<String, dynamic>> makeReservation(
      String houseId,
      String bookingFrom,
      String bookingTo,
      int adultNumber,
      int childrenNumber,
      double totalPrice,
      String? bookingNote) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      DateFormat inputFormat = DateFormat("d MMM yyyy");
      DateTime date = inputFormat.parse(bookingFrom);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      String bookingFromFormat = outputFormat.format(date);

      DateTime date1 = inputFormat.parse(bookingTo);
      DateFormat outputFormat1 = DateFormat("yyyy-MM-dd");
      String bookingToFormat = outputFormat1.format(date1);

      final response = await http.post(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.reservation),
        body: jsonEncode({
          'houseId': houseId,
          'bookStartDate': bookingFromFormat,
          'bookEndDate': bookingToFormat,
          'adultNumber': adultNumber,
          'childrenNumber': childrenNumber,
          'bookingNote': bookingNote,
          'totalAmount': totalPrice
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
