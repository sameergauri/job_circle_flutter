////

// ignore_for_file: duplicate_import

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:job_circle/models/commercial_model.dart';
import 'package:job_circle/models/matching_job_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/new_jobs/new_jobs.dart';
import 'package:job_circle/screens/partnerhome.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/company.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/customDialogue.dart';
import '../../models/interview_rounds_model.dart';
import '../../models/job_post_model.dart';
import '../../models/more__details.dart';
import '../../service/job_post_api_service.dart';

class JobForm extends ConsumerStatefulWidget {
  final bool formEdit;
  final String? companyId, natureOfWork, process, jobTitle, companyName;
  const JobForm(
      {super.key,
      required this.formEdit,
      this.companyId,
      this.natureOfWork,
      this.jobTitle,
      this.companyName,
      this.process});

  @override
  ConsumerState<JobForm> createState() => _JobFormState();
}

class _JobFormState extends ConsumerState<JobForm> {
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
 GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  AutoCompleteModel selectedshort = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedLevel = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedStatus = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedProcess = AutoCompleteModel("", "", {});
  late List<AutoCompleteModel> shortList = [];
  late List<AutoCompleteModel> proccessList = [];
  late List<AutoCompleteModel> levelList = [];
  late List<AutoCompleteModel> statusList = [];
  late List<AutoCompleteModel> interviewList = [];
  FocusNode responsibilityFocus = FocusNode();
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

  /*  @override
  void dispose() {
    minExp.dispose();
    maxExp.dispose();
    super.dispose();
  }
 */
  bool isRelevantExpperience = false;
  bool isGraduateCheckBox = false;
  bool above = false;
  bool compusHiring = false;

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
      temporary = false,
      onlyMale = false,
      onlyFemale = false,
      femalePrefered = false,
      excelent = false,
      veryGood = false,
      decent = false,
      graduate = false,
      undeGraduate = false,
      EnteryLevel = false,
      supportstaff = false;

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

  int? commercialid;

