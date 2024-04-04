import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/screens/admin_booking_screen.dart';
import 'package:guest_house_app/admin/screens/admin_home_screen.dart';
import 'package:guest_house_app/admin/screens/admin_setting_screen.dart';
import 'package:get/get.dart';

class AdminCustomNavBar extends StatelessWidget {
  const AdminCustomNavBar({
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
        onTabChanged(newIndex);
        _navigateToPage(context, newIndex);
      },
    );
  }

  void _navigateToPage(BuildContext context, int newIndex) {
    switch (newIndex) {
      case 0:
        Get.offAll(() => const AdminHomeScreen(),
            transition: Transition.fadeIn);
        break;
      case 1:
        Get.offAll(() => AdminBookingScreen(), transition: Transition.fadeIn);
        break;
      case 2:
        Get.offAll(() => AdminSettingScreen(), transition: Transition.fadeIn);

        break;
    }
  }
}
