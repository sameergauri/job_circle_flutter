// ignore_for_file: must_be_immutable, unused_local_variable, unused_result, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, use_full_hex_values_for_flutter_colors, unrelated_type_equality_checks, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/custom_textfield_for_jobLocation.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/models/autocompleteCheckBoxModel.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_container_for_gender.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/autolistviewmodal.dart';
import '../../constants/customSelection.dart';
import '../../constants/gobal.dart';
import '../../service/job_post_api_service.dart';

class Screen1 extends ConsumerStatefulWidget {
  Screen1(
      {super.key,
      this.prevPageModel,
      required this.isbio,
      required this.isfirst,
      required this.userid,
      required this.profileskill,
      this.primaryNumberValue});
  final bool isbio;
  late ProfileModel? prevPageModel;
  final bool isfirst;
  final String? primaryNumberValue;
  final int userid;
  final List<String> profileskill;
  // Pr ofileSummaryModel profilemodel;
  @override
  ConsumerState<Screen1> createState() => _Screen1State();
}

class _Screen1State extends ConsumerState<Screen1> {
  late Widget previousWidget;

  bool isLoading = false;

  // Veriable Declaration
  // DropdownModel ddlModel;
  List locationList = [];
  CardModel model = CardModel();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController userLocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  DateTime dataOfBirthValue = DateTime.now();
  TextEditingController jobLocationController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController primaryNumber = TextEditingController();
  TextEditingController alternateNumber = TextEditingController();
  TextEditingController otpChar1Controller = TextEditingController();
  TextEditingController otpChar2Controller = TextEditingController();
  TextEditingController otpChar3Controller = TextEditingController();
  TextEditingController otpChar4Controller = TextEditingController();

  // final _formKey = GlobalKey<FormState>();
  bool isManual = true;

  var dt;
  int? userID;

  int locationid = 0;
  bool isNumberOfOpenings = false;
  bool isFirstName = false;
  bool isLastName = false;
  bool isMiddleName = false;
  bool isEmail = false;
  bool isDateOfBirth = false;
  bool isUserLocation = false;
  bool isEmails = false;
  bool isPrimaryNumberVerified = false;
  bool isSecondaryNumber = false;

  FocusNode firtnamefocus = FocusNode();
  FocusNode middlenamefocus = FocusNode();
  FocusNode lastnamefocus = FocusNode();
  FocusNode aboutmefocus = FocusNode();
  FocusNode secondarynumberfocus = FocusNode();
  FocusNode primaryNumberFocus = FocusNode();
  FocusNode emailfocus = FocusNode();
  FocusNode localityFocus = FocusNode();
  FocusNode dobfocus = FocusNode();
  FocusNode secondaryNumberFocus = FocusNode();
  FocusNode otpChar2FocusNode = FocusNode();
  FocusNode otpChar3FocusNode = FocusNode();
  FocusNode otpChar4FocusNode = FocusNode();
  FocusNode otpChar1FocusNode = FocusNode();

  String gender = "";
  String martialStatus = "";
  String Localityfinal = '';
  String cityname = '';
  List<dynamic> selectedValuesList = [];
  List<String> selectedValues = [];
  FocusNode industryFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode middleNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();

  List<dynamic> fetchApiskill = [];
  List<dynamic> jobTitleSuggestion = [];
  List<bool> isSelected = [];
  List<String> fetchApiLanguages = [];
  List<String> selectedLanguages = [];
  List<JobTitleItem> jobTitleItems = [];

  late bool vrifyButtonDisabled = true;
  late bool resendOtpHide = true;
  late bool resendOtpTimerHide = false;
  bool isPresent = false;
  String vaccination = "";
  String? vaccination_certificate;

  // focus node;

  String mobileno = '';
  // variables
  String strOTP = '';
  // Initialize the timer with a duration of 1 second
  final interval = const Duration(seconds: 1);

  // Maximum time for the countdown (in seconds)
  final int timerMaxSeconds = 120;

  // Current time remaining (in seconds)
  int currentSeconds = 0;

  // Timer variable to hold the countdown timer
  Timer? timerCountdown;

  // Ticker object to handle the countdown timer

  String get timerText =>
      '${(currentSeconds ~/ 60).toString().padLeft(2, '0')}: ${(currentSeconds % 60).toString().padLeft(2, '0')}';

  var ddlValues;

  late List list;

