// ignore_for_file: public_member_api_docs, sort_constructors_first, override_on_non_overriding_member, unused_local_variable, use_super_parameters, non_constant_identifier_names, unused_element, no_leading_underscores_for_local_identifiers, use_full_hex_values_for_flutter_colors
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/models/user_data_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/onboarding/add_education.dart';

import '../../constants/gobal.dart';
import '../../models/autocompleteCheckBoxModel.dart';
import '../../models/profileSummary.dart';
import '../../themes/colors.dart';

class AddSkill extends StatefulWidget {
  final int userID;
  final UserRequest introData;
  final ExperienceRequest experience;
  final bool isExperience;
  final bool isUndergraduate;
  final ProfileSummaryModel? prevPageModel;

  // final bool? expirieanceFlag;
  // final List<Experience> experienceList;

  const AddSkill({
    Key? key,
    this.prevPageModel,
    required this.experience,
    required this.introData,
    required this.userID,
    required this.isExperience,
    required this.isUndergraduate,
  }) : super(key: key);
  @override
  State<AddSkill> createState() => _AddSkillState();
}

class _AddSkillState extends State<AddSkill> {
  bool isLoading = false;

  late Widget previousWidget;

  late TextEditingController LanguageController = TextEditingController();
  List<dynamic> fetchApiLanguages = [];
  List<dynamic> selectedValuesList = [];
  List<String> selectedValues = [];
  late List languageList = [];
  late List<AutoCompleteCheckBoxModel> languageAutoList = [];

  int? expID;

  @override
  void callApiFunction() async {
    setState(() {
      isLoading = true;
    });
    await getJobTitle(
      "",
    );
  }

  @override
  void initState() {
    super.initState();
    callApiFunction();
  }

  @override
  List<String> suggestions = [];
  List<dynamic> selectedlist = [];
  FocusNode skillnode = FocusNode();

  Future<List<String>> getJobTitle(String pattern) async {
    final response = await http.post(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/api/master/v1/getMasterDataByGroupName?groupNmae=Skills&pageNumber=1&pageSize=1000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Set<String> uniqueValues = {};

      List<dynamic> content = data['resultData']["masterData"]['content'];

      for (var entry in content) {
        String? value = entry['value']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
          }
          // Add unique values
        }
      }

      suggestions.addAll(uniqueValues); // Add all unique values at once

      setState(() {
        isLoading = false;
      });

      return suggestions.toSet().toList();
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /*  Future<List<String>> getJobTitle(
    String pattern,
  ) async {
    final response = await http.post(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/api/master/v1/getMasterDataByGroupName?groupNmae=Skills&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Set<String> uniqueValues = {};
      List<dynamic> content = data['resultData']["masterData"]['content'];

      for (var entry in content) {
        String? value = entry['value']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            suggestions.add(value);
            setState(() {
              isLoading = false;
            });
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  void save() async {
    // List<String> selectedSkillSet = selectedlist;
    List<String> selectedSkillSet =
        selectedlist.map((item) => item.toString()).toList();

    ExperienceRequest updatedExperience = widget.experience.copyWith(
      //TODO:: Add skill to experience model..
      skillsExp: selectedSkillSet,
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEducation(
                  experience: updatedExperience,
                  introData: widget.introData,
                  selectedSkillSet: selectedSkillSet,
                  // languageModel: widget.languageModel,
                  userID: widget.userID,
                  isUnderGraduate: widget.isUndergraduate,
                  isexperience: widget.isExperience,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForSave(
        title: "Next",
        onTap: () {
          if (selectedlist.isEmpty) {
            CustomSnackbar.show("Select atleast one language.", true);
          } else {
            save();
          }
        },
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Constants.borderColor,
        automaticallyImplyLeading: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Constants.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.sp, left: 10.sp, right: 10.sp),
                child: LinearProgressIndicator(
                  value: 0.501,
                  // value: _calculateProgress(, // Set progress value
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 9.9.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.sp, bottom: 10.sp),
                      child: const OnboardingTitle(
                        title: "Add Skills*",
                      ),
                    ),
                    CustomTextFieldforAll(
                      hint: "Enter your skills that match your role",
                      focusNode: skillnode,
                      controller: LanguageController,
                      /*   onTabOutside: (p0) {
                        FocusScope.of(context).unfocus();
                        LanguageController.clear();
                        getJobTitle("");
                      }, */
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        LanguageController.clear();
                        getJobTitle("");
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        LanguageController.clear();
                        getJobTitle("");
                        setState(() {
                          // Increase maxLines when the "Enter" key is pressed
                        });
                      },
                      onChanged: (text) {
                        // Update the suggestions based on user input
                        setState(() {
                          if (LanguageController.text.isEmpty) {
                            isLoading = true;
                            getJobTitle("");
                            suggestions = suggestions;
                          } else {
                            // Otherwise, filter suggestions based on user input
                            suggestions.clear();
                            getJobTitle(LanguageController.text);
                            setState(() {
                              isLoading = true;
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (selectedlist.isNotEmpty)
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
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            children: selectedlist.map((suggestion) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (!selectedlist.contains(suggestions)) {
                                      selectedlist.remove(suggestion);
                                      suggestions.add(suggestion);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 2, left: 2, right: 2),
                                  decoration: BoxDecoration(
                                      color: Constants.borderColor,
                                      borderRadius: BorderRadius.circular(8.r)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.h, horizontal: 10.w),
                                  child: customTextForWeather(
                                    title: suggestion.toString(),
                                    fontWeight: FontWeight.bold,
                                  ),
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
                    if (suggestions.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            const customTextForWeather(
                              textAlign: TextAlign.center,
                              title:
                                  "No Skills found as per your search result click 'ADD' to add this skill",
                            ),
                            CustomToggleButton(
                                title: " Add ",
                                onTap: () {
                                  setState(() {
                                    if (!selectedlist
                                        .contains(LanguageController.text)) {
                                      selectedlist.add(LanguageController.text);
                                      suggestions
                                          .remove(LanguageController.text);
                                      LanguageController.clear();
                                      getJobTitle("");
                                    } else {
                                      CustomSnackbar.show(
                                          "${LanguageController.text} Already added in the list.",
                                          true);
                                    }
                                  });
                                })
                          ],
                        ),
                      ),
                    if (suggestions.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const customTextForWeather(
                              title: "Suggestions",
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Constants.black),
                          SizedBox(
                            height: 5.h,
                          ),
                          isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Constants.themeBgColor,
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                    top: 10.h,
                                    bottom: 40.h,
                                    left: 10.w,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Constants.lightdull,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 2.1,
                                            spreadRadius: 3.2,
                                            offset: const Offset(4.0, 8.0))
                                      ],
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Wrap(
                                    children:
                                        suggestions.take(20).map((suggestion) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (!selectedlist
                                                .contains(suggestion)) {
                                              selectedlist.add(suggestion);
                                              suggestions.remove(suggestion);
                                            } else {
                                              CustomSnackbar.show(
                                                  "$suggestion Already added in the list.",
                                                  true);
                                            }
                                          });
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6,
                                                top: 2,
                                                left: 6,
                                                right: 2),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r)),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h,
                                                horizontal: 10.w),
                                            child: customTextForWeather(
                                                title: suggestion.toString(),
                                                fontWeight: FontWeight.w400,
                                                color: Constants.subtitleclr)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const customTextForWeather(
                              title:
                                  'We recommend adding your top 5 skill used in this role',
                              fontSize: 12,
                              color: Constants.subtitleclr),
                        ],
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
