import 'package:flutter/material.dart';
import 'package:guest_house_app/models/user_detail_model.dart';
import 'package:guest_house_app/widgets/app_text.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDetailModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
              child: Image.network(
                user.userImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.large(
                    user.fullname,
                    fontSize: 16,
                    textAlign: TextAlign.left,
                    maxLine: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text('Email:  ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(user.email),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Phone: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(user.phone),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('User ID: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(user.userId),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Country: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(user.userCountry),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
