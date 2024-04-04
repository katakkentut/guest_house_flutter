// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/models/hotel_model.dart';
import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:guest_house_app/users/screens/booking_screen.dart';
import 'package:guest_house_app/users/services/check_user_service.dart';
import 'package:guest_house_app/users/services/house_feedback_servuce.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:guest_house_app/widgets/custom_button.dart';
import 'package:guest_house_app/widgets/hotel_card.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key, required this.booking}) : super(key: key);
  final BookingModel booking;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  double userRating = 0.0;
  TextEditingController userFeedback = TextEditingController();
  @override
  initState() {
    super.initState();
    checkIn();
  }

  Future checkIn() async {
    String checkStatus = 'Check-Out';
    var result = await CheckUserService()
        .checkUser(widget.booking.bookingId, checkStatus);
    if (result['status']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'], style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Out',
          style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[400],
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(BookingScreen());
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.blue[400],
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: AppText.large(
                        'Thank You !',
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            height: 100.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                'assets/icon/export.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          AppText.medium('Successfully Check Out',
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                          AppText.small(
                              'Check out at ${DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now())}',
                              color: Color.fromARGB(183, 92, 99, 120),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: _NearbyHotelSection(
                                houseId: widget.booking.houseId),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'House Rating (Optional)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    userRating = rating;
                                  },
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: TextFormField(
                                    controller: userFeedback,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your feedback here',
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                    maxLines: 5,
                                    maxLength: 500,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SubmitFeedbackButton(
                                    buttonText: 'Submit Feedback',
                                    onPressed: () async {
                                      if (userRating != 0.0 &&
                                          userFeedback.text.isNotEmpty) {
                                        var result =
                                            await HouseFeedbackService()
                                                .submitService(
                                                    userRating,
                                                    userFeedback.text,
                                                    widget.booking.houseId);
                                        if (result['status']) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(result['message']),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(result['message']),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Please rate the house to submit feedback'),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ],
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

class _RatingSection extends StatelessWidget {
  const _RatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
