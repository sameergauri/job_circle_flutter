// ignore_for_file: must_be_immutable, unused_local_variable, library_private_types_in_public_api, use_full_hex_values_for_flutter_colors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';

class CustomTextFieldForSkills extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;
  final String name;
  final FocusNode? focusNode;
  final List<String> initialSkills; // New parameter for initial skills
  final Function(List<String>)
  onSkillsChanged; // Callback to return selected skills

  const CustomTextFieldForSkills({
    super.key,
    required this.controller,
    this.focusNode,
    required this.title,
    required this.hintText,
    required this.name,
    required this.initialSkills,
    required this.onSkillsChanged,
  });

  @override
  _CustomTextFieldForSkillsState createState() =>
      _CustomTextFieldForSkillsState();
}

class _CustomTextFieldForSkillsState extends State<CustomTextFieldForSkills> {
  List<dynamic>? suggestion;
  List<String> selectedSkills = [];
  bool suggestionSelected = false;
  int suggestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize selectedSkills with initialSkills (case-insensitive deduplication)
    selectedSkills = widget.initialSkills
        .map((skill) => skill.trim())
        .toSet()
        .toList(); // Remove duplicates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSkillsChanged(selectedSkills); // Notify initial skills
    });
  }

  @override
  void didUpdateWidget(CustomTextFieldForSkills oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync selectedSkills with updated initialSkills (e.g., after AI adds skills to provider)
    // Dedupe and trim for consistency
    final updatedSkills = widget.initialSkills
        .map((skill) => skill.trim())
        .toSet()
        .toList();

    // Set directly since provider is source of truth (includes user + AI skills)
    // This merges implicitly as addAll in provider preserves existing skills
    if (updatedSkills.length != selectedSkills.length ||
        !updatedSkills.every((skill) => selectedSkills.contains(skill))) {
      setState(() {
        selectedSkills = updatedSkills;
      });
      // Optionally notify parent again, but not needed since provider already updated
    }
  }

  Future<List<String>> getJobIndustry(String pattern, String name) async {
    final response = await http.post(
      Uri.parse(
        '${GlobalConstants.fetchmasterdatasuggestionurl}$name&pageNumber=1&pageSize=10000',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      List<String> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      List<dynamic> content = data['resultData']["masterData"]['content'];

      for (var entry in content) {
        String? value = entry['value']?.toString();
        String? code = entry["url_slug"]?.toString();
        if ((value != null &&
                value.toLowerCase().contains(pattern.toLowerCase())) ||
            (code != null &&
                code.toLowerCase().contains(pattern.toLowerCase()))) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value.toString());
            suggestions.add(value.toString());
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  void addSkill(String skill) {
    final normalizedSkill = skill.trim();
    if (normalizedSkill.isNotEmpty &&
        !selectedSkills.any(
          (s) => s.toLowerCase() == normalizedSkill.toLowerCase(),
        )) {
      setState(() {
        selectedSkills.add(normalizedSkill);
        suggestionSelected = true;
        widget.controller.clear();
      });
      widget.onSkillsChanged(selectedSkills); // Notify parent of updated skills
    }
  }

  void removeSkill(String skill) {
    setState(() {
      selectedSkills.removeWhere((s) => s.toLowerCase() == skill.toLowerCase());
    });
    widget.onSkillsChanged(selectedSkills); // Notify parent of updated skills
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
                  addSkill(value);
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
                  color: colors.bottomsheetbgColor,
                ),
                child: child,
              );
            },
            suggestionsCallback: (pattern) async {
              if (pattern.isNotEmpty) {
                suggestion = await getJobIndustry(pattern, widget.name);
                return suggestion!;
              } else {
                return <dynamic>[];
              }
            },
            itemBuilder: (context, suggestion) {
              final isOdd = suggestionIndex % 2 == 0;
              final backgroundColor = isOdd
                  ? colors.bottomsheerCard1Color
                  : colors.bottomsheerCard2Color;
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
                    color: colors.headingColor,
                  ),
                ),
              );
            },
            onSelected: (suggestion) {
              addSkill(suggestion.toString());
            },
            emptyBuilder: (context) {
              if (widget.controller.text.isEmpty) {
                return const SizedBox.shrink();
              }
              if (suggestion != null && suggestion!.isEmpty) {
                return InkWell(
                  onTap: () {
                    addSkill(widget.controller.text);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.bottomsheerCard1Color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: customText(
                        fontSize: 12,
                        title: "Add ${widget.controller.text}",
                        fontWeight: FontWeight.w600,
                        color: colors.headingColor,
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
                      color: colors.headingColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (selectedSkills.isNotEmpty) ...[
          const SizedBox(height: 4),
          //const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedSkills.map((skill) {
              return CustomToggleButton(
                isSelect: true,
                title: skill,
                onTap: () {
                  removeSkill(skill);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
