import 'dart:convert';

import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceRequestApproval {
  Future<Map<String, dynamic>> serviceDone(String serviceId, String serviceDoneNote) async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.adminEndpoints.adminServiceRequest),
        body: jsonEncode({
          'serviceId': serviceId,
          'serviceNote': serviceDoneNote,
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
