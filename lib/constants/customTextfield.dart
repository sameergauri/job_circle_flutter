// ignore_for_file: must_be_immutable, unused_local_variable, override_on_non_overriding_member, file_names, prefer_typing_uninitialized_variables, use_full_hex_values_for_flutter_colors, duplicate_ignore, collection_methods_unrelated_type, library_private_types_in_public_api, non_constant_identifier_names, unused_element
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customButton.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/job_location_model.dart';
import 'package:job_circle/models/job_title_model.dart';
import 'package:job_circle/models/matching_job_model.dart';
import 'package:job_circle/models/nature_of_work.dart';
import 'package:job_circle/models/process_model.dart';

import '../themes/colors.dart';
import 'customDialogue.dart';

int suggestionIndex = 0;

class CustomFormTextFieldMultiSelectLocation extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  List<dynamic>? selectedValuesList1 = [];
  //yfinal Function(String)? se;
  BuildContext contextIn;
  final Function(String) callback1;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool)? onChanged;
  final String name;
  final isSkill;
  final Function(String)? workType1;
  final Function(List<String>)? submit1;
  List<Location>? fetchApiskill1 = [];

  CustomFormTextFieldMultiSelectLocation({
    required this.callback1,
    this.fetchApiskill1,
    this.submit1,
    super.key,
    this.controller,
    this.workType1,
    required this.isSkill,
    // required this.isEdit,
    // required this.focusNode,
    this.selectedValuesList1,
    required this.contextIn,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.onChanged,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  State<CustomFormTextFieldMultiSelectLocation> createState() =>
      _CustomFormTextFieldMultiSelectLocationState();
}

class _CustomFormTextFieldMultiSelectLocationState
    extends State<CustomFormTextFieldMultiSelectLocation> {
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

  List<Location>? selectedValuesList = [];
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
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=10000'));

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

  /* Future<List> getJobTitle(String pattern, String name) async {    // old skills and work location working function
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['value'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      suggestionsLast = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(suggestions);

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  /* Future<List<dynamic>> fetchSuggestions(String pattern) async {
    //List<dynamic> suggestions = [];

    if (pattern.isNotEmpty) {
      suggestions = await getJobTitle(pattern, widget.name) ?? [];
      showAddButton = !suggestions.contains(pattern);
    } else {
      showAddButton = true;
    }

    return suggestions;
  } */
  @override
/*   void initState() {
    // TODO: implement initState
    super.initState();
     setState(() {
        selectedDataList = widget.fetchApiskill!;
      });
  } */
  @override
  Widget build(BuildContext context) {
    selectedValuesList = widget.fetchApiskill1!;
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.varela(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: double.infinity,
            margin: selectedValuesList!.isNotEmpty
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: 5),
            //  height: MediaQuery.of(context).size.height / 9.h,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //selectedValuesList=
                Wrap(
                    spacing: 4,
                    children: selectedValuesList!.map((e) {
                      return Chip(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        label: Text(e.value),
                        onDeleted: () {
                          setState(() {
                            selectedValuesList!.remove(e);
                            widget.fetchApiskill1!.remove(e);
                            textFieldFocusNode.requestFocus();
                            handleBoolChange(false);
                          });
                        },
                      );
                    }).toList()),

                /* SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount: selectedValuesList!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(selectedValuesList![index]),
                      );
                    },
                  ),
                ), */
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 25.h,
                            child: TypeAheadFormField<dynamic>(
                              /* validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  if (selectedValuesList!.contains(value)) {
                                    isDuplicate = true;
                                    return 'Already Added';
                                  }
                                  isDuplicate = false;
                                  return null;
                                }, */

                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                elevation: 4.0,
                              ),
                              textFieldConfiguration: TextFieldConfiguration(
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
                                      showAddButton =
                                          !suggestions.contains(value);
                                    }
                                  });
                                },

                                //enabled: false,

                                autofocus: true,
                                focusNode: textFieldFocusNode,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: hintText,
                                  hintStyle: GoogleFonts.varela(
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
                                        : null, */
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
                                  showAddButton =
                                      !suggestion!.contains(pattern);

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
                                if (selectedValuesList!
                                    .map((e) => e.value)
                                    .contains(suggestion.value)) {
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
                                } else if (suggestion.id != 786 &&
                                    suggestion.id != 787) {
                                  setState(() {
                                    Location newList = Location(
                                        id: suggestion.id,
                                        value: suggestion.value);
                                    selectedValuesList!.add(newList);
                                    isDuplicate = false;
                                    showAddButton = true;
                                    controller!.text =
                                        suggestion.value.toString();
                                    controller!.clear();
                                    widget
                                        .callback1(suggestion.value.toString());
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit1!(selectedDataList);
                                    controller!.clear();

                                    if (suggestion.id != 786 &&
                                        suggestion.value != 787) {
                                      controller!
                                          .clear(); // Clear the controller for all suggestions except "wfh" and "hybrid"
                                    }
                                  });

                                  if (selectedValuesList!
                                          .map((e) => e.value)
                                          .contains("wfh") ||
                                      selectedValuesList!
                                          .map((e) => e.value)
                                          .contains("WFH") ||
                                      selectedValuesList!
                                          .map((e) => e.value)
                                          .contains("Hybrid")) {
                                    selectedValuesList!.clear();
                                    // Perform additional operations for "wfh" or "Hybrid" values
                                    // ...
                                    handleBoolChange(true);
                                    widget.workType1!(suggestion.value);
                                    controller!.text =
                                        suggestion.value.toString();
                                    widget
                                        .callback1(suggestion.value.toString());
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit1!(selectedDataList);
                                    controller!.clear();
                                  }
                                } else {
                                  setState(() {
                                    Location newList = Location(
                                        id: suggestion.id,
                                        value: suggestion.value);
                                    selectedValuesList!.add(newList);
                                    isDuplicate = false;
                                    showAddButton = true;
                                    controller!.text =
                                        suggestion.value.toString();
                                    controller!.clear();
                                    widget
                                        .callback1(suggestion.value.toString());

                                    widget.submit1!(selectedDataList);
                                    controller!.clear();

                                    if (suggestion.id != 786 &&
                                        suggestion.value != 787) {
                                      controller!
                                          .clear(); // Clear the controller for all suggestions except "wfh" and "hybrid"
                                    }
                                  });

                                  if (selectedValuesList!
                                          .map((e) => e.value)
                                          .contains("wfh") ||
                                      selectedValuesList!
                                          .map((e) => e.value)
                                          .contains("WFH") ||
                                      selectedValuesList!
                                          .map((e) => e.value)
                                          .contains("Hybrid")) {
                                    selectedValuesList!.clear();
                                    // Perform additional operations for "wfh" or "Hybrid" values
                                    // ...
                                    handleBoolChange(true);
                                    widget.workType1!(suggestion.value);
                                    controller!.text =
                                        suggestion.value.toString();
                                    widget
                                        .callback1(suggestion.value.toString());
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit1!(selectedDataList);
                                    controller!.clear();
                                  }
                                }
                              },

                              /*  onSuggestionSelected: (suggestion) {  // working skills suggestion
                                if (selectedValuesList!
                                    .contains(suggestion.value)) {
                                  setState(() {
                                    //selectedValuesList!.add(suggestion);
                                    isDuplicate = true;
                                    controller!.clear();
                                    showAddButton = true;
                                    controller!.text =
                                        suggestion.value.toString();
                                    widget
                                        .callback(suggestion.value.toString());
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit!(selectedDataList);
                                    controller!.clear();

                                    if (selectedValuesList!.contains("wfh") ||
                                        selectedValuesList!.contains("WFH") ||
                                        selectedValuesList!
                                            .contains("Hybrid")) {
                                      handleBoolChange(true);
                                      widget.workType!(suggestion.value);
                                      controller!.text =
                                          suggestion.value.toString();
                                      widget.callback(
                                          suggestion.value.toString());
                                      selectedDataList
                                          .add(suggestion.id.toString());
                                      widget.submit!(selectedDataList);
                                      controller!.clear();
                                    }
                                    // textFieldFocusNode.requestFocus();
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                          isFisrt: false,
                                          onClose: () {
                                            Navigator.of(context).pop();
                                            textFieldFocusNode.requestFocus();
                                            controller!.clear();
                                          },
                                          title: "Error!",
                                          subtitle: widget.isSkill
                                              ? 'This skill is already added'
                                              : "This location is already added");
                                    },
                                  );
                                } else if (suggestion.value != null) {
                                  setState(() {
                                    selectedValuesList!.add(suggestion.value);
                                    isDuplicate = false;
                                    showAddButton = true;
                                    controller!.text =
                                        suggestion.value.toString();
                                    widget
                                        .callback(suggestion.value.toString());
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit!(selectedDataList);
                                    controller!.clear();
                                    if (selectedValuesList!.contains("wfh") ||
                                        selectedValuesList!.contains("WFH") ||
                                        selectedValuesList!
                                            .contains("Hybrid")) {
                                      handleBoolChange(true);
                                      /*  handleWorkType(
                                          suggestion.value.toString()); */
                                      selectedValuesList!.add(suggestion.value);
                                      controller!.text =
                                          suggestion.value.toString();
                                      widget.callback(
                                          suggestion.value.toString());
                                      selectedDataList
                                          .add(suggestion.id.toString());
                                      widget.submit!(selectedDataList);
                                      // controller!.clear();
                                    }
                                    controller!.clear();
                                    // textFieldFocusNode.requestFocus();
                                  });
                                }
                                /*  setState(() {                    //before Validation...
                                  controller!.clear();
                                  if (!selectedValuesList!.contains(suggestion)) {
                                    setState(() {
                                      selectedValuesList!.add(suggestion);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Already Added")));
                                  }
                                              
                                  //controller!.text += suggestion.toString();   // textField me show krne ke liy ke kya selected hai
                                  //  firstText = controller!.text;
                                  //  handleBoolChange(true);
                                  // FocusScope.of(context).autofocus(focusNode);  // on hold
                                }); */
                              }, */
                              /* noItemsFoundBuilder: (BuildContext context) {
                                if (isLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Searching...',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  );
                                } else {
                                  return AddButtonVisibilityWidget(
                                    isLoading: false,
                                    suggestions: suggestion,
                                    customValue: customValue,
                                    selectedValuesList: selectedValuesList,
                                    onAddButtonPressed: () {
                                      setState(() {
                                    selectedValuesList!.add(suggestion.toString());
                                    isDuplicate = false;
                                    //showAddButton = true;
                                    controller!.clear();

                                  });
                                });},
   
                              }, */

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
                                                    textFieldFocusNode
                                                        .requestFocus();
                                                  },
                                                  title: "Error!",
                                                  subtitle:
                                                      " 'This skill is already added',",
                                                );
                                              },
                                            );
                                          } else {
                                            setState(() {
                                              //  selectedValuesList!.add(customValue);
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
                              /* final message =
                                    suggestion != null && suggestion!.isEmpty
                                        ? 'No items found'
                                        : 'Searching';

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    message,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                );
                              }, */
                            ),
                          ),
                          /* Container(
                            child: Text(
                              isDuplicate ? "This Skill is already added." : "",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ), */
                        ],
                      ),
                    ),
                    /*  if (showAddButton &&
                        customValue != null &&
                        customValue!.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          if (selectedValuesList!.contains(customValue)) {
                            setState(() {
                              isDuplicate = true;
                              controller!.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Already Added")),
                            );
                          } else {
                            setState(() {
                              selectedValuesList!.add(customValue!);
                              isDuplicate = false;
                              controller!.clear();
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                      ) */
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomJobFormTextField extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  final FocusNode? focusNode;
  // List<String>? selectedValuesList = [];
  final bool isCompany;
  BuildContext contextIn;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  final String name;
  final String? pId;
  final void Function(String)? onSubmit;
  final void Function(String)? onGetResumeId;
  // final void Function(String)? onJobTitle;
  var onIDSelected;
  final Function onTapCallback;
  // final Function(FocusNode) onFocusNodeRequested;

  CustomJobFormTextField({
    super.key,
    this.controller,
    this.onSubmit,
    this.focusNode,
    this.onGetResumeId,
    required this.onTapCallback,
    //  this.onJobTitle,
    // required this.isEdit,
    // required this.focusNode,
    // this.selectedValuesList,
    required this.contextIn,
    required this.isCompany,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.pId,
    required this.onChanged,
    required this.onIDSelected,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  _CustomJobFormTextFieldState createState() => _CustomJobFormTextFieldState();
}

class _CustomJobFormTextFieldState extends State<CustomJobFormTextField> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  List<JobTitleModel> suggestions = [];
  // ignore: non_constant_identifier_names
  List<dynamic> ParentId = [];
  // FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;

  late String selectedID;

  //List<String> selectedValuesList = [];

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  InkWell customContainerSelect(bool isSelect) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          widget.focusNode!.requestFocus();

          setState(() {
            controller!.clear();
            handleBoolChange(false);
            widget.onTapCallback(controller);

            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
        child: Container(
            width: double.maxFinite,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: use_full_hex_values_for_flutter_colors
              color: isSelect ? Colors.grey.shade500 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            /* decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(18)), */
            //  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(controller!.text,
                          style: GoogleFonts.varela(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      /*   Image.asset(
                        "assets/images/cross.png",
                        height: 12,
                      ) */
                      const Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.white,
                      )
                    ],
                  )
                : Text(widget.controller!.text,
                    style: GoogleFonts.varela(fontSize: 15.sp))));
  }

  /* Future<List<Map<String, dynamic>>> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> suggestions = [];
      Set<String> uniqueNames = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String name = entry['name'].toString();
        if (name.toLowerCase().startsWith(pattern.toLowerCase()) &&
            !uniqueNames.contains(name)) {
          uniqueNames.add(name);
          JobTitleModel jobTitle = JobTitleModel.fromJson(entry);
          suggestions.add({
            'name': jobTitle.name,
            'id': jobTitle.id,
          });
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  Future<List<JobTitleModel>> getSuggestions(String pattern) async {
    // 2 min wait
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/company/v1/allClientCompany?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel> suggestions = [];
      Set<String> uniqueNames = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String name = entry['name'].toString();
        if (name.toLowerCase().startsWith(pattern.toLowerCase()) &&
            !uniqueNames.contains(name)) {
          uniqueNames.add(name);
          JobTitleModel jobTitle = JobTitleModel.fromJson(entry);
          suggestions.add(jobTitle);
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<JobTitleModel1>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100000'));

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

  /*  Future<List<JobTitleModel1>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      final suggestions = (data['resultData']['content'] as List)
          .where((e) => e['value']
              .toString()
              .toLowerCase()
              .startsWith(pattern.toLowerCase()))
          .map((e) => JobTitleModel1.fromJson(e))
          .toList();

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  /* void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(widget.focusNode);
     ab Try kr zara
      ha  ek min
    }
  } */

