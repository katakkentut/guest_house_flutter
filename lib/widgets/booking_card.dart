// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/screens/admin_booking_detail_screen.dart';
import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/users/screens/booking_detail_screen.dart';
import 'package:guest_house_app/widgets/custom_stepper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingItemCard extends StatelessWidget {
  const BookingItemCard({
    Key? key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        FlutterSecureStorage storage = FlutterSecureStorage();
        String? userType = await storage.read(key: 'userType');

        if (userType == 'admin') {
          Get.to(AdminBookingDetail(booking: booking));
        } else {
          Get.to(BookingDetailScreen(booking: booking));
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 570,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Book Id #: ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: booking.bookingId,
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Color(0xFF15161E),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        textScaler: TextScaler.linear(
                            MediaQuery.of(context).textScaleFactor),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          booking.houseName,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 178,
                        child: MyStepper(
                          connectorColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue),
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
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "View More  ",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color.fromARGB(232, 72, 76, 90),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.remove_red_eye, color: Colors.blue[800]),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: Text(
                        '  RM ${(booking.housePrice == booking.housePrice.toInt()) ? booking.housePrice.toInt() * booking.dateTo.difference(booking.dateFrom).inDays : booking.housePrice * booking.dateTo.difference(booking.dateFrom).inDays}',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF15161E),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: booking.status == 'Approved' ||
                                  booking.status == 'Today\'s Book'
                              ? Colors.green[200]
                              : Colors.yellow[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color.fromARGB(255, 36, 28, 105),
                            width: 2,
                          ),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                            child: Text(
                              booking.status,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
