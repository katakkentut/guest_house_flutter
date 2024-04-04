// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:guest_house_app/admin/screens/admin_setting_screen.dart';
import 'package:guest_house_app/admin/services/service_request_service.dart';
import 'package:guest_house_app/admin/widgets/user_card.dart';
import 'package:guest_house_app/models/service_model.dart';
import 'package:guest_house_app/models/user_detail_model.dart';
import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:guest_house_app/providers/user_provider.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:guest_house_app/widgets/custom_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/hotel_model.dart';
import '../../widgets/hotel_card.dart';

int _index = 0;

class AdminServiceDetail extends StatelessWidget {
  const AdminServiceDetail({super.key, required this.service});
  final ServiceModel service;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Service Detail',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Service ID',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Color.fromARGB(183, 92, 99, 120),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '#${service.serviceId}',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color: Colors.grey[300]),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: _ServiceDetailCard(
                service: service,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color: Colors.grey[300]),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: _NearbyHotelSection(houseId: service.houseId),
            ),
            Divider(color: Colors.grey[300]),
            Container(
              padding: EdgeInsets.all(10.0),
              child: _UserDetail(userId: service.userId),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceDetailCard extends StatelessWidget {
  const _ServiceDetailCard({super.key, required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Card(
      elevation: 5,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    'Service Requested by User',
                    fontSize: 15,
                    textAlign: TextAlign.left,
                    maxLine: 2,
                    textOverflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 7),
                  AppText.medium(
                    service.userServiceNotes,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                    maxLine: 10,
                    textOverflow: TextOverflow.ellipsis,
                    color: Colors.black54,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Divider(color: Colors.grey[300]),
                  ),
                  SizedBox(height: 7),
                  if (service.serviceStatus == 'Pending')
                    FormBuilder(
                      key: _formKey,
                      child: FormBuilderTextField(
                        name: 'serviceDoneNote',
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Service Note',
                          labelStyle: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (service.serviceStatus == 'Completed')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium(
                          'Service Done Note',
                          fontSize: 15,
                          textAlign: TextAlign.left,
                          maxLine: 2,
                          textOverflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 7),
                        AppText.medium(
                          service.adminServiceNotes,
                          fontSize: 14,
                          textAlign: TextAlign.left,
                          maxLine: 10,
                          textOverflow: TextOverflow.ellipsis,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  SizedBox(height: 7),
                  if (service.serviceStatus == 'Pending')
                    DetailScreenButton(
                      buttonText: 'Submit Service',
                      onPressed: () async {
                        if (_formKey.currentState!.saveAndValidate()) {
                          var serviceDoneNote =
                              _formKey.currentState!.value['serviceDoneNote'];

                          var result = await ServiceRequestApproval()
                              .serviceDone(service.serviceId, serviceDoneNote);

                          if (result['status']) {
                            Get.offAll(AdminSettingScreen());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result['message'],
                                    style: TextStyle(fontSize: 16)),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result['message']),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NearbyHotelSection extends ConsumerWidget {
  const _NearbyHotelSection({Key? key, required this.houseId})
      : super(key: key);
  final String houseId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotels = ref.watch(selectedHotelProvider(houseId));
    return Consumer(
      builder: (context, ref, child) {
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Selected House',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          hotels.when(
            loading: () => const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 5.0,
              backgroundColor: Colors.white,
            )),
            error: (err, stack) => Text('Error: $err'),
            data: (hotels) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hotels.length,
                itemBuilder: (BuildContext context, int index) {
                  HotelModel hotel = hotels[index];
                  return HotelCard(hotel: hotel);
                },
              );
            },
          ),
        ]);
      },
    );
  }
}

class _UserDetail extends ConsumerWidget {
  const _UserDetail({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userByIdProvider(userId));
    return Consumer(
      builder: (context, ref, child) {
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'User Detail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
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
                  return UserCard(user: hotel);
                },
              );
            },
          ),
        ]);
      },
    );
  }
}
