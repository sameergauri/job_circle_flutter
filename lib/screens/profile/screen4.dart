import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../constants/customButton.dart';
import '../../constants/customDialogue.dart';
import '../../constants/customTextfield.dart';
import '../../constants/gobal.dart';
import '../../models/job_title_model.dart';
import '../../themes/colors.dart';

class SkillSelection extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  List<dynamic>? selectedValuesList = [];
  //yfinal Function(String)? se;
  BuildContext contextIn;
  final Function(String) callback;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool)? onChanged;
  final String name;
  final isSkill;
  final Function(String)? workType;
  final Function(List<String>)? submit;
  List<dynamic>? fetchApiskill = [];

  SkillSelection({
    required this.callback,
    this.fetchApiskill,
    this.submit,
    Key? key,
    this.controller,
    this.workType,
    required this.isSkill,
    // required this.isEdit,
    // required this.focusNode,
    this.selectedValuesList,
    required this.contextIn,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.onChanged,
    this.firstText,
    // required this.onFocusNodeRequested
  }) : super(key: key);

  @override
  State<SkillSelection> createState() => _SkillSelection();
}

class _SkillSelection extends State<SkillSelection> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  bool isLoading = false;
  List<dynamic> suggestions = [];
  List<dynamic> suggestionsLast = [];
  final FocusNode textFieldFocusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;
  String? selectedValue;

  List<dynamic>? selectedValuesList = [];
  List<String> selectedDataList = [];
  bool isDuplicate = false;
  String? customValue;
  bool showAddButton = false;
  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
