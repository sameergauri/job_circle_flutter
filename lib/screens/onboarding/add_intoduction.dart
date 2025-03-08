// ignore_for_file: must_be_immutable, override_on_non_overriding_member, unused_local_variable, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, use_full_hex_values_for_flutter_colors, unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/custom_textfield_for_jobLocation.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/autocompleteCheckBoxModel.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/models/user_data_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_container_for_gender.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/onboarding/select_exp_education.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/autolistviewmodal.dart';
import '../../constants/customSelection.dart';
import '../../constants/customTextfield.dart';
import '../../constants/gobal.dart';
import '../../models/api_response.dart';

class AddIntoduction extends StatefulWidget {
  AddIntoduction({super.key, this.prevPageModel, this.primaryNumberValue});
  late ProfileSummaryModel? prevPageModel;

  final String? primaryNumberValue;
  // Pr ofileSummaryModel profilemodel;
  @override
  State<AddIntoduction> createState() => _AddIntoductionState();
}

class _AddIntoductionState extends State<AddIntoduction>
    with SingleTickerProviderStateMixin {
  late Widget previousWidget;

  // Veriable Declaration
  // DropdownModel ddlModel;
  List locationList = [];
  CardModel model = CardModel();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController contactno = TextEditingController();
  TextEditingController altercontactno = TextEditingController();
  TextEditingController userLocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();

  DateTime dataOfBirthValue = DateTime.now();
  TextEditingController jobLocationController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController primaryNumber = TextEditingController();
  TextEditingController secondaryNumber = TextEditingController();
  TextEditingController otpChar1Controller = TextEditingController();
  TextEditingController otpChar2Controller = TextEditingController();
  TextEditingController otpChar3Controller = TextEditingController();
  TextEditingController otpChar4Controller = TextEditingController();
  TextEditingController pincodecontroler = TextEditingController();

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
  FocusNode contactnofocus = FocusNode();
  FocusNode alternatefocus = FocusNode();
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
  String? Localityfinal;
  String? pincode;
  String? cityname;
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
  bool vaccination_certificate = false;

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

  GlobalKey<FormState> basicForm = GlobalKey<FormState>();

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

  @override
  DateTime lastDate = DateTime.now().subtract(const Duration(days: 365 * 35));
  DateTime firstDate = DateTime.now().subtract(const Duration(days: 365 * 18));
  @override
  String cleanNumber(String value) {
    return value.replaceAll('"', '');
  }

  void getNumber() async {
    SharedPreferences pres = await Utils.getSharedPreferences();

    // Await the value before using it
    var variable = await Utils.getPreferencesValue(
        pres, ESharedPreferences.user_mobile.name);

    setState(() {
      contactno.text = variable.toString().replaceAll('"', '');
    });
  }

  @override
  void initState() {
    super.initState();
    getJobTitleLanguage("");
    getNumber();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // primaryNumber = await Utils.getPreferencesValue(
      //     null, ESharedPreferences.user_mobile.name);

      /* setState(() {
        primaryNumber.text = widget.isfirst
            ? widget.primaryNumberValue.toString()
            : primaryNumber.text;
      }); */
    });

    primaryNumberFocus.addListener(() {
      if (!primaryNumberFocus.hasFocus) {
        // The user left the text field; perform your specific operation here
        //performSpecificOperation();
      }
    });

    otpChar1FocusNode = FocusNode();
    //otpChar1FocusNode.requestFocus();
    otpChar2FocusNode = FocusNode();
    otpChar3FocusNode = FocusNode();
    otpChar4FocusNode = FocusNode();

    otpChar1Controller = TextEditingController();
    otpChar2Controller = TextEditingController();
    otpChar3Controller = TextEditingController();
    otpChar4Controller = TextEditingController();
    // startTimer();

    // ticker = Ticker((_) => updateTimerDisplay());

    //  bindLocation();
    //dateOfBirth.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

    //dt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    industryFocus.requestFocus();
    getJobTitle("pattern", "language").then((_) {
      isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
      //setState(() {});
    });

    setState(() {
      isFirstName = true;
    });
    setState(() {
      isMiddleName = true;
    });
    setState(() {
      isLastName = true;
    });
    setState(() {
      isPrimaryNumberVerified = true;
    });
    setState(() {
      isSecondaryNumber = true;
    });
    setState(() {
      isEmail = true;
    });

    if (widget.prevPageModel != null) {
      setState(() {
        isNumberOfOpenings = true;

        firstName.text = widget.prevPageModel!.first_name.toString();
        setState(() {
          userID = widget.prevPageModel!.id;
        });
        middleName.text = widget.prevPageModel!.middle_name.toString();
        lastName.text = widget.prevPageModel!.last_name.toString();
        vaccination = widget.prevPageModel!.vaccination_certificate.toString();
        resideAt =
            "${widget.prevPageModel!.user_locality.toString()}, ${widget.prevPageModel!.user_location.toString()}";
        /*  selectedLocation = widget.prevPageModel?.user_location == null
            ? AutoCompleteModel("", "", {})
            : AutoCompleteModel(
                widget.prevPageModel!.user_location.toString(), "", {});
        jobLocationController.text = widget.prevPageModel?.user_location == null
            ? ''
            : widget.prevPageModel!.user_location.toString(); */
        if (widget.prevPageModel!.user_location != null) {
          localityController.text =
              "${widget.prevPageModel!.user_locality.toString()}, ${widget.prevPageModel!.user_location.toString()}";
        }
        cityname = widget.prevPageModel!.user_location.toString();
        Localityfinal = widget.prevPageModel!.user_locality.toString();
        data = widget.prevPageModel!.vaccination_certificate.toString();

        setState(() {
          isLocality = true;
        });

        setState(() {
          isCity = true;
        });

        emailadr.text = widget.prevPageModel!.email.toString();
        primaryNumber.text = widget.prevPageModel!.mobile.toString();
        if (widget.prevPageModel!.alternate_no != null &&
            widget.prevPageModel!.alternate_no != 0) {
          secondaryNumber.text = widget.prevPageModel!.alternate_no.toString();
        }
        if (widget.prevPageModel!.bio != null) {
          bio.text = widget.prevPageModel!.bio.toString();
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

        if (widget.prevPageModel!.martial_status == "Single") {
          single = true;
        } else if (widget.prevPageModel!.martial_status == "Married") {
          married = true;
        } else if (widget.prevPageModel!.martial_status == "Divorced") {
          divorced = true;
        } else if (widget.prevPageModel!.martial_status == "Widowed") {
          widowed = true;
        } else if (widget.prevPageModel!.martial_status == "Separated") {
          separated = true;
        }

        if (widget.prevPageModel!.vaccination == true) {
          setState(() {
            isPresent = true;
          });
        }
        dataOfBirthValue =
            DateTime.parse(widget.prevPageModel!.dateofbirth.toString());
        dateOfBirth.text = DateFormat("dd-MM-yyyy").format(dataOfBirthValue);
        fetchApiskill = widget.prevPageModel!.skills!;
        selectedValuesList = widget.prevPageModel!.skills!;
        // fetchApiLanguages = widget.prevPageModel!.languages!.cast<String>();
        selectedLanguages = fetchApiLanguages;
      });
    }
  }

  DateTime? selectedDate;
  DateTime? pickedDate = DateTime.now();

  void selectDate() async {
    DateTime lastDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    DateTime firstDate =
        DateTime.now().subtract(const Duration(days: 365 * 77));
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    DateTime? initialDate = lastDate; // Default initial date
    if (dateOfBirth.text.isNotEmpty) {
      try {
        initialDate = dateFormat.parse(dateOfBirth.text);
      } catch (e) {
        print("Error while parsing the date, using default date.");
      }
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateOfBirth.text = dateFormat.format(pickedDate);
        dataOfBirthValue = pickedDate;
      });
    }
  }

  /* void selectDate() async {
    DateTime lastDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    DateTime firstDate =
        DateTime.now().subtract(const Duration(days: 365 * 77));
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime? pickedDate = DateTime.now();
    try {
      DateTime initialDate = dateFormat.parse(dateOfBirth.text);

      pickedDate = await showDatePicker(
        context: context,
        initialDate: firstDate,
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
  } */

  /*  bindLocation() async {
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
          if (widget.prevPageModel?.languages != null) {
            if (widget.prevPageModel!.languages!.contains(e['value'])) {
              e['checked'] = true;
            }
          }

          languageList.add(e);
          languageAutoList.add(AutoCompleteCheckBoxModel(
              e['value'], e['value'], e, e['checked']));
        }
      }
    }
  } */

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Add this line
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Constants.borderColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
          ),
        ),
        bottomNavigationBar: CustomButtonForSave(
          title: "Next",
          onTap: () {
            if (firstName.text.isEmpty) {
              CustomSnackbar.show("First Name cannot be blank.", true);
            } else if (lastName.text.isEmpty) {
              CustomSnackbar.show("Last Name cannot be blank.", true);
            } else if (altercontactno.text.isNotEmpty &&
                altercontactno.text.length < 10) {
              CustomSnackbar.show("Provide proper alternate number.", true);
            } else if (emailadr.text.isNotEmpty &&
                !isValidEmail(emailadr.text)) {
              CustomSnackbar.show("Enter Valid Email Address", true);
            } else if (ismale == false && isfemale == false) {
              CustomSnackbar.show("Select Gender.", true);
            } else if (dateOfBirth.text.isEmpty) {
              CustomSnackbar.show("DOB cannot be blank.", true);
            } else if (cityname == null || cityname == "") {
              CustomSnackbar.show("Add Current Residence City?", true);
            } else if (pincodecontroler.text.isEmpty) {
              CustomSnackbar.show("Add Pin Code?", true);
            } else if (pincodecontroler.text.isNotEmpty &&
                pincodecontroler.text.length < 6) {
              CustomSnackbar.show("Add valid pin code?", true);
            } else if (selectedlist.isEmpty) {
              CustomSnackbar.show("Select Atleast one language", true);
            } else {
              save();
            }
          },
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // shrinkWrap: true,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10.sp, left: 10.sp, right: 10.sp),
                      child: LinearProgressIndicator(
                        value: 0.005,
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
                        title: "Personal Information",
                      ),
                    ),
                    basicInfo()
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? data;

  Widget basicInfo() {
    age = ((DateTime.now().difference(dataOfBirthValue)).inDays / 365.floor());
    return Container(
      //margin: const EdgeInsets.only(top: 10),
      // key: const Key('second'),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
        child: Form(
          key: basicForm,
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
                height: 20.h,
              ),
              const customTextForWeather(
                title: "Middle Name",
              ),
              CustomTextFieldforAll(
                focusNode: middleNameFocus,
                controller: middleName,
                hint: "Enter Your middel Name",
              ),
              const SizedBox(
                height: 20,
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
                height: 20.h,
              ),
              /* Text(
                "About Me",
                style: GoogleFonts.varela(
                  fontSize: 10.sp,
                  color: Constants.black,
                  decoration: TextDecoration.none,
                ),
              ),
              CustomTextField(
                  focusNode: aboutmefocus,
                  controller: bio,
                  hint: "I am software developer",
                  label: "About me",
                  icon: const Icon(Icons.info_outline)),
              SizedBox(
                height: 20.h,
              ), */
              const customTextForWeather(
                title: "Contact No",
              ),
              CustomTextFieldforAll(
                isPrimaryNumber: true,
                isDisabled: false,
                isNumber: true,
                focusNode: contactnofocus,
                controller: contactno,
                hint: "Contact No",
              ),
              SizedBox(
                height: 20.h,
              ),
              const customTextForWeather(
                title: "Alternate No",
              ),
              CustomTextFieldforAll(
                isNumber: true,
                focusNode: alternatefocus,
                controller: altercontactno,
                maxLength: 10,
                hint: "Enter Alternate Number",
              ),
              SizedBox(
                height: 20.h,
              ),
              const customTextForWeather(
                title: "Email ID",
              ),
              CustomTextFieldforAll(
                keyboardType: true,
                isGmail: true,
                focusNode: emailfocus,
                controller: emailadr,
                hint: "Enter Email ID",
              ),

              SizedBox(
                height: 10.h,
              ),

              /*  Row(
                children: [
                  Text(
                    "Gender",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ), */
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
                  /*  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        istranse = true;
                        ismale = false;
                        isfemale = false;
                      });
                    },
                    isSelect: istranse,
                    title: "Transgender",
                  ), */
                ],
              ),

              /* Row(
                children: [
                  Text(
                    "Marital Status",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        single = true;
                        married = false;
                        divorced = false;
                        widowed = false;
                        separated = false;
                      });
                    },
                    isSelect: single,
                    title: "Single",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        single = false;
                        married = true;
                        divorced = false;
                        widowed = false;
                        separated = false;
                      });
                    },
                    isSelect: married,
                    title: "Married",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        single = false;
                        married = false;
                        divorced = true;
                        widowed = false;
                        separated = false;
                      });
                    },
                    isSelect: divorced,
                    title: "Divorced",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        single = false;
                        married = false;
                        divorced = false;
                        widowed = true;
                        separated = false;
                      });
                    },
                    isSelect: widowed,
                    title: "Widowed",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        single = false;
                        married = false;
                        divorced = false;
                        widowed = false;
                        separated = true;
                      });
                    },
                    isSelect: separated,
                    title: "Separated",
                  ),
                ],
              ), */

              const SizedBox(
                height: 5,
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
                  color: Colors.white,
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This Text field Cant be empty";
                        }
                        return null;
                      },
                      // focusNode: firstNameFocus,
                      /*  onFieldSubmitted: (value) {
                        dateOfBirth.text.isNotEmpty
                            ? setState(() {
                                isDateOfBirth = true;
                              })
                            : null;
                      },
                      onTapOutside: (event) {
                        dateOfBirth.text.isNotEmpty
                            ? setState(() {
                                isDateOfBirth = true;
                              })
                            : null;
                      },
                      onEditingComplete: () {
                        dateOfBirth.text.isNotEmpty
                            ? setState(() {
                                isDateOfBirth = true;
                              })
                            : null;
                      }, */
                      keyboardType: TextInputType.text,
                      controller: dateOfBirth,
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
                          prefixIconColor: Constants.themeBgColor,
                          contentPadding: const EdgeInsets.only(
                              top: 6, bottom: 6, left: 10, right: 10),
                          counterText: '',
                          suffix: customTextForMonst(
                            title:
                                "${calculateAge(dateOfBirth.text).toString()} yrs",
                          ),
                          //  labelText: "Date of birth",
                          labelStyle: const TextStyle(
                            color: Constants.themeBgColor,
                          ),
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
                              color: Constants.subtitleclr, fontSize: 14)),
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
                controller: localityController,
                hintText: "Enter your location",
                onSubmit: (p0) {
                  setState(() {
                    Localityfinal = p0;
                    cityname = p0.split(',').last;
                    localityController.text = p0;
                  });
                },
              ),
              /*   CustomJobFormTextFieldRespOneProfile(
                // controller: localityController,
                onIDSelected: () {},
                // isSelected: isIndustry,
                focusNode: localityFocus,
                role: "",
                isCompany: false,
                isIndustry: true,
                name: "location",
                title: "locality",
                //controller: localityController,
                onChanged: (p0) {
                  setState(() {
                    isLocality = true;
                  });
                },
                onCitySubmit: (p0) {
                  setState(() {
                    cityname = p0;
                  });
                },
                onSubmit: (p0) {
                  setState(() {
                    Localityfinal = p0;
                  });
                },
                contextIn: context,
                hintText: cityname == null ||
                        cityname == "" && Localityfinal == null ||
                        Localityfinal == ""
                    ? "Thane, Mumbai"
                    : resideAt.toString(),
              ), */
              SizedBox(
                height: 10.h,
              ),
              const customTextForWeather(
                title: "Pin code*",
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
                controller: pincodecontroler,
                onChanged: (p0) {},
                getid: (p0) {},
                contextIn: context,
                hintText: "Type to search",
              ),
              /*  CustomBottomSheetForPinCode(
                title: "locality",
                controller: pincodecontroler,
                onSubmit: (p0) {
                  setState(() {
                    pincode = p0;
                  });
                },
              ), */
              /*  CustomJobFormTextFieldRespOneProfile(
                onIDSelected: () {},
                // isSelected: isIndustry,
                focusNode: localityFocus,
                role: "",
                isCompany: false,
                isIndustry: true,
                name: "location",
                title: "locality",
                //controller: localityController,
                onChanged: (p0) {
                  setState(() {
                    isLocality = true;
                  });
                },
                onCitySubmit: (p0) {
                  setState(() {
                    cityname = p0;
                  });
                },
                onSubmit: (p0) {
                  setState(() {
                    Localityfinal = p0;
                  });
                },
                contextIn: context,
                hintText: cityname == null ||
                        cityname == "" && Localityfinal == null ||
                        Localityfinal == ""
                    ? "400-001"
                    : resideAt.toString(),
              ),
           */
              SizedBox(
                height: 10.h,
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
                          /*  ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '$suggestion Already added in the list.'),
                            ),
                          ); */
                        }
                      });
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(bottom: 6.h, top: 2.h, right: 15.sp),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedlist.contains(suggestion)
                                  ? Colors.transparent
                                  : Colors.grey.shade400),
                          color: !selectedlist.contains(suggestion)
                              ? Colors.transparent
                              : Constants.borderColor,
                          borderRadius: BorderRadius.circular(8.r)),
                      padding:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                      child: customTextForWeather(
                        title: suggestion.toString(),
                      ),
                    ),
                  );
                }).toList(),
              ),

              /* Flexible(
                    child: isLocality
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Locality",
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              customContainerSelect1(
                                true,
                                localityController.text,
                                true,
                                () {
                                  setState(() {
                                    isLocality = false;
                                    localityFocus.requestFocus();
                                    localityController.clear();
                                  });
                                },
                              ),
                            ],
                          )
                        : CustomJobFormTextFieldRespOne(
                            onIDSelected: () {},
                            // isSelected: isIndustry,
                            focusNode: localityFocus,
                            role: "",
                            isCompany: false,
                            isIndustry: true,
                            name: "location",
                            title: "locality",
                            controller: localityController,
                            onChanged: (p0) {
                              setState(() {
                                isLocality = true;
                              });
                            },
                            contextIn: context,
                            hintText: "Thane",
                          ),
                  ), */
              // SizedBox(width: 10),

              // Text(
              //   "Reside at",
              //   style: GoogleFonts.varela(
              //     fontSize: 13.sp,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // SizedBox(
              //   height: 35,
              //   width: 180.w,
              //   child: TextFormField(
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please select any job location';
              //       }
              //       return null;
              //     },
              //     controller: jobLocationController,
              //     enabled: true,
              //     onTap: (() {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return DialogList(
              //             tile: null,
              //             dialogTitle: "Select State",
              //             onSelected: (AutoCompleteModel model) async {
              //               await selectCity(model.value);
              //             },
              //             itemsData: stateList,
              //           );
              //         },
              //       );
              //     }),
              //     decoration: InputDecoration(
              //       contentPadding: const EdgeInsets.only(
              //         top: 10,
              //         left: 10,
              //       ),
              //       suffixIcon: const Icon(Icons.arrow_drop_down),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.grey.shade300,
              //         ),
              //         borderRadius: const BorderRadius.all(
              //           Radius.circular(20),
              //         ),
              //       ),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.grey.shade300,
              //         ),
              //         borderRadius: const BorderRadius.all(
              //           Radius.circular(20),
              //         ),
              //       ),
              //       hintText: 'Select Job City',
              //     ),
              //   ),
              // ),

              /*                   Row(
                children: [
                  Text(
                    "Blood Group",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = true;
                        isANeg = false;
                        isBPos = false;
                        isBNeg = false;
                        isOPos = false;
                        isONeg = false;
                        isABPos = false;
                        isABNeg = false;
                      });
                    },
                    isSelect: isAPos,
                    title: "A+",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = false;
                        isANeg = false;
                        isBPos = true;
                        isBNeg = false;
                        isOPos = false;
                        isONeg = false;
                        isABPos = false;
                        isABNeg = false;
                      });
                    },
                    isSelect: isBPos,
                    title: "B+",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = false;
                        isANeg = false;
                        isBPos = false;
                        isBNeg = false;
                        isOPos = true;
                        isONeg = false;
                        isABPos = false;
                        isABNeg = false;
                      });
                    },
                    isSelect: isOPos,
                    title: "O+",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = false;
                        isANeg = false;
                        isBPos = false;
                        isBNeg = false;
                        isOPos = false;
                        isONeg = false;
                        isABPos = true;
                        isABNeg = false;
                      });
                    },
                    isSelect: isABPos,
                    title: "AB+",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = false;
                        isANeg = true;
                        isBPos = false;
                        isBNeg = false;
                        isOPos = false;
                        isONeg = false;
                        isABPos = false;
                        isABNeg = false;
                      });
                    },
                    isSelect: isANeg,
                    title: "A-",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = false;
                        isANeg = false;
                        isBPos = false;
                        isBNeg = true;
                        isOPos = false;
                        isONeg = false;
                        isABPos = false;
                        isABNeg = false;
                      });
                    },
                    isSelect: isBNeg,
                    title: "B-",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = false;
                        isANeg = false;
                        isBPos = false;
                        isBNeg = false;
                        isOPos = false;
                        isONeg = true;
                        isABPos = false;
                        isABNeg = false;
                      });
                    },
                    isSelect: isONeg,
                    title: "O-",
                  ),
                  customContainerSelect(
                    isAnother: true,
                    onPressed: () {
                      setState(() {
                        isAPos = false;
                        isANeg = false;
                        isBPos = false;
                        isBNeg = false;
                        isOPos = false;
                        isONeg = false;
                        isABPos = false;
                        isABNeg = true;
                      });
                    },
                    isSelect: isABNeg,
                    title: "AB-",
                  ),
                ],
              ), */
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  data = null;
                                  isPresent = !isPresent;
                                  if (isPresent) {
                                    vaccination = "1";
                                  } else {
                                    vaccination = "0";
                                  }
                                }); // Notify Flutter that the state has changed
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        /* GestureDetector(
                          onTap: () {
                            setState(() {
                              isPresent = !isPresent;
                              if (isPresent) {
                                vaccination = "1";
                              } else {
                                vaccination = "0";
                              }
                            });
                          },
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(3),
                              color: isPresent
                                  ? Colors.red
                                  : Colors
                                      .white, // Change background color based on isPresent
                            ),
                            child: isPresent
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Container(),
                          ),
                        ), */

                        customTextForWeather(
                          title: "I am fully Covid-vaccinated.",
                          color: isPresent
                              ? Constants.black
                              : Constants.subtitleclr,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // customDocumnet(
                    //   "Vaccination Certificate",
                    // ),
                    if (isPresent)
                      if (data == null)
                        CustomDocumentUploadButton(
                          onTab: () async {
                            FileUploader fileUploader = FileUploader();

                            data = await fileUploader.uploadFile(
                                context, ['pdf'], "vacinationCertificate");
                            setState(() {});
                          },
                          title: "Add Vaccination Certificate",
                        )
                  ],
                ),
              ),

              if (data != null)
                CustomContainerSelectToViewDoc(
                  title: "Vaccination Certificate",
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return CustomPDFViewerDialog(
                          pdfUrl:
                              "https://s3.ap-south-1.amazonaws.com/job-circle-2/$data",
                          onRemove: () async {
                            await FileUploadService().deleteSingleFile(data!);
                            setState(() {
                              data = null;
                            });
                          },
                          onReplace: () {},
                        );
                      },
                    );
                  },
                ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 10.h,
              ),

              // Row(
              //   children: [
              //     Text(
              //       "Language Known",
              //       style: GoogleFonts.sourceSansPro(
              //         fontSize: 18.sp,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ],
              // ),
              // Container(
              //   width: double.maxFinite,
              //   margin: const EdgeInsets.only(top: 10, bottom: 12),
              //   child: Wrap(
              //     direction: Axis.horizontal,
              //     spacing: 5,
              //     runSpacing: 5,
              //     children: List.generate(
              //       jobTitleSuggestion.length,
              //       (index) {
              //         String title = jobTitleSuggestion[index];
              //         bool isSelected = selectedLanguages.contains(title);

              //         JobTitleItem item = JobTitleItem(
              //           getJobTitle1isSelected: null,
              //           ismulti: false,
              //           title: title,
              //           isSelected: isSelected,
              //           onTap: (selected) {
              //             setState(() {
              //               if (selected) {
              //                 selectedLanguages.add(title);
              //               } else {
              //                 selectedLanguages.remove(title);
              //               }
              //             });
              //           },
              //           isVisible: true,
              //           onlyOneIcon: false,
              //         );

              //         jobTitleItems.add(item);
              //         return item;
              //       },
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 6.h,
              // ),
              // const Divider(
              //   thickness: 1.5,
              // ),
              // SizedBox(
              //   height: 3.h,
              // ),
              // CustomFormTextFieldMultiSelect(
              //   name: "skills",
              //   isSkill: true,
              //   fetchApiskill: fetchApiskill,
              //   title: "Skills Required",
              //   controller: skillsController,
              //   selectedValuesList: selectedValuesList,
              //   callback: updateSelectedValues,
              //   contextIn: context,
              //   hintText: "Advance Excel",
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /* InkWell customContainerSelectToViewDoc({
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

  /* GestureDetector customDocumentUploadButton() {
    return GestureDetector(
                            onTap: () {
                              setState(() async {
                                data = await uploadFile(['pdf']);
                                setState(() {});
                                /*  var payload = {
                                "stage": "upload_cv",
                                "data": {
                                  "id": await Utils.getPreferencesValue(
                                    null,
                                    ESharedPreferences.user_id.name,
                                  ),
                                  "cv_link": data['fileName'],
                                },
                              }; */
                                // await save(data['fileName'], payload);
                              });
                            },
                            child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                dashPattern: const [4, 4],
                                color: Colors.grey.shade400,
                                strokeWidth: 2,
                                child: SizedBox(
                                  /*  width: MediaQuery.of(context)
                                          .size
                                          .width /
                                      1.1, */
                                  //  color: Colors.amber,

                                  child: Center(
                                      child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 8.h, bottom: 8.h),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6.h, horizontal: 10.w),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(2, 4),
                                                  blurStyle: BlurStyle.outer,
                                                  color: Colors.grey.shade600,
                                                  blurRadius: 3.1)
                                            ]),
                                        child: Text(
                                          "Add Vaccination Certificate",
                                          style: GoogleFonts.varela(
                                              fontSize: 12.sp,
                                              color: Constants.darkBlue),
                                        ),
                                      ),
                                      Text(
                                        "Supported formate : PDF",
                                        style: GoogleFonts.varela(
                                          fontSize: 10.sp,
                                          color: Colors.grey.shade500,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      )
                                    ],
                                  )),
                                )),

                            /* Container(
                              margin:
                                  const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(8.r),
                                border: Border.all(
                                    color: Constants.borderColor),
                              ),
                              child: const Text(
                                  "Upload Vaccination Certificate"),
                            ), */
                          );
  } */

  void performSpecificOperation() {
    // Replace this with your specific operation logic
    if (primaryNumber.text != widget.prevPageModel!.mobile) {
      setState(() {
        saveOTP();
      });
    }
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    if (!emailRegex.hasMatch(email)) {
      return false; // Invalid email format
    }

    // Extract domain and clean spaces
    String domain = email.split('@').last.toLowerCase().replaceAll(' ', '');

    return domain == "gmail.com"; // ✅ Only return true if it's "gmail.com"
  }

  bool isEmailOk = false;

  Row customDocumnet(
    String title,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      vaccination_certificate = !vaccination_certificate;
                    });
                  },
                  child: vaccination_certificate
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
              vaccination_certificate
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
        vaccination_certificate
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 26.h,
              )
            : const SizedBox(),
      ],
    );
  }

  void showOTPVerificationPopup() {
    FocusNode initialFocusNode = otpChar1FocusNode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // startTimer();
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildOTPDigitTextField(
                          otpChar1Controller,
                          otpChar1FocusNode,
                          otpChar2FocusNode,
                        ),
                        buildOTPDigitTextField(
                          otpChar2Controller,
                          otpChar2FocusNode,
                          otpChar3FocusNode,
                        ),
                        buildOTPDigitTextField(
                          otpChar3Controller,
                          otpChar3FocusNode,
                          otpChar4FocusNode,
                        ),
                        buildOTPDigitTextField(
                          otpChar4Controller,
                          otpChar4FocusNode,
                          null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // Add your logic to handle OTP verification here
                        handleOTPVerification(getEnteredOTP());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.themeBgColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 120,
                        padding: const EdgeInsets.only(bottom: 7, top: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verify OTP',
                              style: GoogleFonts.varela(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      timerText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      otpChar1Controller.text = "";
      otpChar2Controller.text = "";
      otpChar3Controller.text = "";
      otpChar4Controller.text = "";
      initialFocusNode.requestFocus();
    });
  }

  /* void updateTimerDisplay() {
    setState(() {
      if (currentSeconds <= 0) {
        ticker.stop();
      }
    });
  } */

  /*  void startTimer() {
    var duration = const Duration(seconds: 1);
    currentSeconds = timerMaxSeconds;
    ticker = Ticker((elapsed) {
      setState(() {
        currentSeconds = timerMaxSeconds - elapsed.inSeconds;
        updateTimerDisplay();
      });
    });
    ticker.start();
  } */

  void _onOTPDigitChanged(
      String value, FocusNode currentFocusNode, FocusNode nextFocusNode) {
    if (value.isNotEmpty) {
      currentFocusNode.unfocus();
      nextFocusNode.requestFocus();
    }
  }

  Widget buildOTPDigitTextField(
    TextEditingController controller,
    FocusNode currentFocusNode,
    FocusNode? nextFocusNode,
  ) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        maxLength: 1,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        focusNode: currentFocusNode,
        onChanged: (value) {
          _onOTPDigitChanged(value, currentFocusNode, nextFocusNode!);
          print(
              "Current Focus Node: $currentFocusNode, Next Focus Node: $nextFocusNode");
        },
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
        ),
      ),
    );
  }

  void validateOtp() {
    if (otpChar1Controller.text != "" &&
        otpChar2Controller.text != "" &&
        otpChar3Controller.text != "" &&
        otpChar4Controller.text != "") {
      vrifyButtonDisabled = false;
    } else {
      vrifyButtonDisabled = true;
    }
    setState(() {});
  }

  String getEnteredOTP() {
    return otpChar1Controller.text +
        otpChar2Controller.text +
        otpChar3Controller.text +
        otpChar4Controller.text;
  }

  saveOTP() async {
    //bool validate = basicForm.currentState!.validate();
    /* if (!validate) {
      return;
    } */
    var result =
        await UserDataService().authenticate({"mobile": primaryNumber.text});
    var res = Utils.parseResponse(result);
    if (res.resultKey == 'SUCCESS') {
      if (res.resultData['val'] == 0) {
        Widget continueButton = TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        );

        AlertDialog alert = AlertDialog(
          title: const Text("!!Alert!!"),
          content: Text(res.resultData['otpmsg']),
          actions: [continueButton],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else {
        // prefs.remove('userid');
        // prefs.remove('user_mob');
        // prefs.setInt('userid',Utils.parseResponse(result).resultData[1]);
        Utils.setPreference(
            null, ESharedPreferences.user_mobile.name, primaryNumber.text);

        // Call loginUser() when the user successfully logs in
        // loginUser();
        showOTPVerificationPopup();
        //   Navigator.pushNamed(context, ERoute.otpscreen.name);
      }
      // Navigator.pushNamedAndRemoveUntil(
      //     context, ERoute.otpscreen.name, (Route<dynamic> route) => false);
    }
  }

  void handleOTPVerification(String enteredOTP) async {
    SharedPreferences pres = await Utils.getSharedPreferences();
    String primaryNumber = await Utils.getPreferencesValue(
        pres, ESharedPreferences.user_mobile.name);

    var result = await UserDataService().validateOTP({
      "mobile": primaryNumber,
      "otp": enteredOTP,
    });
    RequestResult res = Utils.parseResponse(result);
    if (res.resultKey == 'SUCCESS') {
      dynamic data = res.resultData;

      if (res.resultData.containsKey('msg')) {
        clearOTPText();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid OTP. Please try again."),
        ));
      } else {
        // await Utils.setPreference(
        /*      pres, ESharedPreferences.user_id.name, data['id']);
        await Utils.setPreference(pres, ESharedPreferences.user_type.name,
            int.parse(data['usertype']));

        CardModel model = CardModel();
        model.mobile = primaryNumber;
        model.cardName = (data['firstName'] + " " + data['lastName']);
        model.firstName = data['firstName'];
        model.lastName = data['lastName'];
        model.email = data['email'];
        model.role = data['role'];
        model.gender = data['gender'];

        await Utils.setPreference(
            pres, ESharedPreferences.role.name, data['role']);
        await Utils.setPreference(pres, ESharedPreferences.user_data.name,
            jsonEncode(model.toJson()));
        await Utils.setPreference(
            pres, ESharedPreferences.user_rawData.name, jsonEncode(data)); */
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP Verified Successfully"),
        ));
      }
    } else {
      // Handle the case when the OTP verification fails
      clearOTPText();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP. Please try again."),
      ));
    }
  }

  void clearOTPText() {
    otpChar1Controller.text = "";
    otpChar2Controller.text = "";
    otpChar3Controller.text = "";
    otpChar4Controller.text = "";
  }

  /*  calculateAge(String birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  } */
  int calculateAge(String dateOfBirthText) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateOfBirth = DateTime.now();
    if (dateOfBirthText != "") {
      try {
        dateOfBirth = dateFormat.parse(dateOfBirthText);
        print('Parsed date: $dateOfBirth');
      } catch (e) {
        print('Error parsing date: $e');
      }
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
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            width: MediaQuery.of(context).size.width / 2.3,
            //   height: MediaQuery.of(context).size.height / 22.h,
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
              child: Text(title,
                  style: GoogleFonts.varela(
                      fontWeight:
                          isSelect ? FontWeight.bold : FontWeight.normal,
                      color: isSelect ? Constants.black : Colors.black,
                      fontSize: 12.sp)),
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

    var userTypeValue = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_type.name);

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

    var mobilenumber = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_mobile.name);

    int demoid = int.tryParse(await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name)) ??
        0;

