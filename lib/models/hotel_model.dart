// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HotelModel {
  final String id;
  final String houseName;
  final String houseCategory;
  final String houseDescription;
  final String houseThumbnail;
  final String houseBed;
  final String housePeople;
  final double housePrice;
  final String houseStatus;
  final String houseAvailability;
  final String houseLocation;
  final String houseAddress;
  final double? ratingScore;
  final int totalReview;
  final List<String> houseImages;
  final List<String> houseFacility;
  final List<UserReview> userReview;

  HotelModel({
    required this.id,
    required this.houseName,
    required this.houseCategory,
    required this.houseDescription,
    required this.houseThumbnail,
    required this.houseBed,
    required this.housePeople,
    required this.housePrice,
    required this.houseStatus,
    required this.houseAvailability,
    required this.houseLocation,
    required this.houseAddress,
    required this.ratingScore,
    required this.totalReview,
    required this.houseImages,
    required this.houseFacility,
    required this.userReview,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    String apiEndpoint =
        ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.houseImages;
    return HotelModel(
      id: json['id'],
      houseName: json['houseName'],
      houseCategory: json['houseCategory'],
      houseDescription: json['houseDescription'],
      houseThumbnail: apiEndpoint + json['houseThumbnail'],
      houseBed: json['houseBed'],
      housePeople: json['housePeople'],
      housePrice: double.parse(json['housePrice']),
      houseStatus: json['houseStatus'],
      houseAvailability: json['houseAvailability'],
      houseLocation: json['houseLocation'],
      houseAddress: json['houseAddress'],
      ratingScore: json['ratingScore'] != null
          ? double.parse(json['ratingScore'])
          : null,
      totalReview: int.parse(json['totalReview']),
      houseImages: List<String>.from(json['houseImages'])
          .map((image) => apiEndpoint + image)
          .toList(),
      houseFacility: List<String>.from(json['houseFacility']),
      userReview: (json['userReview'] as List<dynamic>)
          .map((reviewJson) => UserReview.fromJson(reviewJson))
          .toList(),
    );
  }

  static Future<List<HotelModel>> fetchHotels(
      String? bookFrom, String? bookTo) async {
    print("fetchHotels");
    print("BookFrom: $bookFrom");
    print("BookTo: $bookTo");
    Map<String, dynamic> parameters = {
      'bookFrom': bookFrom,
      'bookTo': bookTo,
    };

    final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.homepage)
            .replace(queryParameters: parameters));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((hotelJson) => HotelModel.fromJson(hotelJson))
          .toList();
    } else {
      print('Failed to load hotels');
      throw Exception('Failed to load hotels');
    }
  }

  static Future<List<HotelModel>> fetchAllHotels() async {
    FlutterSecureStorage secureFileStorage = FlutterSecureStorage();
    String? accessToken = await secureFileStorage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.allHouse),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((hotelJson) => HotelModel.fromJson(hotelJson))
          .toList();
    } else {
      print('Failed to load hotels');
      throw Exception('Failed to load hotels');
    }
  }

  static Future<List<HotelModel>> fetchFavHotels() async {
    print("fetchFavHotels");
    FlutterSecureStorage secureFileStorage = FlutterSecureStorage();
    String? accessToken = await secureFileStorage.read(key: 'accessToken');
    final response = await http.get(
      Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.favouriteList),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((hotelJson) => HotelModel.fromJson(hotelJson))
          .toList();
    } else {
      print('Failed to load hotels');
      throw Exception('Failed to load hotels');
    }
  }

  static Future<List<HotelModel>> reserveHotel(String houseId) async {
    print("reserveHotel");
    FlutterSecureStorage secureFileStorage = FlutterSecureStorage();
    String? accessToken = await secureFileStorage.read(key: 'accessToken');
    final response = await http.get(
      Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.userEndpoints.selectedHouse +
          '?houseId=$houseId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((hotelJson) => HotelModel.fromJson(hotelJson))
          .toList();
    } else {
      print('Failed to load hotels');
      throw Exception('Failed to load hotels');
    }
  }
}

class UserReview {
  final String profileImage;
  final double rate;
  final String reviewNote;
  final String userName;

  UserReview({
    required this.profileImage,
    required this.rate,
    required this.reviewNote,
    required this.userName,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      profileImage: json['profileImage'],
      rate: double.parse(json['rate'].toString()),
      reviewNote: json['reviewNote'],
      userName: json['userName'],
    );
  }
}
