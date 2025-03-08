// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_element, use_full_hex_values_for_flutter_colors, avoid_print, avoid_unnecessary_containers, use_build_context_synchronously
// ignore_for_file: todo
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/custom_popup_for_location.dart';
import 'package:job_circle/constants/custom_textfield_for_profile.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/models/user_data_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_autosize_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/onboarding/add_skill.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../constants/customTextfield.dart';
import '../../models/autocompleteModel.dart';
import '../../service/UserDataService.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({
    required this.userID,
    required this.introData,
    required this.isExperience,
    required this.isUndergraduate,
    super.key,
  });
  final bool isExperience;
  final bool isUndergraduate;
  final int userID;
  final UserRequest introData;

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  FileUploader fileUploader = FileUploader();
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
  late TextEditingController industry = TextEditingController();
  late TextEditingController functionalArea = TextEditingController();
  late TextEditingController profileheadline = TextEditingController();

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
  FocusNode industryFocus = FocusNode();
  FocusNode functionalAreaFocus = FocusNode();
  FocusNode profileheadlineFocus = FocusNode();
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

    /* if (pickedDate != null) {
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
                  lastWorkingController.clear();
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Constants.borderColor,
          automaticallyImplyLeading: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Constants.black),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
          ),
          /*  Row(
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
          ), */
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: CustomButtonForSave(
          title: "Next",
          onTap: () async {
            if (jobTitleController.text.isEmpty) {
              CustomSnackbar.show(
                "Job title is not optional",
                true,
              );
            } else if (companyController.text.isEmpty) {
              CustomSnackbar.show(
                "Company is not optional",
                true,
              );
            } else if (industry.text.isEmpty) {
              CustomSnackbar.show(
                "Industry is not optional",
                true,
              );
            } else if (functionalArea.text.isEmpty) {
              CustomSnackbar.show(
                "Functional area is not optional",
                true,
              );
            } else if (!isPartTime && !isFullTime && !isContract && !isIntern) {
              CustomSnackbar.show(
                "Specify your employment type",
                true,
              );
            } else if (!isOnsite && !isHybrid && !isWfh) {
              CustomSnackbar.show(
                "Specify your work mode",
                true,
              );
            } else if (joiningDataController.text.isEmpty) {
              CustomSnackbar.show(
                "Enter your employment start date",
                true,
              );
            } else if (!currentlyWorking &&
                lastWorkingController.text.isEmpty) {
              CustomSnackbar.show(
                "Enter your employment end date",
                true,
              );
            } else if (currentSalaryController.text.isEmpty) {
              CustomSnackbar.show(
                "Specify your current salary",
                true,
              );
            } else {
              save();
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(top: 10.sp, left: 10.sp, right: 10.sp),
                child: LinearProgressIndicator(
                  value: 0.334,
                  // value: _calculateProgress(, // Set progress value
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 9.9.sp,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20.sp, top: 10.sp, bottom: 10.sp),
                child: const OnboardingTitle(
                  title: "Professional Experience",
                ),
              ),
              _education(),
            ]),
          ),
        ));
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /*    Row(  //TODO:: Previous way se bana hua checkbox on experience page
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
                ), */

                /* Enable
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
                    : */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                      title: "Job Title*",
                    ),
                    CustomJobTitleForExperience(
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
                    const SizedBox(height: 10),
                    /*  isEdit2
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 25.h,
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.domain_add_outlined),
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
                          )
                        : */
                    const customTextForWeather(
                      title: "Company Name*",
                    ),
                    customCompanyforExperience(
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
                        hintText: "Enter your company name",
                        // getSuggestions: getSuggestions,
                        onIDSelected: () {}),
                  ],
                ),

                /*  if (jobTitleController.text.isNotEmpty &&
                    companyController.text.isNotEmpty &&
                    1 == 1) */

                /*  Row(
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
                    ), */
                /* Row(
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
                    ), */

                //TODO: All the details view only when any one option from current company is selected.

                /*    if (jobTitleController.text.isNotEmpty &&
                    companyController.text.isNotEmpty) */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    /*   CustomTextField(
                        focusNode: industryFocus,
                        controller: industry,
                        hint: "Enter your functional area",
                        label: "Functional Area",
                        isdescription: false,
                        icon: const Icon(Icons.description)),
 */
