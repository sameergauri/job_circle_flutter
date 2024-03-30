// ignore_for_file: unused_result, prefer_typing_uninitialized_variables, unused_element, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, non_constant_identifier_names, use_full_hex_values_for_flutter_colors
// ignore_for_file: todo
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/custom_textfield_for_profile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';

import 'package:job_circle/screens/onboarding/add_cv.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../models/autocompleteModel.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';

class AddEducation extends ConsumerStatefulWidget {
  final int userID;
  final Map<String, dynamic> languageModel;
  final Map<String, dynamic> introData;
  final Experience experience;
  final bool isexperience;
  final int? jobtitleid;
  const AddEducation({
    required this.experience,
    required this.introData,
    required this.languageModel,
    required this.userID,
    required this.isexperience,
    required this.jobtitleid,
    super.key,
  });

  @override
  ConsumerState<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends ConsumerState<AddEducation> {
  late Widget previousWidget;
  //controller
  late TextEditingController educationController = TextEditingController();
  late TextEditingController firstYearController = TextEditingController();
  late TextEditingController passingYearController = TextEditingController();
  late TextEditingController universityController = TextEditingController();
  late TextEditingController degreeController = TextEditingController();
  late TextEditingController fieldOfStudyController = TextEditingController();
  late TextEditingController boardController = TextEditingController();
  int? eduID;

  int? userID;
  bool isSkip = false;
  bool isBoard = false;
  bool isHscPassing = false;
  bool isGraduateUni = false;
  bool isGraduateDeg = false;
  bool isGraduatefield = false;
  bool isGraduateFirst = false;
  bool isGraduatePassing = false;
  bool isPostUni = false;
  bool isPostDeg = false;
  bool isPostfield = false;
  bool isPostFirst = false;
  bool isPostPassing = false;
  bool isMbaUni = false;
  bool isMbaDeg = false;
  bool isMbafield = false;
  bool isMbaFirst = false;
  bool isMbaPassing = false;
  bool isOtherUni = false;
  bool isOtherDeg = false;
  bool isOtherfield = false;
  bool isOtherFirst = false;
  bool isOtherPassing = false;
  FocusNode uniGFocus = FocusNode();
  FocusNode dgreeGFocus = FocusNode();
  FocusNode uniPFocus = FocusNode();
  FocusNode degreePFocus = FocusNode();
  FocusNode uniMFocus = FocusNode();
  FocusNode degreeMFocus = FocusNode();
  FocusNode uniOFocus = FocusNode();
  FocusNode degreeOFocus = FocusNode();

  //drop down
  var ddlValues;
  late List<AutoCompleteModel> levelOfEducationList = [];
  late List<AutoCompleteModel> universityInstitueList = [];
  late List<AutoCompleteModel> degreeList = [];
  AutoCompleteModel selectedEducation = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedUniversity = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedDegree = AutoCompleteModel("", "", {});
  ProfileSummaryModel profilemodel = ProfileSummaryModel();

  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().getUserDetails(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      var userData = dataResult["users"];

      profilemodel = ProfileSummaryModel.fromJson(userData);
    }
    setState(() {});
  }

  @override
  initState() {
    super.initState();
  }

