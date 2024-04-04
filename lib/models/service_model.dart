import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:http/http.dart' as http;

class ServiceModel {
  final String serviceId;
  final String serviceDate;
  final String serviceStatus;
  final String userServiceNotes;
  final String adminServiceNotes;
  final String houseId;
  final String userId;

  ServiceModel({
    required this.serviceId,
    required this.serviceDate,
    required this.serviceStatus,
    required this.userServiceNotes,
    required this.adminServiceNotes,
    required this.houseId,
    required this.userId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['serviceId'].toString(),
      serviceDate: json['serviceDate'].split(' ').sublist(0, 4).join(' '),
      serviceStatus: json['serviceStatus'],
      userServiceNotes: json['userServiceNote'],
      adminServiceNotes: json['adminServiceNote'] ?? 'Service is pending',
      houseId: json['houseId'].toString(),
      userId: json['userId'].toString(),
    );
  }

  static Future<List<ServiceModel>> getService(String reservationId) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    Map<String, dynamic> parameters = {
      'reservationId': reservationId,
    };

    final response = await http.get(
      Uri.parse(ApiEndPoints.baseUrl +
              ApiEndPoints.userEndpoints.userServiceRequest)
          .replace(queryParameters: parameters),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((serviceJson) => ServiceModel.fromJson(serviceJson))
          .toList();
    } else {
      print('Failed to load services');
      throw Exception('Failed to load services');
    }
  }

  static Future<List<ServiceModel>> adminGetService(
      String serviceStatus) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse(ApiEndPoints.baseUrl +
              ApiEndPoints.adminEndpoints.adminServiceRequest)
          .replace(queryParameters: {
        'serviceStatus': serviceStatus,
      }),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((serviceJson) => ServiceModel.fromJson(serviceJson))
          .toList();
    } else {
      print('Failed to load services');
      throw Exception('Failed to load services');
    }
  }
}
