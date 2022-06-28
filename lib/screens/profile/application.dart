import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/autolistviewmodal.dart';
import 'package:job_circle/components/cv.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/autocomplete.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/applicationService.dart';
import 'package:job_circle/service/company.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/autocompleteModel.dart';
import '../../service/UserDataService.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({Key? key, this.prevModel}) : super(key: key);
  final dynamic prevModel;

  @override
  State<ApplicationForm> createState() => ApplicationFormState();
}

class ApplicationFormState extends State<ApplicationForm> {
  List typeList = [];
  DropdownModel selectedTyp = DropdownModel();
  int underGradActive = 0;
  int graduateActive = 0;
  int exprinceActive = 0;
  int fresherActive = 0;
  int leadID = 0;
  int jobId = 0;
  int spoc = 0;
  String paymentClause = "";

  bool enableShortListFor = true;
  bool enableProcess = true;
  bool enableLevel = true;

  TextEditingController contactno = TextEditingController();
  TextEditingController applicationname = TextEditingController();
  TextEditingController shorListController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController processController = TextEditingController();

  var ddlValues;
  late int userType = -1;
  late List<AutoCompleteModel> shortList = [];
  late List<AutoCompleteModel> proccessList = [];
  late List<AutoCompleteModel> levelList = [];
  AutoCompleteModel selectedshort = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedProcess = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedLevel = AutoCompleteModel("", "", {});
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();

  // dynamic applicantName = {};
  String mobileno = "";
  dynamic localStoregData;
  dynamic userinfo;

  ProfileCv profileCv = ProfileCv();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Bind All Dropdown

