import 'package:flutter/material.dart';
import 'package:flutter_hotel_app_ui/users/repositories/book_date.dart';
import 'package:flutter_hotel_app_ui/users/screens/header_section.dart';
import 'package:flutter_hotel_app_ui/widgets/custom_date_input.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../gen/colors.gen.dart';
import '../models/hotel_model.dart';
import '../providers/all_hotels_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_nav_bar.dart';
import '../../widgets/hotel_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex =
      0; // State variable to keep track of the selected tab index

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
              margin: EdgeInsets.only(top: size.height * 0.25),
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  HeaderSection(),
                  _SearchCard(),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _NearbyHotelSection(),
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

final loadingProvider = StateProvider<bool>((ref) => false);

class _SearchCard extends ConsumerWidget {
  final TextEditingController locationTextController = TextEditingController();
  final TextEditingController dateFromTextController = TextEditingController();
  final TextEditingController dateToTextController = TextEditingController();

  final ValueNotifier<DateTime?> fromDate = ValueNotifier<DateTime?>(null);

  _SearchCard({Key? key}) : super(key: key) {
    locationTextController.text = 'Yogyakarta';
    dateFromTextController.text = dateToTextController.text =
        DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    locationTextController.text = 'Yogyakarta';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorName.lightGrey.withAlpha(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Location input
            ],
          ),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue),
              const SizedBox(width: 16),
              CustomDateInput(
                label: 'From',
                controller: dateFromTextController,
                onDateSelected: (selectedDate) {
                  fromDate.value = selectedDate; // Update first date
                },
              ),
              CustomDateInput(
                label: 'To',
                controller: dateToTextController,
                firstDate: fromDate.value, // Pass first date
              ),
            ],
          ),
          const SizedBox(height: 16),
          isLoading
              ? CircularProgressIndicator()
              : CustomButton(
                  buttonText: 'Search',
                  onPressed: () async {
                    if (dateFromTextController.text.isNotEmpty &&
                        dateToTextController.text.isNotEmpty) {
                      ref.read(loadingProvider.notifier).state = true;

                      DateTime dateFrom = DateFormat('dd MMM yyyy')
                          .parse(dateFromTextController.text);
                      DateTime dateTo = DateFormat('dd MMM yyyy')
                          .parse(dateToTextController.text);
                      String formattedDateFrom =
                          DateFormat('yyyy-MM-dd').format(dateFrom);
                      String formattedDateTo =
                          DateFormat('yyyy-MM-dd').format(dateTo);

                      await SharedPreferencesHelper.setBookingDates(
                          formattedDateFrom, formattedDateTo);

                      FocusScope.of(context).unfocus();

                      ref.refresh(allHotelsProvider);

                      ref.read(loadingProvider.notifier).state = false;
                    }
                  },
                ),
        ],
      ),
    );
  }
}

class _NearbyHotelSection extends ConsumerWidget {
  const _NearbyHotelSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotels = ref.watch(allHotelsProvider);
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'All House',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
