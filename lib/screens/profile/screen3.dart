// ignore_for_file: must_be_immutable, unused_local_variable, use_build_context_synchronously, dead_code, unused_result, use_full_hex_values_for_flutter_colors, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_element, curly_braces_in_flow_control_structures, unrelated_type_equality_checks, avoid_unnecessary_containers, avoid_print
// ignore_for_file: todo
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/custom_popup_for_location.dart';
import 'package:job_circle/constants/custom_textfield_for_profile.dart';
import 'package:job_circle/constants/customdialogue_for_education_selecton.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/Manager/constant/custom_autosize_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/screen5.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../constants/customTextfield.dart';
import '../../models/autocompleteModel.dart';
import '../../service/UserDataService.dart';

class Screen3 extends ConsumerStatefulWidget {
  Screen3(
      {super.key,
      this.id,
      this.prevPageModel,
      this.expirieanceFlag,
      this.experiencelist,
      this.isEdit,
      this.needpop,
      required this.expelength,
      this.profileHeadline,
      required this.userid,
      required this.skills,
      required this.isFirst});
  final bool? expirieanceFlag;
  final int? id;
  final String? profileHeadline;
  final bool? needpop;
  final int userid;
  // final dynamic prevPageModel;
  int expelength;
  bool? isEdit;
  final bool isFirst;
  final List<String> skills;
  late Experience? prevPageModel;
  late List<Experience>? experiencelist;

  @override
  ConsumerState<Screen3> createState() => _Screen3State();
}

class _Screen3State extends ConsumerState<Screen3> {
  FileUploader fileUploader = FileUploader();
  late Widget previousWidget;
  // CardModel model = CardModel();
  //bool expirieanceFlag = false;
  late ProfileSummaryModel? prevPofileModel;

  var ddlValues;
  late TextEditingController jobTitleController = TextEditingController();
  late TextEditingController companyController = TextEditingController();
  late TextEditingController industry = TextEditingController();

  late TextEditingController functionalArea = TextEditingController();

  late TextEditingController companyLocationController =
      TextEditingController();
  late TextEditingController companyWebsiteController = TextEditingController();
  late TextEditingController skillsController = TextEditingController();
  late TextEditingController totalOfExpController = TextEditingController();
  late TextEditingController currentSalaryController = TextEditingController();
  late TextEditingController joiningDataController = TextEditingController();
  late TextEditingController lastWorkingController = TextEditingController();
  late TextEditingController description = TextEditingController();
  late TextEditingController profileHeadline = TextEditingController();

  late List<AutoCompleteModel> jobTitleList = [];
  late List<AutoCompleteModel> totalExperienceList = [];
  late List<AutoCompleteModel> currentSalaryList = [];
  AutoCompleteModel selectedJobTitle = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedtotalExperience = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedcurrentSalary = AutoCompleteModel("", "", {});
  bool currentlyWorking = false;

  List<String> fetchApiskill = [];
  String? fetchApiGender;
  FocusNode titleFocus = FocusNode();
  FocusNode cmpnyFocusNode = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode salaryFocus = FocusNode();
  FocusNode skillFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode headlineFocus = FocusNode();

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

  bool isEdit1 = false, isEdit2 = false;
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
  var dt;
  bool apportunities = false;
  bool Enable = false;

  DateTime joiningDateValue = DateTime.now();
  DateTime lastWorkingDateValue = DateTime.now();

  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  DateTime? selectedJoiningDate;
  DateTime? selectedLastWorkingDate;

