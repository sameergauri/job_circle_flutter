// ignore_for_file: unused_result, prefer_typing_uninitialized_variables, unused_element, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, non_constant_identifier_names, use_full_hex_values_for_flutter_colors, unnecessary_null_comparison
// ignore_for_file: todo
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/user_data_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/month_drop_down.dart';
import 'package:job_circle/screens/onboarding/add_certificate.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../models/autocompleteModel.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';

class AddEducation extends ConsumerStatefulWidget {
  final int userID;
  final UserRequest introData;
  final ExperienceRequest? experience;
  final bool isexperience;
  final bool isUnderGraduate;
  final List<dynamic>? selectedSkillSet;

  const AddEducation({
    this.experience,
    required this.introData,
    required this.userID,
    this.selectedSkillSet,
    required this.isexperience,
    required this.isUnderGraduate,
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
  late TextEditingController firstMonthController = TextEditingController();
  late TextEditingController passingYearController = TextEditingController();
  late TextEditingController passingMonthController = TextEditingController();
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

  String? Marksheetfile;

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
            bottomNavigationBar: CustomButtonForSave(
              title: "Next",
              onTap: () async {
                int? firstyear =
                    int.tryParse(firstYearController.text.toString());
                int? passingyear =
                    int.tryParse(passingYearController.text.toString());
                if (!distanceEducation && schoolCollegName.text.isEmpty) {
                  CustomSnackbar.show(
                    "School College name is mandatory",
                    true,
                  );
                } else if (universityController.text.isEmpty) {
                  CustomSnackbar.show(
                    "Select or add university",
                    true,
                  );
                } else if (degreeController.text.isEmpty) {
                  CustomSnackbar.show(
                    "Select or add degree",
                    true,
                  );
                } else if (fieldOfStudyController.text.isEmpty) {
                  CustomSnackbar.show(
                    "Provide field of study",
                    true,
                  );
                } else if (firstYearController.text.isEmpty ||
                    firstMonthController.text.isEmpty) {
                  CustomSnackbar.show(
                    "Start date missing",
                    true,
                  );
                } else if ((passingYearController.text.isEmpty ||
                        passingMonthController.text.isEmpty) &&
                    !currentlyStudying) {
                  CustomSnackbar.show(
                    "Passing year missing",
                    true,
                  );
                } else if ((passingyear != null && firstyear != null) &&
                    (firstyear > passingyear)) {
                  CustomSnackbar.show(
                      "Passing year should be greater the start year", true);
                } else {
                  save();
                }
              },
            ),
            appBar: AppBar(
              backgroundColor: Constants.borderColor,
              automaticallyImplyLeading: true,
              elevation: 0,
              iconTheme: const IconThemeData(color: Constants.black),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingAppBarHeading(),
                  OnboardingAppBarSubTitle()
                ],
              ),
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(top: kToolbarHeight / 6.h),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.sp, left: 10.sp, right: 10.sp),
                        child: LinearProgressIndicator(
                          value: 0.668,
                          // value: _calculateProgress(, // Set progress value
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 9.9.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.sp, top: 10.sp, bottom: 10.sp),
                        child: const OnboardingTitle(
                          title: "Add Education",
                        ),
                      ),
                      _education(),
                    ],
                  ),
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
  FocusNode firstmonthfocus = FocusNode();
  FocusNode finalmonthfocus = FocusNode();

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
            width: MediaQuery.of(context).size.width,

            //height: MediaQuery.of(context).size.height / 30,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: EdgeInsets.only(
              bottom: 7.h,
            ),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2.1,
                    spreadRadius: 2.1,
                    offset: const Offset(1.0, 2.0))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50.h,
                  width: 50.w,
                  child: Image.asset(
                    "assets/images/documentStatus.png",
                    fit: BoxFit.fill,
                    //size: 18.h,
                  ),
                ),
                SizedBox(
                  width: 6.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.varela(
                            fontWeight: FontWeight.normal,
                            color: Constants.black,
                            fontSize: 12.sp)),
                    Text(
                        DateFormat("MMM d, yyyy, h:mm a")
                            .format(DateTime.now()),
                        style: GoogleFonts.varela(
                            fontWeight: FontWeight.normal,
                            color: Constants.subtitleclr,
                            fontSize: 10.sp)),
                  ],
                ),
              ],
            )));
  }
  /*  InkWell customContainerSelectToViewDoc({
    required final VoidCallback onPressed,
    required String title,
  }) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: MediaQuery.of(context).size.width,

            //height: MediaQuery.of(context).size.height / 30,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: EdgeInsets.only(
              bottom: 7.h,
            ),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2.1,
                    spreadRadius: 2.1,
                    offset: const Offset(1.0, 2.0))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.picture_as_pdf_outlined,

                  color: Constants.themeBgColor,
                  //size: 18.h,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(title,
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.normal,
                        color: Constants.black,
                        fontSize: 12.sp)),
              ],
            )));
  } */

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

  TextEditingController schoolCollegName = TextEditingController();
  FocusNode focusNode = FocusNode();

  Widget customWidgetGraduation() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextForWeather(
            title: distanceEducation
                ? "School / College Name"
                : "School / College Name*",
          ),
          /*   CustomTextField(
              context: context,
              hint: "Enter Youor School or College Name",
              label: "label",
              focusNode: focusNode,
              controller: schoolCollegName), */
          CustomJobTitleForExperience(
            onIDSelected: () {},
            // isSelected: isIndustry,
            //focusNode: titleFocus,
            role: "",
            isCompany: false,
            isIndustry: true,
            name: "school",
            title: "School / College name",
            controller: schoolCollegName,
            onChanged: (p0) {},
            getid: (p0) {},
            contextIn: context,
            hintText: "School or college name",
          ),
          /*  CustomTextFieldComapanyLocation(
            university: false,
            hsc: false,
            degree: true,
            labelText: "Degree / Specialization",
            title: "",
            isCity: true,
            contextIn: context,
            role: "",
            hintText: "Type to searchs",
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
            controller: schoolCollegName,
            onChanged: (p0) {
              isGraduateDeg = true;
            },
            icon: const Icon(Icons.workspace_premium_outlined),
          ), */
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
                    value: distanceEducation,
                    onChanged: (newValue) {
                      setState(() {
                        distanceEducation = !distanceEducation;
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
          SizedBox(
            height: 10.h,
          ),
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
          /* CustomTextFieldComapanyLocation(
            university: true,
            degree: false,
            labelText: !isundergradute ? "University / Institute" : "Board",
            title: "",
            isCity: true,
            hsc: false,
            contextIn: context,
            role: "",
            hintText: "Type to search",
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
          ), */
          const SizedBox(height: 10),
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
          /* CustomTextFieldComapanyLocation(
            university: false,
            hsc: false,
            degree: true,
            labelText: "Degree / Specialization",
            title: "",
            isCity: true,
            contextIn: context,
            role: "",
            hintText: "Select Degree",
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
          ), */
          SizedBox(
            height: 10.h,
          ),
          const customTextForWeather(
            title: "Field of Study*",
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
          /*  CustomTextFieldComapanyLocation(
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
          ), */
          /* : Container(
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
                                border:
                                    Border.all(color: Constants.themeBgColor)),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.h, horizontal: 8),
                            child: Text(
                              "Science",
                              style: GoogleFonts.varela(
                                  fontWeight: science
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: science ? Colors.white : Colors.black),
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
                                border:
                                    Border.all(color: Constants.themeBgColor)),
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
                                color:
                                    art ? Constants.themeBgColor : Colors.white,
                                border:
                                    Border.all(color: Constants.themeBgColor)),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.h, horizontal: 8),
                            child: Text(
                              "Art",
                              style: GoogleFonts.varela(
                                  fontWeight:
                                      art ? FontWeight.bold : FontWeight.normal,
                                  color: art ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )), */
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
                  hint: "Select Month",
                ),
              ),
              /*  CustomTextField(
                  maxLength: 4,
                  isNumber: true,
                  context: context,
                  hint: "Year",
                  label: "First Year",
                  focusNode: firstyearfocus,
                  controller: firstYearController,
                  icon: const Icon(Icons.edit_calendar)), */
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: DropDownYear("Select Year", firstYearController, true)
                  /*  YearDropdown(
                  previousyear: firstYearController.text,
                  controller: firstYearController,
                  focusNode: firstyearfocus,
                  hint: "Select Year",
                  isNumber: true,
                  maxLength: 4,
                ), */
                  ),
            ],
          ),
          if (!currentlyStudying) const SizedBox(height: 10),
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
                    controller: passingMonthController,
                    hint: "Select Month",
                  ),
                ),
                /*  CustomTextField(
                  maxLength: 4,
                  isNumber: true,
                  context: context,
                  hint: "Month",
                  label: "Final Year",
                  focusNode: finalyearfocus,
                  controller: passingYearController,
                  icon: const Icon(Icons.edit_calendar)), */
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child:
                      DropDownYear("Select Year", passingYearController, false),
                ),
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
          if (Marksheetfile != null)
            CustomContainerSelectToViewDoc(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CustomPDFViewerDialog(
                        pdfUrl:
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$Marksheetfile",
                        onRemove: () async {
                          await FileUploadService()
                              .deleteSingleFile(Marksheetfile!);
                          setState(() {
                            Marksheetfile = null;
                          });
                        },
                        onReplace: () {},
                      );
                    },
                  );
                },
                title: "Uploaded Marksheet"),
          if (Marksheetfile == null && !currentlyStudying)
            CustomDocumentUploadButton(
                onTab: () async {
                  FileUploader fileUploader = FileUploader();

                  Marksheetfile = await fileUploader.uploadFile(
                      context, ['pdf'], "Marksheet");
                  setState(() {});
                  /* setState(() async {
                    Marksheetfile = await uploadFile(['pdf']);
                  });
                  setState(() {}); */
                },
                title: "Add Marksheet"),
          SizedBox(
            height: 10.h,
          ),
          if (Marksheetfile == null && !currentlyStudying)
            const customTextForWeather(
              title:
                  "Add your marksheets here. These confidential document are only visible to recruiters",
              fontSize: 10,
              color: Constants.subtitleclr,
            ),
          /*  if (isgraduate || isundergradute)
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
            ) */
        ],
      ),
    );
  }

  bool currentlyStudying = false;
  bool distanceEducation = false;

  /* saveEducation(data) async {    //TODO:: SaveEducation too save education....
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      print("done");
    }
    setState(() {});
  } */
  Widget DropDownYear(
      String hint, TextEditingController controller, bool isFirst) {
    late List<int> years;
    late int currentYear;
    int? selectedYear;
    currentYear = DateTime.now().year;

    int startYear =
        int.tryParse(isFirst ? 1995.toString() : firstYearController.text) ??
            1995;
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
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: years
          .map((year) => DropdownMenuItem<int>(
                value: year,
                child: customTextForMonst(title: year.toString()),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value;
          controller.text = value.toString();
          setState(() {});
        });
      },
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
    int? endmonth = monthMapping[passingMonthController.text.toString()];

    EducationRequest education = EducationRequest(
        id: 0,
        schoolOrCollegeName: schoolCollegName.text,
        university: universityController.text,
        degreeSpc: degreeController.text,
        fieldOfStudy: fieldOfStudyController.text,
        firstYear: int.tryParse(firstYearController.text),
        passingYear:
            currentlyStudying ? null : int.tryParse(passingYearController.text),
        endMonth: currentlyStudying ? null : endmonth,
        startMonth: startmonth,
        isCurrent: currentlyStudying ? 1 : 0,
        isRemote: distanceEducation == true ? 1 : 0,
        marksheet: Marksheetfile);
