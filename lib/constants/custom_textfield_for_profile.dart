import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customButton.dart';
import 'package:job_circle/constants/customDialogue.dart';
import 'package:job_circle/constants/gobal.dart';

import '../models/job_title_model.dart';
import '../models/nature_of_work.dart';
import '../themes/colors.dart';
import 'customTextfield.dart';

class CustomTextFieldComapanyLocation extends StatefulWidget {
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
  final Function(int) getid;
  final String name;
  final String? pId;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode;
  final String? labelText;
  final Icon icon;
  final bool degree;
  final bool university;
  final bool hsc;

  // final Function(FocusNode) onFocusNodeRequested;

  CustomTextFieldComapanyLocation({
    super.key,
    this.controller,
    required this.role,
    this.process,
    this.onSubmit,
    this.focusNode,
    required this.hsc,
    required this.isCity,
    required this.icon,
    required this.getid,
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
    this.labelText,
    required this.degree,
    required this.university,

    // required this.onFocusNodeRequested
  });

  @override
  _CustomTextFieldComapanyLocationState createState() =>
      _CustomTextFieldComapanyLocationState();
}

class _CustomTextFieldComapanyLocationState
    extends State<CustomTextFieldComapanyLocation> {
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
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=1000000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel1> suggestions = [];
      List uniqueValues = [];

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String? value = entry['value']?.toString();
        String? code = entry['code']?.toString();

        if (value != null &&
            value.toLowerCase().contains(pattern.toLowerCase()) &&
            !value.toLowerCase().contains("anywhere") &&
            ((widget.hsc || (code == "D001" || code == "D002")) ||
                !widget.hsc)) {
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
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=1000000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel1> suggestions = [];
      Set<String> uniqueValues = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String? value = entry['value']?.toString();
        String? code = entry['code']?.toString();
        if (value != null &&
            value.toLowerCase().contains(pattern.toLowerCase()) &&
            !value.toLowerCase().contains("anywhere")) {
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
  } */

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
    return Container(
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
          //autofocus: true,
          //focusNode: widget.focusNode,
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          style:
              GoogleFonts.varela(color: Constants.hintColor, fontSize: 14.sp),
          decoration: InputDecoration(
            label: Text(widget.labelText.toString()),
            labelStyle: GoogleFonts.varela(
                color: Constants.themeBgColor, fontSize: 15.sp),
            prefixIcon: widget.icon,
            /*  const Icon(
             widget.icon,
              color: Constants.themeBgColor,
            ), */
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
                  : await getJobNatureOfWork(pattern, widget.name,
                      widget.role.toString(), widget.process.toString());
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
                : controller!.text = suggestion.functional_area.toString();
            firstText = controller!.text;
            handleBoolChange(true);
            widget.getid(suggestion.id);
            widget.degree ? widget.onSubmit!(suggestion.code) : null;
            var selectedId = suggestion.id;
            // onIDSelected(suggestion.id.toString());
            // widget.onJobTitle!(firstText.toString());

            // widget.onSubmit??(selectedId.toString());

            //FocusScope.of(context).nextFocus();
          });
        },
        noItemsFoundBuilder: (value) {
          final message = suggestion != null && suggestion!.isEmpty
              ? 'No result found. Search again and select from suggestion or add a new item.'
              : 'Searching';

          return InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                child: Row(
                  children: [
                    Text(
                      "Add ${widget.labelText}",
                      style: GoogleFonts.varela(fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
          );
        },
        /* noItemsFoundBuilder: (value) {
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
        }, */
      ),
    );
  }
}

class CustomFormTextFieldMultiSelectForProfile extends StatefulWidget {
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
  FocusNode focusNode;
  final Function(List<dynamic>)? selectedSkillsChangeCallback;

  CustomFormTextFieldMultiSelectForProfile({
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
    required this.focusNode,
    this.getSuggestions,
    this.onChanged,
    this.firstText,
    // required this.onFocusNodeRequested
  });

  @override
  State<CustomFormTextFieldMultiSelectForProfile> createState() =>
      _CustomFormTextFieldMultiSelectForProfileState();
}

