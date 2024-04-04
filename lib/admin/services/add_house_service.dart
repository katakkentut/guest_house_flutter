import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddHouseServices {
  Future<Map<String, dynamic>> addHouse(Map<String, dynamic> formValues,
      File? houseThumbnails, List<File> images) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.addHouse),
        body: jsonEncode({
          'houseName': formValues['houseName'],
          'houseDescription': formValues['houseDescription'],
          'housePrice': formValues['housePrice'],
          'houseLocation': formValues['houseLocation'],
          'houseAddress': formValues['houseAddress'],
          'houseFacilities': formValues['houseFacility'],
          'houseBed': formValues['houseBed'],
          'housePeople': formValues['housePeople'],
          'houseCategory': formValues['houseCategory'],
          'houseThumbnail': base64Encode(houseThumbnails!.readAsBytesSync()),
          'houseImages': images
              .map((image) => base64Encode(image.readAsBytesSync()))
              .toList(),
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
}
