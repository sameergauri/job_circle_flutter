////

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/autolistviewmodal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/company.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';

class JobForm extends StatefulWidget {
  const JobForm({super.key});

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  TextEditingController company = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController proces = TextEditingController();
  TextEditingController natureOfWork = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  TextEditingController desiredSkills = TextEditingController();
  TextEditingController searchKeyWords = TextEditingController();
  TextEditingController educationQualification = TextEditingController();
  TextEditingController languageKnown = TextEditingController();
  TextEditingController shiftTiming = TextEditingController();
  TextEditingController weeklyOff = TextEditingController();
  TextEditingController workLocation = TextEditingController();
  TextEditingController boundryLimits = TextEditingController();
  TextEditingController interviewRounds = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController empType = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController clientPayout = TextEditingController();
  TextEditingController partnerPayout = TextEditingController();
  TextEditingController paymentClause = TextEditingController();
  TextEditingController Spoc = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController noOfVacancy = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController ageGroup = TextEditingController();
  TextEditingController jobBenefits = TextEditingController();
  TextEditingController moreDetails = TextEditingController();
  TextEditingController processController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController applicationname = TextEditingController();
  TextEditingController shorListController = TextEditingController();
  TextEditingController contactno = TextEditingController();
  TextEditingController minExp = TextEditingController();
  TextEditingController maxExp = TextEditingController();
  TextEditingController minAge = TextEditingController();
  TextEditingController maxAge = TextEditingController();
  TextEditingController moreDetail = TextEditingController();
  //TextEditingController shorListController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutoCompleteModel selectedshort = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedLevel = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedStatus = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedProcess = AutoCompleteModel("", "", {});
  late List<AutoCompleteModel> shortList = [];
  late List<AutoCompleteModel> proccessList = [];
  late List<AutoCompleteModel> levelList = [];
  late List<AutoCompleteModel> statusList = [];
  late List<AutoCompleteModel> interviewList = [];
  bool enableShortListFor = true;
  bool enableProcess = true;
  late int userType = -1;
  int jobId = 0;
  int spoc = 0;
  var ddlValues;
  dynamic prevModel;

  @override
  void dispose() {
    minExp.dispose();
    maxExp.dispose();
    super.dispose();
  }

  bool _showContainer1 = false;
  bool _showContainer2 = false;

  bool isPartTime = false,
      isFullTime = false,
      isContract = false,
      isIntern = false,
      onlyMale = false,
      onlyFemale = false,
      femalePrefered = false,
      excelent = false,
      veryGood = false,
      decent = false,
      graduate = false,
      undeGraduate = false;

  selectProcess(process, extra) {
    processController.text = process;
    selectedProcess = AutoCompleteModel(process, process, extra);
  }

  selectLevel(level, extra) {
    levelController.text = level;
    selectedLevel = AutoCompleteModel(level, level, extra);
  }

