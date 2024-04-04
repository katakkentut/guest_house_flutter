// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:guest_house_app/auth/services/signup-service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userCountry = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailAddressFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode userCountryFocusNode = FocusNode();
  bool passwordVisibility = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'SignUp Page',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/logo/bg.png'), // replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                      Container(
                        margin: EdgeInsets.only(
                            top: 60.0), // adjust the value as needed
                        child: Text(
                          'Thank you for choosing us!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Text(
                        'Fills out the registration form below.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                        prefixText: '+60 ',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      buildInput(
                        'Country',
                        userCountry,
                        userCountryFocusNode,
                        TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid country';
                          }
                          return null;
                        },
                      ),
                      buildInput(
                        'Password',
                        passwordController,
                        passwordFocusNode,
                        TextInputType.visiblePassword,
                        isObscure: true,
                        validator: (value) {
                          String pattern =
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          RegExp regex = new RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (!regex.hasMatch(value)) {
                            return 'Password must have at least:\n 1 uppercase letter, \n 1 lowercase letter,\n 1 number,\n 1 special character \n Must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      buildImageUploadForm(),
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
                              var result = await SignUpService().registerUser(
                                nameController.text,
                                emailAddressController.text,
                                passwordController.text,
                                phoneController.text,
                                _image!,
                                userCountry.text,
                              );
                              if (result['status']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(result['message']),
                                      backgroundColor: Colors.green),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(result['message']),
                                      backgroundColor: Colors.red),
                                );
                              }
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
                              'Sign Up',
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
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue,
                        )
                      : Image.file(
                          _image!,
                          width: 120,
                          height: 120,
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
