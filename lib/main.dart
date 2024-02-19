import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_hotel_app_ui/auth/screens/auth_notifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as prov;
import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';
import 'users/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  // Check if the user is logged in
  final storage = FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'accessToken');
  bool isLoggedIn = accessToken != null;

  runApp(
    prov.ChangeNotifierProvider(
      create: (context) =>
          AuthNotifier(isLoggedIn), // Provide AuthNotifier with isLoggedIn
      child: ProviderScope(child: HotelApp()),
    ),
  );
}

class HotelApp extends StatelessWidget {
  const HotelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hotel App UI',
      theme: ThemeData(
        fontFamily: FontFamily.workSans,
        primarySwatch: ColorName.primarySwatch,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 16.0),
          bodySmall: TextStyle(fontSize: 14.0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 18.0), // Set the font size to 20
          hintStyle: TextStyle(fontSize: 16.0), // Set the font size to 20
          
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FutureBuilder<bool>(
//         future: checkLoginStatus(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return snapshot.data ?? false ? HomeScreen() : SignInWidget();
//           } else {
//             return CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }


// Future<bool> checkLoginStatus() async {
//   const storage = FlutterSecureStorage();
//   final accessToken = await storage.read(key: 'accessToken');
//   return accessToken != null;
// }