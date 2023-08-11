import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/scheduler.dart'
    show Ticker, TickerProvider, SingleTickerProviderStateMixin;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/autocompleteCheckBoxModel.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/profile/screen2.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../components/autolistviewmodal.dart';
import '../../constants/customSelection.dart';
import '../../constants/customTextfield.dart';
import '../../constants/gobal.dart';
import '../../models/api_response.dart';
import '../../service/FileUploadService.dart';

class Screen1 extends StatefulWidget {
  Screen1({Key? key, this.prevPageModel}) : super(key: key);
  late ProfileSummaryModel? prevPageModel;
  // ProfileSummaryModel profilemodel;
  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with SingleTickerProviderStateMixin {
  late Widget previousWidget;

  // Veriable Declaration
  // DropdownModel ddlModel;
  List locationList = [];
  CardModel model = CardModel();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userLocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
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

  FocusNode localityFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode primaryNumberFocus = FocusNode();
  FocusNode secondaryNumberFocus = FocusNode();
  FocusNode otpChar2FocusNode = FocusNode();
  FocusNode otpChar3FocusNode = FocusNode();
  FocusNode otpChar4FocusNode = FocusNode();
  FocusNode otpChar1FocusNode = FocusNode();

  String gender = "";
  String martialStatus = "";
  List<dynamic> selectedValuesList = [];
  List<String> selectedValues = [];
  FocusNode industryFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode middleNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();

  List<dynamic> fetchApiskill = [];
  List<dynamic> jobTitleSuggestion = [];
  List<bool> isSelected = [];
  List<dynamic> fetchApiLanguages = [];
  List<dynamic> selectedLanguages = [];
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
  late Ticker ticker;

  String get timerText =>
      '${(currentSeconds ~/ 60).toString().padLeft(2, '0')}: ${(currentSeconds % 60).toString().padLeft(2, '0')}';

  var ddlValues;

  late List list;

  final basicForm = GlobalKey<FormState>();

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
  void dispose() {
    // Cancel the countdown timer when the widget is disposed
    ticker.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      primaryNumber = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_mobile.name);
      setState(() {});
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
    startTimer();

    ticker = Ticker((_) => updateTimerDisplay());

    bindLocation();
    dateOfBirth.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

    dt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    industryFocus.requestFocus();
    getJobTitle("pattern", "language").then((_) {
      isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
      setState(() {});
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
        selectedLocation = widget.prevPageModel?.user_location == null
            ? AutoCompleteModel("", "", {})
            : AutoCompleteModel(
                widget.prevPageModel!.user_location.toString(), "", {});
        jobLocationController.text = widget.prevPageModel?.user_location == null
            ? ''
            : widget.prevPageModel!.user_location.toString();

        localityController.text =
            widget.prevPageModel!.user_locality.toString();
        setState(() {
          isLocality = true;
        });

        setState(() {
          isCity = true;
        });

        emailadr.text = widget.prevPageModel!.email.toString();
        primaryNumber.text = widget.prevPageModel!.mobile.toString();
        secondaryNumber.text = widget.prevPageModel!.alternate_no.toString();

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
        fetchApiLanguages = widget.prevPageModel!.languages!.cast<String>();
        selectedLanguages = fetchApiLanguages;
      });
    }
  }

  DateTime? selectedDate;
  void selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateOfBirth.text =
            pickedDate.toString(); // Update the TextFormField text
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
          if (widget.prevPageModel?.languages != null) {
            if (widget.prevPageModel!.languages!.indexOf(e['value']) > -1) {
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

      setState(() {});
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Add this line
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Introduction",
                style: GoogleFonts.varela(
                  fontSize: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Introduce yourself to the recruiters",
                style: GoogleFonts.varela(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            if (basicForm.currentState!.validate()) {
              save();
            }
          },
          child: Container(
            margin:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
                color: Constants.themeBgColor,
                borderRadius: BorderRadius.circular(15)),
            width: double.maxFinite,
            padding: const EdgeInsets.only(bottom: 7, top: 7),
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

        /* Container(
            color: Constants.bgPanelColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ThemeButton(
                color: Constants.borderColor,
                /* icon: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xffffffff),
                  size: 25,
                ), */
                radious: 15,
                isText: true,
                onPressed: () {
                  if (basicForm.currentState!.validate()) {
                    save();
                  }
                },
                text: widget.prevPageModel == null ? "Next" : "Save",
                themeButtonSize: ThemeButtonSize.medium,
              ),
            ),
          ), */
        // backgroundColor: ,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    basicInfo(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget basicInfo() {
    age = ((DateTime.now().difference(dataOfBirthValue)).inDays / 365.floor());
    return Container(
      margin: const EdgeInsets.only(top: 10),
      key: const Key('second'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
          child: Form(
            key: basicForm,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "First Name",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  // color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600),
                            ),
                            isFirstName
                                ? customContainerSelect(
                                    isVacancy: true,
                                    isCross: true,
                                    isNumOfOpening: true,
                                    onPressed: () {
                                      setState(() {
                                        isFirstName = false;
                                        // FocusScope.of(context).autofocus(focusNode);
                                        firstName.clear();
                                        firstNameFocus.requestFocus();
                                      });
                                    },
                                    isSelect: true,
                                    title: firstName.text)
                                : Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.32,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                                            // focusNode: firstNameFocus,
                                            // maxLength: 3,
                                            onFieldSubmitted: (value) {
                                              firstName.text.isNotEmpty
                                                  ? setState(() {
                                                      isFirstName = true;
                                                      // _showContainer1 = value.isEmpty;
                                                    })
                                                  : null;
                                            },
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            onTapOutside: (event) {
                                              firstName.text.isNotEmpty
                                                  ? setState(() {
                                                      isFirstName = true;
                                                      // _showContainer1 = value.isEmpty;
                                                    })
                                                  : null;
                                            },
                                            onEditingComplete: () {
                                              firstName.text.isNotEmpty
                                                  ? setState(() {
                                                      isFirstName = true;
                                                      // _showContainer1 = value.isEmpty;
                                                    })
                                                  : null;
                                            },
                                            keyboardType: TextInputType.text,
                                            controller: firstName,
                                            // enabled: enableShortListFor,
                                            onTap: (() {}),
                                            decoration: InputDecoration(
                                                counterText: '',
                                                // contentPadding:
                                                //     const EdgeInsets.only(
                                                //         // top: 8,
                                                //         // bottom: 8,
                                                //         left: 10,
                                                //         right: 10),
                                                // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                                // Icons.workspace_premium
                                                // label: const Text("Company Name *"),
                                                //border: OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Color(0xffff0eceb)),
                                                ),
                                                focusColor:
                                                    const Color(0xffff0eceb),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 122, 113, 111)),
                                                ),
                                                hintText:
                                                    "Enter you first name",
                                                hintStyle:
                                                    GoogleFonts.sourceSansPro(
                                                        color: Constants
                                                            .subtitleclr,
                                                        fontSize: 15.sp)
                                                //  prefixIcon: Icon(Icons.list)
                                                ),
                                          ),
                                        ),
                                      ],
                                    )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.h,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Middle Name",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  // color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600),
                            ),
                            isMiddleName
                                ? customContainerSelect(
                                    isVacancy: true,
                                    isCross: true,
                                    isNumOfOpening: true,
                                    onPressed: () {
                                      setState(() {
                                        isMiddleName = false;
                                        // FocusScope.of(context).autofocus(focusNode);
                                        middleName.clear();
                                        firstNameFocus.requestFocus();
                                      });
                                    },
                                    isSelect: true,
                                    title: middleName.text)
                                : Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.32,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                                            // focusNode: firstNameFocus,
                                            // maxLength: 3,
                                            onFieldSubmitted: (value) {
                                              middleName.text.isNotEmpty
                                                  ? setState(() {
                                                      isMiddleName = true;
                                                      // _showContainer1 = value.isEmpty;
                                                    })
                                                  : null;
                                            },
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            onTapOutside: (event) {
                                              middleName.text.isNotEmpty
                                                  ? setState(() {
                                                      isMiddleName = true;
                                                      // _showContainer1 = value.isEmpty;
                                                    })
                                                  : null;
                                            },
                                            onEditingComplete: () {
                                              middleName.text.isNotEmpty
                                                  ? setState(() {
                                                      isMiddleName = true;
                                                      // _showContainer1 = value.isEmpty;
                                                    })
                                                  : null;
                                            },
                                            keyboardType: TextInputType.text,
                                            controller: middleName,
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
                                                      color:
                                                          Color(0xffff0eceb)),
                                                ),
                                                focusColor:
                                                    const Color(0xffff0eceb),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 122, 113, 111)),
                                                ),
                                                hintText:
                                                    "Enter you middle name",
                                                hintStyle:
                                                    GoogleFonts.sourceSansPro(
                                                        color: Constants
                                                            .subtitleclr,
                                                        fontSize: 15.sp)
                                                //  prefixIcon: Icon(Icons.list)
                                                ),
                                          ),
                                        ),
                                      ],
                                    )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last Name",
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 18.sp,
                              // color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600),
                        ),
                        isLastName
                            ? customContainerSelect(
                                isVacancy: true,
                                isCross: true,
                                isAnother: true,
                                isNumOfOpening: false,
                                onPressed: () {
                                  setState(() {
                                    isLastName = false;
                                    // FocusScope.of(context).autofocus(focusNode);
                                    lastName.clear();
                                    firstNameFocus.requestFocus();
                                  });
                                },
                                isSelect: true,
                                title: lastName.text)
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
                                        // inputFormatters: [
                                        //   FilteringTextInputFormatter.deny(
                                        //       RegExp(r'[.]')),
                                        //   FilteringTextInputFormatter.
                                        // ],
                                        // focusNode: firstNameFocus,
                                        // maxLength: 3,
                                        onFieldSubmitted: (value) {
                                          lastName.text.isNotEmpty
                                              ? setState(() {
                                                  isLastName = true;
                                                  // _showContainer1 = value.isEmpty;
                                                })
                                              : null;
                                        },
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        onTapOutside: (event) {
                                          lastName.text.isNotEmpty
                                              ? setState(() {
                                                  isLastName = true;
                                                  // _showContainer1 = value.isEmpty;
                                                })
                                              : null;
                                        },
                                        onEditingComplete: () {
                                          lastName.text.isNotEmpty
                                              ? setState(() {
                                                  isLastName = true;
                                                  // _showContainer1 = value.isEmpty;
                                                })
                                              : null;
                                        },
                                        keyboardType: TextInputType.text,
                                        controller: lastName,
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
                                            hintText: "Enter your last name",
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
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Primary Number",
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            isPrimaryNumberVerified
                                ? customContainerSelect(
                                    isVacancy: true,
                                    isCross: true,
                                    isNumOfOpening: true,
                                    onPressed: () {
                                      setState(() {
                                        isPrimaryNumberVerified = false;
                                        // FocusScope.of(context).autofocus(focusNode);
                                        primaryNumber.clear();
                                        primaryNumberFocus.requestFocus();
                                      });
                                    },
                                    isSelect: true,
                                    title: primaryNumber.text,
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.32,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                                            // onFieldSubmitted: (value) {
                                            //   if (primaryNumber
                                            //       .text.isNotEmpty) {
                                            //     setState(() {
                                            //       // Trigger OTP verification process here
                                            //       // Call a function to send OTP to the primary number
                                            //       // sendOtpToPrimaryNumber(primaryNumberController.text);
                                            //       isPrimaryNumberVerified =
                                            //           true;
                                            //     });
                                            //   }
                                            // },
                                            onFieldSubmitted: (value) {
                                              if (primaryNumber
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  // startTimer();
                                                });
                                                saveOTP();
                                              }
                                            },

                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            onTapOutside: (event) {
                                              if (primaryNumber
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  isPrimaryNumberVerified =
                                                      true;
                                                });
                                              }
                                            },
                                            onEditingComplete: () {
                                              if (primaryNumber
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  isPrimaryNumberVerified =
                                                      true;
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: primaryNumber,
                                            onTap: (() {}),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xffff0eceb),
                                                ),
                                              ),
                                              focusColor:
                                                  const Color(0xffff0eceb),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 122, 113, 111),
                                                ),
                                              ),
                                              hintText:
                                                  "Enter your primary number",
                                              hintStyle:
                                                  GoogleFonts.sourceSansPro(
                                                color: Constants.subtitleclr,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.h,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Secondary Number",
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            isSecondaryNumber
                                ? customContainerSelect(
                                    isVacancy: true,
                                    isCross: true,
                                    isNumOfOpening: true,
                                    onPressed: () {
                                      setState(() {
                                        isSecondaryNumber = false;
                                        // FocusScope.of(context).autofocus(focusNode);
                                        secondaryNumber.clear();
                                        secondaryNumberFocus.requestFocus();
                                      });
                                    },
                                    isSelect: true,
                                    title: secondaryNumber.text,
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.32,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                                            onFieldSubmitted: (value) {
                                              if (secondaryNumber
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  // Trigger OTP verification process here
                                                  // Call a function to send OTP to the secondary number
                                                  // sendOtpToSecondaryNumber(secondaryNumberController.text);
                                                  isSecondaryNumber = true;
                                                });
                                              }
                                            },
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            onTapOutside: (event) {
                                              if (secondaryNumber
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  isSecondaryNumber = true;
                                                });
                                              }
                                            },
                                            onEditingComplete: () {
                                              if (secondaryNumber
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  isSecondaryNumber = true;
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: secondaryNumber,
                                            onTap: (() {}),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xffff0eceb),
                                                ),
                                              ),
                                              focusColor:
                                                  const Color(0xffff0eceb),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 122, 113, 111),
                                                ),
                                              ),
                                              hintText:
                                                  "Enter your secondary number",
                                              hintStyle:
                                                  GoogleFonts.sourceSansPro(
                                                color: Constants.subtitleclr,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Gender",
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
                            istranse = false;
                            ismale = true;
                            isfemale = false;
                          });
                        },
                        isSelect: ismale,
                        title: "Male",
                      ),
                      customContainerSelect(
                        isAnother: true,
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
                      customContainerSelect(
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email ID",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      isEmail
                          ? customContainerSelect(
                              isVacancy: true,
                              isCross: true,
                              isAnother: false,
                              isEmails: true,
                              isNumOfOpening: false,
                              onPressed: () {
                                setState(() {
                                  isEmail = false;
                                  // FocusScope.of(context).autofocus(focusNode);
                                  emailadr.clear();
                                  firstNameFocus.requestFocus();
                                });
                              },
                              isSelect: true,
                              title: emailadr.text)
                          : Container(
                              width: MediaQuery.of(context).size.width / 1.8,
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
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    height: 35,
                                    color: Colors.white,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This Text field Cant be empty";
                                        }
                                        return null;
                                      },
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.deny(
                                      //       RegExp(r'[.]')),
                                      //   FilteringTextInputFormatter.
                                      // ],
                                      // focusNode: firstNameFocus,
                                      // maxLength: 3,
                                      onFieldSubmitted: (value) {
                                        emailadr.text.isNotEmpty
                                            ? setState(() {
                                                isEmail = true;
                                                // _showContainer1 = value.isEmpty;
                                              })
                                            : null;
                                      },
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      onTapOutside: (event) {
                                        emailadr.text.isNotEmpty
                                            ? setState(() {
                                                isEmail = true;
                                                // _showContainer1 = value.isEmpty;
                                              })
                                            : null;
                                      },
                                      onEditingComplete: () {
                                        emailadr.text.isNotEmpty
                                            ? setState(() {
                                                isEmail = true;
                                                // _showContainer1 = value.isEmpty;
                                              })
                                            : null;
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: emailadr,
                                      // enabled: enableShortListFor,
                                      onTap: (() {}),
                                      decoration: InputDecoration(
                                          counterText: '',
                                          contentPadding: const EdgeInsets.only(
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
                                          focusColor: const Color(0xffff0eceb),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 122, 113, 111)),
                                          ),
                                          hintText: "Enter your email address",
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
                  SizedBox(
                    height: 6.h,
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
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
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date Of Birth",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      isDateOfBirth
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customContainerSelect(
                                  isVacancy: true,
                                  isCross: true,
                                  isAnother: false,
                                  isEmails: true,
                                  isNumOfOpening: false,
                                  onPressed: () async {
                                    setState(() {
                                      isDateOfBirth = false;
                                    });
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().add(
                                        const Duration(days: -(365 * 50)),
                                      ),
                                      lastDate: DateTime.now(),
                                      currentDate: dataOfBirthValue,
                                      firstDate: DateTime.now(),
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      dataOfBirthValue = pickedDate;
                                      setState(() {
                                        dateOfBirth.text = formattedDate;
                                        dt = DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .format(pickedDate);
                                        year = (dt - DateTime.now());
                                        isDateOfBirth = false;
                                        dateOfBirth.clear();
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                  isSelect: true,
                                  title: dateOfBirth.text,
                                ),
                                Text(
                                  "Age: ${calculateAge(dataOfBirthValue).toString()}",
                                ),
                              ],
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 1.8,
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
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    height: 35,
                                    color: Colors.white,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "This Text field Cant be empty";
                                        }
                                        return null;
                                      },
                                      // focusNode: firstNameFocus,
                                      onFieldSubmitted: (value) {
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
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: dateOfBirth,
                                      onTap: () {
                                        selectDate();
                                      },
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
                                        hintText: "Enter your date of birth",
                                        hintStyle: GoogleFonts.sourceSansPro(
                                            color: Constants.subtitleclr,
                                            fontSize: 15.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
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
                              onIDSelected: (){},
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
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: isCity
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "City",
                                    style: GoogleFonts.sourceSansPro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  customContainerSelect1(
                                    true,
                                    jobLocationController.text,
                                    true,
                                    () {
                                      setState(() {
                                        isCity = false;
                                        cityFocus.requestFocus();
                                        jobLocationController.clear();
                                      });
                                    },
                                  ),
                                ],
                              )
                            : CustomJobFormTextFieldRespOne(
                              onIDSelected: (){},
                                // isSelected: isIndustry,
                                focusNode: cityFocus,
                                role: "",
                                isCompany: false,
                                isIndustry: true,
                                name: "city",
                                title: "City",
                                controller: jobLocationController,
                                onChanged: (p0) {
                                  setState(() {
                                    isCity = true;
                                  });
                                },
                                contextIn: context,
                                hintText: "Mumbai",
                              ),
                      ),
                    ],
                  ),

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
                  SizedBox(
                    height: 6.h,
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Have you been fully vaccinated?",
                              style: GoogleFonts.varela(
                                color: isPresent
                                    ? Colors.black
                                    : Colors.grey.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
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
                          Column(
                            children: [
                              // Text(
                              //   "Please Upload Your Vaccination Certificate",
                              //   style: GoogleFonts.varela(
                              //     color: isPresent
                              //         ? Colors.black
                              //         : Colors.grey.shade400,
                              //     fontWeight: FontWeight.w400,
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  setState(() async {
                                    var data = await uploadFile(['pdf']);
                                    var payload = {
                                      "stage": "upload_cv",
                                      "data": {
                                        "id": await Utils.getPreferencesValue(
                                          null,
                                          ESharedPreferences.user_id.name,
                                        ),
                                        "cv_link": data['fileName'],
                                      },
                                    };
                                    // await save(data['fileName'], payload);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                        color: Constants.borderColor),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(
                                            "Upload Vaccination Certificate"),
                                      ),
                                      const SizedBox(
                                          width:
                                              4), // Adjust the spacing between text and icon
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Image.asset(
                                          "assets/images/cv.png",
                                          height: 18.h,
                                        ),
                                      ) // Replace Icons.file_upload with your desired icon
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
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
                  ),
                  SizedBox(
                    height: 15.h,
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
        ),
      ),
    );
  }

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
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  void updateTimerDisplay() {
    setState(() {
      if (currentSeconds <= 0) {
        ticker.stop();
      }
    });
  }

  void startTimer() {
    var duration = const Duration(seconds: 1);
    currentSeconds = timerMaxSeconds;
    ticker = Ticker((elapsed) {
      setState(() {
        currentSeconds = timerMaxSeconds - elapsed.inSeconds;
        updateTimerDisplay();
      });
    });
    ticker.start();
  }

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
        decoration: InputDecoration(
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
    bool validate = basicForm.currentState!.validate();
    if (!validate) {
      return;
    }
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
        await Utils.setPreference(
            pres, ESharedPreferences.user_id.name, data['id']);
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
            pres, ESharedPreferences.user_rawData.name, jsonEncode(data));
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

  calculateAge(DateTime birthDate) {
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
  }

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

  uploadFile(allowExt) async {
    Utils.showLoaderDialog(context, "Uploading...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowExt,
        withReadStream: true);

    if (result != null) {
      var res =
          await FileUploadService().uploadSingleFile("cv", result.files.single);
      var resultD = Utils.parseResponse(res);
      Navigator.pop(context);
      if (resultD.resultKey == 'SUCCESS') {
        return resultD.resultData[0];
      }
      // File file = File(result.files.single.readStream.first!);
    } else {
      Navigator.pop(context);
      return null;
      // User canceled the picker
    }
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

    var mobilenumber = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_mobile.name);

    var params = {
      "stage": "basic_info",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "mobile": primaryNumber.text,
        "alternate_no": secondaryNumber.text,
        "first_name": firstName.text.trim(),
        "middle_name": middleName.text.trim(),
        "last_name": lastName.text.trim(),
        "gender": genderValue,
        "languages": selectedLanguages,
        "skills": fetchApiskill,
        "user_location": selectedLocation.value, // <-- Update here
        "email": emailadr.text, // <-- Update here
        "martial_status": martialStatusValue,
        "vaccination": vaccination,
        "dateofbirth": DateFormat("yyyy-MM-dd").format(dataOfBirthValue),
        "usertype": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_type.name),
      }
    };

    // Continue with the remaining logic...

    CardModel model = CardModel();
    model.mobile = primaryNumber.text;

    model.cardName = (firstName.text + " " + lastName.text).toTitleCase();
    model.email = emailadr.text;
    model.martial_status = martialStatusValue;
    model.gender = genderValue;
    print(params);
    var result = await UserDataService().saveUserStages(params);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      await Utils.setPreference(
          prefs, ESharedPreferences.user_data.name, jsonEncode(model));
      if (widget.prevPageModel == null) {
        Navigator.pushNamed(context, ERoute.screen2.name);
      } else {
        widget.prevPageModel!.first_name = firstName.text;
        widget.prevPageModel!.last_name = lastName.text;
        widget.prevPageModel!.user_location = selectedLocation.label;
        /* widget.prevPageModel.job_location_id =
            int.parse(selectedLocation.value); */
        widget.prevPageModel!.gender = gender;
        widget.prevPageModel!.martial_status = martialStatus;
        widget.prevPageModel!.languages = selectedLanguages;
        // widget.prevPageModel!.skills = fetchApiskill;
        widget.prevPageModel!.dateofbirth =
            DateFormat("yyyy-MM-dd").format(dataOfBirthValue);

        Navigator.pop(context, widget.prevPageModel);
      }
      Utils.setCacheData('firstName', firstName.text);
    }
    setState(() {});
  }
}