  bindLevelOfEducation() async {
    var result = await MasterService().masterGetByGroup({
      'groupName': 'level_education',
      'pageNumber': '1',
      'pageSize': '1000'
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      levelOfEducationList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        //selectedEducation = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindUniversityEducation() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'university', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      universityInstitueList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedUniversity = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindDegree() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'degree', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      degreeList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedDegree = AutoCompleteModel("0", "", {});
      });
    }
  }

  bool graduate = false,
      other = false,
      undergraduate = false,
      hsc = false,
      mba = false,
      sem1 = false,
      sem2 = false,
      sem3 = false,
      sem4 = false,
      sem5 = false,
      sem6 = false,
      isUniG = false,
      isDegreeG = false,
      isUniP = false,
      isDegreeP = false,
      isUniM = false,
      isDegreeM = false,
      isUniO = false,
      isDegreeO = false;

  FilePickerResult? result;
  void _showFilesinDir({required Directory dir}) {
    dir
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      print(entity.path);
    });
  }

  Future<String?> customFilePicker(
    allowExt,
  ) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile("marksheet", result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          print(filename);
          print("Filename: $filePath");

          // Close the loading dialog when the upload is successful
          Navigator.pop(context);
          //save(filename, data);

          return filename;
        } else {
          // Close the loading dialog when there is an error
          Navigator.pop(context);

          // Handle the case where the server returns an error
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error while uploading cv"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
          return null;
        }
      } catch (e) {
        // Close the loading dialog in case of exceptions
        Navigator.pop(context);

        // Handle any exceptions that occur during the upload
        print("Error during file upload: $e");
        return null;
      }
    } else {
      // Close the loading dialog when the user cancels file selection
      Navigator.pop(context);

      // Handle the case where the user cancels file selection
      return null;
    }
  }

  /*  customFilePicker() async { //TODO: old code to upload the file
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      setState(() {
        ListView.builder(
            shrinkWrap: true,
            itemCount: result?.files.length ?? 0,
            itemBuilder: (context, index) {
              return Text(result?.files[index].name ?? '',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold));
            });
      });
    } else {
      print("No file selected");
    }
  }
 */

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
        child: Expanded(
          child: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
                size: 15.h,
              ), // Add an icon if needed
              const SizedBox(width: 8.0), // Add spacing between icon and text
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 14.0, // Text size
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox(),
        Scaffold(
            floatingActionButton: isgraduate ||
                    isundergradute && (degreeController.text.isEmpty)
                ? Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (isgraduate == false &&
                                isundergradute == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(customSnackbar(
                                "Select atleast one option garduate or under-gradute",
                              ));
                            } else {
                              var payload = {
                                "stage": "education",
                                "data": {
                                  "id": await Utils.getPreferencesValue(
                                      null, ESharedPreferences.user_id.name),
                                  "education": isgraduate ? 1 : 0,
                                }
                              };
                              await saveEducation(payload);

                              save(true);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.h, horizontal: 8.r),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border:
                                    Border.all(color: Constants.themeBgColor)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15.h,
                                  color: Constants.themeBgColor,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  "Skip",
                                  style: GoogleFonts.varela(
                                      color: Constants.themeBgColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
            bottomNavigationBar: isgraduate || isundergradute
                ? GestureDetector(
                    onTap: () async {
                      if (isgraduate == false && isundergradute == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title:
                                    "Select one option from graduate and under-graduate.",
                                error: true));
                      } else if (boardController.text.isEmpty &&
                          isundergradute) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Select or add board", error: true));
                      } else if (degreeController.text.isEmpty &&
                          !isundergradute) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: !isundergradute
                                    ? "Select or add Degree."
                                    : "Select or add board",
                                error: true));
                      } else if (universityController.text.isEmpty &&
                          !isundergradute) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Select or add University.",
                                error: true));
                      } else if (fieldOfStudyController.text.isEmpty &&
                          !isundergradute) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Provide field of study.", error: true));
                      } else if (firstYearController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: !isundergradute
                                    ? "Provide first year."
                                    : "Year of passing missing.",
                                error: true));
                      } /*  else if (passingYearController.text.length != 4 &&
                          degreeCode != "D001") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Add Proper year in final year",
                                error: true));
                      } */
                      else if (firstYearController.text.length != 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Add Proper year in first year",
                                error: true));
                      } else if (passingYearController.text.isEmpty &&
                          !isundergradute) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Provide final year.", error: true));
                      } else if (passingYearController.text.length != 4 &&
                          !isundergradute) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Provide Proper final year.",
                                error: true));
                      } else {
                        var payload = {
                          "stage": "education",
                          "data": {
                            "id": await Utils.getPreferencesValue(
                                null, ESharedPreferences.user_id.name),
                            "education": isgraduate ? 1 : 0,
                          }
                        };
                        await saveEducation(payload);
                        save(false);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      decoration: BoxDecoration(
                          color: Constants.themeBgColor,
                          borderRadius: BorderRadius.circular(8.r)),
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Submit",
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Level of Education",
                          style: GoogleFonts.varela(
                            fontSize: 18.sp,
                            color: Constants.themeBgColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Let recruiter know your value as a potential",
                          style: GoogleFonts.varela(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              /*  actions: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (isgraduate == false && isundergradute == false) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(customSnackbar(
                              "Select atleast one option garduate or under-gradute",
                            ));
                          } else {
                            var payload = {
                              "stage": "education",
                              "data": {
                                "id": await Utils.getPreferencesValue(
                                    null, ESharedPreferences.user_id.name),
                                "education": isgraduate ? 1 : 0,
                              }
                            };
                            await saveEducation(payload);

                            save(true);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.r),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border:
                                  Border.all(color: Constants.themeBgColor)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15.h,
                                color: Constants.themeBgColor,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                "Skip",
                                style: GoogleFonts.varela(
                                    color: Constants.themeBgColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ], */
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(top: kToolbarHeight / 6.h),
                child: SingleChildScrollView(
                  child: _education(),
                ),
              ),
            )),
      ],
    );
  }

  Widget _education() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      //  key: const Key('second'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isgraduate = false;
                    isundergradute = true;
                    marksheet = null;
                    degreeController.clear();
                    universityController.clear();
                    fieldOfStudyController.clear();
                    firstYearController.clear();
                    passingYearController.clear();
                    boardController.clear();
                    // degreeController.text = "H.S.C".toString();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: isundergradute
                          ? Constants.themeBgColor
                          : Colors.white,
                      border: Border.all(color: Constants.themeBgColor)),
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8),
                  child: Text(
                    "H.S.C",
                    style: GoogleFonts.varela(
                        fontWeight: isundergradute
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isundergradute ? Colors.white : Colors.black),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isgraduate = true;
                    isundergradute = false;
                    marksheet = null;
                    boardController.clear();
                    science = false;
                    commerce = false;
                    art = false;
                    passingYearController.clear();
                    degreeController.clear();
                    universityController.clear();
                    fieldOfStudyController.clear();
                    firstYearController.clear();
                    passingYearController.clear();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: isgraduate ? Constants.themeBgColor : Colors.white,
                      border: Border.all(color: Constants.themeBgColor)),
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8),
                  child: Text(
                    "Graduate or above",
                    style: GoogleFonts.varela(
                        fontWeight:
                            isgraduate ? FontWeight.bold : FontWeight.normal,
                        color: isgraduate ? Colors.white : Colors.black),
                  ),
                ),
              ),
              /*  Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            // selectedKeyResponsible.contains(item)
                            Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    height: 16,
                    width: 20,
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Colors.transparent,
                      ),
                      child: Checkbox(
                        activeColor: Colors.white,
                        checkColor: Constants.themeBgColor,
                        visualDensity: VisualDensity.compact,
                        value: isundergradute,
                        onChanged: (newValue) {
                          setState(() {
                            isgraduate = false;
                            isundergradute = true;
                          });
                          // Notify Flutter that the state has changed
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  const Text("I am Under-Graduate.")
                ],
              ), */
            ],
          ),
          const SizedBox(height: 10),
          if (isgraduate || isundergradute) const Divider(),
          const SizedBox(height: 10),
          customWidgetGraduation(),
        ],
      ),
    );
  }

  int? universityId, degreeId, fieldId;

  FocusNode boardFocus = FocusNode();
  FocusNode passingyearfocus = FocusNode();
  FocusNode univerrsityfocus = FocusNode();
  FocusNode degreefocus = FocusNode();
  FocusNode filedofstudyfocus = FocusNode();
  FocusNode firstyearfocus = FocusNode();
  FocusNode finalyearfocus = FocusNode();

  String? marksheet;

  InkWell customContainerSelectMarksheet(
      {required final VoidCallback onPressed,
      required bool isSelect,
      required String title,
      bool isHalf = false,
      bool isVacancy = false,
      bool isNumOfOpening = false,
      bool isAnother = false,
      bool isEmails = false,
      bool isCross = false,
      bool? isSalary = false}) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: isAnother
                ? null
                : isNumOfOpening
                    ? MediaQuery.of(context).size.width / 2.449
                    : isEmails
                        ? MediaQuery.of(context).size.width / 2.437
                        : MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height / 30,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelect
                        ? Constants.themeBgColor
                        : Colors.transparent)),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isSalary!
                          ? const Icon(
                              Icons.currency_rupee_rounded,
                              color: Colors.white,
                              size: 15,
                            )
                          : const SizedBox(),
                      Text(title,
                          style: GoogleFonts.sourceSansPro(
                              color: Constants.themeBgColor, fontSize: 15.sp)),
                      isVacancy ? const Spacer() : const SizedBox(),

                      /*  isCross
                          ? Image.asset(
                              "assets/images/close.png",
                              height: 12,
                            )
                          : const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            ) */
                    ],
                  )
                : Text(title,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.themeBgColor, fontSize: 15.sp))));
  }

  InkWell customContainerSelectToViewDoc({
    required final VoidCallback onPressed,
    required String title,
  }) {
    return InkWell(
        onTap: onPressed,
        child: Container(

            //height: MediaQuery.of(context).size.height / 30,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.themeBgColor, fontSize: 15.sp)),
                SizedBox(
                  width: 6.w,
                ),
                Icon(
                  Icons.visibility_outlined,
                  color: Constants.themeBgColor,
                  size: 18.h,
                )
              ],
            )));
  }

  Widget customButton(String title, String? img, int? conSize, bool dlg) {
    return InkWell(
      onTap: () async {
        // data = await uploadFile(['pdf']);
        setState(() async {
          marksheet = await customFilePicker(['pdf']);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border:
                Border.all(color: dlg ? Constants.themeBgColor : Colors.white)),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.add,
              size: 16,
              color: Constants.themeBgColor,
            ),
            Text(
              title,
              style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold, color: Constants.themeBgColor),
            )
          ],
        ),
      ),
    );
  }

  String degreeCode = "";
  bool isgraduate = false, isundergradute = false;
  bool science = false, commerce = false, art = false;

  Widget customWidgetGraduation() {
    return SizedBox(
      child: Column(
        children: [
          if ((isgraduate || isundergradute) && !isundergradute)
            CustomTextFieldComapanyLocation(
              university: false,
              hsc: false,
              degree: true,
              labelText: "Degree / Specialization",
              title: "",
              isCity: true,
              contextIn: context,
              role: "",
              hintText: "Bachelor of Commerce",
              name: "degree",
              isCompany: false,
              onSubmit: (p0) {
                setState(() {
                  degreeCode = p0;
                });
              },
              getid: (p0) {
                degreeId = p0;
              },
              controllerValue: (p0) {
                degreeController.text = p0;
              },
              controller: degreeController,
              onChanged: (p0) {
                isGraduateDeg = true;
              },
              icon: const Icon(Icons.workspace_premium_outlined),
            ),
          if (!isundergradute) const SizedBox(height: 10),
          if (isgraduate || isundergradute)
            CustomTextFieldComapanyLocation(
              university: true,
              degree: false,
              labelText: !isundergradute ? "University / Institute" : "Board",
              title: "",
              isCity: true,
              hsc: false,
              contextIn: context,
              role: "",
              hintText: !isundergradute
                  ? "Mumbai University"
                  : "Maharashtra State Board",
              name: !isundergradute ? "university" : "board",
              isCompany: false,
              controller:
                  !isundergradute ? universityController : boardController,
              onChanged: (p0) {
                isUniG = true;
              },
              getid: (p0) {
                universityId = p0;
              },
              icon: const Icon(Icons.school_outlined),
            ),
          const SizedBox(height: 10),
          if (isgraduate || isundergradute)
            !isundergradute
                ? CustomTextFieldComapanyLocation(
                    university: false,
                    degree: false,
                    labelText: "Field of Study",
                    title: "",
                    hsc: false,
                    isCity: true,
                    contextIn: context,
                    role: "",
                    hintText: "Account and Finance",
                    name: "fieldofstudy",
                    isCompany: false,
                    controller: fieldOfStudyController,
                    onChanged: (p0) {
                      // isUniG = true;
                    },
                    getid: (p0) {
                      fieldId = p0;
                    },
                    icon: const Icon(Icons.auto_stories_outlined),
                  )
                : Container(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Field of study",
                          style: GoogleFonts.varela(
                              fontSize: 14.sp, color: Constants.themeBgColor)),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                science = true;
                                commerce = false;
                                art = false;
                                // degreeController.text = "H.S.C".toString();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 5.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: science
                                      ? Constants.themeBgColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: Constants.themeBgColor)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8),
                              child: Text(
                                "Science",
                                style: GoogleFonts.varela(
                                    fontWeight: science
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        science ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                science = false;
                                commerce = true;
                                art = false;
                                // degreeController.text = "H.S.C".toString();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 5.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: commerce
                                      ? Constants.themeBgColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: Constants.themeBgColor)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8),
                              child: Text(
                                "Commerce",
                                style: GoogleFonts.varela(
                                    fontWeight: commerce
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        commerce ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                science = false;
                                commerce = false;
                                art = true;
                                // degreeController.text = "H.S.C".toString();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 5.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: art
                                      ? Constants.themeBgColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: Constants.themeBgColor)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8),
                              child: Text(
                                "Art",
                                style: GoogleFonts.varela(
                                    fontWeight: art
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: art ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
          /*  CustomTextField(
                context: context,
                hint: "Account and Finance",
                label: "Field of Study",
                focusNode: filedofstudyfocus,
                controller: fieldOfStudyController,
                icon: const Icon(Icons.auto_stories_outlined)), */
          const SizedBox(
            height: 10,
          ),
          if (isgraduate || isundergradute)
            CustomTextField(
                maxLength: 4,
                isNumber: true,
                context: context,
                hint: "2017",
                label: !isundergradute ? "First Year" : "Passing Year",
                focusNode: firstyearfocus,
                controller: firstYearController,
                icon: const Icon(Icons.edit_calendar)),
          const SizedBox(height: 10),
          if ((isgraduate || isundergradute) && !isundergradute)
            CustomTextField(
                maxLength: 4,
                isNumber: true,
                context: context,
                hint: "2023",
                label: "Final Year",
                focusNode: finalyearfocus,
                controller: passingYearController,
                icon: const Icon(Icons.edit_calendar)),
          const SizedBox(
            height: 20,
          ),
          if (isgraduate || isundergradute)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*   InkWell(//TODO: marksheet document
                  child: marksheet != null
                      ? customContainerSelectToViewDoc(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPDFViewerDialog(
                                  pdfUrl:
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/$marksheet",
                                  onRemove: () {
                                    setState(() {
                                      marksheet = null;
                                    });
                                    // Add your logic for removing here
                                  },
                                  onReplace: () async {
                                    setState(() async {
                                      marksheet = await customFilePicker(
                                        ['pdf'],
                                      );

                                      // Add your logic for replacing here
                                    });
                                  },
                                );
                              },
                            );
                          },
                          title: "Upload Marksheet")
                      : customContainerSelectMarksheet(
                          isAnother: true,
                          isSelect: false,
                          onPressed: () async {
                            setState(() async {
                              // offerletter = true;
                              marksheet = await customFilePicker(
                                ["pdf"],
                              );
                              setState(() {});
                            });
                          },
                          title: marksheet != null
                              ? marksheet.toString()
                              : "Upload Marksheet"), //customButton("Upload Marksheet", "", 0, true),
                ), */
              ],
            )
        ],
      ),
    );
  }

  saveEducation(data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      print("done");
    }
    setState(() {});
  }

  bool isLoading = false;

  save(bool isSkip) async {
    setState(() {
      isLoading = true;
    });
    Education model = Education();

    if (!isSkip) {
      model = Education(
          id: eduID,
          userId: widget.userID,
          board: !isundergradute ? null : boardController.text,
          //level: "Graduate",
          university: !isundergradute ? universityController.text : null,
          degree_spc: isundergradute ? "H.S.C" : degreeController.text,
          fieldOfStudy: isundergradute
              ? science
                  ? "Science"
                  : commerce
                      ? "Commerce"
                      : art
                          ? "Art"
                          : fieldOfStudyController.text
              : fieldOfStudyController.text,
          firstYear: int.parse(firstYearController.text),
          passingYear:
              isundergradute ? null : int.parse(passingYearController.text),
          marksheet: marksheet,
          degree_id: degreeId,
          fieldofstudy_id: fieldId,
          university_id: universityId);
    }

    // Create an instance of UserDataService
    UserDataService userDataService = UserDataService();
    if (widget.jobtitleid == 0) {
      JobPostApiService.saveJobRole(
          context, widget.experience.job_title.toString());
    }
    if (widget.experience.userId != null) {
      await JobPostApiService.PostUserExperience(
          widget.experience.toJson(), context);
      // await userDataService.saveUserExperience(widget.experience.toJson());
    }
    if (!isSkip) {
      await userDataService.saveUserEducation(model.toMap());
    }
    await JobPostApiService.PostUserInfo(widget.introData);
    await JobPostApiService.updateLanguages(
        widget.languageModel, widget.userID);
    ref.refresh(userDataProvider);
   
    ref.refresh(profileSummaryProvider);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AddCv()),
        (route) => false);
    /* if (widget.prevPageModel == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else { */

    //}

    setState(() {
      isLoading = false;
    });
  }
}

