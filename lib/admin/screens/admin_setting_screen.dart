import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:guest_house_app/admin/screens/admin_add_house.dart';
import 'package:guest_house_app/admin/screens/admin_edit_house_price_screen.dart';
import 'package:guest_house_app/admin/screens/admin_service_screen.dart';
import 'package:guest_house_app/admin/screens/admin_update_user.dart';
import 'package:guest_house_app/admin/widgets/admin_custom_nav_bar.dart';
import 'package:guest_house_app/admin/widgets/header_section.dart';
import 'package:guest_house_app/auth/screens/auth_notifier.dart';
import 'package:guest_house_app/auth/screens/signin.dart';
import 'package:guest_house_app/users/screens/reset_password.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart' as prov;

class AdminSettingScreen extends StatefulWidget {
  @override
  _AdminSettingScreenState createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: AdminCustomNavBar(
        index: _selectedIndex,
        onTabChanged: (int newIndex) {
          setState(() {
            _selectedIndex = newIndex;
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
                    AdminHeaderSection(),
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
            title: "Admin Utility",
            children: [
              _CustomListTile(
                title: "Services",
                icon: CupertinoIcons.settings,
                onTap: () {
                  Get.to(() => AdminServicesScreen(),
                      transition: Transition.rightToLeftWithFade);
                },
              ),
              _CustomListTile(
                  title: "Users",
                  icon: CupertinoIcons.person_2_fill,
                  onTap: () {
                    Get.to(() => AdminUpdateUserScreen(),
                        transition: Transition.rightToLeftWithFade);
                  }),
              _CustomListTile(
                  title: "House",
                  icon: CupertinoIcons.house_fill,
                  onTap: () {
                    Get.to(() => AdminAddHouse(),
                        transition: Transition.rightToLeftWithFade);
                  }),
              _CustomListTile(
                  title: "Edit House Price",
                  icon: CupertinoIcons.money_dollar_circle_fill,
                  onTap: () {
                    Get.to(() => AdminEditHousePrice(),
                        transition: Transition.rightToLeftWithFade);
                  }),
            ],
          ),
          _SingleSection(
            title: "Privacy and Security",
            children: [
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
      required this.onTap,
      this.trailing})
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
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 16),
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
      required this.onTap,
      this.trailing})
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
    required this.children,
    this.title,
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