// Agar aapko demoid ko String ki tarah use karna hai:
    String demoidString = demoid.toString();
    //if(primaryNumber.text.isNotEmpty&&firstName.te){}
    int? mobile = int.tryParse(contactno.text.trim());

    UserRequest userRequest = UserRequest(
      userId: 0,
      firstName: firstName.text.trim(),
      middleName: middleName.text.trim(),
      lastName: lastName.text.trim(),
      mobile: int.tryParse(contactno.text),
      alternateNo: altercontactno.text.isNotEmpty
          ? int.parse(altercontactno.text.trim())
          : null,
      email: emailadr.text.toLowerCase(),
      gender: genderValue,
      dateOfBirth: DateFormat("yyyy-MM-dd").format(dataOfBirthValue).toString(),
      userLocation: cityname,
      userLocality: Localityfinal,
      pinCode: pincodecontroler.text,
      languages: selectedlist,
      vaccination: isPresent,
      userType: (userTypeValue is int)
          ? userTypeValue
          : int.tryParse(userTypeValue.toString()),
      vaccinationCertificate: isPresent ? data : null,
      bio: bio.text.trim().isEmpty ? null : bio.text,
    );

    /* var params = {
      "stage": "basic_info",
      "data": {
        "id": demoid,
        "mobile": primaryNumber.text.trim(),
        "alternate_no": altercontactno.text,
        "first_name": firstName.text.trim(),
        "middle_name": middleName.text.trim(),
        "last_name": lastName.text.trim(),
        "gender": genderValue,

        // "languages": selectedLanguages,
        // "skills": fetchApiskill,
        "user_location": cityname,
        "user_locality": Localityfinal, // <-- Update here
        "email": emailadr.text.toLowerCase(), // <-- Update here
        // "martial_status": martialStatusValue,
        "vaccination": vaccination,
        "dateofbirth":
            DateFormat("yyyy-MM-dd").format(dataOfBirthValue).toString(),
        "bio": bio.text.trim().isEmpty ? null : bio.text,
        "usertype": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_type.name),
        "vaccination_certificate":
            data != null && vaccination != "0" ? data : null,
        "language_known": selectedlist
      }
    }; */

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SelectExpEducation(introData: userRequest, userID: demoid)));
    log(demoid);

    Utils.setCacheData('firstName', firstName.text);
  }
}
