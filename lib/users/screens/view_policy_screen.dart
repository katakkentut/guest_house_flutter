// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PolicyScreenState extends StatefulWidget {
  const PolicyScreenState({super.key});

  @override
  State<PolicyScreenState> createState() => _PolicyScreenStateState();
}

class _PolicyScreenStateState extends State<PolicyScreenState> {
  List<dynamic> policies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPolicy();
    });
  }

  void fetchPolicy() async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.housePolicy),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          policies = jsonDecode(response.body);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText.large(
          'Policy',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: policies.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                title: AppText.large(
                  'Terms and Condition:',
                  fontSize: 17,
                  textAlign: TextAlign.left,
                  maxLine: 3,
                  textOverflow: TextOverflow.ellipsis,
                  color: Colors.black,
                ),
              );
            } else if (index == policies.length + 1) {
              return ListTile(
                title: AppText.large(
                  'Please adhere to these policies during your stay. Thank You for your cooperation',
                  fontSize: 16,
                  textAlign: TextAlign.left,
                  maxLine: 3,
                  textOverflow: TextOverflow.ellipsis,
                  color: Colors.black,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index}.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 16),
                    ),
                    SizedBox(
                        width:
                            8), 
                    Expanded(
                      child: Text(
                        '${policies[index - 1]['policyNote']}', 
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