  bindStatusList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'join_status', 'pageNumber': '1', 'pageSize': '100'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      statusList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedStatus = AutoCompleteModel("0", "", {});
      });
    }
  }

  openCompanyJobsDetails() async {
    Map<String, String> params = {"companyid": selectedshort.value};

    var result = await JobSearchService().getDistinctProcessAndLevels(params);
    Map resultData2 = jsonDecode(result.body);
    var resultData = RequestResult(
        resultData2["code"],
        resultData2["resultKey"],
        resultData2["errorMessage"],
        resultData2["resultData"]);
    if (resultData.resultKey == "SUCCESS") {
      var jobList = (resultData.resultData as List).map<AutoCompleteModel>((e) {
        return AutoCompleteModel(e['id'].toString(), e['process_name'], e);
      }).toList();

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogList(
              dialogTitle: "Process & Level",
              isCustomTile: true,
              tile: (data) {
                print(data.extra);
                return ListTile(
                  title: Text(data.extra["process_name"].toString()),
                  subtitle: Text(data.extra["level"].toString()),
                  onTap: () => {
                    selectProcess(data.extra["process_name"], data),
                    selectLevel(data.extra["level"], data),
                    paymentClause = data.extra["paymentClause"],
                    spoc = data.extra["spoc"],
                    jobId = data.extra["id"],
                    Navigator.pop(context)
                  },
                );
              },
              itemsData: jobList,
            );
          });
    }
  }

  bindProccessLevelList(companyId) async {
    var result = await JobSearchService()
        .getDistinctProcessAndLevels({'companyid': companyId});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      proccessList = [];
      levelList = [];
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];
      var l = (ddlValues as List);
      var existsList = [];
      for (var i = 0; i < l.length; i++) {
        var item = l[i];
        if (!existsList.contains(item['process_name'])) {
          existsList.add(item['process_name']);
          proccessList.add(AutoCompleteModel(
              item['process_name'].toString(), item['process_name'], item));
        }
        levelList.add(
            AutoCompleteModel(item['level'].toString(), item['level'], item));
      }

      // proccessList = (ddlValues as List)
      //     .map<AutoCompleteModel>((e) => AutoCompleteModel(
      //         e['process_name'].toString(), e['process_name'], e))
      //     .toList();
    }
  }

  bindShortList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'cmp_short', 'pageNumber': '1', 'pageSize': '500'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      shortList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedshort = AutoCompleteModel("0", "", {});
      });
    }
  }

  resetProcessLevel() {
    setState(() {
      selectedProcess = AutoCompleteModel("0", "", {});
      selectedLevel = AutoCompleteModel("0", "", {});
      processController.text = "";
      levelController.text = "";
    });
  }

  bindCompanyList() async {
    var result = await CompanyService()
        .getCompanies({'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      shortList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['name'], e))
          .toList();

      // setState(() {
      //   selectedshort = AutoCompleteModel("0", "", {});
      // });
    }
  }

  dynamic userinfo;
  dynamic localStoregData;

  @override
  void initState() {
    // TODO: implement initState
    moreDetail.addListener(_handleTextChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamic args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args["isnew"] != true) {
        if (args["refer"] == true) {
          //  enableApplicantName = false;
          //  enableContactNo = false;

          // bindUserDetails();
        }
      }

      if (args != null && args["prevModel"] != null) {
        prevModel = args["prevModel"] as dynamic;
        shorListController.text = prevModel?.name;
        selectedshort = AutoCompleteModel(
            prevModel.compnayid.toString(), prevModel?.name, prevModel);
        paymentClause = prevModel?.paymentclause;

        selectProcess(prevModel.process, prevModel);
        selectLevel(prevModel?.rolename, prevModel);

        jobId = prevModel?.id;

        spoc = prevModel?.spoc;

        enableShortListFor = false;

        bindProccessLevelList(prevModel.compnayid.toString());
        setState(() {});
      }
      if (args["refer"] == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // baad me kaam krna hai
          userinfo = await Utils.getPreferencesValue(
              null, ESharedPreferences.user_data.name);
          userType = await Utils.getPreferencesValue(
              null, ESharedPreferences.user_type.name);
          role = await Utils.getPreferencesValue(
              null, ESharedPreferences.role.name);
          // mobileno = await Utils.getPreferencesValue(
          //     null, ESharedPreferences.user_mobile.name);
          localStoregData = jsonDecode(userinfo);
          if (userType == EUserType.jobSeeker.value) {
            contactno.text = localStoregData["mobile"];
            applicationname.text = localStoregData["firstName"].toString();
            lastname.text = localStoregData["lastName"].toString();
            // applicationname.text = localStoregData["cardName"].toString().toTitleCase();
          }
          setState(() {});
        });
      }
    });
    enableProcess = false;
    bindCompanyList();
    // enableLevel = false;
    setState(() {});

    bindShortList();
    // bindCompanyList();
    // if (widget.isnew != true) {
    //   // bindUserDetails();
    // }

    bindStatusList();
    // bindInterViewList();
  }

  String _selectedOption = "Monthly";
  bool isFresher = false;
  bool expContainer = false;
  bool agegroupContainer = false;
  final List<String> _bulletPoints = [];
  String _text = '';

  void _handleTextChange() {
    setState(() {
      _text = moreDetail.text;
    });
  }

  List<Widget> _getBulletPointWidgets() {
    List<String> lines = _text.split('\n');
    List<Widget> bulletPoints = [];

    for (String line in lines) {
      bulletPoints.add(
        const Text(
          '\u2022  ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }

    return bulletPoints;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight / 1.2.h,
        //margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Container(
          decoration: const BoxDecoration(
              //color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  // width: MediaQuery.of(context).size.width / 2.2,
                  alignment: Alignment.center,
                  child: const Text("Save as draft",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              InkWell(
                onTap: () {
                  //   if(noOfVacancy.text.isEmpty||languageKnown.text.isEmpty||boundryLimits.text.isEmpty){}  these field may be empty
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15)),
                  // width: MediaQuery.of(context).size.width / 2.2,
                  alignment: Alignment.center,
                  child: const Text("Post Job",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 172, 187),
        title: const Text("New Job"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                newFormFiled(shorListController, context, "Company Name",
                    "Aditay Birla Health Insurance", false, false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2.w,
                        child: newFormFiled(shorListController, context,
                            "Job Title", "Sr.Executive", false, false)),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2.w,
                        child: newFormFiled(shorListController, context,
                            "Process", "Health Insurance", false, false)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      child: newFormFiled(shorListController, context,
                          "Nature of Work", "Sales", false, false),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      child: newFormFiled(shorListController, context,
                          "Number of Openings", "e.g 1", false, false),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      child: newFormFiled(shorListController, context,
                          "Industry", "NBFC", false, false),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      child: newFormFiled(shorListController, context,
                          "Functional Area", "Sales", false, false),
                    ),
                  ],
                ),
                Text(
                  "Emp Type",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                Wrap(
                  children: [
                    if (isContract == false &&
                        isFullTime == false &&
                        isIntern == false)
                      customContainerSelect(() {
                        setState(() {
                          isPartTime = !isPartTime;
                          isFullTime = false;
                          isContract = false;
                          isIntern = false;
                        });
                      }, isPartTime, "Part Time"),
                    if (isPartTime == false &&
                        isContract == false &&
                        isIntern == false)
                      customContainerSelect(() {
                        setState(() {
                          isPartTime = false;
                          isFullTime = !isFullTime;
                          isContract = false;
                          isIntern = false;
                        });
                      }, isFullTime, "full Time"),
                    if (isPartTime == false &&
                        isFullTime == false &&
                        isIntern == false)
                      customContainerSelect(() {
                        setState(() {
                          isPartTime = false;
                          isFullTime = false;
                          isContract = !isContract;
                          isIntern = false;
                        });
                      }, isContract, "Contractual"),
                    if (isPartTime == false &&
                        isFullTime == false &&
                        isContract == false)
                      customContainerSelect(() {
                        setState(() {
                          isPartTime = false;
                          isFullTime = false;
                          isContract = false;
                          isIntern = !isIntern;
                        });
                      }, isIntern, "Internship"),
                  ],
                ),
                Text(
                  "Education",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                Wrap(
                  children: [
                    if (graduate == false)
                      customContainerSelect(() {
                        setState(() {
                          undeGraduate = !undeGraduate;
                          graduate = false;
                        });
                      }, undeGraduate, "Under-Graduate"),
                    if (undeGraduate == false)
                      customContainerSelect(() {
                        setState(() {
                          graduate = !graduate;
                          undeGraduate = false;
                        });
                      }, graduate, "Graduate"),
                  ],
                ),
                newFormFiled(shorListController, context, "Skills Required",
                    "Advance Excel", false, false),
                Text(
                  "Job Responsibility",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                CheckboxListTile(
                  title: const Text("Data"),
                  value: true,
                  onChanged: (value) {},
                ),
                newFormFiled(shorListController, context, "",
                    "Any other respo that you want to add", false, false),
                newFormFiled(shorListController, context, "Language Required",
                    "English", false, false),

                newFormFiled(shorListController, context, "Job Benefits", "PF",
                    false, false),
                Text(
                  "Salary",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5.w,
                      child: newFormFiled(shorListController, context, "",
                          "Min-salary", true, false),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text("-"),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5.w,
                      child: newFormFiled(shorListController, context, "",
                          "Max-salary", true, false),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    /* Text(
                      "Years",
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 14.sp,
                          // color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400),
                    ), */
                    SizedBox(
                        child: Radio(
                      // contentPadding: EdgeInsets.zero,
                      // title: const Text('Monthly'),
                      value: 'Monthly',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value.toString();
                        });
                      },
                    )),
                    const Text("Monthly"),
                    SizedBox(
                        child: Radio(
                      value: 'Yearly',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value.toString();
                        });
                      },
                    )),
                    const Text("Yearly")
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      child: newFormFiled(shorListController, context,
                          "Shift Timing", "Day Shift", false, false),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      child: newFormFiled(shorListController, context,
                          "Week Off", "Sunday", false, false),
                    ),
                  ],
                ),
                newFormFiled(shorListController, context, "Locality", "Thane",
                    false, false),
                newFormFiled(shorListController, context, "Boundry Limits",
                    "Graduate", false, false),
                newFormFiled(shorListController, context, "Eligibility",
                    "Banking sales compulsory", false, false),
                Text(
                  "Experience",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                Visibility(
                    visible: _showContainer1 && _showContainer2,
                    child: customContainerSelect(() {
                      setState(() {
                        isFresher = !isFresher;
                      });
                    }, isFresher, "Fresher can also apply.")

                    /* Row(
                    children: [
                      Checkbox(
                        value: isFresher,
                        onChanged: (value) {
                          setState(() {
                            isFresher = !isFresher;
                          });
                        },
                      ),
                      const Text("Fresher can also apply."),
                    ],
                  ), */
                    ),

                if (isFresher == false)
                  Container(
                    //  margin: const EdgeInsets.only(left: 15),
                    child: expContainer
                        ? Row(
                            children: [
                              customContainerSelect(() {
                                setState(() {
                                  expContainer = false;
                                });
                              }, expContainer,
                                  "${minExp.text} - ${maxExp.text} Year"),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 6.w,
                                  child: /* newFormFiled(
                              minExp, context, "", "Min-exp", true, true), */
                                      Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    26.h,
                                                color: Colors.white,
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _showContainer1 =
                                                          value.isEmpty;
                                                    });
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: minExp,
                                                  enabled: enableShortListFor,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please select any company';
                                                    }
                                                    return null;
                                                  },
                                                  onTap: (() {
                                                    /* showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          dialogTitle: "Company Details",
                          onSelected: (AutoCompleteModel model) => {
                            shorListController.text = model.label,
                            selectedshort = model,
                            Navigator.pop(context),
                            if (userType == EUserType.businessPartner.value ||
                                userType == EUserType.employee.value)
                              {openCompanyJobsDetails()}
                            else
                              {
                                if (selectedshort.value != model.value)
                                  {bindProccessLevelList(model.value)},
                                proccessList = [],
                                levelList = [],
                              },
                            resetProcessLevel(),
                          },
                          itemsData: shortList,
                        );
                      }); */
                                                  }),
                                                  decoration: InputDecoration(
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
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        122,
                                                                        113,
                                                                        111)),
                                                      ),
                                                      hintText: "Min-exp",
                                                      hintStyle: GoogleFonts
                                                          .sourceSansPro(
                                                              color: Constants
                                                                  .subtitleclr,
                                                              fontSize: 14.sp)
                                                      //  prefixIcon: Icon(Icons.list)
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ))),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("-"),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 6.w,
                                child: /* newFormFiled(
                              maxExp, context, "", "Max-exp", true, true), */
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6.w,
                                        child: /* newFormFiled(
                              minExp, context, "", "Min-exp", true, true), */
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              26.h,
                                                      color: Colors.white,
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _showContainer2 =
                                                                value.isEmpty;
                                                          });
                                                        },
                                                        onSubmitted:
                                                            (newValue) {
                                                          maxExp.text.isNotEmpty
                                                              ? setState(() {
                                                                  expContainer =
                                                                      newValue
                                                                          .isNotEmpty;
                                                                })
                                                              : null;
                                                        },
                                                        onTapOutside: (event) {
                                                          maxExp.text.isNotEmpty
                                                              ? setState(() {
                                                                  expContainer =
                                                                      !expContainer;
                                                                })
                                                              : null;
                                                        },
                                                        onEditingComplete: () {
                                                          maxExp.text.isNotEmpty
                                                              ? setState(() {
                                                                  expContainer =
                                                                      !expContainer;
                                                                })
                                                              : null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller: maxExp,
                                                        enabled:
                                                            enableShortListFor,
                                                        /* validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please select any company';
                                                          }
                                                          return null;
                                                        }, */
                                                        onTap: (() {
                                                          /* showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          dialogTitle: "Company Details",
                          onSelected: (AutoCompleteModel model) => {
                            shorListController.text = model.label,
                            selectedshort = model,
                            Navigator.pop(context),
                            if (userType == EUserType.businessPartner.value ||
                                userType == EUserType.employee.value)
                              {openCompanyJobsDetails()}
                            else
                              {
                                if (selectedshort.value != model.value)
                                  {bindProccessLevelList(model.value)},
                                proccessList = [],
                                levelList = [],
                              },
                            resetProcessLevel(),
                          },
                          itemsData: shortList,
                        );
                      }); */
                                                        }),
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 8,
                                                                        bottom:
                                                                            8,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                                                // Icons.workspace_premium
                                                                // label: const Text("Company Name *"),
                                                                //border: OutlineInputBorder(),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              Color(0xffff0eceb)),
                                                                ),
                                                                focusColor:
                                                                    const Color(
                                                                        0xffff0eceb),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          122,
                                                                          113,
                                                                          111)),
                                                                ),
                                                                hintText:
                                                                    "Max-exp",
                                                                hintStyle: GoogleFonts
                                                                    .sourceSansPro(
                                                                        color: Constants
                                                                            .subtitleclr,
                                                                        fontSize:
                                                                            14.sp)
                                                                //  prefixIcon: Icon(Icons.list)
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ))),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Years",
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 14.sp,
                                    // color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                  ),

                Text(
                  "Gender",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                Wrap(
                  children: [
                    if (onlyFemale == false && femalePrefered == false)
                      customContainerSelect(() {
                        setState(() {
                          onlyMale = !onlyMale;
                          onlyFemale = false;
                          femalePrefered = false;
                        });
                      }, onlyMale, "Only Male"),
                    if (onlyMale == false && femalePrefered == false)
                      customContainerSelect(() {
                        setState(() {
                          femalePrefered = false;
                          onlyMale = false;
                          onlyFemale = !onlyFemale;
                        });
                      }, onlyFemale, "Only Female"),
                    if (onlyFemale == false && onlyMale == false)
                      customContainerSelect(() {
                        setState(() {
                          femalePrefered = !femalePrefered;
                          onlyMale = false;
                          onlyFemale = false;
                        });
                      }, femalePrefered, "Female Prefered")
                  ],
                ),
                Text(
                  "Age Group",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                agegroupContainer
                    ? Row(
                        children: [
                          customContainerSelect(() {
                            setState(() {
                              agegroupContainer = false;
                            });
                          }, agegroupContainer,
                              "${minAge.text} - ${maxAge.text} Year"),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          /*  SizedBox(
                      width: MediaQuery.of(context).size.width / 6.w,
                      child: newFormFiled(shorListController, context, "",
                          "Min-age", true, false),
                    ), */
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 6.w,
                              child: /* newFormFiled(
                              minExp, context, "", "Min-exp", true, true), */
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                26.h,
                                            color: Colors.white,
                                            child: TextFormField(
                                              onChanged: (value) {},
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: minAge,
                                              enabled: enableShortListFor,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select any company';
                                                }
                                                return null;
                                              },
                                              onTap: (() {
                                                /* showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          dialogTitle: "Company Details",
                          onSelected: (AutoCompleteModel model) => {
                            shorListController.text = model.label,
                            selectedshort = model,
                            Navigator.pop(context),
                            if (userType == EUserType.businessPartner.value ||
                                userType == EUserType.employee.value)
                              {openCompanyJobsDetails()}
                            else
                              {
                                if (selectedshort.value != model.value)
                                  {bindProccessLevelList(model.value)},
                                proccessList = [],
                                levelList = [],
                              },
                            resetProcessLevel(),
                          },
                          itemsData: shortList,
                        );
                      }); */
                                              }),
                                              decoration: InputDecoration(
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
                                                        BorderRadius.circular(
                                                            10),
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
                                                  hintText: "Min-age",
                                                  hintStyle:
                                                      GoogleFonts.sourceSansPro(
                                                          color: Constants
                                                              .subtitleclr,
                                                          fontSize: 14.sp)
                                                  //  prefixIcon: Icon(Icons.list)
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ))),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("-"),
                          const SizedBox(
                            width: 5,
                          ),
                          /* SizedBox(
                      width: MediaQuery.of(context).size.width / 6.w,
                      child: newFormFiled(shorListController, context, "",
                          "Max-age", true, false),
                    ), */
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 6.w,
                              child: /* newFormFiled(
                              minExp, context, "", "Min-exp", true, true), */
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                26.h,
                                            color: Colors.white,
                                            child: TextField(
                                              onSubmitted: (newValue) {
                                                maxAge.text.isNotEmpty
                                                    ? setState(() {
                                                        agegroupContainer =
                                                            newValue.isNotEmpty;
                                                      })
                                                    : null;
                                              },
                                              onTapOutside: (event) {
                                                maxAge.text.isNotEmpty
                                                    ? setState(() {
                                                        agegroupContainer =
                                                            !agegroupContainer;
                                                      })
                                                    : null;
                                              },
                                              onEditingComplete: () {
                                                maxAge.text.isNotEmpty
                                                    ? setState(() {
                                                        agegroupContainer =
                                                            !agegroupContainer;
                                                      })
                                                    : null;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: maxAge,
                                              enabled: enableShortListFor,
                                              /*  validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select any company';
                                          }
                                          return null;
                                        }, */
                                              onTap: (() {
                                                /* showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          dialogTitle: "Company Details",
                          onSelected: (AutoCompleteModel model) => {
                            shorListController.text = model.label,
                            selectedshort = model,
                            Navigator.pop(context),
                            if (userType == EUserType.businessPartner.value ||
                                userType == EUserType.employee.value)
                              {openCompanyJobsDetails()}
                            else
                              {
                                if (selectedshort.value != model.value)
                                  {bindProccessLevelList(model.value)},
                                proccessList = [],
                                levelList = [],
                              },
                            resetProcessLevel(),
                          },
                          itemsData: shortList,
                        );
                      }); */
                                              }),
                                              decoration: InputDecoration(
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
                                                        BorderRadius.circular(
                                                            10),
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
                                                  hintText: "Max-age",
                                                  hintStyle:
                                                      GoogleFonts.sourceSansPro(
                                                          color: Constants
                                                              .subtitleclr,
                                                          fontSize: 14.sp)
                                                  //  prefixIcon: Icon(Icons.list)
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Years",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 14.sp,
                                // color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                Text(
                  "Communication Rating",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                Wrap(
                  children: [
                    if (veryGood == false && decent == false)
                      customContainerSelect(() {
                        setState(() {
                          excelent = !excelent;
                          veryGood = false;
                          decent = false;
                        });
                      }, excelent, "Excelent | Versent"),
                    if (excelent == false && decent == false)
                      customContainerSelect(() {
                        setState(() {
                          excelent = false;
                          veryGood = !veryGood;
                          decent = false;
                        });
                      }, veryGood, "Very Good | Non Versent"),
                    if (excelent == false && veryGood == false)
                      customContainerSelect(() {
                        setState(() {
                          excelent = false;
                          veryGood = false;
                          decent = !decent;
                        });
                      }, decent, "Average | Decent"),
                  ],
                ),
                Text(
                  "More Details",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                /*  TextField(
                  controller: moreDetail,
                  decoration: const InputDecoration(
                    hintText: 'Enter text (Press Enter for bullet point)',
                  ),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSubmitted: _handleTextSubmitted,
                ), */

                TextField(
                  // textInputAction: TextInputAction.newline,

                  // onFieldSubmitted: (_) => _handleTextSubmitted(),
                  controller: moreDetail,
                  //  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 10, right: 10),
                      prefix: Column(
                        children: _getBulletPointWidgets(),
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      // Icons.workspace_premium
                      // label: const Text("Company Name *"),
                      //border: OutlineInputBorder(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xffff0eceb)),
                      ),
                      focusColor: const Color(0xffff0eceb),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 122, 113, 111)),
                      ),
                      hintText: "Optional...",
                      hintStyle: GoogleFonts.sourceSansPro(
                          color: Constants.subtitleclr, fontSize: 14.sp)
                      //  prefixIcon: Icon(Icons.list)
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),

                /*  newFormFiled(shorListController, context, "More Details",
                    "Optional", false, false), */
                newFormFiled(shorListController, context, "Interview Rounds",
                    "Graduate", false, false),

                /* TextFormField(                                           //show dialogue for process//
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select any process';
                    }
                    return null;
                  },
                  controller: processController,
                  enabled: enableProcess,
                  onTap: (() {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogList(
                            tile: null,
                            dialogTitle: "Process",
                            onSelected: (AutoCompleteModel model) => {
                              processController.text = model.label,
                              selectedProcess = model,
                              Navigator.pop(context)
                            },
                            itemsData: proccessList,
                          );
                        });
                  }),
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      // Icons.workspace_premium
                      label: Text("Process *"),
                      //border: OutlineInputBorder(),
                      border: InputBorder.none,
                      hintText: "Select proccess",
                      prefixIcon: Icon(Icons.circle_outlined)),
                ), */
                //  suggestTextfield("Company", 1, _typeAheadController, shortList),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell customContainerSelect(
      final VoidCallback onPressed, bool isSelect, String title) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(right: 5, bottom: 10, top: 10),
            decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: isSelect
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title,
                          style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 14.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "assets/images/cross.png",
                        height: 12,
                      )
                    ],
                  )
                : Text(title,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.subtitleclr, fontSize: 14.sp))));
  }

  Container newFormFiled(TextEditingController controller, BuildContext context,
      String? title, String subTitle, bool isNum, bool isVisible) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title!.isNotEmpty)
              Text(
                title,
                style: GoogleFonts.sourceSansPro(
                    fontSize: 14.sp,
                    // color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600),
              ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 26.h,
              color: Colors.white,
              child: TextFormField(
                onChanged: (value) {
                  isVisible
                      ? setState(() {
                          _showContainer1 = value.isEmpty;
                        })
                      : null;
                },
                keyboardType: isNum ? TextInputType.number : TextInputType.name,
                controller: controller,
                enabled: enableShortListFor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select any company';
                  }
                  return null;
                },
                onTap: (() {
                  /* showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          dialogTitle: "Company Details",
                          onSelected: (AutoCompleteModel model) => {
                            shorListController.text = model.label,
                            selectedshort = model,
                            Navigator.pop(context),
                            if (userType == EUserType.businessPartner.value ||
                                userType == EUserType.employee.value)
                              {openCompanyJobsDetails()}
                            else
                              {
                                if (selectedshort.value != model.value)
                                  {bindProccessLevelList(model.value)},
                                proccessList = [],
                                levelList = [],
                              },
                            resetProcessLevel(),
                          },
                          itemsData: shortList,
                        );
                      }); */
                }),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 10, right: 10),
                    // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                    // Icons.workspace_premium
                    // label: const Text("Company Name *"),
                    //border: OutlineInputBorder(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffff0eceb)),
                    ),
                    focusColor: const Color(0xffff0eceb),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 122, 113, 111)),
                    ),
                    hintText: subTitle,
                    hintStyle: GoogleFonts.sourceSansPro(
                        color: Constants.subtitleclr, fontSize: 14.sp)
                    //  prefixIcon: Icon(Icons.list)
                    ),
              ),
            ),
          ],
        ));
  }

  Widget customTextField(TextEditingController textController, String title,
      int? lineOfTextField, bool isColor) {
    return Container(
      margin: isColor
          ? const EdgeInsets.only(top: 5)
          : const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
      padding: isColor
          ? const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10)
          : const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
      decoration: BoxDecoration(
          color: isColor ? Colors.white : const Color(0xfffe3bad0)),
      //height: 150,
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                color: Color(0xfff805c6b),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          lineOfTextField == 1
              ? SizedBox(
                  height: 40.h,
                  child: TextFormField(
                    enableSuggestions: true,
                    maxLines: lineOfTextField,
                    controller: textController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(
                                color: Color(0xfffc3aea7), width: 0.8)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(
                                color: Color(0xfffc3aea7), width: 0.8))),
                  ),
                )
              : SizedBox(
                  child: TextFormField(
                    enableSuggestions: true,
                    maxLines: lineOfTextField,
                    controller: textController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(
                                color: Color(0xfffc3aea7), width: 0.8)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(
                                color: Color(0xfffc3aea7), width: 0.8))),
                  ),
                )
        ],
      ),
    );
  }

  Widget suggestTextfield(String title, int lineOfTextField,
      TextEditingController textController, List data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
      decoration: const BoxDecoration(color: Color(0xfffe3bad0)),
      //height: 150,
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                color: Color(0xfff805c6b),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          lineOfTextField == 1
              ? SizedBox(
                  height: 40.h,
                  child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          cursorRadius: const Radius.circular(15),
                          autofocus: true,
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontStyle: FontStyle.italic),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder()),
                          controller: textController),
                      suggestionsCallback: (pattern) async {
                        Completer<List<String>> completer = Completer();
                        completer.complete([data.first]);
                        return completer.future;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: data.first,
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        textController.text = suggestion.toString();
                      }),
                )
              : SizedBox(
                  child: TextFormField(
                    enableSuggestions: true,
                    maxLines: lineOfTextField,
                    controller: textController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(
                                color: Color(0xfffc3aea7), width: 0.8)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(
                                color: Color(0xfffc3aea7), width: 0.8))),
                  ),
                )
        ],
      ),
    );
  }
}

class BulletPointInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      final lines = newValue.text.split('\n');
      final formattedLines = lines.map((line) {
        if (line.isNotEmpty && !line.startsWith('\u2022 ')) {
          return '\u2022 $line';
        }
        return line;
      });
      final formattedText = formattedLines.join('\n');

      return TextEditingValue(
        text: formattedText,
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}