/*   void handleFocusNodeRequest() {
    widget.onFocusNodeRequested; // Pass the focusNode itself
  } */
  late final Function(String) onIDSelected;
  int suggestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isEdit
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                customContainerSelect(true),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 25.h,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TypeAheadFormField<dynamic>(
                    enabled: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Text field Cant be empty";
                      }
                      return null;
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 4.0,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      focusNode: widget.focusNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      onChanged: (value) {
                        suggestion = null;
                      },
                      autofocus: true,

                      // focusNode: focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: hintText,
                        hintStyle: GoogleFonts.varela(
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
                            // ignore: use_full_hex_values_for_flutter_colors
                            color: Color(0xffff0eceb),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.only(left: 15),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        suggestion = widget.isCompany
                            ? await getSuggestions(pattern)
                            : await getJobTitle(pattern, widget.name);
                        return suggestion!;
                      } else {
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
                            suggestion.name.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },

                    /* itemBuilder: (context, suggestion) {
                      final index = suggestions.indexOf(suggestion);
                      final isOdd = index % 2 == 0;
                      final backgroundColor =
                          isOdd ? Colors.grey.shade200 : Colors.white;

                      return Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            suggestion.name.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }, */
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        controller!.text = suggestion.name.toString();
                        firstText = controller!.text;
                        controller!.text = suggestion.name.toString();
                        firstText = controller!.text;
                        handleBoolChange(true);
                        var selectedId = suggestion.id;
                        // onIDSelected(suggestion.id.toString());
                        // widget.onJobTitle!(firstText.toString());
                        widget.onSubmit!(selectedId.toString());
                        var selectedResumeId = suggestion.isResumeId;
                        widget.onGetResumeId!(selectedResumeId);

                        // FocusScope.of(context).nextFocus();
                      });
                    },
                    noItemsFoundBuilder: (value) {
                      final message = suggestion != null && suggestion!.isEmpty
                          ? 'No result found. Search again and select from suggestion.'
                          : 'Searching';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomFormTextFieldMultiSelect extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  List<dynamic>? selectedValuesList = [];
  //yfinal Function(String)? se;
  BuildContext contextIn;
  final Function(String)? callback;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool)? onChanged;
  final String name;
  final isSkill;
  final Function(String)? workType;
  final Function(List<String>)? submit;
  List<dynamic>? fetchApiskill = [];
  final Function(List<dynamic>)? selectedSkillsChangeCallback;

  CustomFormTextFieldMultiSelect({
    this.callback,
    this.fetchApiskill,
    this.selectedSkillsChangeCallback,
    this.submit,
    super.key,
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
  });

  @override
  State<CustomFormTextFieldMultiSelect> createState() =>
      _CustomFormTextFieldMultiSelectState();
}

