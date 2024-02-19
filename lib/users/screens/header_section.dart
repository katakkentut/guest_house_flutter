import 'package:flutter/material.dart';
import 'package:flutter_hotel_app_ui/auth/screens/auth_notifier.dart';
import 'package:flutter_hotel_app_ui/gen/assets.gen.dart';
import 'package:flutter_hotel_app_ui/users/services/update_profile_sevice.dart';
import 'package:flutter_hotel_app_ui/users/widgets1/custom_icon_container.dart';
import 'package:flutter_hotel_app_ui/utils/api-endpoint.dart';
import 'package:provider/provider.dart' as prov;

class HeaderSection extends StatefulWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String nameController = "";
  String profileImage = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authNotifier =
          prov.Provider.of<AuthNotifier>(context, listen: false);
      if (authNotifier.isLoggedIn) {
        getProfile();
      }
    });
  }

  void getProfile() async {
    var result = await UpdateProfileService().fetchUser();
    setState(() {
      isLoading = false;
      if (result['status']) {
        profileImage = ApiEndPoints.baseUrl +
            ApiEndPoints.authEndpoints.userProfile +
            result['message']['userImage'];
      }
    });
  }

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
                  if (!isLoading && profileImage.isNotEmpty)
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                  CustomIconButton(
                    icon: Assets.icon.notification.svg(height: 25),
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
