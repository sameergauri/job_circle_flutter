// ignore_for_file: must_be_immutable, unused_local_variable, library_private_types_in_public_api, use_full_hex_values_for_flutter_colors, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';

class CustomTextFieldForMasterData extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  BuildContext contextIn;
  final String title;
  final String name;
  final FocusNode? focusNode;

  CustomTextFieldForMasterData({
    super.key,
    required this.controller,
    this.focusNode,
    required this.contextIn,
    required this.title,
    required this.hintText,
    required this.name,
  });

  @override
  _CustomTextFieldForMasterDataState createState() =>
      _CustomTextFieldForMasterDataState();
}

class _CustomTextFieldForMasterDataState
    extends State<CustomTextFieldForMasterData> {
  List<dynamic>? suggestion;

  List<dynamic> suggestions = [];
  bool suggestionSelected = false;

  late TextEditingController? controller = widget.controller;

  late String hintText = widget.hintText;

  Future<List<String>> getJobIndustry(String pattern, String name) async {
    //old Working code of job title
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

  late final Function(String) onIDSelected;
  int suggestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight / 24,
      child: TypeAheadField<dynamic>(
        controller: widget.controller,
        focusNode: widget.focusNode,
        builder: (context, textEditingController, focusNode) {
          return CustomTextFieldforAll(
            isNumber: widget.name == 'pin_code' ? true : false,
            isGmail: widget.name == 'pin_code' ? true : false,
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
            maxLength: widget.name == "pin_code" ? 6 : null,
            hint: hintText,
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
          print("🔍 Searching for: $pattern"); // debug line
          if (pattern.isNotEmpty) {
            suggestion = await getJobIndustry(pattern, widget.name);
            print("✅ Suggestions: $suggestion");
            return suggestion!;
          } else {
            return <dynamic>[];
          }
        },
        itemBuilder: (context, suggestion) {
          final isOdd = suggestionIndex % 2 == 0;
          final backgroundColor = isOdd ? Colors.grey.shade200 : Colors.white;

          // Increment the suggestion index counter
          suggestionIndex++;

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: customText(
                //  monst: true,
                title: suggestion.toString(),
                fontWeight: FontWeight.bold,
                fontSize: 12,
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
                  color: Constants.lightdull,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: customText(
                    monst: true,
                    fontSize: 12,
                    title:
                        widget.name == "industry" || widget.name == "location"
                        ? 'No result found. select from suggestion.'
                        : "Add ${widget.title}",
                    fontWeight: FontWeight.w600,
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
