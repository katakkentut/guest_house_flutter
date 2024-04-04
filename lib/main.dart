// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:guest_house_app/admin/screens/admin_home_screen.dart';
import 'package:guest_house_app/users/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as prov;
import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';
import 'package:guest_house_app/auth/screens/auth_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  final storage = FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'accessToken');
  String? userType = await storage.read(key: 'userType');
  bool isLoggedIn = accessToken != null;
  bool isAdmin = userType == 'admin';

  runApp(
    prov.ChangeNotifierProvider(
      create: (context) => AuthNotifier(isLoggedIn, userType ?? ''),
      child: ProviderScope(child: HotelApp(isAdmin: isAdmin)),
    ),
  );
}

class HotelApp extends StatelessWidget {
  final bool isAdmin;

  const HotelApp({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hotel App UI',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: FontFamily.workSans,
        primarySwatch: ColorName.primarySwatch,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 16.0),
          bodySmall: TextStyle(fontSize: 14.0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 18.0),
          hintStyle: TextStyle(fontSize: 16.0),
        ),
      ),
      home: isAdmin ? const AdminHomeScreen() : const HomeScreen(),
    );
  }
}