  int? jobtitleId;
  int? workcityId;

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
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(date);
    }

    bool isDateLess = false;

    /*  if (pickedDate != null && widget.experiencelist != null) {
      for (Experience experience in widget.experiencelist!) {
        if (pickedDate.isBefore(experience.joining_date!) ||
            pickedDate.isAtSameMomentAs(experience.joining_date!)) {
          isDateLess = true;
          break;
        }
      }
    } */

    if (isDateLess) {
      // Snackbar dikhao yeh wali date ya previous wali mai isse kam hai
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yeh wali date ya previous wali date se kam hai.'),
        ),
      );
    } else {
      setState(() {
        selectedJoiningDate = pickedDate;
        joiningDataController.text = formatDate(pickedDate!);
        //  dataOfBirthValue = pickedDate; // Update the TextFormField text
      });
      // Agar koi match nahi mila toh aap kuch aur kar sakte hain
    }

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

  Future<void> selectDateForLastWorkingDayForPResent() async {
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
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(date);
    }

    /*  if (pickedDate != null) {
      setState(() {
        selectedLastWorkingDate = pickedDate;
        lastWorkingController.text = formatDate(pickedDate);
        //  dataOfBirthValue = pickedDate; // Update the TextFormField text
      });
    } */
    if (pickedDate != null) {
      // Check if pickedDate is earlier than selectedJoiningDate
      if (selectedJoiningDate != null &&
          pickedDate.isBefore(selectedJoiningDate!)) {
        // Show dialog if pickedDate is earlier
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogueForAddResume(
                subtitle: "Last working date cannot be before joining date.",
                onClose: () {
                  Navigator.pop(context);
                },
                error: true);
          },
        );
      } else {
        setState(() {
          selectedLastWorkingDate = pickedDate;
          lastWorkingController.text = formatDate(pickedDate);
        });
      }
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

  int? companyid;

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

    var stringid =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    int? userid = int.tryParse(stringid.toString());

    var result = await UserDataService().getUserDetails(userid!);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      var userData = dataResult["users"];

      profilemodel = ProfileSummaryModel.fromJson(userData);
    }
  }

  @override
  void initState() {
    bindJobTitle();
    bindTotalExperiance();
    bindCurrentSalary();
    bindProfileSummary();
    titleFocus.requestFocus();

    final DateFormat dateFormatter = DateFormat('dd-MMM-yyyy');
    if (widget.profileHeadline != null && widget.profileHeadline != "null") {
      setState(() {
        profileHeadline.text = widget.profileHeadline.toString();
        //  userID = widget.prevPageModel!.userId;
      });
    }

    if (widget.prevPageModel != null) {
      String addBulletPoints(String input) {
        // Split the text into lines, then add bullet points to each line.
        return input.split('\n').map((line) {
          return '• ${line.trim()}'; // Add bullet point to each line, trimming excess spaces
        }).join('\n'); // Join the lines back into a single string
      }

      setState(() {
        jobTitleController.text = widget.prevPageModel!.jobTitle.toString();
        companyController.text = widget.prevPageModel!.companyName ?? '';
        industry.text = widget.prevPageModel!.industry.toString();
        functionalArea.text = widget.prevPageModel!.functionalArea.toString();
        //
        //
        //TODO:: Emp Type.
        widget.prevPageModel!.empType == "FullTime"
            ? isFullTime = true
            : widget.prevPageModel!.empType == "PartTime"
                ? isPartTime = true
                : widget.prevPageModel!.empType == "Contractual"
                    ? isContract = true
                    : widget.prevPageModel!.empType == "Internship"
                        ? isIntern = true
                        : widget.prevPageModel!.empType == "freelancer"
                            ? freelancer = true
                            : widget.prevPageModel!.empType == "Trainee"
                                ? trainee = true
                                : widget.prevPageModel!.empType ==
                                        "SelfEmployee"
                                    ? selfemp = true
                                    : null;
        //
        //
        //TODO:: Mode of work
        widget.prevPageModel!.workType == "OnSite"
            ? isOnsite = true
            : widget.prevPageModel!.workType == "Hybrid"
                ? isHybrid = true
                : widget.prevPageModel!.workType == "WFH"
                    ? isWfh = true
                    : null;
        //
        //
        companyLocationController.text =
            widget.prevPageModel!.jobLocation.toString();
        //

        if (widget.prevPageModel!.jobRole != "" &&
            widget.prevPageModel!.jobRole != null) {
          description.text =
              addBulletPoints(widget.prevPageModel!.jobRole.toString());
        }
        //
        selectedJoiningDate = widget.prevPageModel!.joiningDate;
        joiningDataController.text = widget.prevPageModel!.joiningDate != null
            ? (DateFormat('dd-MM-yyyy')
                    .format(widget.prevPageModel!.joiningDate!))
                .toString()
            : '';

        lastWorkingController.text =
            widget.prevPageModel!.lastWorkingDate != null
                ? DateFormat('dd-MM-yyyy')
                    .format(widget.prevPageModel!.lastWorkingDate!)
                : '';
        //
        if (widget.prevPageModel!.isCurrent == 1) {
          setState(() {
            currentlyWorking = true;
          });
        }
        //
        currentSalaryController.text = widget.prevPageModel!.salary ?? '';
        //
        if (widget.profileHeadline != null &&
            widget.profileHeadline != "null") {
          setState(() {
            profileHeadline.text = widget.profileHeadline.toString();
            //  userID = widget.prevPageModel!.userId;
          });
        }
        //

        offerLetter = widget.prevPageModel!.offerletter?.toString();
        experienceLetter = widget.prevPageModel!.expLetter?.toString();
        appointmentLetter = widget.prevPageModel!.appointmentLetter?.toString();
        incrementLetter = widget.prevPageModel!.increamentLetter?.toString();
        alarySlip = widget.prevPageModel!.salarySlip?.toString();
      });
    }

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Constants.borderColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Constants.black),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.prevPageModel == null
                  ? const OnboardingTitle(
                      title: "Add Experience",
                    )
                  : const OnboardingTitle(
                      title: "Edit Experience",
                    ),

              //const Spacer(),
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: CustomButtonForSave(
          title: "Next",
          onTap: () {
            if (jobTitleController.text.isEmpty) {
              CustomSnackbar.show("Job title is not optional", true);
            } else if (companyController.text.isEmpty) {
              CustomSnackbar.show("Company is not optional", true);
            } else if (industry.text.isEmpty) {
              CustomSnackbar.show("Industry is not optional", true);
            } else if (functionalArea.text.isEmpty) {
              CustomSnackbar.show("Functional Area is not optional", true);
            } else if (!isPartTime &&
                !isFullTime &&
                !isContract &&
                !isIntern &&
                !freelancer &&
                !trainee &&
                !selfemp) {
              CustomSnackbar.show("Specify your Employment type.", true);
            } else if (companyLocationController.text.isEmpty) {
              CustomSnackbar.show("Provide your work city", true);
            } else if (joiningDataController.text.isEmpty) {
              CustomSnackbar.show("Enter your employment Start date", true);
            } else if (!currentlyWorking &&
                lastWorkingController.text.isEmpty) {
              CustomSnackbar.show("Enter your employment End date", true);
            } else if (currentSalaryController.text.isEmpty) {
              CustomSnackbar.show("Specify your annual slary", true);
            } else if (!isHybrid && !isOnsite && !isWfh) {
              CustomSnackbar.show("Specify your mode of work", true);
            } else {
              save();
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _education(),
          ),
        ));
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
      content: Expanded(
        child: Row(
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 14.0,
                  // Text size
                ),
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      // duration: const Duration(seconds: 3),
    );
  }

  Widget _education() {
    return Container(
      // key: const Key('second'),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const customTextForWeather(
                  title: "Job Title*",
                ),
                CustomJobTitleForExperience(
                  onIDSelected: () {},
                  // isSelected: isIndustry,
                  // focusNode: titleFocus,
                  role: "",
                  isCompany: false,
                  isIndustry: true,
                  name: "job_role",
                  title: "Job Title",
                  controller: jobTitleController,

                  onChanged: (p0) {
                    //  isEdit1 = true;
                  },
                  getid: (p0) {
                    jobtitleId = p0;
                    print(jobtitleId);
                  },
                  contextIn: context,
                  hintText: "Sales Manager",
                ),
                const SizedBox(height: 10),
                /*  isEdit2
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 25.h,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.domain_add_outlined),
                              prefixIconColor: Constants.themeBgColor,
                              contentPadding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 10, right: 10),
                              counterText: '',
                              labelText: companyController.text,
                              labelStyle: const TextStyle(
                                color: Constants.themeBgColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide:
                                    const BorderSide(color: Color(0xffff0eceb)),
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
                                  color: Constants.hintColor, fontSize: 15.sp)),
                        ),
                      )
                    : */
                const customTextForWeather(
                  title: "Company Name*",
                ),
                customCompanyforExperience(
                    onTapCallback: () {},
                    // focusNode: cmpnyFocusNode,
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
                        isEdit1 = true;
                      });
                    },
                    contextIn: context,
                    onSubmit: (p0) {
                      setState(() {
                        companyid = int.tryParse(p0);
                      });
                    },
                    hintText: "Aditya birla Health Insurance",
                    // getSuggestions: getSuggestions,
                    onIDSelected: () {}),
                SizedBox(
                  height: 7.h,
                ),

                const customTextForWeather(
                  title: "Industry*",
                ),
                /*   CustomTextField(
                        focusNode: functionalAreaFocus,
                        controller: functionalArea,
                        hint: "Domain on which the company operates",
                        label: "Indusry",
                        isdescription: false,
                        icon: const Icon(Icons.description)), */
                CustomJobTitleForExperience(
                  onIDSelected: () {},
                  // isSelected: isIndustry,
                  //focusNode: titleFocus,
                  role: "",
                  isCompany: false,
                  isIndustry: true,
                  name: "industry",
                  title: "industry",
                  controller: industry,
                  onChanged: (p0) {},
                  getid: (p0) {},
                  contextIn: context,
                  hintText: "Industry",
                ),
                SizedBox(
                  height: 10.h,
                ),
                const customTextForWeather(
                  title: "Functional Area*",
                ),
                CustomJobTitleForExperience(
                  onIDSelected: () {},
                  // isSelected: isIndustry,
                  //focusNode: titleFocus,
                  role: "",
                  isCompany: false,
                  isIndustry: true,
                  name: "functional_area",
                  title: "Functional Area",
                  controller: functionalArea,
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
                  hintText: "Functional Area",
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

                SizedBox(
                  height: 10.h,
                ),
                const customTextForWeather(
                  title: "Employment Type*",
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      customContainerSelectForEmpType(
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = true;
                              isContract = false;
                              isIntern = false;
                              temporary = false;
                              freelancer = false;
                              trainee = false;
                              selfemp = false;
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
                              freelancer = false;
                              trainee = false;
                              selfemp = false;
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
                              freelancer = false;
                              trainee = false;
                              selfemp = false;
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
                              freelancer = false;
                              trainee = false;
                              selfemp = false;
                            });
                          },
                          isSelect: isIntern,
                          title: "Internship"),
                      customContainerSelectForEmpType(
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = false;
                              isContract = false;
                              isIntern = false;
                              temporary = false;
                              freelancer = true;
                              trainee = false;
                              selfemp = false;
                            });
                          },
                          isSelect: freelancer,
                          title: "Freelancer"),
                      customContainerSelectForEmpType(
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = false;
                              isContract = false;
                              isIntern = false;
                              temporary = false;
                              freelancer = false;
                              trainee = true;
                              selfemp = false;
                            });
                          },
                          isSelect: trainee,
                          title: "Trainee"),
                      customContainerSelectForEmpType(
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = false;
                              isContract = false;
                              isIntern = false;
                              temporary = false;
                              freelancer = false;
                              trainee = false;
                              selfemp = true;
                            });
                          },
                          isSelect: selfemp,
                          title: "Self Employee"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                const customTextForWeather(
                  title: "Mode of Work*",
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      CustomPopUpForLocation(
                        pageHeading: "Job Location",
                        isSelect: isOnsite,
                        title: "On-Site",
                        name: "location",
                        hintText: "Mumbai",
                        onSubmit: (p0) {
                          setState(() {
                            companyLocationController.text = p0;
                            isHybrid = false;
                            isOnsite = true;
                            isWfh = false;
                          });
                        },
                      ),
                      CustomPopUpForLocation(
                        pageHeading: "Job Location",
                        isSelect: isHybrid,
                        title: "Hybrid",
                        name: "location",
                        hintText: "Mumbai",
                        onSubmit: (p0) {
                          setState(() {
                            companyLocationController.text = p0;
                            isHybrid = true;
                            isOnsite = false;
                            isWfh = false;
                          });
                        },
                      ),
                      CustomPopUpForLocation(
                        pageHeading: "Job Location",
                        isSelect: isWfh,
                        title: "WFH",
                        name: "city",
                        hintText: "Mumbai",
                        onSubmit: (p0) {
                          setState(() {
                            companyLocationController.text = p0;
                            isHybrid = false;
                            isOnsite = false;
                            isWfh = true;
                          });
                        },
                      ),
                      /*  customContainerSelectForWorkingType(
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
                      ), */
                    ],
                  ),
                ),

                //
                //
                //
                //
                //
                //
                //
                //
                //
                /*       if (isEdit2 && isEdit1 && widget.isEdit == false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            jobTitleController.clear();
                            companyController.clear();
                            yes = false;
                            no = false;
                            isEdit1 = false;
                            isEdit2 = false;
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
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Clear All",
                                style: GoogleFonts.varela(color: Colors.red),
                              ),
                              jobTitleController.text.isEmpty
                                  ? const Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Specify the designation/Title")
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ), */

                /*  */
                if (isHybrid || isOnsite || isWfh)
                  SizedBox(
                    height: 5.h,
                  ),
                if (isHybrid || isOnsite || isWfh)
                  Text(
                    "Job Location",
                    style: GoogleFonts.varela(
                      color: Constants.black,
                      fontSize: 10.sp,
                    ),
                  ),
                if (isHybrid || isOnsite || isWfh)
                  customContainerSelectForWorkingType(
                      isSelect: true,
                      onPressed: () {},
                      title: companyLocationController.text),
                /* CustomPopUpForLocation(
                    isSelect: isWfh,
                    title: "WFH",
                    name: isOnsite
                        ? "location"
                        : isHybrid
                            ? "location"
                            : "city",
                    //  focusNode: cityFocus,
                    // controller: companyLocationController,
                    hintText: "Mumbai",
                    onSubmit: (p0) {
                      setState(() {
                        companyLocationController.text = p0;
                      });
                    },
                  ), */
                SizedBox(
                  height: 10.h,
                ),