class _CustomFormTextFieldMultiSelectForProfileState
    extends State<CustomFormTextFieldMultiSelectForProfile> {
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

  Future<List<Skill>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/jobs/v1/skills?pageNumber=1&pageSize=100'

        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Skill> suggestions = [];
      Set<String> uniqueValues = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String? value = entry['skills']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            Skill skill = Skill.fromJson(entry);
            suggestions.add(skill);
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
                        deleteIconColor: Constants.themeBgColor,
                        backgroundColor: Colors.grey.shade200,
                        // side: BorderSide(color: Constants.themeBgColor),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        label: Text(
                          e,
                          style:
                              GoogleFonts.varela(color: Constants.themeBgColor),
                        ),
                        onDeleted: () {
                          if (selectedValuesList != null) {
                            setState(() {
                              selectedValuesList!.remove(e);
                              widget.fetchApiskill!.remove(e);
                              textFieldFocusNode.requestFocus();
                              handleBoolChange(false);
                              widget.selectedSkillsChangeCallback!(
                                  selectedValuesList!);
                            });
                          }

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
                SizedBox(
                  height: 2.h,
                ),

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

                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 4.0,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'^\s')), // Disallow spaces at the beginning
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

                      //autofocus: true,
                      // focusNode: textFieldFocusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      style: GoogleFonts.varela(
                          color: Constants.hintColor, fontSize: 14.sp),
                      decoration: InputDecoration(
                        label: const Text("Skills"),
                        labelStyle: GoogleFonts.varela(
                            color: Constants.themeBgColor, fontSize: 15.sp),
                        prefixIcon: const Icon(
                          Icons.star_border_outlined,
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
                          borderSide:
                              const BorderSide(color: Constants.themeBgColor),
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

                        suggestion = await getJobTitle(pattern, widget.name);
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
                            suggestion.skills.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      if (selectedValuesList!.contains(suggestion.skills)) {
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
                          selectedValuesList!.add(suggestion.skills);
                          isDuplicate = false;
                          showAddButton = true;
                          controller!.text = suggestion.skills.toString();
                          controller!.clear();
                          selectedValuesList != null
                              ? widget.selectedSkillsChangeCallback ??
                                  (selectedValuesList!)
                              : null;
                          /*  widget
                              .callback(suggestion.value.toString()); */
                          selectedDataList.add(suggestion.id.toString());
                          selectedDataList != null
                              ? widget.submit!(selectedDataList)
                              : null;
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
                          /*  widget
                              .callback(suggestion.value.toString()); */
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
                                if (selectedValuesList!.contains(customValue)) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class customCompanyforExperience extends StatefulWidget {
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
  final void Function(String)? getid;
  // final void Function()? onJobTitle;
  var onIDSelected;
  final Function onTapCallback;
  // final Function(FocusNode) onFocusNodeRequested;

  customCompanyforExperience({
    super.key,
    this.controller,
    this.onSubmit,
    this.focusNode,
    this.onGetResumeId,
    this.getid,
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
  _customCompanyforExperienceState createState() =>
      _customCompanyforExperienceState();
}

class _customCompanyforExperienceState
    extends State<customCompanyforExperience> {
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

  bool suggestionSelected = false;

  //List<String> selectedValuesList = [];

  Future<List<JobTitleModel>> getSuggestions(String pattern) async {
    // 2 min wait
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/company/v1/all?pageNumber=1&pageSize=100'));

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

  @override
  void initState() {
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
    //  widget.focusNode!.dispose(); // Don't forget to dispose of the focus node
    super.dispose();
  }

  late final Function(String) onIDSelected;
  int suggestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // enabled: !suggestionSelected,
          focusNode: widget.focusNode,
          /* onTapOutside: (event) {
            setState(() {
              suggestionSelected = true;
            });
          },
          onSubmitted: (value) {
            setState(() {
              suggestionSelected = true;
            });
          },

          onChanged: (value) {
            suggestion = null;
          }, */
          // autofocus: true,

          // focusNode: focusNode,
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          style:
              GoogleFonts.varela(color: Constants.hintColor, fontSize: 14.sp),
          decoration: InputDecoration(
            label: const Text("Company"),
            labelStyle: GoogleFonts.varela(
                color: Constants.themeBgColor, fontSize: 15.sp),
            prefixIcon: const Icon(
              Icons.domain_add_outlined,
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
            contentPadding: const EdgeInsets.only(left: 15),
          ),
        ),
        suggestionsCallback: (pattern) async {
          if (pattern.isNotEmpty) {
            suggestion = await getSuggestions(pattern);
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
            widget.onChanged(true);
            controller!.text = suggestion.name.toString();
            widget.getid!(suggestion.id);
            suggestionSelected = true;
            widget.onSubmit!(suggestion.id);
          });
        },
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
                      "Add Company",
                      style: GoogleFonts.varela(fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
          );
        },
        /*  noItemsFoundBuilder: (value) {
          /* if (controller!.text.isNotEmpty) {
            return AddButtonVisibilityWidgetExperience(
              suggestions: suggestion,
              onAddButtonPressed: () {
                setState(() {
                  controller!.text = controller!.text;
                  FocusScope.of(context).requestFocus(FocusNode());
                });
              },
            );
          } else {
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
          } */
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
      ),
    );
  }
}
