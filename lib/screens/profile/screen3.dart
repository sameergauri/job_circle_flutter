import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../constants/customTextfield.dart';
import '../../models/autocompleteModel.dart';
import '../../service/UserDataService.dart';

class Screen3 extends StatefulWidget {
  Screen3({Key? key, this.prevPageModel, this.expirieanceFlag})
      : super(key: key);
  final bool? expirieanceFlag;
  // final dynamic prevPageModel;
  late Experience? prevPageModel;

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
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

  late List<AutoCompleteModel> jobTitleList = [];
  late List<AutoCompleteModel> totalExperienceList = [];
  late List<AutoCompleteModel> currentSalaryList = [];
  AutoCompleteModel selectedJobTitle = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedtotalExperience = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedcurrentSalary = AutoCompleteModel("", "", {});

  List<String> fetchApiskill = [];
  String? fetchApiGender;
  FocusNode titleFocus = FocusNode();

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
  bool isMonthly = true; // Set the initial value based on your logic
  var dt;
  bool apportunities = false;

  DateTime joiningDateValue = DateTime.now();
  DateTime lastWorkingDateValue = DateTime.now();

  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  DateTime? selectedDate;
  DateTime? selectedLastWorkingDate;

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
        joiningDataController.text =
            pickedDate.toString(); // Update the TextFormField text
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

    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    if (widget.prevPageModel != null) {
      companyController.text = widget.prevPageModel!.company_name ?? '';
      setState(() {
        expID = widget.prevPageModel!.id;
      });
      setState(() {
        //  userID = widget.prevPageModel!.userId;
      });
      if (companyController.text.isNotEmpty) {
        setState(() {
          isCompanyName = true;
        });
      }
      companyLocationController.text =
          widget.prevPageModel!.company_location ?? '';
      if (companyLocationController.text.isNotEmpty) {
        setState(() {
          isCompanyLocation = true;
        });
      }
      companyWebsiteController.text =
          widget.prevPageModel!.company_website ?? '';
      if (companyWebsiteController.text.isNotEmpty) {
        setState(() {
          isCOmpanyWebsite = true;
        });
      }

      currentSalaryController.text = widget.prevPageModel!.salary ?? '';
      if (currentSalaryController.text.isNotEmpty) {
        setState(() {
          isCurrentSalary = true;
        });
      }

      joiningDataController.text = widget.prevPageModel!.joining_date != null
          ? dateFormatter.format(widget.prevPageModel!.joining_date!)
          : '';

      lastWorkingController.text =
          widget.prevPageModel!.last_working_date != null
              ? dateFormatter.format(widget.prevPageModel!.last_working_date!)
              : '';

      work_type = widget.prevPageModel!.work_type.toString();
      jobTitleController.text = widget.prevPageModel!.job_title.toString();
      if (widget.prevPageModel!.job_title!.isNotEmpty) {
        isJobTitlle = true;
      }
      if (widget.prevPageModel!.work_type == "On-Site") {
        setState(() {
          isOnsite = true;
        });
      } else if (widget.prevPageModel!.work_type == "Hybrid") {
        setState(() {
          isHybrid = true;
        });
      } else if (widget.prevPageModel!.work_type == "WFH") {
        setState(() {
          isWfh = true;
        });
      }

      // Check if "I am currently working" is selected
      if (widget.prevPageModel!.working == "I am currently working") {
        setState(() {
          isPresent = true;
          working = "I am currently working";
        });
      }

      if (widget.prevPageModel!.availability == "Imediate") {
        setState(() {
          imd = true;
        });
      } else if (widget.prevPageModel!.availability == "15 Days or less") {
        setState(() {
          day15 = true;
          apportunities = true;
        });
      } else if (widget.prevPageModel!.availability == "1 Month") {
        setState(() {
          day30 = true;
          apportunities = true;
        });
      } else if (widget.prevPageModel!.availability == "2 Months") {
        setState(() {
          day60 = true;
        });
      } else if (widget.prevPageModel!.availability == "3 Months") {
        setState(() {
          day90 = true;
        });
      }

      setState(() {
        if (widget.prevPageModel!.ismonthly == true) {
          isMonthly = true;
        } else if (widget.prevPageModel!.ismonthly == false) {
          isMonthly = false;
        }
      });

      jobTitleController.text = widget.prevPageModel!.job_title ?? '';
      fetchApiskill = widget.prevPageModel!.skills_exp!;
      selectedValuesList = widget.prevPageModel!.skills_exp!;
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
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.prevPageModel == null
                    ? Text(
                        "Add Experience",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        "Edit Experience",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                Text(
                  "Introduce your experience to the recruiters",
                  style: GoogleFonts.varela(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(children: [
                _education(),
              ]),
            ),
          )),
    );
  }

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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: isJobTitlle!
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Job Title",
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              customContainerSelect1(
                                true,
                                jobTitleController.text,
                                true,
                                () {
                                  setState(() {
                                    isJobTitlle = false;
                                    titleFocus.requestFocus();
                                    jobTitleController.clear();
                                  });
                                },
                              ),
                            ],
                          )
                        : CustomJobFormTextFieldRespOne(
                            onIDSelected: () {},
                            // isSelected: isIndustry,
                            focusNode: titleFocus,
                            role: "",
                            isCompany: false,
                            isIndustry: true,
                            name: "job_title",
                            title: "Job Title",
                            controller: jobTitleController,
                            onChanged: (p0) {
                              isEdit1 = true;
                            },
                            contextIn: context,
                            hintText: "Sales Manager",
                          ),
                  ),
                  const SizedBox(height: 10),

                  Column(
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
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
                      Column(
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Working Type",
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
                            isHybrid = false;
                            isOnsite = true;
                            isWfh = false;
                          });
                        },
                        isSelect: isOnsite,
                        title: "On-Site",
                      ),
                      customContainerSelect(
                        isAnother: true,
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
                      customContainerSelect(
                        isAnother: true,
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
                    height: 10.h,
                  ),
                  CustomFormTextFieldMultiSelect(
                    name: "skills",
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
                    height: 10.h,
                  ),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Salary",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 18.sp,
                                // color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              isCurrentSalary
                                  ? customContainerSelect(
                                      isVacancy: true,
                                      isCross: true,
                                      isNumOfOpening: false,
                                      isEmails: true,
                                      onPressed: () {
                                        setState(() {
                                          isCurrentSalary = false;
                                          // FocusScope.of(context).autofocus(focusNode);
                                          currentSalaryController.clear();
                                          titleFocus.requestFocus();
                                        });
                                      },
                                      isSelect: true,
                                      title: currentSalaryController.text)
                                  : Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
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
                                            margin:
                                                EdgeInsets.only(bottom: 5.h),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
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
                                                currentSalaryController
                                                        .text.isNotEmpty
                                                    ? setState(() {
                                                        isCurrentSalary = true;
                                                        // _showContainer1 = value.isEmpty;
                                                      })
                                                    : null;
                                              },
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              onTapOutside: (event) {
                                                currentSalaryController
                                                        .text.isNotEmpty
                                                    ? setState(() {
                                                        isCurrentSalary = true;
                                                        // _showContainer1 = value.isEmpty;
                                                      })
                                                    : null;
                                              },
                                              onEditingComplete: () {
                                                currentSalaryController
                                                        .text.isNotEmpty
                                                    ? setState(() {
                                                        isCompanyLocation =
                                                            true;
                                                        // _showContainer1 = value.isEmpty;
                                                      })
                                                    : null;
                                              },
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  currentSalaryController,
                                              // enabled: enableShortListFor,
                                              onTap: (() {}),
                                              decoration: InputDecoration(
                                                  counterText: '',
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
                                                  hintText: "Enter salary",
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio(
                                    value: true,
                                    groupValue: isMonthly,
                                    onChanged: (value) {
                                      setState(() {
                                        isMonthly = true;
                                      });
                                    },
                                  ),
                                  Text("PM"),
                                  Radio(
                                    value: false,
                                    groupValue: isMonthly,
                                    onChanged: (value) {
                                      setState(() {
                                        isMonthly = false;
                                      });
                                    },
                                  ),
                                  Text("PA"),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),

                  Row(
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
                                            const Duration(days: -(365 * 50)),
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
                                  width: MediaQuery.of(context).size.width / 3,
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
                                          keyboardType: TextInputType.text,
                                          controller: joiningDataController,
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
                                            hintText: "Enter joining date ",
                                            hintStyle:
                                                GoogleFonts.sourceSansPro(
                                                    color:
                                                        Constants.subtitleclr,
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
                      if (!isPresent)
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
                                            initialDate: DateTime.now().add(
                                              const Duration(days: -(365 * 50)),
                                            ),
                                            lastDate: DateTime.now(),
                                            currentDate: lastWorkingDateValue,
                                            firstDate: DateTime.now(),
                                          );

                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(pickedDate);
                                            lastWorkingDateValue = pickedDate;
                                            setState(() {
                                              lastWorkingController.text =
                                                  formattedDate;
                                              dt = DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(pickedDate);
                                              year = (dt - DateTime.now());
                                              isJoiningDate = false;
                                              lastWorkingController.clear();
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
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                                      isLastWorkingDate = true;
                                                    })
                                                  : null;
                                            },
                                            onTapOutside: (event) {
                                              lastWorkingController
                                                      .text.isNotEmpty
                                                  ? setState(() {
                                                      isLastWorkingDate = true;
                                                    })
                                                  : null;
                                            },
                                            onEditingComplete: () {
                                              lastWorkingController
                                                      .text.isNotEmpty
                                                  ? setState(() {
                                                      isLastWorkingDate = true;
                                                    })
                                                  : null;
                                            },
                                            keyboardType: TextInputType.text,
                                            controller: lastWorkingController,
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
                                              hintText:
                                                  "Enter last working date ",
                                              hintStyle:
                                                  GoogleFonts.sourceSansPro(
                                                      color:
                                                          Constants.subtitleclr,
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
                  ),
                  SizedBox(
                    // width: MediaQuery.of(context).size.width / 2.2.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                        ),
                        if (isPresent)
                          Container(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
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
                                ),
                                if (apportunities)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Availability to join?",
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                        children: [
                                          customContainerSelect(
                                            isAnother: true,
                                            onPressed: () {
                                              setState(() {
                                                working = "Imediate";
                                                day15 = true;
                                                day30 = false;
                                                day60 = false;
                                                day90 = false;
                                              });
                                            },
                                            isSelect: day15,
                                            title: "Imediate",
                                          ),
                                          customContainerSelect(
                                            isAnother: true,
                                            onPressed: () {
                                              setState(() {
                                                working = "15 Days or less";
                                                imd = true;
                                                day15 = false;
                                                day30 = false;
                                                day60 = false;
                                                day90 = false;
                                              });
                                            },
                                            isSelect: day15,
                                            title: "Imediate",
                                          ),
                                          customContainerSelect(
                                            isAnother: true,
                                            onPressed: () {
                                              setState(() {
                                                working = "1 Month";
                                                day15 = false;
                                                day30 = true;
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
                                                day60 = true;
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
                                                day90 = true;
                                              });
                                            },
                                            isSelect: day90,
                                            title: "2 Months",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Documnets related to work experience",
                          style: GoogleFonts.varela(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        customDocumnet(
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
                        customDocumnet3("Experience / Relieving letter."),
                      ],
                    ),
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

  save() async {
    // Retrieve the form data

    String companyName = companyController.text;
    String companyLocation = companyLocationController.text;
    String companyWebsite = companyWebsiteController.text;
    String currentSalary = currentSalaryController.text;
    String joiningDate = joiningDataController.text;
    String lastWorkingDate = lastWorkingController.text;
    String workType = '';
    if (isOnsite) {
      workType = 'On-Site';
    } else if (isHybrid) {
      workType = 'Hybrid';
    } else if (isWfh) {
      workType = 'WFH';
    }
    String jobTitle = jobTitleController.text;
    String availability = '';
    if (imd) {
      availability = 'Imediate';
    } else if (day15) {
      availability = '15 Days or less';
    } else if (day30) {
      availability = '1 Month';
    } else if (day60) {
      availability = '2 Months';
    } else if (day90) {
      availability = '3 Months';
    }
    String working = '';
    if (isPresent) {
      working = "I am currently working";
    }
    // bool ismonthly;
    if (isMonthly) {
      isMonthly = true;
    }
    if (!isMonthly) {
      isMonthly = false;
    }
    List<String> skills = fetchApiskill;

    // Create a new instance of the model and assign the values
    Experience experience = Experience(
      id: expID,
      userId: profilemodel.id,
      company_name: companyName,
      company_location: companyLocation,
      company_website: companyWebsite,
      salary: currentSalary,
      joining_date: DateTime.parse(joiningDate),
      last_working_date: DateTime.parse(lastWorkingDate),
      work_type: workType,
      job_title: jobTitle,
      availability: availability,
      ismonthly: isMonthly,
      skills_exp: skills,
      working: working,
    );

    // Create an instance of UserDataService
    UserDataService userDataService = UserDataService();

    // Call the saveUserExperience method on the instance
    await userDataService.saveUserExperience(experience.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form data saved successfully')),
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
}