class _CustomFormTextFieldMultiSelectState
    extends State<CustomFormTextFieldMultiSelect> {
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
    // widget.onChanged!(newValue);
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

  /* Future<List> getJobTitle(String pattern, String name) async {    // old skills and work location working function
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['value'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      suggestionsLast = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(suggestions);

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  /* Future<List<dynamic>> fetchSuggestions(String pattern) async {
    //List<dynamic> suggestions = [];

    if (pattern.isNotEmpty) {
      suggestions = await getJobTitle(pattern, widget.name) ?? [];
      showAddButton = !suggestions.contains(pattern);
    } else {
      showAddButton = true;
    }

    return suggestions;
  } */
  @override
/*   void initState() {
    // TODO: implement initState
    super.initState();
     setState(() {
        selectedDataList = widget.fetchApiskill!;
      });
  } */
  @override
  Widget build(BuildContext context) {
    title == "Work Location"
        ? selectedValuesList = widget.fetchApiskill
        : selectedValuesList = widget.fetchApiskill;
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.varela(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: double.infinity,
            margin: selectedValuesList!.isNotEmpty
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: 5),
            //  height: MediaQuery.of(context).size.height / 9.h,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //selectedValuesList=
                Wrap(
                    spacing: 4,
                    children: selectedValuesList!.map((e) {
                      return Chip(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        label: Text(e),
                        onDeleted: () {
                          setState(() {
                            selectedValuesList!.remove(e);
                            widget.fetchApiskill!.remove(e);
                            textFieldFocusNode.requestFocus();
                            handleBoolChange(false);
                            widget.selectedSkillsChangeCallback!(
                                selectedValuesList!);
                          });

                          // Call the callback function to update selected skills
                        },
                        /*  onDeleted: () {
                          setState(() {
                            selectedValuesList!.remove(e);
                            widget.fetchApiskill!.remove(e);
                            textFieldFocusNode.requestFocus();
                            handleBoolChange(false);
                          });
                        }, */
                      );
                    }).toList()),

                /* SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount: selectedValuesList!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(selectedValuesList![index]),
                      );
                    },
                  ),
                ), */
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 25.h,
                            child: TypeAheadFormField<dynamic>(
                              /* validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  if (selectedValuesList!.contains(value)) {
                                    isDuplicate = true;
                                    return 'Already Added';
                                  }
                                  isDuplicate = false;
                                  return null;
                                }, */

                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                elevation: 4.0,
                              ),
                              textFieldConfiguration: TextFieldConfiguration(
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
                                      showAddButton =
                                          !suggestions.contains(value);
                                    }
                                  });
                                },
                                onSubmitted: (value) {
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
                                      selectedValuesList!.add(customValue);

                                      isDuplicate = false;
                                      controller!.clear();
                                    });
                                  }
                                },

                                //enabled: false,

                                autofocus: true,
                                focusNode: textFieldFocusNode,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: controller,
                                decoration: InputDecoration(
                                  suffixIcon: suggestion != null &&
                                          suggestion!.isEmpty &&
                                          controller!.text.isNotEmpty &&
                                          widget.isSkill
                                      ? IconButton(
                                          onPressed: () {
                                            if (selectedValuesList!
                                                .contains(customValue)) {
                                              setState(() {
                                                isDuplicate = true;
                                                controller!.clear();
                                              });
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialog(
                                                    fetchDataFromApi: () {},
                                                    isFisrt: false,
                                                    onClose: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      textFieldFocusNode
                                                          .requestFocus();
                                                    },
                                                    title: "Error!",
                                                    subtitle:
                                                        " 'This skill is already added',",
                                                  );
                                                },
                                              );
                                            } else {
                                              setState(() {
                                                selectedValuesList!
                                                    .add(customValue!);
                                                isDuplicate = false;
                                                controller!.clear();
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Constants.themeBgColor,
                                          ))
                                      : null,
                                  hintText: hintText,
                                  hintStyle: GoogleFonts.varela(
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
                                        : null, */
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                if (pattern.isNotEmpty) {
                                  isLoading =
                                      true; // Set isLoading to true when fetching suggestions
                                  /* setState(
                                      () {});  */ // Trigger a rebuild to show the "Searching" message

                                  suggestion =
                                      await getJobTitle(pattern, widget.name);
                                  showAddButton =
                                      !suggestion!.contains(pattern);

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
                                if (selectedValuesList!
                                    .contains(suggestion.value)) {
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
                                    controller!.text =
                                        suggestion.value.toString();
                                    controller!.clear();
                                    widget.selectedSkillsChangeCallback!(
                                        selectedValuesList!);
                                    /*  widget
                                        .callback(suggestion.value.toString()); */
                                    selectedDataList
                                        .add(suggestion.id.toString());
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
                                    controller!.text =
                                        suggestion.value.toString();
                                    /*  widget
                                        .callback(suggestion.value.toString()); */
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit!(selectedDataList);
                                    controller!.clear();
                                  }
                                }
                              },

                              /*  onSuggestionSelected: (suggestion) {  // working skills suggestion
                                if (selectedValuesList!
                                    .contains(suggestion.value)) {
                                  setState(() {
                                    //selectedValuesList!.add(suggestion);
                                    isDuplicate = true;
                                    controller!.clear();
                                    showAddButton = true;
                                    controller!.text =
                                        suggestion.value.toString();
                                    widget
                                        .callback(suggestion.value.toString());
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit!(selectedDataList);
                                    controller!.clear();

                                    if (selectedValuesList!.contains("wfh") ||
                                        selectedValuesList!.contains("WFH") ||
                                        selectedValuesList!
                                            .contains("Hybrid")) {
                                      handleBoolChange(true);
                                      widget.workType!(suggestion.value);
                                      controller!.text =
                                          suggestion.value.toString();
                                      widget.callback(
                                          suggestion.value.toString());
                                      selectedDataList
                                          .add(suggestion.id.toString());
                                      widget.submit!(selectedDataList);
                                      controller!.clear();
                                    }
                                    // textFieldFocusNode.requestFocus();
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                          isFisrt: false,
                                          onClose: () {
                                            Navigator.of(context).pop();
                                            textFieldFocusNode.requestFocus();
                                            controller!.clear();
                                          },
                                          title: "Error!",
                                          subtitle: widget.isSkill
                                              ? 'This skill is already added'
                                              : "This location is already added");
                                    },
                                  );
                                } else if (suggestion.value != null) {
                                  setState(() {
                                    selectedValuesList!.add(suggestion.value);
                                    isDuplicate = false;
                                    showAddButton = true;
                                    controller!.text =
                                        suggestion.value.toString();
                                    widget
                                        .callback(suggestion.value.toString());
                                    selectedDataList
                                        .add(suggestion.id.toString());
                                    widget.submit!(selectedDataList);
                                    controller!.clear();
                                    if (selectedValuesList!.contains("wfh") ||
                                        selectedValuesList!.contains("WFH") ||
                                        selectedValuesList!
                                            .contains("Hybrid")) {
                                      handleBoolChange(true);
                                      /*  handleWorkType(
                                          suggestion.value.toString()); */
                                      selectedValuesList!.add(suggestion.value);
                                      controller!.text =
                                          suggestion.value.toString();
                                      widget.callback(
                                          suggestion.value.toString());
                                      selectedDataList
                                          .add(suggestion.id.toString());
                                      widget.submit!(selectedDataList);
                                      // controller!.clear();
                                    }
                                    controller!.clear();
                                    // textFieldFocusNode.requestFocus();
                                  });
                                }
                                /*  setState(() {                    //before Validation...
                                  controller!.clear();
                                  if (!selectedValuesList!.contains(suggestion)) {
                                    setState(() {
                                      selectedValuesList!.add(suggestion);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Already Added")));
                                  }
                                              
                                  //controller!.text += suggestion.toString();   // textField me show krne ke liy ke kya selected hai
                                  //  firstText = controller!.text;
                                  //  handleBoolChange(true);
                                  // FocusScope.of(context).autofocus(focusNode);  // on hold
                                }); */
                              }, */
                              /* noItemsFoundBuilder: (BuildContext context) {
                                if (isLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Searching...',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  );
                                } else {
                                  return AddButtonVisibilityWidget(
                                    isLoading: false,
                                    suggestions: suggestion,
                                    customValue: customValue,
                                    selectedValuesList: selectedValuesList,
                                    onAddButtonPressed: () {
                                      setState(() {
                                    selectedValuesList!.add(suggestion.toString());
                                    isDuplicate = false;
                                    //showAddButton = true;
                                    controller!.clear();

                                  });
                                });},
   
                              }, */

                              noItemsFoundBuilder: (value) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    suggestion != null && suggestion!.isEmpty
                                        ? 'No result found.'
                                        : 'Searching',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                );
                              },
                              /* final message =
                                    suggestion != null && suggestion!.isEmpty
                                        ? 'No items found'
                                        : 'Searching';

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    message,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                );
                              }, */
                            ),
                          ),
                          /* Container(
                            child: Text(
                              isDuplicate ? "This Skill is already added." : "",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ), */
                        ],
                      ),
                    ),
                    /*  if (showAddButton &&
                        customValue != null &&
                        customValue!.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          if (selectedValuesList!.contains(customValue)) {
                            setState(() {
                              isDuplicate = true;
                              controller!.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Already Added")),
                            );
                          } else {
                            setState(() {
                              selectedValuesList!.add(customValue!);
                              isDuplicate = false;
                              controller!.clear();
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                      ) */
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomJobFormTextFieldRespOne extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  // List<String>? selectedValuesList = [];
  final bool isCompany;
  BuildContext contextIn;
  final bool isIndustry;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  final String name;
  final String? pId;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode;
  final String role;
  // final void Function(String)? onJobTitle;
  var onIDSelected;
  // final Function(FocusNode) onFocusNodeRequested;

  CustomJobFormTextFieldRespOne({
    super.key,
    this.controller,
    required this.isIndustry,
    this.onSubmit,
    this.focusNode,
    required this.role,
    //  this.onJobTitle,
    // required this.isEdit,
    // required this.focusNode,
    // this.selectedValuesList,
    required this.contextIn,
    required this.isCompany,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.pId,
    required this.onChanged,
    required this.onIDSelected,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  _CustomJobFormTextFieldRespoOneState createState() =>
      _CustomJobFormTextFieldRespoOneState();
}

class _CustomJobFormTextFieldRespoOneState
    extends State<CustomJobFormTextFieldRespOne> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  List<dynamic> suggestions = [];
  List<dynamic> ParentId = [];
  //FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;

  late String selectedID;

  //List<String> selectedValuesList = [];

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  InkWell customContainerSelect(bool isSelect) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          widget.focusNode?.requestFocus();

          setState(() {
            controller!.clear();
            handleBoolChange(false);
            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
        child: Container(
            width: double.maxFinite,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelect ? const Color(0xfff310d44) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            /* decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(18)), */
            //  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(controller!.text,
                          style: GoogleFonts.varela(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15.h,
                      )
                    ],
                  )
                : Text(widget.controller!.text,
                    style: GoogleFonts.varela(fontSize: 15.sp))));
  }

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['name'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<RoleModel>> getJobTitle(
      String pattern, String name, String role) async {
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://${GlobalConstants.API_Host}/jobCRPF/v1/getDistinctRolename?companyid=$name&process=$role"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<RoleModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      RoleResponseModel? roleResponseModel;
      try {
        roleResponseModel = RoleResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          RoleModel role = RoleModel.fromJson(entry);
          if (!uniqueValues.contains(role.id)) {
            uniqueValues.add(role.id);
            suggestions.add(role);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<ProcessModel>> getJobProcess(
    String pattern,
    String name,
  ) async {
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://${GlobalConstants.API_Host}/jobCRPF/v1/getDistinctProcess?companyid=$name"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<ProcessModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      ProcessResponseModel? roleResponseModel;
      try {
        roleResponseModel = ProcessResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['process']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          ProcessModel role = ProcessModel.fromJson(entry);
          if (!uniqueValues.contains(role.id)) {
            uniqueValues.add(role.id);
            suggestions.add(role);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<JobTitleModel1>> getJobIndustry(
      String pattern, String name) async {
    //old Working code of job title
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    /*   if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      final suggestions = (data['resultData']['content'] as List)
          .where((e) => e['value']
              .toString()
              .toLowerCase()
              .startsWith(pattern.toLowerCase()))
          .map((e) => JobTitleModel.fromJson(e))
          .toList();

      print(suggestions);
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    } */
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel1> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      JobTitleModel1? roleResponseModel;
      try {
        roleResponseModel = JobTitleModel1.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      //  String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['value']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          JobTitleModel1 role = JobTitleModel1.fromJson(entry);
          if (!uniqueValues.contains(role.id)) {
            uniqueValues.add(role.id!.toInt());
            suggestions.add(role);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(widget.focusNode);
     ab Try kr zara
      ha  ek min
    }
  } */

/*   void handleFocusNodeRequest() {
    widget.onFocusNodeRequested; // Pass the focusNode itself
  } */
  late final Function(String) onIDSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isEdit
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                customContainerSelect(true),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 25.h,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TypeAheadFormField<dynamic>(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Text field Cant be empty";
                      }
                      return null;
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 4.0,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      onChanged: (value) {
                        suggestion = null;
                      },
                      autofocus: true,
                      focusNode: widget.focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: GoogleFonts.varela(
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
                        contentPadding: const EdgeInsets.only(left: 15),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        if (widget.role.isNotEmpty) {
                          suggestion = widget.isIndustry
                              ? await getJobIndustry(pattern, widget.name)
                              : await getJobTitle(
                                  pattern, widget.name, widget.role);
                        } else {
                          suggestion = widget.isIndustry
                              ? await getJobIndustry(pattern, widget.name)
                              : await getJobProcess(pattern, widget.name);
                        }

                        return suggestion!;
                      } else {
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
                            widget.isIndustry
                                ? suggestion.value.toString()
                                : widget.role.isNotEmpty
                                    ? suggestion.roleName.toString()
                                    : suggestion.process.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      // widget.focusNode!.nextFocus();
                      setState(() {
                        widget.isIndustry
                            ? controller!.text = suggestion.value.toString()
                            : widget.role.isNotEmpty
                                ? controller!.text =
                                    suggestion.roleName.toString()
                                : controller!.text =
                                    suggestion.process.toString();
                        firstText = controller!.text;
                        handleBoolChange(true);
                        var selectedId = suggestion.id;
                        // onIDSelected(suggestion.id.toString());
                        // widget.onJobTitle!(firstText.toString());
                        if (widget.onSubmit != null) {
                          widget.onSubmit!(firstText.toString());
                        }

                        //FocusScope.of(context).nextFocus();
                      });
                    },
                    noItemsFoundBuilder: (value) {
                      final message = suggestion != null && suggestion!.isEmpty
                          ? 'No result found. Search again and select from suggestion.'
                          : 'Searching';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomJobFormTextFieldJobRespo extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  // List<String>? selectedValuesList = [];
  final bool isCompany;
  BuildContext contextIn;
  final String title;
  final String role;
  final String? process;
  final bool isCity;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  final String name;
  final String? pId;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode;

  // final Function(FocusNode) onFocusNodeRequested;

  CustomJobFormTextFieldJobRespo({
    super.key,
    this.controller,
    required this.role,
    this.process,
    this.onSubmit,
    this.focusNode,
    required this.isCity,

    // required this.isEdit,
    // required this.focusNode,
    // this.selectedValuesList,
    required this.contextIn,
    required this.isCompany,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.pId,
    required this.onChanged,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  _CustomJobFormTextFieldJobRespoState createState() =>
      _CustomJobFormTextFieldJobRespoState();
}

class _CustomJobFormTextFieldJobRespoState
    extends State<CustomJobFormTextFieldJobRespo> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  List<dynamic> suggestions = [];
  List<dynamic> ParentId = [];
  FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;

  late String selectedID;

  //List<String> selectedValuesList = [];

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  InkWell customContainerSelect(bool isSelect) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          widget.focusNode!.requestFocus();

          setState(() {
            controller!.clear();
            handleBoolChange(false);
            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
        child: Container(
            width: double.maxFinite,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelect ? const Color(0xfff310d44) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            /* decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(18)), */
            //  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(controller!.text,
                          style: GoogleFonts.varela(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      /* Image.asset(
                        "assets/images/cross.png",
                        height: 12,
                      ) */
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15.h,
                      )
                    ],
                  )
                : Text(widget.controller!.text,
                    style: GoogleFonts.varela(fontSize: 15.sp))));
  }

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['name'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
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

  Future<List<NatureOfWorkModel>> getJobNatureOfWork(
      String pattern, String name, String role, String process) async {
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://ec2-13-200-109-136.ap-south-1.compute.amazonaws.com:9090/jobCRPF/v1/getDistinctFunctionalArea?companyid=$name&rolename=$role&process=$process"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<NatureOfWorkModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      NatureOfWorkResponseModel? roleResponseModel;
      try {
        roleResponseModel = NatureOfWorkResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['functional_area']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          NatureOfWorkModel natureOFwork = NatureOfWorkModel.fromJson(entry);
          if (!uniqueValues.contains(natureOFwork.id)) {
            uniqueValues.add(natureOFwork.id!.toInt());
            suggestions.add(natureOFwork);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* Future<List<JobTitleModel>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      final suggestions = (data['resultData']['content'] as List)
          .where((e) => e['value']
              .toString()
              .toLowerCase()
              .startsWith(pattern.toLowerCase()))
          .map((e) => JobTitleModel.fromJson(e))
          .toList();

      print(suggestions);
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  /* void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(widget.focusNode);
     ab Try kr zara
      ha  ek min
    }
  } */

/*   void handleFocusNodeRequest() {
    widget.onFocusNodeRequested; // Pass the focusNode itself
  } */
  late final Function(String) onIDSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isEdit
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                customContainerSelect(true),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 25.h,
                  // margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TypeAheadFormField<dynamic>(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Text field Cant be empty";
                      }
                      return null;
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 4.0,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      onChanged: (value) {
                        suggestion = null;
                      },
                      autofocus: true,
                      focusNode: widget.focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: GoogleFonts.varela(
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
                        contentPadding: const EdgeInsets.only(left: 15),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        if (widget.isCity) {
                          suggestion = widget.isCompany
                              ? await getSuggestions(pattern)
                              : await getJobTitle(
                                  pattern,
                                  widget.name,
                                );
                        } else {
                          suggestion = widget.isCompany
                              ? await getSuggestions(pattern)
                              : await getJobNatureOfWork(
                                  pattern,
                                  widget.name,
                                  widget.role.toString(),
                                  widget.process.toString());
                        }

                        return suggestion!;
                      } else {
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
                            widget.isCity
                                ? suggestion.value.toString()
                                : suggestion.functional_area.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        widget.isCity
                            ? controller!.text = suggestion.value.toString()
                            : controller!.text =
                                suggestion.functional_area.toString();
                        firstText = controller!.text;
                        handleBoolChange(true);
                        var selectedId = suggestion.id;
                        // onIDSelected(suggestion.id.toString());
                        // widget.onJobTitle!(firstText.toString());
                        widget.onSubmit!(selectedId.toString());

                        //FocusScope.of(context).nextFocus();
                      });
                    },
                    noItemsFoundBuilder: (value) {
                      final message = suggestion != null && suggestion!.isEmpty
                          ? 'No result found. Search again and select from suggestion.'
                          : 'Searching';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomJobFormTextFieldRespOneProfile extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  // List<String>? selectedValuesList = [];
  final bool isCompany;
  BuildContext contextIn;
  final bool isIndustry;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  final String name;
  final String? pId;
  final void Function(String)? onSubmit;
  final void Function(String)? onCitySubmit;

  final FocusNode? focusNode;
  final String role;
  // final void Function(String)? onJobTitle;
  var onIDSelected;
  // final Function(FocusNode) onFocusNodeRequested;

  CustomJobFormTextFieldRespOneProfile({
    super.key,
    this.controller,
    required this.isIndustry,
    this.onSubmit,
    this.focusNode,
    required this.role,
    //  this.onJobTitle,
    // required this.isEdit,
    // required this.focusNode,
    // this.selectedValuesList,
    required this.contextIn,
    required this.isCompany,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.onCitySubmit,
    this.pId,
    required this.onChanged,
    required this.onIDSelected,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  _CustomJobFormTextFieldRespoOneProfileState createState() =>
      _CustomJobFormTextFieldRespoOneProfileState();
}

class _CustomJobFormTextFieldRespoOneProfileState
    extends State<CustomJobFormTextFieldRespOneProfile> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  List<dynamic> suggestions = [];
  List<dynamic> ParentId = [];
  //FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;
  String? cityname = '';

  late String selectedID;

  //List<String> selectedValuesList = [];

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.requestFocus();

    // getJobIndustry();
  }

  InkWell customContainerSelect(bool isSelect) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          //widget.focusNode?.requestFocus();

          setState(() {
            controller!.clear();
            handleBoolChange(false);
            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
        child: Container(
            width: double.maxFinite,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelect ? const Color(0xfff310d44) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            /* decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(18)), */
            //  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(controller!.text,
                          style: GoogleFonts.varela(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15.h,
                      )
                    ],
                  )
                : Text(widget.controller!.text,
                    style: GoogleFonts.varela(fontSize: 15.sp))));
  }

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['name'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<RoleModel>> getJobTitle(
      String pattern, String name, String role) async {
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://${GlobalConstants.API_Host}/jobCRPF/v1/getDistinctRolename?companyid=$name&process=$role"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<RoleModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      RoleResponseModel? roleResponseModel;
      try {
        roleResponseModel = RoleResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          RoleModel role = RoleModel.fromJson(entry);
          if (!uniqueValues.contains(role.id)) {
            uniqueValues.add(role.id);
            suggestions.add(role);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<ProcessModel>> getJobProcess(
    String pattern,
    String name,
  ) async {
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://${GlobalConstants.API_Host}/jobCRPF/v1/getDistinctProcess?companyid=$name"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<ProcessModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      ProcessResponseModel? roleResponseModel;
      try {
        roleResponseModel = ProcessResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['process']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          ProcessModel role = ProcessModel.fromJson(entry);
          if (!uniqueValues.contains(role.id)) {
            uniqueValues.add(role.id);
            suggestions.add(role);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<JobLocationModel>> getJobIndustry(
    String pattern,
  ) async {
    //old Working code of job title
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/master/v1/getByLocation?pageNumber=1&pageSize=10000'));

    /*   if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      final suggestions = (data['resultData']['content'] as List)
          .where((e) => e['value']
              .toString()
              .toLowerCase()
              .startsWith(pattern.toLowerCase()))
          .map((e) => JobTitleModel.fromJson(e))
          .toList();

      print(suggestions);
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    } */
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobLocationModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      JobTitleModel1? roleResponseModel;
      try {
        roleResponseModel = JobTitleModel1.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      //  String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = "${entry['value']?.toString()}";
        if (value.toLowerCase().startsWith(pattern.toLowerCase())) {
          JobLocationModel role = JobLocationModel.fromJson(entry);
          if (!uniqueValues.contains(role.id)) {
            uniqueValues.add(role.id!.toInt());
            suggestions.add(role);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(widget.focusNode);
     ab Try kr zara
      ha  ek min
    }
  } */

/*   void handleFocusNodeRequest() {
    widget.onFocusNodeRequested; // Pass the focusNode itself
  } */

  List<dynamic> _filterData(String query) {
    // Implement your filtering logic here based on the query
    // For demo purposes, this performs a case-insensitive filter.
    return suggestion!
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  late final Function(String) onIDSelected;

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    return SizedBox(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              context: context,
              builder: (BuildContext context) {
                return Container(
                  decoration:
                      const BoxDecoration(borderRadius: BorderRadius.only()),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  height: MediaQuery.of(context).size.height / 1.16,
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Constants.themeBgColor,
                                )),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Reside City",
                              style: GoogleFonts.varela(
                                  color: Constants.themeBgColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 24,
                              child: TypeAheadFormField<dynamic>(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This Text field Cant be empty";
                                  }
                                  return null;
                                },
                                suggestionsBoxDecoration:
                                    SuggestionsBoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  elevation: 4.0,
                                ),
                                textFieldConfiguration: TextFieldConfiguration(
                                  style: GoogleFonts.varela(
                                      color: Constants.subtitleclr),
                                  onChanged: (value) {
                                    suggestion = null;
                                  },
                                  //autofocus: true,
                                  focusNode: _focusNode,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                      color: Constants.themeBgColor,
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.house_outlined),
                                    prefixIconColor: Constants.themeBgColor,
                                    //label: Text("Reside at"),
                                    hintText: hintText,
                                    hintStyle: GoogleFonts.varela(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp,
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
                                    contentPadding:
                                        const EdgeInsets.only(left: 15),
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  if (pattern.isNotEmpty) {
                                    if (widget.role.isNotEmpty) {
                                      suggestion = widget.isIndustry
                                          ? await getJobIndustry(pattern)
                                          : await getJobTitle(pattern,
                                              widget.name, widget.role);
                                    } else {
                                      suggestion = widget.isIndustry
                                          ? await getJobIndustry(pattern)
                                          : await getJobProcess(
                                              pattern, widget.name);
                                    }

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

                                  // Increment the suggestion index counter
                                  suggestionIndex++;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        "${suggestion.value.toString()}, ${suggestion.city.toString()}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  // widget.focusNode!.nextFocus();
                                  setState(() {
                                    /* controller!.text =
                                        "${suggestion.value.toString()}, ${suggestion.city.toString()}"; */
                                    firstText = suggestion.value.toString();
                                    handleBoolChange(true);
                                    var selectedId = suggestion.id;
                                    cityname = suggestion.city.toString();

                                    widget.onSubmit!(firstText.toString());

                                    widget.onCitySubmit!(cityname.toString());
                                    Navigator.pop(context);

                                    //FocusScope.of(context).nextFocus();
                                  });
                                },
                                noItemsFoundBuilder: (value) {
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
                            /* Container(
                              height: MediaQuery.of(context).size.height / 24,
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    suggestion = _filterData(value);
                                  });
                                },
                                // enabled: isDisabled,
                                // autofocus: focusNode.canRequestFocus,
                                focusNode: widget.focusNode,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This Text field Cant be empty";
                                  }
                                  return null;
                                },
                                // maxLength: maxLength,
                                // keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
                                //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                                textCapitalization: TextCapitalization.words,
                                controller: controller,
                                onTap: (() {}),
                                style: GoogleFonts.varela(
                                    color: Constants.subtitleclr),
                                decoration: InputDecoration(
                                    // filled: isPrimaryNumber! ? true : false,

                                    // prefixIcon: icon,
                                    prefixIconColor: Constants.themeBgColor,
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    counterText: '',
                                    // labelText: label,
                                    labelStyle: TextStyle(
                                      color: Constants.themeBgColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Color(0xffff0eceb)),
                                    ),
                                    focusColor: const Color(0xffff0eceb),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                        color: Constants.themeBgColor,
                                      ),
                                    ),
                                    //hintText: hint,
                                    hintStyle: GoogleFonts.sourceSansPro(
                                        color: Constants.hintColor,
                                        fontSize: 15.sp)),
                              ),
                            ),
                            /* Align(
                              alignment: Alignment.topLeft,
                              child: Text.rich(
                                TextSpan(
                                    text: 'optional',
                                    style: GoogleFonts.varela()),
                              ),
                            ), */
                            const Divider(),
                            SizedBox(
                              height: 20.h,
                            ),
                            if (suggestion != null)
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: suggestion!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(suggestion![index]),
                                      onTap: () {
                                        // Store the selected item in 'selectedValue'
                                        setState(() {
                                          var selectedValue = suggestion![index]
                                              .value
                                              .toString();
                                        });
                                        Navigator.of(context)
                                            .pop(); // Close the bottom sheet
                                      },
                                    );
                                  },
                                ), 
                              ),*/
                          ],
                        ),
                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ThemeButton(
                              width: 100.w,
                              radious: 30,
                              themeButtonSize: ThemeButtonSize.small,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: "Cancel",
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            ThemeButton(
                              width: 100.w,
                              radious: 30,
                              themeButtonSize: ThemeButtonSize.small,
                              onPressed: () {
                                // searchAgain();
                                Navigator.pop(context);
                              },
                              text: "Submit",
                            ),
                          ],
                        ), */
                      ],
                    ),
                  ),
                );
              });
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 24,
          child: TextFormField(
            controller: controller,
            enabled: false,
            // autofocus: focusNode.canRequestFocus,
            //focusNode: focusNode,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This Text field Cant be empty";
              }
              return null;
            },

            //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
            textCapitalization: TextCapitalization.words,

            onTap: (() {}),
            style: GoogleFonts.varela(color: Constants.subtitleclr),
            decoration: InputDecoration(
                prefixIconColor: Constants.themeBgColor,
                prefixIcon: const Icon(Icons.house_outlined),
                contentPadding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 10, right: 10),
                counterText: '',
                labelText: firstText != null
                    ? "$firstText, $cityname"
                    : widget.hintText,
                labelStyle: const TextStyle(
                  color: Constants.subtitleclr,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xffff0eceb)),
                ),
                focusColor: const Color(0xffff0eceb),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: Constants.themeBgColor,
                  ),
                ),
                hintText: "Thane",
                hintStyle: GoogleFonts.sourceSansPro(
                    color: Constants.hintColor, fontSize: 15.sp)),
          ), /* TypeAheadFormField<dynamic>(
            validator: (value) {
              if (value!.isEmpty) {
                return "This Text field Cant be empty";
              }
              return null;
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(8),
              elevation: 4.0,
            ),
            textFieldConfiguration: TextFieldConfiguration(
              style: GoogleFonts.varela(color: Constants.subtitleclr),
              onChanged: (value) {
                suggestion = null;
              },
              //autofocus: true,
              //focusNode: widget.focusNode,
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Constants.themeBgColor,
                ),
                prefixIcon: Icon(Icons.pin_drop_outlined),
                prefixIconColor: Constants.themeBgColor,
                label: Text("Reside at"),
                hintText: hintText,
                hintStyle: GoogleFonts.varela(
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
                contentPadding: const EdgeInsets.only(left: 15),
              ),
            ),
            suggestionsCallback: (pattern) async {
              if (pattern.isNotEmpty) {
                if (widget.role.isNotEmpty) {
                  suggestion = widget.isIndustry
                      ? await getJobIndustry(pattern, widget.name)
                      : await getJobTitle(pattern, widget.name, widget.role);
                } else {
                  suggestion = widget.isIndustry
                      ? await getJobIndustry(pattern, widget.name)
                      : await getJobProcess(pattern, widget.name);
                }
      
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
                  title: Text(
                    "${suggestion.value.toString()}, ${suggestion.city.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            onSuggestionSelected: (suggestion) {
              // widget.focusNode!.nextFocus();
              setState(() {
                controller!.text =
                    "${suggestion.value.toString()}, ${suggestion.city.toString()}";
                firstText = suggestion.value.toString();
                handleBoolChange(true);
                var selectedId = suggestion.id;
                var cityname = suggestion.city.toString();
      
                widget.onSubmit!(firstText.toString());
      
                widget.onCitySubmit!(cityname.toString());
      
                //FocusScope.of(context).nextFocus();
              });
            },
            noItemsFoundBuilder: (value) {
              final message = suggestion != null && suggestion!.isEmpty
                  ? 'No result found. Search again and select from suggestion.'
                  : 'Searching';
      
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              );
            },
          ), */
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
///
///

