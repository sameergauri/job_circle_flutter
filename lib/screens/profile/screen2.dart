// ignore_for_file: must_be_immutable, unused_result, unused_local_variable, prefer_typing_uninitialized_variables, unused_element, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, non_constant_identifier_names, use_full_hex_values_for_flutter_colors, unnecessary_null_comparison
// ignore_for_file: todo
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/customdialogue_for_education_selecton.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/month_drop_down.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../models/autocompleteModel.dart';
import '../../models/profileSummary.dart';
// import '../../service/UserDataService.dart';

class Screen2 extends ConsumerStatefulWidget {
  final bool underGraduate;
  Screen2(
      {super.key,
      this.prevPageModel,
      this.selectedLevel,
      this.educationList,
      required this.edulength,
      required this.isFirst,
      required this.underGraduate,
      required this.userid,
      required this.profileskill,
      required this.isEdit});
  late EducationDetail? prevPageModel;
  int edulength;
  late String? selectedLevel;
  late List<EducationDetail>? educationList;
  final bool isFirst, isEdit;
  final int userid;
  final List<String> profileskill;

  @override
  ConsumerState<Screen2> createState() => _Screen2State();
}

class _Screen2State extends ConsumerState<Screen2> {
  late Widget previousWidget;
  //controller
  late TextEditingController educationController = TextEditingController();
  late TextEditingController firstYearController = TextEditingController();
  late TextEditingController endYearController = TextEditingController();
  late TextEditingController universityController = TextEditingController();
  late TextEditingController degreeController = TextEditingController();
  late TextEditingController fieldOfStudyController = TextEditingController();
  late TextEditingController boardController = TextEditingController();
  late TextEditingController firstMonthController = TextEditingController();
  late TextEditingController endMonthController = TextEditingController();

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
  FocusNode firstmonthfocus = FocusNode();
  FocusNode endmonthfocus = FocusNode();

  int? universityId, degreeId, fieldId;

  //drop down
  var ddlValues;
  late List<AutoCompleteModel> levelOfEducationList = [];
  late List<AutoCompleteModel> universityInstitueList = [];
  late List<AutoCompleteModel> degreeList = [];
  AutoCompleteModel selectedEducation = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedUniversity = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedDegree = AutoCompleteModel("", "", {});
  ProfileSummaryModel profilemodel = ProfileSummaryModel();

  bool isremote = false;

