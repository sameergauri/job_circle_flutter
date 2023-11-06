// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/screens/profile/profile_summary.dart';

import '../../constants/gobal.dart';
import '../../models/profileSummary.dart';
import '../../themes/colors.dart';

class SkillsMulti extends ConsumerStatefulWidget {
  final ProfileSummaryModel? prevPageModel;

  // final bool? expirieanceFlag;
  final List<Experience> experienceList;
  final List<String> initialSkills;

  const SkillsMulti(
      {Key? key,
      required this.prevPageModel,
      required this.experienceList,
      required this.initialSkills})
      : super(key: key);
  @override
  ConsumerState<SkillsMulti> createState() => _SkillsMultiState();
}

class _SkillsMultiState extends ConsumerState<SkillsMulti> {
  late Widget previousWidget;

  late TextEditingController skillsController = TextEditingController();
  List<String> fetchApiskill = [];
  List<dynamic> selectedValuesList = [];
  List<dynamic> selectedKeySkills = [];
  List<String> selectedValues = [];
  int? expID;

  void callApiFunction() async {
    await getSkills(
      "",
    );
    skillsController = TextEditingController();
    if (widget.prevPageModel != null) {
      selectedlist = widget.prevPageModel!.skills!.toSet().toList() ?? [];
      suggestions.removeWhere(
          (suggestion) => widget.prevPageModel!.skills!.contains(suggestion));
      expID = widget.prevPageModel!.id;
    }
    for (var experience in widget.experienceList) {
      if (experience.skills_exp != null) {
        selectedValues.addAll(experience.skills_exp!);
      }
    }
    selectedValues.addAll(fetchApiskill);
    selectedValues = selectedValues.toSet().toList();
  }

  @override
  void initState() {
    super.initState();
    callApiFunction();
  }

  @override
  void dispose() {
    skillsController.dispose();
    super.dispose();
  }

  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  static Future<void> updateSkills(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl = 'http://${GlobalConstants.API_Host}/users/v1/$id';

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        // Successful request
        // print('Data posted successfully');
      } else {
        // Request failed
        // print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
    }
  }

  void save() async {
    ProfileSummaryModel model =
        ProfileSummaryModel(id: expID, skills: selectedlist);
    Map<String, dynamic> jsonData = model.toJson();
    await updateSkills(jsonData, expID!);
    ref.refresh(userDataProvider);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Skills saved successfully')),
    );
  }

  List<String> suggestions = [];
  List<String>? selectedlist;

  /*  Future<List<Skill>> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/jobs/v1/skills?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // List<JobTitleModel1> suggestions = [];
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
  } */

  Future<List<String>> getSkills(
    String pattern,
  ) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/jobs/v1/skills?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Set<String> uniqueValues = {};
      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String? value = entry['skills']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            suggestions.add(value);
            setState(() {});
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
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: save,
        child: Container(
          margin:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          decoration: BoxDecoration(
              color: Constants.themeBgColor,
              borderRadius: BorderRadius.circular(8.r)),
          width: double.maxFinite,
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Save",
                style: GoogleFonts.varela(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      //  backgroundColor: Constants.themeBgColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Skills",
              style: GoogleFonts.varela(
                fontSize: 18.sp,
                color: Constants.themeBgColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Let recruiter know your value as a potential candidate",
              style: GoogleFonts.varela(
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(
                  icon: const Icon(
                    Icons.lightbulb_outline,
                  ),
                  hint: "Advance Excel",
                  label: "Skills",
                  focusNode: FocusNode(),
                  controller: skillsController),
              const SizedBox(
                height: 10,
              ),
              if (selectedlist != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* Text(
                      "Selected Skills",
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.w500, fontSize: 16.sp),
                    ), */
                    SizedBox(
                      height: 5.h,
                    ),
                    if (selectedlist != null)
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        children: selectedlist!.map((suggestion) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (!selectedlist!.contains(suggestions)) {
                                  selectedlist!.remove(suggestion);
                                  suggestions.add(suggestion);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 2, top: 2, left: 2, right: 2),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 10.w),
                              child: Text(suggestion.toString()),
                            ),
                          );
                        }).toList(),
                      ),
                    SizedBox(
                      height: 05.h,
                    ),
                    const Divider(thickness: 0.8),
                  ],
                ),
              if (suggestions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Suggestions",
                      style: GoogleFonts.varela(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                          color: Constants.themeBgColor),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    if (selectedlist != null)
                      Wrap(
                        children: suggestions.map((suggestion) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (!selectedlist!.contains(suggestion)) {
                                  selectedlist!.add(suggestion);
                                  suggestions.remove(suggestion);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '$suggestion Already added in the list.'),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 2, top: 2, left: 2, right: 2),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 10.w),
                              child: Text(suggestion.toString()),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomTextField(
      {Icon? icon,
      required String hint,
      required String label,
      required FocusNode focusNode,
      bool? isPrimaryNumber = false,
      String? img,
      bool? isImage = false,
      int? maxLength,
      bool? isdescription,
      bool isNumber = false,
      bool? keyboardType,
      bool? isDisabled = true,
      bool? isOptional = false,
      required TextEditingController controller}) {
    int _maxLines = 1;
    // bool isError = false;
    return SizedBox(
      height: MediaQuery.of(context).size.height / 24,
      child: TextFormField(
        enabled: isDisabled,
        // autofocus: focusNode.canRequestFocus,
        focusNode: focusNode,

        /*  validator: (value) {
          if (value == null || value.isEmpty) {
            //return "This Text field Cant be empty";
          }
          return null;
        }, */
        //  maxLength: maxLength,

        maxLines: null,
        keyboardType: TextInputType.name,
        //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        onFieldSubmitted: (value) {
          setState(() {
            // Increase maxLines when the "Enter" key is pressed
            _maxLines += 1;
          });
        },

        onChanged: (text) {
          // Update the suggestions based on user input
          setState(() {
            if (controller.text.isEmpty) {
              getSkills("");
              suggestions = suggestions;
            } else {
              // Otherwise, filter suggestions based on user input
              suggestions.clear();
              getSkills(controller.text);
              setState(() {});
            }
          });
        },
        onTap: (() {}),
        style: GoogleFonts.varela(color: Constants.hintColor, fontSize: 14.sp),
        decoration: InputDecoration(
            /*  filled: isPrimaryNumber! ? true : false,
            fillColor:
                isPrimaryNumber ? Colors.grey.shade200 : Colors.transparent, */
            prefixIcon: icon,
            prefixIconColor: Constants.themeBgColor,
            suffix: isOptional != null && isOptional
                ? const Text("(Optional)")
                : const SizedBox(),
            contentPadding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            counterText: '',
            labelText: label,
            labelStyle: const TextStyle(
              color: Constants.themeBgColor,
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
            hintText: hint,
            hintStyle: GoogleFonts.sourceSansPro(
                color: Constants.hintColor, fontSize: 15.sp)),
      ),
    );
  }
}
