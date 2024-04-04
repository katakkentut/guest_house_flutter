import 'package:flutter/material.dart';
import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/users/screens/booking_screen.dart';
import 'package:guest_house_app/users/services/check_user_service.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({Key? key, required this.booking}) : super(key: key);
  final BookingModel booking;

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  @override
  initState() {
    super.initState();
    checkIn();
  }

  Future checkIn() async {
    String checkStatus = 'Check-In';
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
          'Check In',
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
                      padding: EdgeInsets.only(top: 80.0),
                      child: AppText.large(
                        'Welcome !',
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
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width:
                            100.0, // Adjust these values to change the size of the image
                        height: 100.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/icon/check.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      AppText.medium('Successfully Check in',
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                      AppText.small(
                          'Check in at ${DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now())}',
                          color: Color.fromARGB(183, 92, 99, 120),
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