    // profileCv.profile_cv_file = "abc.pdf";
    // profileCv.cv_link = "abc.pdf";
    // profileCv.cv_upladted_date = "2033";
    // profileCv.profile_cv_link = "lin";

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userinfo = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_data.name);
      userType = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
      // mobileno = await Utils.getPreferencesValue(
      //     null, ESharedPreferences.user_mobile.name);
      localStoregData = jsonDecode(userinfo);
      if (userType == EUserType.jobSeeker.value) {
        contactno.text = localStoregData["mobile"];
        applicationname.text =
            localStoregData["cardName"].toString().toTitleCase();
      }
      setState(() {});
    });
    if (widget.prevModel != null) {
      shorListController.text = widget.prevModel?.name;
      selectedshort = AutoCompleteModel(widget.prevModel.compnayid.toString(),
          widget.prevModel?.name, widget.prevModel);
      paymentClause = widget.prevModel?.paymentclause;

      selectProcess(widget.prevModel.process, widget.prevModel);
      selectLevel(widget.prevModel?.rolename, widget.prevModel);

      jobId = widget.prevModel?.id;

      spoc = widget.prevModel?.spoc;

      enableShortListFor = false;

      bindProccessLevelList(widget.prevModel.compnayid.toString());
    }
    enableProcess = false;
    enableLevel = false;
    setState(() {});

    //bindShortList();
    bindCompanyList();
    bindUserDetails();
    //Navigator.pop(context);
    // bindProccessList();
    // bindLevelList();
  }

  selectProcess(process, extra) {
    processController.text = process;
    selectedProcess = AutoCompleteModel(process, process, extra);
  }

  selectLevel(level, extra) {
    levelController.text = level;
    selectedLevel = AutoCompleteModel(level, level, extra);
    ;
  }

  bindUserDetails() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    Utils.showLoaderDialog(context, "");
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromMap(dataResult);
      if (profilemodel.has_experience == 1) {
        // exprinceActive = 1;
        fresherActive = 0;
      } else {
        exprinceActive = 0;
        // fresherActive = 1;
      }
      if (profilemodel.education != null) {
        if (profilemodel.education?.toLowerCase() == 'under graduate') {
          underGradActive = 1;
          graduateActive = 0;
        } else {
          underGradActive = 0;
          graduateActive = 1;
        }
      }

      if (profilemodel.cv_link != null) {
        profileCv.profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
        profileCv.profile_cv_file =
            Utils.getFileName(profileCv.profile_cv_link);
        profileCv.cv_upladted_date = profilemodel.cv_upladted_date;
        profileCv.cv_link = profilemodel.cv_link;
      }
    }
    Navigator.pop(context);
    setState(() {});
  }

  // bindShortList() async {
  //   var result = await MasterService().masterGetByGroup(
  //       {'groupName': 'cmp_short', 'pageNumber': '1', 'pageSize': '500'});
  //   if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
  //     ddlValues = Utils.parseResponse(result).resultData;
  //     // list=ddlValues["content"];

  //     shortList = (ddlValues["content"] as List)
  //         .map<AutoCompleteModel>(
  //             (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
  //         .toList();

  //     setState(() {
  //       selectedshort = AutoCompleteModel("0", "", {});
  //     });
  //   }
  // }

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

  resetProcessLevel() {
    setState(() {
      selectedProcess = AutoCompleteModel("0", "", {});
      selectedLevel = AutoCompleteModel("0", "", {});
      processController.text = "";
      levelController.text = "";
    });
  }

  // bindLevelList() async {
  //   var result = await MasterService().masterGetByGroup(
  //       {'groupName': 'job_title', 'pageNumber': '1', 'pageSize': '10'});
  //   if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
  //     ddlValues = Utils.parseResponse(result).resultData;
  //     // list=ddlValues["content"];

  //     levelList = (ddlValues["content"] as List)
  //         .map<AutoCompleteModel>(
  //             (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
  //         .toList();

  //     setState(() {
  //       selectedLevel = AutoCompleteModel("0", "", {});
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('New Resume'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                enabled: (userType == EUserType.jobSeeker.value ? false : true),
                controller: applicationname,
                decoration: const InputDecoration(
                  // icon: Icon(Icons.person),
                  label: Text("Application Name"),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: 'Enter appilcation name',
                ),
              ),
              TextFormField(
                maxLength: 10,
                enabled: (userType == EUserType.jobSeeker.value ? false : true),
                controller: contactno,
                decoration: const InputDecoration(
                  // icon: Icon(Icons.person),
                  label: Text("Contact No"),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: 'Enter conctact no',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.topLeft, child: Text('Qualification')),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            underGradActive = 1;
                            graduateActive = 0;
                          });
                        },
                        child: Text(
                          'Under-Graduate',
                          style: TextStyle(
                              color: underGradActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: underGradActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            underGradActive = 0;
                            graduateActive = 1;
                          });
                        },
                        child: Text(
                          'Graduate',
                          style: TextStyle(
                              color: graduateActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: graduateActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Work Experience')),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            exprinceActive = 1;
                            fresherActive = 0;
                          });
                        },
                        child: Text(
                          'Exprience',
                          style: TextStyle(
                              color: exprinceActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: exprinceActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            exprinceActive = 0;
                            fresherActive = 1;
                          });
                        },
                        child: Text(
                          'Fresher',
                          style: TextStyle(
                              color: fresherActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: fresherActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              TextFormField(
                controller: shorListController,
                enabled: enableShortListFor,
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          dialogTitle: "Company Details",
                          onSelected: (AutoCompleteModel model) => {
                            shorListController.text = model.label,
                            selectedshort = model,
                            Navigator.pop(context),
                            if (userType == EUserType.businessPartner.value)
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
                      });
                }),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    // Icons.workspace_premium
                    label: Text("Applied For"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: "Select Company",
                    prefixIcon: Icon(Icons.list)),
              ),
              TextFormField(
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
                    label: Text("Proccess"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: "Select proccess",
                    prefixIcon: Icon(Icons.circle_outlined)),
              ),

              TextFormField(
                controller: levelController,
                enabled: enableLevel,
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          dialogTitle: "Level Details",
                          onSelected: (AutoCompleteModel model) => {
                            levelController.text = model.label,
                            selectedLevel = model,
                            Navigator.pop(context)
                          },
                          itemsData: levelList
                              .where((element) =>
                                  element.extra['process_name'] ==
                                  selectedProcess.value)
                              .toList(),
                        );
                      });
                }),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    // Icons.workspace_premium
                    label: Text("Level"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: "Select level",
                    prefixIcon: Icon(Icons.person)),
              ),
              // CustomControls.AutoCompleteCustom(
              //     context,
              //     "Level",
              //     "Select level",
              //     ((AutoCompleteModel item) => {
              //           setState(() {
              //             selectedlevel = item;
              //           }),
              //           // print(selectedEducation.label),
              //         }),
              //     selectedlevel,
              //     levelList,
              //     Icons.label),
              // const SizedBox(
              //   height: 30,
              // ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CVWidget(
                      profileCv: profileCv,
                      // cv_link: profileCv['cv_link'],
                      // cv_upladted_date: profileCv['cv_upladted_date'],
                      // profile_cv_file: profileCv['profile_cv_file'],
                      // profile_cv_link: profileCv['profile_cv_link'],
                      onUpload: (fileName, payload) async => {
                            setState(
                              () => {},
                            )
                            // await saveProfile(fileName, payload)
                          }),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ThemeButton(
                width: 200,
                radious: 0,
                onPressed: () {
                  save();
                },
                text: "SUBMIT",
                themeButtonSize: ThemeButtonSize.small,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  openCompanyJobsDetails() async {
    Map<String, String> params = {"companyid": selectedshort.value};

    var result = await JobSearchService().getDistinctProcessAndLevels(params);
    var resultData = Utils.parseResponse(result);
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

  save() async {
    Utils.showLoaderDialog(context, "Saving...");
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var userId =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    var param = {
      "applicantName": applicationname.text.trim(),
      "companyName": selectedshort.label,
      "contactNo": int.parse(contactno.text.trim()),
      "id": leadID,
      "jobid": jobId,
      "level": selectedLevel.value,
      "levelId": 0,
      "doj": "2022-06-24T17:23:36.161Z",
      "process": selectedProcess.value,
      "processId": 0,
      "qualification": underGradActive == 1 ? 'Under Graduate' : 'Graduate',
      "isExperienced": exprinceActive,
      "resume": profileCv.cv_link ?? "",
      "shortListFor": int.parse(selectedshort.value),
      "sourceId": (userType == EUserType.businessPartner.value ||
              userType == EUserType.employee.value
          ? userId
          : 0),
      "attr_status": "",
      "exp_max": 0,
      "sp_inv_no": "",
      "sp_payout": "",
      "sp_payment_status": "",
      "exp_min": 0,
      "completeStatus": 0,
      "status": 0,
      "remark": "",
      "paymentClause": paymentClause,
      "spoc": spoc,
      "uid": (userType == EUserType.businessPartner.value ||
              userType == EUserType.employee.value
          ? userId
          : 0),
    };

    var result = await ApplicationService().saveApplication(param);
    var apiresult = Utils.parseResponse(result);
    if (apiresult.resultKey == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Request has been submitted successfully"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(apiresult.errorMessage),
      ));
    }
    Navigator.pop(context);
  }

  saveProfile(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    var parseResult = Utils.parseResponse(result);
    if (parseResult.resultKey == 'SUCCESS') {
      leadID = parseResult.resultData.id;
      profileCv.cv_link = filePath;
      profileCv.profile_cv_link = Utils.resolveImage(profileCv.cv_link);
      profileCv.profile_cv_file = Utils.getFileName(profileCv.profile_cv_link);
      profileCv.cv_upladted_date =
          DateFormat('MMM dd, yyyy').format(DateTime.now());
    }
    setState(() {});
  }
}