//TODO: All the details view only when any one option from current company is selected.

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                      title: "Job Role",
                    ),
                    // QuillEditorPage(),
                    /* BulletPointTextField(
                      maxlength: 1200,
                      controller: description,
                      hintText: "My Job Profile is",
                    ), */
                    CustomAutoSizeTextField(
                      controller: description,
                      hintText: "My job profile is",
                      maxline: 5,
                      maxLength: 1200,
                    ),
                    /*  CustomTextField(
                        focusNode: descriptionFocus,
                        controller: description,
                        hint: "My Job profile is......",
                        label: "Job Responsibilities",
                        maxline: 4,
                        isdescription: true,
                        icon: const Icon(Icons.description)), */
                    SizedBox(
                      height: 10.h,
                    ),
/* 
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
                    ), */

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

                    /*  Text(
                      "Job Location*",
                      style: GoogleFonts.varela(
                        color: Constants.black,
                        fontSize: 10.sp,
                      ),
                    ),

                    CustomTextfieldForJobLocation(
                      name: "city",
                      focusNode: cityFocus,
                      controller: companyLocationController,
                      hintText: "Mumbai",
                      onSubmit: (p0) {
                        setState(() {
                          companyLocationController.text = p0;
                        });
                      },
                    ),

                    //TODO: new, joining and lastworking date
                    SizedBox(
                      height: 10.h,
                    ), */
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const customTextForWeather(
                              title: "Joining Date*",
                            ),
                            InkWell(
                              onTap: () {
                                selectDateForJoiningDay();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    // width: MediaQuery.of(context).size.width / 2.5,
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    margin: EdgeInsets.only(bottom: 5.h),
                                    // width: MediaQuery.of(context).size.width / 1.8,
                                    // height: 35,
                                    color: Colors.white,
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        focusNode: joiningDateFocus,
                                        readOnly: true,
                                        //enabled: false,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "This Text field Cant be empty";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        controller: joiningDataController,
                                        style: GoogleFonts.montserrat(
                                            color: Constants.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.calendar_month_outlined,
                                              color: Constants.darkBlue,
                                            ),
                                            prefixIconColor:
                                                Constants.themeBgColor,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 10,
                                                    right: 10),
                                            counterText: '',
                                            // labelText: "Joining Date",
                                            labelStyle: const TextStyle(
                                              color: Constants.themeBgColor,
                                            ),
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
                                                  BorderRadius.circular(8.r),
                                              borderSide: const BorderSide(
                                                color: Constants.black,
                                              ),
                                            ),
                                            hintText: "Enter start date",
                                            hintStyle: GoogleFonts.montserrat(
                                                color: Constants.subtitleclr,
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (joiningDataController.text.isNotEmpty)
                              const customTextForWeather(
                                title: "LWD",
                              ),
                            if (joiningDataController.text.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  currentlyWorking
                                      ? null
                                      : selectDateForLastWorkingDay();
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      // width: MediaQuery.of(context).size.width / 2.5,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      margin: EdgeInsets.only(bottom: 5.h),
                                      // width: MediaQuery.of(context).size.width / 1.8,
                                      // height: 35,
                                      color: Colors.white,
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          focusNode: joiningDateFocus,
                                          readOnly: true,
                                          //  enabled: false,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This Text field Cant be empty";
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.text,
                                          controller: lastWorkingController,
                                          style: GoogleFonts.montserrat(
                                              color: Constants.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                Icons.calendar_month_outlined,
                                                color: Constants.darkBlue,
                                              ),
                                              prefixIconColor:
                                                  Constants.themeBgColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 8,
                                                      left: 10,
                                                      right: 10),
                                              counterText: '',
                                              // labelText: "Joining Date",
                                              labelStyle: const TextStyle(
                                                color: Constants.themeBgColor,
                                              ),
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
                                                    BorderRadius.circular(8.r),
                                                borderSide: const BorderSide(
                                                  color: Constants.black,
                                                ),
                                              ),
                                              hintText:
                                                  "Enter Last working date",
                                              hintStyle: GoogleFonts.montserrat(
                                                  color: Constants.subtitleclr,
                                                  fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
                      ],
                    ),

                    SizedBox(
                      height: 10.h,
                    ),
                    if (joiningDataController.text.isNotEmpty)
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
                                  value: currentlyWorking,
                                  onChanged: (newValue) {
                                    setState(() {
                                      currentlyWorking = !currentlyWorking;
                                      lastWorkingController.clear();
                                    });
                                    /* else {
                                      for (var e in widget.experiencelist!) {
                                        if (newValue == true) {
                                          if (e.last_working_date == null &&
                                              e.isCurrent == 1 &&
                                              widget.prevPageModel!
                                                      .companyName !=
                                                  e.companyName) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return MyCustomDialogForExperience(
                                                    e: e,
                                                    onYes: (p0) {
                                                      setState(() {
                                                        yes = p0;
                                                        currentlyWorking = p0;
                                                      });
                                                    },
                                                    onNo: (p0) {
                                                      setState(() {
                                                        currentlyWorking = p0;
                                                        no = p0;
                                                      });
                                                    },
                                                    onDateSelected: (p0) {
                                                      setState(() {
                                                        currentlyWorking =
                                                            !currentlyWorking;
                                                        selectedLastDateofPrevious =
                                                            p0;
                                                      });
                                                    },
                                                    selectedDate:
                                                        DateTime.now(),
                                                  );
                                                });
                                          } else {
                                            setState(() {
                                              no = false;
                                              yes = true;
                                              currentlyWorking = true;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            yes = false;
                                            no = true;
                                            currentlyWorking = false;
                                          });
                                        }
                                      }
                                    } */
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          const customTextForWeather(
                              title: "I am currently working here."),
                        ],
                      ),
                    SizedBox(
                      height: 10.h,
                    ),

                    const customTextForWeather(
                      title: "Annual Salary*",
                    ),

                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5.h),
                              height: MediaQuery.of(context).size.height / 25,
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
                                /*   onFieldSubmitted: (value) {
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
                                    currentSalaryController.text.length <= 3
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
                                }, */
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: currentSalaryController,
                                // enabled: enableShortListFor,

                                style: GoogleFonts.montserrat(
                                    color: Constants.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  counterText: '',

                                  //label: Text("Reside at"),
                                  prefixText: "Rs. ",
                                  hintText: "Enter your salary",
                                  hintStyle: GoogleFonts.montserrat(
                                    color: Constants.subtitleclr,
                                    fontSize: 14,
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
                    SizedBox(
                      height: 5.h,
                    ),
                    const customTextForWeather(
                      title: "Profile Headline",
                    ),
                    CustomAutoSizeTextField(
                      maxLength: 120,
                      controller: profileHeadline,
                      hintText: "Enter your profile headline",
                      maxline: 3,
                    )
                    /* CustomTextFieldforAll(
                      maxline: 4,
                      maxLength: 120,
                      focusNode: headlineFocus,
                      controller: profileHeadline,
                      hint: "Enter your profile headline",
                    ), */

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
                    /*   const SizedBox(
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
                    ), */
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                /*   if ((jobTitleController.text.isNotEmpty &&
                    companyController.text.isNotEmpty)) */
                const customTextForWeather(
                  title: "Career Assets",
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        offerLetter != null && offerLetter != ""
                            ? CustomContainerSelectToViewDoc(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return CustomPDFViewerDialog(
                                        pdfUrl:
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$offerLetter",
                                        onRemove: () async {
                                          await FileUploadService()
                                              .deleteSingleFile(offerLetter!);
                                          setState(() {
                                            offerLetter = null;
                                          });
                                          // Add your logic for removing here
                                        },
                                        onReplace: () {
                                          /*  offerLetter =
                                              await fileUploader.uploadFile(
                                                  context,
                                                  ['pdf'],
                                                  "offerLetter");
                                          setState(() {});
                                          /* setState(() async {
                                            offerLetter = await uploadFile(
                                                allowExt: ['pdf'],
                                                isoffer: true);

                                            // Add your logic for replacing here
                                          }); */ */
                                        },
                                      );
                                    },
                                  );
                                },
                                title: "Offer Letter")
                            : const SizedBox(),
                        /* customContainerSelect(
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
                                      : "Offer letter"), */
                        appointmentLetter != null && appointmentLetter != ""
                            ? CustomContainerSelectToViewDoc(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return CustomPDFViewerDialog(
                                        pdfUrl:
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$appointmentLetter",
                                        onRemove: () async {
                                          await FileUploadService()
                                              .deleteSingleFile(
                                                  appointmentLetter!);
                                          setState(() {
                                            appointmentLetter = null;
                                          });
                                          // Add your logic for removing here
                                        },
                                        onReplace: () {
                                          /*  appointmentLetter =
                                              await fileUploader.uploadFile(
                                                  context,
                                                  ['pdf'],
                                                  "appointmentLetter");
                                          setState(() {});
                                          /*  setState(() async {
                                            appointmentLetter =
                                                await uploadFile(
                                                    allowExt: ['pdf'],
                                                    isappointment: true);

                                            // Add your logic for replacing here
                                          }); */ */
                                        },
                                      );
                                    },
                                  );
                                },
                                title: "Appointment letter")
                            : /* customContainerSelect(
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
                                  title: "Appointment letter"), */
                            const SizedBox(),
                        alarySlip != null && alarySlip != ""
                            ? CustomContainerSelectToViewDoc(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return CustomPDFViewerDialog(
                                        pdfUrl:
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$alarySlip",
                                        onRemove: () async {
                                          await FileUploadService()
                                              .deleteSingleFile(alarySlip!);
                                          setState(() {
                                            alarySlip = null;
                                          });
                                          // Add your logic for removing here
                                        },
                                        onReplace: () async {
                                          alarySlip =
                                              await fileUploader.uploadFile(
                                                  context,
                                                  ['pdf'],
                                                  "alarySlip");
                                          setState(() {});
                                          /*  setState(() async {
                                            alarySlip = await uploadFile(
                                                allowExt: ['pdf'],
                                                issalry: true);

                                            // Add your logic for replacing here
                                          }); */
                                        },
                                      );
                                    },
                                  );
                                },
                                title: "Salary Slip")
                            : /* customContainerSelect(
                                  isAnother: true,
                                  onPressed: () async {
                                    setState(() async {
                                      // salrysleep = true;
                                      alarySlip = await uploadFile(
                                          allowExt: ['pdf'], issalry: true);
                                    });
                                  },
                                  isSelect: salrysleep,
                                  title: "Salary slips"), */
                            const SizedBox(),
                        incrementLetter != null && incrementLetter != ""
                            ? CustomContainerSelectToViewDoc(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return CustomPDFViewerDialog(
                                        pdfUrl:
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$incrementLetter",
                                        onRemove: () async {
                                          await FileUploadService()
                                              .deleteSingleFile(
                                                  incrementLetter!);
                                          setState(() {
                                            incrementLetter = null;
                                          });
                                          // Add your logic for removing here
                                        },
                                        onReplace: () async {
                                          incrementLetter =
                                              await fileUploader.uploadFile(
                                                  context,
                                                  ['pdf'],
                                                  "incrementLetter");
                                          setState(() {});
                                          /* setState(() async {
                                            incrementLetter = await uploadFile(
                                                allowExt: ['pdf'],
                                                isincrement: true);

                                            // Add your logic for replacing here
                                          }); */
                                        },
                                      );
                                    },
                                  );
                                },
                                title: "Increment letter")
                            : /* customContainerSelect(
                                  isAnother: true,
                                  onPressed: () async {
                                    setState(() async {
                                      //  increament = true;
                                      incrementLetter = await uploadFile(
                                          allowExt: ['pdf'], isincrement: true);
                                    });
                                  },
                                  isSelect: increament,
                                  title: "Increment letter"), */
                            const SizedBox(),
                        experienceLetter != null && experienceLetter != ""
                            ? CustomContainerSelectToViewDoc(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return CustomPDFViewerDialog(
                                        pdfUrl:
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$experienceLetter",
                                        onRemove: () async {
                                          await FileUploadService()
                                              .deleteSingleFile(
                                                  experienceLetter!);
                                          setState(() {
                                            experienceLetter = null;
                                          });
                                          // Add your logic for removing here
                                        },
                                        onReplace: () async {
                                          experienceLetter =
                                              await fileUploader.uploadFile(
                                                  context,
                                                  ['pdf'],
                                                  "experienceLetter");
                                          setState(() {});
                                          /*  setState(() async {
                                              experienceLetter =
                                                  await uploadFile(
                                                      allowExt: ['pdf'],
                                                      isexperience: true);

                                              // Add your logic for replacing here
                                            }); */
                                        },
                                      );
                                    },
                                  );
                                },
                                title: "Experience letter")
                            : /* customContainerSelect(
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
                                    title: "Experience / Relieving letter"), */
                            const SizedBox(),
                      ],
                    ),
                    if ((offerLetter == null && offerLetter != "") ||
                        (appointmentLetter == null &&
                            appointmentLetter != "") ||
                        (alarySlip == null && alarySlip != "") ||
                        (incrementLetter == null && incrementLetter != "") ||
                        (lastWorkingController.text.isNotEmpty &&
                            experienceLetter == null &&
                            experienceLetter != ""))
                      CustomDocumentUploadButton(
                          onTab: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return _buildBottomSheetContent(context);
                              },
                            );
                          },
                          title: "Add Document"),
                    /* if (yes)
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
                                          for (var e
                                              in widget.experiencelist!) {
                                            if (newValue == true) {
                                              setState(() {
                                                e.availability.toString() ==
                                                        "Immediate"
                                                    ? imd = true
                                                    : e.availability
                                                                .toString() ==
                                                            "15Days or less"
                                                        ? day15 = true
                                                        : e.availability
                                                                    .toString() ==
                                                                "1 Month"
                                                            ? day30 = true
                                                            : e.availability
                                                                        .toString() ==
                                                                    "2 Month"
                                                                ? day60 = true
                                                                : e.availability
                                                                            .toString() ==
                                                                        "3 month or more"
                                                                    ? day90 =
                                                                        true
                                                                    : null; // Add the item to the list
                                                apportunities = true;
                                              });
                                            } else {
                                              setState(() {
                                                apportunities = false;
                                                imd = false;
                                                day15 = false;
                                                day30 = false;
                                                day60 = false;
                                                day90 = false;
                                              });
                                            }
                                          }
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
                        ), */

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
            if (!widget.isFirst)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EducationSelectionDialog(
                                explegth: widget.expelength,
                                type: "exp",
                                text: "Experience",
                                id: widget.prevPageModel!.id!.toInt(),
                              );
                            },
                          );
                          /*  if (widget.experiencelist!.length <= 1) {
                            var payload = {
                              "stage": "experience",
                              "data": {
                                "id": await Utils.getPreferencesValue(
                                    null, ESharedPreferences.user_id.name),
                                "experience": 0,
                              }
                            };
                            await saveExperience(payload);
                            JobPostApiService.DeletExperience(
                                widget.prevPageModel!.id!.toInt(),
                                context,
                                "exp");
                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackbar(
                                    "Experience Deleted Succesfully.", true));
                            ref.refresh(userDataProvider);

                            // Navigator.pop(context);
                          } else {
                            await JobPostApiService.DeletExperience(
                                widget.prevPageModel!.id!.toInt(),
                                context,
                                "exp");
                            ref.refresh(userDataProvider);
                          } */
                        },
                        /* () async {
                          await JobPostApiService.DeletExperience(
                              widget.prevPageModel!.id!.toInt(),
                              context,
                              "exp");
                          ref.refresh(userDataProvider);
                        }, */
                        child: Image.asset(
                          "assets/images/bin.gif",
                          height: 40.h,
                        )
                        /*  child: Text(
                          "Delete Experience",
                          style: GoogleFonts.varela(color: Colors.red),
                        ) */
                        ),
                  ),
                ],
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

  bool isPartTime = false,
      isFullTime = false,
      isContract = false,
      isIntern = false,
      freelancer = false,
      trainee = false,
      selfemp = false,
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
            margin: EdgeInsets.only(bottom: 6.h, top: 2.h, right: 15.sp),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      isSelect ? Constants.borderColor : Colors.grey.shade400),
              color: isSelect ? Constants.borderColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: customTextForWeather(
                title: title,
                color: isSelect ? Constants.black : Colors.grey.shade400,
                fontSize: 12,
                fontWeight: isSelect ? FontWeight.bold : FontWeight.normal)));
  }

  saveExperience(data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      print("done");
    }
    setState(() {});
  }

  save() async {
    DateFormat format = DateFormat('dd-MM-yyyy');

    // Parse the string into a DateTime object
    DateTime joiningDate = format.parse(joiningDataController.text);
    DateTime? lastDate;
    if (currentlyWorking == false) {
      lastDate = format.parse(lastWorkingController.text);
    }

    String empType = (isFullTime)
        ? "FullTime"
        : (isPartTime)
            ? "PartTime"
            : (isContract)
                ? "Contractual"
                : (isIntern)
                    ? "Internship"
                    : freelancer
                        ? "freelancer"
                        : trainee
                            ? "Trainee"
                            : selfemp
                                ? "SelfEmployee"
                                : "FullTime";
    SharedPreferences prefs = await Utils.getSharedPreferences();

    ProfileUpdateRequestDto profileUpdateRequestDto = ProfileUpdateRequestDto(
      id: widget.userid,
      skills: widget.skills,
      profileHeadline:
          profileHeadline.text == "" ? "null" : profileHeadline.text,
    );

    ExperienceRequestDto experienceRequestDto = ExperienceRequestDto(
      id: widget.isEdit == true ? widget.prevPageModel!.id : null,
      userId: widget.userid,
      companyName: companyController.text,
      industry: industry.text,
      functionalArea: functionalArea.text,
      empType: empType,

/*       empType: isFullTime
          ? "FullTime"
          : isPartTime
              ? "PartTime"
              : isContract
                  ? "Contractual"
                  : isIntern
                      ? "Internship"
                      : "FullTime", */
      workType: isOnsite
          ? "OnSite"
          : isHybrid
              ? "Hybrid"
              : isWfh
                  ? "WFH"
                  : "",
      jobTitle: jobTitleController.text,
      jobLocation: companyLocationController.text,
      jobRole: description.text == "• " || description.text == ""
          ? null
          : description.text.replaceAll(RegExp(r'•\s*'), ''),
      joiningDate: joiningDate,
      isCurrent: currentlyWorking ? 1 : 0,
      lastWorkingDate: currentlyWorking ? null : lastDate,
      salary: currentSalaryController.text,
      appointmentLetter: appointmentLetter,
      experienceLettter: experienceLetter,
      incrementLetter: incrementLetter,
      offerLetter: offerLetter,
      salarySlip: alarySlip,
      skillsExp: widget.isEdit == true ? widget.prevPageModel!.skillsExp : [],
    );

    /*   UserUpdateRequestModel userUpdateRequestModel = UserUpdateRequestModel(  //TODO:: use this function if u want to save data on experience page.
        certificationsRequestDtos: null,
        educationRequestDtos: null,
        experienceRequestDtos: [experienceRequestDto],
        profileUpdateRequestDto: profileUpdateRequestDto);
    await JobPostApiService.PostUserInfo(
      userUpdateRequestModel,
    );
    ref.refresh(userDataProvider);
    ref.refresh(ProfileDataProvider);
    CustomSnackbar.show(
        widget.isEdit!
            ? "Experience updated Succesfully."
            : "New Experience added Succesfully.",
        false);
  
     */

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SkillsMulti(
                  isEdit: widget.isEdit!,
                  needpop: widget.needpop,
                  Skill: widget.skills,
                  userid: widget.userid,
                  experienceRequestDto: experienceRequestDto,
                  profileUpdateRequestDto: profileUpdateRequestDto,
                )));
    // Retrieve the form data

    // Create a new instance of the model and assign the values
    /* Experience experience1 = Experience(
      id: expID,
      userId: profilemodel.id,
      /*   city_id: workcityId,
      jobid: jobtitleId,
      job_title: jobTitleController.text,
      company_name: companyController.text,
      isCurrent: yes ? 1 : 0,
      description: description.text == "" ? null : description.text,
      skills_exp: fetchApiskill,

      work_type: isOnsite
          ? "OnSite"
          : isHybrid
              ? "Hybrid"
              : isWfh
                  ? "WFH"
                  : "",
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
      last_working_date: no ? selectedLastWorkingDate : null,
      salary: yes ? currentSalaryController.text : null,
      ismonthly: yes ? 1 : 0,
      offer_letter: offerLetter,
      appointment_letter: appointmentLetter,
      salary_slip: alarySlip,
      increment_letter: incrementLetter,
      experience_lettter: experienceLetter,
      companyid: companyid, */
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
    ); */

    // Create an instance of UserDataService

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
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: EdgeInsets.only(bottom: 6.h, top: 2.h, right: 15.sp),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
            decoration: BoxDecoration(
                color: isSelect ? Constants.borderColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelect
                        ? Constants.borderColor
                        : Colors.grey.shade400)),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: customTextForWeather(
                title: title,
                color: isSelect ? Constants.black : Colors.grey.shade400,
                fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
                fontSize: 12)));
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
      int? maxline,
      required TextEditingController controller}) {
    int maxLines = 1;
    // bool isError = false;
    return SizedBox(
      height:
          maxline == null ? MediaQuery.of(context).size.height / 25.h : null,
      child: TextFormField(
        enabled: isDisabled,
        // autofocus: focusNode.canRequestFocus,
        maxLength: maxLength,
        focusNode: focusNode,

        /*  validator: (value) {
          if (value == null || value.isEmpty) {
            //return "This Text field Cant be empty";
          }
          return null;
        }, */
        //  maxLength: maxLength,

        maxLines: maxline,
        keyboardType: TextInputType.name,
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
        style: GoogleFonts.varela(color: Constants.hintColor, fontSize: 12.sp),
        decoration: InputDecoration(
            /*  filled: isPrimaryNumber! ? true : false,
            fillColor:
                isPrimaryNumber ? Colors.grey.shade200 : Colors.transparent, */

            contentPadding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            // counterText: '',
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

  Widget _buildBottomSheetContent(BuildContext context) {
    final List<String> options = [
      "Offer Letter",
      "Appointment Letter",
      "Salary Slip",
      "Increment Letter",
      "Experience / Relieving Letter"
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          return GestureDetector(
              onTap: () async {
                if (option == "Offer Letter") {
                  offerLetter = await fileUploader.uploadFile(
                      context, ['pdf'], "offerLetter");
                  setState(() {});
                  Navigator.pop(context);
                  /* setState(() async {
                  // offerletter = true;
                  offerLetter =
                      await uploadFile(allowExt: ["pdf"], isoffer: true);
                }); */
                } else if (option == "Appointment Letter") {
                  appointmentLetter = await fileUploader.uploadFile(
                      context, ['pdf'], "appointmentLetter");
                  setState(() {});
                  Navigator.pop(context);
                  /*  setState(() async {
                  appointmentLetter =
                      await uploadFile(allowExt: ["pdf"], isappointment: true);
                }); */
                } else if (option == "Salary Slip") {
                  alarySlip = await fileUploader.uploadFile(
                      context, ['pdf'], "alarySlip");
                  setState(() {});
                  Navigator.pop(context);
                  /*  setState(() async {
                  alarySlip =
                      await uploadFile(allowExt: ['pdf'], issalry: true);
                }); */
                } else if (option == "Increment Letter") {
                  incrementLetter = await fileUploader.uploadFile(
                      context, ['pdf'], "incrementLetter");
                  setState(() {});
                  Navigator.pop(context);
                  /*  setState(() async {
                  incrementLetter =
                      await uploadFile(allowExt: ['pdf'], isincrement: true);
                }); */
                } else if (option == "Experience / Relieving Letter") {
                  experienceLetter = await fileUploader.uploadFile(
                      context, ['pdf'], "experienceLetter");
                  setState(() {});
                  Navigator.pop(context);
                  /*  setState(() async {
                  experienceLetter =
                      await uploadFile(allowExt: ['pdf'], isexperience: true);
                }); */
                }
              },
              child: offerLetter != null &&
                      offerLetter != "" &&
                      option == "Offer Letter"
                  ? const SizedBox()
                  : appointmentLetter != null &&
                          appointmentLetter != "" &&
                          option == "Appointment Letter"
                      ? const SizedBox()
                      : alarySlip != null &&
                              alarySlip != "" &&
                              option == "Salary Slip"
                          ? const SizedBox()
                          : incrementLetter != null &&
                                  incrementLetter != "" &&
                                  option == "Increment Letter"
                              ? const SizedBox()
                              : experienceLetter != null &&
                                      experienceLetter != "" &&
                                      option ==
                                          "Experience / Relieving Letter" &&
                                      lastWorkingController.text.isEmpty
                                  ? const SizedBox()
                                  : option == "Experience / Relieving Letter" &&
                                          lastWorkingController.text.isEmpty
                                      ? const SizedBox()
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 4),
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Constants.subtitleclr,
                                                offset: Offset(2, 2),
                                                blurRadius: 4,
                                              )
                                            ],
                                            color: Constants.lightdull,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ListTile(
                                            trailing: const Icon(Icons.add),
                                            title: customTextForWeather(
                                                fontSize: 12, title: option),
                                          ),
                                        )
              /* Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: const Offset(2, 2),
                                              blurRadius: 4,
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: customTextForWeather(
                                            title: option,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ), */
              );
        }).toList(),
      ),
    );
  }
}