Widget CustomTextField(
    {Icon? icon,
    required BuildContext context,
    required String hint,
    required String label,
    required FocusNode focusNode,
    bool? isPrimaryNumber = false,
    String? img,
    bool? isImage = false,
    int? maxLength,
    bool isNumber = false,
    bool? keyboardType,
    bool? isDisabled = true,
    bool? isOptional = false,
    required TextEditingController controller}) {
  // bool isError = false;
  return SizedBox(
    height: MediaQuery.of(context).size.height / 24,
    child: TextFormField(
      enabled: isDisabled,
      // autofocus: focusNode.canRequestFocus,
      focusNode: focusNode,
      inputFormatters: isNumber
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ]
          : <TextInputFormatter>[
              FilteringTextInputFormatter.singleLineFormatter,
            ],

      /*  validator: (value) {
          if (value == null || value.isEmpty) {
            //return "This Text field Cant be empty";
          }
          return null;
        }, */
      maxLength: maxLength,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
      //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
      textCapitalization: TextCapitalization.sentences,
      controller: controller.text != "0" ? controller : null,
      onTap: (() {}),
      style: GoogleFonts.varela(color: Constants.subtitleclr, fontSize: 14.sp),
      decoration: InputDecoration(
          filled: isPrimaryNumber! ? true : false,
          fillColor:
              isPrimaryNumber ? Colors.grey.shade200 : Colors.transparent,
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
