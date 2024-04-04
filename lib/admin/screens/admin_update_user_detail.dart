// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/services/update_user_sevice.dart';
import 'package:guest_house_app/gen/colors.gen.dart';
import 'package:guest_house_app/models/user_detail_model.dart';
import 'package:guest_house_app/users/services/update_profile_sevice.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:image_picker/image_picker.dart';

class AdminUpdateProfileScreen extends StatefulWidget {
  const AdminUpdateProfileScreen({super.key, required this.user});
  final UserDetailModel user;

  @override
  State<AdminUpdateProfileScreen> createState() =>
      _AdminUpdateProfileScreenState();
}

class _AdminUpdateProfileScreenState extends State<AdminUpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  dynamic _image;

  final ImagePicker _picker = ImagePicker();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailAddressFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  String? _profileImageUrl;
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.fullname;
    emailAddressController.text = widget.user.email;
    phoneController.text = widget.user.phone;
    _profileImageUrl = widget.user.userImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText.large(
          'Update Profile',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorName.lightGrey.withAlpha(50),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, 60, 32, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildImageUploadForm(),
                        SizedBox(height: 16),
                        buildInput(
                          'Full Name',
                          nameController,
                          nameFocusNode,
                          TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        buildInput(
                          'Email',
                          emailAddressController,
                          emailAddressFocusNode,
                          TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        buildInput(
                          'Phone Number',
                          phoneController,
                          phoneFocusNode,
                          TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            16,
                            25,
                            16,
                            16,
                          ),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_image != null) {
                                  var result = await UpdateProfileService()
                                      .updateProfile(
                                    nameController.text,
                                    emailAddressController.text,
                                    phoneController.text,
                                    _image
                                        as File, // Cast _image to File since it's guaranteed to be a File here
                                  );
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
                                  // Handle case where user did not pick an image
                                  // Send only name, email, and phone number
                                  var result =
                                      await UpdateUserService().updateProfile(
                                    widget.user.userId,
                                    nameController.text,
                                    emailAddressController.text,
                                    phoneController.text,
                                    null,
                                  );
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
                                }

                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Update Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
          ],
        ),
      ),
    );
  }

  Widget buildInput(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    TextInputType inputType, {
    bool isObscure = false,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        0,
        9,
        0,
        9,
      ),
      child: Container(
        width: 370,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          obscureText: isObscure,
          decoration: InputDecoration(
            labelText: label,
            prefixText: prefixText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: inputType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }

  Widget buildImageUploadForm() {
    return Center(
      child: Column(
        children: [
          Text(
            'Profile Photo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: _image == null
                      ? _profileImageUrl == null
                          ? Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.grey,
                            )
                          : Image.network(
                              _profileImageUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                      : Image.file(
                          _image as File,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(8),
                    backgroundColor: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
