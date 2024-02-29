// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_element, use_full_hex_values_for_flutter_colors, avoid_print, avoid_unnecessary_containers, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/custom_textfield_for_profile.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/onboarding/add_education.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../constants/customTextfield.dart';
import '../../models/autocompleteModel.dart';
import '../../service/UserDataService.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({
    required this.languageModel,
    required this.userID,
    required this.introData,
    super.key,
  });
  final Map<String, dynamic> languageModel;
  final int userID;
  final Map<String, dynamic> introData;

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  late Widget previousWidget;
  // CardModel model = CardModel();
  //bool expirieanceFlag = false;
  late ProfileSummaryModel? prevPofileModel;

  var ddlValues;
  late TextEditingController jobTitleController = TextEditingController();
  late TextEditingController companyController = TextEditingController();
  late TextEditingController companyLocationController =
      TextEditingController();
  late TextEditingController companyWebsiteController = TextEditingController();
  late TextEditingController skillsController = TextEditingController();
  late TextEditingController totalOfExpController = TextEditingController();
  late TextEditingController currentSalaryController = TextEditingController();
  late TextEditingController joiningDataController = TextEditingController();
  late TextEditingController lastWorkingController = TextEditingController();
  late TextEditingController description = TextEditingController();

  late List<AutoCompleteModel> jobTitleList = [];
  late List<AutoCompleteModel> totalExperienceList = [];
  late List<AutoCompleteModel> currentSalaryList = [];
  AutoCompleteModel selectedJobTitle = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedtotalExperience = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedcurrentSalary = AutoCompleteModel("", "", {});

  List<String> fetchApiskill = [];
  String? fetchApiGender;
  FocusNode titleFocus = FocusNode();
  FocusNode cmpnyFocusNode = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode salaryFocus = FocusNode();
  FocusNode skillFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  FocusNode joiningDateFocus = FocusNode();

  String work_type = "";
  String availability = "";
  String bank_statement = "";
  String appointment_letter = "";
  String salary_slip = "";
  String experience_lettter = "";
  String working = "";
  List<dynamic> selectedValuesList = [];
  List<String> selectedValues = [];
  int? expID;
  bool? isJobTitlle = false;
  List<dynamic> jobTitleSuggestion = [];
  int? userID;

  bool isEdit1 = false;
  bool isEdit2 = false;
  bool isCompanyName = false;
  bool isCompanyLocation = false;
  bool isCOmpanyWebsite = false;
  bool isCurrentSalary = false;
  bool isJoiningDate = false;
  bool isLastWorkingDate = false;
  bool isEdit8 = false;
  bool isEdit9 = false;
  bool isEdit10 = false;
  bool isOnsite = false;
  bool isHybrid = false;
  bool isWfh = false;
  bool isMonthly = false;
  bool isYearly = false;
  bool yes = false; // Set the initial value based on your logic
  bool no = false;
  bool currentlyWorking = false;
  var dt;
  bool apportunities = false;

  DateTime joiningDateValue = DateTime.now();
  DateTime lastWorkingDateValue = DateTime.now();

  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  int? jobtitleId;
  int? workcityId;

  DateTime? selectedJoiningDate;
  DateTime? selectedLastWorkingDate;

  /* void selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        joiningDataController.text =
            pickedDate.toString(); // Update the TextFormField text
      });
    }
  } */
  void selectDateForJoiningDay() async {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedJoiningDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    String formatDate(DateTime date) {
      final formatter = DateFormat('dd-MMM-yyyy');
      return formatter.format(date);
    }

    bool isDateLess = false;

    setState(() {
      selectedJoiningDate = pickedDate;
      joiningDataController.text = formatDate(pickedDate!);
      //  dataOfBirthValue = pickedDate; // Update the TextFormField text
    });
    // Agar koi match nahi mila toh aap kuch aur kar sakte hain

    /* if (pickedDate != null &&
        pickedDate != widget.experiencelist!.map((e) => e.joining_date)) {
      setState(() {
        selectedJoiningDate = pickedDate;
        joiningDataController.text = formatDate(pickedDate);
        //  dataOfBirthValue = pickedDate; // Update the TextFormField text
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar("Already selected in your previous experience"));
    } */
  }

  DateTime? selectedLastDateofPrevious;

  void selectDateForLastWorkingDayForPResent() async {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedJoiningDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    String formatDate(DateTime date) {
      final formatter = DateFormat('dd-MMM-yyyy');
      return formatter.format(date);
    }

    if (pickedDate != null) {
      setState(() {
        selectedLastDateofPrevious = pickedDate;
        // lastWorkingController.text = formatDate(pickedDate);
        //  dataOfBirthValue = pickedDate; // Update the TextFormField text
      });
    }
  }

  void selectDateForLastWorkingDay() async {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedJoiningDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    String formatDate(DateTime date) {
      final formatter = DateFormat('dd-MMM-yyyy');
      return formatter.format(date);
    }

    if (pickedDate != null) {
      setState(() {
        selectedLastWorkingDate = pickedDate;
        lastWorkingController.text = formatDate(pickedDate);
        //  dataOfBirthValue = pickedDate; // Update the TextFormField text
      });
    }
  }

  String? jobTitle, pId;

  void selectLastWorkingDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedLastWorkingDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedLastWorkingDate = pickedDate;
        lastWorkingController.text =
            pickedDate.toString(); // Update the TextFormField text
      });
    }
  }

  String? someid;
  void getSuggestionList(String id) {
    setState(() {
      someid = id;
    });
  }

  void getValueOfJobtitle(String getJobTitle) async {
    setState(() {
      jobTitle = getJobTitle;
    });
  }

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
  void initState() {
    bindJobTitle();
    bindTotalExperiance();
    bindCurrentSalary();
    bindProfileSummary();
    titleFocus.requestFocus();

    final DateFormat dateFormatter = DateFormat('dd,MMM,yyyy');

    setState(() {
      //  userID = widget.prevPageModel!.userId;
    });

    super.initState();
  }

  bindJobTitle() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'job_role', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      jobTitleList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        //selectedJobTitle = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindTotalExperiance() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'total_exp', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      totalExperienceList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedtotalExperience = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindCurrentSalary() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'current_salary', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      currentSalaryList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        //selectedcurrentSalary = AutoCompleteModel("0", "", {});
      });
    }
  }

  bool isPresent = false;
  bool month = false,
      year = false,
      skill1 = false,
      skill2 = false,
      skill3 = false,
      onsite = false,
      hybrid = false,
      wfh = false,
      offerletter = false,
      salrysleep = false,
      bankstmt = false,
      increament = false,
      appontment = false,
      experienceletter = false,
      onNoticePeriod = false,
      imd = false,
      day15 = false,
      day30 = false,
      day60 = false,
      day90 = false,
      isAvail = false;

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        companyController.clear();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            iconTheme: const IconThemeData(color: Constants.themeBgColor),
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Employment Detail",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Constants.themeBgColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        "Introduce your experience to the recruiters",
                        style: GoogleFonts.varela(
                            color: Colors.grey.shade600,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      //const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          bottomNavigationBar: ((jobTitleController.text.isNotEmpty &&
                      companyController.text.isNotEmpty) ||
                  yes)
              ? InkWell(
                  onTap: () async {
                    if (jobTitleController.text.isEmpty && !yes) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(CustomSnackbarfinal(
                        title: "Job title is not optional",
                        error: true,
                      ));
                    } else if (companyController.text.isEmpty && !yes) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(CustomSnackbarfinal(
                        title: "Company is not optional",
                        error: true,
                      ));
                    } else if (!isPartTime &&
                        !isFullTime &&
                        !isContract &&
                        !isIntern &&
                        !yes) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(CustomSnackbarfinal(
                        title: "Specify your Employment type.",
                        error: true,
                      ));
                    } else if (companyLocationController.text.isEmpty && !yes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbarfinal(
                              title: "Provide your work city", error: true));
                    } else if (!isOnsite && !isHybrid && !isWfh && !yes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbarfinal(
                              title: "Specify your Work Mode / Type",
                              error: true));
                    } else if (fetchApiskill.isEmpty && !yes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbarfinal(
                              title:
                                  "Add skills that match your Job Responsibilities.",
                              error: false));
                    } else if (joiningDataController.text.isEmpty && !yes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbarfinal(
                              title: "Enter your employment Start date",
                              error: true));
                    } else if (!currentlyWorking &&
                        lastWorkingController.text.isEmpty &&
                        !yes) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(CustomSnackbarfinal(
                        title: "Enter your employment End date",
                        error: true,
                      ));
                    } else if (currentSalaryController.text.isNotEmpty &&
                        (!isMonthly && !isYearly)) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(CustomSnackbarfinal(
                        title:
                            "Specify whether the salary is on a per month (pm) or per annum (pa) basis?.",
                        error: true,
                      ));
                    } else if (currentSalaryController.text.isEmpty &&
                        (isMonthly || isYearly)) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(CustomSnackbarfinal(
                        title: "Specify your current salary.",
                        error: true,
                      ));
                    } else if (apportunities &&
                        (!imd && !day15 && !day30 && !day60 && !day90)) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(CustomSnackbarfinal(
                        title: "Specify your availability to join.",
                        error: true,
                      ));
                    } else {
                      var payload = {
                        "stage": "experience",
                        "data": {
                          "id": await Utils.getPreferencesValue(
                              null, ESharedPreferences.user_id.name),
                          "experience": yes ? 0 : 1,
                        }
                      };
                      await saveExperience(payload);
                      save();
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
                          "Next",
                          style: GoogleFonts.varela(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(children: [
                _education(),
              ]),
            ),
          )),
    );
  }

  /* SnackBar customSnackbar(String title) {
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
  } */

  bool Enable = false;

  Widget _education() {
    return Container(
      key: const Key('second'),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            value: yes,
                            onChanged: (newValue) {
                              setState(() {
                                yes = !yes;
                              });
                              if (yes) {
                                setState(() {
                                  Enable = true;
                                });
                              } else {
                                Enable = false;
                              }

                              setState(() {
                                isEdit1 = false;
                                isEdit2 = false;
                                jobTitleController.clear();
                                companyController.clear();
                                description.clear();
                                fetchApiskill.clear();
                                isOnsite = false;
                                isHybrid = false;
                                isWfh = false;
                                companyLocationController.clear();
                                isFullTime = false;
                                isPartTime = false;
                                isContract = false;
                                isIntern = false;
                                joiningDataController.clear();
                                lastWorkingController.clear();
                                currentlyWorking = false;
                                currentSalaryController.clear();
                                year = false;
                                month = false;
                                offerLetter = null;
                                appointmentLetter = null;
                                alarySlip = null;
                                incrementLetter = null;
                                experienceLetter = null;
                                imd = false;
                                day15 = false;
                                day30 = false;
                                day60 = false;
                                day90 = false;
                                apportunities = false;
                              });

                              log(yes.toString());
                              // Notify Flutter that the state has changed
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Text("I am Fresher.")
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const Divider(
                        color: Colors.black, // Customize the Divider as needed
                      ),
                      Container(
                        color: Colors.white, // Background color of the text
                        padding: const EdgeInsets.all(
                            8.0), // Adjust padding as needed
                        child: Text(
                          "OR",
                          style:
                              GoogleFonts.varela(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Enable
                      ? Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25.h,
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.badge_outlined),
                                    prefixIconColor: Constants.themeBgColor,
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    counterText: '',
                                    labelText: "Job Title",
                                    labelStyle: const TextStyle(
                                      color: Constants.themeBgColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Color(0xffff0eceb)),
                                    ),
                                    focusColor: const Color(0xffff0eceb),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                        color: Constants.themeBgColor,
                                      ),
                                    ),
                                    // hintText: hint,
                                    hintStyle: GoogleFonts.sourceSansPro(
                                        color: Constants.hintColor,
                                        fontSize: 15.sp)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25.h,
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.badge_outlined),
                                    prefixIconColor: Constants.themeBgColor,
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    counterText: '',
                                    labelText: "Company",
                                    labelStyle: const TextStyle(
                                      color: Constants.themeBgColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Color(0xffff0eceb)),
                                    ),
                                    focusColor: const Color(0xffff0eceb),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                        color: Constants.themeBgColor,
                                      ),
                                    ),
                                    // hintText: hint,
                                    hintStyle: GoogleFonts.sourceSansPro(
                                        color: Constants.hintColor,
                                        fontSize: 15.sp)),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: isEdit2
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25.h,
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                                Icons.badge_outlined),
                                            prefixIconColor:
                                                Constants.themeBgColor,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 10,
                                                    right: 10),
                                            counterText: '',
                                            labelText: jobTitleController.text,
                                            labelStyle: const TextStyle(
                                              color: Constants.themeBgColor,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffff0eceb)),
                                            ),
                                            focusColor:
                                                const Color(0xffff0eceb),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              borderSide: const BorderSide(
                                                color: Constants.themeBgColor,
                                              ),
                                            ),
                                            // hintText: hint,
                                            hintStyle:
                                                GoogleFonts.sourceSansPro(
                                                    color: Constants.hintColor,
                                                    fontSize: 15.sp)),
                                      ),
                                    )
                                  : CustomJobTitleForExperience(
                                      onIDSelected: () {},
                                      // isSelected: isIndustry,
                                      //focusNode: titleFocus,
                                      role: "",
                                      isCompany: false,
                                      isIndustry: true,
                                      name: "job_role",
                                      title: "Job Title",
                                      controller: jobTitleController,
                                      onChanged: (p0) {
                                        setState(() {
                                          isEdit1 = p0;
                                        });
                                      },
                                      getid: (p0) {
                                        jobtitleId = p0;
                                        print(p0);
                                      },
                                      contextIn: context,
                                      hintText: "Sales Manager",
                                    ),
                            ),
                            const SizedBox(height: 10),
                            isEdit2
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        25.h,
                                    child: TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                              Icons.domain_add_outlined),
                                          prefixIconColor:
                                              Constants.themeBgColor,
                                          contentPadding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 8,
                                              left: 10,
                                              right: 10),
                                          counterText: '',
                                          labelText: companyController.text,
                                          labelStyle: const TextStyle(
                                            color: Constants.themeBgColor,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                                color: Color(0xffff0eceb)),
                                          ),
                                          focusColor: const Color(0xffff0eceb),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                              color: Constants.themeBgColor,
                                            ),
                                          ),
                                          // hintText: hint,
                                          hintStyle: GoogleFonts.sourceSansPro(
                                              color: Constants.hintColor,
                                              fontSize: 15.sp)),
                                    ),
                                  )
                                : customCompanyforExperience(
                                    onTapCallback: () {},
                                    focusNode: cmpnyFocusNode,
                                    isCompany: true,
                                    name: "company",
                                    getid: getSuggestionList,
                                    /* onFocusNodeRequested: (p0) {
                                  focusNode.requestFocus();
                                }, */
                                    title: "Client Name",
                                    controller: companyController,
                                    // isEdit: isEdit,
                                    //  focusNode: focusNode,
                                    onChanged: (p0) {
                                      setState(() {
                                        isEdit2 = true;
                                      });
                                    },
                                    contextIn: context,
                                    //  onSubmit: (p0) {},
                                    hintText: "Aditya birla Health Insurance",
                                    // getSuggestions: getSuggestions,
                                    onIDSelected: () {}),
                          ],
                        ),

                  /*                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company Name",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      isCompanyName
                          ? customContainerSelect(
                              isVacancy: true,
                              isCross: true,
                              isAnother: true,
                              isNumOfOpening: false,
                              onPressed: () {
                                setState(() {
                                  isCompanyName = false;
                                  // FocusScope.of(context).autofocus(focusNode);
                                  companyController.clear();
                                  // titleFocus.requestFocus();
                                });
                              },
                              isSelect: true,
                              title: companyController.text)
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
                                        companyController.text.isNotEmpty
                                            ? setState(() {
                                                isCompanyName = true;
                                                // _showContainer1 = value.isEmpty;
                                              })
                                            : null;
                                      },
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      onTapOutside: (event) {
                                        companyController.text.isNotEmpty
                                            ? setState(() {
                                                isCompanyName = true;
                                                // _showContainer1 = value.isEmpty;
                                              })
                                            : null;
                                      },
                                      onEditingComplete: () {
                                        companyController.text.isNotEmpty
                                            ? setState(() {
                                                isCompanyName = true;
                                                // _showContainer1 = value.isEmpty;
                                              })
                                            : null;
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: companyController,
                                      // enabled: enableShortListFor,
                                      onTap: (() {}),
                                      decoration: InputDecoration(
                                          counterText: '',
                                          contentPadding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 8,
                                              left: 10,
                                              right: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Color(0xffff0eceb)),
                                          ),
                                          focusColor: const Color(0xffff0eceb),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 122, 113, 111)),
                                          ),
                                          hintText:
                                              "Adity Birla Health Insurance",
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
                  ), */

                  if (jobTitleController.text.isNotEmpty &&
                      companyController.text.isNotEmpty &&
                      1 == 2)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 7.w,
                              child: const Divider(
                                thickness: 1.5,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Is this your current company?",
                              style: GoogleFonts.varela(
                                  color: Constants.themeBgColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 7.w,
                              child: const Divider(
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  yes = true;
                                  no = false;
                                });
                                if (someid == null) {
                                  await JobPostApiService.AddCompanytoMom(
                                      companyController.text.toString());
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                        color: yes
                                            ? Constants.themeBgColor
                                            : Colors.transparent)),
                                child: Text(
                                  "Yes",
                                  style: GoogleFonts.varela(
                                      color: Constants.themeBgColor),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  yes = false;
                                  no = true;
                                });
                                if (someid == null) {
                                  await JobPostApiService.AddCompanytoMom(
                                      companyController.text.toString());
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 4.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                        color: no
                                            ? Constants.themeBgColor
                                            : Colors.transparent)),
                                child: Text(
                                  "No",
                                  style: GoogleFonts.varela(
                                      color: Constants.themeBgColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 10,
                  ),

                  //TODO: All the details view only when any one option from current company is selected.

                  if (jobTitleController.text.isNotEmpty &&
                      companyController.text.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // QuillEditorPage(),
                        CustomTextField(
                            focusNode: descriptionFocus,
                            controller: description,
                            hint: "My Job profile is......",
                            label: "Job Responsibilities",
                            isdescription: true,
                            icon: const Icon(Icons.description)),
                        SizedBox(
                          height: 6.h,
                        ),

                        CustomFormTextFieldMultiSelectForProfile(
                          name: "skills",
                          focusNode: skillFocus,
                          isSkill: true,
                          fetchApiskill: fetchApiskill,
                          title: "Skills Required",
                          controller: skillsController,
                          selectedValuesList: selectedValuesList,
                          callback: updateSelectedValues,
                          contextIn: context,
                          hintText: "Advance Excel",
                        ),
                        SizedBox(
                          height: 6.h,
                        ),

                        // TODO: old code for company location.
                        /* Row(  
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company Location",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 18.sp,
                                // color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600),
                          ),
                          isCompanyLocation
                              ? customContainerSelect(
                                  isVacancy: true,
                                  isCross: true,
                                  isNumOfOpening: false,
                                  isEmails: true,
                                  onPressed: () {
                                    setState(() {
                                      isCompanyLocation = false;
                                      // FocusScope.of(context).autofocus(focusNode);
                                      companyLocationController.clear();
                                      titleFocus.requestFocus();
                                    });
                                  },
                                  isSelect: true,
                                  title: companyLocationController.text)
                              : Container(
                                  width: double.maxFinite,
                                  // height: 55,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5.h),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.32,
                                        height: 35,
                                        color: Colors.white,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This Text field Cant be empty";
                                            }
                                            return null;
                                          },
    
                                          // focusNode: titleFocus,
                                          // maxLength: 3,
                                          onFieldSubmitted: (value) {
                                            companyLocationController
                                                    .text.isNotEmpty
                                                ? setState(() {
                                                    isCompanyLocation = true;
                                                    // _showContainer1 = value.isEmpty;
                                                  })
                                                : null;
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          onTapOutside: (event) {
                                            companyLocationController
                                                    .text.isNotEmpty
                                                ? setState(() {
                                                    isCompanyLocation = true;
                                                    // _showContainer1 = value.isEmpty;
                                                  })
                                                : null;
                                          },
                                          onEditingComplete: () {
                                            companyLocationController
                                                    .text.isNotEmpty
                                                ? setState(() {
                                                    isCompanyLocation = true;
                                                    // _showContainer1 = value.isEmpty;
                                                  })
                                                : null;
                                          },
                                          keyboardType: TextInputType.text,
                                          controller: companyLocationController,
                                          // enabled: enableShortListFor,
                                          onTap: (() {}),
                                          decoration: InputDecoration(
                                              counterText: '',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffff0eceb)),
                                              ),
                                              focusColor:
                                                  const Color(0xffff0eceb),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 122, 113, 111)),
                                              ),
                                              hintText: "Mumbai",
                                              hintStyle:
                                                  GoogleFonts.sourceSansPro(
                                                      color:
                                                          Constants.subtitleclr,
                                                      fontSize: 15.sp)
                                              //  prefixIcon: Icon(Icons.list)
                                              ),
                                        ),
                                      ),
                                    ],
                                  )),
                        ],
                      ),
                      SizedBox(
                        width: 10.h,
                      ),
                      /*  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company Website",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 18.sp,
                                // color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600),
                          ),
                          isCOmpanyWebsite
                              ? customContainerSelect(
                                  isVacancy: true,
                                  isCross: true,
                                  isNumOfOpening: false,
                                  isEmails: true,
                                  onPressed: () {
                                    setState(() {
                                      isCOmpanyWebsite = false;
                                      // FocusScope.of(context).autofocus(focusNode);
                                      companyWebsiteController.clear();
                                      titleFocus.requestFocus();
                                    });
                                  },
                                  isSelect: true,
                                  title: companyWebsiteController.text)
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.32,
                                  // height: 55,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5.h),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.32,
                                        height: 35,
                                        color: Colors.white,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This Text field Cant be empty";
                                            }
                                            return null;
                                          },
                                          // inputFormatters: [
                                          //   FilteringTextInputFormatter.deny(
                                          //       RegExp(r'[.]')),
                                          //   FilteringTextInputFormatter.
                                          // ],
                                          // focusNode: titleFocus,
                                          // maxLength: 3,
                                          onFieldSubmitted: (value) {
                                            companyWebsiteController
                                                    .text.isNotEmpty
                                                ? setState(() {
                                                    isCOmpanyWebsite = true;
                                                    // _showContainer1 = value.isEmpty;
                                                  })
                                                : null;
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          onTapOutside: (event) {
                                            companyWebsiteController
                                                    .text.isNotEmpty
                                                ? setState(() {
                                                    isCOmpanyWebsite = true;
                                                    // _showContainer1 = value.isEmpty;
                                                  })
                                                : null;
                                          },
                                          onEditingComplete: () {
                                            companyWebsiteController
                                                    .text.isNotEmpty
                                                ? setState(() {
                                                    isCOmpanyWebsite = true;
                                                    // _showContainer1 = value.isEmpty;
                                                  })
                                                : null;
                                          },
                                          keyboardType: TextInputType.text,
                                          controller: companyWebsiteController,
                                          // enabled: enableShortListFor,
                                          onTap: (() {}),
                                          decoration: InputDecoration(
                                              counterText: '',
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 8,
                                                      left: 10,
                                                      right: 10),
                                              // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                              // Icons.workspace_premium
                                              // label: const Text("Company Name *"),
                                              //border: OutlineInputBorder(),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffff0eceb)),
                                              ),
                                              focusColor:
                                                  const Color(0xffff0eceb),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 122, 113, 111)),
                                              ),
                                              hintText: "www.jobcircle.co.in",
                                              hintStyle:
                                                  GoogleFonts.sourceSansPro(
                                                      color:
                                                          Constants.subtitleclr,
                                                      fontSize: 15.sp)
                                              //  prefixIcon: Icon(Icons.list)
                                              ),
                                        ),
                                      ),
                                    ],
                                  )),
                        ],
                      ), */
                    ],
                  ), */

                        const SizedBox(
                          height: 2,
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            const Divider(
                              thickness: 1.5, // Customize the Divider as needed
                            ),
                            Container(
                              color:
                                  Colors.white, // Background color of the text
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust padding as needed
                              child: Text(
                                "Work Mode",
                                style: GoogleFonts.varela(
                                    color: Constants.themeBgColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),

                        /*  SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.83.w,
                              child: const Divider(
                                thickness: 1.5,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Work Mode",
                              style: GoogleFonts.varela(
                                  color: Constants.themeBgColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 11.w,
                              child: const Divider(
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ), */

                        Wrap(
                          children: [
                            customContainerSelectForWorkingType(
                              onPressed: () {
                                setState(() {
                                  isHybrid = false;
                                  isOnsite = true;
                                  isWfh = false;
                                });
                              },
                              isSelect: isOnsite,
                              title: "On-Site",
                            ),
                            customContainerSelectForWorkingType(
                              onPressed: () {
                                setState(() {
                                  isHybrid = true;
                                  isOnsite = false;
                                  isWfh = false;
                                });
                              },
                              isSelect: isHybrid,
                              title: "Hybrid",
                            ),
                            customContainerSelectForWorkingType(
                              onPressed: () {
                                setState(() {
                                  isHybrid = false;
                                  isOnsite = false;
                                  isWfh = true;
                                });
                              },
                              isSelect: isWfh,
                              title: "WFH",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),

                        CustomTextFieldComapanyLocation(
                          degree: false,
                          university: false,
                          hsc: false,

                          isCompany: false,
                          name: "city",
                          isCity: true,
                          focusNode: cityFocus,
                          /* onFocusNodeRequested: (p0) {
                                                      focusNode.requestFocus();
                                                    }, */
                          title: "City",
                          role: "",
                          controller: companyLocationController,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          onChanged: (p0) {
                            isEdit10 = p0;
                          },
                          getid: (p0) {
                            workcityId = p0;
                            print(workcityId);
                          },
                          contextIn: context,
                          onSubmit: (p0) {},
                          hintText: "Mumbai",
                          labelText: "Work City",
                          icon: const Icon(Icons.add_location_alt_outlined),
                          //  onIDSelected: handleSelectedID,
                          //   getSuggestions: getJobTitle,
                        ),

                        const SizedBox(
                          height: 2,
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            const Divider(
                              thickness: 1.5, // Customize the Divider as needed
                            ),
                            Container(
                              color:
                                  Colors.white, // Background color of the text
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust padding as needed
                              child: Text(
                                "Emp Type",
                                style: GoogleFonts.varela(
                                    color: Constants.themeBgColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),

                        Wrap(
                          children: [
                            customContainerSelectForEmpType(
                                onPressed: () {
                                  setState(() {
                                    isPartTime = false;
                                    isFullTime = true;
                                    isContract = false;
                                    isIntern = false;
                                    temporary = false;
                                  });
                                },
                                isSelect: isFullTime,
                                title: "Full Time"),
                            customContainerSelectForEmpType(
                                onPressed: () {
                                  setState(() {
                                    isPartTime = true;
                                    isFullTime = false;
                                    isContract = false;
                                    isIntern = false;
                                    temporary = false;
                                  });
                                },
                                isSelect: isPartTime,
                                title: "Part Time"),
                            customContainerSelectForEmpType(
                                onPressed: () {
                                  setState(() {
                                    isPartTime = false;
                                    isFullTime = false;
                                    isContract = true;
                                    isIntern = false;
                                    temporary = false;
                                  });
                                },
                                isSelect: isContract,
                                title: "Contractual"),
                            customContainerSelectForEmpType(
                                onPressed: () {
                                  setState(() {
                                    isPartTime = false;
                                    isFullTime = false;
                                    isContract = false;
                                    isIntern = true;
                                    temporary = false;
                                  });
                                },
                                isSelect: isIntern,
                                title: "Internship"),
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),

                        //TODO: new, joining and lastworking date

                        InkWell(
                          onTap: () {
                            selectDateForJoiningDay();
                          },
                          child: Stack(
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width / 2.5,
                                height: MediaQuery.of(context).size.height / 25,
                                margin: EdgeInsets.only(bottom: 5.h),
                                // width: MediaQuery.of(context).size.width / 1.8,
                                // height: 35,
                                color: Colors.white,
                                child: TextFormField(
                                  focusNode: joiningDateFocus,
                                  enabled: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This Text field Cant be empty";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: joiningDataController,
                                  /* onTap: () {
                              selectDate();
                        }, */
                                  style: GoogleFonts.varela(
                                      color: Constants.hintColor,
                                      fontSize: 14.sp),
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.edit_calendar_outlined),
                                      prefixIconColor: Constants.themeBgColor,
                                      contentPadding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 10,
                                          right: 10),
                                      counterText: '',
                                      labelText: "Joining Date",
                                      labelStyle: const TextStyle(
                                        color: Constants.themeBgColor,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: const BorderSide(
                                            color: Constants.themeBgColor),
                                      ),
                                      focusColor: const Color(0xffff0eceb),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: const BorderSide(
                                          color: Constants.themeBgColor,
                                        ),
                                      ),
                                      hintText: "26-Jan-2023",
                                      hintStyle: GoogleFonts.sourceSansPro(
                                          color: Constants.hintColor,
                                          fontSize: 15.sp)),
                                ),
                              ),
                              if (joiningDataController.text.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          joiningDataController.clear();
                                          lastWorkingController.clear();
                                        });
                                      },
                                      child: Icon(Icons.close,
                                          size: 20.h,
                                          color: Constants.themeBgColor)),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        if (!currentlyWorking &&
                            joiningDataController.text.isNotEmpty)
                          InkWell(
                            onTap: !currentlyWorking
                                ? () {
                                    selectDateForLastWorkingDay();
                                  }
                                : () {},
                            child: Stack(
                              children: [
                                Container(
                                  // width: MediaQuery.of(context).size.width / 2.5,
                                  height:
                                      MediaQuery.of(context).size.height / 25,
                                  margin: EdgeInsets.only(bottom: 5.h),
                                  // width: MediaQuery.of(context).size.width / 1.8,
                                  // height: 35,
                                  color: Colors.white,
                                  child: TextFormField(
                                    focusNode: joiningDateFocus,
                                    enabled: false,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This Text field Cant be empty";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: lastWorkingController,
                                    /* onTap: () {
                          selectDate();
                        }, */
                                    style: GoogleFonts.varela(
                                        color: Constants.hintColor,
                                        fontSize: 14.sp),
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                            Icons.edit_calendar_outlined),
                                        prefixIconColor: Constants.themeBgColor,
                                        contentPadding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 10,
                                            right: 10),
                                        counterText: '',
                                        labelText: "Last Working Date",
                                        labelStyle: const TextStyle(
                                          color: Constants.themeBgColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: const BorderSide(
                                              color: Constants.themeBgColor),
                                        ),
                                        focusColor: const Color(0xffff0eceb),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: const BorderSide(
                                            color: Constants.themeBgColor,
                                          ),
                                        ),
                                        hintText: "26-Jan-2023",
                                        hintStyle: GoogleFonts.sourceSansPro(
                                            color: Constants.hintColor,
                                            fontSize: 15.sp)),
                                  ),
                                ),
                                if (lastWorkingController.text.isNotEmpty)
                                  Positioned(
                                    right: 0,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            lastWorkingController.clear();
                                          });
                                        },
                                        child: Icon(Icons.close,
                                            size: 20.h,
                                            color: Constants.themeBgColor)),
                                  ),
                              ],
                            ),
                          ),
                        if (joiningDataController.text.isNotEmpty &&
                            lastWorkingController.text.isEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("I am currently working."),
                              SizedBox(
                                width: 10.w,
                              ),
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
                                    value: currentlyWorking,
                                    onChanged: (newValue) {
                                      setState(() {
                                        currentlyWorking = !currentlyWorking;
                                      });
                                      // Notify Flutter that the state has changed
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                        Container(

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
                                  height:
                                      MediaQuery.of(context).size.height / 25,
                                  color: Colors.white,
                                  child: TextFormField(
                                    maxLength: 8,
                                    focusNode: salaryFocus,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This Text field Cant be empty";
                                      }
                                      return null;
                                    },

                                    // focusNode: titleFocus,
                                    // maxLength: 3,
                                    onFieldSubmitted: (value) {
                                      currentSalaryController.text.isNotEmpty
                                          ? setState(() {
                                              isCurrentSalary = true;
                                              // _showContainer1 = value.isEmpty;
                                            })
                                          : null;
                                    },

                                    onChanged: (value) {
                                      setState(() {
                                        currentSalaryController.text.isEmpty
                                            ? isMonthly = false
                                            : isYearly = false;
                                      });
                                    },
                                    onTapOutside: (event) {
                                      currentSalaryController.text.isNotEmpty
                                          ? setState(() {
                                              isCurrentSalary = true;
                                              // _showContainer1 = value.isEmpty;
                                            })
                                          : null;
                                    },
                                    onEditingComplete: () {
                                      currentSalaryController.text.isNotEmpty
                                          ? setState(() {
                                              isCompanyLocation = true;
                                              // _showContainer1 = value.isEmpty;
                                            })
                                          : null;
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: currentSalaryController,
                                    // enabled: enableShortListFor,
                                    onTap: (() {}),
                                    style: GoogleFonts.varela(
                                        color: Constants.hintColor,
                                        fontSize: 14.sp),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      label: const Text("Salary"),
                                      labelStyle: GoogleFonts.varela(
                                          color: Constants.themeBgColor,
                                          fontSize: 15.sp),
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(right: 6.w),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isMonthly = true;
                                                  isYearly = false;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.h,
                                                    horizontal: 10.w),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    border: Border.all(
                                                        color: isMonthly
                                                            ? Constants
                                                                .themeBgColor
                                                            : Colors
                                                                .transparent)),
                                                child: Text(
                                                  "Per month",
                                                  style: GoogleFonts.varela(
                                                      color: Constants
                                                          .themeBgColor),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isMonthly = false;
                                                  isYearly = true;
                                                });
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 4.w),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.h,
                                                    horizontal: 10.w),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    border: Border.all(
                                                        color: isYearly
                                                            ? Constants
                                                                .themeBgColor
                                                            : Colors
                                                                .transparent)),
                                                child: Text(
                                                  "Per annum",
                                                  style: GoogleFonts.varela(
                                                      color: Constants
                                                          .themeBgColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.currency_rupee_outlined,
                                        color: Constants.themeBgColor,
                                      ),
                                      prefixIconColor: Constants.themeBgColor,
                                      //label: Text("Reside at"),
                                      hintText: "10000",
                                      hintStyle: GoogleFonts.varela(
                                        color: Constants.subtitleclr,
                                        fontSize: 14.sp,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Constants.themeBgColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffff0eceb),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                              ],
                            )),

                        /* Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Joining Date",
                                  style: GoogleFonts.sourceSansPro(
                                      fontSize: 18.sp,
                                      // color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w600),
                                ),
                                isJoiningDate
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customContainerSelect(
                                            isVacancy: true,
                                            isCross: true,
                                            isAnother: false,
                                            isEmails: false,
                                            isNumOfOpening: true,
                                            onPressed: () async {
                                              setState(() {
                                                isJoiningDate = false;
                                              });
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now().add(
                                                  const Duration(
                                                      days: -(365 * 50)),
                                                ),
                                                lastDate: DateTime.now(),
                                                currentDate: joiningDateValue,
                                                firstDate: DateTime.now(),
                                              );
    
                                              if (pickedDate != null) {
                                                String formattedDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(pickedDate);
                                                joiningDateValue = pickedDate;
                                                setState(() {
                                                  joiningDataController.text =
                                                      formattedDate;
                                                  dt = DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss')
                                                      .format(pickedDate);
                                                  year = (dt - DateTime.now());
                                                  isJoiningDate = false;
                                                  joiningDataController.clear();
                                                });
                                              } else {
                                                print("Date is not selected");
                                              }
                                            },
                                            isSelect: true,
                                            title: joiningDataController.text,
                                          ),
                                        ],
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        // height: 55,
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.h),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: 35,
                                              color: Colors.white,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "This Text field Cant be empty";
                                                  }
                                                  return null;
                                                },
                                                // focusNode: firstNameFocus,
                                                onFieldSubmitted: (value) {
                                                  joiningDataController
                                                          .text.isNotEmpty
                                                      ? setState(() {
                                                          isJoiningDate = true;
                                                        })
                                                      : null;
                                                },
                                                onTapOutside: (event) {
                                                  joiningDataController
                                                          .text.isNotEmpty
                                                      ? setState(() {
                                                          isJoiningDate = true;
                                                        })
                                                      : null;
                                                },
                                                onEditingComplete: () {
                                                  joiningDataController
                                                          .text.isNotEmpty
                                                      ? setState(() {
                                                          isJoiningDate = true;
                                                        })
                                                      : null;
                                                },
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    joiningDataController,
                                                onTap: () {
                                                  selectDate();
                                                },
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 10,
                                                          right: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xffff0eceb)),
                                                  ),
                                                  focusColor:
                                                      const Color(0xffff0eceb),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    122,
                                                                    113,
                                                                    111)),
                                                  ),
                                                  hintText:
                                                      "Enter joining date ",
                                                  hintStyle:
                                                      GoogleFonts.sourceSansPro(
                                                          color: Constants
                                                              .subtitleclr,
                                                          fontSize: 15.sp),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            if (!isPresent && no)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Working Date",
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 18.sp,
                                        // color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  isLastWorkingDate
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customContainerSelect(
                                              isVacancy: true,
                                              isCross: true,
                                              isAnother: false,
                                              isEmails: false,
                                              isNumOfOpening: true,
                                              onPressed: () async {
                                                setState(() {
                                                  isLastWorkingDate = false;
                                                });
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      DateTime.now().add(
                                                    const Duration(
                                                        days: -(365 * 50)),
                                                  ),
                                                  lastDate: DateTime.now(),
                                                  currentDate:
                                                      lastWorkingDateValue,
                                                  firstDate: DateTime.now(),
                                                );
    
                                                if (pickedDate != null) {
                                                  String formattedDate =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(pickedDate);
                                                  lastWorkingDateValue =
                                                      pickedDate;
                                                  setState(() {
                                                    lastWorkingController.text =
                                                        formattedDate;
                                                    dt = DateFormat(
                                                            'yyyy-MM-dd HH:mm:ss')
                                                        .format(pickedDate);
                                                    year =
                                                        (dt - DateTime.now());
                                                    isJoiningDate = false;
                                                    lastWorkingController
                                                        .clear();
                                                  });
                                                } else {
                                                  print("Date is not selected");
                                                }
                                              },
                                              isSelect: true,
                                              title: lastWorkingController.text,
                                            ),
                                          ],
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          // height: 55,
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 5.h),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                height: 35,
                                                color: Colors.white,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "This Text field Cant be empty";
                                                    }
                                                    return null;
                                                  },
                                                  // focusNode: firstNameFocus,
                                                  onFieldSubmitted: (value) {
                                                    lastWorkingController
                                                            .text.isNotEmpty
                                                        ? setState(() {
                                                            isLastWorkingDate =
                                                                true;
                                                          })
                                                        : null;
                                                  },
                                                  onTapOutside: (event) {
                                                    lastWorkingController
                                                            .text.isNotEmpty
                                                        ? setState(() {
                                                            isLastWorkingDate =
                                                                true;
                                                          })
                                                        : null;
                                                  },
                                                  onEditingComplete: () {
                                                    lastWorkingController
                                                            .text.isNotEmpty
                                                        ? setState(() {
                                                            isLastWorkingDate =
                                                                true;
                                                          })
                                                        : null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller:
                                                      lastWorkingController,
                                                  onTap: () {
                                                    selectDate();
                                                  },
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            bottom: 8,
                                                            left: 10,
                                                            right: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xffff0eceb)),
                                                    ),
                                                    focusColor: const Color(
                                                        0xffff0eceb),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      122,
                                                                      113,
                                                                      111)),
                                                    ),
                                                    hintText:
                                                        "Enter last working date ",
                                                    hintStyle: GoogleFonts
                                                        .sourceSansPro(
                                                            color: Constants
                                                                .subtitleclr,
                                                            fontSize: 15.sp),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                          ],
                        ), */
                        const SizedBox(
                          // width: MediaQuery.of(context).size.width / 2.2.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /* Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isPresent = !isPresent;
                                  if (isPresent) {
                                    // apportunities = false;
                                    working = "I am currently working";
                                  } else {
                                    working = "";
                                  }
                                });
                              },
                              child: isPresent
                                  ? Image.asset(
                                      "assets/images/currentworking.png",
                                      height: 16.h,
                                    )
                                  : Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey,
                                      size: 16.h,
                                    ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            isPresent
                                ? Text(
                                    "I am currently working. ",
                                    style: GoogleFonts.varela(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    "I am currently working. ",
                                    style: GoogleFonts.varela(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                          ],
                        ), */
                              //   if (isPresent)
                            ],
                          ),
                        ),
                      ],
                    ),
                  if ((jobTitleController.text.isNotEmpty &&
                      companyController.text.isNotEmpty))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            const Divider(
                              thickness: 1.5, // Customize the Divider as needed
                            ),
                            Container(
                              color:
                                  Colors.white, // Background color of the text
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust padding as needed
                              child: Text(
                                "Career Assets",
                                style: GoogleFonts.varela(
                                    color: Constants.themeBgColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            offerLetter != null
                                ? customContainerSelectToViewDoc(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomPDFViewerDialog(
                                            pdfUrl:
                                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/$offerLetter",
                                            onRemove: () {
                                              setState(() {
                                                offerLetter = null;
                                              });
                                              // Add your logic for removing here
                                            },
                                            onReplace: () async {
                                              setState(() async {
                                                offerLetter = await uploadFile(
                                                    allowExt: ['pdf'],
                                                    isoffer: true);

                                                // Add your logic for replacing here
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                    title: "Offer Letter")
                                : customContainerSelect(
                                    isAnother: true,
                                    onPressed: () async {
                                      setState(() async {
                                        // offerletter = true;
                                        offerLetter = await uploadFile(
                                            allowExt: ["pdf"], isoffer: true);
                                      });
                                    },
                                    isSelect: offerletter,
                                    title: offerLetter != null
                                        ? offerLetter.toString()
                                        : "Offer letter"),
                            appointmentLetter != null
                                ? customContainerSelectToViewDoc(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomPDFViewerDialog(
                                            pdfUrl:
                                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/$appointmentLetter",
                                            onRemove: () {
                                              setState(() {
                                                appointmentLetter = null;
                                              });
                                              // Add your logic for removing here
                                            },
                                            onReplace: () async {
                                              setState(() async {
                                                appointmentLetter =
                                                    await uploadFile(
                                                        allowExt: ['pdf'],
                                                        isappointment: true);

                                                // Add your logic for replacing here
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                    title: "Appointment letter")
                                : customContainerSelect(
                                    isAnother: true,
                                    onPressed: () async {
                                      setState(() async {
                                        // appontment = true;
                                        appointmentLetter = await uploadFile(
                                            allowExt: ["pdf"],
                                            isappointment: true);
                                      });
                                    },
                                    isSelect: appontment,
                                    title: "Appointment letter"),
                            alarySlip != null
                                ? customContainerSelectToViewDoc(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomPDFViewerDialog(
                                            pdfUrl:
                                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/$alarySlip",
                                            onRemove: () {
                                              setState(() {
                                                alarySlip = null;
                                              });
                                              // Add your logic for removing here
                                            },
                                            onReplace: () async {
                                              setState(() async {
                                                alarySlip = await uploadFile(
                                                    allowExt: ['pdf'],
                                                    issalry: true);

                                                // Add your logic for replacing here
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                    title: "Salary Slip")
                                : customContainerSelect(
                                    isAnother: true,
                                    onPressed: () async {
                                      setState(() async {
                                        // salrysleep = true;
                                        alarySlip = await uploadFile(
                                            allowExt: ['pdf'], issalry: true);
                                      });
                                    },
                                    isSelect: salrysleep,
                                    title: "Salary slips"),
                            incrementLetter != null
                                ? customContainerSelectToViewDoc(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomPDFViewerDialog(
                                            pdfUrl:
                                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/$incrementLetter",
                                            onRemove: () {
                                              setState(() {
                                                incrementLetter = null;
                                              });
                                              // Add your logic for removing here
                                            },
                                            onReplace: () async {
                                              setState(() async {
                                                incrementLetter =
                                                    await uploadFile(
                                                        allowExt: ['pdf'],
                                                        isincrement: true);

                                                // Add your logic for replacing here
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                    title: "Increment letter")
                                : customContainerSelect(
                                    isAnother: true,
                                    onPressed: () async {
                                      setState(() async {
                                        //  increament = true;
                                        incrementLetter = await uploadFile(
                                            allowExt: ['pdf'],
                                            isincrement: true);
                                      });
                                    },
                                    isSelect: increament,
                                    title: "Increment letter"),
                            experienceLetter != null
                                ? customContainerSelectToViewDoc(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomPDFViewerDialog(
                                            pdfUrl:
                                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/$experienceLetter",
                                            onRemove: () {
                                              setState(() {
                                                experienceLetter = null;
                                              });
                                              // Add your logic for removing here
                                            },
                                            onReplace: () async {
                                              setState(() async {
                                                experienceLetter =
                                                    await uploadFile(
                                                        allowExt: ['pdf'],
                                                        isexperience: true);

                                                // Add your logic for replacing here
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                    title: "Experience letter")
                                : !currentlyWorking
                                    ? customContainerSelect(
                                        isAnother: true,
                                        onPressed: () async {
                                          setState(() async {
                                            //   experienceletter = true;
                                            experienceLetter = await uploadFile(
                                                allowExt: ['pdf'],
                                                isexperience: true);
                                          });
                                        },
                                        isSelect: experienceletter,
                                        title: "Experience / Relieving letter")
                                    : const SizedBox()
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Looking for better opportunities.",
                                      style: GoogleFonts.varela(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  const Spacer(),
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
                                        unselectedWidgetColor:
                                            Colors.transparent,
                                      ),
                                      child: Checkbox(
                                        side: const BorderSide(
                                            color: Colors.white),
                                        activeColor: Colors.white,
                                        checkColor: Constants.themeBgColor,
                                        visualDensity: VisualDensity.compact,
                                        value: apportunities,
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (newValue!) {
                                              // Add the item to the list
                                              apportunities = true;
                                            } else {
                                              apportunities = false;
                                              imd = false;
                                              day15 = false;
                                              day30 = false;
                                              day60 = false;
                                              day90 = false;
                                              // Remove the item from the list
                                            }
                                          });
                                          // Notify Flutter that the state has changed
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /* InkWell(
                                      onTap: () {
                                        setState(() {
                                          apportunities = !apportunities;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          apportunities
                                              ? Image.asset(
                                                  "assets/images/currentworking.png",
                                                  height: 15.h,
                                                )
                                              : Icon(
                                                  Icons.circle_outlined,
                                                  color: Colors.grey,
                                                  size: 16.h,
                                                ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          apportunities
                                              ? Text(
                                                  "Looking for better opportunities.",
                                                  style: GoogleFonts.varela(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              : Text(
                                                  "Looking for better opportunities?",
                                                  style: GoogleFonts.varela(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ), */
                              if (apportunities)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Availability to join?",
                                          style: GoogleFonts.varela(
                                              color: Constants.themeBgColor),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        customContainerSelect(
                                          isAnother: true,
                                          onPressed: () {
                                            setState(() {
                                              working = "Immediate";
                                              imd = !imd;
                                              day15 = false;
                                              day30 = false;
                                              day60 = false;
                                              day90 = false;
                                            });
                                          },
                                          isSelect: imd,
                                          title: "Immediate",
                                        ),
                                        customContainerSelect(
                                          isAnother: true,
                                          onPressed: () {
                                            setState(() {
                                              working = "15 Days or less";
                                              imd = false;
                                              day15 = !day15;
                                              day30 = false;
                                              day60 = false;
                                              day90 = false;
                                            });
                                          },
                                          isSelect: day15,
                                          title: "15 Days or less",
                                        ),
                                        customContainerSelect(
                                          isAnother: true,
                                          onPressed: () {
                                            setState(() {
                                              working = "1 Month";
                                              day15 = false;
                                              day30 = !day30;
                                              day60 = false;
                                              day90 = false;
                                            });
                                          },
                                          isSelect: day30,
                                          title: "1 Month",
                                        ),
                                        customContainerSelect(
                                          isAnother: true,
                                          onPressed: () {
                                            setState(() {
                                              working = "2 Months";
                                              day15 = false;
                                              day30 = false;
                                              day60 = !day60;
                                              day90 = false;
                                            });
                                          },
                                          isSelect: day60,
                                          title: "2 Months",
                                        ),
                                        customContainerSelect(
                                          isAnother: true,
                                          onPressed: () {
                                            setState(() {
                                              working = "2 Months";
                                              day15 = false;
                                              day30 = false;
                                              day60 = false;
                                              day90 = !day90;
                                            });
                                          },
                                          isSelect: day90,
                                          title: "3 Months or more",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        /* customDocumnet(
                              "Offer / Appointment letter.",
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            customDocumnet1("6 months Salary Slip. "),
                            SizedBox(
                              height: 5.h,
                            ),
                            customDocumnet2("6 months Bank statement. "),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (no)
                              customDocumnet3(
                                  "Experience / Relieving letter."), */
                      ],
                    )
                  // const SizedBox(height: 200),
                ],
              ),
            ),
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
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      offerletter = !offerletter;
                    });
                  },
                  child: offerletter
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              offerletter
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        offerletter
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  Row customDocumnet1(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      salrysleep = !salrysleep;
                    });
                  },
                  child: salrysleep
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              salrysleep
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        salrysleep
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  Row customDocumnet2(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      bankstmt = !bankstmt;
                    });
                  },
                  child: bankstmt
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              bankstmt
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        bankstmt
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  Row customDocumnet3(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      experienceletter = !experienceletter;
                    });
                  },
                  child: experienceletter
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              experienceletter
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        experienceletter
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  saveExperience(data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      print("done");
    }
    setState(() {});
  }

  bool isPartTime = false,
      isFullTime = false,
      isContract = false,
      isIntern = false,
      temporary = false;

  InkWell customContainerSelectForEmpType({
    required final VoidCallback onPressed,
    required bool isSelect,
    required String title,
  }) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            //width: MediaQuery.of(context).size.width / 2.2,

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      isSelect ? Constants.themeBgColor : Colors.transparent),
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Text(title,
                style: GoogleFonts.sourceSansPro(
                    color: Constants.themeBgColor, fontSize: 15.sp))));
  }

  save() async {
    // Retrieve the form data

    // Create a new instance of the model and assign the values
    Experience experience = Experience(
      // id: expID,
      userId: widget.userID,
      job_title: jobTitleController.text,
      company_name: companyController.text,
      isCurrent: currentlyWorking ? 1 : 0,
      description: description.text == "" ? null : description.text,
      skills_exp: fetchApiskill,
      city_id: 0,
      work_type: isOnsite
          ? "OnSite"
          : isHybrid
              ? "Hybrid"
              : isWfh
                  ? "WFH"
                  : "",
      jobid: 0,
      companyid: int.tryParse(someid.toString()),
      company_location: companyLocationController.text,
      emptype: isFullTime
          ? "FullTime"
          : isPartTime
              ? "PartTime"
              : isContract
                  ? "Contractual"
                  : isIntern
                      ? "Internship"
                      : null,
      joining_date: selectedJoiningDate,
      last_working_date: !currentlyWorking ? selectedLastWorkingDate : null,
      salary: currentSalaryController.text,
      ismonthly: year ? 0 : 1,
      offer_letter: offerLetter,
      appointment_letter: appointmentLetter,
      salary_slip: alarySlip,
      increment_letter: incrementLetter,
      experience_lettter: experienceLetter,

      availability: apportunities
          ? imd
              ? "Immediate"
              : day15
                  ? "15Days or less"
                  : day30
                      ? "1 Month"
                      : day60
                          ? "2 Month"
                          : day90
                              ? "3 month or more"
                              : null
          : null,

      // working: working,
    );

    // Create an instance of UserDataService
    /*  UserDataService userDataService = UserDataService();

    // Call the saveUserExperience method on the instance
    await userDataService.saveUserExperience(experience.toJson()); */

    /*  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form data saved successfully')),
    ); */
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEducation(
                experience: yes ? Experience() : experience,
                introData: widget.introData,
                languageModel: widget.languageModel,
                userID: widget.userID,
                isexperience: currentlyWorking,
                jobtitleid: !yes ? jobtitleId ?? 0 : 1)));
    /* if (widget.prevPageModel == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Screen2(
                    isFirst: false,
                  )));
    } else { */

    // }
  }

  InkWell customContainerSelectForWorkingType({
    required final VoidCallback onPressed,
    required bool isSelect,
    required String title,
  }) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: MediaQuery.of(context).size.width / 3.7,

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
            child: Center(
              child: Text(title,
                  style: GoogleFonts.sourceSansPro(
                      color: Constants.themeBgColor, fontSize: 15.sp)),
            )));
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
                              "assets/images/close.png",
                              height: 12,
                            )
                          : const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            )
                    ],
                  )
                : Text(text,
                    style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
  }

  handleReadOnlyInputClick() async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate;
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: CupertinoDatePicker(
                      maximumYear: 2023,
                      //  maximumDate: DateTime.now(),
                      //minimumDate: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime dateTime) {
                        tempPickedDate = dateTime;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        totalOfExpController.text = pickedDate.toString();
      });
    }
  }

  String? offerLetter;
  String? appointmentLetter;
  String? alarySlip;
  String? incrementLetter;
  String? experienceLetter;

  Future<String?> uploadFile(
      {allowExt,
      bool isoffer = false,
      isappointment = false,
      issalry = false,
      isincrement = false,
      isexperience = false}) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      String? customValue;
      try {
        // Default value
        // Check if you need to replace "offerLetter" with another value
        if (isoffer) {
          setState(() {
            customValue = "offerLetter";
          });
        } else if (isappointment) {
          setState(() {
            customValue = "appointmentLetter";
          });
        } else if (issalry) {
          setState(() {
            customValue = "salarySlip";
          });
        } else if (isincrement) {
          setState(() {
            customValue = "incrementLetter";
          });
        } else if (isexperience) {
          setState(() {
            customValue = "experienceLetter";
          });
        } else {
          setState(() {
            customValue = "cv";
          });
        }
        var res = await FileUploadService()
            .uploadSingleFile(customValue.toString(), result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          print(filename);
          print("Filename: $filePath");

          // Close the loading dialog when the upload is successful
          Navigator.pop(context);
          //save(filename, data);
          setState(() {});
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
      setState(() {});
      // Handle the case where the user cancels file selection
      return null;
    }
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
      // height: isdescription! ? MediaQuery.of(context).size.height / 24 : null,
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
        keyboardType:
            isdescription! ? TextInputType.multiline : TextInputType.name,
        //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        onFieldSubmitted: (value) {
          setState(() {
            // Increase maxLines when the "Enter" key is pressed
            maxLines += 1;
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
