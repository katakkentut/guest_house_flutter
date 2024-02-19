import 'package:flutter_hotel_app_ui/users/providers/all_hotels_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotel_app_ui/gen/colors.gen.dart';
import 'package:flutter_hotel_app_ui/users/services/reserve_page_service.dart';
import 'package:flutter_hotel_app_ui/users/widgets1/app_text.dart';
import 'package:flutter_hotel_app_ui/users/widgets1/custom_button.dart';
import 'package:intl/intl.dart';
import '../../widgets/hotel_card.dart';
import '../models/hotel_model.dart';

class ReserveScreen extends StatefulWidget {
  const ReserveScreen(
      {super.key, required this.houseId, required this.pricePerNight});
  final String houseId;
  final double pricePerNight;

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  late ValueNotifier<double> totalPriceNotifier;
  late ValueNotifier<String> daysNotifier;
  List<DateTime> disabledDates = [];

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [];
  @override
  void initState() {
    super.initState();
    totalPriceNotifier = ValueNotifier<double>(widget.pricePerNight);
    daysNotifier = ValueNotifier<String>('1');
    _getReservationDate();
  }

  void _getReservationDate() async {
    List<String> result =
        await ReservePageService().getReservation(widget.houseId);
    for (String date in result) {
      DateTime dateTime = DateTime.parse(date);
      setState(() {
        disabledDates.add(dateTime);
      });
    }
  }

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  @override
  void dispose() {
    totalPriceNotifier.dispose();
    daysNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      selectableDayPredicate: (day) {
        for (DateTime disabledDate in disabledDates) {
          if (disabledDate.year == day.year &&
              disabledDate.month == day.month &&
              disabledDate.day == day.day) {
            return false;
          }
        }
        return true;
      },
      calendarType: CalendarDatePicker2Type.range,
      firstDate: DateTime.now(),
      selectedDayHighlightColor: Colors.teal[800],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText.large(
          'Make Reservation',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Insert your booking date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
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
                                      Icon(Icons.calendar_today,
                                          color: Colors.blue),
                                      const SizedBox(width: 16),
                                      Flexible(
                                        child: TextField(
                                          controller: fromDateController,
                                          decoration: InputDecoration(
                                            label: AppText.small(
                                              'From',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          readOnly: true,
                                          autofocus: false,
                                        ),
                                      ),
                                      Flexible(
                                        child: TextField(
                                          controller: toDateController,
                                          decoration: InputDecoration(
                                            label: AppText.small(
                                              'To',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          readOnly: true,
                                          autofocus: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ]),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ColorName.lightGrey.withAlpha(50),
                              ),
                            ),
                            child: CalendarDatePicker2(
                              config: config,
                              value: _rangeDatePickerValueWithDefaultValue,
                              onValueChanged: (value) {
                                if (value.length == 2) {
                                  for (int i = 0;
                                      i <=
                                          value[1]!
                                              .difference(value[0]!)
                                              .inDays;
                                      i++) {
                                    DateTime currentDate =
                                        value[0]!.add(Duration(days: i));
                                    if (disabledDates.any((disabledDate) =>
                                        disabledDate.year == currentDate.year &&
                                        disabledDate.month ==
                                            currentDate.month &&
                                        disabledDate.day == currentDate.day)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: AppText.small(
                                              'Date is not available',
                                              fontSize: 15,
                                              color: Colors.white),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      fromDateController.clear();
                                      toDateController.clear();
                                      return;
                                    }
                                  }

                                  String startDate = DateFormat('dd MMM yyyy')
                                      .format(value[0]!);
                                  String endDate = DateFormat('dd MMM yyyy')
                                      .format(value[1]!);
                                  fromDateController.text = startDate;
                                  toDateController.text = endDate;
                                  int numberOfDays =
                                      value[1]!.difference(value[0]!).inDays +
                                          1;
                                  daysNotifier.value = numberOfDays.toString();
                                  totalPriceNotifier.value =
                                      numberOfDays * widget.pricePerNight;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _NearbyHotelSection(houseId: widget.houseId),
                    BookingNoteWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<double>(
        valueListenable: totalPriceNotifier,
        builder: (context, totalPrice, child) =>
            _ReserveBar(price: totalPrice, days: daysNotifier.value),
      ),
    );
  }
}

class BookingNoteWidget extends StatefulWidget {
  @override
  State<BookingNoteWidget> createState() => _BookingNoteWidgetState();
}

class _BookingNoteWidgetState extends State<BookingNoteWidget> {
  final TextEditingController peopleController = TextEditingController();

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Note (optional)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorName.lightGrey.withAlpha(50),
                ),
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(width: 16),
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: peopleController,
                        decoration: InputDecoration(),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReserveBar extends StatelessWidget {
  const _ReserveBar({
    Key? key,
    required this.price,
    required this.days,
  }) : super(key: key);

  final double price;
  final String days;

  @override
  Widget build(BuildContext context) {
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
              AppText.medium('Total Price', fontWeight: FontWeight.normal),
              RichText(
                text: TextSpan(
                  children: [
                    AppTextSpan.large('\RM ${price.toStringAsFixed(2)}/'),
                    AppTextSpan.medium('$days Days', fontSize: 17),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 150,
            child: CustomButton(
              buttonText: 'Book Now',
              onPressed: () async {},
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
