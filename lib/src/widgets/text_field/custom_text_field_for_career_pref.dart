// ignore_for_file: must_be_immutable, unused_local_variable, library_private_types_in_public_api, use_full_hex_values_for_flutter_colors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';

class CustomTextFieldForCareerPreference extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;
  final PrefTextFieldType name;
  final FocusNode focusNode;
  final List<String> initialList; // New parameter for initial skills
  final Function(List<String>)
  onListChnaged; // Callback to return selected skills

  const CustomTextFieldForCareerPreference({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.title,
    required this.hintText,
    required this.name,
    required this.initialList,
    required this.onListChnaged,
  });

  @override
  _CustomTextFieldForCareerPreferenceState createState() =>
      _CustomTextFieldForCareerPreferenceState();
}

class _CustomTextFieldForCareerPreferenceState
    extends State<CustomTextFieldForCareerPreference> {
  List<dynamic>? suggestion;
  List<String> selectedList = [];
  bool suggestionSelected = false;
  int suggestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize selectedSkills with initialSkills (case-insensitive deduplication)
    selectedList = widget.initialList
        .map((item) => item.trim())
        .toSet()
        .toList(); // Remove duplicates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onListChnaged(selectedList); // Notify initial skills
    });
  }

  @override
  void didUpdateWidget(CustomTextFieldForCareerPreference oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync selectedSkills with updated initialSkills (e.g., after AI adds skills to provider)
    // Dedupe and trim for consistency
    final updatedList = widget.initialList
        .map((item) => item.trim())
        .toSet()
        .toList();

    // Set directly since provider is source of truth (includes user + AI skills)
    // This merges implicitly as addAll in provider preserves existing skills
    if (updatedList.length != selectedList.length ||
        !updatedList.every((item) => selectedList.contains(item))) {
      setState(() {
        selectedList = updatedList;
      });
      // Optionally notify parent again, but not needed since provider already updated
    }
  }

  Future<List<String>> getData(String pattern, PrefTextFieldType name) async {
    final response = await http.get(
      Uri.parse(
        name == PrefTextFieldType.Industry
            ? GlobalConstants.getIndustry
            : name == PrefTextFieldType.JobRole
            ? GlobalConstants.getJobrole
            : name == PrefTextFieldType.Location
            ? GlobalConstants.getLocation
            : name == PrefTextFieldType.WorkMode
            ? GlobalConstants.getWorkMode
            : name == PrefTextFieldType.ShiftTime
            ? GlobalConstants.getShiftTime
            : "",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      List<String> uniqueValues = [];

      List<String> content;
      try {
        // Ensure data is a List and convert each entry to String
        content = (data as List).map((e) => e.toString()).toList();
      } catch (e) {
        throw Exception('Failed to parse response data as List<String>');
      }

      for (var entry in content) {
        String value = entry.toString();
        String code = entry.toString();
        if ((value.toLowerCase().contains(pattern.toLowerCase())) ||
            (code.toLowerCase().contains(pattern.toLowerCase()))) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            suggestions.add(value);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  void addItem(String item) {
    final normalizedList = item.trim();
    if (normalizedList.isNotEmpty &&
        !selectedList.any(
          (s) => s.toLowerCase() == normalizedList.toLowerCase(),
        )) {
      setState(() {
        selectedList.add(normalizedList);
        suggestionSelected = true;
        widget.controller.clear();
      });
      widget.onListChnaged(selectedList); // Notify parent of updated skills
    }
  }

  void removeItem(String item) {
    setState(() {
      selectedList.removeWhere((s) => s.toLowerCase() == item.toLowerCase());
    });
    widget.onListChnaged(selectedList); // Notify parent of updated skills
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight / 24,
          child: TypeAheadField<dynamic>(
            controller: widget.controller,
            focusNode: widget.focusNode,
            builder: (context, textEditingController, focusNode) {
              return CustomTextFieldforAll(
                controller: widget.controller,
                focusNode: focusNode,
                onFieldSubmitted: (value) {
                  addItem(value);
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  suggestion = null;
                  setState(() {
                    suggestionSelected = false;
                  });
                },
                maxLength: 20,
                hint: widget.hintText,
              );
            },
            decorationBuilder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Constants.white,
                ),
                child: child,
              );
            },
            suggestionsCallback: (pattern) async {
              if (pattern.isNotEmpty) {
                suggestion = await getData(pattern, widget.name);
                return suggestion!;
              } else {
                return <dynamic>[];
              }
            },
            itemBuilder: (context, suggestion) {
              final isOdd = suggestionIndex % 2 == 0;
              final backgroundColor = isOdd
                  ? Colors.grey.shade200
                  : Colors.white;
              suggestionIndex++;
              return Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: customText(
                    title: suggestion.toString(),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
            onSelected: (suggestion) {
              addItem(suggestion.toString());
              FocusScope.of(context).unfocus();
            },
            emptyBuilder: (context) {
              if (widget.controller.text.isEmpty) {
                return const SizedBox.shrink();
              }
              if (suggestion != null && suggestion!.isEmpty) {
                return InkWell(
                  onTap: () {
                    widget.controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    //addItem(widget.controller.text);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Constants.lightdull,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: customText(
                        fontSize: 12,
                        title: "No matches found",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customText(
                      fontSize: 12,
                      title: "Searching...",
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (selectedList.isNotEmpty) ...[
          const SizedBox(height: 4),
          //const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedList.map((item) {
              return CustomToggleButton(
                isSelect: true,
                title: item,
                onTap: () {
                  removeItem(item);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
