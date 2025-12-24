import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class DropDownYear extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isFirst;
  // This is optional now, but good to keep for reference
  final TextEditingController? firstYearController;
  final Function(String)? onChanged;

  const DropDownYear({
    super.key,
    required this.hint,
    required this.controller,
    required this.isFirst,
    this.firstYearController,
    this.onChanged,
  });

  @override
  State<DropDownYear> createState() => _DropDownYearState();
}

class _DropDownYearState extends State<DropDownYear> {
  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    // 1. Calculate the years directly inside build
    // This ensures the list is ALWAYS fresh
    final List<int> years = _generateYears();

    // 2. Check if the currently selected year is valid
    // (e.g., if Start Year is 2018, but End Year was 2016, we must clear 2016)
    if (widget.controller.text.isNotEmpty) {
      final int? currentVal = int.tryParse(widget.controller.text);
      if (currentVal != null && years.contains(currentVal)) {
        selectedYear = currentVal;
      } else {
        // If the previously selected year is not in the new list, clear it
        selectedYear = null;
        // We delay clearing the text slightly to avoid build conflicts,
        // or we just accept it matches visually via selectedYear variable.
        // Ideally, do not clear controller text during build.
      }
    } else {
      selectedYear = null;
    }

    return DropdownButtonFormField<int>(
      menuMaxHeight: 300,
      isExpanded: true,
      // If selectedYear is not null but also not in the 'items' list, Flutter throws an error.
      // So we ensure 'value' is either valid or null.
      initialValue: (selectedYear != null && years.contains(selectedYear))
          ? selectedYear
          : null,
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
        if (widget.onChanged != null) {
          widget.onChanged!(value.toString());
        }
      },
    );
  }

  // Helper function to generate the list
  List<int> _generateYears() {
    int currentYear = DateTime.now().year;
    int startYear = 1995; // Default

    // If this is the End Year dropdown, get the Start Year from the controller
    if (!widget.isFirst && widget.firstYearController != null) {
      if (widget.firstYearController!.text.isNotEmpty) {
        startYear = int.tryParse(widget.firstYearController!.text) ?? 1995;
      }
    }

    if (widget.isFirst) {
      // Start Year Logic: Reverse order (2024, 2023...)
      return List.generate(
        currentYear - startYear + 1,
        (i) => startYear + i,
      ).reversed.toList();
    } else {
      // End Year Logic: Only years >= Start Year
      // We allow up to Current Year + 4 years into the future
      int endLimit = currentYear + 4;

      // Safety check: if start year is somehow greater than end limit
      if (startYear > endLimit) return [];

      return List.generate(
        endLimit - startYear + 1,
        (i) => startYear + i,
      ); // This list is naturally ascending (2015, 2016...)
    }
  }
}


/* import 'package:flutter/material.dart';
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
 */