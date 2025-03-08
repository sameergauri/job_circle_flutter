import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

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
    "December"
  ];

  String? selectedMonth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          menuMaxHeight: 200,
          value: selectedMonth,
          hint: customTextForMonst(title: widget.hint),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Constants.black),
                borderRadius: BorderRadius.circular(8)),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Constants.subtitleclr)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Constants.subtitleclr),
                borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: months
              .map((month) => DropdownMenuItem<String>(
                    value: month,
                    child: customTextForMonst(title: month),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedMonth = value;
              widget.controller.text = value!;
            });
          },
        ),
      ],
    );
  }
}
