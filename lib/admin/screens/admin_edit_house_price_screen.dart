// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_result

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guest_house_app/models/hotel_model.dart';
import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:guest_house_app/widgets/hotel_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminEditHousePrice extends StatefulWidget {
  @override
  _AdminEditHousePriceState createState() => _AdminEditHousePriceState();
}

class _AdminEditHousePriceState extends State<AdminEditHousePrice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.large(
          'Update House Price',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: _NearbyHotelSection()),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearbyHotelSection extends HookConsumerWidget {
  const _NearbyHotelSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshCompleter = Completer<void>();

    void _refresh() {
      ref.refresh(adminAllHotelsProvider);
      refreshCompleter.complete();
    }

    return RefreshIndicator(
      onRefresh: () {
        _refresh();
        return refreshCompleter.future;
      },
      child: FutureBuilder<List<HotelModel>>(
        future: ref.watch(adminAllHotelsProvider.future),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (!refreshCompleter.isCompleted) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 5.0,
                  backgroundColor: Colors.white,
                )),
              );
            }
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final hotels = snapshot.data!;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Select House',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: hotels.length,
                  itemBuilder: (BuildContext context, int index) {
                    HotelModel hotel = hotels[index];
                    return HotelCard(hotel: hotel, option: 'Edit Price');
                  },
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
