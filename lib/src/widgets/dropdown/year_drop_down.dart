import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class DropDownYear extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isFirst;
  final TextEditingController? firstYearController;

  const DropDownYear({
    super.key,
    required this.hint,
    required this.controller,
    required this.isFirst,
    this.firstYearController,
  });

  @override
  State<DropDownYear> createState() => _DropDownYearState();
}

class _DropDownYearState extends State<DropDownYear> {
  late List<int> years;
  late int currentYear;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year;

    int startYear =
        int.tryParse(
          widget.isFirst
              ? "1995"
              : (widget.firstYearController?.text ?? "1995"),
        ) ??
        1995;

    years = widget.isFirst
        ? List.generate(
            currentYear - startYear + 1,
            (i) => startYear + i,
          ).reversed.toList()
        : List.generate(currentYear - startYear + 1, (i) => startYear + i);

    // Agar controller me already koi value hai to usko select karo
    if (widget.controller.text.isNotEmpty) {
      final yearFromController = int.tryParse(widget.controller.text);
      if (yearFromController != null && years.contains(yearFromController)) {
        selectedYear = yearFromController;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: selectedYear,
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
          borderSide: BorderSide(color: Constants.subtitleclr),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: years
          .map(
            (year) => DropdownMenuItem<int>(
              value: year,
              child: customText(monst: true, title: year.toString()),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value;
          widget.controller.text = value.toString();
        });
      },
    );
  }
}
