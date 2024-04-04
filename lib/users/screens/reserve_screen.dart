import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:guest_house_app/users/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:guest_house_app/gen/colors.gen.dart';
import 'package:guest_house_app/users/services/reserve_page_service.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:guest_house_app/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import '../../widgets/hotel_card.dart';
import '../../models/hotel_model.dart';

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
  int _adultNumber = 0;
  int _childrenNumber = 0;
  String bookingNote = '';
  final loadingNotifier = ValueNotifier<bool>(false);

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

  void updateAdultNumber(int adultNumber) {
    setState(() {
      _adultNumber = adultNumber;
    });
  }

  void updateChildrenNumber(int childrenNumber) {
    setState(() {
      _childrenNumber = childrenNumber;
    });
  }

  void updateBookingNote(String notes) {
    setState(() {
      bookingNote = notes;
    });
  }

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

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
    return ValueListenableBuilder<bool>(
        valueListenable: loadingNotifier,
        builder: (context, isLoading, child) {
          return Stack(
            children: [
              Scaffold(
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
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          color:
                                              ColorName.lightGrey.withAlpha(50),
                                        ),
                                      ),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today,
                                                    color: Colors.blue),
                                                const SizedBox(width: 16),
                                                Flexible(
                                                  child: TextField(
                                                    controller:
                                                        fromDateController,
                                                    decoration: InputDecoration(
                                                      label: AppText.small(
                                                        'From',
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    readOnly: true,
                                                    autofocus: false,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: TextField(
                                                    controller:
                                                        toDateController,
                                                    decoration: InputDecoration(
                                                      label: AppText.small(
                                                        'To',
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                          color:
                                              ColorName.lightGrey.withAlpha(50),
                                        ),
                                      ),
                                      child: CalendarDatePicker2(
                                        config: config,
                                        value:
                                            _rangeDatePickerValueWithDefaultValue,
                                        onValueChanged: (value) {
                                          if (value.length == 2) {
                                            for (int i = 0;
                                                i <=
                                                    value[1]!
                                                        .difference(value[0]!)
                                                        .inDays;
                                                i++) {
                                              DateTime currentDate = value[0]!
                                                  .add(Duration(days: i));
                                              if (disabledDates.any(
                                                  (disabledDate) =>
                                                      disabledDate.year ==
                                                          currentDate.year &&
                                                      disabledDate.month ==
                                                          currentDate.month &&
                                                      disabledDate.day ==
                                                          currentDate.day)) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: AppText.small(
                                                        'Date is not available',
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 1),
                                                  ),
                                                );
                                                fromDateController.clear();
                                                toDateController.clear();
                                                return;
                                              }
                                            }

                                            String startDate =
                                                DateFormat('dd MMM yyyy')
                                                    .format(value[0]!);
                                            String endDate =
                                                DateFormat('dd MMM yyyy')
                                                    .format(value[1]!);
                                            fromDateController.text = startDate;
                                            toDateController.text = endDate;
                                            int numberOfDays = value[1]!
                                                .difference(value[0]!)
                                                .inDays;
                                            daysNotifier.value =
                                                numberOfDays.toString();
                                            totalPriceNotifier.value =
                                                numberOfDays *
                                                    widget.pricePerNight;
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _NearbyHotelSection(houseId: widget.houseId),
                              SizedBox(height: 20),
                              PeopleBookingWidget(
                                  setAdultNumber: updateAdultNumber,
                                  setChildrenNumber: updateChildrenNumber),
                              BookingNoteWidget(
                                  onNoteEntered: updateBookingNote),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: ValueListenableBuilder<double>(
                  valueListenable: totalPriceNotifier,
                  builder: (context, totalPrice, child) => _ReserveBar(
                    price: totalPrice,
                    days: daysNotifier.value,
                    bookingFrom: fromDateController.text,
                    bookingTo: toDateController.text,
                    adultNumber: _adultNumber,
                    childrenNumber: _childrenNumber,
                    bookingNote: bookingNote,
                    houseId: widget.houseId,
                    loadingNotifier: loadingNotifier,
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: SizedBox(
                      width: 50.0, // Adjust the width
                      height: 50.0, // Adjust the height
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 5.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}

class PeopleBookingWidget extends StatefulWidget {
  final ValueChanged<int> setAdultNumber;
  final ValueChanged<int> setChildrenNumber;

  PeopleBookingWidget(
      {required this.setAdultNumber, required this.setChildrenNumber});

  @override
  _PeopleBookingWidgetState createState() => _PeopleBookingWidgetState();
}

class _PeopleBookingWidgetState extends State<PeopleBookingWidget> {
  int _selectedAdults = 0;
  int _selectedChildren = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.values[0],
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Number of People',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ColorName.lightGrey.withAlpha(50),
            ),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Adults',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 55.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 13,
                  itemBuilder: (context, index) {
                    final number = index;
                    return Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: SizedBox(
                        width: 43,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedAdults = number;
                              widget.setAdultNumber(_selectedAdults);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedAdults == number
                                ? Colors.blue
                                : Colors.white,
                            shape: CircleBorder(),
                          ),
                          child: Text(
                            '$number',
                            style: TextStyle(
                              color: _selectedAdults == number
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Children',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 55.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 13,
                  itemBuilder: (context, index) {
                    final number = index;
                    return Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: SizedBox(
                        width: 43,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedChildren = number;
                              widget.setChildrenNumber(_selectedChildren);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedChildren == number
                                ? Colors.blue
                                : Colors.white,
                            shape: CircleBorder(),
                          ),
                          child: Text(
                            '$number',
                            style: TextStyle(
                              color: _selectedChildren == number
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookingNoteWidget extends StatefulWidget {
  final ValueChanged<String> onNoteEntered;
  BookingNoteWidget({required this.onNoteEntered});
  @override
  State<BookingNoteWidget> createState() => _BookingNoteWidgetState();
}

class _BookingNoteWidgetState extends State<BookingNoteWidget> {
  final TextEditingController noteController = TextEditingController();

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
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: noteController,
                decoration: InputDecoration(
                  hintText: 'Enter your note here',
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 5,
                maxLength: 500,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.onNoteEntered(value);
                },
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
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
    this.bookingFrom,
    this.bookingTo,
    this.adultNumber,
    this.childrenNumber,
    this.bookingNote,
    this.houseId,
    required this.loadingNotifier,
  }) : super(key: key);

  final double price;
  final String days;
  final String? bookingFrom;
  final String? bookingTo;
  final int? adultNumber;
  final int? childrenNumber;
  final String? bookingNote;
  final String? houseId;
  final ValueNotifier<bool> loadingNotifier;

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
              onPressed: () async {
                if (bookingFrom!.isEmpty || bookingTo!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText.small(
                        'Please select booking date',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else if (adultNumber == 0 && childrenNumber == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText.small(
                        'Please select number of people',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else if (adultNumber == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText.small(
                        'Please select number of people',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  var result = await ReservePageService().makeReservation(
                    houseId!,
                    bookingFrom!,
                    bookingTo!,
                    adultNumber!,
                    childrenNumber!,
                    price,
                    bookingNote,
                  );
                  if (result['status']) {
                    loadingNotifier.value = true;
                    await Future.delayed(Duration(seconds: 2));
                    loadingNotifier.value = false;
                    Get.offAll(() => HomeScreen(), transition: Transition.fade);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result['message'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: AppText.small(
                          result['message'],
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
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
          ],
        );
      },
    );
  }
}