  @override
  initState() {
    super.initState();

    bindLevelOfEducation();
    // bindUniversityEducation();
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
      /*   if (widget.prevPageModel!.level == "HSC") {
        hsc = true;
        boardController.text = widget.prevPageModel!.board!;
        passingYearController.text =
            widget.prevPageModel!.passingYear.toString();
      } else if (widget.prevPageModel!.level == "Graduate") { */
      setState(() {
        // graduate = true;
        if (widget.prevPageModel?.isRemote == 1) {
          isremote = true;
        } else if (widget.prevPageModel?.isRemote == 0) {
          isremote = false;
        }
        if (widget.prevPageModel!.schoolOrCollegeName != null &&
            widget.prevPageModel!.schoolOrCollegeName != "") {
          schoolcollegeName.text =
              widget.prevPageModel!.schoolOrCollegeName.toString();
        }
        universityController.text = widget.prevPageModel!.university.toString();
        degreeController.text = widget.prevPageModel!.degree_spc!;
        fieldOfStudyController.text = widget.prevPageModel!.fieldOfStudy!;
        firstMonthController.text = widget.prevPageModel!.startMonth.toString();
        firstYearController.text = widget.prevPageModel!.firstYear.toString();
        if (widget.prevPageModel!.isCurrent != 1 &&
            widget.prevPageModel!.isCurrent != null) {
          endMonthController.text = widget.prevPageModel!.endMonth.toString();
          endYearController.text = widget.prevPageModel!.passingYear.toString();
        }
        if (widget.prevPageModel!.isCurrent == 1) {
          currentlyStudying = true;
        } else {
          currentlyStudying = false;
        }
        if (widget.prevPageModel!.marksheet != null &&
            widget.prevPageModel!.marksheet != "" &&
            widget.prevPageModel!.marksheet != "null") {
          marksheet = widget.prevPageModel!.marksheet.toString();
        }
        /*  universityId = widget.prevPageModel!.university_id;
        degreeId = widget.prevPageModel!.degree_id;
        fieldId = widget.prevPageModel!.fieldofstudy_id;
        marksheet = widget.prevPageModel!.marksheet.toString();
        universityId = widget.prevPageModel!.university_id;
        degreeId = widget.prevPageModel!.degree_id;
        fieldId = widget.prevPageModel!.fieldofstudy_id; */
      });
      /*  } else if (widget.prevPageModel!.level == "Post Graduate") {
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
      } */
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

  /*  bindUniversityEducation() async {
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
  } */

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            bottomNavigationBar: CustomButtonForSave(
              onTap: () async {
                int? firstyear =
                    int.tryParse(firstYearController.text.toString());
                int? passingyear =
                    int.tryParse(endYearController.text.toString());
                if (!isremote && schoolcollegeName.text.isEmpty) {
                  CustomSnackbar.show("Add School / College name", true);
                } else if (degreeController.text.isEmpty) {
                  CustomSnackbar.show("Add degree first", true);
                } else if (universityController.text.isEmpty) {
                  CustomSnackbar.show("Add University first", true);
                } else if (fieldOfStudyController.text.isEmpty) {
                  CustomSnackbar.show("Add Field of study", true);
                } else if (firstMonthController.text.isEmpty ||
                    firstMonthController.text.isEmpty) {
                  CustomSnackbar.show("Add Start year", true);
                } else if (!currentlyStudying &&
                    (endMonthController.text.isEmpty ||
                        endYearController.text.isEmpty)) {
                  CustomSnackbar.show("Add Passing/End year", true);
                } else if ((passingyear != null && firstyear != null) &&
                    (firstyear > passingyear)) {
                  CustomSnackbar.show(
                      "Passing year should be greater the start year", true);
                } else {
                  await save();
                }
              },
              title: "Save",
            ),
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Constants.borderColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.prevPageModel == null
                      ? const OnboardingTitle(
                          title: "Add Education",
                        )
                      : const OnboardingTitle(
                          title: "Edit Education",
                        ),
                ],
              ),
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _education(),
              ),
            )),
        if (isLoading)
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

  Widget _education() {
    String? selectedLevel =
        widget.prevPageModel != null ? widget.prevPageModel!.level : "";
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*    Text(
                  "Level of Education : ${widget.prevPageModel!.level}",
                  style: GoogleFonts.varela(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ), */
          const SizedBox(height: 10),
          // if (hsc) customWidgetHSC(),
          // if (graduate)
          customWidgetGraduation(),
          // if (undergraduate) customWidgetPost(),
          // if (mba) customWidgetMBA(),
          // if (other) customWidgetOther(),
        ],
      ),
    );
  }

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

  TextEditingController schoolcollegeName = TextEditingController();
  FocusNode schoolcollegeFocus = FocusNode();

  bool currentlyStudying = false;

  String degreeCode = "";
  bool science = false, commerce = false, art = false;

  SizedBox customWidgetGraduation() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "School / College Name*",
          ),
          CustomJobTitleForExperience(
            onIDSelected: () {},
            role: "",
            isCompany: false,
            isIndustry: true,
            name: "school",
            title: "School / College name",
            controller: schoolcollegeName,
            onChanged: (p0) {},
            getid: (p0) {},
            contextIn: context,
            hintText: "School or college name",
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    side: const BorderSide(color: Colors.white),
                    activeColor: Colors.white,
                    checkColor: Constants.themeBgColor,
                    visualDensity: VisualDensity.compact,
                    value: isremote,
                    onChanged: (newValue) {
                      setState(() {
                        isremote = !isremote;
                      });
                      // Notify Flutter that the state has changed
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              const customTextForWeather(
                title: "Study remotely via a distance learning.",
              ),
            ],
          ),

          const SizedBox(height: 10),
          const customTextForWeather(
            title: "University / Board Name*",
          ),
          CustomJobTitleForExperience(
            onIDSelected: () {},
            // isSelected: isIndustry,
            //focusNode: titleFocus,
            role: "",
            isCompany: false,
            isIndustry: true,
            name: "university",
            title: "University",
            controller: universityController,
            onChanged: (p0) {},
            getid: (p0) {},
            contextIn: context,
            hintText: "Type to search",
          ),

          SizedBox(
            height: 10.h,
          ),
          //   if (degreeCode != "D001")
          const customTextForWeather(
            title: "Degree*",
          ),
          CustomJobTitleForExperience(
            onIDSelected: () {},
            // isSelected: isIndustry,
            //focusNode: titleFocus,
            role: "",
            isCompany: false,
            isIndustry: true,
            name: "degree",
            title: "Degree",
            controller: degreeController,
            onChanged: (p0) {},
            getid: (p0) {},
            contextIn: context,
            hintText: "Type to search",
          ),

          const SizedBox(height: 10),
          const customTextForWeather(
            title: "Field of study*",
          ),
          CustomJobTitleForExperience(
            onIDSelected: () {},
            // isSelected: isIndustry,
            //focusNode: titleFocus,
            role: "",
            isCompany: false,
            isIndustry: true,
            name: "fieldofstudy",
            title: "Field of study",
            controller: fieldOfStudyController,
            onChanged: (p0) {},
            getid: (p0) {},
            contextIn: context,
            hintText: "Type to search",
          ),

          const SizedBox(
            height: 10,
          ),
          const customTextForWeather(
            title: "Start Year*",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: MonthDropdown(
                  controller: firstMonthController,
                  //focusNode: firstmonthfocus,
                  hint: firstMonthController.text.isNotEmpty
                      ? firstMonthController.text
                      : "Select Month",
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: DropDownYear(
                      firstYearController.text.isNotEmpty
                          ? firstYearController.text
                          : "Select Year",
                      firstYearController,
                      true)),
            ],
          ),
          if (!currentlyStudying)
            const SizedBox(
              height: 10,
            ),
          if (!currentlyStudying)
            const customTextForWeather(
              title: "End Year*",
            ),
          if (!currentlyStudying)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: MonthDropdown(
                      controller: endMonthController,
                      // focusNode: firstmonthfocus,
                      hint: endMonthController.text.isNotEmpty
                          ? endMonthController.text
                          : "Select Month",
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: DropDownYear(
                        endYearController.text.isNotEmpty
                            ? endYearController.text
                            : "Select Year",
                        endYearController,
                        false)),
              ],
            ),

          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    side: const BorderSide(color: Colors.white),
                    activeColor: Colors.white,
                    checkColor: Constants.themeBgColor,
                    visualDensity: VisualDensity.compact,
                    value: currentlyStudying,
                    onChanged: (newValue) {
                      setState(() {
                        currentlyStudying = !currentlyStudying;
                        endMonthController.clear();
                        endYearController.clear();
                        marksheet = null;
                      });
                      // Notify Flutter that the state has changed
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              const customTextForWeather(
                  title: "I am currently studying here."),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          if (marksheet != null)
            CustomContainerSelectToViewDoc(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CustomPDFViewerDialog(
                        pdfUrl:
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$marksheet",
                        onRemove: () async {
                          await FileUploadService()
                              .deleteSingleFile(marksheet!);
                          setState(() {
                            marksheet = null;
                          });
                        },
                        onReplace: () {},
                      );
                    },
                  );
                },
                title: "Uploaded Marksheet"),
          if (marksheet == null && !currentlyStudying)
            CustomDocumentUploadButton(
                onTab: () async {
                  FileUploader fileUploader = FileUploader();

                  marksheet = await fileUploader.uploadFile(
                      context, ['pdf'], "Marksheet");
                  setState(() {});
                },
                title: "Add Marksheet"),
          SizedBox(
            height: 10.h,
          ),
          if (marksheet == null && !currentlyStudying)
            const customTextForWeather(
              title:
                  "Add your marksheets here. These confidential document are only visible to recruiters",
              fontSize: 10,
              color: Constants.subtitleclr,
            ),

          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
          const SizedBox(
            height: 50,
          ),
          if (widget.isEdit && widget.edulength != 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: InkWell(
                      onTap: () async {
                        /*  widget.educationList!.length <= 1
                                ? */
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EducationSelectionDialog(
                              explegth: widget.edulength,
                              type: "edu",
                              text: "Education",
                              id: widget.prevPageModel!.id!.toInt(),
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        "assets/images/bin.gif",
                        height: 40.h,
                      ) /* Text(
                        "Delete Education",
                        style: GoogleFonts.varela(color: Colors.red),
                      ) */
                      ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget DropDownYear(
      String hint, TextEditingController controller, bool isFirst) {
    late List<int> years;
    late int currentYear;
    int? selectedYear;
    currentYear = DateTime.now().year;

    int startYear =
        int.tryParse(isFirst ? "1995" : firstYearController.text) ?? 1995;
    years = isFirst
        ? List.generate(
                currentYear - startYear + 1, (index) => startYear + index)
            .reversed
            .toList()
        : List.generate(
            currentYear - startYear + 1, (index) => startYear + index);

    return DropdownButtonFormField<int>(
      value: selectedYear,
      hint: customTextForMonst(title: hint),
      isDense: true, // Reduce default dropdown height
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Constants.black),
            borderRadius: BorderRadius.circular(8)),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Constants.subtitleclr)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Constants.subtitleclr),
            borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color:
                  selectedYear != null ? Colors.black : Constants.subtitleclr),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: years
          .map((year) => DropdownMenuItem<int>(
                value: year,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedYear == year
                          ? Colors.black
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  child: customTextForMonst(title: year.toString()),
                ),
              ))
          .toList(),

      onChanged: (value) {
        setState(() {
          selectedYear = value;
          controller.text = value.toString();
        });
      },
      // Limits dropdown height to show 5 elements
    );
  }

  bool isLoading = false;

  save() async {
    setState(() {
      isLoading = true;
    });

    Map<String, int> monthMapping = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };
    int? startmonth = monthMapping[firstMonthController.text.toString()];
    int? endmonth = monthMapping[endMonthController.text.toString()];

    SharedPreferences prefs = await Utils.getSharedPreferences();

    ProfileUpdateRequestDto profileUpdateRequestDto =
        ProfileUpdateRequestDto(id: widget.userid, skills: widget.profileskill);
    EducationRequestDto educationRequestDto = EducationRequestDto(
        id: widget.isEdit == true ? widget.prevPageModel?.id : null,
        userId: widget.userid,
        //level: "Graduate",
        university: universityController.text,
        isRemote: isremote ? 1 : 0,
        schoolOrCollegeName: schoolcollegeName.text,
        degreeSpc: degreeController.text,
        fieldOfStudy: fieldOfStudyController.text,
        endMonth: currentlyStudying ? null : endmonth,
        startMonth: startmonth,
        firstYear: firstYearController.text.isNotEmpty
            ? int.parse(firstYearController.text)
            : null,
        passingYear:
            currentlyStudying ? null : int.tryParse(endYearController.text),
        isCurrent: currentlyStudying ? 1 : 0,
        marksheet: marksheet.toString());

    UserUpdateRequestModel userUpdateRequestModel = UserUpdateRequestModel(
        certificationsRequestDtos: null,
        educationRequestDtos: [educationRequestDto],
        experienceRequestDtos: null,
        profileUpdateRequestDto: profileUpdateRequestDto);

    // Create an instance of UserDataService
    UserDataService userDataService = UserDataService();

    // Call the saveUserExperience method on the instance
    await JobPostApiService.PostUserInfo(userUpdateRequestModel);

    setState(() {
      isLoading = false;
    });
    ref.refresh(ProfileDataProvider);
    ref.refresh(userDataProvider);

    Navigator.pop(context);
    if (widget.edulength > 1) {
      Navigator.pop(context);
    }
    CustomSnackbar.show(
        widget.isEdit
            ? "Qualification Updated Succesfully"
            : "Qualification Added Succesfully",
        false);

    // await userDataService.saveUserEducation(model.toMap()); //TODO: Old one.....
    /*  if (widget.prevPageModel == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else { */

    //  }
  }
}
