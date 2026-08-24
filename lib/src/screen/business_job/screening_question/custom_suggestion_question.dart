// ignore_for_file: avoid_print, must_be_immutable, unused_local_variable, library_private_types_in_public_api, use_full_hex_values_for_flutter_colors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';

class CustomSuggestionForQuestions extends StatefulWidget {
  final TextEditingController controller;
  BuildContext contextIn;
  final FocusNode? focusNode;
  final bool isDisabled;

  CustomSuggestionForQuestions({
    super.key,
    required this.controller,
    this.focusNode,
    required this.contextIn,
    required this.isDisabled,
  });

  @override
  _CustomSuggestionForQuestionsState createState() =>
      _CustomSuggestionForQuestionsState();
}

class _CustomSuggestionForQuestionsState
    extends State<CustomSuggestionForQuestions> {
  List<dynamic>? suggestion;

  List<dynamic> suggestions = [];
  bool suggestionSelected = false;

  late TextEditingController? controller = widget.controller;

  @override
  void initState() {
    super.initState();
    // TypeAheadField v5 clears the external controller on init.
    // Save the pre-set text (e.g. in edit mode) and restore it after the first frame.
    final savedText = widget.controller.text;
    if (savedText.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.controller.text.isEmpty) {
          widget.controller.text = savedText;
        }
      });
    }
  }

  Future<List<String>> getJobIndustry(String pattern) async {
    final response = await http.get(
      Uri.parse(GlobalConstants.questionfetchforsuggestion),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];

      // Verify that resultData and questions list exist in the response
      if (data['resultData'] != null &&
          data['resultData']['questions'] != null) {
        List<dynamic> questionsList = data['resultData']['questions'];

        for (var entry in questionsList) {
          // Extract the target key "questionText"
          String? questionText = entry['questionText']?.toString();

          if (questionText != null) {
            // Filter out matching text using the case-insensitive pattern
            if (questionText.toLowerCase().contains(pattern.toLowerCase())) {
              // Avoid adding duplicates to the list
              if (!suggestions.contains(questionText)) {
                suggestions.add(questionText);
              }
            }
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  late final Function(String) onIDSelected;
  int suggestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight / 24,
      child: TypeAheadField<dynamic>(
        controller: widget.controller,
        focusNode: widget.focusNode,
        builder: (context, textEditingController, focusNode) {
          return CustomTextFieldforAll(
            isDisabled: widget.isDisabled,
            controller: widget.controller, // ✅ yeh change karein
            focusNode: focusNode, // focus node fallback
            onFieldSubmitted: (value) {
              setState(() {
                suggestionSelected = true;
              });
            },
            onChanged: (value) {
              suggestion = null;
            },
            hint: "Type to get suggestions",
          );
        },
        decorationBuilder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colors.bgColor,
            ),
            child: child,
          );
        },
        suggestionsCallback: (pattern) async {
          print("🔍 Searching for: $pattern"); // debug line
          if (pattern.isNotEmpty) {
            suggestion = await getJobIndustry(pattern);
            print("✅ Suggestions: $suggestion");
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

          // Increment the suggestion index counter
          suggestionIndex++;

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: customText(
                //  monst: true,
                title: suggestion.toString(),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: colors.headingColor,
              ),
            ),
          );
        },
        onSelected: (suggestion) {
          setState(() {
            controller!.text = suggestion.toString();
            suggestionSelected = true;
          });
          // ✅ TextField ka focus chhod do
          FocusScope.of(context).unfocus();
        },
        emptyBuilder: (context) {
          // ✅ Case 1: Agar user ne kuch bhi type nahi kiya
          if (widget.controller.text.isEmpty) {
            return const SizedBox.shrink();
          }

          // ✅ Case 2: Agar suggestion empty hai to "Add {title}" dikhao
          if (suggestion != null && suggestion!.isEmpty) {
            return InkWell(
              onTap: () {
                setState(() {
                  suggestionSelected = true;
                });
                FocusManager.instance.primaryFocus?.unfocus(); // ✅ yeh lagao
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colors.bottomsheetbgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: customText(
                    monst: true,
                    fontSize: 12,
                    title: "Add Question",
                    fontWeight: FontWeight.w600,
                    color: colors.subTitleColor,
                  ),
                ),
              ),
            );
          }

          // ✅ Case 3: Jab searching ho rahi hai aur abhi result nahi aaya
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                customText(
                  monst: true,
                  fontSize: 12,
                  title: "Searching...",
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