//selectedValuesList = widget.fetchApiskill;
    });
    widget.onChanged!(newValue);
  }

  Future<List<JobTitleModel1>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel1> suggestions = [];
      Set<String> uniqueValues = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String? value = entry['value']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            JobTitleModel1 jobTitle = JobTitleModel1.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    title == "Work Location"
        ? selectedValuesList = widget.fetchApiskill
        : selectedValuesList = widget.fetchApiskill;
    return Container(
      width: double.infinity,
      margin: selectedValuesList!.isNotEmpty
          ? EdgeInsets.zero
          : const EdgeInsets.only(top: 10),
      //  height: MediaQuery.of(context).size.height / 9.h,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //selectedValuesList=
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              selectedValuesList!.isEmpty
                                  ? const SizedBox()
                                  : Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: const Text(
                                        "Suggested based on your profile",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                              Wrap(
                                spacing: 4,
                                children: selectedValuesList!.map((e) {
                                  return Chip(
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    label: Text(e),
                                    onDeleted: () {
                                      setState(() {
                                        selectedValuesList!.remove(e);
                                        widget.fetchApiskill!.remove(e);
                                        textFieldFocusNode.requestFocus();
                                        handleBoolChange(false);
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25.h,
                      child: TypeAheadFormField<dynamic>(
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 4.0,
                        ),
                        textFieldConfiguration: TextFieldConfiguration(
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(
                                r'^\s')), // Disallow spaces at the beginning
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          maxLines: 1,
                          onChanged: (value) {
                            setState(() {
                              if (widget.isSkill) {
                                customValue = value;
                                showAddButton = !suggestions.contains(value);
                              }
                            });
                          },

                          //enabled: false,

                          /*  autofocus: true,
                          focusNode: textFieldFocusNode,
                          textCapitalization:
                              TextCapitalization.sentences,
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr,
                              fontSize: 15.sp,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 122, 113, 111),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffff0eceb),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 15),
                            /* errorText: isDuplicate
                                  ? 'This skill is already added'
                                  : null, */ */
                          autofocus: true,
                          focusNode: textFieldFocusNode,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller,
                          style: GoogleFonts.varela(
                              color: Constants.hintColor, fontSize: 14.sp),
                          decoration: InputDecoration(
                            label: const Text("Skills"),
                            labelStyle: GoogleFonts.varela(
                                color: Constants.themeBgColor, fontSize: 15.sp),
                            prefixIcon: const Icon(
                              Icons.lightbulb_outline,
                              color: Constants.themeBgColor,
                            ),
                            prefixIconColor: Constants.themeBgColor,
                            //label: Text("Reside at"),
                            hintText: hintText,
                            hintStyle: GoogleFonts.varela(
                              color: Constants.subtitleclr,
                              fontSize: 14.sp,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Constants.themeBgColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffff0eceb),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.only(left: 15),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          if (pattern.isNotEmpty) {
                            isLoading =
                                true; // Set isLoading to true when fetching suggestions
                            setState(
                                () {}); // Trigger a rebuild to show the "Searching" message

                            suggestion =
                                await getJobTitle(pattern, widget.name);
                            showAddButton = !suggestion!.contains(pattern);

                            isLoading =
                                false; // Set isLoading to false after suggestions are fetched
                            setState(
                                () {}); // Trigger a rebuild to hide the "Searching" message

                            return suggestion!;
                          } else {
                            suggestion = [];
                            showAddButton = false;
                            return <dynamic>[];
                          }
                        },
                        itemBuilder: (context, suggestion) {
                          final isOdd = suggestionIndex % 2 == 0;
                          final backgroundColor =
                              isOdd ? Colors.grey.shade200 : Colors.white;

                          // Increment the suggestion index counter
                          suggestionIndex++;

                          return Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(
                                suggestion.value.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          if (selectedValuesList!.contains(suggestion.value)) {
                            // Dialog for duplicate value
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  fetchDataFromApi: () {},
                                  isFisrt: false,
                                  onClose: () {
                                    Navigator.of(context).pop();
                                    textFieldFocusNode.requestFocus();
                                    controller!.clear();
                                  },
                                  title: "Error!",
                                  subtitle: widget.isSkill
                                      ? 'This skill is already added'
                                      : "This location is already added",
                                );
                              },
                            );
                          } else {
                            setState(() {
                              selectedValuesList!.add(suggestion.value);
                              isDuplicate = false;
                              showAddButton = true;
                              controller!.text = suggestion.value.toString();
                              controller!.clear();
                              widget.callback(suggestion.value.toString());
                              selectedDataList.add(suggestion.id.toString());
                              widget.submit!(selectedDataList);
                              controller!.clear();

                              if (suggestion.value != "WFH" &&
                                  suggestion.value != "Hybrid") {
                                controller!
                                    .clear(); // Clear the controller for all suggestions except "wfh" and "hybrid"
                              }
                            });

                            if (selectedValuesList!.contains("wfh") ||
                                selectedValuesList!.contains("WFH") ||
                                selectedValuesList!.contains("Hybrid")) {
                              // Perform additional operations for "wfh" or "Hybrid" values
                              // ...
                              handleBoolChange(true);
                              widget.workType!(suggestion.value);
                              controller!.text = suggestion.value.toString();
                              widget.callback(suggestion.value.toString());
                              selectedDataList.add(suggestion.id.toString());
                              widget.submit!(selectedDataList);
                              controller!.clear();
                            }
                          }
                        },
                        noItemsFoundBuilder: widget.isSkill
                            ? (BuildContext context) {
                                return AddButtonVisibilityWidget(
                                  suggestions: suggestion,
                                  customValue: customValue,
                                  selectedValuesList: selectedValuesList,
                                  isLoading: isLoading,
                                  onAddButtonPressed: () {
                                    if (selectedValuesList!
                                        .contains(customValue)) {
                                      setState(() {
                                        isDuplicate = true;
                                        controller!.clear();
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialog(
                                            fetchDataFromApi: () {},
                                            isFisrt: false,
                                            onClose: () {
                                              Navigator.of(context).pop();
                                              textFieldFocusNode.requestFocus();
                                            },
                                            title: "Error!",
                                            subtitle:
                                                " 'This skill is already added',",
                                          );
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        selectedValuesList!.add(customValue!);
                                        isDuplicate = false;
                                        controller!.clear();
                                      });
                                    }
                                  },
                                );
                              }
                            : (value) {
                                final message = suggestion != null &&
                                        suggestion!.isEmpty
                                    ? 'No result found. Search again and select from suggestion.'
                                    : 'Searching';

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    message,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                );
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