  GlobalKey<FormState> basicForm3 = GlobalKey<FormState>();

  late List<AutoCompleteModel> stateList = [];
  late List<AutoCompleteModel> cityList = [];
  late List languageList = [];
  late List<AutoCompleteCheckBoxModel> languageAutoList = [];

  AutoCompleteModel selectedLocation = AutoCompleteModel("", "", {});

  double? age;
  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  String removeDuplicates(String input) {
    // Split the string into a list of locations
    List<String> locations = input.split(', ');

    // Remove duplicates by converting to a Set and back to a List
    List<String> uniqueLocations = locations.toSet().toList();

    // Join the list back into a string
    return uniqueLocations.join(', ');
  }

  Future<List> getJobTitle(String pattern, String? name) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions

      List<dynamic> content = data['resultData']['content'];
      // Sort the content based on the order number
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));

      jobTitleSuggestion = content.map((e) => e['value'].toString()).toList();
      print(jobTitleSuggestion);
      return jobTitleSuggestion;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  List<dynamic> suggestions = [];
  List<String> selectedlist = [];

  Future<List<dynamic>> getJobTitleLanguage(
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

  @override
  DateTime lastDate = DateTime.now().subtract(const Duration(days: 365 * 35));
  DateTime firstDate = DateTime.now().subtract(const Duration(days: 365 * 18));

  String? displayName;

  String formatLocality(String locality) {
    // Split the string by comma
    List<String> parts = locality.split(',');

    if (parts.length >= 2) {
      // Trim any leading or trailing spaces/tabs from both parts
      String part1 = parts[0].trim();
      String part2 = parts[1].trim();

      // Combine the parts with a single space after the comma
      return '$part1, $part2';
    }

    // If there's no comma, return the original string
    return locality;
  }

  @override
  void initState() {
    super.initState();
    getJobTitleLanguage("");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        primaryNumber.text =
            widget.primaryNumberValue!.toString().replaceAll('"', '');
      });
    });

    bindLocation();
    getJobTitle("pattern", "language").then((_) {
      isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
      setState(() {});
    });

    if (widget.prevPageModel != null) {
      setState(() {
        userID = widget.prevPageModel!.id;
        firstName.text = widget.prevPageModel!.firstName.toString();
        middleName.text = widget.prevPageModel!.middleName != " "
            ? widget.prevPageModel!.middleName.toString()
            : "";
        lastName.text = widget.prevPageModel!.lastName.toString();
        if (widget.prevPageModel!.alternateNo != null &&
            widget.prevPageModel!.alternateNo != "" &&
            widget.prevPageModel!.alternateNo != " " &&
            widget.prevPageModel!.alternateNo != 1 &&
            widget.prevPageModel!.alternateNo != 0) {
          alternateNumber.text = widget.prevPageModel!.alternateNo.toString();
        }
        if (widget.prevPageModel!.gmail != null &&
            widget.prevPageModel!.gmail != "null" &&
            widget.prevPageModel!.gmail != "") {
          emailadr.text = widget.prevPageModel!.gmail.toString();
        }
        if (widget.prevPageModel!.gender == "Male") {
          setState(() {
            ismale = true;
          });
        } else if (widget.prevPageModel!.gender == "Female") {
          setState(() {
            isfemale = true;
          });
        } else if (widget.prevPageModel!.gender == "Transgender") {
          setState(() {
            istranse = true;
          });
        }
        //
        //TODO:: Date of birth
        var dob = widget.prevPageModel!.dob;
        dob = dob!.replaceAll(RegExp(r'(st|nd|rd|th)'), '');
        DateFormat inputFormat = DateFormat("dd MMMM yyyy");
        DateFormat outputFormat = DateFormat("dd-MM-yyyy");
        DateTime date = inputFormat.parse(dob);
        String formattedDate = outputFormat.format(date);
        dataOfBirthValue = date;
        dateOfBirth.text = formattedDate;
        //
        //TODO:: Location
        List<String> dataList =
            widget.prevPageModel!.userFullLocation!.split(", ");
        resideAt =
            formatLocality(widget.prevPageModel!.userLocality.toString());
        locationController.text = removeDuplicates(resideAt.toString());
        Localityfinal = resideAt.toString();
        cityname = resideAt!.split(',').last;
        //
        //TODO:: Pin code
        if (widget.prevPageModel!.pinCode != null &&
            widget.prevPageModel!.pinCode != "null") {
          pincode = widget.prevPageModel!.pinCode;
          pincodecontroller.text = widget.prevPageModel!.pinCode.toString();
        }

        //
        //TODO:: Language.
        selectedlist = widget.prevPageModel!.languagesKnown != null
            ? widget.prevPageModel!.languagesKnown!
            : [];
        //
        //TODO:: vaccination certificate.
        if (widget.prevPageModel!.vaccination_certificate != null &&
            widget.prevPageModel!.vaccination_certificate != "" &&
            widget.prevPageModel!.vaccination_certificate != " " &&
            widget.prevPageModel!.vacination == true) {
          vaccination_certificate =
              widget.prevPageModel!.vaccination_certificate;
        }
        if (widget.prevPageModel?.vacination != null &&
            widget.prevPageModel!.vacination != "") {
          isPresent = widget.prevPageModel!.vacination!;
        }
      });
    }
  }

  DateTime? selectedDate;

  void selectDate() async {
    DateTime lastDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    DateTime firstDate =
        DateTime.now().subtract(const Duration(days: 365 * 77));
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    DateTime? pickedDate = DateTime.now();
    try {
      DateTime initialDate = dateFormat.parse(dateOfBirth.text);

      pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate,
      );
    } catch (e) {
      print("Error while parsing the data");
    }
    String formatDate(DateTime date) {
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(date);
    }

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        if (pickedDate != null) {
          dateOfBirth.text = formatDate(pickedDate);
          dataOfBirthValue = pickedDate;
        } else {
          // Handle the case when pickedDate is null (e.g., set a default value or show an error message).
        }
        // dateOfBirth.text = formatDate(pickedDate);
        // Update the TextFormField text
      });
    }
  }

  bindLocation() async {
    var result = await MasterService().masterGetByGroups(
        {'groupName': 'state,language', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      for (var e in (ddlValues["content"] as List)) {
        if (e['group_name'] == 'state') {
          stateList.add(AutoCompleteModel(e['id'].toString(), e['value'], e));
        } else if (e['group_name'] == 'language') {
          e['checked'] = false;
          if (widget.prevPageModel?.languagesKnown != null) {
            if (widget.prevPageModel!.languagesKnown!.contains(e['value'])) {
              e['checked'] = true;
            }
          }

          languageList.add(e);
          languageAutoList.add(AutoCompleteCheckBoxModel(
              e['value'], e['value'], e, e['checked']));
        }
      }
      // try {
      //   languageList.sort((a, b) => a['order'].compareTo(b['order']));
      // } catch (e) {}

      //setState(() {});
      // jobLocationList =
      //     .map<AutoCompleteModel>(
      //         (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
      //     .toList();
      // final productId = ModalRoute.of(context)!.settings.arguments;

      // 07/06/2022
      // print(productId);
      // setState(() {
      //   selectedLocation = AutoCompleteModel("0", "", {});
      // });
    }
  }

  bool ismale = false,
      isfemale = false,
      istranse = false,
      single = false,
      married = false,
      divorced = false,
      separated = false,
      widowed = false,
      isCity = false,
      isLocality = false,
      isAPos = false,
      isANeg = false,
      isBPos = false,
      isBNeg = false,
      isOPos = false,
      isONeg = false,
      isABPos = false,
      isABNeg = false;

  // male = false,
  // female = false,
  // trans = false;
  bool language = false;
  String year = "";
  String? resideAt;
  bool isEmailValid(String email) {
    // Define a regular expression pattern for a valid email address
    // This pattern is a simple one and may not cover all edge cases
    // You can use a more comprehensive regex pattern for email validation
    const pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email.toLowerCase());
  }

  TextEditingController locationController = TextEditingController();
  TextEditingController pincodecontroller = TextEditingController();
  String? pincode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true, // Add this line
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Constants.borderColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const OnboardingTitle(
                title: "Personal Detail",
              ),
            ),
            bottomNavigationBar: CustomButtonForSave(
              title: "Save",
              onTap: () {
                if (firstName.text.isEmpty) {
                  //final snackBar = customSnackbar();

                  CustomSnackbar.show("First name is compulsory.", true);
                } else if (lastName.text.isEmpty) {
                  CustomSnackbar.show("Last name is compulsory.", true);
                } else if (dateOfBirth.text.isEmpty) {
                  CustomSnackbar.show("add Date of birth.", true);
                } else if (!isEmailValid(emailadr.text) &&
                    !widget.isfirst &&
                    emailadr.text != "" &&
                    emailadr.text.isNotEmpty) {
                  CustomSnackbar.show("Invalid E-Mail", true);
                } else if (locationController.text.isEmpty) {
                  CustomSnackbar.show("Add Current Residence City?", true);
                } else if (pincode == null && pincode == "") {
                  CustomSnackbar.show("Add Pin Code?", true);
                } else if (selectedlist.isEmpty) {
                  CustomSnackbar.show(
                      "Select atleast one langauge to continue.?", true);
                } else if (alternateNumber.text.isNotEmpty &&
                    alternateNumber.text.length < 10) {
                  CustomSnackbar.show("Provide proper alternate number.", true);
                } else if (pincodecontroller.text.length < 6) {
                  CustomSnackbar.show("Provide proper pin code.", true);
                } else if (alternateNumber.text.isNotEmpty &&
                    alternateNumber.text.startsWith("0")) {
                  CustomSnackbar.show(
                      "Alternate number start with 0 that is not accepted",
                      true);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  save();
                }
              },
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Stack(
                      // shrinkWrap: true,
                      children: [
                        basicInfo(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
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
      ),
    );
  }

  String? data;

  Widget basicInfo() {
    age = ((DateTime.now().difference(dataOfBirthValue)).inDays / 365.floor());
    return Container(
      //margin: const EdgeInsets.only(top: 10),

      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
          child: Form(
            key: basicForm3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const customTextForWeather(
                    title: "First Name*",
                  ),
                  CustomTextFieldforAll(
                    focusNode: firstNameFocus,
                    controller: firstName,
                    hint: "Enter Your First Name",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title: "Middle Name",
                  ),
                  CustomTextFieldforAll(
                    focusNode: middleNameFocus,
                    controller: middleName,
                    hint: "Enter Your Middle Name",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const customTextForWeather(
                    title: "Last Name*",
                  ),
                  CustomTextFieldforAll(
                    focusNode: lastNameFocus,
                    controller: lastName,
                    hint: "Enter Your Last Name",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title: "Contact No*",
                  ),
                  CustomTextFieldforAll(
                    isDisabled: false,
                    isPrimaryNumber: true,
                    focusNode: primaryNumberFocus,
                    controller: primaryNumber,
                    hint: "844******2",
                    maxLength: 10,
                    isNumber: true,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title: "Alternate No",
                  ),
                  CustomTextFieldforAll(
                    focusNode: secondaryNumberFocus,
                    controller: alternateNumber,
                    hint: "Enter Your Alternate Number",
                    maxLength: 10,
                    isNumber: true,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title: "Email ID",
                  ),
                  CustomTextFieldforAll(
                    isGmail: true,
                    keyboardType: true,
                    focusNode: emailfocus,
                    controller: emailadr,
                    hint: "Enter Your Email ID",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title: "Gender*",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContainerForGender(
                        onPressed: () {
                          setState(() {
                            istranse = false;
                            ismale = true;
                            isfemale = false;
                          });
                        },
                        isSelect: ismale,
                        title: "Male",
                      ),
                      CustomContainerForGender(
                        onPressed: () {
                          setState(() {
                            istranse = false;
                            ismale = false;
                            isfemale = true;
                          });
                        },
                        isSelect: isfemale,
                        title: "Female",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const customTextForWeather(
                    title: "Date of Birth*",
                  ),
                  InkWell(
                    onTap: () {
                      selectDate();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 24,
                      margin: EdgeInsets.only(bottom: 5.h),
                      // width: MediaQuery.of(context).size.width / 1.8,
                      // height: 35,
//color: Colors.white,
                      child: AbsorbPointer(
                        child: TextFormField(
                          //  enabled: true,
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          controller: dateOfBirth,
                          style: GoogleFonts.montserrat(
                              color: Constants.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Constants.darkBlue,
                              ),
                              prefixIconColor: Constants.themeBgColor,
                              contentPadding: const EdgeInsets.only(
                                  top: 6, bottom: 6, left: 10, right: 10),
                              counterText: '',
                              suffix: Text(
                                "${calculateAge(dateOfBirth.text).toString()} yrs",
                              ),
                              //  labelText: "Date of birth",

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xffff0eceb)),
                              ),
                              focusColor: const Color(0xffff0eceb),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: Constants.black,
                                ),
                              ),
                              hintText: "Enter your date of birth",
                              hintStyle: GoogleFonts.montserrat(
                                  color: Constants.hintColor, fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title: "Location*",
                  ),
                  CustomTextfieldForJobLocation(
                    name: "location",
                    focusNode: localityFocus,
                    controller: locationController,
                    hintText: "Mumbai",
                    onSubmit: (p0) {
                      setState(() {
                        locationController.text = p0;
                        cityname = p0.split(',').last;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title: "Pin Code*",
                  ),
                  CustomJobTitleForExperience(
                    onIDSelected: () {},
                    // isSelected: isIndustry,
                    //focusNode: titleFocus,
                    role: "",
                    isCompany: false,
                    isIndustry: true,
                    name: "pin_code",
                    title: "Pin Code",
                    controller: pincodecontroller,
                    onChanged: (p0) {},
                    getid: (p0) {},
                    contextIn: context,
                    hintText: "Type to searchy",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const customTextForWeather(
                    title: "Language Known*",
                  ),
                  Wrap(
                    children: suggestions.map((suggestion) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (!selectedlist.contains(suggestion)) {
                              selectedlist.add(suggestion);
                              // suggestions.remove(suggestion);
                            } else {
                              selectedlist.remove(suggestion);
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 6.h, top: 2.h, right: 15.sp),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedlist.contains(suggestion)
                                      ? Colors.transparent
                                      : Colors.grey.shade400),
                              color: !selectedlist.contains(suggestion)
                                  ? Colors.transparent
                                  : Constants.borderColor,
                              borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 12.w),
                          child: customTextForWeather(
                              title: suggestion.toString(),
                              fontWeight: selectedlist.contains(suggestion)
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
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
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Checkbox(
                            side: const BorderSide(color: Colors.white),
                            activeColor: Colors.white,
                            checkColor: Constants.darkBlue,
                            visualDensity: VisualDensity.compact,
                            value: isPresent,
                            onChanged: (newValue) {
                              setState(() {
                                //     vaccination_certificate = null;
                                isPresent = !isPresent;
                              }); // Notify Flutter that the state has changed
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      customTextForWeather(
                        title: "I am fully Covid-vaccinated.",
                        color: isPresent ? Colors.black : Constants.subtitleclr,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isPresent)
                    if (vaccination_certificate != null &&
                        vaccination_certificate != "")
                      CustomContainerSelectToViewDoc(
                        title: "Vaccination Certificate",
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return CustomPDFViewerDialog(
                                pdfUrl:
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$vaccination_certificate",
                                onRemove: () async {
                                  await FileUploadService().deleteSingleFile(
                                      vaccination_certificate!);
                                  setState(() {
                                    vaccination_certificate = null;
                                  });
                                },
                                onReplace: () {},
                              );
                            },
                          );
                        },
                      ),
                  if (isPresent)
                    if (vaccination_certificate == null)
                      CustomDocumentUploadButton(
                        onTab: () async {
                          FileUploader fileUploader = FileUploader();

                          vaccination_certificate =
                              await fileUploader.uploadFile(
                                  context, ['pdf'], "vacinationCertificate");
                          setState(() {});
                        },
                        title: "Add Vaccination Certificate",
                      ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int calculateAge(String dateOfBirthText) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateOfBirth = DateTime.now();
    try {
      dateOfBirth = dateFormat.parse(dateOfBirthText);
      print('Parsed date: $dateOfBirth');
    } catch (e) {
      print('Error parsing date: $e');
    }
    // final DateTime dateOfBirth = dateFormat.parse(dateOfBirthText);
    final DateTime currentDate = DateTime.now();

    final int years = currentDate.year - dateOfBirth.year;
    final int currentMonth = currentDate.month;
    final int birthMonth = dateOfBirth.month;

    if (currentMonth < birthMonth ||
        (currentMonth == birthMonth && currentDate.day < dateOfBirth.day)) {
      // Subtract 1 from the age if the birthdate hasn't occurred yet this year.
      return years - 1;
    } else {
      return years;
    }
  }

  int? finalage;

  InkWell customLanguage(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          language = !language;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
        decoration: BoxDecoration(
            color: language ? Constants.borderColor : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            language
                ? Text(
                    title,
                    style: GoogleFonts.varela(
                        fontSize: 13.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    title,
                    style: GoogleFonts.varela(fontSize: 13.sp),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              width: 4.w,
            ),
            language
                ? Image.asset(
                    "assets/images/check.png",
                    height: 13.h,
                  )
                : Icon(
                    Icons.add,
                    size: 15.h,
                  )
          ],
        ),
      ),
    );
  }

  updateCard(CardModel items) {
    model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    model.email = items.email;
    model.gender = items.gender;
    model.martial_status = items.martial_status;

    // model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    setState(() {});
  }

  selectCity(stateId) async {
    cityList.clear();
    var result = await MasterService().getByGroupParentId({
      'groupName': 'city',
      'parentId': stateId,
      'pageNumber': '1',
      'pageSize': '2000'
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      for (var e in (ddlValues as List)) {
        cityList.add(AutoCompleteModel(e['id'].toString(), e['value'], e));
      }
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogList(
              tile: null,
              dialogTitle: "Select Location",
              onSelected: (AutoCompleteModel model) async {
                jobLocationController.text = model.label;
                selectedLocation = model;
                Navigator.pop(context);
              },
              itemsData: cityList,
            );
          });
      setState(() {});
    }
  }

  /* InkWell customContainerMale(
      {required final VoidCallback onPressed,
      required bool isSelect,
      required String title,
      bool? isSalary = false}) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: MediaQuery.of(context).size.height / 22.h,
            margin: const EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            decoration: BoxDecoration(
                color: isSelect ? Constants.borderColor : Colors.white,
                // isSelect ? const Color(0xfff310d44) :

                borderRadius: BorderRadius.circular(8),
                border: isSelect
                    ? Border.all(color: Constants.borderColor)
                    : Border.all(
                        color: const Color.fromARGB(255, 200, 194, 193))),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Center(
              child: customTextForWeather(
                title: title,
                fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
              ),
            )));
  } */

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
                    ? MediaQuery.of(context).size.width / 2.44
                    : isEmails
                        ? MediaQuery.of(context).size.width / 2.1
                        : double.infinity,

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: const EdgeInsets.all(8),
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
                : Text(title,
                    style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
  }

  save() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();

    var genderValue = "";
    if (ismale) {
      genderValue = "Male";
    } else if (isfemale) {
      genderValue = "Female";
    } else if (istranse) {
      genderValue = "Transgender";
    }

    var martialStatusValue = "";
    if (single) {
      martialStatusValue = "Single";
    } else if (married) {
      martialStatusValue = "Married";
    } else if (divorced) {
      martialStatusValue = "Divorced";
    } else if (widowed) {
      martialStatusValue = "Widowed";
    } else if (separated) {
      martialStatusValue = "Separated";
    }

    if (isPresent) {
      vaccination = "1";
    } else {
      vaccination = "0";
    }
    String getDaySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    // Define the desired format
    String dateOfBirth = DateFormat('dd MMMM yyyy').format(dataOfBirthValue);

    // Add the suffix (st, nd, rd, th) to the day
    String day = dataOfBirthValue.day.toString();
    String suffix = getDaySuffix(dataOfBirthValue.day);
    dateOfBirth = dateOfBirth.replaceFirst(day, '$day$suffix');

    print('Date of Birth: $dateOfBirth');

    /*  var mobilenumber = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_mobile.name); */

    ProfileUpdateRequestDto profileUpdateRequestDto = ProfileUpdateRequestDto(
        id: widget.userid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        middleName: middleName.text == "" ? " " : middleName.text.trim(),
        alternateNo:
            alternateNumber.text == "" ? 1 : int.tryParse(alternateNumber.text),
        email: emailadr.text == "" ? "null" : emailadr.text,
        gender: genderValue,
        dateOfBirth: dateOfBirth,
        userLocation: cityname,
        userLocality: locationController.text,
        pinCode: pincodecontroller.text,
        vaccination: isPresent,
        vaccinationCertificate:
            isPresent == true ? vaccination_certificate : " ",
        languages: selectedlist,
        skills: widget.profileskill

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

    ref.refresh(userDataProvider);
    ref.read(jobListProvider.notifier).fetchInitialJobs();
    Navigator.pop(
      context,
    );
    ref.refresh(ProfileDataProvider);

    ref.refresh(profileSummaryProvider);
    setState(() {
      isLoading = false;
    });
    CustomSnackbar.show("User Details updated Succesfully", false);

    Utils.setCacheData('firstName', firstName.text);
  }
}
