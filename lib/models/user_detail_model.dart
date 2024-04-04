// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserDetailModel {
  String userId;
  String fullname;
  String email;
  String phone;
  String userImage;
  String userCountry;

  UserDetailModel({
    required this.userId,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.userImage,
    required this.userCountry,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    String apiEndpoint =
        ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.userProfile;
    return UserDetailModel(
      userId: json['userId'].toString(),
      fullname: json['userFullName'],
      email: json['userEmail'],
      phone: json['phoneNumber'].toString(),
      userImage: apiEndpoint + json['userImage'],
      userCountry: json['userCountry'],
    );
  }

  static Future<List<UserDetailModel>> getUserById(String userId) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    Map<String, dynamic> parameters = {
      'userId': userId,
    };

    final response = await http.get(
      Uri.parse(
              ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.getUserDetail)
          .replace(queryParameters: parameters),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((userJson) => UserDetailModel.fromJson(userJson))
          .toList();
    } else {
      print('Failed to load user detail`');
      throw Exception('Failed to load user detail');
    }
  }

  static Future<List<UserDetailModel>> getAllUser() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.updateUser),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((userJson) => UserDetailModel.fromJson(userJson))
          .toList();
    } else {
      print('Failed to load user detail`');
      throw Exception('Failed to load user detail');
    }
  }
}
