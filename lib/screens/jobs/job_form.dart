////

// ignore_for_file: duplicate_import

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/autolistviewmodal.dart';
import 'package:job_circle/constants/customSelection.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/company.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';

import '../../constants/customDialogue.dart';
import '../../models/job_post_model.dart';
import '../../models/more__details.dart';
import '../../service/job_post_api_service.dart';

class JobForm extends StatefulWidget {
  const JobForm({super.key});

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  TextEditingController company = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController proces = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController natureOfWork = TextEditingController();
  TextEditingController industry = TextEditingController();
  TextEditingController skills = TextEditingController();
  TextEditingController functionalArea = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  TextEditingController desiredSkills = TextEditingController();
  TextEditingController searchKeyWords = TextEditingController();
  TextEditingController educationQualification = TextEditingController();
  TextEditingController languageKnown = TextEditingController();
  TextEditingController shiftTiming = TextEditingController();
  TextEditingController weeklyOff = TextEditingController();
  TextEditingController workLocation = TextEditingController();
  //TextEditingControllerndryLimits = TextEditingController();
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
  TextEditingController Eligibility = TextEditingController();
  TextEditingController numberofopenings = TextEditingController();
  TextEditingController minSalary = TextEditingController();
  TextEditingController maxSalary = TextEditingController();

  TextEditingController boundryLimits = TextEditingController();
  TextEditingController responsibility = TextEditingController();
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
  String? pId;

  bool isCheckBox = false;

  String minSalaryk = "", maxSalaryk = "";

  bool nextValid = true;
  bool _isSecondTextFieldEnabled = false;

  @override
  void dispose() {
    minExp.dispose();
    maxExp.dispose();
    super.dispose();
  }

  bool isRelevantExpperience = false;

  void checkAgeGroup(String ageText) {
    int? age = int.tryParse(ageText);

    if (age != null && age >= 18) {
      setState(() {
        _isSecondTextFieldEnabled = true;
      });
    } else {
      setState(() {
        _isSecondTextFieldEnabled = false;
        maxAge.clear();
      });
    }
  }

  bool _showContainer1 = true;
  bool _showContainer2 = true;
  bool isValueValid = true;
  FocusNode minSalaryFocusNode = FocusNode();
  FocusNode maxSalaryFocusNode = FocusNode();
  FocusNode numberOfOpeningFocusNode = FocusNode();
  FocusNode experinceFocusNode = FocusNode();
  FocusNode ageGroupFocusNode = FocusNode();

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

  List<dynamic> dropdownItems = []; // List to store the dropdown items
  String selectedValue = "";

  /* void fetchData() async {
    final response = await http.get(Uri.parse(
        "http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/company/v1/all?pageNumber=1&pageSize=100"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var list = data as List;
      setState(() {
        dropdownItems.addAll(list);
        // Assuming data is a list of strings
      });
      print(dropdownItems);
    } else {
      print("somthing went wrong");
    }
  } */
  Timer? _timer;
  InkWell customContainerSelect1(bool isSelect, String text) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          focusNode.requestFocus();

