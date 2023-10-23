// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/screens/onboarding/add_experience.dart';

import '../../constants/gobal.dart';
import '../../models/autocompleteCheckBoxModel.dart';
import '../../models/profileSummary.dart';
import '../../themes/colors.dart';

class AddLanguage extends StatefulWidget {
  final ProfileSummaryModel? prevPageModel;
  final List<dynamic>? languageList;

  final Map<String, dynamic> params;
  final int userID;

  // final bool? expirieanceFlag;
  // final List<Experience> experienceList;

  const AddLanguage(
      {Key? key,
      this.prevPageModel,
      this.languageList,
      required this.params,
      required this.userID})
      : super(key: key);
  @override
  State<AddLanguage> createState() => _AddLanguageState();
}

class _AddLanguageState extends State<AddLanguage> {
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
    await getJobTitle(
      "",
    );
    LanguageController = TextEditingController();
    if (widget.prevPageModel != null) {
      selectedlist = widget.prevPageModel!.languages!.toSet().toList();
      suggestions.removeWhere((suggestion) =>
          widget.prevPageModel!.languages!.contains(suggestion));
      expID = widget.prevPageModel!.id;
    }

    /*   selectedValues.addAll(la);
    selectedValues = selectedValues.toSet().toList(); */
  }

  @override
  void initState() {
    super.initState();
    callApiFunction();
  }

  @override
  void dispose() {
    LanguageController.dispose();
    super.dispose();
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

  static Future<void> updateLanguages(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl = 'http://${GlobalConstants.API_Host}/users/v1/$id/languges';

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

  List<dynamic> suggestions = [];
  List<dynamic> selectedlist = [];
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
            setState(() {});
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  void save() async {
    List<dynamic> languages = selectedlist;

    ProfileSummaryModel model = ProfileSummaryModel(
      id: widget.userID,
      languages: languages,
    );
    Map<String, dynamic> jsonData = model.toJson();
    /*  await updateLanguages(jsonData, widget.userID);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('language saved successfully')),
    ); */

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddExperience(
                  languageModel: jsonData,
                  introData: widget.params,
                  userID: widget.userID,
                )));
  }

  SnackBar customSnackbar(String title) {
    return SnackBar(
      backgroundColor:
          Colors.transparent, // Set background color to transparent
      elevation: 0, // Remove shadow
      content: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Add horizontal padding
        decoration: BoxDecoration(
          color: Colors.white, // White background
          borderRadius: BorderRadius.circular(8.0), // Border radius
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_outlined,
              color: Colors.red,
              size: 15.h,
            ), // Add an icon if needed
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
      ),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          if (selectedlist.isEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(customSnackbar("Select atleast one language."));
          } else {
            save();
          }
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
                "Next",
                style: GoogleFonts.varela(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Languages known",
              style: GoogleFonts.varela(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Let recruiter know you can communicate in multiple languages.",
                    softWrap: true,
                    maxLines: 2,
                    style: GoogleFonts.varela(
                        color: Colors.grey.shade600,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: kToolbarHeight / 6.h,
              ),
              CustomTextField(
                  icon: const Icon(
                    Icons.language_outlined,
                  ),
                  hint: "English",
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
                    Wrap(
                      children: suggestions.map((suggestion) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (!selectedlist.contains(suggestion)) {
                                selectedlist.add(suggestion);
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
