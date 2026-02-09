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
    final colors = context.appColors;
    return DropdownButtonFormField<String>(
      dropdownColor: colors.appbarColor,
      menuMaxHeight: 200,
      initialValue: selectedMonth,
      hint: customText(
        monst: true,
        title: widget.hint,
        color: colors.headingColor,
      ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.headingColor!),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.subTitleColor!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.subTitleColor!),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: months
          .map(
            (month) => DropdownMenuItem<String>(
              value: month,
              child: customText(
                monst: true,
                title: month,
                color: colors.headingColor,
              ),
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
