import 'package:flutter/material.dart';

class CustomDatePicker {
  static Future<DateTime?> selectDate({
    required BuildContext context,
    required DateTime startDate,
    required bool isAddResume,
    required String title,
    DateTime? lastDate,
  }) async {
    DateTime today = DateTime.now();
    DateTime firstSelectableDate = isAddResume
        ? today.add(const Duration(days: 2)) // Day after tomorrow
        : today;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate.isBefore(firstSelectableDate)
          ? firstSelectableDate
          : startDate,
      firstDate: firstSelectableDate,
      lastDate: lastDate ?? DateTime(2030),
      helpText: title,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    return pickedDate;
  }
}

class CustomDateOfBirth {
  static Future<DateTime?> selectDate({
    required BuildContext context,
    required DateTime initialDate,
    required String title,
    DateTime? minDate, // For lastDate to be after startDate
    DateTime? maxDate, // For startDate to be before lastDate
    bool isStartDate = false, // Flag to restrict startDate to today or earlier
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate!,
      lastDate: maxDate!,
      helpText: title,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    return pickedDate;
  }
}

class CustomDatePickerForWorkSpace {
  static Future<DateTime?> selectDate({
    required BuildContext context,
    required DateTime initialDate,
    required String title,
    DateTime? minDate, // For lastDate to be after startDate
    DateTime? maxDate, // For startDate to be before lastDate
    bool isStartDate = false, // Flag to restrict startDate to today or earlier
  }) async {
    DateTime today = DateTime.now();
    DateTime twentyYearsAgo = today.subtract(const Duration(days: 365 * 20));

    // Set default date range
    DateTime firstDate = twentyYearsAgo;
    DateTime lastDate = isStartDate ? today : DateTime(2030);

    // Adjust firstDate and lastDate based on minDate and maxDate constraints
    if (minDate != null && minDate.isAfter(firstDate)) {
      firstDate = minDate;
    }
    if (maxDate != null && maxDate.isBefore(lastDate)) {
      lastDate = maxDate;
    }

    // Ensure initialDate is within the valid range
    DateTime validInitialDate = initialDate;
    if (initialDate.isBefore(firstDate)) {
      validInitialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      validInitialDate = lastDate;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: validInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: title,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    return pickedDate;
  }
}
