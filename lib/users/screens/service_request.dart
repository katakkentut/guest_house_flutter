// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/users/screens/booking_screen.dart';
import 'package:guest_house_app/users/services/booking_detail_services.dart';
import 'package:guest_house_app/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../widgets/hotel_card.dart';
import '../../models/hotel_model.dart';

int _index = 0;

class ServiceRequestScreen extends StatelessWidget {
  const ServiceRequestScreen({super.key, required this.booking});
  final BookingModel booking;
  @override
  Widget build(BuildContext context) {
    TextEditingController serviceNote = TextEditingController();
    final loadingNotifier = ValueNotifier<bool>(false);
    return ValueListenableBuilder<bool>(
      valueListenable: loadingNotifier,
      builder: (context, isLoading, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  booking.status,
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
                            'Booking ID',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color.fromARGB(183, 92, 99, 120),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '#${booking.bookingId}',
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
                      child: _NearbyHotelSection(houseId: booking.houseId),
                    ),
                    Divider(color: Colors.grey[300]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 15, bottom: 10),
                          child: Text(
                            'Service Request',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Container(
                              child: TextFormField(
                                controller: serviceNote,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: 'Enter your service here',
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                maxLines: 5,
                                maxLength: 500,
                                textInputAction: TextInputAction.done,
                                validator: (String? text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Center(
                          child: SubmitFeedbackButton(
                            buttonText: 'Submit Request',
                            onPressed: () async {
                              loadingNotifier.value = true;
                              var result = await BookingDetailService()
                                  .userServiceRequest(
                                      booking.bookingId, serviceNote.text);
                              await Future.delayed(Duration(seconds: 1));
                              loadingNotifier.value = false;
                              if (result['status']) {
                                Get.offAll(BookingScreen());

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result['message'],
                                        style: TextStyle(fontSize: 16)),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result['message']),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 5.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
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
        return Column(
          children: [
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
              loading: () => const Center(child: CircularProgressIndicator()),
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
          ],
        );
      },
    );
  }
}
