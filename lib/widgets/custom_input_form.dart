// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;
  final bool isObscure;
  final String? prefixText;
  final String? Function(String?)? validator;

  const CustomInputForm({
    Key? key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.inputType,
    this.isObscure = false,
    this.prefixText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          autofocus: true,
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
            fontSize: 14,
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