// ignore_for_file: public_member_api_docs, sort_constructors_first, override_on_non_overriding_member, unused_result, no_leading_underscores_for_local_identifiers, unused_local_variable, use_full_hex_values_for_flutter_colors, non_constant_identifier_names, use_build_context_synchronously, avoid_print, use_super_parameters
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/job_post_api_service.dart';

import '../../constants/gobal.dart';
import '../../models/autocompleteCheckBoxModel.dart';
import '../../themes/colors.dart';

class LanguageMulti extends ConsumerStatefulWidget {
  final List<String> languageList;
  final int userid;

  // final bool? expirieanceFlag;
  // final List<Experience> experienceList;

  const LanguageMulti(
      {Key? key, required this.languageList, required this.userid})
      : super(key: key);
  @override
  ConsumerState<LanguageMulti> createState() => _LanguageMultiState();
}

class _LanguageMultiState extends ConsumerState<LanguageMulti> {
  late Widget previousWidget;
  bool isLoading = false;
  late TextEditingController LanguageController = TextEditingController();
  List<dynamic> fetchApiLanguages = [];
  List<dynamic> selectedValuesList = [];
  List<dynamic> selectedValues = [];
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
    LanguageController = TextEditingController();
    if (widget.languageList.isNotEmpty) {
      selectedlist = widget.languageList.toSet().toList();
      suggestions.removeWhere(
          (suggestion) => widget.languageList.contains(suggestion));
    }
    for (dynamic language in widget.languageList) {
      if (language != null) {
        selectedValues.addAll(language);
      }
    }
    /*   selectedValues.addAll(la);
    selectedValues = selectedValues.toSet().toList(); */
  }

  @override
  void initState() {
    super.initState();
    callApiFunction();
  }

 
  /* void initState() {
    super.initState();
    LanguageController = TextEditingController();
    if (widget.prevPageModel != null) {
      fetchApiLanguages = widget.prevPageModel!.languages ?? [];
      selectedValuesList = widget.prevPageModel!.skills ?? [];
      expID = widget.prevPageModel!.id;
    }
  } */

  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  List<dynamic> suggestions = [];
  List<String> selectedlist = [];
  Future<List<dynamic>> getJobTitle(
    String pattern,
  ) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=language&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // List<JobTitleModel1> suggestions = [];
      Set<String> uniqueValues = {};

      List<dynamic> content = data['resultData']['content'];

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
  }

  SnackBar customSnackbar(String title, bool error) {
    return SnackBar(
      elevation: 1.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: Constants.themeBgColorLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 8), // Remove shadow
      content: Row(
        children: [
          error
              ? Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                  size: 15.h,
                )
              : Image.asset(
                  "assets/images/check.png",
                  color: Constants.themeBgColor,
                  height: 15.h,
                ),
          /* Icon(
                  Icons.check,
                  color: Constants.themeBgColor,
                  size: 15.h,
                ),  */ // Add an icon if needed
          const SizedBox(width: 8.0), // Add spacing between icon and text
          Text(
            title,
            style: const TextStyle(
              color: Colors.black, // Text color
              fontSize: 14.0, // Text size
            ),
          ),
        ],
      ),
      // duration: const Duration(seconds: 3),
    );
  }

  void save() async {
    ProfileUpdateRequestDto profileUpdateRequestDto =
        ProfileUpdateRequestDto(id: widget.userid, languages: selectedlist);

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
    ScaffoldMessenger.of(context)
        .showSnackBar(customSnackbar("Your Language has been updated.", false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          save();
          /*  if (selectedlist.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: CustomSnackBar(title: "Add atleast one language")));
          } else {
            
          } */
        },
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Constants.borderColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const OnboardingTitle(
          title: "Edit Languages",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 10.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(
                  icon: const Icon(
                    Icons.lightbulb_outline,
                  ),
                  hint: "Type for search",
                  label: "Language",
                  focusNode: FocusNode(),
                  controller: LanguageController),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Suggestions",
                    style: GoogleFonts.varela(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Constants.black),
                  ),
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
                              color: Colors.grey.shade100,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 2.1,
                                    spreadRadius: 3.2,
                                    offset: const Offset(4.0, 8.0))
                              ],
                              borderRadius: BorderRadius.circular(8.r)),
                          child: Wrap(
                            children: suggestions.map((suggestion) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (!selectedlist.contains(suggestion)) {
                                      selectedlist.add(suggestion);
                                      suggestions.remove(suggestion);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                      bottom: 6, top: 2, left: 6, right: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.h, horizontal: 10.w),
                                  child: Text(suggestion.toString(),
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade500)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      /* Center(  //TODO : old code of language page which is use to add language.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkillSelection(
                name: "language",
                isSkill: true,
                fetchApiskill: fetchApiLanguages,
                title: "Add Language",
                controller: LanguageController,
                selectedValuesList: selectedValuesList,
                callback: updateSelectedValues,
                contextIn: context,
                hintText: "English",
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: save,
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                      color: Constants.themeBgColor,
                      borderRadius: BorderRadius.circular(15)),
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Save",
                        style: GoogleFonts.varela(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ), */
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
              getJobTitle("");
              suggestions = suggestions;
            } else {
              // Otherwise, filter suggestions based on user input
              suggestions.clear();
              getJobTitle(controller.text);
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

            prefixIconColor: Constants.themeBgColor,
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