class CustomJobTitleForExperience extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  // List<String>? selectedValuesList = [];
  final bool isCompany;
  BuildContext contextIn;
  final bool isIndustry;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  final Function(int) getid;
  final String name;
  final String? pId;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode;
  final String role;
  // final void Function(String)? onJobTitle;
  var onIDSelected;
  // final Function(FocusNode) onFocusNodeRequested;

  CustomJobTitleForExperience({
    super.key,
    this.controller,
    required this.isIndustry,
    this.onSubmit,
    this.focusNode,
    required this.role,
    //  this.onJobTitle,
    // required this.isEdit,
    // required this.focusNode,
    // this.selectedValuesList,
    required this.contextIn,
    required this.isCompany,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.pId,
    required this.getid,
    required this.onChanged,
    required this.onIDSelected,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  _CustomJobTitleForExperienceState createState() =>
      _CustomJobTitleForExperienceState();
}

class _CustomJobTitleForExperienceState
    extends State<CustomJobTitleForExperience> {
  @override
  void initStateComp() {
    // TODO: implement initState
    super.initState();
    /*  widget.focusNode!.addListener(() {
      setState(() {
        suggestionSelected =
            widget.focusNode!.hasFocus && controller!.text.isEmpty
                ? false
                : true;
      });
    }); */
  }

  @override
  void dispose() {
    // Don't forget to dispose of the focus node
    super.dispose();
  }

  List<dynamic>? suggestion;
  bool isEdit = false;
  List<dynamic> suggestions = [];
  bool suggestionSelected = false;

  late TextEditingController? controller = widget.controller;

  late String hintText = widget.hintText;

  Future<List<JobTitleModel1>> getJobIndustry(
      String pattern, String name) async {
    //old Working code of job title
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=10000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel1> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      JobTitleModel1? roleResponseModel;
      try {
        roleResponseModel = JobTitleModel1.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      //  String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['value']?.toString();
        String? code = entry["url_slug"]?.toString();
        if ((value != null &&
                value.toLowerCase().contains(pattern.toLowerCase())) ||
            (code != null &&
                code.toLowerCase().contains(pattern.toLowerCase()))) {
          JobTitleModel1 role = JobTitleModel1.fromJson(entry);
          if (!uniqueValues.contains(role.id)) {
            uniqueValues.add(role.id!.toInt());
            suggestions.add(role);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  late final Function(String) onIDSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 25.h,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: TypeAheadFormField<dynamic>(
          validator: (value) {
            if (value!.isEmpty) {
              return "This Text field Cant be empty";
            }
            return null;
          },
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(8),
            elevation: 4.0,
          ),
          textFieldConfiguration: TextFieldConfiguration(
            /* onTapOutside: (event) {
              setState(() {
                suggestionSelected = true;
              });
            }, */
            onSubmitted: (value) {
              setState(() {
                suggestionSelected = true;
              });
            },
            // enabled: !suggestionSelected,
            onChanged: (value) {
              suggestion = null;
            },
            autofocus: true,
            focusNode: widget.focusNode,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            style:
                GoogleFonts.varela(color: Constants.hintColor, fontSize: 14.sp),
            decoration: InputDecoration(
              label: const Text("Job Title"),
              labelStyle: GoogleFonts.varela(
                  color: Constants.themeBgColor, fontSize: 15.sp),
              prefixIcon: const Icon(
                Icons.badge_outlined,
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
                borderSide: const BorderSide(color: Constants.themeBgColor),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffff0eceb),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.only(
                left: 15,
              ),
            ),
          ),
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
            final backgroundColor = isOdd ? Colors.grey.shade200 : Colors.white;

            // Increment the suggestion index counter
            suggestionIndex++;

            return Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  widget.isIndustry
                      ? suggestion.value.toString()
                      : widget.role.isNotEmpty
                          ? suggestion.roleName.toString()
                          : suggestion.process.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          onSuggestionSelected: (suggestion) {
            // widget.focusNode!.nextFocus();
            widget.onChanged(true);
            setState(() {
              controller!.text = suggestion.value.toString();
              suggestionSelected = true;
              widget.getid(suggestion.id);
              //FocusScope.of(context).nextFocus();
            });
          },
          /* noItemsFoundBuilder: (value) {
            final message =
                suggestion != null && suggestion!.isEmpty ? '' : 'Searching';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          }, */
          noItemsFoundBuilder: (value) {
            final message = suggestion != null && suggestion!.isEmpty
                ? 'No result found. Search again and select from suggestion or add a new item.'
                : 'Searching';

            return InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                widget.onChanged(true);
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Add Designation",
                        style: GoogleFonts.varela(fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}

class CustomJobFormForUpdateCRPF extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  final FocusNode? focusNode;
  // List<String>? selectedValuesList = [];
  final bool isCompany;
  BuildContext contextIn;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  final String name;
  final String? pId;
  final void Function(String)? onSubmit;
  final void Function(String)? onGetResumeId;
  // final void Function(String)? onJobTitle;
  var onIDSelected;
  final Function onTapCallback;
  // final Function(FocusNode) onFocusNodeRequested;

  CustomJobFormForUpdateCRPF({
    super.key,
    this.controller,
    this.onSubmit,
    this.focusNode,
    this.onGetResumeId,
    required this.onTapCallback,
    //  this.onJobTitle,
    // required this.isEdit,
    // required this.focusNode,
    // this.selectedValuesList,
    required this.contextIn,
    required this.isCompany,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.pId,
    required this.onChanged,
    required this.onIDSelected,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  _CustomJobFormForUpdateCRPFState createState() =>
      _CustomJobFormForUpdateCRPFState();
}

class _CustomJobFormForUpdateCRPFState
    extends State<CustomJobFormForUpdateCRPF> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  List<JobTitleModel> suggestions = [];
  // ignore: non_constant_identifier_names
  List<dynamic> ParentId = [];
  // FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;

  late String selectedID;

  //List<String> selectedValuesList = [];

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  InkWell customContainerSelect(bool isSelect) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          widget.focusNode!.requestFocus();

          setState(() {
            controller!.clear();
            handleBoolChange(false);
            widget.onTapCallback(controller);

            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
        child: Container(
            width: double.maxFinite,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: use_full_hex_values_for_flutter_colors
              color: isSelect ? Colors.grey.shade500 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            /* decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(18)), */
            //  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(controller!.text,
                          style: GoogleFonts.varela(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      /*   Image.asset(
                        "assets/images/cross.png",
                        height: 12,
                      ) */
                      const Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.white,
                      )
                    ],
                  )
                : Text(widget.controller!.text,
                    style: GoogleFonts.varela(fontSize: 15.sp))));
  }

  /* Future<List<Map<String, dynamic>>> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> suggestions = [];
      Set<String> uniqueNames = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String name = entry['name'].toString();
        if (name.toLowerCase().startsWith(pattern.toLowerCase()) &&
            !uniqueNames.contains(name)) {
          uniqueNames.add(name);
          JobTitleModel jobTitle = JobTitleModel.fromJson(entry);
          suggestions.add({
            'name': jobTitle.name,
            'id': jobTitle.id,
          });
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  Future<List<JobTitleModel>> getSuggestions(String pattern) async {
    // 2 min wait
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/company/v1/allClientCompany?pageNumber=1&pageSize=100' //TODO: old which for all company
        'http://${GlobalConstants.API_Host_one}/jobs/v1/getDistinctCompany?page=1&size=10000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel> suggestions = [];
      Set<String> uniqueNames = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String name = entry['name'].toString();
        if (name.toLowerCase().startsWith(pattern.toLowerCase()) &&
            !uniqueNames.contains(name)) {
          uniqueNames.add(name);
          JobTitleModel jobTitle = JobTitleModel.fromJson(entry);
          suggestions.add(jobTitle);
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<JobTitleModel1>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100000'));

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

  /*  Future<List<JobTitleModel1>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      final suggestions = (data['resultData']['content'] as List)
          .where((e) => e['value']
              .toString()
              .toLowerCase()
              .startsWith(pattern.toLowerCase()))
          .map((e) => JobTitleModel1.fromJson(e))
          .toList();

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  /* void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(widget.focusNode);
     ab Try kr zara
      ha  ek min
    }
  } */

/*   void handleFocusNodeRequest() {
    widget.onFocusNodeRequested; // Pass the focusNode itself
  } */
  late final Function(String) onIDSelected;
  int suggestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isEdit
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                customContainerSelect(true),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.varela(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 25.h,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TypeAheadFormField<dynamic>(
                    enabled: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Text field Cant be empty";
                      }
                      return null;
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 4.0,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      focusNode: widget.focusNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      onChanged: (value) {
                        suggestion = null;
                      },
                      autofocus: true,

                      // focusNode: focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: hintText,
                        hintStyle: GoogleFonts.varela(
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
                            // ignore: use_full_hex_values_for_flutter_colors
                            color: Color(0xffff0eceb),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.only(left: 15),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        suggestion = widget.isCompany
                            ? await getSuggestions(pattern)
                            : await getJobTitle(pattern, widget.name);
                        return suggestion!;
                      } else {
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
                            suggestion.name.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },

                    /* itemBuilder: (context, suggestion) {
                      final index = suggestions.indexOf(suggestion);
                      final isOdd = index % 2 == 0;
                      final backgroundColor =
                          isOdd ? Colors.grey.shade200 : Colors.white;

                      return Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            suggestion.name.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }, */
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        controller!.text = suggestion.name.toString();
                        firstText = controller!.text;
                        controller!.text = suggestion.name.toString();
                        firstText = controller!.text;
                        handleBoolChange(true);
                        var selectedId = suggestion.companyid;
                        // onIDSelected(suggestion.id.toString());
                        // widget.onJobTitle!(firstText.toString());
                        widget.onSubmit!(selectedId.toString());
                        var selectedResumeId = suggestion.isResumeId;
                        widget.onGetResumeId!(selectedResumeId);

                        // FocusScope.of(context).nextFocus();
                      });
                    },
                    noItemsFoundBuilder: (value) {
                      final message = suggestion != null && suggestion!.isEmpty
                          ? 'No result found. Search again and select from suggestion.'
                          : 'Searching';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
