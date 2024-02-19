import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this
import 'app_text.dart';

class CustomDateInput extends StatelessWidget {
  const CustomDateInput({
    Key? key,
    required this.label,
    required this.controller,
    this.firstDate,
    this.onDateSelected,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final DateTime? firstDate;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: AppText.small(label, fontSize: 14),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontWeight: FontWeight.bold),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: firstDate ?? DateTime.now(),
            firstDate: firstDate ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            controller.text = DateFormat('dd MMM yyyy').format(date);
            onDateSelected?.call(date);
          }
        },
      ),
    );
  }
}