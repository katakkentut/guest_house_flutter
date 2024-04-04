// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_result
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/providers/all_booking_provider.dart';
import 'package:guest_house_app/users/screens/header_section.dart';
import 'package:guest_house_app/widgets/booking_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/custom_nav_bar.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex =
      1; 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: CustomNavBar(
        index: _selectedIndex,
        onTabChanged: (int newIndex) {
          setState(() {
            _selectedIndex = newIndex;
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
                  SizedBox(height: 30),
                  Expanded(child: NestedTabBar())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: "Today's Book"),
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
          ],
          indicatorColor: Colors.blueAccent,
        ),
        Expanded(
          child: Container(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(3.0),
                  child: SingleChildScrollView(
                      child:
                          _PendingBookingSection(bookingStatus: 'todayBook')),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                      child: _PendingBookingSection(bookingStatus: 'Pending')),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                      child: _PendingBookingSection(bookingStatus: 'Approved')),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PendingBookingSection extends HookConsumerWidget {
  const _PendingBookingSection({Key? key, required this.bookingStatus})
      : super(key: key);
  final String bookingStatus;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshCompleter = Completer<void>();

    void _refresh() {
      ref.refresh(allBookingProvider(bookingStatus));
      refreshCompleter.complete();
    }

    return RefreshIndicator(
      onRefresh: () {
        _refresh();
        return refreshCompleter.future;
      },
      child: FutureBuilder<List<BookingModel>>(
        future: ref.watch(allBookingProvider(bookingStatus).future),
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
            final bookings = snapshot.data!;
            if (bookings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: Text('No $bookingStatus booking available yet')),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (BuildContext context, int index) {
                BookingModel booking = bookings[index];
                return BookingItemCard(booking: booking);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
