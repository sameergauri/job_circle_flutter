// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_result, unused_local_variable, use_full_hex_values_for_flutter_colors, non_constant_identifier_names, collection_methods_unrelated_type, use_build_context_synchronously, avoid_types_as_parameter_names, unrelated_type_equality_checks
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/job_post_api_service.dart';

import '../../constants/gobal.dart';
import '../../themes/colors.dart';

class SkillsMulti extends ConsumerStatefulWidget {
  final bool isEdit;
  // final bool? expirieanceFlag;
  final List<String> Skill;
  final List<String>? expskill;
  final int userid;
  final ExperienceRequestDto? experienceRequestDto;
  final ProfileUpdateRequestDto? profileUpdateRequestDto;
  final bool? needpop;

  const SkillsMulti(
      {super.key,
      required this.Skill,
      required this.userid,
      required this.isEdit,
      this.expskill,
      this.needpop,
      this.experienceRequestDto,
      this.profileUpdateRequestDto});
  @override
  ConsumerState<SkillsMulti> createState() => _SkillsMultiState();
}

class _SkillsMultiState extends ConsumerState<SkillsMulti> {
  late TextEditingController skillsController = TextEditingController();
  List<String> fetchApiskill = [];
  List<dynamic> selectedValuesList = [];
  List<dynamic> selectedKeySkills = [];
  List<String> selectedValues = [];

  bool isLoading = false;
  bool isMainLoading = false;

  FocusNode skillfocus = FocusNode();

  void callApiFunction() async {
    setState(() {
      isLoading = true;
    });
    await getSkills(
      "",
    );
    skillsController = TextEditingController();
    if (widget.experienceRequestDto != null) {
      selectedlist = widget.experienceRequestDto!.skillsExp?.toSet().toList();
    } else {
      selectedlist = widget.Skill.toSet().toList();
    }

    suggestions.removeWhere((suggestion) => widget.Skill.contains(suggestion));

    selectedValues.addAll(fetchApiskill);
    selectedValues = selectedValues.toSet().toList();
  }

  @override
  void initState() {
    super.initState();
    callApiFunction();
  }

  @override
  void save() async {
    if (widget.profileUpdateRequestDto != null &&
        widget.profileUpdateRequestDto != null) {
      List<String> allSkills = widget.Skill + selectedlist!;
      ProfileUpdateRequestDto updateRequestDto =
          widget.profileUpdateRequestDto!.copyWith(skills: allSkills);
      ExperienceRequestDto updateExperienceDto =
          widget.experienceRequestDto!.copyWith(skillsExp: selectedlist ?? []);
      UserUpdateRequestModel userUpdateRequestModel = UserUpdateRequestModel(
          certificationsRequestDtos: null,
          educationRequestDtos: null,
          experienceRequestDtos: [updateExperienceDto],
          profileUpdateRequestDto: updateRequestDto);
      await JobPostApiService.PostUserInfo(
        userUpdateRequestModel,
      );
      ref.refresh(ProfileDataProvider);
      Navigator.pop(context);
      Navigator.pop(context);
      if (widget.needpop != null && widget.needpop == true) {
        Navigator.pop(context);
      }
      setState(() {
        isMainLoading = false;
      });
      CustomSnackbar.show(
          widget.isEdit
              ? "Expperience Updated Succesfully"
              : "Experience Added Succesfully.",
          false);
    } else {
      ProfileUpdateRequestDto profileUpdateRequestDto =
          ProfileUpdateRequestDto(id: widget.userid, skills: selectedlist ?? []
              //bio: bio.text.trim().isEmpty ? null : bio.text,
              );

      UserUpdateRequestModel userUpdateRequestModel = UserUpdateRequestModel(
          certificationsRequestDtos: null,
          educationRequestDtos: null,
          experienceRequestDtos: null,
          profileUpdateRequestDto: profileUpdateRequestDto);

      await JobPostApiService.PostUserInfo(
        userUpdateRequestModel,
      );
      ref.refresh(ProfileDataProvider);

      Navigator.pop(context);
      setState(() {
        isMainLoading = false;
      });

      CustomSnackbar.show(
          widget.isEdit == false
              ? "Your skills set added succesfully"
              : "Your skill set has been updated.",
          false);
    }
  }

