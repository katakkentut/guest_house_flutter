// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/models/hotel_model.dart';
import 'package:guest_house_app/models/service_model.dart';
import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:guest_house_app/providers/service_provider.dart';
import 'package:guest_house_app/users/screens/booking_screen.dart';
import 'package:guest_house_app/users/services/booking_detail_services.dart';
import 'package:guest_house_app/widgets/custom_button.dart';
import 'package:guest_house_app/widgets/hotel_card.dart';
import 'package:guest_house_app/widgets/service_card.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServiceRequestScreen2 extends StatefulWidget {
  final BookingModel booking;
  const ServiceRequestScreen2({Key? key, required this.booking})
      : super(key: key);

  @override
  _ServiceRequestScreen2State createState() => _ServiceRequestScreen2State();
}

class _ServiceRequestScreen2State extends State<ServiceRequestScreen2>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final loadingNotifier = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loadingNotifier,
      builder: (context, isLoading, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Service Request',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            TabBar.secondary(
                              controller: _tabController,
                              tabs: const <Widget>[
                                Tab(text: "Request Service"),
                                Tab(text: 'Request History'),
                              ],
                              indicatorColor: Colors.blueAccent,
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(2.0),
                                      child: SingleChildScrollView(
                                          child: _ServiceRequestScreen(
                                        booking: widget.booking,
                                        loadingNotifier: loadingNotifier,
                                      )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(5.0),
                                      child: SingleChildScrollView(
                                          child: _ServiceHistoryScreen(
                                        booking: widget.booking,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 5.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServiceRequestScreen extends StatelessWidget {
  const _ServiceRequestScreen(
      {super.key, required this.booking, required this.loadingNotifier});
  final BookingModel booking;
  final ValueNotifier<bool> loadingNotifier;
  @override
  Widget build(BuildContext context) {
    TextEditingController serviceNote = TextEditingController();
    return Stack(
      children: [
        SingleChildScrollView(
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
              Divider(color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected House',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    _NearbyHotelSection(houseId: booking.houseId),
                  ],
                ),
              ),
              Divider(color: Colors.grey[300]),
              Column(children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                        if (serviceNote.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a service note'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
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
      ],
    );
  }
}

class _ServiceHistoryScreen extends StatelessWidget {
  const _ServiceHistoryScreen({super.key, required this.booking});
  final BookingModel booking;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
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
              Divider(color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected House',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    _NearbyHotelSection(houseId: booking.houseId),
                  ],
                ),
              ),
              Divider(color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'All Service History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    _AllUserService(
                      reservationId: booking.bookingId,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
        return hotels.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error: $err'),
          data: (hotels) {
            return Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: hotels.length,
                itemBuilder: (BuildContext context, int index) {
                  HotelModel hotel = hotels[index];
                  return HotelCard(hotel: hotel);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _AllUserService extends ConsumerWidget {
  const _AllUserService({Key? key, required this.reservationId})
      : super(key: key);

  final String reservationId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(allServiceProvider(reservationId));
    return Consumer(
      builder: (context, ref, child) {
        return services.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error: $err'),
          data: (services) {
            if (services.isEmpty) {
              return Center(child: Text('No service available'));
            }
            return Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  ServiceModel service = services[index];
                  return ServiceCard(service: service);
                },
              ),
            );
          },
        );
      },
    );
  }
}