//TODO:::  Emp Type
//
//
//
//
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
                                  selfemploye = false;
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
                                  selfemploye = false;
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
                                  selfemploye = false;
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
                                  selfemploye = false;
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
                                  selfemploye = false;
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
                                  selfemploye = false;
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
                                  selfemploye = true;
                                });
                              },
                              isSelect: selfemploye,
                              title: "Self Employed"),
                        ],
                      ),
                    ),

                    // QuillEditorPage(),
                    //
                    //
                    //
                    //
                    //TODO::: Work Mode.
                    //
                    //
                    //
                    //
                    SizedBox(
                      height: 5.h,
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
//TODO::: Job Location
                    if (isHybrid || isOnsite || isWfh)
                      SizedBox(
                        height: 5.h,
                      ),
                    if (isHybrid || isOnsite || isWfh)
                      const customTextForWeather(
                        title: "Job Location",
                      ),
                    if (isHybrid || isOnsite || isWfh)
                      customContainerSelectForWorkingType(
                          isSelect: true,
                          onPressed: () {},
                          title: companyLocationController.text),
                    /*   if (isHybrid || isOnsite || isWfh)
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
                      CustomTextfieldForJobLocation(
                        name: isOnsite
                            ? "location"
                            : isHybrid
                                ? "location"
                                : "city",
                        focusNode: cityFocus,
                        controller: companyLocationController,
                        hintText: "Mumbai",
                        onSubmit: (p0) {
                          setState(() {
                            companyLocationController.text = p0;
                          });
                        },
                      ), */
                    /* CustomTextFieldComapanyLocation(
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
                    ), */

//
//
//
//
//
//TODO:: Job Role...
                    SizedBox(
                      height: 10.h,
                    ),
                    const customTextForWeather(
                      title: "Job Responsibility",
                    ),
                    /*   BulletPointTextField(
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
                    /*   CustomTextField(
                        maxline: 4,
                        focusNode: descriptionFocus,
                        controller: description,
                        hint: "My Job profile is......",
                        label: "Job Responsibilities",
                        isdescription: true,
                        icon: const Icon(Icons.description)), */

//
//
//
//
//TODO:: Joining date and last working date.
                    SizedBox(
                      height: 10.h,
                    ),

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

                                    // width: MediaQuery.of(context).size.width / 1.8,
                                    // height: 35,
                                    color: Colors.white,
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        focusNode: joiningDateFocus,
                                        // enabled: false,
                                        readOnly: true,
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
                                  /*  if (joiningDataController.text.isNotEmpty)
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
                                ), */
                                ],
                              ),
                            ),
                          ],
                        ),

                        /*   if (!currentlyWorking &&
                        joiningDataController.text.isNotEmpty) */
                        //   if (!currentlyWorking)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const customTextForWeather(
                              title: "LWD",
                            ),
                            InkWell(
                              onTap: !currentlyWorking
                                  ? () {
                                      selectDateForLastWorkingDay();
                                    }
                                  : () {},
                              child: Stack(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    height:
                                        MediaQuery.of(context).size.height / 25,

                                    // width: MediaQuery.of(context).size.width / 1.8,
                                    // height: 35,
                                    color: Colors.white,
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        focusNode: joiningDateFocus,
                                        readOnly: true,
                                        // enabled: false,
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
                                            // labelText: "Last Working Date",
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
                                            hintText: "Enter End Date",
                                            hintStyle: GoogleFonts.montserrat(
                                                color: Constants.subtitleclr,
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                  /*  if (lastWorkingController.text.isNotEmpty)
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
                                    ), */
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    /*   if (joiningDataController.text.isNotEmpty &&
                        lastWorkingController.text.isEmpty) */
                    SizedBox(
                      height: 7.h,
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
                              value: currentlyWorking,
                              onChanged: (newValue) {
                                setState(() {
                                  currentlyWorking = !currentlyWorking;
                                  lastWorkingController.clear();
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
                            title: "I am currently working."),
                      ],
                    ),

//
//
//
//
//
//TODO:::Salary..
                    SizedBox(
                      height: 10.h,
                    ),
                    const customTextForWeather(
                      title: "Annual Salary*",
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
                                style: GoogleFonts.montserrat(
                                    color: Constants.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  prefixText: "Rs. ",
                                  prefixStyle: GoogleFonts.montserrat(
                                      color: Constants.black, fontSize: 14),
                                  counterText: '',
                                  //  label: const Text("Salary"),
                                  labelStyle: GoogleFonts.varela(
                                      color: Constants.themeBgColor,
                                      fontSize: 12.sp),
                                  /* suffixIcon: Padding( //TODO:: per month and per anum button..
                                    padding: EdgeInsets.only(right: 6.w),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                color: isMonthly
                                                    ? Constants.borderColor
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color: isMonthly
                                                        ? Constants.borderColor
                                                        : Colors
                                                            .grey.shade400)),
                                            child: Text(
                                              "Per Month",
                                              style: GoogleFonts.varela(
                                                  color: isMonthly
                                                      ? Constants.black
                                                      : Colors.grey.shade400,
                                                  fontSize: 12.sp),
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
                                            margin: EdgeInsets.only(left: 4.w),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h,
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                                color: isYearly
                                                    ? Constants.borderColor
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color: isYearly
                                                        ? Constants.borderColor
                                                        : Colors
                                                            .grey.shade400)),
                                            child: Text(
                                              "Per Annum",
                                              style: GoogleFonts.varela(
                                                  color: isYearly
                                                      ? Constants.black
                                                      : Colors.grey.shade400,
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ), */
                                  /*   prefixIcon: const Icon(
                                    Icons.currency_rupee_outlined,
                                    color: Constants.themeBgColor,
                                  ), */
                                  prefixIconColor: Constants.themeBgColor,
                                  //label: Text("Reside at"),
                                  hintText: "Enter your salary",
                                  hintStyle: GoogleFonts.montserrat(
                                      color: Constants.subtitleclr,
                                      fontSize: 14),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Constants.black),
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

//
//
//
//
//TODO:::  Profile Headline.....
                    SizedBox(
                      height: 5.h,
                    ),
                    const customTextForWeather(
                      title: "Profile Headline",
                    ),
                    CustomAutoSizeTextField(
                      maxLength: 120,
                      controller: profileheadline,
                      hintText: "Enter your profile headline",
                      maxline: 3,
                    ),
                    /*    CustomTextFieldforAll(
                      focusNode: profileheadlineFocus,
                      controller: profileheadline,
                      hint: "Enter your profile headline",
                    ), */

//
//
//
//
//
//

                    // TODO::: Old textfield to add skill........
                    //
                    //
                    //
                    //

                    /*  CustomFormTextFieldMultiSelectForProfile(
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

                    //
                    //
                    //
                    //
                    //

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

                    //TODO: new, joining and lastworking date

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
                /*  if ((jobTitleController.text.isNotEmpty &&
                    companyController.text.isNotEmpty)) */
                SizedBox(
                  height: 10.h,
                ),
                const customTextForWeather(
                  title: "Career Assets",
                ),
                //
                //
                //
                //
                //
                offerLetter != null
                    ? CustomContainerSelectToViewDoc(
                        onPressed: () {
                          showDialog(
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
                                onReplace: () async {
                                  offerLetter = await fileUploader.uploadFile(
                                      context, ['pdf'], "offerLetter");
                                  setState(() {});
                                  /*  offerLetter = await uploadFile(
                                        allowExt: ['pdf'], isoffer: true); */

                                  // Add your logic for replacing here
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
                appointmentLetter != null
                    ? CustomContainerSelectToViewDoc(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomPDFViewerDialog(
                                pdfUrl:
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$appointmentLetter",
                                onRemove: () async {
                                  await FileUploadService()
                                      .deleteSingleFile(appointmentLetter!);
                                  setState(() {
                                    appointmentLetter = null;
                                  });
                                  // Add your logic for removing here
                                },
                                onReplace: () async {
                                  appointmentLetter =
                                      await fileUploader.uploadFile(context,
                                          ['pdf'], "appointmentLetter");
                                  setState(() {});
                                  /*  setState(() async {
                                    appointmentLetter = await uploadFile(
                                        allowExt: ['pdf'], isappointment: true);

                                    // Add your logic for replacing here
                                  }); */
                                },
                              );
                            },
                          );
                        },
                        title: "Appointment letter")
                    : const SizedBox(),
                alarySlip != null
                    ? CustomContainerSelectToViewDoc(
                        onPressed: () {
                          showDialog(
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
                                  alarySlip = await fileUploader.uploadFile(
                                      context, ['pdf'], "alarySlip");
                                  setState(() {});
                                  /*  setState(() async {
                                    alarySlip = await uploadFile(
                                        allowExt: ['pdf'], issalry: true);

                                    // Add your logic for replacing here
                                  }); */
                                },
                              );
                            },
                          );
                        },
                        title: "Salary Slip")
                    : const SizedBox(),
                incrementLetter != null
                    ? CustomContainerSelectToViewDoc(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomPDFViewerDialog(
                                pdfUrl:
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$incrementLetter",
                                onRemove: () async {
                                  await FileUploadService()
                                      .deleteSingleFile(incrementLetter!);
                                  setState(() {
                                    incrementLetter = null;
                                  });
                                  // Add your logic for removing here
                                },
                                onReplace: () async {
                                  incrementLetter =
                                      await fileUploader.uploadFile(
                                          context, ['pdf'], "incrementLetter");
                                  setState(() {});
                                  /*  setState(() async {
                                    incrementLetter = await uploadFile(
                                        allowExt: ['pdf'], isincrement: true);

                                    // Add your logic for replacing here
                                  }); */
                                },
                              );
                            },
                          );
                        },
                        title: "Increment letter")
                    : const SizedBox(),
                experienceLetter != null
                    ? CustomContainerSelectToViewDoc(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomPDFViewerDialog(
                                pdfUrl:
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$experienceLetter",
                                onRemove: () async {
                                  await FileUploadService()
                                      .deleteSingleFile(experienceLetter!);
                                  setState(() {
                                    experienceLetter = null;
                                  });
                                  // Add your logic for removing here
                                },
                                onReplace: () async {
                                  experienceLetter =
                                      await fileUploader.uploadFile(
                                          context, ['pdf'], "experienceLetter");
                                  setState(() {});
                                  /*   setState(() async {
                                    experienceLetter = await uploadFile(
                                        allowExt: ['pdf'], isexperience: true);

                                    // Add your logic for replacing here
                                  }); */
                                },
                              );
                            },
                          );
                        },
                        title: "Experience letter")
                    : !currentlyWorking
                        ? const SizedBox()
                        : const SizedBox(),
                //
                //
                //
                //
                //
                if (offerLetter == null ||
                    appointmentLetter == null ||
                    alarySlip == null ||
                    incrementLetter == null ||
                    (lastWorkingController.text.isNotEmpty &&
                        experienceLetter == null))
                  CustomDocumentUploadButton(
                      onTab: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return _buildBottomSheetContent(context);
                          },
                        );
                      },
                      title: "Add Document"),
                SizedBox(
                  height: 4.h,
                ),
                if (appointmentLetter == null ||
                    alarySlip == null ||
                    incrementLetter == null)
                  const customTextForWeather(
                      title:
                          'Add your document like offer letter, Appointment letter, Payslip, Increment letter, Reliving/Experience letter. These confidential document are only visible to recruiters.',
                      fontSize: 12,
                      color: Constants.subtitleclr),

                //
                //
                //
                //
                //
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TODO::: Custom bottomsheet for document upload...
  //
  //
  //
  //

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Career Assets",
            style: GoogleFonts.varela(
                color: Constants.themeBgColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return GestureDetector(
                  onTap: () async {
                    if (option == "Offer Letter") {
                      offerLetter = await fileUploader.uploadFile(
                          context, ['pdf'], "offerLetter");
                      setState(() {});
                      Navigator.pop(context);
                      // offerletter = true;
                      /*   offerLetter =
                          await uploadFile(allowExt: ["pdf"], isoffer: true); */
                    } else if (option == "Appointment Letter") {
                      appointmentLetter = await fileUploader.uploadFile(
                          context, ['pdf'], "appointmentLetter");
                      setState(() {});
                      Navigator.pop(context);
                      /*  appointmentLetter = await uploadFile(
                          allowExt: ["pdf"], isappointment: true); */
                    } else if (option == "Salary Slip") {
                      alarySlip = await fileUploader.uploadFile(
                          context, ['pdf'], "alarySlip");
                      setState(() {});
                      Navigator.pop(context);
                      /*  alarySlip =
                          await uploadFile(allowExt: ['pdf'], issalry: true); */
                    } else if (option == "Increment Letter") {
                      incrementLetter = await fileUploader.uploadFile(
                          context, ['pdf'], "incrementLetter");
                      setState(() {});
                      Navigator.pop(context);
                      /*  incrementLetter = await uploadFile(
                          allowExt: ['pdf'], isincrement: true); */
                    } else if (option == "Experience / Relieving Letter") {
                      experienceLetter = await fileUploader.uploadFile(
                          context, ['pdf'], "experienceLetter");
                      setState(() {});
                      Navigator.pop(context);
                      /*  experienceLetter = await uploadFile(
                          allowExt: ['pdf'], isexperience: true); */
                    }
                  },
                  child: offerLetter != null && option == "Offer Letter"
                      ? const SizedBox()
                      : appointmentLetter != null &&
                              option == "Appointment Letter"
                          ? const SizedBox()
                          : alarySlip != null && option == "Salary Slip"
                              ? const SizedBox()
                              : incrementLetter != null &&
                                      option == "Increment Letter"
                                  ? const SizedBox()
                                  : experienceLetter != null &&
                                          option ==
                                              "Experience / Relieving Letter" &&
                                          lastWorkingController.text.isEmpty
                                      ? const SizedBox()
                                      : option == "Experience / Relieving Letter" &&
                                              lastWorkingController.text.isEmpty
                                          ? const SizedBox()
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 4),
                                              decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color:
                                                        Constants.subtitleclr,
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
                                                    fontSize: 12,
                                                    title: option),
                                              ),
                                            ));
            }).toList(),
          ),
        ],
      ),
    );
  }
  //
  //
  //
  //
  //

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
      freelancer = false,
      trainee = false,
      selfemploye = false,
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

  save() async {
    // Retrieve the form data

    // Create a new instance of the model and assign the values
    ExperienceRequest experience = ExperienceRequest(
      id: 0,
      jobTitle: jobTitleController.text,
      companyName: companyController.text,
      //  profileHeadline: description.text == "" ? null : description.text,
      industry: industry.text,
      functionalArea: functionalArea.text,
      empType: isFullTime
          ? "FullTime"
          : isPartTime
              ? "PartTime"
              : isContract
                  ? "Contractual"
                  : isIntern
                      ? "Internship"
                      : freelancer
                          ? "freelancer"
                          : trainee
                              ? "Trainee"
                              : selfemploye
                                  ? "SelfEmployee"
                                  : "FullTime",
      workType: isOnsite
          ? "OnSite"
          : isHybrid
              ? "Hybrid"
              : isWfh
                  ? "WFH"
                  : "",

      jobLocation: companyLocationController.text,
      jobRole: description.text == "• "
          ? null
          : description.text.replaceAll(RegExp(r'•\s*'), ''),
      joiningDate: selectedJoiningDate!,
      lastWorkingDate: currentlyWorking ? null : selectedLastWorkingDate!,
      isCurrent: currentlyWorking ? 1 : 0,
      salary: currentSalaryController.text,
      offerLetter: offerLetter,
      appointmentLetter: appointmentLetter,
      experienceLettter: experienceLetter,
      incrementLetter: incrementLetter,
      salarySlip: alarySlip,
    );

    /* Experience experience = Experience(
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
    ); */

    // Create an instance of UserDataService
    /*  UserDataService userDataService = UserDataService();

    // Call the saveUserExperience method on the instance
    await userDataService.saveUserExperience(experience.toJson()); */

    /*  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form data saved successfully')),
    ); */

    UserRequest updatedUser =
        widget.introData.copyWith(profileHeadline: profileheadline.text);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddSkill(
                  introData: updatedUser,
                  userID: widget.userID,
                  experience: experience,
                  isExperience: widget.isExperience,
                  isUndergraduate: widget.isUndergraduate,
                )));
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
}
