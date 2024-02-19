import 'package:flutter/material.dart';
import 'package:flutter_hotel_app_ui/users/screens/booking_screen.dart';
import 'package:flutter_hotel_app_ui/users/screens/home_screen.dart';
import 'package:flutter_hotel_app_ui/users/screens/setting_screen.dart';
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

  void _navigateToPage(BuildContext context, int newIndex) {
    switch (newIndex) {
      case 0:
        Get.offAll(() => HomeScreen(), transition: Transition.fadeIn);
        break;
      case 1:
        Get.offAll(() => BookingScreen(), transition: Transition.fadeIn);
        break;
      case 2:
        Get.offAll(() => SettingScreen(), transition: Transition.fadeIn);
        break;
    }
  }
}