/* 
if (jobTitleController.text.isNotEmpty &&
                    companyController.text.isNotEmpty &&
                    isEdit2 &&
                    isEdit1 &&
                    widget.isEdit != null &&
                    !widget.isEdit!)
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
                              for (var e in widget.experiencelist!) {
                                if (e.last_working_date == null) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return MyCustomDialogForExperience(
                                          e: e,
                                          onYes: (p0) {
                                            setState(() {
                                              yes = p0;
                                            });
                                          },
                                          onNo: (p0) {
                                            setState(() {
                                              no = p0;
                                            });
                                          },
                                          onDateSelected: (p0) {
                                            setState(() {
                                              selectedLastDateofPrevious = p0;
                                            });
                                          },
                                          selectedDate: DateTime.now(),
                                        );
                                        /*  AlertDialog(
                                            contentPadding: EdgeInsets.only(
                                                top: 10.h,
                                                left: 14,
                                                right: 14,
                                                bottom: 8),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Add",
                                                      style: GoogleFonts
                                                          .varela(),
                                                    ),
                                                    Text(
                                                      " End Date",
                                                      style:
                                                          GoogleFonts.varela(
                                                              color: Colors
                                                                  .blue),
                                                    ),
                                                    Text(
                                                      " of previous company",
                                                      style: GoogleFonts
                                                          .varela(),
                                                    )
                                                  ],
                                                ),
                                                ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 0, bottom: 0),
                                                  // ignore: sized_box_for_whitespace
                                                  leading: Container(
                                                    width: 70.w,
                                                    height: 70.h,
                                                    // decoration: BoxDecoration(
                                                    //   color: Colors.white,
                                                    //   borderRadius: BorderRadius.circular(15),
                                                    //   border: Border.all(
                                                    //     color: Colors.transparent,
                                                    //   ),
                                                    // ),
                                                    child: Image.network(
                                                      "https://cdn-icons-png.flaticon.com/128/2098/2098316.png",
                                                      //  "https://cdn-icons-png.flaticon.com/128/10693/10693407.png",
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    e.job_title.toString(),
                                                    // experience.job_title.toString(),
                                                    style: GoogleFonts.varela(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            e.shortname !=
                                                                    null
                                                                ? e.shortname
                                                                    .toString()
                                                                : e.company_name
                                                                    .toString(),
                                                            // experience.company_name.toString(),
                                                            style: GoogleFonts
                                                                .varela(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          const Text(" · "),
                                                          Text(
                                                            e.emptype
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .varela(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 2),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            e.joining_date !=
                                                                    null
                                                                ? DateFormat(
                                                                        'MMM-yyyy')
                                                                    .format(e
                                                                        .joining_date!)
                                                                : "",
                                                            /*  experienceList[index].joining_date != null
                                                                ? experienceList[index].joining_date.toString()
                                                                : "", */
                                                            // '$formattedJoiningDate - $formattedLastWorkingDate ($experience)',
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          if (e.last_working_date !=
                                                              null)
                                                            SizedBox(
                                                              child: Row(
                                                                children: [
                                                                  const Text(
                                                                      " - "),
                                                                  Text(
                                                                    DateFormat(
                                                                            'MMM-yyyy')
                                                                        .format(
                                                                            e.last_working_date!),

                                                                    /*  experienceList[index].joining_date != null
                                                                      ? experienceList[index].joining_date.toString()
                                                                      : "", */
                                                                    // '$formattedJoiningDate - $formattedLastWorkingDate ($experience)',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12.sp,
                                                                      fontWeight:
                                                                          FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          if (e.last_working_date ==
                                                              null)
                                                            SizedBox(
                                                              child: Row(
                                                                children: [
                                                                  const Text(
                                                                      " - "),
                                                                  InkWell(
                                                                    onTap:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        selectDateForLastWorkingDayForPResent();
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets.only(
                                                                          left:
                                                                              6,
                                                                          right:
                                                                              6,
                                                                          top:
                                                                              4,
                                                                          bottom:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        selectedLastDateofPrevious != null
                                                                            ? DateFormat('MMM-yyyy').format(selectedLastDateofPrevious!)
                                                                            : "Select End Date",
                                                                        style:
                                                                            GoogleFonts.varela(
                                                                          color:
                                                                              Colors.blue,
                                                                          fontSize:
                                                                              12.sp,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          /* if (experienceList[index].joining_date != null &&
                                                              experienceList[index].last_working_date != null)
                                                            Text(
                                                              " (${monthsDifference.toString()}m)",
                                                              style: GoogleFonts.varela(
                                                                fontSize: 12.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ) */
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            e.company_location
                                                                .toString(),
                                                            // experience.company_location.toString(),
                                                            style: GoogleFonts
                                                                .varela(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          const Text(" · "),
                                                          Text(
                                                            e.work_type
                                                                .toString(),
                                                            // experience.company_location.toString(),
                                                            style: GoogleFonts
                                                                .varela(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(
                                                                () {
                                                                  no = true;
                                                                  yes = false;
                                                                  selectedLastDateofPrevious =
                                                                      null;
                                                                },
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          6.h,
                                                                      horizontal:
                                                                          10.w),
                                                              child: Text(
                                                                "Cancel",
                                                                style: GoogleFonts.varela(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              // Retrieve the form data

                                                              // Create a new instance of the model and assign the values
                                                              Experience
                                                                  experience =
                                                                  Experience(
                                                                id: e.id,
                                                                userId:
                                                                    e.userId,
                                                                job_title: e
                                                                    .job_title,
                                                                company_name:
                                                                    e.company_name,
                                                                isCurrent: 0,
                                                                description: e
                                                                    .description,
                                                                skills_exp: e
                                                                    .skills_exp,
                                                                work_type: e
                                                                    .work_type,
                                                                company_location:
                                                                    e.company_location,
                                                                emptype:
                                                                    e.emptype,
                                                                joining_date:
                                                                    e.joining_date,
                                                                last_working_date:
                                                                    selectedLastDateofPrevious,
                                                                salary:
                                                                    e.salary,
                                                                ismonthly: e
                                                                    .ismonthly,
                                                                offer_letter:
                                                                    e.offer_letter,
                                                                appointment_letter:
                                                                    e.appointment_letter,
                                                                salary_slip: e
                                                                    .salary_slip,
                                                                increment_letter:
                                                                    e.increment_letter,
                                                                experience_letter:
                                                                    e.experience_letter,

                                                                availability:
                                                                    e.availability,

                                                                // working: working,
                                                              );

                                                              // Create an instance of UserDataService
                                                              UserDataService
                                                                  userDataService =
                                                                  UserDataService();
                                                              //  selectedLastDateofPrevious,
                                                              if (selectedLastDateofPrevious !=
                                                                  null) {
                                                                await userDataService
                                                                    .saveUserExperience(
                                                                        experience
                                                                            .toJson());
                                                                ref.refresh(
                                                                    userDataProvider);

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content:
                                                                          Text('end date of previous company updated successfully')),
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content:
                                                                          Text('Select end date')),
                                                                );
                                                              }
                                                              // Call the saveUserExperience method on the instance
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          6.h,
                                                                      horizontal:
                                                                          10.w),
                                                              child: Text(
                                                                "Submit",
                                                                style: GoogleFonts.varela(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  /* trailing: InkWell(
                                                      onTap: () {
                                                        sendToExperience(experienceList[index]
                                                            // experience
                                                            ); // Pass the selected experience object
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.only(left: 10, right: 4, bottom: 10),
                                                        child: Icon(Icons.edit_outlined, size: 18.h),
                                                      )), */
                                                ),
                                              ],
                                            )); */
                                      });
                                } else {
                                  setState(() {
                                    yes = true;
                                    no = false;
                                  });
                                  // Do something when last_working_date is not null
                                  // For example, display a different message or perform a different action
                                  print('Last working date is not null.');
                                  // You can replace the above line with your desired action.
                                }
                              }
                              widget.experiencelist!
                                  .map((e) => e.last_working_date == null);

                              if (someid == null) {
                                await JobPostApiService.AddCompanytoMom(
                                    companyController.text.toString());
                              }
                              setState(() {
                                yes = true;
                                no = false;
                              });
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
                          /* InkWell(
                            onTap: () async {
                              for (var e in widget.experiencelist!) {
                                if (e.last_working_date == null) {
                                } else {
                                  setState(() {
                                    yes = true;
                                    no = false;
                                  });

                                  print('Last working date is not null.');
                                }
                              }
                              widget.experiencelist!
                                  .map((e) => e.last_working_date == null);

                              if (someid == null) {
                                await JobPostApiService.AddCompanytoMom(
                                    companyController.text.toString());
                              }
                              setState(() {
                                yes = true;
                                no = false;
                              });
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
                          ), */
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
                  ), */