  List<String> suggestions = [];
  List<String>? selectedlist;

  Future<List<String>> getSkills(String pattern) async {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: CustomButtonForSave(
            title: "Save",
            onTap: () {
              if (selectedlist!.isEmpty) {
                CustomSnackbar.show("Add Atleast one skill to save", true);
              } else {
                setState(() {
                  isMainLoading = true;
                });
                save();
              }
            },
          ), //  backgroundColor: Constants.themeBgColorLight,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: OnboardingTitle(
              title: widget.isEdit ? "Edit Skills" : "Add Skills",
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextFieldforAll(
                      onChanged: (text) {
                        // Update the suggestions based on user input
                        setState(() {
                          if (skillsController.text.isEmpty) {
                            getSkills("");
                            suggestions = suggestions;
                          } else {
                            // Otherwise, filter suggestions based on user input
                            suggestions.clear();
                            getSkills(skillsController.text);
                            setState(() {
                              isLoading = true;
                            });
                          }
                        });
                      },
                      /*   onTabOutside: (event) {
                        FocusScope.of(context).unfocus();
                        skillsController.clear();
                        getSkills("");
                      }, */
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        skillsController.clear();
                        getSkills("");
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          // Increase maxLines when the "Enter" key is pressed

                          skillsController.clear();
                        });
                      },
                      hint: "Enter your skill that match your role",
                      focusNode: skillfocus,
                      controller: skillsController),
                  const SizedBox(
                    height: 10,
                  ),
                  if (selectedlist != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        if (selectedlist != null)
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            children: selectedlist!.toSet().map((suggestion) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (suggestions.isNotEmpty)
                        const customTextForWeather(
                          title: "Suggestions",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      SizedBox(
                        height: 5.h,
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Constants.themeBgColor,
                          ),
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
                                      if (!selectedlist!
                                          .contains(skillsController.text)) {
                                        selectedlist!
                                            .add(skillsController.text);
                                        suggestions
                                            .remove(skillsController.text);
                                        skillsController.clear();
                                        getSkills('');
                                      } else {
                                        CustomSnackbar.show(
                                            "'${skillsController.text} Already added in the list.'",
                                            true);
                                      }
                                    });
                                  })
                            ],
                          ),
                        ),
                      if (suggestions.isNotEmpty)
                        Container(
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
                            children: suggestions.take(20).map((suggestion) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (!selectedlist!.contains(suggestion)) {
                                      selectedlist!.add(suggestion);
                                      suggestions.remove(suggestion);
                                    } else {
                                      CustomSnackbar.show(
                                          "'$suggestion Already added in the list.'",
                                          true);
                                    }
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 6, top: 2, left: 6, right: 2),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
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
                      if (suggestions.isNotEmpty)
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
          ),
        ),
        if (isMainLoading)
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Blur Effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.2), // Semi-transparent overlay
                  ),
                ),
                // Circular Progress Indicator
                const CircularProgressIndicator(
                  color: Constants.darkBlue,
                ),
              ],
            ),
          ),
      ],
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
    int maxLines = 1;
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
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          controller.clear();
          getSkills("");
        },
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
          controller.clear();
          getSkills("");
        },
        onFieldSubmitted: (value) {
          setState(() {
            // Increase maxLines when the "Enter" key is pressed
            maxLines += 1;
            controller.clear();
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
              setState(() {
                isLoading = true;
              });
            }
          });
        },
        onTap: (() {}),
        style: GoogleFonts.varela(color: Constants.black, fontSize: 12.sp),
        decoration: InputDecoration(
            /*  filled: isPrimaryNumber! ? true : false,
            fillColor:
                isPrimaryNumber ? Colors.grey.shade200 : Colors.transparent, */

            contentPadding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xffff0eceb)),
            ),
            focusColor: const Color(0xffff0eceb),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Constants.black,
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.sourceSansPro(
                color: Constants.hintColor, fontSize: 12.sp)),
      ),
    );
  }
}
