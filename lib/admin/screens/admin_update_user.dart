import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/widgets/update_user_card.dart';
import 'package:guest_house_app/models/user_detail_model.dart';
import 'package:guest_house_app/providers/user_provider.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminUpdateUserScreen extends StatefulWidget {
  @override
  _AdminUpdateUserScreenState createState() => _AdminUpdateUserScreenState();
}

class _AdminUpdateUserScreenState extends State<AdminUpdateUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.large(
          'Update User',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: _AllUsers())
          ],
        ),
      ),
    );
  }
}

class _AllUsers extends ConsumerWidget {
  const _AllUsers({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(allUsersProvider);
    return Consumer(
      builder: (context, ref, child) {
        return Column(children: [
          const SizedBox(height: 4),
          user.when(
            loading: () => const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 5.0,
              backgroundColor: Colors.white,
            )),
            error: (err, stack) => Text('Error: $err'),
            data: (users) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  UserDetailModel hotel = users[index];
                  return UpdateUserCard(user: hotel);
                },
              );
            },
          ),
        ]);
      },
    );
  }
}