  var user_id = "";
  ProfileSummaryModel profileSummaryModel = ProfileSummaryModel();
  ProfileSummaryModel profilemodel = ProfileSummaryModel();

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
              color: isSelect ? Colors.grey.shade500 : Colors.grey.shade200,
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
                          ? Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15.h,
                            ) /* Image.asset(
                              "assets/images/cross.png",
                              height: 12,
                            ) */
                          : const SizedBox()
                    ],
                  )
                : Text(text,
                    style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
  }

  List<String> fetchApiLanguages = [];
  List<String> fetchApiBenefits = [];
  List<String> fetchApiInterViewRounds = [];
  String? fetchApiGender;
  List<dynamic> fetchApiskill = [];
  List<Location> fetchApilocation = [];
  List<dynamic> fetchApiWoekLocation = [];
  List<dynamic> fetchApieligibility = [];
  List<dynamic> fetchApiMoreDEtail = [];
  List<dynamic> fetchApiBoundryLimit = [];
  bool? isIndustry = false;
  bool? isCity = false;
  int? jobID;
  List<dynamic> worklocationint = [];
  int? fetchworkCity;

  void assignDataToController(JobData? jobData) {
    if (jobData != null) {
      setState(() {
        if (jobData.active == 1 && widget.formEdit == false) {
          Navigator.pushNamedAndRemoveUntil(
              context,
              ERoute.jobsdetail.name,
              arguments: {'id': jobData.id},
              (Route<dynamic> route) => route.isFirst);
          /* Navigator.pushNamedAndRemoveUntil(
            context,
            ERoute.jobsdetail.name,
            arguments: {'id': jobData.id},
          ); */
        }

        if (jobData.active == 0) {
          commercialid = jobData.commercial_id;
        }
        isNumberOfOpenings = true;
        functionalAreaId = jobData.crpf_id;
        if (widget.formEdit == true) {
          CompanyID = widget.companyId;
        }

        jobID = jobData.id;
        numberofopenings.text = jobData.noOfVacancy.toString();
        industry.text = jobData.industry.toString();
        if (jobData.industry.isNotEmpty) {
          isIndustry = true;
        }
        minSalary.text = (jobData.minctc).truncate().toString();
        maxSalary.text = (jobData.maxctc).truncate().toString();
        minSalaryk = NumberFormat.compact()
            .format(double.tryParse(jobData.minctc.toString()));
        maxSalaryk = NumberFormat.compact()
            .format(double.tryParse(jobData.maxctc.toString()));
        isValueValid = true;
        if (jobData.isMonthly == 'Per Month') {
          _selectedOption = "Per Month";
        } else if (jobData.isMonthly == "Lac's P.A") {
          _selectedOption = "Lac's P.A";
        }
        if (jobData.empType == "Full Time") {
          isFullTime = true;
        } else if (jobData.empType == "Part Time") {
          isPartTime = true;
        } else if (jobData.empType == "Contractual") {
          isContract = true;
        } else if (jobData.empType == "InternShip") {
          isIntern = true;
        } else if (jobData.empType == "Temporary") {
          temporary = true;
        }
        if (jobData.education == "Graduate") {
          graduate = true;
        } else if (jobData.education == "Under-Graduate") {
          undeGraduate = true;
        }
        /* if (jobData.jobSkills != null) {
          selectedValues.add(jobData.jobSkills);
        } */
        if (jobData.isFresher == "Fresher") {
          isFresher = true;
        } else {
          //  isFresher = false;
          expContainer = true;
          _showContainer1 = false;
          _showContainer2 = false;

          minExp.text = jobData.minExperience;
          if (jobData.maxExperience == "& above") {
            above = true;
            // maxExp.text = jobData.maxExperience;
          } else {
            above = false;
            maxExp.text = jobData.maxExperience;
          }

          List<dynamic> loc = jobData.workLocation;

          print(loc);
        }
        isGraduateCheckBox = jobData.is_graduate == 1 ? true : false;
        fetchApiLanguages = jobData.languageKnown.cast<String>();
        fetchApiskill = jobData.skills;
        selectedLanguages = fetchApiLanguages;
        city.text = jobData.city.toString();
        worklocationint = jobData.workLocation;
        CityID = jobData.workCity.toString();
        if (city.text.isNotEmpty) {
          isCity = true;
        }

        // ignore: unnecessary_null_comparison
        if (jobData.isCampus != null) {
          jobData.isCampus == 1 ? compusHiring = true : compusHiring = false;
        }
        // ignore: unnecessary_null_comparison
        if (jobData.isSupportStaff != null) {
          jobData.isSupportStaff == 1
              ? supportstaff = true
              : EnteryLevel = true;
        }

        fetchApiBenefits = jobData.jobBenefits.cast<String>();
        selectedJobBenefits = fetchApiBenefits;
        selectedShiftTime1 = jobData.shiftTime;
        selectedWeakOff1 = jobData.shiftDesc;
        if (jobData.gender == "Male") {
          onlyMale = true;
        } else if (jobData.gender == "Female") {
          onlyFemale = true;
        } else if (jobData.gender == "âï¸ Female Prefered") {
          femalePrefered = true;
        } else if (jobData.gender == "Female prefered") {
          femalePrefered = true;
        }
        minAge.text = jobData.minAge.toString();
        maxAge.text = jobData.maxAge.toString();
        minAge.text.isNotEmpty
            ? agegroupContainer = true
            : agegroupContainer = false;

        selectedComunication = jobData.rating;
        selectedInterviewRoundsId = jobData.inteviewrounds.cast<int>();
        if (jobData.eligible.contains(
            "Candidate should be from relevant experience background.")) {
          isRelevantExpperience = true;
        } else if (jobData.eligible
            .contains("Candidate should be from relevant experience.")) {
          isRelevantExpperience = true;
        }
        selectedValuesList = jobData.skills;
        String allSkills = fetchApiskill.join(",");

        fetchData(allSkills).then((checkboxData) {
          setState(() {
            checkboxDataState = checkboxData; // Update the state variable
          });
        });
        //selectedKeyResponsible = jobData.keyResponsible;
        print(selectedKeyResponsible);
        fetchApilocation = jobData.location;
        if (fetchApilocation.isNotEmpty) {
          bool containsWFH = fetchApilocation
              .any((location) => location.value.contains("WFH"));
          bool containsHybrid = fetchApilocation
              .any((location) => location.value.contains("Hybrid"));
          if (containsWFH == true) {
            isEdit8 = true;
            workFromHome = "WFH";
            workLocation.text = "WFH";
          } else if (containsHybrid == true) {
            isEdit8 = true;
            workFromHome = "Hybrid";
            workLocation.text = "Hybrid";
          }
        }
        fetchApiWoekLocation = jobData.workLocation;

//boundry limit
        List<dynamic> boundaryLimits = jobData.boundry_limits;

        for (var item in boundaryLimits) {
          fetchApiBoundryLimit.add(item);
          selectedKeyBoundryLimits.add(item);
        } //boundry limit
//Eligiblity

        // _eligibilityList = [CheckItem(jobData.eligible, true)];

        List<dynamic> eligibility = jobData.eligible;

        for (var item in eligibility) {
          if (item ==
              "Candidate should be from relevant experience background.") {
          } else if (item == "Candidate should be from relevant experience.") {
          } else if (item ==
              "Excellent English written & verbal Communication skills required.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "A basic level of English proficiency is expected for communication in this job.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "Good English communication skills are required for effective interaction with customers.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "Candidates should be comfortable working in a 24/7 rotational shift.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "Proficiency in English, Hindi, and Any one Regional Language ${fetchApiLanguages.map((e) => e)} Required.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "Compulsory Proficiency in English, Hindi, and ${fetchApiLanguages.map((e) => e.replaceAll("()", ""))} (Regional Language).") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "Candidates should be flexible with Night / US shifts.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "All candidates are encouraged to apply, and we have a preference for female applicants as part of our diversity initiative.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item == "This role is exclusively for male candidates.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else if (item ==
              "This position is exclusively open to female candidates.") {
            // _eligibilityList.add(CheckItem(item.toString(), true));
          } else {
            fetchApieligibility.add(item);
            selectedKeyEligibility.add(item);
          }
        } //bou
        //Eligibility
        //more details

        List<dynamic> moreDetails = jobData.moredetails;

        for (var item in moreDetails) {
          fetchApiMoreDEtail.add(item);
          selectedKeyMoreDetails.add(item);
        }

        //more details
        List<dynamic> jobResponsible = jobData.key_responsible;

        for (var item in jobResponsible) {
          selectedKeyResponsible.add(item.toString());
        }
        worklocationList = jobData.location;
        //  fetchApiInterViewRounds = jobData.
      });
    } else {
      numberofopenings
          .clear(); // Clear the TextEditingController if data is null
    }
  }

  Future<void> fetchDataFromApi() async {
    JobData? jobData = await fetchMatchingJobs(
        companyId: int.parse(CompanyID!),
        process: proces.text,
        natureOfWork: natureOfWork.text,
        jobTitle: role.text); // Call the API function and await the result
    assignDataToController(
        jobData); // Assign the received data to the TextEditingController
  }

  List<String> preselectedLanguages = [];
  int? functionalAreaId;

  @override
  void initState() {
    /* _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchData();
    }); */
    /* if (checkboxDataState.isEmpty) {
      fetchData();
    } */
    // fetchData();
    if (widget.formEdit == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          // barrierColor: Colors.grey.shade100,

          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              getJobtitleValue: getValueOfJobtitle,
              getNatureOfWorkId: fetchData,
              onDataReceived: assignDataToController,
              // fetchDataFromApi: fetchDataFromApi,
              fetchDataFromApi: () {},
              getCompanyId: (value) {
                setState(() {
                  CompanyID = value;
                });
              },
              getCompanyName: (value) {
                setState(() {
                  shorListController = value; // Update the value in Class1
                });
              },

              getJobtitile: (value) {
                //
                setState(() {
                  role = value;
                });
              },
              getFunctionalAreaId: (value) {
                setState(() {
                  functionalAreaId = value;
                });
              },

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
    } else {
      setState(() {
        shorListController.text = widget.companyName.toString();
        role.text = widget.jobTitle.toString();
        proces.text = widget.process.toString();
        natureOfWork.text = widget.natureOfWork.toString();
      });
      fetchData(widget.natureOfWork.toString());
      fetchMatchingJobs(
          companyId: int.parse(widget.companyId.toString()),
          natureOfWork: widget.natureOfWork,
          jobTitle: widget.jobTitle,
          onDataReceived: assignDataToController,
          process: widget.process);
    }
    industryFocus.requestFocus();
    getJobTitle("pattern", "language").then((_) {
      isSelected = List<bool>.filled(jobTitleSuggestion.length, false);
      setState(() {});
    });
    getJobTitle1("pattern", "language").then((_) {
      isJobBenefits = List<bool>.filled(jobTitleSuggestion1.length, false);
      setState(() {});
    });
    getJobTitle4("pattern", "language").then((_) {
      isInterview = List<bool>.filled(interviewRoundsModel!.length, false);
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
    bindProfileSummary();
    // bindInterViewList();
  }

  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromJson(dataResult);
    }
    setState(() {});
  }

  String _selectedOption = "";
  bool isFresher = false;
  bool expContainer = false;
  bool agegroupContainer = false;
  bool enableExperience = false;
  List<int> preselectedIndices = [];

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
              fetchDataFromApi: () {},
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
              fetchDataFromApi: () {},
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
        selectedMoreDetail.add(value);
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
              fetchDataFromApi: () {},
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
              fetchDataFromApi: () {},
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
              fetchDataFromApi: () {},
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
              fetchDataFromApi: () {},
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
  List<dynamic> interviewRoundsId = [];
  bool isNotFound = false;
  List<dynamic> jobTitleSuggestion2 = [];
  List<dynamic> jobTitleSuggestion5 = [];
  List<String> checkboxData = [];
  List<dynamic> natureofWorkID = [];
  List<String> checkboxDataState = [];
  List<dynamic> selectedKeyResponsible = [];
  List<String> selectedKeyEligibility = [];
  List<String> selectedKeyMoreDetails = [];
  List<String> selectedKeyBoundryLimits = [];

  List<String> selectedTextResponsible = [];
  String? jobTitle;
  String? Nowid;
  int? NatureOfWorkID;
  String? CompanyID;
  String? CityID = "0";
  List<Location> worklocationList = [];

  bool showAllItems = false;

  int visibleItemCount = 5;

  final ScrollController _scrollController = ScrollController();

  void getWorkLocation(List<String> data) {
    // Store the received data in the list
    setState(() {
      List<Location> customLocation = data
          .map((location) => Location(id: int.parse(location), value: ""))
          .toList();
      worklocationList = customLocation;
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

  Future<List<String>> fetchData(String skills) async {
    String combineSkills = '';
    if (skills == "") {
      setState(() {
        combineSkills = "xyzzzzzzz";
      });
    } else {
      setState(() {
        combineSkills = skills.replaceAll(" ", " ");
      });
    }

    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/master/v1/key_responsible/$combineSkills'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and extract the desired value from each map
      final content = data['resultData'];
      if (content is! List) {
        print('Invalid data format');
        return []; // or any other appropriate default value
      } else {
        Set<String> uniqueValues = <String>{}; // Use Set to store unique values
        for (var map in content) {
          uniqueValues.add(map['value'].toString());
        }
        // Convert Set back to List and update the state
        checkboxData = uniqueValues.toList();
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

  /* Future<List<String>> fetchData(String id) async {
    /* setState(() {
      NatureOfWorkID = int.parse(id);
    }); */
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/master/v1/getDataByParentNameAndParentIdAndGroupName?groupName=key_responsible&parentname=${role.text}&parent_name=${natureOfWork.text}'));

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
  } */

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/company/v1/all?pageNumber=1&pageSize=100'));

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
        'http://${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=job_benifits&pageNumber=1&pageSize=100'));

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
        'http://${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=shifttime&pageNumber=1&pageSize=100'));

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
        'http://${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=rating&pageNumber=1&pageSize=100'));

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
        'http://${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=shiftdesc&pageNumber=1&pageSize=100'));

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
  List<InterviewRoundModel>? interviewRoundsModel;

  int selectedItemCount = 0;

  Future<List<InterviewRoundModel>?> getJobTitle4(
      String pattern, String? name) async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=interview_rounds&pageNumber=1&pageSize=100');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        interviewRoundsModel = contentList
            .map((json) => InterviewRoundModel.fromJson(json))
            .toList();
        return interviewRoundsModel;
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