          setState(() {
            // controller!.clear();
//handleBoolChange(false);
            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
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
                      const Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.white,
                      )
                    ],
                  )
                : Text(text,
                    style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
  }

  @override
  void initState() {
    /* _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchData();
    }); */
    /* if (checkboxDataState.isEmpty) {
      fetchData();
    } */
    // fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        // barrierColor: Colors.grey.shade100,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            getCompanyName: (value) {
              setState(() {
                shorListController = value; // Update the value in Class1
              });
            },
            getCompanyId: (value) {
              setState(() {
                CompanyID = value;
              });
            },
            getJobtitile: (value) {
              setState(() {
                role = value;
              });
            },
            getJobtitleValue: getValueOfJobtitle,
            getNatureOfWorkId: fetchData,
            getProcess: (value) {
              setState(() {
                proces = value;
              });
            },
            getNatureOFWork: (value) {
              setState(() {
                natureOfWork = value;
              });
            },
            isFisrt: true,
            onClose: () {},
            title: "Quick & Easy Job Posting",
            subtitle: "",
          );
        },
      );
    });

    getJobTitle("pattern", "language").then((_) {
      isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
      setState(() {});
    });
    getJobTitle1("pattern", "language").then((_) {
      isJobBenefits = List<bool>.filled(jobTitleSuggestion1.length, false);
      setState(() {});
    });
    getJobTitle4("pattern", "language").then((_) {
      isInterview = List<bool>.filled(jobTitleSuggestion4.length, false);
      setState(() {});
    });
    getJobTitle2("pattern", "language").then((_) {
      isShiftTime1 = List<bool>.filled(jobTitleSuggestion2.length, false);
      setState(() {});
    });
    getJobTitle3("pattern", "language").then((_) {
      isWeakOff = List<bool>.filled(jobTitleSuggestion3.length, false);
      setState(() {});
    });
    getJobTitle5("pattern", "language").then((_) {
      isCommunication = List<bool>.filled(jobTitleSuggestion5.length, false);
      setState(() {});
    });

    // getJobTitle("Admin");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    // TODO: implement initState
    moreDetail.addListener(_handleTextChange);
    Eligibility.addListener(_handleTextChangeEligi);
    boundryLimits.addListener(_handleTextChangebond);
    responsibility.addListener(_handleTextChangerespo);
    //
    // ();
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

  String _selectedOption = "";
  bool isFresher = false;
  bool expContainer = false;
  bool agegroupContainer = false;
  bool enableExperience = false;

  final List<String> _bulletPointsrespo = [];
  String _textrespo = '';

  void _handleTextChangerespo() {
    setState(() {
      _textrespo = responsibility.text;
    });
  }

  List<Widget> _getBulletPointWidgetsrespo() {
    List<String> lines = _textrespo.split('\n');
    List<Widget> bulletPointsrespo = [];

    for (String line in lines) {
      bulletPointsrespo.add(
        const Text(
          '\u2022  ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }
    return bulletPointsrespo;
  }

  ///////////////////////////////////////////

  final List<String> _bulletPointsbond = [];
  String _textbond = '';

  void _handleTextChangebond() {
    setState(() {
      _textbond = boundryLimits.text;
    });
  }

  List<Widget> _getBulletPointWidgetsbond() {
    List<String> lines = _textbond.split('\n');
    List<Widget> bulletPointsbond = [];

    for (String line in lines) {
      bulletPointsbond.add(
        const Text(
          '\u2022  ',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    return bulletPointsbond;
  }

/////////////////////////////////////////////

  final List<String> _bulletPointsEligi = [];
  String _textEligi = '';

  void _handleTextChangeEligi() {
    setState(() {
      _textEligi = Eligibility.text;
    });
  }

  List<Widget> _getBulletPointWidgetsEligi() {
    List<String> lines = _textEligi.split('\n');
    List<Widget> bulletPointsEligi = [];

    for (String line in lines) {
      bulletPointsEligi.add(
        const Text(
          '\u2022  ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }
    return bulletPointsEligi;
  }

////////////////////////////////////////////

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

  final List<CheckItem> _moreDetailsList = [];
  final List<CheckItem> _eligibilityList = [];
  final List<CheckItem> _boundryLimitList = [];

  List<String> selectedBoundryLimit = [];
  List<String> selectedEligibility = [];
  List<String> selectedMoreDetail = [];

  void _handleMoreDetailSubmitted(String value) {
    bool isDuplicate = _moreDetailsList.any((item) => item.text == value);
    if (value.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              isFisrt: false,
              onClose: () {
                moreDetail.clear();
                Navigator.of(context).pop();
              },
              title: "Error",
              subtitle: "Please Type somthing then add");
        },
      );
    } else if (isDuplicate) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              isFisrt: false,
              onClose: () {
                moreDetail.clear();
                Navigator.of(context).pop();
              },
              title: "Error",
              subtitle: "Data Already Exist");
        },
      );
    } else {
      setState(() {
        _moreDetailsList.add(CheckItem(value, true));
        moreDetail.clear();
      });
    }
  }

  void _toggleCheckbox(int index, bool value) {
    setState(() {
      _moreDetailsList[index].isChecked = value;
    });
  }

  void _handleEligibilitySubmitted(String value) {
    bool isDuplicate = _eligibilityList.any((item) => item.text == value);
    if (value.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              isFisrt: false,
              onClose: () {
                Eligibility.clear();
                Navigator.of(context).pop();
              },
              title: "Error",
              subtitle: "Please Type somthing then add");
        },
      );
    } else if (isDuplicate) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              isFisrt: false,
              onClose: () {
                Eligibility.clear();
                Navigator.of(context).pop();
              },
              title: "Error",
              subtitle: "Data Already Exist");
        },
      );
    } else {
      setState(() {
        _eligibilityList.add(CheckItem(value, true));
        Eligibility.clear();
      });
    }
  }

  void _toggleCheckbox2(int index, bool value) {
    setState(() {
      _eligibilityList[index].isChecked = value;
    });
  }

  void _handleBoundrySubmitted(String value) {
    bool isDuplicate = _boundryLimitList.any((item) => item.text == value);
    if (value.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              isFisrt: false,
              onClose: () {
                boundryLimits.clear();
                Navigator.of(context).pop();
              },
              title: "Error",
              subtitle: "Please Type somthing then add");
        },
      );
    } else if (isDuplicate) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              isFisrt: false,
              onClose: () {
                boundryLimits.clear();
                Navigator.of(context).pop();
              },
              title: "Error",
              subtitle: "Data Already Exist");
        },
      );
    } else {
      setState(() {
        _boundryLimitList.add(CheckItem(value, true));
        boundryLimits.clear();
      });
    }
  }

  void _toggleCheckbox3(int index, bool value) {
    setState(() {
      _boundryLimitList[index].isChecked = value;
    });
  }

  bool isEdit1 = false;
  bool isEdit2 = false;
  bool isEdit3 = false;
  bool isEdit4 = false;
  bool isEdit5 = false;
  bool isEdit6 = false;
  bool isEdit7 = false;
  bool isEdit8 = false;
  bool isEdit9 = false;
  bool isEdit10 = false;

  bool isJobTitle = false;
  List<dynamic> suggestions = [];
  List<dynamic> jobTitleSuggestion = [];
  List<dynamic> jobTitleSuggestion1 = [];
  List<dynamic> jobTitleSuggestion3 = [];
  List<dynamic> jobTitleSuggestion4 = [];
  bool isNotFound = false;
  List<dynamic> jobTitleSuggestion2 = [];
  List<dynamic> jobTitleSuggestion5 = [];
  List<String> checkboxData = [];
  List<dynamic> natureofWorkID = [];
  List<String> checkboxDataState = [];
  List<String> selectedResponsibility = [];
  String? jobTitle;
  String? Nowid;
  int? NatureOfWorkID;
  String? CompanyID;
  String? CityID = "0";
  List<String> worklocationList = [];

  void getWorkLocation(List<String> data) {
    // Store the received data in the list
    setState(() {
      worklocationList = data;
    });

    // Perform further operations on the storedData list if needed
    // ...
  }

  void getCityId(String cityId) async {
    setState(() {
      CityID = cityId;
    });
  }

  void getValueOfJobtitle(String getJobTitle) async {
    setState(() {
      jobTitle = getJobTitle;
    });
  }

  void getCompanyId(String compnayId) async {
    setState(() {
      CompanyID = compnayId;
    });
  }

  /* void getNowId(String id) async {
    setState(() {
      Nowid = id;
    });
  } */

  Future<List<String>> fetchData(String id) async {
    setState(() {
      NatureOfWorkID = int.parse(id);
    });
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getDataByParentNameAndParentIdAndGroupName?groupName=key_responsible&parentname=$jobTitle&parentId=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and extract the desired value from each map
      final content = data['resultData'];
      if (content is! List) {
        print('Invalid data format');
        return []; // or any other appropriate default value
      } else {
        checkboxData = content.map((map) => map['value'].toString()).toList();
        setState(() {
          checkboxDataState = checkboxData; // Update the state variable
        });
        print(checkboxData);
        return checkboxData;
      }
    } else {
      print('Failed to fetch data');
      return []; // or any other appropriate default value
    }
  }

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['name'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List> getJobTitle(String pattern, String? name) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

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

  /* Future<List> getJobTitle(String pattern, String? name) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      jobTitleSuggestion = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(jobTitleSuggestion);
      return jobTitleSuggestion;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  Future<List> getJobTitle1(String pattern, String? name) async {
    //Job Benefits
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=job_benifits&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions

      List<dynamic> content = data['resultData']['content'];
      // Sort the content based on the order number
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));

      jobTitleSuggestion1 = content.map((e) => e['value'].toString()).toList();
      print(jobTitleSuggestion1);
      return jobTitleSuggestion1;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* Future<List> getJobTitle1(String pattern, String? name) async {   // JobBenefits without order
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=job_benifits&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      jobTitleSuggestion1 = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(jobTitleSuggestion1);
      return jobTitleSuggestion1;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  Future<List> getJobTitle2(String pattern, String? name) async {
    // shift Time
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=shifttime&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions

      List<dynamic> content = data['resultData']['content'];
      // Sort the content based on the order number
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));

      jobTitleSuggestion2 = content.map((e) => e['value'].toString()).toList();
      print(jobTitleSuggestion2);
      return jobTitleSuggestion2;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* Future<List> getJobTitle2(String pattern, String? name) async {     shift time without order
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=shifttime&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      jobTitleSuggestion2 = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(jobTitleSuggestion2);
      return jobTitleSuggestion2;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  Future<List> getJobTitle5(String pattern, String? name) async {
    //CommunicationRating
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=rating&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions

      List<dynamic> content = data['resultData']['content'];
      // Sort the content based on the order number
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));

      jobTitleSuggestion5 = content.map((e) => e['value'].toString()).toList();
      print(jobTitleSuggestion5);
      return jobTitleSuggestion5;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* Future<List> getJobTitle5(String pattern, String? name) async {  // Communication Rating withoud order
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=rating&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      jobTitleSuggestion5 = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(jobTitleSuggestion5);
      return jobTitleSuggestion5;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  Future<List> getJobTitle3(String pattern, String? name) async {
    // Weak off
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=shiftdesc&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions

      List<dynamic> content = data['resultData']['content'];
      // Sort the content based on the order number
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));

      jobTitleSuggestion3 = content.map((e) => e['value'].toString()).toList();
      print(jobTitleSuggestion3);
      return jobTitleSuggestion3;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /*  Future<List> getJobTitle3(String pattern, String? name) async {  // Weak off without order
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=shiftdesc&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      jobTitleSuggestion3 = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(jobTitleSuggestion3);
      return jobTitleSuggestion3;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

  Future<List> getJobTitle4(String pattern, String? name) async {
    // Interview Rounds
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=interview_rounds&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions

      List<dynamic> content = data['resultData']['content'];
      // Sort the content based on the order number
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));

      jobTitleSuggestion4 = content.map((e) => e['value'].toString()).toList();
      print(jobTitleSuggestion4);
      return jobTitleSuggestion4;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* Future<List> getJobTitle4(String pattern, String? name) async {  // Interview Rounds api withoud order
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=interview_rounds&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      jobTitleSuggestion4 = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(jobTitleSuggestion4);
      return jobTitleSuggestion4;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */
  //shifttime

  final _focusNode = FocusNode();

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  FocusNode focusNode = FocusNode();
  String firstText = '';

  bool myBoolValue = false;

  bool l1 = false, l2 = false, l3 = false;
  //List<bool> isSelected = [];

  bool isNumberOfOpenings = false;

  void handleCustomWidgetChange(bool newValue) {
    setState(() {
      myBoolValue = newValue;
    });
  }

  FocusNode roleFocusNodeFrom = FocusNode();

  List<String> selectedValuesList = [];
  List<String> selectedWorkLocation = [];
  String? workFromHome;
  List<String> selectedValues = [];
  // List<String> selectedWorkLocation = [];
  void getWorkValue(String value) {
    setState(() {
      workFromHome = value;
    });
  }

  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  void updateSelectedValues1(String value) {
    setState(() {
      selectedWorkLocation.add(value);
    });
  }

  /* void handleFocusNodeRequest() {
    setState(() {
      FocusScope.of(context).requestFocus(focusNode); // Request focus on the focusNode
    });
  } */

  List<String> selectedLanguages = [];
  List<String> selectedJobBenefits = [];
  List<String> selectedInterViewRounds = [];
  String? selectedShiftTime1;
  String? selectedComunication;
  String? selectedWeakOff1;

  List<JobTitleItem> jobTitleItems = [];
  List<JobTitleItem> jobTitleItems1 = [];
  List<JobTitleItem> jobTitleItems2 = [];

  List<bool> isSelected = [];
  List<bool> isJobBenefits = [];
  List<bool> isShiftTime1 = [];
  List<bool> isInterview = [];
  List<bool> isWeakOff = [];
  List<bool> isCommunication = [];
  int selectedShiftTime = -1;
  int selectedWeakOff = -1;
  int selectedCommunication = -1;

  bool isOptionVisible = true;
  bool isWeakOfVisible = true;
  bool isCommunicationVisible = true;

  bool isShitTime = false;

  void selectShiftTime(int index) {
    setState(() {
      selectedShiftTime = index;
      isOptionVisible = false;
    });
  }

  void clearSelectedShiftTime() {
    setState(() {
      selectedShiftTime = -1;
      isOptionVisible = true;
    });
  }

  void selectWeakOff(int index) {
    setState(() {
      selectedWeakOff = index;
      isWeakOfVisible = false;
    });
  }

  void clearWeakOff() {
    setState(() {
      selectedWeakOff = -1;
      isWeakOfVisible = true;
    });
  }

  void clearSelectedCommunication() {
    setState(() {
      selectedCommunication = -1;
      isCommunicationVisible = true;
    });
  }

  void selectCommunication(int index) {
    setState(() {
      selectedCommunication = index;
      isCommunicationVisible = false;
    });
  }

  var parentID;

  void handleSelectedID(String id) {
    // Process the selected ID as needed
    print('Selected ID: $id');
    setState(() {
      parentID = id;
    });
    // Perform any other actions with the ID
  }

  //isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
    if (jobTitleSuggestion.isEmpty) {
      // Display a loading indicator or alternative content while fetching data
      return const Scaffold(
          //backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()));
    }
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
                onTap: () {
                  if (selectedComunication == "Excellent | Versant") {
                    selectedEligibility.add(
                        "Excellent English written & verbal Communication skills required.");
                  }
                  if (isFresher == false) {
                    if (isRelevantExpperience == true) {
                      selectedEligibility.add(
                          "Candidate should be from relevant experience background.");
                    }
                  }
                  if (_formKey.currentState!.validate()) {
                    if (isFullTime == false &&
                        isPartTime == false &&
                        isIntern == false &&
                        isContract == false) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Emp Type");
                        },
                      );
                    } else if (graduate == false && undeGraduate == false) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Education type Type");
                        },
                      );
                    } else if (selectedValues.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Add some skill");
                        },
                      );
                    } else if (selectedResponsibility.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Responsibility ");
                        },
                      );
                    } else if (selectedShiftTime1 == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select shift time");
                        },
                      );
                    } else if (selectedWeakOff1 == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Weak-off");
                        },
                      );
                    } else if (worklocationList.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Add work location ");
                        },
                      );
                    } else if (selectedComunication == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select communication rating");
                        },
                      );
                    } else if (selectedInterViewRounds.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select atleast one interview round");
                        },
                      );
                    } else {
                      jobPostModel model = jobPostModel(
                        active: null,

                        roleName: role.text,
                        process: proces.text,
                        // natureOfWorkId: natureofWorkID.toString()
                        industry: industry.text,
                        noOfVacancy: int.parse(numberofopenings.text),
                        empType: isFullTime
                            ? "Full Time"
                            : isPartTime
                                ? "Part Time"
                                : isContract
                                    ? "Contractual"
                                    : isIntern
                                        ? "InternShip"
                                        : " ",
                        education: graduate ? "Graduate" : "Under-Graduate",
                        skills: selectedValues,
                        keyResponsible: selectedResponsibility,
                        languageKnown: selectedLanguages,
                        jobBenefits: selectedJobBenefits,
                        shiftTime: selectedShiftTime1,
                        shiftDesc: selectedWeakOff1,
                        minCtc: int.parse(minSalary.text),
                        maxCtc: int.parse(maxSalary.text),
                        isMonthly: _selectedOption,
                        minExperience: minExp.text,
                        maxExperience: maxExp.text,
                        isFresher: isFresher ? "Fresher" : " ",
                        boundaryLimits: selectedBoundryLimit
                            .map((str) => '- $str')
                            .join('\n'),
                        gender: onlyMale
                            ? "Male"
                            : onlyFemale
                                ? "Female"
                                : femalePrefered
                                    ? "Female prefered"
                                    : " ",
                        minAge: int.parse(minAge.text),
                        maxAge: int.parse(maxAge.text),
                        eligibility: selectedEligibility
                            .map((str) => '- $str')
                            .join('\n'),
                        moreDetails: selectedMoreDetail
                            .map((str) => '- $str')
                            .join('\n'),
                        interviewRounds: selectedInterViewRounds,
                        rating: selectedComunication,

                        workCity: int.parse(CityID.toString()),
                        companyId: int.parse(CompanyID!),
                        natureOfWorkId: NatureOfWorkID,
                        workLocation: worklocationList
                            .map((str) => int.parse(str))
                            .toList(),

                        //  workLocation: sele
//empType:
//minAge: minAge.text
                        // Populate other properties here
                      );

                      Map<String, dynamic> jsonData = model.toJson();
                      JobPostApiService.postDataToApi(jsonData);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                            },
                            title: "Error",
                            subtitle: "Please Fill All The Deatils");
                      },
                    );
                  }
                  // if (shorListController.text.isEmpty) {}//   if(noOfVacancy.text.isEmpty||languageKnown.text.isEmpty||boundryLimits.text.isEmpty){}  these field may be empty
                },
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
                  if (selectedComunication == "Excellent | Versant") {
                    selectedEligibility.add(
                        "Excellent English written & verbal Communication skills required.");
                  }
                  if (isFresher == false) {
                    if (isRelevantExpperience == true) {
                      selectedEligibility.add(
                          "Candidate should be from relevant experience background.");
                    }
                  }
                  if (_formKey.currentState!.validate()) {
                    if (isFullTime == false &&
                        isPartTime == false &&
                        isIntern == false &&
                        isContract == false) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Emp Type");
                        },
                      );
                    } else if (graduate == false && undeGraduate == false) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Education type Type");
                        },
                      );
                    } else if (selectedValues.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Add some skill");
                        },
                      );
                    } else if (selectedResponsibility.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Responsibility ");
                        },
                      );
                    } else if (selectedShiftTime1 == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select shift time");
                        },
                      );
                    } else if (selectedWeakOff1 == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select Weak-off");
                        },
                      );
                    } else if (worklocationList.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Add work location ");
                        },
                      );
                    } else if (selectedComunication == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select communication rating");
                        },
                      );
                    } else if (selectedInterViewRounds.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                              },
                              title: "Error",
                              subtitle: "Select atleast one interview round");
                        },
                      );
                    } else {
                      jobPostModel model = jobPostModel(
                        active: 1,

                        roleName: role.text,
                        process: proces.text,
                        // natureOfWorkId: natureofWorkID.toString()
                        industry: industry.text,
                        noOfVacancy: int.parse(numberofopenings.text),
                        empType: isFullTime
                            ? "Full Time"
                            : isPartTime
                                ? "Part Time"
                                : isContract
                                    ? "Contractual"
                                    : isIntern
                                        ? "InternShip"
                                        : " ",
                        education: graduate ? "Graduate" : "Under-Graduate",
                        skills: selectedValues,
                        keyResponsible: selectedResponsibility,
                        languageKnown: selectedLanguages,
                        jobBenefits: selectedJobBenefits,
                        shiftTime: selectedShiftTime1,
                        shiftDesc: selectedWeakOff1,
                        minCtc: int.parse(minSalary.text),
                        maxCtc: int.parse(maxSalary.text),
                        isMonthly: _selectedOption,
                        minExperience: minExp.text,
                        maxExperience: maxExp.text,
                        isFresher: isFresher ? "Fresher" : " ",
                        boundaryLimits: selectedBoundryLimit
                            .map((str) => '- $str')
                            .join('\n'),
                        gender: onlyMale
                            ? "Male"
                            : onlyFemale
                                ? "Female"
                                : femalePrefered
                                    ? "Female prefered"
                                    : " ",
                        minAge: int.parse(minAge.text),
                        maxAge: int.parse(maxAge.text),
                        eligibility: selectedEligibility
                            .map((str) => '- $str')
                            .join('\n'),
                        moreDetails: selectedMoreDetail
                            .map((str) => '- $str')
                            .join('\n'),
                        interviewRounds: selectedInterViewRounds,
                        rating: selectedComunication,

                        workCity: int.parse(CityID.toString()),
                        companyId: int.parse(CompanyID!),
                        natureOfWorkId: NatureOfWorkID,
                        workLocation: worklocationList
                            .map((str) => int.parse(str))
                            .toList(),

                        //  workLocation: sele
//empType:
//minAge: minAge.text
                        // Populate other properties here
                      );

                      Map<String, dynamic> jsonData = model.toJson();
                      JobPostApiService.postDataToApi(jsonData);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                            },
                            title: "Error",
                            subtitle: "Please Fill All The Deatils");
                      },
                    );
                  }
                  // if (shorListController.text.isEmpty) {}//   if(noOfVacancy.text.isEmpty||languageKnown.text.isEmpty||boundryLimits.text.isEmpty){}  these field may be empty
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
        title: const Text("Job Posting"),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {
            if (shorListController.text.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            }
            /* setState(() {
              {
                if (!isEdit1) {
                  role.clear();
                }
                if (!isEdit3) {
                  natureOfWork.clear();
                }
                if (!isEdit2) {
                  proces.clear();
                }
                if (!isEdit4) {
                  shorListController.clear();
                }
                if (!isEdit5) {
                  industry.clear();
                }
                if (!isEdit6) {
                  functionalArea.clear();
                }
                /* if (!isEdit7) {
                  skills.clear();
                } */
              }
            }); */
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (shorListController.text.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Company Name",
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        customContainerSelect1(true, shorListController.text),
                      ],
                    ),

                  /* CustomJobFormTextField(
                    isCompany: true,
                    name: "company",
                    /* onFocusNodeRequested: (p0) {
                      focusNode.requestFocus();
                    }, */
                    title: "Company Name",
                    controller: shorListController,
                    // isEdit: isEdit,
                    //  focusNode: focusNode,
                    onChanged: (p0) {
                      isEdit4 = p0;
                    },
                    contextIn: context,
                    onSubmit: getCompanyId,
                    hintText: "Aditya birla Health Insurance",
                    getSuggestions: getSuggestions,
                    onIDSelected: handleSelectedID,
                  ), */
                  if (role.text.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width / 2.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Job Title / Role",
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              customContainerSelect1(true, role.text),
                            ],
                          ),
                          /* CustomJobFormTextFieldRespOne(
                          isCompany: false,
                          name: "job_role",
                          /* onFocusNodeRequested: (p0) {
                            focusNode.requestFocus();
                          }, */
                          title: "Job Title / Role",
                          controller: role,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          onChanged: (p0) {
                            isEdit1 = p0;
                          },
                          onIDSelected: handleSelectedID,
                          contextIn: context,
                          hintText: "Sr. Executive",
                          onSubmit: getValueOfJobtitle,
                          //  getSuggestions: getJobTitle,
                        ), */
                        ),
                        if (proces.text.isNotEmpty)
                          SizedBox(
                            width: width / 2.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Process",
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                customContainerSelect1(true, proces.text),
                              ],
                            ),
                            /*  CustomJobFormTextFieldRespOne(
                          isCompany: false,
                          name: "process",
                          /* onFocusNodeRequested: (p0) {
                        focusNode.requestFocus();
                                          }, */
                          title: "Process",
                          controller: proces,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          onChanged: (p0) {
                            isEdit2 = p0;
                          },
                          contextIn: context,
                          hintText: "Health Insurance",
                          //   getSuggestions: getJobTit
                          onIDSelected: handleSelectedID,
                        ), */
                          ),
                      ],
                    ),
                  if (natureOfWork.text.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width / 2.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "functional Area",
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              customContainerSelect1(true, natureOfWork.text),
                            ],
                          ),
                          /* CustomJobFormTextFieldJobRespo(
                          isCompany: false,
                          name: "now",
                          /* onFocusNodeRequested: (p0) {
                            focusNode.requestFocus();
                          }, */
                          title: "Functional Area", // Nature of Work on update
                          controller: natureOfWork,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          pId: pId,
                          onChanged: (p0) {
                            isEdit3 = p0;
                            //fetchData();
                          },
                          contextIn: context,
                          hintText: "Sales",
                          //  onIDSelected: handleSelectedID,
                          onSubmit: fetchData,
                          // getSuggestions: getJobTitle,
                        ), */
                        ),
                        SizedBox(
                          width: width / 2.2,
                          child: CustomJobFormTextFieldRespOne(
                            focusNode: roleFocusNodeFrom,
                            isCompany: false,
                            name: "industry",
                            /* onFocusNodeRequested: (p0) {
                        focusNode.requestFocus();
                                          }, */
                            title: "Industry",
                            controller: industry,
                            // isEdit: isEdit,
                            //  focusNode: focusNode,
                            onChanged: (p0) {
                              isEdit5 = p0;
                            },
                            contextIn: context,
                            hintText: "NBFC",
                            onIDSelected: handleSelectedID,
                            // getSuggestions: getJobTitle,
                          ),
                        ),
                      ],
                    ),

                  /*  CustomJobFormTextField(     //functional Area
                    isCompany: false,
                    name: "functional_area",
                    /* onFocusNodeRequested: (p0) {
                      focusNode.requestFocus();
                    }, */
                    title: "Functional Area",
                    controller: functionalArea,
                    // isEdit: isEdit,
                    //  focusNode: focusNode,
                    onChanged: (p0) {
                      isEdit6 = p0;
                    },
                    contextIn: context,
                    hintText: "Sales",
                   getSuggestions: getJobTitle,
                  ), */
                  /*  newFormFiled(shorListController, context,
                      "Number of Openings", "e.g 1", true, false, true), */

                  Text(
                    "Number of Openings",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  isNumberOfOpenings
                      ? customContainerSelect(
                          isVacancy: true,
                          isCross: true,
                          isNumOfOpening: true,
                          onPressed: () {
                            setState(() {
                              isNumberOfOpenings = false;
                              // FocusScope.of(context).autofocus(focusNode);
                              numberofopenings.clear();
                              numberOfOpeningFocusNode.requestFocus();
                            });
                          },
                          isSelect: true,
                          title: numberofopenings.text)
                      : Container(
                          width: MediaQuery.of(context).size.width / 6.w,
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
                                    MediaQuery.of(context).size.height / 25.h,
                                color: Colors.white,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This Text field Cant be empty";
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[.]')),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  focusNode: numberOfOpeningFocusNode,
                                  maxLength: 3,
                                  onFieldSubmitted: (value) {
                                    numberofopenings.text.isNotEmpty
                                        ? setState(() {
                                            isNumberOfOpenings = true;
                                            // _showContainer1 = value.isEmpty;
                                          })
                                        : null;
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  onTapOutside: (event) {
                                    numberofopenings.text.isNotEmpty
                                        ? setState(() {
                                            isNumberOfOpenings = true;
                                            // _showContainer1 = value.isEmpty;
                                          })
                                        : null;
                                  },
                                  onEditingComplete: () {
                                    numberofopenings.text.isNotEmpty
                                        ? setState(() {
                                            isNumberOfOpenings = true;
                                            // _showContainer1 = value.isEmpty;
                                          })
                                        : null;
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: numberofopenings,
                                  enabled: enableShortListFor,
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
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffff0eceb)),
                                      ),
                                      focusColor: const Color(0xffff0eceb),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 122, 113, 111)),
                                      ),
                                      hintText: "e.g. 1",
                                      hintStyle: GoogleFonts.sourceSansPro(
                                          color: Constants.subtitleclr,
                                          fontSize: 15.sp)
                                      //  prefixIcon: Icon(Icons.list)
                                      ),
                                ),
                              ),
                            ],
                          )),

                  Text(
                    "Emp Type",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    children: [
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = true;
                              isContract = false;
                              isIntern = false;
                            });
                          },
                          isSelect: isFullTime,
                          title: "Full Time"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              isPartTime = true;
                              isFullTime = false;
                              isContract = false;
                              isIntern = false;
                            });
                          },
                          isSelect: isPartTime,
                          title: "Part Time"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = false;
                              isContract = true;
                              isIntern = false;
                            });
                          },
                          isSelect: isContract,
                          title: "Contractual"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = false;
                              isContract = false;
                              isIntern = true;
                            });
                          },
                          isSelect: isIntern,
                          title: "Internship"),
                    ],
                  ),
                  Text(
                    "Education",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    children: [
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              undeGraduate = true;
                              graduate = false;
                            });
                          },
                          isSelect: undeGraduate,
                          title: "Under-Graduate"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              graduate = true;
                              undeGraduate = false;
                            });
                          },
                          isSelect: graduate,
                          title: "Graduate"),
                    ],
                  ),
                  CustomFormTextFieldMultiSelect(
                    // isCompany: false,
                    name: "skills",
                    isSkill: true,
                    /* onFocusNodeRequested: (p0) {
                      focusNode.requestFocus();
                    }, */
                    title: "Skills Required",
                    controller: skills,
                    selectedValuesList: selectedValuesList,
                    callback: updateSelectedValues,
                    // isEdit: isEdit,
                    //  focusNode: focusNode,
                    /*  onChanged: (p0) {
                      isEdit7 = p0;
                    }, */
                    contextIn: context,
                    hintText: "Advance Excel",
                    // getSuggestions: getJobTitle,
                  ),
                  /* newFormFiled(shorListController, context, "Skills Required",
                      "Advance Excel", false, false, false), */

                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Job Responsibility",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  //  if (checkboxData.isNotEmpty)
                  /*  ListView.builder(
                    shrinkWrap: true,
                    itemCount: checkboxData.length,
                    itemBuilder: (context, index) {
                      final item = checkboxData[index];

                      // Call your function here
                      //   fetchData();

                      // Return the list item widget
                      return Text(checkboxData[index]);
                    },
                  ), */
                  /* ListView.builder(
                      shrinkWrap: true,
                      itemCount: checkboxData.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(checkboxData[index]),
                          value: checkboxData[index].isNotEmpty ? true : false,
                          onChanged: (newValue) {
                            // Handle checkbox state change
                            // ...
                          },
                        );
                      }), */
                  checkboxData.isNotEmpty
                      ? const SizedBox()
                      : const SizedBox(
                          height: 5,
                        ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: checkboxData.length,
                    itemBuilder: (context, index) {
                      final item = checkboxData[index];
                      //  fetchData();
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              height: 16,
                              width: 20,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          // selectedResponsibility.contains(item)
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
                                      activeColor: Colors.white,
                                      checkColor: Colors.red,
                                      visualDensity: VisualDensity.compact,
                                      value:
                                          selectedResponsibility.contains(item),
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue!) {
                                            // Add the item to the list
                                            selectedResponsibility.add(item);
                                          } else {
                                            // Remove the item from the list
                                            selectedResponsibility.remove(item);
                                          }
                                        });
                                        print(
                                            selectedResponsibility); // Notify Flutter that the state has changed
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                item,
                                softWrap:
                                    true, // Allow text to wrap into the next line
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: height / 25,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'^\s')), // Disallow spaces at the beginning
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      // textInputAction: TextInputAction.newline,

                      // onFieldSubmitted: (_) => _handleTextSubmitted(),
                      controller: responsibility,
                      //  textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,

                      /*  onSubmitted: (value) {
                        setState(() {
                          checkboxData.add(responsibility.text);
                          selectedResponsibility.add(responsibility.text);
                          responsibility.clear();
                        });
                      }, */
                      onEditingComplete: () {
                        final newResponsibility = responsibility.text.trim();
                        if (newResponsibility.isNotEmpty &&
                            !checkboxData.contains(newResponsibility)) {
                          setState(() {
                            checkboxData.add(newResponsibility);
                            selectedResponsibility.add(newResponsibility);
                            responsibility.clear();
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Responsibility already exists.'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },

                      /*  onTapOutside: (event) {
                        
                        setState(() {
                          
                          checkboxData.add(responsibility.text);
                        });
                      }, */
                      maxLines: 1,
                      decoration: InputDecoration(
                          /*  errorText: checkboxData
                                  .contains(responsibility.text.trim())
                              ? 'Responsibility already exists.'
                              : null, */
                          contentPadding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          prefix: Column(
                            children: _getBulletPointWidgetsrespo(),
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          // Icons.workspace_premium
                          // label: const Text("Company Name *"),
                          //border: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: checkboxData
                                    .contains(responsibility.text.trim())
                                ? const BorderSide(color: Colors.red)
                                : BorderSide(color: Colors.grey.shade400),
                          ),
                          focusColor: const Color(0xffff0eceb),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: checkboxData
                                    .contains(responsibility.text.trim())
                                ? const BorderSide(color: Colors.red)
                                : BorderSide(color: Colors.grey.shade400),
                          ),
                          hintText:
                              "Any other responsibility that you want to add",
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr, fontSize: 14.sp)
                          //  prefixIcon: Icon(Icons.list)

                          ),
                    ),
                  ),
                  Container(
                    margin: checkboxData.contains(responsibility.text.trim())
                        ? const EdgeInsets.only(bottom: 15, left: 10)
                        : null,
                    child: Text(
                      checkboxData.contains(responsibility.text.trim())
                          ? "This Responsibility is already added."
                          : "",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        "Language Required",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  (Optional)",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp, fontStyle: FontStyle.italic
                            // color: Colors.grey.shade500,
                            ),
                      )
                    ],
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        jobTitleSuggestion.length,
                        (index) {
                          JobTitleItem item = JobTitleItem(
                            ismulti: false,
                            title: jobTitleSuggestion[index],
                            isSelected: isSelected[index],
                            onTap: () {
                              setState(() {
                                isSelected[index] = !isSelected[index];
                                JobTitleItem currentItem = jobTitleItems[index];
                                if (isSelected[index]) {
                                  selectedLanguages.add(currentItem.title);
                                } else {
                                  selectedLanguages.remove(currentItem.title);
                                }
                              });
                            },
                            isVisible: true,
                            onlyOneIcon: false,
                            getJobTitle1isSelected: null,
                          );

                          jobTitleItems.add(item);
                          return item;
                        },
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        "Job Benefits",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  (Optional)",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp, fontStyle: FontStyle.italic
                            // color: Colors.grey.shade500,
                            ),
                      )
                    ],
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion1.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: false,
                          ismulti: false,
                          title: jobTitleSuggestion1[index],
                          isSelected: isJobBenefits[index],
                          onTap: () {
                            setState(() {
                              isJobBenefits[index] = !isJobBenefits[index];
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ), */
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        jobTitleSuggestion1.length,
                        (index) {
                          JobTitleItem item = JobTitleItem(
                            ismulti: false,
                            title: jobTitleSuggestion1[index],
                            isSelected: isJobBenefits[index],
                            onTap: () {
                              setState(() {
                                isJobBenefits[index] = !isJobBenefits[index];
                                JobTitleItem currentItem =
                                    jobTitleItems1[index];
                                if (isJobBenefits[index]) {
                                  selectedJobBenefits.add(currentItem.title);
                                } else {
                                  selectedJobBenefits.remove(currentItem.title);
                                }
                              });
                            },
                            isVisible: true,
                            onlyOneIcon: false,
                            getJobTitle1isSelected: null,
                          );

                          jobTitleItems1.add(item);
                          return item;
                        },
                      ),
                    ),
                  ),
                  /* Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          jobTitleSuggestion.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected[index] = !isSelected[index];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected[index]
                                    ? const Color(0xfff310d44)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    jobTitleSuggestion[index],
                                    style: TextStyle(
                                        color: isSelected[index]
                                            ? Colors.white
                                            : null),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Icon(
                                    isSelected[index] ? Icons.check : Icons.add,
                                    size: 15.h,
                                    color:
                                        isSelected[index] ? Colors.white : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )), */

                  /*  newFormFiled(shorListController, context, "Language Required",
                      "Tamil, Kannada, Punjabi", false, false, true), */

                  /*  newFormFiled(shorListController, context, "Job Benefits",
                      "PF", false, false, false), */

                  Text(
                    "Shift Time",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isOptionVisible ? 5 : 0,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion2.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: true,
                          ismulti:
                              false, // Set ismulti to false for single select
                          title: jobTitleSuggestion2[index],
                          isSelected: isShiftTime1[index],
                          onTap: () {
                            setState(() {
                              // Clear all previous selections
                              for (int i = 0; i < isShiftTime1.length; i++) {
                                isShiftTime1[i] = false;
                              }
                              // Select the tapped item
                              isShiftTime1[index] = true;

                              // Update selectedJobTitles

                              selectedShiftTime1 = jobTitleSuggestion2[index];
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ),
                  /* Container(// previous code of shift time before 8/06/23
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isOptionVisible ? 5 : 0,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion2.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: true,
                          ismulti:
                              false, // Set ismulti to false for single select
                          title: jobTitleSuggestion2[index],
                          isSelected: isShiftTime1[index],
                          onTap: () {
                            setState(() {
                              // Clear all previous selections
                              for (int i = 0; i < isShiftTime1.length; i++) {
                                isShiftTime1[i] = false;
                              }
                              // Select the tapped item
                              isShiftTime1[index] = true;
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ), */
                  /* Container(                 //shift time multi select and all visible
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isOptionVisible ? 5 : 0,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion2.length, (index) {
                        return JobTitleItem(
                          ismulti: true,
                          title: jobTitleSuggestion2[index],
                          isSelected: isShiftTime1[index],
                          onTap: () {
                            setState(() {
                              isShiftTime1[index] = !isShiftTime1[index];
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ), */
                  Text(
                    "Weak Off",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isOptionVisible ? 5 : 0,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion3.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: true,
                          ismulti:
                              false, // Set ismulti to false for single select
                          title: jobTitleSuggestion3[index],
                          isSelected: isWeakOff[index],
                          onTap: () {
                            setState(() {
                              // Clear all previous selections
                              for (int i = 0; i < isWeakOff.length; i++) {
                                isWeakOff[i] = false;
                              }
                              // Select the tapped item
                              isWeakOff[index] = true;

                              // Update selectedJobTitles

                              selectedWeakOff1 = jobTitleSuggestion3[index];
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ),
                  /*  Container(  // old selected weak off 
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 12,
                    ),
                    child: Wrap(
                      spacing: isWeakOfVisible ? 5 : 5,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion3.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: true,
                          ismulti: false,
                          title: jobTitleSuggestion3[index],
                          isSelected: isWeakOff[index],
                          onTap: () {
                            setState(() {
                              // Clear all previous selections
                              for (int i = 0; i < isWeakOff.length; i++) {
                                isWeakOff[i] = false;
                              }
                              // Select the tapped item
                              isWeakOff[index] = true;
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ), */
                  Text(
                    "Salary",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  // if (minSalary.text.length >= 4 && _selectedOption.isNotEmpty)

                  isValueValid && minSalaryk.isNotEmpty && maxSalaryk.isNotEmpty
                      ? customContainerSelect(
                          isCross: true,
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              isValueValid = false;
                            });
                          },
                          isSelect: true,
                          isSalary: true,
                          title: "$minSalaryk -  $maxSalaryk $_selectedOption")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5.w,
                              child: newFormFiled(
                                  controller: minSalary,
                                  context: context,
                                  title: "",
                                  subTitle: "Min-salary",
                                  isNum: true,
                                  isVisible: false,
                                  nonEdit: false,
                                  sioptonal: false),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 35.h,
                                child: const Text("-")),
                            const SizedBox(
                              width: 5,
                            ),
                            minSalary.text.length <= 3
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5.w,
                                    child: newFormFiled1(
                                        controller: maxSalary,
                                        context: context,
                                        title: "",
                                        subTitle: "Max-salary",
                                        isNum: true,
                                        isVisible: false,
                                        nonEdit: false,
                                        sioptonal: false),
                                  )
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5.w,
                                    child: newFormFiled1(
                                        controller: maxSalary,
                                        context: context,
                                        title: "",
                                        subTitle: "Max-salary",
                                        isNum: true,
                                        isVisible: false,
                                        nonEdit: true,
                                        sioptonal: false),
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
                              value: 'Per Month',
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value.toString();
                                });
                              },
                            )),
                            const Text("P.M"),
                            SizedBox(
                                child: Radio(
                              value: 'PA',
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value.toString();
                                });
                              },
                            )),
                            const Text("P.A")
                          ],
                        ),
                  isEdit8
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Work Location",
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 18.sp,
                                        // color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  customContainerSelect(
                                      isAnother: true,
                                      isVacancy: true,
                                      isCross: true,
                                      onPressed: () {
                                        setState(() {
                                          isEdit8 = false;
                                          location.clear();
                                          city.clear();
                                        });
                                      },
                                      isSelect: true,
                                      title: workFromHome.toString())
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2.w,
                              child: CustomJobFormTextFieldJobRespo(
                                isCompany: false,
                                name: "city",
                                /* onFocusNodeRequested: (p0) {
                                                      focusNode.requestFocus();
                                                    }, */
                                title: "City",
                                controller: city,
                                // isEdit: isEdit,
                                //  focusNode: focusNode,
                                onChanged: (p0) {
                                  isEdit10 = p0;
                                },
                                contextIn: context,
                                onSubmit: getCityId,
                                hintText: "Thane",
                                //  onIDSelected: handleSelectedID,
                                //   getSuggestions: getJobTitle,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : CustomFormTextFieldMultiSelect(
                          // isCompany: false,
                          name: "location",
                          isSkill: false,
                          /* onFocusNodeRequested: (p0) {
                      focusNode.requestFocus();
                    }, */
                          title: "Work Location",
                          controller: location,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          onChanged: (p0) {
                            isEdit8 = p0;
                          },
                          workType: getWorkValue,
                          submit: getWorkLocation,
                          // selectedValuesList: selectedWorkLocation,
                          callback: updateSelectedValues1,
                          contextIn: context,
                          hintText: "Thane",
                          //  onIDSelected: handleSelectedID,
                          //   getSuggestions: getJobTitle,
                        ),
                  const SizedBox(
                    height: 10,
                  ),

                  /* newFormFiled(shorListController, context, "Locality", "Thane",
                      false, false, false), */
                  Row(
                    children: [
                      Text(
                        "Boundry Limits",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  (Optional)",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp, fontStyle: FontStyle.italic
                            // color: Colors.grey.shade500,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _boundryLimitList.length,
                    itemBuilder: (context, index) {
                      final checkitem = _boundryLimitList[index];
                      final isChecked = checkitem.isChecked;
                      final item = checkitem.text;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              height: 16,
                              width:
                                  20, // Adjust the width according to your requirements
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _boundryLimitList[index].isChecked =
                                        !isChecked;
                                    if (isChecked) {
                                      selectedBoundryLimit.remove(item);
                                    } else {
                                      selectedBoundryLimit.add(item);
                                    }
                                  });
                                },
                                child: Container(
                                  // margin: const EdgeInsets.only(bottom: 4),
                                  height: 16,
                                  width: 20,
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _boundryLimitList[index].isChecked
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.transparent,
                                    ),
                                    child: Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.white,
                                      checkColor: Colors.red,
                                      value: _boundryLimitList[index].isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _boundryLimitList[index].isChecked =
                                              value!;

                                          if (value) {
                                            selectedBoundryLimit.add(item);
                                          } else {
                                            selectedBoundryLimit.remove(item);
                                          }
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      side: isChecked
                                          ? const BorderSide(color: Colors.red)
                                          : null, // No border when unchecked

                                      // Remove extra padding around the checkbox
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(item),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    height: height / 25.h,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'^\s')), // Disallow spaces at the beginning
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      // textInputAction: TextInputAction.newline,
                      onEditingComplete: () {
                        _handleBoundrySubmitted(boundryLimits.text);
                      },
                      maxLines: 1,
                      // onFieldSubmitted: (_) => _handleTextSubmitted(),
                      controller: boundryLimits,
                      //  textInputAction: TextInputAction.newline,
                      //keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      // maxLines: null,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          prefix: Column(
                            children: _getBulletPointWidgetsbond(),
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          // Icons.workspace_premium
                          // label: const Text("Company Name *"),
                          //border: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffff0eceb)),
                          ),
                          focusColor: const Color(0xffff0eceb),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 122, 113, 111)),
                          ),
                          hintText: "Dadar to Ambarnath",
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr, fontSize: 15.sp)
                          //  prefixIcon: Icon(Icons.list)
                          ),
                    ),
                  ),

                  Text(
                    "Experience",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Visibility(
                      visible: _showContainer1 && _showContainer2,
                      child: customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              isFresher = !isFresher;
                            });
                          },
                          isSelect: isFresher,
                          title: "Fresher can also apply.")

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
                                customContainerSelect(
                                    isCross: true,
                                    onPressed: () {
                                      setState(() {
                                        expContainer = false;
                                        experinceFocusNode.requestFocus();
                                      });
                                    },
                                    isSelect: expContainer,
                                    title:
                                        "${minExp.text} - ${maxExp.text} Yrs"),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          5.w,
                                      child: /* newFormFiled(
                                  minExp, context, "", "Min-exp", true, true), */
                                          Container(
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
                                                25.h,
                                            color: Colors.white,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "This Text field Cant be empty";
                                                }
                                                return null;
                                              },
                                              maxLength: 3,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,2}')),
                                              ],
                                              focusNode: experinceFocusNode,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (minExp.text.isNotEmpty) {
                                                    setState(() {
                                                      isCheckBox = !isCheckBox;
                                                    });
                                                  }
                                                  enableExperience =
                                                      value.isNotEmpty;
                                                  _showContainer1 =
                                                      value.isEmpty;
                                                  if (minExp.text.isEmpty) {
                                                    setState(() {
                                                      isRelevantExpperience =
                                                          false;
                                                    });
                                                    maxExp.clear();
                                                    /*  _showContainer1 =
                                                                !_showContainer1; */
                                                    _showContainer2 !=
                                                        _showContainer2;
                                                    expContainer = false;
                                                  }
                                                });
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: minExp,
                                              enabled: enableShortListFor,
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
                                                  hintText: "Min-exp",
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
                                      ))),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const SizedBox(child: Text("-")),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5.w,
                                    child: /* newFormFiled(
                                  maxExp, context, "", "Max-exp", true, true), */
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                6.w,
                                            child: /* newFormFiled(
                                  minExp, context, "", "Min-exp", true, true), */
                                                Container(
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
                                                      25.h,
                                                  color: Colors.white,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "This Text field Cant be empty";
                                                      }
                                                      return null;
                                                    },
                                                    maxLength: 3,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'^\d+\.?\d{0,2}')),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        /* _showContainer2 =
                                                                    value.isEmpty; */
                                                      });
                                                    },
                                                    /*  onSubmitted:
                                                                (newValue) {
                                                              maxExp.text
                                                                      .isNotEmpty
                                                                  ? setState(() {
                                                                      expContainer =
                                                                          newValue
                                                                              .isNotEmpty;
                                                                    })
                                                                  : null;
                                                            }, */
                                                    onFieldSubmitted:
                                                        (newValue) {
                                                      /*   maxAge.text.isNotEmpty &&
                                                            minAge.text.isNotEmpty */

                                                      if (maxExp
                                                          .text.isNotEmpty) {
                                                        double? age =
                                                            double.tryParse(
                                                                maxExp.text);
                                                        double? age2 =
                                                            double.tryParse(
                                                                minExp.text);
                                                        if (age! <= age2!) {
                                                          // Clear the text field if the entered number is not above 18
                                                          /* WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          ageGroup.clear();
                                                          
                                                        }); */
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CustomDialog(
                                                                  isFisrt:
                                                                      false,
                                                                  onClose: () {
                                                                    Navigator.pop(
                                                                        context);

                                                                    setState(
                                                                        () {
                                                                      expContainer =
                                                                          !newValue
                                                                              .isNotEmpty;
                                                                      _showContainer1 =
                                                                          true;
                                                                      _showContainer2 =
                                                                          true;
                                                                      enableExperience =
                                                                          false;
                                                                      minExp
                                                                          .clear();
                                                                      maxExp
                                                                          .clear();
                                                                    });
                                                                  },
                                                                  title:
                                                                      "Invalid Experience Value!",
                                                                  subtitle:
                                                                      "Max Experience should be greater than Min Experience");
                                                            },
                                                          );
                                                        } else if (maxExp.text
                                                                .isNotEmpty &&
                                                            minExp.text
                                                                .isNotEmpty) {
                                                          setState(() {
                                                            expContainer =
                                                                newValue
                                                                    .isNotEmpty;
                                                          });
                                                        }
                                                      } /* else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return CustomDialog(
                                                                        onClose:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          minExp
                                                                              .clear();
                                                                          // maxExp.clear();
                                                                          setState(
                                                                              () {
                                                                            expContainer =
                                                                                !newValue.isNotEmpty;
                                                                            enableExperience =
                                                                                enableExperience = newValue.isNotEmpty;
                                                                            /*   _showContainer1 = !_showContainer1;
                                                                                _showContainer2 = !_showContainer2; */
                                                                          });
                                                                        },
                                                                        title:
                                                                            "Invalid Experience Value!",
                                                                        subtitle:
                                                                            "Please enter min experince");
                                                                  },
                                                                );
                                                              } */
                                                    },
                                                    onEditingComplete: () {
                                                      if (minExp.text.isEmpty) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return CustomDialog(
                                                                isFisrt: false,
                                                                onClose: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  minExp
                                                                      .clear();
                                                                  maxExp
                                                                      .clear();
                                                                  // maxExp.clear();
                                                                  setState(() {
                                                                    expContainer =
                                                                        !expContainer;
                                                                    enableExperience =
                                                                        false;
                                                                    /*   enableExperience =
                                                                               // newValue.isNotEmpty; */
                                                                    /*   _showContainer1 = !_showContainer1;
                                                                                _showContainer2 = !_showContainer2; */
                                                                  });
                                                                },
                                                                title:
                                                                    "Invalid Experience Value!",
                                                                subtitle:
                                                                    "Please enter min experince");
                                                          },
                                                        );
                                                      }
                                                    },
                                                    /* onTapOutside:
                                                                (event) {
                                                              maxExp.text
                                                                      .isNotEmpty
                                                                  ? setState(() {
                                                                      expContainer =
                                                                          !expContainer;
                                                                    })
                                                                  : null;
                                                            }, */
                                                    /* onEditingComplete:
                                                                () {
                                                              maxExp.text
                                                                      .isNotEmpty
                                                                  ? setState(() {
                                                                      expContainer =
                                                                          !expContainer;
                                                                    })
                                                                  : null;
                                                            }, */
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: maxExp,
                                                    /*   enabled:
                                                                enableShortListFor, */
                                                    enabled: enableExperience,
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
                                                    decoration: InputDecoration(
                                                        counterText: '',
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
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
                                                                  .circular(8),
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
                                                                  .circular(8),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          122,
                                                                          113,
                                                                          111)),
                                                        ),
                                                        hintText: "Max-exp",
                                                        hintStyle: GoogleFonts
                                                            .sourceSansPro(
                                                                color: Constants
                                                                    .subtitleclr,
                                                                fontSize: 15.sp)
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
                                    "Yrs",
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 16.sp,
                                        // color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                    ),

                  if (minExp.text.isNotEmpty)
                    /*  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          //   shape: const OutlineInputBorder(),
                          value: isRelevantExpperience,
                          onChanged: (value) {
                            setState(() {
                              isRelevantExpperience = value!;
                            });
                          },
                        ),
                        const Text(
                          "Candidate should be from relevant experience background.",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ), */
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 3),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 16,
                            width:
                                20, // Adjust the width according to your requirements
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isRelevantExpperience =
                                      !isRelevantExpperience;
                                });
                              },
                              child: Container(
                                // margin: const EdgeInsets.only(bottom: 4),
                                height: 16,
                                width: 20,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isRelevantExpperience
                                        ? Colors.red
                                        : Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.transparent,
                                  ),
                                  child: Checkbox(
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Colors.white,
                                    checkColor: Colors.red,
                                    value: isRelevantExpperience,
                                    onChanged: (value) {
                                      setState(() {
                                        isRelevantExpperience = value!;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    side: isRelevantExpperience
                                        ? const BorderSide(color: Colors.red)
                                        : null, // No border when unchecked

                                    // Remove extra padding around the checkbox
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Candidate should be from relevant experience background.",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),

                  Row(
                    children: [
                      Text(
                        "Gender",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  (Optional)",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp, fontStyle: FontStyle.italic
                            // color: Colors.grey.shade500,
                            ),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      customContainerSelect(
                          //isCross: true,
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              onlyMale = true;
                              onlyFemale = false;
                              femalePrefered = false;
                            });
                          },
                          isSelect: onlyMale,
                          title: "Only Male"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              femalePrefered = false;
                              onlyMale = false;
                              onlyFemale = true;
                            });
                          },
                          isSelect: onlyFemale,
                          title: "Only Female"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              femalePrefered = true;
                              onlyMale = false;
                              onlyFemale = false;
                            });
                          },
                          isSelect: femalePrefered,
                          title: "Female Prefered")
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Age Group",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  (Optional)",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp, fontStyle: FontStyle.italic
                            // color: Colors.grey.shade500,
                            ),
                      )
                    ],
                  ),
                  agegroupContainer
                      ? Row(
                          children: [
                            customContainerSelect(
                                isCross: true,
                                isAnother: true,
                                onPressed: () {
                                  setState(() {
                                    agegroupContainer = false;
                                  });
                                },
                                isSelect: agegroupContainer,
                                title: "${minAge.text} - ${maxAge.text} Yrs"),
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
                                width: MediaQuery.of(context).size.width / 5.w,
                                child: /* newFormFiled(
                                minExp, context, "", "Min-exp", true, true), */
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
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
                                                  25.h,
                                              color: Colors.white,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "This Text field Cant be empty";
                                                  }
                                                  return null;
                                                },
                                                maxLength: 2,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .deny(RegExp(r'[.]')),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onFieldSubmitted: (value) {
                                                  checkAge();
                                                },
                                                onEditingComplete: () {
                                                  checkAge();
                                                },
                                                /*  onTapOutside: (event) {
                                                  checkAge();
                                                }, */
                                                onChanged: (value) {
                                                  checkAgeGroup(minAge.text);
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: minAge,
                                                enabled: enableShortListFor,
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
                                                    counterText: "",
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            bottom: 15,
                                                            left: 10,
                                                            right: 10),
                                                    // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                                    // Icons.workspace_premium
                                                    // label: const Text("Company Name *"),
                                                    //border: OutlineInputBorder(),
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
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      122,
                                                                      113,
                                                                      111)),
                                                    ),
                                                    hintText: "Min-age",
                                                    hintStyle: GoogleFonts
                                                        .sourceSansPro(
                                                            color: Constants
                                                                .subtitleclr,
                                                            fontSize: 15.sp)
                                                    //  prefixIcon: Icon(Icons.list)
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ))),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 35,
                                child: const Text("-")),
                            const SizedBox(
                              width: 5,
                            ),
                            /* SizedBox(
                        width: MediaQuery.of(context).size.width / 6.w,
                        child: newFormFiled(shorListController, context, "",
                            "Max-age", true, false),
                      ), */ //if (maxAge.text.isNotEmpty&&ma)

                            SizedBox(
                                width: MediaQuery.of(context).size.width / 5.w,
                                child: /* newFormFiled(
                                minExp, context, "", "Min-exp", true, true), */
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
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
                                                  25.h,
                                              color: Colors.white,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "This Text field Cant be empty";
                                                  }
                                                  return null;
                                                },
                                                maxLength: 2,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .deny(RegExp(r'[.]')),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                enabled:
                                                    _isSecondTextFieldEnabled,
                                                onChanged: (value) {
                                                  if (value.isNotEmpty) {
                                                    int? age =
                                                        int.tryParse(value);
                                                    if (age! <= 18) {
                                                      // Clear the text field if the entered number is not above 18
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        ageGroup.clear();
                                                      });
                                                    }
                                                  }
                                                },
                                                onFieldSubmitted: (newValue) {
                                                  /*   maxAge.text.isNotEmpty &&
                                                          minAge.text.isNotEmpty */

                                                  if (maxAge.text.isNotEmpty) {
                                                    int? age = int.tryParse(
                                                        maxAge.text);
                                                    int? age2 = int.tryParse(
                                                        minAge.text);
                                                    if (age! <= age2!) {
                                                      // Clear the text field if the entered number is not above 18
                                                      /* WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        ageGroup.clear();
                                                        
                                                      }); */
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomDialog(
                                                              isFisrt: false,
                                                              onClose: () {
                                                                Navigator.pop(
                                                                    context);
                                                                minAge.clear();
                                                                maxAge.clear();
                                                              },
                                                              title:
                                                                  "Invalid Age Group",
                                                              subtitle:
                                                                  "Max age should be greater than Min age");
                                                        },
                                                      );
                                                    } else if (age > 55) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomDialog(
                                                              isFisrt: false,
                                                              onClose: () {
                                                                Navigator.pop(
                                                                    context);
                                                                minAge.clear();
                                                                maxAge.clear();
                                                              },
                                                              title:
                                                                  "Invalid Age Group",
                                                              subtitle:
                                                                  "Max age should not be greater than 55 years");
                                                        },
                                                      );
                                                    } else {
                                                      setState(() {
                                                        agegroupContainer =
                                                            !agegroupContainer;
                                                      });
                                                    }
                                                  }
                                                },
                                                /* {
                                                  maxAge.text.isNotEmpty &&
                                                          minAge.text.isNotEmpty
                                                      ? setState(() {
                                                          agegroupContainer =
                                                              newValue
                                                                  .isNotEmpty;
                                                        })
                                                      : showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return CustomDialog(
                                                                onClose: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                title: "Error!",
                                                                subtitle:
                                                                    "You have to fill min age as well");
                                                          },
                                                        );
                                                  checkAge();
                                                  if (newValue.isNotEmpty) {
                                                    int? age =
                                                        int.tryParse(newValue);
                                                    if (age! <= 18) {
                                                      // Clear the text field if the entered number is not above 18
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        ageGroup.clear();
                                                      });
                                                    }
                                                  }
                                                }, */
                                                onTapOutside: (event) {
                                                  /*   maxAge.text.isNotEmpty &&
                                                          minAge.text.isNotEmpty */

                                                  if (maxAge.text.isNotEmpty) {
                                                    int? age = int.tryParse(
                                                        maxAge.text);
                                                    int? age2 = int.tryParse(
                                                        minAge.text);
                                                    if (age! <= age2!) {
                                                      // Clear the text field if the entered number is not above 18
                                                      /* WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        ageGroup.clear();
                                                        
                                                      }); */
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomDialog(
                                                              isFisrt: false,
                                                              onClose: () {
                                                                Navigator.pop(
                                                                    context);
                                                                minAge.clear();
                                                                maxAge.clear();
                                                              },
                                                              title:
                                                                  "Invalid Age Group",
                                                              subtitle:
                                                                  "Max age should be greater than Min age");
                                                        },
                                                      );
                                                    } else if (age > 55) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomDialog(
                                                              isFisrt: false,
                                                              onClose: () {
                                                                Navigator.pop(
                                                                    context);
                                                                minAge.clear();
                                                                maxAge.clear();
                                                              },
                                                              title:
                                                                  "Invalid Age Group",
                                                              subtitle:
                                                                  "Max age should not be greater than 55 years");
                                                        },
                                                      );
                                                    } else {
                                                      setState(() {
                                                        agegroupContainer =
                                                            !agegroupContainer;
                                                      });
                                                    }
                                                  }
                                                },
                                                /* onEditingComplete: () {
                                                  maxAge.text.isNotEmpty &&
                                                          minAge.text.isNotEmpty
                                                      ? setState(() {
                                                          agegroupContainer =
                                                              !agegroupContainer;
                                                        })
                                                      : showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return CustomDialog(
                                                                onClose: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                title: "Error!",
                                                                subtitle:
                                                                    "You have to fill min age as well");
                                                          },
                                                        );
                                                }, */
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: maxAge,
                                                //   enabled: enableShortListFor,
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
                                                    counterText: "",
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            bottom: 15,
                                                            left: 10,
                                                            right: 10),
                                                    // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                                    // Icons.workspace_premium
                                                    // label: const Text("Company Name *"),
                                                    //border: OutlineInputBorder(),
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
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      122,
                                                                      113,
                                                                      111)),
                                                    ),
                                                    hintText: "Max-age",
                                                    hintStyle: GoogleFonts
                                                        .sourceSansPro(
                                                            color: Constants
                                                                .subtitleclr,
                                                            fontSize: 15.sp)
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
                              "Yrs",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 16.sp,
                                  // color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                  Text(
                    "Communication Rating",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isCommunicationVisible ? 5 : 0,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion5.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: true,
                          ismulti:
                              false, // Set ismulti to false for single select
                          title: jobTitleSuggestion5[index],
                          isSelected: isCommunication[index],
                          onTap: () {
                            setState(() {
                              // Clear all previous selections
                              for (int i = 0; i < isCommunication.length; i++) {
                                isCommunication[i] = false;
                              }
                              // Select the tapped item
                              isCommunication[index] = true;

                              // Update selectedJobTitles

                              selectedComunication = jobTitleSuggestion5[index];
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isCommunicationVisible ? 5 : 5,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion5.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: true,
                          ismulti: false,
                          title: jobTitleSuggestion5[index],
                          isSelected: isCommunication[index],
                          onTap: () {
                            setState(() {
                              // Clear all previous selections
                              for (int i = 0; i < isCommunication.length; i++) {
                                isCommunication[i] = false;
                              }
                              // Select the tapped item
                              isCommunication[index] = true;
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ), */
                  Row(
                    children: [
                      Text(
                        "Eligibility",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  (Optional)",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp, fontStyle: FontStyle.italic
                            // color: Colors.grey.shade500,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  /*  ListView.builder(      //Old check box code for Eligibility
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _eligibilityList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _eligibilityList[index].isChecked,
                            onChanged: (value) {
                              _toggleCheckbox2(index, value!);
                            },
                          ),
                          Text(_eligibilityList[index].text),
                        ],
                      );
                    },
                  ), */
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _eligibilityList.length,
                    itemBuilder: (context, index) {
                      final checkitem = _eligibilityList[index];
                      final isChecked = checkitem.isChecked;
                      final item = checkitem.text;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              height: 16,
                              width:
                                  20, // Adjust the width according to your requirements
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _eligibilityList[index].isChecked =
                                        !_eligibilityList[index].isChecked;
                                    if (isChecked) {
                                      selectedEligibility.remove(item);
                                    } else {
                                      selectedEligibility.add(item);
                                    }
                                  });
                                },
                                child: Container(
                                  // margin: const EdgeInsets.only(bottom: 4),
                                  height: 16,
                                  width: 20,
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _eligibilityList[index].isChecked
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.transparent,
                                    ),
                                    child: Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.white,
                                      checkColor: Colors.red,
                                      value: _eligibilityList[index].isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _toggleCheckbox2(index, value!);
                                          if (value) {
                                            selectedEligibility.add(item);
                                          } else {
                                            selectedEligibility.remove(item);
                                          }
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      side: _eligibilityList[index].isChecked
                                          ? const BorderSide(color: Colors.red)
                                          : null, // No border when unchecked

                                      // Remove extra padding around the checkbox
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Text(_eligibilityList[index].text),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                item,
                                softWrap:
                                    true, // Allow text to wrap into the next line
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    height: height / 25,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'^\s')), // Disallow spaces at the beginning
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      onEditingComplete: () {
                        _handleEligibilitySubmitted(Eligibility.text);
                      },
                      controller: Eligibility,
                      //  textInputAction: TextInputAction.newline,
                      // keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      // maxLines: null,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          prefix: Column(
                            children: _getBulletPointWidgetsEligi(),
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 24.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffff0eceb)),
                          ),
                          focusColor: const Color(0xffff0eceb),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 122, 113, 111)),
                          ),
                          hintText: "Banking sales experience ",
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr, fontSize: 15.sp)
                          //  prefixIcon: Icon(Icons.list)
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        "More Details",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  (Optional)",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp, fontStyle: FontStyle.italic
                            // color: Colors.grey.shade500,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  /* ListView.builder(        //old check box for more detail
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _moreDetailsList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _moreDetailsList[index].isChecked,
                            onChanged: (value) {
                              _toggleCheckbox(index, value!);
                            },
                          ),
                          Text(_moreDetailsList[index].text),
                        ],
                      );
                    },
                  ), */
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _moreDetailsList.length,
                    itemBuilder: (context, index) {
                      final checkitem = _moreDetailsList[index];
                      final isChecked = checkitem.isChecked;
                      final item = checkitem.text;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              height: 16,
                              width:
                                  20, // Adjust the width according to your requirements
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _moreDetailsList[index].isChecked =
                                        !_moreDetailsList[index].isChecked;
                                    if (isChecked) {
                                      selectedMoreDetail.remove(item);
                                    } else {
                                      selectedMoreDetail.add(item);
                                    }
                                  });
                                },
                                child: Container(
                                  // margin: const EdgeInsets.only(bottom: 4),
                                  height: 16,
                                  width: 20,
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _moreDetailsList[index].isChecked
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.transparent,
                                    ),
                                    child: Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.white,
                                      checkColor: Colors.red,
                                      value: _moreDetailsList[index].isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _toggleCheckbox(index, value!);
                                          if (value) {
                                            selectedMoreDetail.add(item);
                                          } else {
                                            selectedMoreDetail.remove(item);
                                          }
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      side: _moreDetailsList[index].isChecked
                                          ? const BorderSide(color: Colors.red)
                                          : null, // No border when unchecked

                                      // Remove extra padding around the checkbox
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Text(_moreDetailsList[index].text),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                item,
                                softWrap:
                                    true, // Allow text to wrap into the next line
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

                  Container(
                    height: height / 25,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'^\s')), // Disallow spaces at the beginning
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      // textInputAction: TextInputAction.newline,
                      onEditingComplete: () {
                        _handleMoreDetailSubmitted(moreDetail.text);
                      },

                      // onFieldSubmitted: (_) => _handleTextSubmitted(),
                      controller: moreDetail,
                      //  textInputAction: TextInputAction.newline,
                      // keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      // maxLines: null,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          prefix: Column(
                            children: _getBulletPointWidgets(),
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          // Icons.workspace_premium
                          // label: const Text("Company Name *"),
                          //border: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffff0eceb)),
                          ),
                          focusColor: const Color(0xffff0eceb),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 122, 113, 111)),
                          ),
                          hintText: "Optional...",
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr, fontSize: 15.sp)
                          //  prefixIcon: Icon(Icons.list)
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  /*  newFormFiled(shorListController, context, "More Details",
                      "Optional", false, false), */
                  /*  newFormFiled(shorListController, context, "Interview Rounds",
                      "Graduate", false, false, false) */
                  Text(
                    "Interview Rounds",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  /* Container(  old one
                    margin: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(jobTitleSuggestion4.length, (index) {
                        return JobTitleItem(
                          onlyOneIcon: false,
                          ismulti: false,
                          title: jobTitleSuggestion4[index],
                          isSelected: isInterview[index],
                          onTap: () {
                            setState(() {
                              isInterview[index] = !isInterview[index];
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ), */
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        jobTitleSuggestion4.length,
                        (index) {
                          JobTitleItem item = JobTitleItem(
                            ismulti: false,
                            title: jobTitleSuggestion4[index],
                            isSelected: isInterview[index],
                            onTap: () {
                              setState(() {
                                isInterview[index] = !isInterview[index];
                                JobTitleItem currentItem =
                                    jobTitleItems2[index];
                                if (isInterview[index]) {
                                  selectedInterViewRounds
                                      .add(currentItem.title);
                                } else {
                                  selectedInterViewRounds
                                      .remove(currentItem.title);
                                }
                              });
                            },
                            isVisible: true,
                            onlyOneIcon: false,
                            getJobTitle1isSelected: null,
                          );

                          jobTitleItems2.add(item);
                          return item;
                        },
                      ),
                    ),
                  ),

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
      ),
    );
  }

  void checkAge() {
    int age = int.tryParse(minAge.text) ?? 0;
    int checkAge = int.tryParse(maxAge.text) ?? 0;

    if (age < 18) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Entry Restricted'),
          content: const Text('Candidate above age of 18 years can Eligible.'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                minAge.clear();
              },
            ),
          ],
        ),
      );
    } else if (checkAge < age) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Entry Restricted'),
          content: const Text('Max age should be more than minimum age.'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                maxAge.clear();
              },
            ),
          ],
        ),
      );
    } else if (checkAge > 60) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Entry Restricted'),
          content: const Text('Eligible candidate should be below 60 years.'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                maxAge.clear();
              },
            ),
          ],
        ),
      );
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
      bool isCross = false,
      bool? isSalary = false}) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: isAnother
                ? null
                : isNumberOfOpenings
                    ? MediaQuery.of(context).size.width / 5
                    : isAnother
                        ? double.infinity
                        : MediaQuery.of(context).size.width / 2.2,

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 8),
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

  Container newFormFiled(
      {required TextEditingController controller,
      required BuildContext context,
      String? title,
      required String subTitle,
      required bool isNum,
      required bool isVisible,
      required bool nonEdit,
      required bool sioptonal}) {
    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title!.isNotEmpty)
              sioptonal
                  ? Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 18.sp,
                              // color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "  (Optional)",
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp,
                            // color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      title,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          // color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600),
                    ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 25.h,
              color: Colors.white,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This Text field Cant be empty";
                  }
                  return null;
                },
                enableSuggestions: true,

                keyboardType: isNum ? TextInputType.number : TextInputType.name,
                controller: controller,
                // enabled: nonEdit ? minSalary.text.isNotEmpty : true,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[.]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                onFieldSubmitted: (value) {
                  _checkLength(true);
                },
                onChanged: (value) {
                  setState(() {
                    //  _checkLength(true);
                    // Update the second text field when the first text field changes

                    if (value.length <= 3) {
                      maxSalary.clear();
                    }
                  });
                },
                //onEditingComplete: _checkLength,
                /*  onTapOutside: (event) {
                  _checkLength();
                }, */
                focusNode: minSalaryFocusNode,
                maxLength: 7,

                onTap: (() {
                  /* TypeAheadFormField<String>(
                    textFieldConfiguration: const TextFieldConfiguration(
                      decoration: InputDecoration(
                        hintText: 'Enter a suggestion...',
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      // Perform your suggestion logic here
                      // Return a list of suggestions based on the provided pattern
                      return await getSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      // Do something with the selected suggestion
                      Navigator.of(context).pop(suggestion);
                    },
                  ); */

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
                    counterText: '',
                    contentPadding: const EdgeInsets.only(
                        top: 8, bottom: 15, left: 10, right: 10),
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
                        color: Constants.subtitleclr, fontSize: 15.sp)
                    //  prefixIcon: Icon(Icons.list)
                    ),
              ),
            ),
          ],
        ));
  }

  void _checkLength(bool isMin) {
    final String text = minSalary.text.trim();
    if (text.length < 4) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              isFisrt: false,
              onClose: () {
                Navigator.of(context).pop();
                isMin
                    ? minSalaryFocusNode.requestFocus()
                    : maxSalaryFocusNode.requestFocus();
              },
              title: "Error!",
              subtitle: "Minimum 4 digit required for salary");
        },
      );
    }
  }

  Container newFormFiled1(
      {required TextEditingController controller,
      required BuildContext context,
      String? title,
      required String subTitle,
      required bool isNum,
      required bool isVisible,
      required bool nonEdit,
      required bool sioptonal}) {
    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title!.isNotEmpty)
              sioptonal
                  ? Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 18.sp,
                              // color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "  (Optional)",
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 15.sp,
                            // color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      title,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          // color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600),
                    ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 25.h,
              color: Colors.white,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This Text field Cant be empty";
                  }
                  return null;
                },
                focusNode: maxSalaryFocusNode,
                //   enableSuggestions: true,
                //   onEditingComplete: _checkLength,
                onChanged: (value) {
                  if (minSalary.text.length <= 3) {
                    maxSalary.clear();
                  }
                },

                onFieldSubmitted: (value) {
                  _checkLength(false);

                  if (maxSalary.text.isNotEmpty) {
                    final int minSalary1 = int.tryParse(minSalary.text) ?? 0;
                    final int maxSalary2 = int.tryParse(maxSalary.text) ?? 0;

                    if (maxSalary2 <= minSalary1) {
                      // Value of the second text field is not greater than the first text field
                      setState(() {
                        isValueValid = false;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              isFisrt: false,
                              onClose: () {
                                Navigator.pop(context);
                                maxSalaryFocusNode.requestFocus();
                                maxSalary.clear();
                              },
                              title: "Invalid Data!",
                              subtitle:
                                  "Maximum salary should be more thn minimum salary.",
                            );
                          },
                        );
                      });
                    } else if (_selectedOption.isNotEmpty) {
                      String formatValue(int value, bool ismax) {
                        if (value >= 100000) {
                          double formattedValue = value / 100000;
                          return ismax
                              ? NumberFormat("0.00' Lacs'")
                                  .format(formattedValue)
                              : NumberFormat("0.00' '").format(formattedValue);
                        } else {
                          return value.toString();
                        }
                      }

                      setState(() {
                        isValueValid = true;
                        if (minSalary1 <= 100000) {
                          minSalaryk = NumberFormat.compact()
                              .format(double.tryParse(minSalary.text));
                        } else {
                          minSalaryk = formatValue(minSalary1, false);
                        }

                        if (maxSalary2 <= 100000) {
                          maxSalaryk = NumberFormat.compact()
                              .format(double.tryParse(maxSalary.text));
                        } else {
                          maxSalaryk = formatValue(maxSalary2, true);
                        }

                        /*  maxSalaryk = NumberFormat.compact()
                            .format(double.tryParse(maxSalary.text)); */
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                              maxSalaryFocusNode.requestFocus();
                              // maxSalary.clear();
                            },
                            title: "Invalid Data!",
                            subtitle:
                                "Please select any option from salary type.",
                          );
                        },
                      );
                    }
                  }
                },
                /*  onTapOutside: (event) {
                  if (maxSalary.text.isNotEmpty) {
                    final int minSalary1 = int.tryParse(minSalary.text) ?? 0;
                    final int maxSalary2 = int.tryParse(maxSalary.text) ?? 0;
                    if (maxSalary2 <= minSalary1) {
                      // Value of the second text field is not greater than the first text field
                      setState(() {
                        isValueValid = false;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              onClose: () {
                                Navigator.pop(context);
                                salryFocusNode.requestFocus();
                                maxSalary.clear();
                              },
                              title: "Invalid Data!",
                              subtitle:
                                  "Maximum salary should be more thn minimum salary.",
                            );
                          },
                        );
                      });
                    } else {
                      setState(() {
                        isValueValid = true;
                      });
                    }
                  }
                }, */
                keyboardType: isNum ? TextInputType.number : TextInputType.name,
                controller: controller,
                enabled: nonEdit,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[.]')),
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 7,

                //   onTap: (() {
                /* TypeAheadFormField<String>(
                    textFieldConfiguration: const TextFieldConfiguration(
                      decoration: InputDecoration(
                        hintText: 'Enter a suggestion...',
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      // Perform your suggestion logic here
                      // Return a list of suggestions based on the provided pattern
                      return await getSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      // Do something with the selected suggestion
                      Navigator.of(context).pop(suggestion);
                    },
                  ); */

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
                //   }),
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.only(
                        top: 8, bottom: 15, left: 10, right: 10),
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
                        color: Constants.subtitleclr, fontSize: 15.sp)
                    //  prefixIcon: Icon(Icons.list)
                    ),
              ),
            ),
          ],
        ));
  }
}
