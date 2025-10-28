// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class MonthDropdown extends StatefulWidget {
  final TextEditingController controller;

  final String hint;

  const MonthDropdown({
    super.key,
    required this.controller,
    this.hint = "Select Month",
  });

  @override
  _MonthDropdownState createState() => _MonthDropdownState();
}

class _MonthDropdownState extends State<MonthDropdown> {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty &&
        months.contains(widget.controller.text)) {
      selectedMonth = widget.controller.text; // controller ka value set kar do
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      menuMaxHeight: 200,
      initialValue: selectedMonth,
      hint: customText(monst: true, title: widget.hint),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Constants.black),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Constants.subtitleclr),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Constants.subtitleclr),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: months
          .map(
            (month) => DropdownMenuItem<String>(
              value: month,
              child: customText(monst: true, title: month),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedMonth = value;
          widget.controller.text = value!;
        });
      },
    );
  }
}
