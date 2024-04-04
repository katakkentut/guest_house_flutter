// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guest_house_app/gen/assets.gen.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText.large(
          'About Us',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              _LocationSection(
                address:
                    'No.53A, Lot 1721, Kg.Perana, Mk.Kedawang, Langkawi, 07000 Pantai Cenang, Malaysia',
              ),
              SizedBox(height: 30, width: double.infinity, child: Divider()),
              _ContactUsWidget(),
            ],
          )),
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
        AppText.medium(address, fontWeight: FontWeight.normal),
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

class _ContactUsWidget extends StatelessWidget {
  const _ContactUsWidget({super.key});

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('https://wa.me/+60125250081');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium('Contact Us', fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _launchUrl,
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone),
                      const SizedBox(width: 10),
                      AppText.medium('+6012-5250081',
                          fontWeight: FontWeight.normal),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
