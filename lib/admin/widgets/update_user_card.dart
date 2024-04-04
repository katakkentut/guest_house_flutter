// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/screens/admin_update_user_detail.dart';
import 'package:guest_house_app/gen/fonts.gen.dart';
import 'package:guest_house_app/models/user_detail_model.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:get/get.dart';

class UpdateUserCard extends StatelessWidget {
  const UpdateUserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDetailModel user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AdminUpdateProfileScreen(user: user),
            transition: Transition.rightToLeftWithFade);
      },
      child: Card(
        elevation: 5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.userImage),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium(
                      user.fullname,
                      fontSize: 15,
                      textAlign: TextAlign.left,
                      maxLine: 2,
                      textOverflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Email: ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.workSans),
                          ),
                          TextSpan(
                            text: user.email,
                            style: TextStyle(
                                fontFamily: FontFamily.workSans,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Phone: ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.workSans),
                          ),
                          TextSpan(
                            text: user.phone,
                            style: TextStyle(
                                fontFamily: FontFamily.workSans,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'User Id: ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.workSans),
                          ),
                          TextSpan(
                            text: user.userId.toString(),
                            style: TextStyle(
                                fontFamily: FontFamily.workSans,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
