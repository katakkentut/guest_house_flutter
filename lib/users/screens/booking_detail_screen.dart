import 'package:flutter/material.dart';
import 'package:guest_house_app/gen/colors.gen.dart';
import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/users/screens/booking_screen.dart';
import 'package:guest_house_app/users/screens/check-in.dart';
import 'package:guest_house_app/users/screens/check-out.dart';
import 'package:guest_house_app/users/screens/service_request_screen.dart';
import 'package:guest_house_app/users/services/booking_detail_services.dart';
import 'package:guest_house_app/widgets/custom_button.dart';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:guest_house_app/widgets/custom_stepper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../../widgets/hotel_card.dart';
import '../../models/hotel_model.dart';
import 'package:material_dialogs/material_dialogs.dart';

int _index = 0;

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.booking});
  final BookingModel booking;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              booking.houseName,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color.fromARGB(184, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Transform.translate(
                              offset: Offset(-15, 0),
                              child: MyStepper(
                                connectorColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.blue),
                                margin: EdgeInsets.fromLTRB(33, 22, 22, 11),
                                controlsBuilder: (context, controller) {
                                  return const SizedBox.shrink();
                                },
                                steps: <customStep>[
                                  customStep(
                                    state: StepIcon.complete,
                                    title: Text(
                                      "From:\n ${DateFormat('dd MMM yyyy').format(booking.dateFrom)}",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        color: Color.fromARGB(183, 92, 99, 120),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    content: Container(),
                                  ),
                                  customStep(
                                    state: StepIcon.complete,
                                    title: Text(
                                      "To:\n ${DateFormat('dd MMM yyyy').format(booking.dateTo)}",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        color: Color.fromARGB(183, 92, 99, 120),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    content: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "${booking.dateTo.difference(booking.dateFrom).inDays} Days",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color.fromARGB(183, 92, 99, 120),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Container(
                          width: 170.0,
                          height: 170.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              ApiEndPoints.baseUrl +
                                  ApiEndPoints.userEndpoints.houseImages +
                                  booking.houseThumbnail,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            if (booking.status == "Today's Book")
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (booking.bookHouseStatus == "Check-In")
                      DetailScreenButton(
                        onPressed: () {
                          Get.offAll(
                              () => CheckOutPage(
                                    booking: booking,
                                  ),
                              transition: Transition.fade);
                        },
                        buttonText: 'Check Out',
                      ),
                    if (booking.bookHouseStatus == "Pending")
                      DetailScreenButton(
                        onPressed: () {
                          Get.offAll(
                              CheckInPage(
                                booking: booking,
                              ),
                              transition: Transition.fade);
                        },
                        buttonText: 'Check In',
                      ),
                    DetailScreenButton(
                      onPressed: () {
                        if (booking.bookHouseStatus == "Pending") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('You have to check in first'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          Get.to(
                              () => ServiceRequestScreen2(
                                    booking: booking,
                                  ),
                              transition: Transition.fade);
                        }
                      },
                      buttonText: 'Service Request',
                    ),
                  ],
                ),
              ),
            if (booking.status == "Pending")
              Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: DetailScreenButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    //   Get.offAll(
                    //       CheckInPage(
                    //         booking: booking,
                    //       ),
                    //       transition: Transition.fade);

                    Dialogs.bottomMaterialDialog(
                        msg: 'Are you sure? you can\'t undo this action',
                        msgStyle: TextStyle(fontFamily: 'Outfit'),
                        title: 'Delete',
                        context: context,
                        actions: [
                          IconsButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            text: 'Cancel',
                            iconData: Icons.cancel_outlined,
                            textStyle: TextStyle(color: Colors.grey),
                            iconColor: Colors.grey,
                          ),
                          IconsButton(
                            onPressed: () async {
                              var result = await BookingDetailService()
                                  .deleteReservation(booking.bookingId);

                              if (result['status']) {
                                Get.offAll(BookingScreen());

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
                            },
                            text: 'Delete',
                            iconData: Icons.delete,
                            color: Colors.red,
                            textStyle: TextStyle(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ]);
                  },
                  buttonText: 'Cancel',
                ),
              ),
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
                  padding: EdgeInsets.only(top: 10, left: 15, bottom: 10),
                  child: Text(
                    'Price Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorName.lightGrey.withAlpha(50),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Price One Night',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color.fromARGB(223, 54, 58, 68),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Rm ${(booking.housePrice == booking.housePrice.toInt()) ? booking.housePrice.toInt().toString() : booking.housePrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total Days',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color.fromARGB(223, 54, 58, 68),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${booking.dateTo.difference(booking.dateFrom).inDays}',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sub Total',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color.fromARGB(223, 54, 58, 68),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'RM ${(booking.housePrice == booking.housePrice.toInt()) ? booking.housePrice.toInt().toString() : booking.housePrice.toStringAsFixed(2)} * ${booking.dateTo.difference(booking.dateFrom).inDays}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors
                                          .grey, // Change this to the color you want
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '  RM ${(booking.housePrice == booking.housePrice.toInt()) ? booking.housePrice.toInt() * booking.dateTo.difference(booking.dateFrom).inDays : booking.housePrice * booking.dateTo.difference(booking.dateFrom).inDays}',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
