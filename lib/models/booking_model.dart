import 'dart:convert';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BookingModel {
  final DateTime dateFrom;
  final DateTime dateTo;
  final String houseId;
  final String houseName;
  final String status;
  final double totalAmount;
  final String bookingId;
  final String houseThumbnail;
  final double housePrice;
  final String bookHouseStatus;
  final String userId;

  BookingModel({
    required this.dateFrom,
    required this.dateTo,
    required this.houseId,
    required this.houseName,
    required this.status,
    required this.totalAmount,
    required this.bookingId,
    required this.houseThumbnail,
    required this.housePrice,
    required this.bookHouseStatus,
    required this.userId,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      dateFrom:
          DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(json['bookStartDate']),
      dateTo:
          DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(json['bookEndDate']),
      houseId: json['houseId'].toString(),
      houseName: json['houseName'],
      status: json['bookStatus'],
      totalAmount: json['totalAmount'],
      bookingId: json['reservationId'].toString(),
      houseThumbnail: json['houseThumbnail'],
      housePrice: json['housePrice'],
      bookHouseStatus: json['bookHouseStatus'],
      userId: json['userId'].toString(),
    );
  }

  static Future<List<BookingModel>> getBooking(String bookType) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    Map<String, dynamic> parameters = {
      'bookStatus': bookType,
    };

    final response = await http.get(
      Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.userBooking)
          .replace(queryParameters: parameters),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((bookingJson) => BookingModel.fromJson(bookingJson))
          .toList();
    } else {
      print('Failed to load hotels');
      throw Exception('Failed to load hotels');
    }
  }

  static Future<List<BookingModel>> getAllBooking(String bookType) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    Map<String, dynamic> parameters = {
      'bookStatus': bookType,
    };

    final response = await http.get(
      Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.getAllBooking)
          .replace(queryParameters: parameters),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((bookingJson) => BookingModel.fromJson(bookingJson))
          .toList();
    } else {
      print('Failed to load hotels');
      throw Exception('Failed to load hotels');
    }
  }
}
