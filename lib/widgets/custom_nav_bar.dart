import 'package:flutter/material.dart';
import 'package:guest_house_app/users/screens/booking_screen.dart';
import 'package:guest_house_app/users/screens/home_screen.dart';
import 'package:guest_house_app/users/screens/setting_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
    required this.index,
    required this.onTabChanged,
  }) : super(key: key);

  final int index;
  final Function(int) onTabChanged;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.house),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_added_sharp),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
        ),
      ],
      currentIndex: index,
      selectedItemColor: Colors.blue,
      onTap: (int newIndex) {
        onTabChanged(newIndex); // Notify the parent about tab changes
        _navigateToPage(context, newIndex); // Navigate to the selected page
      },
    );
  }

  Future<bool> checkLogin() async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    bool isLoggedIn = accessToken != null;
    return isLoggedIn;
  }

  Future<void> _navigateToPage(BuildContext context, int newIndex) async {
    switch (newIndex) {
      case 0:
        Get.offAll(() => HomeScreen(), transition: Transition.fadeIn);
        break;
      case 1:
        if (await checkLogin()) {
          Get.offAll(() => BookingScreen(), transition: Transition.fadeIn);
        } else {
          Get.showSnackbar(
            const GetSnackBar(
              title: 'Login Required',
              message: 'Booking pages only available for authenticated users',
              duration: Duration(seconds: 3),
              backgroundColor: Colors.orange,
            ),
          );
        }
        break;
      case 2:
        Get.offAll(() => SettingScreen(), transition: Transition.fadeIn);
        break;
    }
  }
}