//TODO: old Api code to fetch interviewRounds.
  /*  Future<List> getJobTitle4(String pattern, String? name) async {
    // Interview Rounds
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/master/v1/getByGroup?groupName=interview_rounds&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions

      List<dynamic> content = data['resultData']['content'];
      // Sort the content based on the order number
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));

      jobTitleSuggestion4 = content.map((e) => e['value'].toString()).toList();
      interviewRoundsId = content.map((e) => e['id'].toString()).toList();
      print(jobTitleSuggestion4);
      return jobTitleSuggestion4;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  } */

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

  FocusNode industryFocus = FocusNode();
  FocusNode numberOfOpeneningFocus = FocusNode();
  FocusNode skillsFocus = FocusNode();

  List<dynamic> selectedValuesList = [];
  List<dynamic> selectedWorkLocation = [];
  String? workFromHome;
  List<String> selectedValues = [];
  // List<String> selectedWorkLocation = [];
  void getWorkValue(String value) {
    setState(() {
      workFromHome = value;
    });
  }

  /*  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  } */
  void handleSelectedSkillsChange(List<dynamic> selectedSkills) {
    // Update the selected skills and trigger fetchData
    setState(() {
      selectedValuesList = selectedSkills;
    });

    String skills = selectedSkills.join(",");
    fetchData(skills).then((updatedData) {
      setState(() {
        checkboxDataState = updatedData;
      });
    });
  }

  void updateSelectedValues1(String value) {
    setState(() {
      if (!selectedWorkLocation.contains(value)) {
        selectedWorkLocation.add(value);
      }
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
  List<int> selectedInterviewRoundsId = [];
  String? selectedShiftTime1;
  String? selectedComunication;
  String? selectedWeakOff1;
  int? lastTappedItem;

  List<JobTitleItem> jobTitleItems = [];
  List<JobTitleItem> jobTitleItems1 = [];
  List<JobTitleItemForInterviewRounds> jobTitleItems2 = [];

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
//  bool isLoading = false;

  bool isShitTime = false;

  void selectShiftTime(int index) {
    setState(() {
      selectedShiftTime = index;
      isOptionVisible = false;
    });
  }

  void clearSelectedShiftTime() {
    setState(() {
      selectedShiftTime =
          -1; // kya chahiye ? Selectionlist or data list// api se jaha store ho raha hai wo ? ha wo or jisme select karne pe store kar raha haiok
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

  Future<void> saveCommercial() async {
    Commercial commercial = Commercial(
        companyId: int.tryParse(CompanyID.toString()),
        process: proces.text,
        natureOfWork: natureOfWork.text,
        roleName: role.text,
        commercialActive: 1);
    Map<String, dynamic> requestBody = commercial.toJson();

    try {
      final response = await http.post(
        Uri.parse('http://${GlobalConstants.API_Host}/commercial/v1'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Commercial added");
        widget.formEdit
            ? ""
            : showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CustomDialog(
                    fetchDataFromApi: () {},
                    isFisrt: false,
                    onClose: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const PartnerHomeScreen()),
                          (Route<dynamic> route) => false);
                    },
                    title: "Success",
                    subtitle: "Submitted successfully!",
                  );
                },
              );
      } else {
        print("Error while posting commercial");
      }
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
    // ref.refresh(commercialProvider);
  }

  Future<void> InActiveCommercial() async {
    Commercial commercial = Commercial(
        jobActive: 1,
        isConfirm: 0,
        commercial_id: commercialid,
        commercialActive: 0);
    Map<String, dynamic> requestBody = commercial.toJson();

    try {
      final response = await http.put(
        Uri.parse(
            'http://${GlobalConstants.API_Host}/commercial/v1/$commercialid/jobActive'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Commercial added");
        widget.formEdit
            ? ""
            : showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CustomDialog(
                    fetchDataFromApi: () {},
                    isFisrt: false,
                    onClose: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const PartnerHomeScreen()),
                          (Route<dynamic> route) => false);
                    },
                    title: "Success",
                    subtitle: "Submitted successfully!",
                  );
                },
              );
      } else {
        print("Error while posting commercial InActive commercial");
      }
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
    // ref.refresh(commercialProvider);
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
              widget.formEdit
                  ? const SizedBox()
                  : InkWell(
                      onTap: () async {
                        if (selectedComunication == "Excellent | Versant") {
                          selectedKeyEligibility.add(
                              "Excellent English written & verbal Communication skills required.");
                        }
                        if (selectedCommunication == "Average") {
                          selectedKeyEligibility.add(
                              "A basic level of English proficiency is expected for communication in this job.");
                        }
                        if (selectedCommunication ==
                            "Very Good | Non Versant") {
                          selectedKeyEligibility.add(
                              "Good English communication skills are required for effective interaction with customers.");
                        }
                        if (selectedShiftTime1 == "🕒Rotational (24/7)") {
                          selectedKeyEligibility.add(
                              "Candidates should be comfortable working in a 24/7 rotational shift.");
                        }
                        if (isFresher == false) {
                          if (isRelevantExpperience == true) {
                            selectedKeyEligibility.add(
                                "Candidate should be from relevant experience background.");
                          }
                        }
                        if (role.text.isNotEmpty) {
                          if (isFullTime == false &&
                              isPartTime == false &&
                              isIntern == false &&
                              isContract == false &&
                              temporary == false) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                    fetchDataFromApi: () {},
                                    isFisrt: false,
                                    onClose: () {
                                      Navigator.pop(context);
                                    },
                                    title: "Error",
                                    subtitle: "Select Emp Type");
                              },
                            );
                          } else if (graduate == false &&
                              undeGraduate == false) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                    fetchDataFromApi: () {},
                                    isFisrt: false,
                                    onClose: () {
                                      Navigator.pop(context);
                                    },
                                    title: "Error",
                                    subtitle: "Select Education type Type");
                              },
                            );
                          } else if (fetchApiskill.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                    fetchDataFromApi: () {},
                                    isFisrt: false,
                                    onClose: () {
                                      Navigator.pop(context);
                                    },
                                    title: "Error",
                                    subtitle: "Add some skill");
                              },
                            );
                          } else if (selectedKeyResponsible.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                    fetchDataFromApi: () {},
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
                                    fetchDataFromApi: () {},
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
                                    fetchDataFromApi: () {},
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
                                    fetchDataFromApi: () {},
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
                                    fetchDataFromApi: () {},
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
                                    fetchDataFromApi: () {},
                                    isFisrt: false,
                                    onClose: () {
                                      Navigator.pop(context);
                                    },
                                    title: "Error",
                                    subtitle:
                                        "Select atleast one interview round");
                              },
                            );
                          } else {
                            double minCtcValue =
                                0.0; // Default value if parsing fails
                            try {
                              minCtcValue = double.parse(minSalary.text);
                            } catch (e) {
                              // Handle the parsing error, e.g., provide a default value, show an error message, etc.
                              print("Error parsing maxSalary: $e");
                              // You can choose to provide a default value or show an error message to the user.
                            }
                            double maxCtcValue =
                                0.0; // Default value if parsing fails
                            try {
                              maxCtcValue = double.parse(maxSalary.text);
                            } catch (e) {
                              // Handle the parsing error, e.g., provide a default value, show an error message, etc.
                              print("Error parsing maxSalary: $e");
                              // You can choose to provide a default value or show an error message to the user.
                            }
                            jobPostModel model = jobPostModel(
                              active: null,
                              crpf_id: functionalAreaId,
                              id: jobID,
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
                                              : "Temporary",
                              education:
                                  graduate ? "Graduate" : "Under-Graduate",
                              skills: fetchApiskill,
                              keyResponsible: selectedKeyResponsible,
                              // textResponsible: selectedTextResponsible,
                              languageKnown: selectedLanguages,
                              jobBenefits: selectedJobBenefits,
                              shiftTime: selectedShiftTime1,
                              shiftDesc: selectedWeakOff1,
                              minCtc: minCtcValue,
                              maxCtc: maxCtcValue,
                              isMonthly: _selectedOption,
                              minExperience: minExp.text,
                              maxExperience: above ? "& above" : maxExp.text,
                              isFresher: isFresher ? "Fresher" : " ",
                              boundry_limits: selectedKeyBoundryLimits,
                              gender: onlyMale
                                  ? "Male"
                                  : onlyFemale
                                      ? "Female"
                                      : femalePrefered
                                          ? "Female prefered"
                                          : " ",
                              is_graduate: isGraduateCheckBox ? 1 : 0,

                              minAge: minAge.text.isNotEmpty
                                  ? int.parse(minAge.text)
                                  : null,
                              maxAge: maxAge.text.isNotEmpty
                                  ? int.parse(maxAge.text).toInt()
                                  : null,
                              eligible: selectedKeyEligibility,

                              moredetails: selectedKeyMoreDetails,
                              inteview_rounds: selectedInterviewRoundsId,
                              //  interviewRounds: selectedInterViewRounds,
                              rating: selectedComunication,

                              workCity: int.parse(CityID.toString()),
                              companyId: int.parse(CompanyID!),
                              natureOfWork: natureOfWork.text,
                              workLocation:
                                  worklocationList.map((e) => e.id).toList(),

                              //  spoc: profileSummaryModel.id
                              spoc: profilemodel.id,
                              //  workLocation: sele
//empType:
//minAge: minAge.text
                              // Populate other properties here
                            );

                            Map<String, dynamic> jsonData = model.toJson();
                            await JobPostApiService.postDataSaveAsDraft(
                              jsonData,
                              context,
                            );
                            ref.refresh(userJobDataProvider);
                            ref.refresh(jobsProvider);

                            /* showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  fetchDataFromApi: () {},
                                  isFisrt: false,
                                  onClose: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()),
                                        (Route<dynamic> route) => false);
                                  },
                                  title: "Success",
                                  subtitle: "Data added to save as draft!",
                                );
                              },
                            ); */
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                  fetchDataFromApi: () {},
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
              InkWell(
                onTap: () async {
                  if (selectedComunication == "Average") {
                    selectedKeyEligibility.add(
                        "A basic level of English proficiency is expected for communication in this job.");
                  }
                  if (selectedComunication == "Excellent | Versant") {
                    selectedKeyEligibility.add(
                        "Excellent English written & verbal Communication skills required.");
                  }

                  if (selectedComunication == "Very Good | Non Versant") {
                    selectedKeyEligibility.add(
                        "Good English communication skills are required for effective interaction with customers.");
                  }
                  if (selectedShiftTime1 == "🕒Rotational (24/7)") {
                    selectedKeyEligibility.add(
                        "Candidates should be comfortable working in a 24/7 rotational shift.");
                  }
                  if (selectedShiftTime1 == "🌙 Night") {
                    selectedKeyEligibility.add(
                        "Candidates should be flexible with Night / US shifts.");
                  }
                  if (selectedLanguages.length > 1) {
                    selectedKeyEligibility.add(
                        "Proficiency in English, Hindi, and Any one Regional Language ${selectedLanguages.map((e) => e)} Required.");
                  }
                  if (selectedLanguages.length == 1) {
                    selectedKeyEligibility.add(
                        "Compulsory Proficiency in English, Hindi, and ${selectedLanguages.map((e) => e.replaceAll("()", ""))} (Regional Language).");
                  }
                  if (onlyFemale) {
                    selectedKeyEligibility.add(
                        "This position is exclusively open to female candidates.");
                  }
                  if (femalePrefered) {
                    selectedKeyEligibility.add(
                        "All candidates are encouraged to apply, and we have a preference for female applicants as part of our diversity initiative.");
                  }
                  if (onlyMale) {
                    selectedKeyEligibility
                        .add("This role is exclusively for male candidates.");
                  }
                  if (isFresher == false) {
                    if (isRelevantExpperience == true) {
                      selectedKeyEligibility.add(
                          "Candidate should be from relevant experience background.");
                    }
                  }

                  if (isFullTime == false &&
                      isPartTime == false &&
                      isIntern == false &&
                      isContract == false &&
                      temporary == false) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            fetchDataFromApi: () {},
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
                            fetchDataFromApi: () {},
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                            },
                            title: "Error",
                            subtitle: "Select Education type Type");
                      },
                    );
                  } else if (fetchApiskill.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            fetchDataFromApi: () {},
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                            },
                            title: "Error",
                            subtitle: "Add some skill");
                      },
                    );
                  } else if (selectedKeyResponsible.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            fetchDataFromApi: () {},
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
                            fetchDataFromApi: () {},
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
                            fetchDataFromApi: () {},
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
                            fetchDataFromApi: () {},
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
                            fetchDataFromApi: () {},
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                            },
                            title: "Error",
                            subtitle: "Select communication rating");
                      },
                    );
                  } else if (!EnteryLevel && !supportstaff) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            fetchDataFromApi: () {},
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                            },
                            title: "Error",
                            subtitle: "Select Hiring Grade");
                      },
                    );
                  } else if (selectedInterViewRounds.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            fetchDataFromApi: () {},
                            isFisrt: false,
                            onClose: () {
                              Navigator.pop(context);
                            },
                            title: "Error",
                            subtitle: "Select atleast one interview round");
                      },
                    );
                  } else {
                    double minCtcValue = 0.0; // Default value if parsing fails
                    try {
                      minCtcValue = double.parse(minSalary.text);
                    } catch (e) {
                      // Handle the parsing error, e.g., provide a default value, show an error message, etc.
                      print("Error parsing maxSalary: $e");
                      // You can choose to provide a default value or show an error message to the user.
                    }
                    double maxCtcValue = 0.0; // Default value if parsing fails
                    try {
                      maxCtcValue = double.parse(maxSalary.text);
                    } catch (e) {
                      // Handle the parsing error, e.g., provide a default value, show an error message, etc.
                      print("Error parsing maxSalary: $e");
                      // You can choose to provide a default value or show an error message to the user.
                    }

// Convert the list to a set to remove duplicates
                    Set<String> uniqueSelectedKeyEligibility =
                        Set<String>.from(selectedKeyEligibility);

// Convert the set back to a list
                    List<String> finalList =
                        uniqueSelectedKeyEligibility.toList();

                    jobPostModel model = jobPostModel(
                        active: 1,
                        crpf_id: functionalAreaId,
                        id: jobID,
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
                                        : "Temporary",
                        education: graduate ? "Graduate" : "Under-Graduate",
                        skills: fetchApiskill,
                        keyResponsible: selectedKeyResponsible,
                        // textResponsible: selectedTextResponsible,
                        languageKnown: selectedLanguages,
                        jobBenefits: selectedJobBenefits,
                        shiftDesc: selectedWeakOff1,
                        minCtc: minCtcValue,
                        maxCtc: maxCtcValue,
                        shiftTime: selectedShiftTime1,
                        minExperience: minExp.text,
                        maxExperience: above ? "& above" : maxExp.text,
                        isFresher: isFresher ? "Fresher" : " ",
                        isMonthly: _selectedOption.toString(),
                        boundry_limits: selectedKeyBoundryLimits,
                        gender: onlyMale
                            ? "Male"
                            : onlyFemale
                                ? "Female"
                                : femalePrefered
                                    ? "Female prefered"
                                    : " ",
                        is_graduate: isGraduateCheckBox == true ? 1 : 0,
                        minAge: minAge.text.isNotEmpty
                            ? int.parse(minAge.text)
                            : null,
                        maxAge: maxAge.text.isNotEmpty
                            ? int.parse(maxAge.text).toInt()
                            : null,
                        eligible: finalList,
                        moredetails: selectedKeyMoreDetails,
                        // interviewRounds: selectedInterViewRounds,  //TODO: old interview Rounds.
                        rating: selectedComunication,
                        inteview_rounds: selectedInterviewRoundsId,
                        workCity: int.parse(CityID.toString()),
                        companyId:
                            CompanyID != null ? int.parse(CompanyID!) : 1,
                        natureOfWork: natureOfWork.text,
                        // workLocation: worklocationList.map((e) => e.id).toList(),
                        workLocation:
                            fetchApilocation.map((e) => e.id).toList(),

                        //  spoc: profileSummaryModel.id
                        spoc: profilemodel.id,
                        isCampus: compusHiring ? 1 : 0,
                        isSupportStaff: supportstaff
                            ? 1
                            : EnteryLevel
                                ? 0
                                : null
                        //  workLocation: sele
//empType:
//minAge: minAge.text
                        // Populate other properties here
                        );

                    Map<String, dynamic> jsonData = model.toJson();
                    await JobPostApiService.postDataToApi(
                        jsonData, context, widget.formEdit);
                    if (!widget.formEdit) {
                      commercialid == 0 || commercialid == null
                          ? await saveCommercial()
                          : await InActiveCommercial();
                    }
                    ref.refresh(userJobDataProvider);
                    // ref.refresh();
                    ref.refresh(jobsProvider);

                    /*  setState(() {
                            isLoading = false;
                          }); */
                  }
                  /* } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                  fetchDataFromApi: () {},
                                  isFisrt: false,
                                  onClose: () {
                                    Navigator.pop(context);
                                  },
                                  title: "Error",
                                  subtitle: "Please Fill All The Deatils");
                            },
                          );
                        } */
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
                  child: Text(widget.formEdit ? "Update" : "Post Job",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 172, 187),
        title: Text(widget.formEdit ? "Edit" : "Job Posting"),
      ),
      body: Form(
        key:_formKey1,
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
                        customContainerSelect1(
                            true, shorListController.text, false, () {}),
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
                    SizedBox(
                      // width: width / 2.2,
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
                          customContainerSelect1(true, role.text, false, () {}),
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
                  if (natureOfWork.text.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                customContainerSelect1(
                                    true, proces.text, false, () {}),
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
                        SizedBox(
                          width: width / 2.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Functional Area",
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              customContainerSelect1(
                                  true, natureOfWork.text, false, () {}),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width / 2.2,
                        child: isIndustry!
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Industry",
                                    style: GoogleFonts.sourceSansPro(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  customContainerSelect1(
                                    true,
                                    industry.text,
                                    true,
                                    () {
                                      setState(() {
                                        isIndustry = false;
                                        industryFocus.requestFocus();
                                        industry.clear();
                                      });
                                    },
                                  ),
                                ],
                              )
                            : CustomJobFormTextFieldRespOne(
                                // isSelected: isIndustry,
                                // focusNode: industryFocus,
                                role: "",
                                isCompany: false,
                                isIndustry: true,
                                name: "industry",
                                /* onFocusNodeRequested: (p0) {
                        focusNode.requestFocus();
                                          }, */
                                title: "Industry",
                                controller: industry,

                                // isEdit: isEdit,
                                //  focusNode: focusNode,
                                onChanged: (p0) {
                                  isEdit5 = true;
                                },
                                contextIn: context,
                                hintText: "NBFC",
                                onIDSelected: handleSelectedID,
                                // getSuggestions: getJobTitle,
                              ),
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No of vacancies",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  // color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600),
                            ),
                            isNumberOfOpenings
                                ? customContainerSelect(
                                    isVacancy: true,
                                    isCross: true,
                                    //isNumOfOpening: true,
                                    onPressed: () {
                                      setState(() {
                                        isNumberOfOpenings = false;
                                        // FocusScope.of(context).autofocus(focusNode);
                                        numberofopenings.clear();
                                        numberOfOpeneningFocus.requestFocus();
                                      });
                                    },
                                    isSelect: true,
                                    title: numberofopenings.text)
                                : Container(
                                    width: width / 2.2,
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
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp(r'[.]')),
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            focusNode: numberOfOpeneningFocus,
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
                                                hintText: "e.g. 1",
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
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Is this campus hiring ?",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        // margin: const EdgeInsets.only(bottom: 4),
                        height: 16,
                        width: 20,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: compusHiring
                                ? Constants.themeBgColor
                                : Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.transparent,
                          ),
                          child: Checkbox(
                            side: const BorderSide(color: Colors.white),
                            activeColor: Colors.white,
                            checkColor: Constants.themeBgColor,
                            visualDensity: VisualDensity.compact,
                            value: compusHiring,
                            onChanged: (value) {
                              setState(() {
                                compusHiring = value!;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            // No border when unchecked

                            // Remove extra padding around the checkbox
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hiring Grade?",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 18.sp,
                            // color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          customContainerSelect(
                              isAnother: true,
                              onPressed: () {
                                setState(() {
                                  EnteryLevel = true;
                                  supportstaff = false;
                                });
                              },
                              isSelect: EnteryLevel,
                              title: "Entery Level"),
                          customContainerSelect(
                              isAnother: true,
                              onPressed: () {
                                setState(() {
                                  EnteryLevel = false;
                                  supportstaff = true;
                                });
                              },
                              isSelect: supportstaff,
                              title: "Support Staff"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),

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
                              temporary = false;
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
                              temporary = false;
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
                              temporary = false;
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
                              temporary = false;
                            });
                          },
                          isSelect: isIntern,
                          title: "Internship"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              isPartTime = false;
                              isFullTime = false;
                              isContract = false;
                              isIntern = false;
                              temporary = true;
                            });
                          },
                          isSelect: temporary,
                          title: "Temporary"),
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
                  graduate == true
                      ? Container(
                          margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 4.w),
                                height: 16,
                                width: 20,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isGraduateCheckBox
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
                                    value: isGraduateCheckBox,
                                    onChanged: (value) {
                                      setState(() {
                                        isGraduateCheckBox = value!;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    side: isGraduateCheckBox
                                        ? const BorderSide(color: Colors.red)
                                        : null, // No border when unchecked

                                    // Remove extra padding around the checkbox
                                  ),
                                ),
                              ),
                              const Text(
                                "Undergraduates with Relevant Experience can Apply.",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),

                  CustomFormTextFieldMultiSelect(
                    // isCompany: false,
                    name: "skills",
                    isSkill: true,
                    fetchApiskill: fetchApiskill,
                    selectedSkillsChangeCallback: handleSelectedSkillsChange,
                    /* onFocusNodeRequested: (p0) {
                      focusNode.requestFocus();
                    }, */
                    title: "Skills Required",
                    controller: skills,
                    selectedValuesList: selectedValuesList,
                    //callback:handleSelectedSkillsChange,
                    // isEdit: isEdit,
                    //  focusNode: focusNode,
                    /*  onChanged: (p0) {
                      isEdit7 = p0;
                    }, */
                    contextIn: context,
                    hintText: "Advance Excel",
                    // getSuggestions: getJobTitle,
                  ),

                  /* CustomFormTextFieldMultiSelect(
                    // isCompany: false,
                    name: "skills",
                    isSkill: true,
                    fetchApiskill: fetchApiskill,
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
                  ), */
                  /* newFormFiled(shorListController, context, "Skills Required",
                      "Advance Excel", false, false, false), */

                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Job Responsibilities",
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
                    itemCount: selectedKeyResponsible.length,
                    itemBuilder: (context, index) {
                      final item = selectedKeyResponsible[index];
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
                                      activeColor: Colors.white,
                                      checkColor: Constants.themeBgColor,
                                      visualDensity: VisualDensity.compact,
                                      value:
                                          selectedKeyResponsible.contains(item),
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue!) {
                                            // Add the item to the list
                                            selectedKeyResponsible.add(item);
                                          } else {
                                            // Remove the item from the list
                                            selectedKeyResponsible.remove(item);
                                          }
                                        });
                                        print(
                                            selectedKeyResponsible); // Notify Flutter that the state has changed
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
                      focusNode: responsibilityFocus,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'^\s')), // Disallow spaces at the beginning
                        /*  FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')), */
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
                          selectedKeyResponsible.add(responsibility.text);
                          responsibility.clear();
                        });
                      }, */
                      onEditingComplete: () {
                        final newResponsibility = responsibility.text.trim();
                        if (newResponsibility.isNotEmpty &&
                            !checkboxData.contains(newResponsibility)) {
                          setState(() {
                            checkboxData.add(newResponsibility);
                            selectedKeyResponsible.add(newResponsibility);
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _getBulletPointWidgetsrespo(),
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
                  /* ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: checkboxData.length,
                    itemBuilder: (context, index) {
                      final item = checkboxData[index];
                      //  fetchData();
                      if (!selectedKeyResponsible.contains(item)) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 5),
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
                                        activeColor: Colors.white,
                                        checkColor: Constants.themeBgColor,
                                        visualDensity: VisualDensity.compact,
                                        value: selectedKeyResponsible
                                            .contains(item),
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (newValue!) {
                                              // Add the item to the list
                                              selectedKeyResponsible.add(item);
                                            } else {
                                              // Remove the item from the list
                                              selectedKeyResponsible
                                                  .remove(item);
                                            }
                                          });
                                          print(
                                              selectedKeyResponsible); // Notify Flutter that the state has changed
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
                      } else {
                        return Container();
                      }
                    },
                  ), */
                  /* checkboxData.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: showAllItems
                              ? checkboxData.length
                              : selectedKeyResponsible.isEmpty
                                  ? 4
                                  : 1 + selectedKeyResponsible.length,
                          itemBuilder: (context, index) {
                            final item = checkboxData[index];

                            // Check if the item is not selected
                            if (!selectedKeyResponsible.contains(item)) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, right: 5),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              activeColor: Colors.white,
                                              checkColor:
                                                  Constants.themeBgColor,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              value: selectedKeyResponsible
                                                  .contains(item),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  if (newValue!) {
                                                    // Add the item to the list
                                                    selectedKeyResponsible
                                                        .add(item);
                                                  } else {
                                                    // Remove the item from the list
                                                    selectedKeyResponsible
                                                        .remove(item);
                                                  }
                                                });
                                                print(
                                                    selectedKeyResponsible); // Notify Flutter that the state has changed
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
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Return an empty container if the item is already selected
                              return Container();
                            }
                          },
                        ),
                  if (checkboxData.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showAllItems = !showAllItems;
                              responsibilityFocus.requestFocus();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors
                                .white, // Change this color to your desired color
                          ),
                          child: Text(
                            showAllItems ? "Show Less" : "Show More",
                            style:
                                const TextStyle(color: Constants.themeBgColor),
                          ),
                        )
                      ],
                    ), */

                  /*  checkboxData.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: showAllItems
                              ? checkboxData.length
                              : selectedKeyResponsible.isEmpty
                                  ? 5
                                  : 5,
                          itemBuilder: (context, index) {
                            final nonSelectedItems = checkboxData
                                .where(
                                  (item) =>
                                      !selectedKeyResponsible.contains(item),
                                )
                                .toList();

                            if (!showAllItems &&
                                index == 4 &&
                                nonSelectedItems.length > 5) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showAllItems = true;
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Show More",
                                        style: TextStyle(
                                            color: Constants.themeBgColor),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            if (index < nonSelectedItems.length) {
                              final item = nonSelectedItems[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, right: 5),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              activeColor: Colors.white,
                                              checkColor:
                                                  Constants.themeBgColor,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              value: selectedKeyResponsible
                                                  .contains(item),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  if (newValue!) {
                                                    // Add the item to the list
                                                    selectedKeyResponsible
                                                        .add(item);
                                                  } else {
                                                    // Remove the item from the list
                                                    selectedKeyResponsible
                                                        .remove(item);
                                                  }
                                                });
                                                print(
                                                    selectedKeyResponsible); // Notify Flutter that the state has changed
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
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (showAllItems &&
                                index == nonSelectedItems.length) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showAllItems = false;
                                        responsibilityFocus.requestFocus();
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Show Less",
                                        style: TextStyle(
                                            color: Constants.themeBgColor),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ), */

                  checkboxData.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: showAllItems
                              ? checkboxData.length
                              : selectedKeyResponsible.isEmpty
                                  ? visibleItemCount
                                  : visibleItemCount,
                          itemBuilder: (context, index) {
                            final nonSelectedItems = checkboxData
                                .where(
                                  (item) =>
                                      !selectedKeyResponsible.contains(item),
                                )
                                .toList();

                            if (!showAllItems &&
                                index == visibleItemCount - 1 &&
                                nonSelectedItems.length >= visibleItemCount) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (!showAllItems &&
                                      index == visibleItemCount - 1 &&
                                      nonSelectedItems.length >
                                          visibleItemCount)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          visibleItemCount += 4;
                                          if (visibleItemCount >
                                              nonSelectedItems.length) {
                                            visibleItemCount =
                                                nonSelectedItems.length;
                                          }
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "View More",
                                          style: TextStyle(
                                              color: Constants.themeBgColor),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  if (visibleItemCount > 4)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          visibleItemCount -= 4;
                                          if (visibleItemCount < 4) {
                                            visibleItemCount = 4;
                                          }
                                          _scrollController.animateTo(
                                            0.0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "View less",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }

                            if (index < nonSelectedItems.length) {
                              final item = nonSelectedItems[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, right: 5),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              activeColor: Colors.white,
                                              checkColor:
                                                  Constants.themeBgColor,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              value: selectedKeyResponsible
                                                  .contains(item),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  if (newValue!) {
                                                    // Add the item to the list
                                                    selectedKeyResponsible
                                                        .add(item);
                                                  } else {
                                                    // Remove the item from the list
                                                    selectedKeyResponsible
                                                        .remove(item);
                                                  }
                                                });
                                                print(
                                                    selectedKeyResponsible); // Notify Flutter that the state has changed
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
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (showAllItems &&
                                index == nonSelectedItems.length) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showAllItems = false;
                                        visibleItemCount = 4;
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Show Less",
                                        style: TextStyle(
                                            color: Constants.themeBgColor),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
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
                          String title = jobTitleSuggestion[index];
                          bool isSelected = selectedLanguages.contains(title);

                          /*  if (isPreselected && !isSelected) {
                            isSelected =
                                true; // Mark the preselected item as selected
                          } */

                          JobTitleItem item = JobTitleItem(
                            isunSelect: true,
                            getJobTitle1isSelected: null,
                            ismulti:
                                false, // Set ismulti to true for multi-select functionality
                            title: title,
                            isSelected: isSelected,
                            onTap: (selected) {
                              setState(() {
                                if (selected) {
                                  // Select the item
                                  selectedLanguages.add(title);
                                } else {
                                  // Unselect the item
                                  selectedLanguages.remove(title);
                                }
                              });
                            },
                            isVisible: true,
                            onlyOneIcon: false,
                          );

                          jobTitleItems.add(item);
                          return item;
                        },
                      ),
                    ),
                  ),

                  /*  Container( // preselected item getting unselect but not multiselect
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        jobTitleSuggestion.length,
                        (index) {
                          String title = jobTitleSuggestion[index];
                          bool isSelected = selectedLanguages.contains(title);
                          bool isPreselected =
                              fetchApiLanguages.contains(title);

                          if (isPreselected && !isSelected) {
                            selectedLanguages.add(title);
                          }

                          JobTitleItem item = JobTitleItem(
                            ismulti:
                                false, // Set ismulti to true for multi-select functionality
                            title: title,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isPreselected) {
                                  if (isSelected) {
                                    // Unselect the preselected item
                                    selectedLanguages.remove(title);
                                  } else {
                                    // Toggle selection for preselected item
                                    selectedLanguages.contains(title)
                                        ? selectedLanguages.remove(title)
                                        : selectedLanguages.add(title);
                                  }
                                } else {
                                  if (isSelected) {
                                    // Unselect the item
                                    selectedLanguages.remove(title);
                                  } else {
                                    // Select the item
                                    selectedLanguages.add(title);
                                  }
                                }
                              });
                            },
                            isVisible: true,
                            onlyOneIcon: false,
                            getJobTitle1isSelected: () => isSelected,
                          );

                          jobTitleItems.add(item);
                          return item;
                        },
                      ),
                    ),
                  ), */

                  /* Container( // Selected data fetch hua but unselectd is remaining
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        jobTitleSuggestion.length,
                        (index) {
                          String title = jobTitleSuggestion[index];
                          bool isSelected = selectedLanguages.contains(title);

                          if (fetchApiLanguages.contains(title) &&
                              !isSelected) {
                            isSelected = true;
                            selectedLanguages.add(title);
                          }

                          JobTitleItem item = JobTitleItem(
                            ismulti: false,
                            title: title,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (selectedLanguages.contains(title)) {
                                  selectedLanguages.remove(title);
                                } else {
                                  selectedLanguages.add(title);
                                }
                                isSelected = !isSelected;
                              });
                            },
                            isVisible: true,
                            onlyOneIcon: false,
                            getJobTitle1isSelected: () => isSelected,
                          );

                          jobTitleItems.add(item);
                          return item;
                        },
                      ),
                    ),
                  ), */

                  /*  Container(
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
                    ), */

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
                          String title = jobTitleSuggestion1[index];
                          bool isSelected = selectedJobBenefits.contains(title);
                          JobTitleItem item = JobTitleItem(
                            isunSelect: true,
                            ismulti: false,
                            title: title,
                            isSelected: isSelected,
                            onTap: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedJobBenefits.add(title);
                                } else {
                                  selectedJobBenefits.remove(title);
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
                        final jobTitle = jobTitleSuggestion2[index];
                        String modifiedString1 = jobTitle.replaceAll(" ", "");
                        String? modifiedString2 =
                            selectedShiftTime1?.replaceAll(" ", "");
                        final bool isSelected0 =
                            modifiedString1 == modifiedString2 &&
                                selectedShiftTime1 != null;

                        return JobTitleItem(
                          isunSelect: false,
                          getJobTitle1isSelected: isSelected0,
                          onlyOneIcon: true,
                          ismulti: false,
                          title: jobTitle,
                          isSelected: isSelected0,
                          onTap: (selected) {
                            if (selected) {
                              setState(() {
                                selectedShiftTime1 = jobTitle;
                              });
                            }
                          },
                          isVisible: true,
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
                    "Week Off",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 18.sp,
                        // color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                  /* Container(  // Before Fetching From Api 
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
                          onTap: (_) {
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
                  ), */
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isOptionVisible ? 5 : 0,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion3.length, (index) {
                        final jobTitle = jobTitleSuggestion3[index];
                        String modifiedString1 = jobTitle.replaceAll(" ", "");
                        String? modifiedString2 =
                            selectedWeakOff1?.replaceAll(" ", "");
                        final bool isSelected0 =
                            modifiedString1 == modifiedString2 &&
                                selectedWeakOff1 != null;

                        return JobTitleItem(
                          getJobTitle1isSelected: isSelected0,
                          onlyOneIcon: true,
                          isunSelect: false,
                          ismulti: false,
                          title: jobTitle,
                          isSelected: isSelected0,
                          onTap: (selected) {
                            if (lastTappedItem != index) {
                              setState(() {
                                selectedWeakOff1 = jobTitle;
                                lastTappedItem =
                                    index; // Update the last tapped item index
                              });
                            }
                          },
                          isVisible: true,
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

                  isValueValid && minSalaryk.isNotEmpty
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
                          title:
                              "$minSalaryk ${maxSalary.text.isEmpty ? "" : "- $maxSalaryk"} $_selectedOption")
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
                              value: "Lac's P.A",
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
                                          worklocationList.clear();
                                        });
                                      },
                                      isSelect: true,
                                      title: workFromHome.toString())
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2.w,
                              child: isCity!
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "City",
                                          style: GoogleFonts.sourceSansPro(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        customContainerSelect(
                                            isAnother: true,
                                            isVacancy: true,
                                            isCross: true,
                                            onPressed: () {
                                              setState(() {
                                                //  isEdit8 = false;
                                                //  location.clear();
                                                isCity = false;

                                                city.clear();
                                                //  worklocationList.clear();
                                              });
                                            },
                                            isSelect: true,
                                            title: city.text)
                                        /*  customContainerSelect1(
                                                true,
                                                city.text,
                                                true,
                                                () {
                                                  setState(() {
                                                    isCity = false;
                                                    // isEdit10 = false;
                                                    //roleFocusNodeFrom.requestFocus();
                                                    city.clear();
                                                  });
                                                },
                                              ), */
                                      ],
                                    )
                                  : CustomJobFormTextFieldJobRespo(
                                      isCompany: false,
                                      name: "city",
                                      isCity: true,
                                      /* onFocusNodeRequested: (p0) {
                                                      focusNode.requestFocus();
                                                    }, */
                                      title: "City",
                                      role: "",
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
                      : CustomFormTextFieldMultiSelectLocation(
                          // isCompany: false,
                          name: "location",
                          isSkill: false,
                          fetchApiskill1: fetchApilocation, //

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
                          workType1: getWorkValue,
                          submit1: getWorkLocation,
                          selectedValuesList1: selectedWorkLocation, //
                          callback1: updateSelectedValues1,
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
                  fetchApiBoundryLimit.isNotEmpty
                      ? const SizedBox()
                      : const SizedBox(
                          height: 5,
                        ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: fetchApiBoundryLimit.length,
                    itemBuilder: (context, index) {
                      final item = fetchApiBoundryLimit[index];
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
                                      color: selectedKeyBoundryLimits
                                              .contains(item)
                                          ? Colors.red
                                          : Colors.grey,
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
                                      value: selectedKeyBoundryLimits
                                          .contains(item),
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue!) {
                                            // Add the item to the list
                                            selectedKeyBoundryLimits.add(item);
                                          } else {
                                            // Remove the item from the list
                                            selectedKeyBoundryLimits
                                                .remove(item);
                                          }
                                        });
                                        print(
                                            selectedKeyBoundryLimits); // Notify Flutter that the state has changed
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
                        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                        /* FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')), */
                      ],
                      controller: boundryLimits,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      onEditingComplete: () {
                        final newBoundaryLimit = boundryLimits.text.trim();
                        if (newBoundaryLimit.isNotEmpty &&
                            !fetchApiBoundryLimit.contains(newBoundaryLimit)) {
                          setState(() {
                            fetchApiBoundryLimit.add(newBoundaryLimit);
                            selectedKeyBoundryLimits.add(newBoundaryLimit);
                            boundryLimits.clear();
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Boundary limit already exists.'),
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
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        prefix: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _getBulletPointWidgetsrespo(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: selectedKeyBoundryLimits
                                  .contains(boundryLimits.text.trim())
                              ? const BorderSide(color: Colors.red)
                              : BorderSide(color: Colors.grey.shade400),
                        ),
                        focusColor: const Color(0xffff0eceb),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: selectedKeyBoundryLimits
                                  .contains(boundryLimits.text.trim())
                              ? const BorderSide(color: Colors.red)
                              : BorderSide(color: Colors.grey.shade400),
                        ),
                        hintText:
                            "Any other Boundary Limit that you want to add",
                        hintStyle: GoogleFonts.sourceSansPro(
                          color: Constants.subtitleclr,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        fetchApiBoundryLimit.contains(boundryLimits.text.trim())
                            ? const EdgeInsets.only(bottom: 15, left: 10)
                            : null,
                    child: Text(
                      fetchApiBoundryLimit.contains(boundryLimits.text.trim())
                          ? "This Boundary Limit is already added."
                          : "",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  //old code of boundry limits down
                  /* const SizedBox(
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
                                onTap: () {},
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
                  ), */
                  //old code of boundry limits

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
                                above
                                    ? customContainerSelect(
                                        isCross: true,
                                        isExp: true,
                                        isNumOfOpening: false,
                                        onPressed: () {
                                          setState(() {
                                            expContainer = false;
                                            experinceFocusNode.requestFocus();
                                            maxAge.clear();
                                          });
                                        },
                                        isSelect: expContainer,
                                        title: "${minExp.text} Yrs & above.")
                                    : customContainerSelect(
                                        isCross: true,
                                        onPressed: () {
                                          setState(() {
                                            //above = false;
                                            expContainer = false;
                                            experinceFocusNode.requestFocus();
                                            maxAge.clear();
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
                                              onFieldSubmitted: (newValue) {
                                                /*   maxAge.text.isNotEmpty &&
                                                            minAge.text.isNotEmpty */

                                                if (minExp.text.isNotEmpty &&
                                                    above) {
                                                  setState(() {
                                                    expContainer =
                                                        newValue.isNotEmpty;
                                                  });
                                                }
                                                /* else {
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
                                              focusNode: experinceFocusNode,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (minExp.text.isNotEmpty) {
                                                    setState(() {
                                                      isCheckBox = !isCheckBox;
                                                      above = false;
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
                                                      _showContainer1 = true;
                                                      _showContainer2 = true;
                                                      enableExperience = true;
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
                                  if (above == false)
                                    const SizedBox(child: Text("-")),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if (above == false)
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          5.w,
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
                                                    height:
                                                        MediaQuery.of(context)
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
                                                              builder:
                                                                  (context) {
                                                                return CustomDialog(
                                                                    fetchDataFromApi:
                                                                        () {},
                                                                    isFisrt:
                                                                        false,
                                                                    onClose:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);

                                                                      setState(
                                                                          () {
                                                                        expContainer =
                                                                            !newValue.isNotEmpty;
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
                                                        if (minExp
                                                            .text.isEmpty) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CustomDialog(
                                                                  fetchDataFromApi:
                                                                      () {},
                                                                  isFisrt:
                                                                      false,
                                                                  onClose: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    minExp
                                                                        .clear();
                                                                    maxExp
                                                                        .clear();
                                                                    // maxExp.clear();
                                                                    setState(
                                                                        () {
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
                                                      enabled:
                                                          minExp.text.isNotEmpty
                                                              ? true
                                                              : false,
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
                                                              counterText: '',
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      left: 10,
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
                                                                            8),
                                                                borderSide: const BorderSide(
                                                                    color: Color(
                                                                        0xffff0eceb)),
                                                              ),
                                                              focusColor:
                                                                  const Color(
                                                                      0xffff0eceb),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide: const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
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
                                    "Yrs",
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 16.sp,
                                        // color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 3, left: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          height: 16,
                                          width:
                                              20, // Adjust the width according to your requirements
                                          child: InkWell(
                                            onTap: () {
                                              minExp.text.isNotEmpty &&
                                                      maxAge.text.isEmpty
                                                  ? setState(() {
                                                      above = !above;
                                                    })
                                                  : setState(() {
                                                      above = above;
                                                    });
                                            },
                                            child: Container(
                                              // margin: const EdgeInsets.only(bottom: 4),
                                              height: 16,
                                              width: 20,
                                              padding: EdgeInsets.zero,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: above
                                                      ? Colors.red
                                                      : minExp.text.isEmpty &&
                                                              maxAge.text
                                                                  .isNotEmpty
                                                          ? Colors.grey.shade400
                                                          : Colors.grey,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Theme(
                                                data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.transparent,
                                                ),
                                                child: Checkbox(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  activeColor: Colors.white,
                                                  checkColor: Colors.red,
                                                  value: above,
                                                  onChanged: (value) {
                                                    minExp.text.isNotEmpty &&
                                                            maxAge.text.isEmpty
                                                        ? setState(() {
                                                            above = value!;
                                                            maxExp.clear();
                                                          })
                                                        : null;
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  side: above
                                                      ? const BorderSide(
                                                          color: Colors.red)
                                                      : null, // No border when unchecked

                                                  // Remove extra padding around the checkbox
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "& above.",
                                          style: TextStyle(
                                              color: minExp.text.isEmpty
                                                  ? Colors.grey.shade400
                                                  : Colors.black,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
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
                              onlyMale = !onlyMale;
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
                              onlyFemale = !onlyFemale;
                            });
                          },
                          isSelect: onlyFemale,
                          title: "Only Female"),
                      customContainerSelect(
                          isAnother: true,
                          onPressed: () {
                            setState(() {
                              femalePrefered = !femalePrefered;
                              onlyMale = false;
                              onlyFemale = false;
                            });
                          },
                          isSelect: femalePrefered,
                          title: "Female Preferred")
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
                                    minAge.clear();
                                    maxAge.clear();
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
                                                              fetchDataFromApi:
                                                                  () {},
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
                                                              fetchDataFromApi:
                                                                  () {},
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
                                                /*  onTapOutside: (event) {
                                                        /*   maxAge.text.isNotEmpty &&
                                                          minAge.text.isNotEmpty */

                                                        if (maxAge
                                                            .text.isNotEmpty) {
                                                          int? age =
                                                              int.tryParse(
                                                                  maxAge.text);
                                                          int? age2 =
                                                              int.tryParse(
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
                                                              builder:
                                                                  (context) {
                                                                return CustomDialog(
                                                                    isFisrt:
                                                                        false,
                                                                    onClose:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      minAge
                                                                          .clear();
                                                                      maxAge
                                                                          .clear();
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
                                                              builder:
                                                                  (context) {
                                                                return CustomDialog(
                                                                    isFisrt:
                                                                        false,
                                                                    onClose:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      minAge
                                                                          .clear();
                                                                      maxAge
                                                                          .clear();
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
                                                      }, */
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
                  /* Container(
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
                          onTap: (_) {
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
                  ), */
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      spacing: isOptionVisible ? 5 : 0,
                      runSpacing: 5,
                      children:
                          List.generate(jobTitleSuggestion5.length, (index) {
                        final jobTitle = jobTitleSuggestion5[index];
                        String modifiedString1 = jobTitle.replaceAll(" ", "");
                        String? modifiedString2 =
                            selectedComunication?.replaceAll(" ", "");
                        final bool isSelected0 =
                            modifiedString1 == modifiedString2 &&
                                selectedComunication != null;

                        return JobTitleItem(
                          isunSelect: false,
                          getJobTitle1isSelected: isSelected0,
                          onlyOneIcon: true,
                          ismulti: false,
                          title: jobTitle,
                          isSelected: isSelected0,
                          onTap: (selected) {
                            if (selected) {
                              setState(() {
                                selectedComunication = jobTitle;
                              });
                            }
                          },
                          isVisible: true,
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
                  fetchApieligibility.isNotEmpty
                      ? const SizedBox()
                      : const SizedBox(height: 5),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: fetchApieligibility.length,
                    itemBuilder: (context, index) {
                      final item = fetchApieligibility[index];
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
                                      color: Colors.grey,
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
                                          selectedKeyEligibility.contains(item),
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue!) {
                                            selectedKeyEligibility.add(item);
                                          } else {
                                            selectedKeyEligibility.remove(item);
                                          }
                                        });
                                        print(selectedKeyEligibility);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                item,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
// Rest of the code...

                  SizedBox(
                    height: height / 25,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                        /*  FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')), */
                      ],
                      controller: Eligibility,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      onEditingComplete: () {
                        final newEligibility = Eligibility.text.trim();
                        if (newEligibility.isNotEmpty &&
                            !fetchApieligibility.contains(newEligibility)) {
                          setState(() {
                            fetchApieligibility.add(newEligibility);
                            selectedKeyEligibility.add(newEligibility);
                            Eligibility.clear();
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Eligibility already exists.'),
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
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        prefix: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _getBulletPointWidgetsrespo(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: selectedKeyEligibility
                                  .contains(Eligibility.text.trim())
                              ? const BorderSide(color: Colors.red)
                              : BorderSide(color: Colors.grey.shade400),
                        ),
                        focusColor: const Color(0xffff0eceb),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: selectedKeyEligibility
                                  .contains(Eligibility.text.trim())
                              ? const BorderSide(color: Colors.red)
                              : BorderSide(color: Colors.grey.shade400),
                        ),
                        hintText: "Any other eligibility that you want to add",
                        hintStyle: GoogleFonts.sourceSansPro(
                          color: Constants.subtitleclr,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        fetchApieligibility.contains(Eligibility.text.trim())
                            ? const EdgeInsets.only(bottom: 15, left: 10)
                            : null,
                    child: Text(
                      fetchApieligibility.contains(Eligibility.text.trim())
                          ? "This Eligibility is already added."
                          : "",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  //old eligibility down
                  /* ListView.builder(
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
                  ), */
                  //old eligibility

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

                  fetchApiMoreDEtail.isNotEmpty
                      ? const SizedBox()
                      : const SizedBox(
                          height: 5,
                        ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: fetchApiMoreDEtail.length,
                    itemBuilder: (context, index) {
                      final item = fetchApiMoreDEtail[index];
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
                                          selectedKeyMoreDetails.contains(item)
                                              ? Colors.red
                                              : Colors.grey,
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
                                          selectedKeyMoreDetails.contains(item),
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue!) {
                                            // Add the item to the list
                                            selectedKeyMoreDetails.add(item);
                                          } else {
                                            // Remove the item from the list
                                            selectedKeyMoreDetails.remove(item);
                                          }
                                        });
                                        print(
                                            selectedKeyMoreDetails); // Notify Flutter that the state has changed
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
                        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                        /*  FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')), */
                      ],
                      controller: moreDetail,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      onEditingComplete: () {
                        final newMoreDetail = moreDetail.text.trim();
                        if (newMoreDetail.isNotEmpty &&
                            !fetchApiMoreDEtail.contains(newMoreDetail)) {
                          setState(() {
                            fetchApiMoreDEtail.add(newMoreDetail);
                            selectedKeyMoreDetails.add(newMoreDetail);
                            moreDetail.clear();
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Eligibility already exists.'),
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
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        prefix: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _getBulletPointWidgetsrespo(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: selectedKeyMoreDetails
                                  .contains(moreDetail.text.trim())
                              ? const BorderSide(color: Colors.red)
                              : BorderSide(color: Colors.grey.shade400),
                        ),
                        focusColor: const Color(0xffff0eceb),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: selectedKeyMoreDetails
                                  .contains(moreDetail.text.trim())
                              ? const BorderSide(color: Colors.red)
                              : BorderSide(color: Colors.grey.shade400),
                        ),
                        hintText: "Any other More Detail that you want to add",
                        hintStyle: GoogleFonts.sourceSansPro(
                          color: Constants.subtitleclr,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: fetchApiMoreDEtail.contains(moreDetail.text.trim())
                        ? const EdgeInsets.only(bottom: 15, left: 10)
                        : null,
                    child: Text(
                      fetchApiMoreDEtail.contains(moreDetail.text.trim())
                          ? "This More Detail is already added."
                          : "",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  // old more detail down
                  /* ListView.builder(
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
                  //old more detail
                  const SizedBox(
                    height: 5,
                  ), */

                  /*  newFormFiled(shorListController, context, "More Details",
                      "Optional", false, false), */
                  /*  newFormFiled(shorListController, context, "Interview Rounds",
                      "Graduate", false, false, false) */
                  if (selectedInterViewRounds.isNotEmpty)
                    Text(
                      "Interview Rounds Sequence::",
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18.sp,
                          // color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600),
                    ),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    children: selectedInterViewRounds != null
                        ? selectedInterViewRounds.toSet().map((title) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                      color: Constants.themeBgColor)),
                              margin: EdgeInsets.only(right: 6.w, top: 6.h),
                              child: Text(title),
                            );
                          }).toList()
                        : [],
                  ),
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
                  /* Container(   Before Fetching data from api Related to matching jobs.
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
                            onTap: (_) {
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
                  ), */

                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        interviewRoundsModel != null
                            ? interviewRoundsModel!.length
                            : 0,
                        (index) {
                          String title = interviewRoundsModel![index].value;
                          bool isSelected = selectedInterviewRoundsId
                              .contains(interviewRoundsModel![index].id);
                          JobTitleItemForInterviewRounds item =
                              JobTitleItemForInterviewRounds(
                            isunSelect: true,
                            ismulti: false,
                            title: title,
                            isSelected: isSelected,
                            onTap: (selected) {
                              setState(() {
                                if (selected) {
                                  //     selectedItemCount++;
                                  selectedInterViewRounds.add(title);
                                  selectedInterviewRoundsId
                                      .add(interviewRoundsModel![index].id);
                                } else {
                                  // selectedItemCount--;
                                  selectedInterViewRounds.remove(title);
                                  selectedInterviewRoundsId
                                      .remove(interviewRoundsModel![index].id);
                                }
                              });
                            },
                            /* onTap: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedInterViewRounds.add(title);
                                  selectedInterviewRoundsId
                                      .add(interviewRoundsModel![index].id);
                                } else {
                                  selectedInterViewRounds.remove(title);
                                  selectedInterviewRoundsId
                                      .remove(interviewRoundsModel![index].id);
                                }
                              });
                            }, */
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
      bool isExp = false,
      bool? isSalary = false}) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: isAnother
                ? null
                : isNumberOfOpenings
                    ? MediaQuery.of(context).size.width / 2.3
                    : isAnother
                        ? double.infinity
                        : isExp
                            ? MediaQuery.of(context).size.width / 3
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ? Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15.h,
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
                onTapOutside: (event) {
                  //    _checkLength(false);
                },
                onFieldSubmitted: (value) {
                  _checkLength(true);
                  if (minSalary.text.isNotEmpty) {
                    final int minSalary1 = int.tryParse(minSalary.text) ?? 0;
                    final int maxSalary2 = int.tryParse(maxSalary.text) ?? 0;
                    if (minSalary1 <= 4) {
                      setState(() {
                        isValueValid = false;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              fetchDataFromApi: () {},
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
                              ? NumberFormat("0.00' '").format(formattedValue)
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

                        /*  maxSalaryk = NumberFormat.compact()
                            .format(double.tryParse(maxSalary.text)); */
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            fetchDataFromApi: () {},
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
              fetchDataFromApi: () {},
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
                /* onTapOutside: (event) {
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
                }, */

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
                              fetchDataFromApi: () {},
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
                              ? NumberFormat("0.00' '").format(formattedValue)
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
                            fetchDataFromApi: () {},
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
                        color: Constants.subtitleclr, fontSize: 15.sp)
                    //  prefixIcon: Icon(Icons.list)
                    ),
              ),
            ),
          ],
        ));
  }
}
