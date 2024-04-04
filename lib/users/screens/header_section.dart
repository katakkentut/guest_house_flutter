import 'package:flutter/material.dart';
import 'package:guest_house_app/auth/screens/auth_notifier.dart';
import 'package:guest_house_app/users/services/update_profile_sevice.dart';
import 'package:guest_house_app/utils/api-endpoint.dart';
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
      profileImage = ApiEndPoints.baseUrl +
          ApiEndPoints.userEndpoints.userProfile +
          result['message']['userImage'];
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
                  Stack(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                      ),
                      if (!isLoading && profileImage.isNotEmpty)
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(profileImage),
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
