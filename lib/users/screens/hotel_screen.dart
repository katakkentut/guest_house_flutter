// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guest_house_app/auth/screens/auth_notifier.dart';
import 'package:guest_house_app/auth/screens/signin.dart';
import 'package:guest_house_app/users/screens/reserve_screen.dart';
import 'package:guest_house_app/users/services/hotel_service.dart';
import 'package:guest_house_app/utils/api-endpoint.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../models/hotel_model.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_icon_container.dart';
import '../../widgets/custom_rating.dart';

class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();

  final HotelModel hotel;
}

Future _checkUserType() async {
  const storage = FlutterSecureStorage();
  String? userType = await storage.read(key: 'userType');
  return userType;
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  bool showAllReviews = false; // Define the showAllReviews variable

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.network(
              widget.hotel.houseThumbnail,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.4),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _HotelTitleSection(hotel: widget.hotel),
                        const SizedBox(height: 16),
                        _FacilitiesSection(widget.hotel.houseFacility),
                      ],
                    ),
                  ),
                  _GallerySection(imagePaths: widget.hotel.houseImages),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _LocationSection(
                      address: widget.hotel.houseAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _DescriptionSection(
                      description: widget.hotel.houseDescription,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium('Review', fontWeight: FontWeight.bold),
                        const SizedBox(height: 10),
                        if (widget.hotel.userReview.isEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AppText.medium('No review yet !',
                                fontWeight: FontWeight.normal),
                          )
                        else
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: widget.hotel.userReview.length,
                              itemBuilder: (context, index) {
                                final review = widget.hotel.userReview[index];
                                return _ReviewSectionState(
                                  profileImage: ApiEndPoints.baseUrl +
                                      ApiEndPoints.userEndpoints.userProfile +
                                      "/" +
                                      review.profileImage,
                                  name: review.userName,
                                  review: review.reviewNote,
                                  rate: review.rate,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 50,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      icon: Assets.icon.chevronDown.svg(height: 25),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    if (authNotifier.userType == 'user')
                      CustomIconButton(
                        icon: Assets.icon.wishlist.svg(
                          height: 25,
                        ),
                        onPressed: () async {
                          var result = await HotelPageService()
                              .addFavourite(widget.hotel.id.toString());

                          if (result['status']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result['message']),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result['message']),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ReserveBar(
          price: widget.hotel.housePrice, houseId: widget.hotel.id.toString()),
    );
  }
}

class _HotelTitleSection extends StatelessWidget {
  const _HotelTitleSection({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  final HotelModel hotel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.large(
          hotel.houseName,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Assets.icon.location.svg(color: ColorName.darkGrey, height: 15),
            const SizedBox(width: 10),
            AppText.small(hotel.houseLocation),
          ],
        ),
        const SizedBox(height: 10),
        CustomRating(
          ratingScore: hotel.ratingScore ?? 0.0,
          showReviews: true,
          totalReviewer: hotel.totalReview,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _FacilitiesSection extends StatelessWidget {
  final List<String> facilities;
  const _FacilitiesSection(this.facilities, {Key? key}) : super(key: key);

  SvgPicture getIconForFacility(String facility) {
    switch (facility) {
      case 'Flat-screen TV':
        return SvgPicture.asset(Assets.icon.amenities.tv.path);
      case 'Garden view':
        return SvgPicture.asset(Assets.icon.amenities.garden.path);
      case 'Patio':
        return SvgPicture.asset(Assets.icon.amenities.patio.path);
      case 'Barbecue':
        return SvgPicture.asset(Assets.icon.amenities.bbq.path);
      case 'Kitchen':
        return SvgPicture.asset(Assets.icon.amenities.kitchen.path);
      case 'Wifi':
        return SvgPicture.asset(Assets.icon.amenities.wifi.path);
      case 'Air Conditioner':
        return SvgPicture.asset(Assets.icon.amenities.airConditioner.path);
      case 'Swimming Pool':
        return SvgPicture.asset(Assets.icon.amenities.swimmingPool.path);
      case 'Room Service':
        return SvgPicture.asset(Assets.icon.amenities.roomService.path);
      case 'Free Parking':
        return SvgPicture.asset(Assets.icon.amenities.parking.path);
      case 'Private Bathroom':
        return SvgPicture.asset(Assets.icon.amenities.privateBathroom.path);
      case 'Family Room':
        return SvgPicture.asset(Assets.icon.amenities.family.path);
      case 'Transport':
        return SvgPicture.asset(Assets.icon.amenities.transport.path);
      case 'View':
        return SvgPicture.asset(Assets.icon.amenities.view.path);
      default:
        return SvgPicture.asset(Assets.icon.amenities.view.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium('Facilities', fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        Table(
          columnWidths: const {0: FlexColumnWidth(), 1: FlexColumnWidth()},
          children: _buildTableRows(),
        ),
      ],
    );
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [];
    for (var i = 0; i < facilities.length; i += 2) {
      rows.add(
        TableRow(
          children: [
            _buildIconWithLabel(
              getIconForFacility(facilities[i]),
              facilities[i],
            ),
            if (i + 1 < facilities.length)
              _buildIconWithLabel(
                getIconForFacility(facilities[i + 1]),
                facilities[i + 1],
              )
            else
              Container(),
          ],
        ),
      );
    }
    return rows;
  }

  Padding _buildIconWithLabel(
    SvgPicture icon,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 10),
          AppText.medium(label, fontWeight: FontWeight.normal),
        ],
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    Key? key,
    required this.imagePaths,
  }) : super(key: key);

  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppText.medium('Gallery', fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 150,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 10),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              final imagePath = imagePaths[index];
              return AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({
    Key? key,
    required this.address,
  }) : super(key: key);

  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium('Location', fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        AppText.medium(address, fontWeight: FontWeight.normal),
        const SizedBox(height: 10),
        FutureBuilder<LatLng>(
          future: _getLatLngFromAddress(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            } else {
              final coordinate = snapshot.data!;
              return FutureBuilder<BitmapDescriptor?>(
                future: _convertToMarkerBitmap(),
                builder: (context, snapshot) {
                  final bitmapData = snapshot.data;
                  if (bitmapData == null) {
                    return const SizedBox.shrink();
                  } else {
                    return SizedBox(
                      height: 200,
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        initialCameraPosition:
                            CameraPosition(target: coordinate, zoom: 15),
                        markers: {
                          Marker(
                            markerId: MarkerId(address),
                            position: coordinate,
                            icon: bitmapData,
                          ),
                        },
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<LatLng> _getLatLngFromAddress() async {
    final locations =
        await locationFromAddress("Kapal Terbang Guest House Langkawi");
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  Future<BitmapDescriptor?> _convertToMarkerBitmap() async {
    final data = await rootBundle.load(Assets.icon.pinPng.path);
    final uint8List = data.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(uint8List);
  }
}

class _DescriptionSection extends StatefulWidget {
  const _DescriptionSection({
    Key? key,
    required this.description,
  }) : super(key: key);

  final String description;

  @override
  _DescriptionSectionState createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<_DescriptionSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium('Description', fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            height: isExpanded ? null : 100, // Adjust this value as needed
            child: Text(
              widget.description,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
              maxLines: isExpanded ? null : 5, // Adjust this value as needed
              overflow: TextOverflow.fade,
            ),
          ),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: AppText.medium(
            isExpanded ? 'Show less' : 'Show more',
            textDecoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}

class _ReviewSectionState extends StatefulWidget {
  final String profileImage;
  final String name;
  final String review;
  final double rate;

  const _ReviewSectionState({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.review,
    required this.rate,
  }) : super(key: key);

  @override
  State<_ReviewSectionState> createState() => __ReviewSectionStateState();
}

class __ReviewSectionStateState extends State<_ReviewSectionState> {
  bool isExpanded = true; // Initialize isExpanded to false

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Add this line
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Image(
                    image: NetworkImage(widget.profileImage),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF14181B),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: RatingBar.builder(
                        initialRating: widget.rate.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 18,
                        ignoreGestures: true,
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 4, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          widget.review,
                          maxLines:
                              isExpanded ? null : 40, // Adjust maxLines here
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Color(0xFF57636C),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.2,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class _ReserveBar extends StatefulWidget {
  const _ReserveBar({
    Key? key,
    required this.price,
    required this.houseId,
  }) : super(key: key);

  final double price;
  final String houseId;

  @override
  State<_ReserveBar> createState() => _ReserveBarState();
}

class _ReserveBarState extends State<_ReserveBar> {
  List<dynamic> policies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPolicy();
    });
  }

  void fetchPolicy() async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.userEndpoints.housePolicy),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          policies = jsonDecode(response.body);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  void _showFullScreenDialog(BuildContext context) {
    bool? isChecked = false;

    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              appBar: AppBar(
                title: AppText.large(
                  'Terms and Conditions',
                  fontSize: 20,
                  textAlign: TextAlign.left,
                  maxLine: 2,
                  textOverflow: TextOverflow.ellipsis,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        height: 700.0,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListView.builder(
                            itemCount: policies.length + 1,
                            itemBuilder: (context, index) {
                              if (index < policies.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${index + 1}.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(fontSize: 16),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${policies[index]['policyNote']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: AppText.large(
                                        'Please adhere to these policies during your stay. Thank You for your cooperation',
                                        fontSize: 16,
                                        textAlign: TextAlign.left,
                                        maxLine: 3,
                                        textOverflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 80)
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('I agree to the policy', style: TextStyle(fontWeight: FontWeight.bold),),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CustomButton(
                      buttonText: 'Continue',
                      onPressed: isChecked == true
                          ? () {
                              Navigator.of(context).pop();
                              Get.to(
                                () => ReserveScreen(
                                    houseId: widget.houseId,
                                    pricePerNight: widget.price),
                                transition: Transition.rightToLeftWithFade,
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);

    return Container(
      height: 90,
      padding: const EdgeInsets.all(20.0).copyWith(top: 10.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium('Start from', fontWeight: FontWeight.normal),
              RichText(
                text: TextSpan(
                  children: [
                    AppTextSpan.large('\RM ${widget.price}'),
                    AppTextSpan.medium(' /night'),
                  ],
                ),
              ),
            ],
          ),
          if (authNotifier.userType == 'user')
            SizedBox(
              width: 150,
              child: CustomButton(
                buttonText: authNotifier.isLoggedIn ? 'Reserve' : 'Sign In',
                onPressed: () async {
                  if (authNotifier.isLoggedIn) {
                    _showFullScreenDialog(context);
                  } else {
                    Get.to(
                      () => SignInWidget(),
                      transition: Transition.fadeIn,
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