/* 
    EducationRequest model = EducationRequest();

    if (!isSkip) {
      model = EducationRequest(
          id: 0,
          userId: 0,
          //board: !isundergradute ? null : boardController.text,
          //level: "Graduate",
          university: !isundergradute ? universityController.text : null,
          //  degree_spc: isundergradute ? "H.S.C" : degreeController.text,
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
              isundergradute ? null : int.parse(passingYearController.text));
      //  marksheet: marksheet,
      //degree_id: degreeId,
      //fieldofstudy_id: fieldId,
      //university_id: universityId);
    } */

    // Create an instance of UserDataService
    UserDataService userDataService = UserDataService();
    //
    //
    //
    //
    //
    //
    /*  if (widget.jobtitleid == 0) {  //TODO::  Old code to save all info before cv page.....
      JobPostApiService.saveJobRole(
          context, widget.experience!.job_title.toString());
    }
    if (widget.experience!.userId != null) {
      await JobPostApiService.PostUserExperience(
          widget.experience!.toJson(), context);
      // await userDataService.saveUserExperience(widget.experience.toJson());
    }
    if (!isSkip) {
      await userDataService.saveUserEducation(model.toMap());
    }
    await JobPostApiService.PostUserInfo(widget.introData);
    /* await JobPostApiService.updateLanguages(
        widget.languageModel, widget.userID); */ //TODO:: Language model....
    ref.refresh(userDataProvider);

    ref.refresh(profileSummaryProvider); */
    //
    //
    //
    //
    //
    //
    //
    //
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddCertificate(
                introData: widget.introData,
                education: education,
                isUnderGraduate: widget.isUnderGraduate,
                isexperience: widget.isexperience,
                userID: widget.userID,
                experience: widget.experience,
                selectedSkillSet: widget.selectedSkillSet,
              )),
    );
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
    width: MediaQuery.of(context).size.width / 2.5,
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

      keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
      //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
      textCapitalization: TextCapitalization.sentences,
      controller: controller.text != "0" ? controller : null,
      onTap: (() {
        showYearPicker(context);
      }),
      style: GoogleFonts.varela(color: Constants.black, fontSize: 12.sp),
      decoration: InputDecoration(
          filled: isPrimaryNumber! ? true : false,
          fillColor:
              isPrimaryNumber ? Colors.grey.shade200 : Colors.transparent,
          contentPadding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
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

Future<int?> showYearPicker(BuildContext context) async {
  int currentYear = DateTime.now().year;
  List<int> years = List.generate(currentYear - 1994, (index) => 1995 + index);

  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select a Year"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: years.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(years[index].toString()),
                onTap: () {
                  Navigator.of(context).pop(years[index]);
                },
              );
            },
          ),
        ),
      );
    },
  );
}

/* class YearDropdown extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool isNumber;
  final int maxLength;
  final String previousyear;

  const YearDropdown({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.previousyear,
    this.hint = "Select Year",
    this.isNumber = true,
    this.maxLength = 4,
  });

  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  late List<int> years;
  late int currentYear;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    _initializeYears();
  }

  @override
  void didUpdateWidget(covariant YearDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if `previousyear` has changed.
    if (oldWidget.previousyear != widget.previousyear) {
      _initializeYears();
    }
  }

  void _initializeYears() {
    currentYear = DateTime.now().year;

    int startYear = int.tryParse(widget.previousyear) ?? 1995;
    years = List.generate(
        currentYear - startYear + 1, (index) => startYear + index);

    if (years.contains(int.tryParse(widget.previousyear))) {
      selectedYear = int.tryParse(widget.previousyear);
      widget.controller.text = selectedYear.toString();
    } else {
      selectedYear = null;
    }

    setState(() {}); // Trigger a rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          value: selectedYear,
          hint: Text(widget.hint),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: years
              .map((year) => DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedYear = value;
              widget.controller.text = value.toString();
            });
          },
        ),
      ],
    );
  }
} */

