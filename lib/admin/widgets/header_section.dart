// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:guest_house_app/auth/screens/auth_notifier.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:provider/provider.dart' as prov;

class AdminHeaderSection extends StatefulWidget {
  const AdminHeaderSection({Key? key}) : super(key: key);

  @override
  State<AdminHeaderSection> createState() => _AdminHeaderSectionState();
}

class _AdminHeaderSectionState extends State<AdminHeaderSection> {
  String nameController = "";
  String profileImage = "";
  bool isLoading = true;


  @override
  Widget build(BuildContext context) {
    final authNotifier = prov.Provider.of<AuthNotifier>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        authNotifier.isLoggedIn
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: AppText.large(
                            'Admin',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Placeholder(
                fallbackHeight: 50,
                color:
                    Colors.transparent), // Adjust the fallbackHeight as needed
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Kapal Terbang Guest House',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
