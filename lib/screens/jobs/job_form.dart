////

// ignore_for_file: duplicate_import

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/autolistviewmodal.dart';
import 'package:job_circle/constants/customSelection.dart';
import 'package:job_circle/constants/customTextfield.dart';
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
  TextEditingController location = TextEditingController();
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
  //TextEditingController boundryLimits = TextEditingController();
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

  @override
  void dispose() {
    minExp.dispose();
    maxExp.dispose();
    super.dispose();
  }

  bool _showContainer1 = true;
  bool _showContainer2 = true;

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

  @override
  void initState() {
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
    getJobTitle2("pattern", "language").then((_) {});
    getJobTitle3("pattern", "language").then((_) {});

    // getJobTitle("Admin");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    // TODO: implement initState
    moreDetail.addListener(_handleTextChange);
    Eligibility.addListener(_handleTextChangeEligi);
    boundryLimits.addListener(_handleTextChangebond);
    responsibility.addListener(_handleTextChangerespo);
    //  fetchData();
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
          style: TextStyle(fontSize: 16, color: Colors.black),
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

  bool isEdit1 = false;
  bool isEdit2 = false;
  bool isEdit3 = false;
  bool isEdit4 = false;
  bool isEdit5 = false;
  bool isEdit6 = false;
  bool isEdit7 = false;
  bool isEdit8 = false;

  bool isJobTitle = false;
  List<dynamic> suggestions = [];
  List<dynamic> jobTitleSuggestion = [];
  List<dynamic> jobTitleSuggestion1 = [];
  List<dynamic> jobTitleSuggestion3 = [];
  List<dynamic> jobTitleSuggestion4 = [];
  bool isNotFound = false;
  List<dynamic> jobTitleSuggestion2 = [];

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/company/v1/all?pageNumber=1&pageSize=100'));

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
        'http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

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
  }

  Future<List> getJobTitle1(String pattern, String? name) async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/master/v1/getByGroup?groupName=job_benifits&pageNumber=1&pageSize=100'));

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
  }

  Future<List> getJobTitle2(String pattern, String? name) async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/master/v1/getByGroup?groupName=shifttime&pageNumber=1&pageSize=100'));

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
  }

  Future<List> getJobTitle3(String pattern, String? name) async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/master/v1/getByGroup?groupName=shiftdesc&pageNumber=1&pageSize=100'));

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
  }

  Future<List> getJobTitle4(String pattern, String? name) async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/master/v1/getByGroup?groupName=interview_rounds&pageNumber=1&pageSize=100'));

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
  }
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

  List<String> selectedValuesList = [];

  /* void handleFocusNodeRequest() {
    setState(() {
      FocusScope.of(context).requestFocus(focusNode); // Request focus on the focusNode
    });
  } */

  List<bool> isSelected = [];
  List<bool> isJobBenefits = [];
  List<bool> isInterview = [];
  int selectedShiftTime = -1;
  int selectedWeakOff = -1;

  bool isOptionVisible = true;
  bool isWeakOfVisible = true;

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

  //isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
    if (jobTitleSuggestion.isEmpty) {
      // Display a loading indicator or alternative content while fetching data
      return const Center(child: CircularProgressIndicator());
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
        child: GestureDetector(
          onTap: () {
            if (shorListController.text.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            }
            setState(() {
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
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomJobFormTextField(
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
                    hintText: "Aditya birla Health Insurance",
                    getSuggestions: getSuggestions,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width / 2.2,
                        child: CustomJobFormTextField(
                          isCompany: false,
                          name: "job_role",
                          /* onFocusNodeRequested: (p0) {
                            focusNode.requestFocus();
                          }, */
                          title: "Job title",
                          controller: role,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          onChanged: (p0) {
                            isEdit1 = p0;
                          },
                          contextIn: context,
                          hintText: "Sr. Executive",
                          //  getSuggestions: getJobTitle,
                        ),
                      ),
                      SizedBox(
                        width: width / 2.2,
                        child: CustomJobFormTextField(
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
                          //   getSuggestions: getJobTitle,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width / 2.2,
                        child: CustomJobFormTextField(
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
                          },
                          contextIn: context,
                          hintText: "Sales",
                          // getSuggestions: getJobTitle,
                        ),
                      ),
                      SizedBox(
                        width: width / 2.2,
                        child: CustomJobFormTextField(
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
                      ? customContainerSelect(() {
                          setState(() {
                            isNumberOfOpenings = false;
                            FocusScope.of(context).autofocus(focusNode);
                            numberofopenings.clear();
                          });
                        }, true, numberofopenings.text)
                      : Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[.]')), // Disallow dots
                                  ],
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select any company';
                                    }
                                    return null;
                                  },
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
                        }, isFullTime, "Full Time"),
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
                        fontSize: 18.sp,
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
                  CustomFormTextFieldMultiSelect(
                    // isCompany: false,
                    name: "skills",
                    /* onFocusNodeRequested: (p0) {
                      focusNode.requestFocus();
                    }, */
                    title: "Skills Required",
                    controller: skills,
                    selectedValuesList: selectedValuesList,
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
                  Text(
                    "Job Responsibility",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  CheckboxListTile(
                    title: const Text("Data"),
                    value: true,
                    onChanged: (value) {},
                  ),

                  Container(
                    height: height / 25,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      // textInputAction: TextInputAction.newline,

                      // onFieldSubmitted: (_) => _handleTextSubmitted(),
                      controller: responsibility,
                      //  textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      decoration: InputDecoration(
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
                            borderSide:
                                const BorderSide(color: Color(0xffff0eceb)),
                          ),
                          focusColor: const Color(0xffff0eceb),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 122, 113, 111)),
                          ),
                          hintText:
                              "Any other responsibility that you want to add",
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr, fontSize: 14.sp)
                          //  prefixIcon: Icon(Icons.list)
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Language Required (Optional)",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(jobTitleSuggestion.length, (index) {
                        return JobTitleItem(
                          ismulti: false,
                          title: jobTitleSuggestion[index],
                          isSelected: isSelected[index],
                          onTap: () {
                            setState(() {
                              isSelected[index] = !isSelected[index];
                            });
                          },
                          isVisible: true,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ),
                  Text(
                    "Job Benefits (Optional)",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(jobTitleSuggestion1.length, (index) {
                        return JobTitleItem(
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
                    margin: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: isOptionVisible ? 8 : 0,
                      runSpacing: 8,
                      children:
                          List.generate(jobTitleSuggestion2.length, (index) {
                        return JobTitleItem(
                          ismulti: true,
                          title: jobTitleSuggestion2[index],
                          isSelected: selectedShiftTime == index,
                          onTap: () {
                            setState(() {
                              if (selectedShiftTime == index) {
                                clearSelectedShiftTime();
                              } else {
                                selectShiftTime(index);
                              }
                            });
                          },
                          isVisible:
                              isOptionVisible || selectedShiftTime == index,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ),
                  Text(
                    "Weak Off",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: isWeakOfVisible ? 8 : 0,
                      runSpacing: 8,
                      children:
                          List.generate(jobTitleSuggestion3.length, (index) {
                        return JobTitleItem(
                          ismulti: true,
                          title: jobTitleSuggestion3[index],
                          isSelected: selectedWeakOff == index,
                          onTap: () {
                            setState(() {
                              if (selectedWeakOff == index) {
                                clearWeakOff();
                              } else {
                                selectWeakOff(index);
                              }
                            });
                          },
                          isVisible:
                              isWeakOfVisible || selectedWeakOff == index,
                          getJobTitle1isSelected: null,
                        );
                      }),
                    ),
                  ),
                  Text(
                    "Salary",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
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
                            "Min-salary", true, false, false),
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
                            "Max-salary", true, false, false),
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
                  CustomJobFormTextField(
                    isCompany: false,
                    name: "location",
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
                    contextIn: context,
                    hintText: "Thane",
                    //   getSuggestions: getJobTitle,
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
                          fontSize: 15.sp,
                          // color: Colors.grey.shade500,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      // textInputAction: TextInputAction.newline,

                      // onFieldSubmitted: (_) => _handleTextSubmitted(),
                      controller: boundryLimits,
                      //  textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 10, right: 10),
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
                          fontSize: 15.sp,
                          // color: Colors.grey.shade500,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  TextField(
                    controller: Eligibility,
                    //  textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        prefix: Column(
                          children: _getBulletPointWidgetsEligi(),
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
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
                  const SizedBox(
                    height: 5,
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
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
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
                                                      22.h,
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
                                const Text("-"),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 6.w,
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
                                                  margin: const EdgeInsets.only(
                                                      bottom: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            22.h,
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
                                                            maxExp.text
                                                                    .isNotEmpty
                                                                ? setState(() {
                                                                    expContainer =
                                                                        newValue
                                                                            .isNotEmpty;
                                                                  })
                                                                : null;
                                                          },
                                                          onTapOutside:
                                                              (event) {
                                                            maxExp.text
                                                                    .isNotEmpty
                                                                ? setState(() {
                                                                    expContainer =
                                                                        !expContainer;
                                                                  })
                                                                : null;
                                                          },
                                                          onEditingComplete:
                                                              () {
                                                            maxExp.text
                                                                    .isNotEmpty
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
                                                                          top:
                                                                              8,
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
                                                                            .circular(8),
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
                                                                            .circular(8),
                                                                    borderSide: const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            122,
                                                                            113,
                                                                            111)),
                                                                  ),
                                                                  hintText:
                                                                      "Max-exp",
                                                                  hintStyle: GoogleFonts.sourceSansPro(
                                                                      color: Constants
                                                                          .subtitleclr,
                                                                      fontSize:
                                                                          15.sp)
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
                                      fontSize: 16.sp,
                                      // color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w400),
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
                          fontSize: 15.sp,
                          // color: Colors.grey.shade500,
                        ),
                      )
                    ],
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
                          fontSize: 15.sp,
                          // color: Colors.grey.shade500,
                        ),
                      )
                    ],
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
                                                  22.h,
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
                                                  22.h,
                                              color: Colors.white,
                                              child: TextField(
                                                onSubmitted: (newValue) {
                                                  maxAge.text.isNotEmpty
                                                      ? setState(() {
                                                          agegroupContainer =
                                                              newValue
                                                                  .isNotEmpty;
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
                              "Years",
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
                          fontSize: 15.sp,
                          // color: Colors.grey.shade500,
                        ),
                      )
                    ],
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

                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextField(
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
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(jobTitleSuggestion4.length, (index) {
                        return JobTitleItem(
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

  Widget customSuggestionField(BuildContext context) {
    List? suggestion;
    return SizedBox(
      child: isEdit1
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Company Name",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                customContainerSelect(() {
                  setState(() {
                    FocusScope.of(context).requestFocus(_focusNode);
                    // isFocus = true;
                    isEdit1 = false;
                    shorListController.clear();
                    focusNode.requestFocus();
                  });
                }, true, shorListController.text),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Company Name",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 26.h,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //  border: Border.all(color: Colors.grey),
                  ),
                  child: TypeAheadFormField<dynamic>(
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(

                        //shape: ShapeBorder.lerp(),
                        borderRadius: BorderRadius.circular(15),
                        elevation: 4.0),
                    textFieldConfiguration: TextFieldConfiguration(
                      onChanged: (value) {
                        suggestion = null;
                      },
                      autofocus: true,
                      focusNode: focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: shorListController,
                      decoration: InputDecoration(
                          hintText: "Aditya Birla Health Insurance",
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr, fontSize: 14.sp),
                          // labelText: 'Enter a suggestion',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 122, 113, 111)),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffff0eceb)),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.only(left: 15)),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        suggestion = (await getSuggestions(pattern));
                        suggestion ??= [];
                        return suggestion!;
                      } else {
                        return <
                            dynamic>[]; // Return an empty list when the pattern is empty
                      }
                    },
                    itemBuilder: (context, suggestion) {
                      final index = suggestions.indexOf(suggestion);
                      final isOdd = index % 2 == 0;

                      final backgroundColor =
                          isOdd ? Colors.grey.shade200 : Colors.white;
                      return Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(color: Colors.grey),
                        ),
                        child: ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        shorListController.text = suggestion.toString();
                        firstText = shorListController.text;

                        isEdit1 = true;
                      });
                    },
                    noItemsFoundBuilder: (value) {
                      String message;
                      if (suggestion != null && suggestion!.isEmpty) {
                        message = 'No items found';
                      } else {
                        message = 'searching';
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget customSuggestionFieldJobTitle(BuildContext context) {
    return SizedBox(
      child: isJobTitle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Job Title",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                customContainerSelect(() {
                  setState(() {
                    FocusScope.of(context).requestFocus(_focusNode);
                    //isFocus = true;
                    isJobTitle = false;
                    role.clear();
                  });
                }, true, role.text),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Job Title",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      // color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 26.h,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TypeAheadFormField<dynamic>(
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(

                        //shape: ShapeBorder.lerp(),
                        borderRadius: BorderRadius.circular(15),
                        elevation: 4.0),
                    textFieldConfiguration: TextFieldConfiguration(
                      //autofocus: isFocus,
                      // focusNode: _focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: role,
                      decoration: InputDecoration(
                          hintText: "Sr. Executive",
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.subtitleclr, fontSize: 14.sp),
                          // labelText: 'Enter a suggestion',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 122, 113, 111)),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffff0eceb)),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.only(left: 15)),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        // await Future.delayed(const Duration(seconds: 1));
                        return await getJobTitle(pattern, "job_role");
                      } else {
                        return <
                            dynamic>[]; // Return an empty list when the pattern is empty
                      }
                    },
                    itemBuilder: (context, suggestion) {
                      final index = jobTitleSuggestion.indexOf(suggestion);
                      final isOdd = index % 2 == 0;
                      final backgroundColor =
                          isOdd ? Colors.grey.shade200 : Colors.white;
                      return Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //color: backgroundColor,
                        child: ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        role.text = suggestion.toString();
                        isJobTitle = true;
                      });
                    },
                    // debounceDuration: const Duration(seconds: 2),
                  ),
                ),
              ],
            ),
    );
  }

  /*  List<String> suggestions = [
    'Apple',
    'Banana',
    'Cherry',
    'Durian',
    'Elderberry',
    'Fig'
  ]; */
  /* Future<List<String>> getSuggestions(String pattern) async {
    // Perform filtering based on the pattern
    return suggestions
        .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }
 */
  InkWell customContainerSelect(
      final VoidCallback onPressed, bool isSelect, String title) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelect ? const Color(0xfff310d44) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title,
                          style: GoogleFonts.sourceSansPro(
                              color: Colors.white, fontSize: 15.sp)),
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
                    style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
  }

  Container newFormFiled(
      TextEditingController controller,
      BuildContext context,
      String? title,
      String subTitle,
      bool isNum,
      bool isVisible,
      bool sioptonal) {
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
              height: MediaQuery.of(context).size.height / 18.h,
              color: Colors.white,
              child: TextFormField(
                enableSuggestions: true,
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
