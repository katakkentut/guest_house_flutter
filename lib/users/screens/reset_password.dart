import 'package:flutter/material.dart';
import 'package:guest_house_app/gen/colors.gen.dart';
import 'package:guest_house_app/users/services/reset_password_service.dart';
import 'package:guest_house_app/widgets/app_text.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmNewPasswordFocusNode = FocusNode();

  bool _isOldPasswordObscured = true;
  bool _isNewPasswordObscured = true;
  bool _isConfirmNewPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText.large(
          'Reset Password',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
              child: Image.asset(
                'assets/icon/forgot-password.png', // Replace with your logo path
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInput(
                        'Old Password',
                        oldPassword,
                        oldPasswordFocusNode,
                        TextInputType.text,
                        isObscure: _isOldPasswordObscured,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          return null;
                        },
                        toggleVisibility: () {
                          setState(() {
                            _isOldPasswordObscured = !_isOldPasswordObscured;
                          });
                        },
                      ),
                      buildInput(
                        'New Password',
                        newPassword,
                        newPasswordFocusNode,
                        TextInputType.text,
                        isObscure: _isNewPasswordObscured,
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
                        toggleVisibility: () {
                          setState(() {
                            _isNewPasswordObscured = !_isNewPasswordObscured;
                          });
                        },
                      ),
                      buildInput(
                        'Confirm New Password',
                        confirmNewPassword,
                        confirmNewPasswordFocusNode,
                        TextInputType.text,
                        isObscure: _isConfirmNewPasswordObscured,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a confirm new password';
                          } else if (value != newPassword.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                        toggleVisibility: () {
                          setState(() {
                            _isConfirmNewPasswordObscured =
                                !_isConfirmNewPasswordObscured;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 25, 16, 16),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              var result = await ResetPasswordService()
                                  .resetPassword(
                                      oldPassword.text, newPassword.text);

                              if (result['status']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result['message']),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result['message']),
                                    backgroundColor: Colors.red,
                                  ),
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
                              'Reset Password',
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
    required bool isObscure,
    String? prefixText,
    String? Function(String?)? validator,
    required VoidCallback toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 9, 0, 9),
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
            suffixIcon: IconButton(
              onPressed: toggleVisibility,
              icon: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
              ),
            ),
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
}
