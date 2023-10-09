import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../components/autolistviewmodal.dart';
import '../../constants/customTextfield.dart';
import '../../models/autocompleteModel.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';

class Screen2 extends StatefulWidget {
  Screen2({Key? key, this.prevPageModel, this.selectedLevel}) : super(key: key);
  late Education? prevPageModel;
  late String? selectedLevel;

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
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
    bindProfileSummary();
    bindLevelOfEducation();
    bindUniversityEducation();
    bindDegree();
    if (widget.prevPageModel != null) {
      setState(() {
        isBoard = true;
      });

      setState(() {
        isHscPassing = true;
      });

      setState(() {
        isGraduateUni = true;
      });

      setState(() {
        isGraduateDeg = true;
      });

      setState(() {
        isGraduatefield = true;
      });

      setState(() {
        isGraduateFirst = true;
      });

      setState(() {
        isGraduatePassing = true;
      });

      setState(() {
        isPostUni = true;
      });

      setState(() {
        isPostDeg = true;
      });

      setState(() {
        isPostFirst = true;
      });

      setState(() {
        isPostPassing = true;
      });
      setState(() {
        isPostfield = true;
      });

      setState(() {
        isMbaUni = true;
      });

      setState(() {
        isMbaDeg = true;
      });

      setState(() {
        isMbafield = true;
      });

      setState(() {
        isMbaFirst = true;
      });

      setState(() {
        isMbaPassing = true;
      });

      setState(() {
        isOtherUni = true;
      });

      setState(() {
        isOtherDeg = true;
      });

      setState(() {
        isOtherfield = true;
      });

      setState(() {
        isOtherFirst = true;
      });

      setState(() {
        isOtherPassing = true;
      });

      eduID = widget.prevPageModel!.id;

      if (widget.selectedLevel == "Under Graduate") {
        hsc = true;
      }

      if (widget.selectedLevel == "Graduate") {
        graduate = true;
      }
      if (widget.prevPageModel!.level == "HSC") {
        hsc = true;
        boardController.text = widget.prevPageModel!.board!;
        passingYearController.text =
            widget.prevPageModel!.passingYear.toString();
      } else if (widget.prevPageModel!.level == "Graduate") {
        graduate = true;
        universityController.text = widget.prevPageModel!.university!;
        degreeController.text = widget.prevPageModel!.degree_spc!;
        fieldOfStudyController.text = widget.prevPageModel!.fieldOfStudy!;
        firstYearController.text = widget.prevPageModel!.firstYear.toString();
        passingYearController.text =
            widget.prevPageModel!.passingYear.toString();
      } else if (widget.prevPageModel!.level == "Post Graduate") {
        undergraduate = true;
        universityController.text = widget.prevPageModel!.university!;
        degreeController.text = widget.prevPageModel!.degree_spc!;
        fieldOfStudyController.text = widget.prevPageModel!.fieldOfStudy!;
        firstYearController.text = widget.prevPageModel!.firstYear.toString();
        passingYearController.text =
            widget.prevPageModel!.passingYear.toString();
      } else if (widget.prevPageModel!.level == "other") {
        other = true;
        universityController.text = widget.prevPageModel!.university!;
        degreeController.text = widget.prevPageModel!.degree_spc!;
        fieldOfStudyController.text = widget.prevPageModel!.fieldOfStudy!;
        firstYearController.text = widget.prevPageModel!.firstYear.toString();
        passingYearController.text =
            widget.prevPageModel!.passingYear.toString();
      } else if (widget.prevPageModel!.level == "MBA") {
        mba = true;
        universityController.text = widget.prevPageModel!.university!;
        degreeController.text = widget.prevPageModel!.degree_spc!;
        fieldOfStudyController.text = widget.prevPageModel!.fieldOfStudy!;
        firstYearController.text = widget.prevPageModel!.firstYear.toString();
        passingYearController.text =
            widget.prevPageModel!.passingYear.toString();
      }
    }
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

