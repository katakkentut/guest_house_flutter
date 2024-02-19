import 'package:flutter/material.dart';
import 'package:flutter_hotel_app_ui/auth/screens/auth_notifier.dart';
import 'package:flutter_hotel_app_ui/auth/screens/signin.dart';
import 'package:flutter_hotel_app_ui/users/screens/favourite_house.dart';
import 'package:flutter_hotel_app_ui/users/screens/header_section.dart';
import 'package:flutter_hotel_app_ui/users/screens/reset_password.dart';
import 'package:flutter_hotel_app_ui/users/screens/update-profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../widgets/custom_nav_bar.dart';
import 'package:provider/provider.dart' as prov;
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex =
      2; // State variable to keep track of the selected tab index

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: CustomNavBar(
        index: _selectedIndex, // Pass the selected index to CustomNavBar
        onTabChanged: (int newIndex) {
          setState(() {
            _selectedIndex = newIndex; // Update the selected index
          });
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              margin: EdgeInsets.only(top: size.height * 0.15),
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderSection(),
                    SizedBox(height: 40),
                    SettingItem(),
                    // Your other widgets
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatefulWidget {
  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    final authNotifier = prov.Provider.of<AuthNotifier>(context);

    return Material(
        child: Container(
      height: MediaQuery.of(context).size.height, // or any specific height
      child: ListView(children: [
        if (authNotifier.isLoggedIn) ...[
          _SingleSection(
            title: "General",
            children: [
              _CustomListTile(
                title: "Favourites",
                icon: CupertinoIcons.heart,
                onTap: () {
                  Get.to(() => FavouriteHouseScreen(),
                      transition: Transition.rightToLeftWithFade);
                },
              ),
              _CustomListTile(
                  title: "View Policy",
                  icon: CupertinoIcons.doc_text,
                  onTap: () {
                    print("View Policy");
                  }),
            ],
          ),
          _SingleSection(
            title: "Privacy and Security",
            children: [
              _CustomListTile(
                  title: "Update Profile",
                  icon: CupertinoIcons.profile_circled,
                  onTap: () {
                    Get.to(() => UpdateProfileScreen(),
                        transition: Transition.rightToLeftWithFade);
                  }),
              _CustomListTile(
                  title: "Change Password",
                  icon: CupertinoIcons.lock,
                  onTap: () {
                    Get.to(() => ResetPasswordScreen(),
                        transition: Transition.rightToLeftWithFade);
                  }),
            ],
          ),
          const Divider(),
        ],
        _SingleSection1(
          children: [
            _CustomListTile1(
                title: "About",
                icon: Icons.info_outline_rounded,
                onTap: () {
                  print("About");
                }),
            _CustomListTile1(
              title: authNotifier.isLoggedIn ? "Sign out" : "Sign in",
              icon: Icons.exit_to_app_rounded,
              onTap: () async {
                if (authNotifier.isLoggedIn) {
                  ProgressDialog progressDialog =
                      ProgressDialog(context, isDismissible: false);
                  progressDialog.style(
                    message: 'Logging out...',
                  );
                  await progressDialog.show();

                  await Future.delayed(Duration(seconds: 1));

                  final storage = FlutterSecureStorage();
                  await storage.deleteAll();

                  authNotifier.setLoggedIn(false);
                  await progressDialog.hide();
                } else {
                  // Navigate to the sign in screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInWidget()),
                  );
                }
              },
            ),
          ],
        ),
        const Divider(),
      ]),
    ));
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function onTap;
  const _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 18),
      onTap: () {
        onTap();
      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style:
                Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _CustomListTile1 extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function onTap;
  const _CustomListTile1(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        onTap();
      },
    );
  }
}

class _SingleSection1 extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection1({
    Key? key,
    required this.children, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Column(
            children: children,
          ),
        ],
      ),
    );
  }
}
