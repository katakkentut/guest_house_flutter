// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:guest_house_app/admin/screens/admin_setting_screen.dart';
import 'package:guest_house_app/admin/services/edit_house_service.dart';
import 'package:guest_house_app/gen/colors.gen.dart';
import 'package:guest_house_app/models/hotel_model.dart';
import 'package:guest_house_app/providers/all_hotels_provider.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:guest_house_app/widgets/hotel_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class EditDeleteHousePrice extends StatefulWidget {
  const EditDeleteHousePrice({super.key, required this.hotel});

  final HotelModel hotel;
  @override
  State<EditDeleteHousePrice> createState() => _EditDeleteHousePriceState();
}

class _EditDeleteHousePriceState extends State<EditDeleteHousePrice> {
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
                child: _NearbyHotelSection(houseId: widget.hotel.id),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: _UpdatePriceSection(houseId: widget.hotel.id),
              ),
            ],
          ),
        ),
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
        return Column(children: [
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
        ]);
      },
    );
  }
}

class _UpdatePriceSection extends StatefulWidget {
  const _UpdatePriceSection({super.key, required this.houseId});

  final String houseId;

  @override
  State<_UpdatePriceSection> createState() => _UpdatePriceSectionState();
}

class _UpdatePriceSectionState extends State<_UpdatePriceSection> {
  TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        FormBuilder(
          child: FormBuilderTextField(
            name: 'housePrice',
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'House Price',
              hintText: 'Enter House Price',
              prefixText: 'RM  ',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_priceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter house price'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    var result = await UpdateHouseService()
                        .editHouse(widget.houseId, _priceController.text);

                    if (result['status']) {
                      Get.offAll(AdminSettingScreen());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'],
                              style: TextStyle(fontSize: 16)),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message']),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(ColorName.yellow),
                  minimumSize: MaterialStateProperty.all(const Size(120, 50)),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: AppText.medium(
                  'Update Price',
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Dialogs.bottomMaterialDialog(
                      msg: 'Are you sure? you can\'t undo this action',
                      msgStyle: TextStyle(fontFamily: 'Outfit'),
                      title: 'Delete',
                      context: context,
                      actions: [
                        IconsButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          text: 'Cancel',
                          iconData: Icons.cancel_outlined,
                          textStyle: TextStyle(color: Colors.grey),
                          iconColor: Colors.grey,
                        ),
                        IconsButton(
                          onPressed: () async {
                            var result = await UpdateHouseService()
                                .deleteHouse(widget.houseId);

                            if (result['status']) {
                              Get.offAll(AdminSettingScreen());

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result['message'],
                                      style: TextStyle(fontSize: 16)),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result['message']),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          text: 'Delete',
                          iconData: Icons.delete,
                          color: Colors.red,
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                      ]);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  minimumSize: MaterialStateProperty.all(const Size(120, 50)),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: AppText.medium(
                  'Delete House',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
