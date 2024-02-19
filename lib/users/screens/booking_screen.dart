import 'package:flutter/material.dart';
import 'package:flutter_hotel_app_ui/users/screens/header_section.dart';
import '../../widgets/custom_nav_bar.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex =
      1; // State variable to keep track of the selected tab index

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: CustomNavBar(
        index: _selectedIndex, // Pass the selected index to CustomNavBar
        onTabChanged: (int newIndex) {
          setState(() {
            _selectedIndex = newIndex; // Update the selected index
          });
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              margin: EdgeInsets.only(top: size.height * 0.15),
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  HeaderSection(),
                  SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BookingPage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                child: TextFormField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  // onChanged: _searchDentalBooks,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Search for booking...',
                    labelStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Color(0xFF57636C),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4B39EF),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Color(0xFF57636C),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF14181B),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: null,
                ),
              ),
              SizedBox(height: 10),
              BookingItem(
                  orderNumber: "22224345",
                  from: '22 Jan 2022',
                  to: '24 Jan 2022',
                  totalAmount: 100.00,
                  houseName: 'Tulip House',
                  status: 'Approved'),
              BookingItem(
                  orderNumber: "22224345",
                  from: '22 Jan 2022',
                  to: '24 Jan 2022',
                  totalAmount: 100.00,
                  houseName: 'Tulip House',
                  status: 'Pending'),
              BookingItem(
                  orderNumber: "22224345",
                  from: '22 Jan 2022',
                  to: '24 Jan 2022',
                  totalAmount: 100.00,
                  houseName: 'Tulip House',
                  status: 'Approved'),
              BookingItem(
                  orderNumber: "22224345",
                  from: '22 Jan 2022',
                  to: '24 Jan 2022',
                  totalAmount: 100.00,
                  houseName: 'Tulip House',
                  status: 'Pending'),
              BookingItem(
                  orderNumber: "22224345",
                  from: '22 Jan 2022',
                  to: '24 Jan 2022',
                  totalAmount: 100.00,
                  houseName: 'Tulip House',
                  status: 'Pending'),
              BookingItem(
                  orderNumber: "22224345",
                  from: '22 Jan 2022',
                  to: '24 Jan 2022',
                  totalAmount: 100.00,
                  houseName: 'Tulip House',
                  status: 'Pending'),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingItem extends StatelessWidget {
  final String orderNumber;
  final String from;
  final String to;
  final double totalAmount;
  final String houseName;
  final String status;

  const BookingItem({
    required this.orderNumber,
    required this.from,
    required this.to,
    required this.totalAmount,
    required this.houseName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                              text: orderNumber,
                              style: TextStyle(
                                color: Color(0xFF6F61EF),
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
                        ), textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          houseName,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          "From: $from",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFF606A85),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          "To: $to",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFF606A85),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
                        "RM $totalAmount",
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
                          color: Colors.green[200],
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
                              status,
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
