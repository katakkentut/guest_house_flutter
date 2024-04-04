// ignore_for_file: prefer_const_constructors, unused_field

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:guest_house_app/admin/services/add_house_service.dart';
import 'package:guest_house_app/gen/assets.gen.dart';
import 'package:guest_house_app/gen/colors.gen.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:guest_house_app/widgets/custom_button.dart';
import 'package:guest_house_app/widgets/custom_rating.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddHouse extends StatefulWidget {
  const AdminAddHouse({super.key});

  @override
  State<AdminAddHouse> createState() => _AdminAddHouseState();
}

class _AdminAddHouseState extends State<AdminAddHouse> {
  final TextController _houseNameController = TextController();

  final TextEditingController _houseDescriptionController =
      TextEditingController();
  final TextEditingController _hpuseBedController = TextEditingController();
  final TextEditingController _housePeopleController = TextEditingController();
  final TextController _housePriceController = TextController();
  final TextController _houseLocationController = TextController();
  final TextEditingController _houseAddressController = TextEditingController();
  final TextEditingController _houseFacilityController =
      TextEditingController();
  File? _image;
  List<File> _images = [];
  final _formKey = GlobalKey<FormBuilderState>();
  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    setState(() {
      if (images != null) {
        _images = images.map((image) => File(image.path)).toList();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText.large(
          'Add House',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        child: _image == null
                            ? Container(
                                padding: const EdgeInsets.all(25.0),
                                child: Text('No Image'),
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: _houseNameController.textNotifier,
                            builder: (BuildContext context, String value,
                                Widget? child) {
                              return AppText.large(
                                value.isEmpty ? 'Unknown' : value,
                                fontSize: 18,
                                textAlign: TextAlign.left,
                                maxLine: 2,
                                textOverflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Assets.icon.location.svg(
                                color: ColorName.darkGrey,
                                height: 15,
                              ),
                              const SizedBox(width: 8),
                              ValueListenableBuilder<String>(
                                valueListenable:
                                    _houseLocationController.textNotifier,
                                builder: (BuildContext context, String value,
                                    Widget? child) {
                                  return AppText.small(
                                    value.isEmpty ? 'Unknown' : value,
                                    fontSize: 14,
                                  );
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: CustomRating(ratingScore: 0.0),
                          ),
                          ValueListenableBuilder<String>(
                            valueListenable: _housePriceController.textNotifier,
                            builder: (BuildContext context, String value,
                                Widget? child) {
                              return RichText(
                                text: TextSpan(
                                  children: [
                                    AppTextSpan.large(
                                        '\RM ${value.isEmpty ? '0.00' : value}'),
                                    AppTextSpan.medium(' /night'),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColorName.lightGrey.withAlpha(100),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'houseName',
                            controller: _houseNameController,
                            decoration: InputDecoration(
                              labelText: 'House Name',
                              hintText: 'Enter House Name',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FormBuilderDropdown(
                            name: 'houseCategory',
                            decoration: InputDecoration(
                              labelText: 'House Category',
                              hintText: 'Select House Category',
                            ),
                            items: ['House', 'Villa', 'Studio']
                                .map((category) => DropdownMenuItem(
                                      value: category,
                                      child: Text('$category'),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            name: 'houseDescription',
                            controller: _houseDescriptionController,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'House Description',
                              hintText: 'Enter House Description',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FormBuilderChoiceChip(
                            name: 'houseBed',
                            decoration: InputDecoration(
                                labelText: 'House Bed',
                                border: InputBorder.none),
                            options: const [
                              FormBuilderChipOption(value: '2'),
                              FormBuilderChipOption(value: '4'),
                              FormBuilderChipOption(value: '6'),
                              FormBuilderChipOption(value: '8'),
                            ],
                          ),
                          FormBuilderChoiceChip(
                            name: 'housePeople',
                            decoration: InputDecoration(
                                labelText: 'House People',
                                border: InputBorder.none),
                            spacing: 2.0,
                            options: const [
                              FormBuilderChipOption(value: '2'),
                              FormBuilderChipOption(value: '4'),
                              FormBuilderChipOption(value: '6'),
                              FormBuilderChipOption(value: '8'),
                              FormBuilderChipOption(value: '10'),
                              FormBuilderChipOption(value: '12'),
                            ],
                          ),
                          FormBuilderTextField(
                            name: 'housePrice',
                            controller: _housePriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'House Price',
                              hintText: 'Enter House Price',
                              prefixText: 'RM  ',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            name: 'houseLocation',
                            controller: _houseLocationController,
                            decoration: InputDecoration(
                              labelText: 'House Location',
                              hintText: 'eg. Pantai Cenang, Langkawi',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            name: 'houseAddress',
                            controller: _houseAddressController,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'House Address',
                              hintText:
                                  'eg. No.53A, Lot 1721,Kg.Perana,Mk.Kedawang,Langkawi, 07000 Pantai Cenang, Malaysia',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FormBuilderFilterChip(
                            name: 'houseFacility',
                            decoration: InputDecoration(
                                labelText: 'House Facility',
                                border: InputBorder.none),
                            spacing: 8.0,
                            options: const [
                              FormBuilderChipOption(value: 'Kitchen'),
                              FormBuilderChipOption(value: 'Private bathroom'),
                              FormBuilderChipOption(value: 'Garden view'),
                              FormBuilderChipOption(value: 'Swimming Pool'),
                              FormBuilderChipOption(value: 'Air Conditioner'),
                              FormBuilderChipOption(value: 'Patio'),
                              FormBuilderChipOption(value: 'Flat-screen TV'),
                              FormBuilderChipOption(value: 'Barbecue'),
                              FormBuilderChipOption(value: 'Room Service'),
                              FormBuilderChipOption(value: 'Wifi'),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_a_photo),
                                onPressed: _pickImage,
                              ),
                              Text('Add House Thumbnail'),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_a_photo),
                                onPressed: _pickImages,
                              ),
                              Text('Add House Photos'),
                            ],
                          ),
                          _images.isEmpty
                              ? Container()
                              : SizedBox(
                                  height: 200,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing:
                                        10, // Add horizontal spacing
                                    mainAxisSpacing: 10, // Add vertical spacing
                                    children: _images.map((image) {
                                      return Container(
                                        margin: const EdgeInsets.all(
                                            2.0), // Add margin

                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Image.file(
                                              image,
                                              fit: BoxFit.cover,
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                  CupertinoIcons
                                                      .xmark_circle_fill,
                                                  color: Colors.black),
                                              onPressed: () {
                                                setState(() {
                                                  _images.remove(image);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          DetailScreenButton(
                            buttonText: 'Add House',
                            onPressed: () async {
                              if (_formKey.currentState!.saveAndValidate()) {
                                var result = await AddHouseServices().addHouse(
                                    _formKey.currentState!.value,
                                    _image,
                                    _images);

                                if (result['status']) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      result['message'],
                                    ),
                                    backgroundColor: Colors.green,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "An error occurred. Please try again later.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please fill in all the required fields.",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextController extends TextEditingController {
  TextController() {
    addListener(_handleTextChange);
  }

  final ValueNotifier<String> _textNotifier = ValueNotifier('');

  ValueNotifier<String> get textNotifier => _textNotifier;

  void _handleTextChange() {
    _textNotifier.value = text;
  }

  @override
  void dispose() {
    removeListener(_handleTextChange);
    super.dispose();
  }
}