  customFilePicker() async {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          bottomNavigationBar: InkWell(
            onTap: () {
              save();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.prevPageModel == null
                    ? Text(
                        "Add Education",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        "Edit Education ",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
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
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: _education(),
            ),
          )),
    );
  }

  Widget _education() {
    String? selectedLevel =
        widget.prevPageModel != null ? widget.prevPageModel!.level : "";
    return selectedLevel != ""
        ? Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            key: const Key('second'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Level of Education : ${widget.prevPageModel!.level}",
                  style: GoogleFonts.varela(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Wrap(
                //   children: [
                //     if (selectedLevel == "HSC")
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             graduate = false;
                //             undergraduate = false;
                //             mba = false;
                //             hsc = true;
                //             other = false;
                //             degreeController.clear();
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: hsc ? Constants.borderColor : Colors.white,
                //             borderRadius: BorderRadius.circular(15),
                //             border: Border.all(color: Colors.grey),
                //           ),
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 14, vertical: 4),
                //           margin: EdgeInsets.only(right: 5.w, bottom: 5),
                //           child: Text(
                //             "H.S.C / 10+2",
                //             style: GoogleFonts.varela(
                //               fontSize: 13.sp,
                //               fontWeight: FontWeight.bold,
                //               color: hsc ? Colors.black : Colors.grey.shade400,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     if (selectedLevel == "Graduate")
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             graduate = true;
                //             undergraduate = false;
                //             hsc = false;
                //             other = false;
                //             mba = false;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color:
                //                 graduate ? Constants.borderColor : Colors.white,
                //             borderRadius: BorderRadius.circular(15),
                //             border: Border.all(color: Colors.grey),
                //           ),
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 14, vertical: 4),
                //           margin: EdgeInsets.only(right: 5.w, bottom: 5),
                //           child: Text(
                //             "Graduate",
                //             style: GoogleFonts.varela(
                //               fontSize: 13.sp,
                //               fontWeight: FontWeight.bold,
                //               color: graduate
                //                   ? Colors.black
                //                   : Colors.grey.shade400,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     if (selectedLevel == "Post Graduate")
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             graduate = false;
                //             undergraduate = true;
                //             mba = false;
                //             hsc = false;
                //             other = false;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: undergraduate
                //                 ? Constants.borderColor
                //                 : Colors.white,
                //             borderRadius: BorderRadius.circular(15),
                //             border: Border.all(color: Colors.grey),
                //           ),
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 14, vertical: 4),
                //           margin: EdgeInsets.only(right: 5.w, bottom: 5),
                //           child: Text(
                //             "Post Graduate",
                //             style: GoogleFonts.varela(
                //               fontSize: 13.sp,
                //               fontWeight: FontWeight.bold,
                //               color: undergraduate
                //                   ? Colors.black
                //                   : Colors.grey.shade400,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     if (selectedLevel == "MBA")
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             graduate = false;
                //             undergraduate = false;
                //             hsc = false;
                //             mba = true;
                //             other = false;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: mba ? Constants.borderColor : Colors.white,
                //             borderRadius: BorderRadius.circular(15),
                //             border: Border.all(color: Colors.grey),
                //           ),
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 14, vertical: 4),
                //           margin: EdgeInsets.only(right: 5.w, bottom: 5),
                //           child: Text(
                //             "MBA",
                //             style: GoogleFonts.varela(
                //               fontSize: 13.sp,
                //               fontWeight: FontWeight.bold,
                //               color: mba ? Colors.black : Colors.grey.shade400,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     if (selectedLevel == "other")
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             graduate = false;
                //             undergraduate = false;
                //             hsc = false;
                //             mba = false;
                //             degreeController.clear();
                //             other = true;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: other ? Constants.borderColor : Colors.white,
                //             borderRadius: BorderRadius.circular(15),
                //             border: Border.all(color: Colors.grey),
                //           ),
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 14, vertical: 4),
                //           margin: EdgeInsets.only(right: 5.w, bottom: 5),
                //           child: Text(
                //             "Other's",
                //             style: GoogleFonts.varela(
                //               fontSize: 13.sp,
                //               fontWeight: FontWeight.bold,
                //               color:
                //                   other ? Colors.black : Colors.grey.shade400,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //   ],
                // ),
                // SizedBox(height: 10.h),
                // const Divider(
                //   thickness: 1.5,
                // ),
                const SizedBox(height: 10),
                if (hsc) customWidgetHSC(),
                if (graduate) customWidgetGraduation(),
                if (undergraduate) customWidgetPost(),
                if (mba) customWidgetMBA(),
                if (other) customWidgetOther(),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            key: const Key('second'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level of Education",
                  style: GoogleFonts.varela(
                      fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          graduate = false;
                          undergraduate = false;
                          mba = false;
                          hsc = true;
                          other = false;
                          degreeController.clear;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: hsc ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: EdgeInsets.only(right: 5.w, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            hsc
                                ? Text(
                                    "H.S.C / 10+2",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "H.S.C / 10+2",
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade400,
                                        fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            hsc
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          graduate = true;
                          undergraduate = false;
                          hsc = false;
                          other = false;
                          mba = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              graduate ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: EdgeInsets.only(right: 5.w, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            graduate
                                ? Text(
                                    "Graduate",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Graduate",
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade400,
                                        fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            graduate
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          graduate = false;
                          undergraduate = true;
                          mba = false;
                          hsc = false;
                          other = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: undergraduate
                              ? Constants.borderColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: EdgeInsets.only(right: 5.w, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            undergraduate
                                ? Text(
                                    "Post Graduate",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Post Graduate",
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade400,
                                        fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            undergraduate
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          graduate = false;
                          undergraduate = false;
                          hsc = false;
                          mba = true;
                          other = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: mba ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: EdgeInsets.only(right: 5.w, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            mba
                                ? Text(
                                    "MBA",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "MBA",
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade400,
                                        fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            mba
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          graduate = false;
                          undergraduate = false;
                          mba = false;
                          hsc = false;
                          degreeController.clear;
                          other = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: other ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: EdgeInsets.only(right: 5.w, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            other
                                ? Text(
                                    "Other's",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Other's",
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade400,
                                        fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            other
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                const Divider(
                  thickness: 1.5,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (hsc == true) customWidgetHSC(),
                if (graduate == true) customWidgetGraduation(),
                if (undergraduate == true) customWidgetPost(),
                if (mba == true) customWidgetMBA(),
                if (other == true) customWidgetOther(),
              ],
            ),
          );
  }

  SizedBox customWidgetOther() {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: isOtherUni
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "University / Institute",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      customContainerSelect1(
                        true,
                        universityController.text,
                        true,
                        () {
                          setState(() {
                            isOtherUni = false;
                            uniOFocus.requestFocus();
                            universityController.clear();
                          });
                        },
                      ),
                    ],
                  )
                : CustomJobFormTextFieldRespOne(
                    onIDSelected: () {},
                    // isSelected: isIndustry,
                    focusNode: uniOFocus,
                    role: "",
                    isCompany: false,
                    isIndustry: true,
                    name: "university",
                    title: "University / Institute",
                    controller: universityController,
                    onChanged: (p0) {
                      isUniO = true;
                    },
                    contextIn: context,
                    hintText: "Mumbai University",
                  ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: isOtherDeg
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Degree / Specialization",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      customContainerSelect1(
                        true,
                        degreeController.text,
                        true,
                        () {
                          setState(() {
                            isOtherDeg = false;
                            degreeOFocus.requestFocus();
                            degreeController.clear();
                          });
                        },
                      ),
                    ],
                  )
                : CustomJobFormTextFieldRespOne(
                    onIDSelected: () {},
                    // isSelected: isIndustry,
                    focusNode: degreeOFocus,
                    role: "",
                    isCompany: false,
                    isIndustry: true,
                    name: "degree",
                    title: "Degree / Specialization",
                    controller: degreeController,
                    onChanged: (p0) {
                      isOtherDeg = true;
                    },
                    contextIn: context,
                    hintText: "Bachelor of Commerce",
                  ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Field of Study",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isOtherfield
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isOtherfield = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          fieldOfStudyController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: fieldOfStudyController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherfield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherfield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherfield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: fieldOfStudyController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "Accounts and Finance",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "First Year",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isOtherFirst
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isOtherFirst = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          firstYearController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: firstYearController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: firstYearController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "March 2023",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Final Year",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isOtherPassing
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isOtherPassing = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          passingYearController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: passingYearController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isOtherPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: passingYearController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "March 2023",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*  customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false), */
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox customWidgetMBA() {
    return SizedBox(
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: isMbaUni
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "University / Institute",
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    customContainerSelect1(
                      true,
                      universityController.text,
                      true,
                      () {
                        setState(() {
                          isMbaUni = false;
                          uniMFocus.requestFocus();
                          universityController.clear();
                        });
                      },
                    ),
                  ],
                )
              : CustomJobFormTextFieldRespOne(
                  onIDSelected: () {},
                  // isSelected: isIndustry,
                  focusNode: uniMFocus,
                  role: "",
                  isCompany: false,
                  isIndustry: true,
                  name: "university",
                  title: "University / Institute",
                  controller: universityController,
                  onChanged: (p0) {
                    isUniM = true;
                  },
                  contextIn: context,
                  hintText: "Mumbai University",
                ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: isMbaDeg
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Degree / Specialization",
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    customContainerSelect1(
                      true,
                      degreeController.text,
                      true,
                      () {
                        setState(() {
                          isMbaDeg = false;
                          degreeMFocus.requestFocus();
                          degreeController.clear();
                        });
                      },
                    ),
                  ],
                )
              : CustomJobFormTextFieldRespOne(
                  onIDSelected: () {},
                  // isSelected: isIndustry,
                  focusNode: degreeMFocus,
                  role: "",
                  isCompany: false,
                  isIndustry: true,
                  name: "degree",
                  title: "Degree / Specialization",
                  controller: degreeController,
                  onChanged: (p0) {
                    isMbaDeg = true;
                  },
                  contextIn: context,
                  hintText: "Bachelor of Commerce",
                ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Field of Study",
              style: GoogleFonts.sourceSansPro(
                  fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            isMbafield
                ? customContainerSelect(
                    isVacancy: true,
                    isCross: true,
                    isAnother: true,
                    isNumOfOpening: false,
                    onPressed: () {
                      setState(() {
                        isMbafield = false;
                        // FocusScope.of(context).autofocus(focusNode);
                        fieldOfStudyController.clear();
                        // titleFocus.requestFocus();
                      });
                    },
                    isSelect: true,
                    title: fieldOfStudyController.text)
                : Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 55,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          color: Colors.white,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This Text field Cant be empty";
                              }
                              return null;
                            },

                            onFieldSubmitted: (value) {
                              fieldOfStudyController.text.isNotEmpty
                                  ? setState(() {
                                      isMbafield = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                            onTapOutside: (event) {
                              fieldOfStudyController.text.isNotEmpty
                                  ? setState(() {
                                      isMbafield = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            onEditingComplete: () {
                              fieldOfStudyController.text.isNotEmpty
                                  ? setState(() {
                                      isMbafield = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            keyboardType: TextInputType.text,
                            controller: fieldOfStudyController,
                            // enabled: enableShortListFor,
                            onTap: (() {}),
                            decoration: InputDecoration(
                                counterText: '',
                                contentPadding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xffff0eceb)),
                                ),
                                focusColor: const Color(0xffff0eceb),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 122, 113, 111)),
                                ),
                                hintText: "Accounts and Finance",
                                hintStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.subtitleclr,
                                    fontSize: 15.sp)
                                //  prefixIcon: Icon(Icons.list)
                                ),
                          ),
                        ),
                      ],
                    )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "First Year",
              style: GoogleFonts.sourceSansPro(
                  fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            isMbaFirst
                ? customContainerSelect(
                    isVacancy: true,
                    isCross: true,
                    isAnother: true,
                    isNumOfOpening: false,
                    onPressed: () {
                      setState(() {
                        isMbaFirst = false;
                        // FocusScope.of(context).autofocus(focusNode);
                        firstYearController.clear();
                        // titleFocus.requestFocus();
                      });
                    },
                    isSelect: true,
                    title: firstYearController.text)
                : Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 55,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          color: Colors.white,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This Text field Cant be empty";
                              }
                              return null;
                            },

                            onFieldSubmitted: (value) {
                              firstYearController.text.isNotEmpty
                                  ? setState(() {
                                      isMbaFirst = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                            onTapOutside: (event) {
                              firstYearController.text.isNotEmpty
                                  ? setState(() {
                                      isMbaFirst = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            onEditingComplete: () {
                              firstYearController.text.isNotEmpty
                                  ? setState(() {
                                      isMbaFirst = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            keyboardType: TextInputType.text,
                            controller: firstYearController,
                            // enabled: enableShortListFor,
                            onTap: (() {}),
                            decoration: InputDecoration(
                                counterText: '',
                                contentPadding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xffff0eceb)),
                                ),
                                focusColor: const Color(0xffff0eceb),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 122, 113, 111)),
                                ),
                                hintText: "March 2023",
                                hintStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.subtitleclr,
                                    fontSize: 15.sp)
                                //  prefixIcon: Icon(Icons.list)
                                ),
                          ),
                        ),
                      ],
                    )),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Final Year",
              style: GoogleFonts.sourceSansPro(
                  fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            isMbaPassing
                ? customContainerSelect(
                    isVacancy: true,
                    isCross: true,
                    isAnother: true,
                    isNumOfOpening: false,
                    onPressed: () {
                      setState(() {
                        isMbaPassing = false;
                        // FocusScope.of(context).autofocus(focusNode);
                        passingYearController.clear();
                        // titleFocus.requestFocus();
                      });
                    },
                    isSelect: true,
                    title: passingYearController.text)
                : Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 55,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          color: Colors.white,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This Text field Cant be empty";
                              }
                              return null;
                            },

                            onFieldSubmitted: (value) {
                              passingYearController.text.isNotEmpty
                                  ? setState(() {
                                      isMbaPassing = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                            onTapOutside: (event) {
                              passingYearController.text.isNotEmpty
                                  ? setState(() {
                                      isMbaPassing = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            onEditingComplete: () {
                              passingYearController.text.isNotEmpty
                                  ? setState(() {
                                      isMbaPassing = true;
                                      // _showContainer1 = value.isEmpty;
                                    })
                                  : null;
                            },
                            keyboardType: TextInputType.text,
                            controller: passingYearController,
                            // enabled: enableShortListFor,
                            onTap: (() {}),
                            decoration: InputDecoration(
                                counterText: '',
                                contentPadding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xffff0eceb)),
                                ),
                                focusColor: const Color(0xffff0eceb),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 122, 113, 111)),
                                ),
                                hintText: "March 2023",
                                hintStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.subtitleclr,
                                    fontSize: 15.sp)
                                //  prefixIcon: Icon(Icons.list)
                                ),
                          ),
                        ),
                      ],
                    )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*     customButton("Digi Locker",
                                  "assets/images/digilocker.png", 70, false), */
                              customButton("Manual",
                                  "assets/images/file_exp.png", 70, false),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: customButton("Upload Marksheet", "", 0, true),
            ),
          ],
        )
      ]),
    );
  }

  SizedBox customWidgetHSC() {
    return SizedBox(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Board",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isBoard
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isBoard = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          boardController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: boardController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                boardController.text.isNotEmpty
                                    ? setState(() {
                                        isBoard = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                boardController.text.isNotEmpty
                                    ? setState(() {
                                        isBoard = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                boardController.text.isNotEmpty
                                    ? setState(() {
                                        isBoard = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: boardController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "Maharashtra Board",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Passing Year",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isHscPassing
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isHscPassing = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          passingYearController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: passingYearController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isHscPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isHscPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isHscPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: passingYearController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "March 2023",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false),
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget customButton(String title, String? img, int? conSize, bool dlg) {
    return InkWell(
      onTap: () async {
        customFilePicker();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border:
                Border.all(color: dlg ? Constants.themeBgColor : Colors.white)),
        child: img!.isNotEmpty
            ? Image.asset(
                img,
                height: conSize!.h,
              )
            : Row(
                children: [
                  const Icon(
                    Icons.add,
                    size: 16,
                    color: Constants.themeBgColor,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        color: Constants.themeBgColor),
                  )
                ],
              ),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      ),
    );
  }

  Row customDocumnet(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            title,
            style: GoogleFonts.varela(
                color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),
        Image.asset(
          "assets/images/file_upload.png",
          height: 16.h,
        )
      ],
    );
  }

  SizedBox customWidgetGraduation() {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: isGraduateUni
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "University / Institute",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      customContainerSelect1(
                        true,
                        universityController.text,
                        true,
                        () {
                          setState(() {
                            isGraduateUni = false;
                            uniGFocus.requestFocus();
                            universityController.clear();
                          });
                        },
                      ),
                    ],
                  )
                : CustomJobFormTextFieldRespOne(
                    onIDSelected: () {},
                    // isSelected: isIndustry,
                    focusNode: uniGFocus,
                    role: "",
                    isCompany: false,
                    isIndustry: true,
                    name: "university",
                    title: "University / Institute",
                    controller: universityController,
                    onChanged: (p0) {
                      isUniG = true;
                    },
                    contextIn: context,
                    hintText: "Mumbai University",
                  ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: isGraduateDeg
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Degree / Specialization",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      customContainerSelect1(
                        true,
                        degreeController.text,
                        true,
                        () {
                          setState(() {
                            isGraduateDeg = false;
                            dgreeGFocus.requestFocus();
                            degreeController.clear();
                          });
                        },
                      ),
                    ],
                  )
                : CustomJobFormTextFieldRespOne(
                    onIDSelected: () {},
                    // isSelected: isIndustry,
                    focusNode: dgreeGFocus,
                    role: "",
                    isCompany: false,
                    isIndustry: true,
                    name: "degree",
                    title: "Degree / Specialization",
                    controller: degreeController,
                    onChanged: (p0) {
                      isGraduateDeg = true;
                    },
                    contextIn: context,
                    hintText: "Bachelor of Commerce",
                  ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Field of Study",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isGraduatefield
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isGraduatefield = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          fieldOfStudyController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: fieldOfStudyController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduatefield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduatefield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduatefield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: fieldOfStudyController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "Accounts and Finance",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "First Year",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isGraduateFirst
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isGraduateFirst = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          firstYearController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: firstYearController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduateFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduateFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduateFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: firstYearController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "March 2023",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Final Year",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isGraduatePassing
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isGraduatePassing = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          passingYearController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: passingYearController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduatePassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduatePassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isGraduatePassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: passingYearController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "March 2023",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*  customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false), */
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox customWidgetPost() {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: isPostUni
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "University / Institute",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      customContainerSelect1(
                        true,
                        universityController.text,
                        true,
                        () {
                          setState(() {
                            isPostUni = false;
                            uniPFocus.requestFocus();
                            universityController.clear();
                          });
                        },
                      ),
                    ],
                  )
                : CustomJobFormTextFieldRespOne(
                    onIDSelected: () {},
                    // isSelected: isIndustry,
                    focusNode: uniPFocus,
                    role: "",
                    isCompany: false,
                    isIndustry: true,
                    name: "university",
                    title: "University / Institute",
                    controller: universityController,
                    onChanged: (p0) {
                      isUniP = true;
                    },
                    contextIn: context,
                    hintText: "Mumbai University",
                  ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: isPostDeg
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Degree / Specialization",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      customContainerSelect1(
                        true,
                        degreeController.text,
                        true,
                        () {
                          setState(() {
                            isPostDeg = false;
                            degreePFocus.requestFocus();
                            degreeController.clear();
                          });
                        },
                      ),
                    ],
                  )
                : CustomJobFormTextFieldRespOne(
                    onIDSelected: () {},
                    // isSelected: isIndustry,
                    focusNode: degreePFocus,
                    role: "",
                    isCompany: false,
                    isIndustry: true,
                    name: "degree",
                    title: "Degree / Specialization",
                    controller: degreeController,
                    onChanged: (p0) {
                      isPostDeg = true;
                    },
                    contextIn: context,
                    hintText: "Bachelor of Commerce",
                  ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Field of Study",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isPostfield
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isPostfield = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          fieldOfStudyController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: fieldOfStudyController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isPostfield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isPostfield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                fieldOfStudyController.text.isNotEmpty
                                    ? setState(() {
                                        isPostfield = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: fieldOfStudyController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "Accounts and Finance",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "First Year",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isGraduateFirst
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isPostFirst = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          firstYearController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: firstYearController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isPostFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isPostFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                firstYearController.text.isNotEmpty
                                    ? setState(() {
                                        isPostFirst = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: firstYearController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "March 2023",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Final Year",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              isPostPassing
                  ? customContainerSelect(
                      isVacancy: true,
                      isCross: true,
                      isAnother: true,
                      isNumOfOpening: false,
                      onPressed: () {
                        setState(() {
                          isPostPassing = false;
                          // FocusScope.of(context).autofocus(focusNode);
                          passingYearController.clear();
                          // titleFocus.requestFocus();
                        });
                      },
                      isSelect: true,
                      title: passingYearController.text)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 55,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            color: Colors.white,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This Text field Cant be empty";
                                }
                                return null;
                              },

                              onFieldSubmitted: (value) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isPostPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTapOutside: (event) {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isPostPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              onEditingComplete: () {
                                passingYearController.text.isNotEmpty
                                    ? setState(() {
                                        isPostPassing = true;
                                        // _showContainer1 = value.isEmpty;
                                      })
                                    : null;
                              },
                              keyboardType: TextInputType.text,
                              controller: passingYearController,
                              // enabled: enableShortListFor,
                              onTap: (() {}),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xffff0eceb)),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 122, 113, 111)),
                                  ),
                                  hintText: "March 2023",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.subtitleclr,
                                      fontSize: 15.sp)
                                  //  prefixIcon: Icon(Icons.list)
                                  ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*    customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false), */
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  InkWell customContainerSelect(
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

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelect ? const Color(0xfff310d44) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
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
                              color: Colors.white, fontSize: 15.sp)),
                      isVacancy
                          ? const Spacer()
                          : const SizedBox(
                              width: 5,
                            ),
                      isCross
                          ? Image.asset(
                              "assets/images/cross.png",
                              height: 12,
                            )
                          : const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            )
                    ],
                  )
                : Text(title,
                    style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
  }

  save() async {
    Education model = Education();

    if (hsc == true) {
      model = Education(
        id: eduID,
        userId: profilemodel.id,
        level: "HSC",
        board: boardController.text,
        passingYear: int.parse(passingYearController.text),
        marksheet: "marksheet.pdf",
      );
    } else if (graduate == true) {
      model = Education(
        id: eduID,
        userId: profilemodel.id,
        level: "Graduate",
        university: universityController.text,
        degree_spc: degreeController.text,
        fieldOfStudy: fieldOfStudyController.text,
        firstYear: int.parse(firstYearController.text),
        passingYear: int.parse(passingYearController.text),
        marksheet: "marksheet.pdf",
      );
    } else if (undergraduate == true) {
      model = Education(
        id: eduID,
        userId: profilemodel.id,
        level: "Post Graduate",
        university: universityController.text,
        degree_spc: degreeController.text,
        fieldOfStudy: fieldOfStudyController.text,
        firstYear: int.parse(firstYearController.text),
        passingYear: int.parse(passingYearController.text),
        marksheet: "marksheet.pdf",
      );
    } else if (other == true) {
      model = Education(
        id: eduID,
        userId: profilemodel.id,
        level: "other",
        university: universityController.text,
        degree_spc: degreeController.text,
        fieldOfStudy: fieldOfStudyController.text,
        firstYear: int.parse(firstYearController.text),
        passingYear: int.parse(passingYearController.text),
        marksheet: "marksheet.pdf",
      );
    } else if (mba == true) {
      model = Education(
        id: eduID,
        userId: profilemodel.id,
        level: "MBA",
        university: universityController.text,
        degree_spc: degreeController.text,
        fieldOfStudy: fieldOfStudyController.text,
        firstYear: int.parse(firstYearController.text),
        passingYear: int.parse(passingYearController.text),
        marksheet: "marksheet.pdf",
      );
    }

    // Create an instance of UserDataService
    UserDataService userDataService = UserDataService();

    // Call the saveUserExperience method on the instance
    await userDataService.saveUserEducation(model.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Education saved successfully')),
    );
  }
}

InkWell customContainerSelect1(
    bool isSelect, String text, bool isFetch, Function() onTab) {
  return InkWell(
      onTap: onTab,
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
                    Text(text,
                        style: GoogleFonts.sourceSansPro(
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15.sp)),
                    const SizedBox(
                      width: 5,
                    ),
                    isFetch
                        ? Image.asset(
                            "assets/images/cross.png",
                            height: 12,
                          )
                        : const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          )
                  ],
                )
              : Text(text, style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
}
