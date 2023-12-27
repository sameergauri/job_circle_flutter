// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, use_build_context_synchronously, avoid_print
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../service/masterService.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm(
      {super.key,
      this.isnew = false,
      this.refer,
      this.cmpnyname,
      this.process,
      this.level});

  final bool? isnew;
  final bool? refer;
  final String? cmpnyname;
  final String? process;
  final String? level;

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
  dynamic prevModel;

  TextEditingController contactno = TextEditingController();
  TextEditingController applicationname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController shorListController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController interviewController = TextEditingController();
  TextEditingController processController = TextEditingController();
  TextEditingController dateOfSelection = TextEditingController();
  TextEditingController dateOfJoin = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  var dtSelection;
  var dtDOJ;

  bool isGraduatValidate = false;
  bool isExpValidate = false;

  var ddlValues;
  late int userType = -1;
  late String role = "0";
  late List<AutoCompleteModel> shortList = [];
  late List<AutoCompleteModel> proccessList = [];
  late List<AutoCompleteModel> levelList = [];
  late List<AutoCompleteModel> statusList = [];
  late List<AutoCompleteModel> interviewList = [];
  AutoCompleteModel selectedshort = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedProcess = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedLevel = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedStatus = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedInterview = AutoCompleteModel("", "", {});
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();

   GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

  // dynamic applicantName = {};
  String mobileno = "";
  dynamic localStoregData;
  dynamic userinfo;

  ProfileCv profileCv = ProfileCv();

  var enableApplicantName = true;

  var enableContactNo = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamic args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args["isnew"] != true) {
        if (args["refer"] == true) {
          enableApplicantName = false;
          enableContactNo = false;

          bindUserDetails();
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
    // Bind All Dropdown

    // profileCv.profile_cv_file = "abc.pdf";
    // profileCv.cv_link = "abc.pdf";
    // profileCv.cv_upladted_date = "2033";
    // profileCv.profile_cv_link = "lin";

    enableProcess = false;
    enableLevel = false;
    setState(() {});

    //bindShortList();
    bindCompanyList();
    if (widget.isnew != true) {
      // bindUserDetails();
    }

    bindStatusList();
    bindInterViewList();
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
  }

  bindUserDetails() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    Utils.showLoaderDialog(context, "");
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromJson(dataResult);
      applicationname.text = profilemodel.first_name.toString().toTitleCase();
      lastname.text = profilemodel.last_name.toString().toTitleCase();
      contactno.text = profilemodel.mobile.toString();

      /*  if (profilemodel.has_experience == 1) {
        exprinceActive = 1;
        fresherActive = 0;
      } else {
        exprinceActive = 0;
        fresherActive = 1;
      } */
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

  bindInterViewList() async {
    var result = await MasterService().masterGetByGroup({
      'groupName': 'interview_rounds',
      'pageNumber': '1',
      'pageSize': '100'
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      interviewList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedInterview = AutoCompleteModel("0", "", {});
      });
    }
  }

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
          child: Form(
            key: _formKey4,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  enabled: enableApplicantName,
                  controller: applicationname,
                  decoration: const InputDecoration(
                    // icon: Icon(Icons.person),
                    label: Text("First Name"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Enter first name',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  enabled: enableApplicantName,
                  controller: lastname,
                  decoration: const InputDecoration(
                    // icon: Icon(Icons.person),
                    label: Text("Last Name"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Enter last name',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact no';
                    } else if (value.length < 10) {
                      return 'Please enter valid contact no';
                    }
                    return null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 10,
                  enabled: enableContactNo,
                  controller: contactno,
                  decoration: const InputDecoration(
                    // icon: Icon(Icons.person),
                    label: Text("Contact *"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Enter conctact',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Qualification *')),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: userType == EUserType.jobSeeker.value
                              ? null
                              : () {
                                  setState(() {
                                    underGradActive = 1;
                                    graduateActive = 0;
                                    isGraduatValidate = false;
                                  });
                                },
                          style: ButtonStyle(
                            backgroundColor: underGradActive == 1
                                ? MaterialStateProperty.all(Colors.red)
                                : MaterialStateProperty.all(Colors.grey[300]),
                          ),
                          child: Text(
                            'Under-Graduate',
                            style: TextStyle(
                                color: underGradActive == 1
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: userType == EUserType.jobSeeker.value
                              ? null
                              : () {
                                  setState(() {
                                    underGradActive = 0;
                                    graduateActive = 1;
                                    isGraduatValidate = false;
                                  });
                                },
                          style: ButtonStyle(
                            backgroundColor: graduateActive == 1
                                ? MaterialStateProperty.all(Colors.red)
                                : MaterialStateProperty.all(Colors.grey[300]),
                          ),
                          child: Text(
                            'Graduate',
                            style: TextStyle(
                                color: graduateActive == 1
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: isGraduatValidate,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Qualification is required',
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Work Experience *')),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: userType == EUserType.jobSeeker.value
                              ? null
                              : () {
                                  setState(() {
                                    exprinceActive = 1;
                                    fresherActive = 0;
                                    isExpValidate = false;
                                  });
                                },
                          style: ButtonStyle(
                            backgroundColor: exprinceActive == 1
                                ? MaterialStateProperty.all(Colors.red)
                                : MaterialStateProperty.all(Colors.grey[300]),
                          ),
                          child: Text(
                            'Experience',
                            style: TextStyle(
                                color: exprinceActive == 1
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: userType == EUserType.jobSeeker.value
                              ? null
                              : () {
                                  setState(() {
                                    exprinceActive = 0;
                                    fresherActive = 1;
                                    isExpValidate = false;
                                  });
                                },
                          style: ButtonStyle(
                            backgroundColor: fresherActive == 1
                                ? MaterialStateProperty.all(Colors.red)
                                : MaterialStateProperty.all(Colors.grey[300]),
                          ),
                          child: Text(
                            'Fresher',
                            style: TextStyle(
                                color: fresherActive == 1
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: isExpValidate,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Work Experience is required',
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: shorListController,
                  enabled: enableShortListFor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select any company';
                    }
                    return null;
                  },
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
                        });
                  }),
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      // Icons.workspace_premium
                      label: Text("Company Name *"),
                      //border: OutlineInputBorder(),
                      border: InputBorder.none,
                      hintText: "Select Company",
                      prefixIcon: Icon(Icons.list)),
                ),
                TextFormField(
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
                ),

                TextFormField(
                  controller: levelController,
                  enabled: enableLevel,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select any Level';
                    }
                    return null;
                  },
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
                      label: Text("Level *"),
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
                // const SizedBox(
                //   height: 15,
                // ),
                // TextFormField(
                //   controller: statusController,
                //   enabled: true,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please select any status';
                //     }
                //   },
                //   onTap: (() {
                //     showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return DialogList(
                //               dialogTitle: "Status",
                //               onSelected: (AutoCompleteModel model) => {
                //                     statusController.text = model.label,
                //                     selectedStatus = model,
                //                     Navigator.pop(context)
                //                   },
                //               itemsData: statusList);
                //         });
                //     setState(() {
                //       statusController.text = selectedStatus.label;
                //     });
                //   }),
                //   decoration: const InputDecoration(
                //       suffixIcon: Icon(Icons.arrow_drop_down),
                //       label: Text("Status *"),
                //       border: InputBorder.none,
                //       hintText: "Select status",
                //       prefixIcon: Icon(Icons.person)),
                // ),
                // TextFormField(
                //   controller: interviewController,
                //   enabled: true,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please select any interview by';
                //     }
                //   },
                //   onTap: (() {
                //     showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return DialogList(
                //               dialogTitle: "Interview",
                //               onSelected: (AutoCompleteModel model) => {
                //                     interviewController.text = model.label,
                //                     selectedInterview = model,
                //                     Navigator.pop(context)
                //                   },
                //               itemsData: interviewList);
                //         });
                //   }),
                //   decoration: const InputDecoration(
                //       suffixIcon: Icon(Icons.arrow_drop_down),
                //       // Icons.workspace_premium
                //       label: Text("Interview bay *"),
                //       //border: OutlineInputBorder(),
                //       border: InputBorder.none,
                //       hintText: "Select interview",
                //       prefixIcon: Icon(Icons.person)),
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextFormField(
                //         controller: dateOfSelection,
                //         decoration: const InputDecoration(
                //           icon: Icon(Icons.calendar_month),
                //           label: Text("Date Of Selection"),
                //           //border: OutlineInputBorder(),
                //           border: InputBorder.none,
                //           hintText: 'Select Dos.',
                //         ),
                //         readOnly: true,
                //         onTap: () async {
                //           DateTime? pickedDate = await showDatePicker(
                //             context: context,
                //             initialDate: DateTime.now(),
                //             firstDate:
                //                 // DateTime.now().add(const Duration(days: -(365 * 50))),
                //                 DateTime.now(),
                //             lastDate:
                //                 DateTime.now().add(const Duration(days: 120)),
                //           );

                //           if (pickedDate != null) {
                //             String formattedDate =
                //                 DateFormat('yyyy-MM-dd').format(pickedDate);
                //             setState(() {
                //               dateOfSelection.text = formattedDate;
                //               dtSelection = DateFormat('yyyy-MM-dd HH:mm:ss')
                //                   .format(pickedDate);
                //               //set output date to TextField value.
                //             });
                //           }
                //         },
                //       ),
                //     ),
                //     Expanded(
                //       child: TextFormField(
                //         controller: dateOfJoin,
                //         decoration: const InputDecoration(
                //           icon: Icon(Icons.calendar_month),
                //           label: Text("Date Of Joining"),
                //           //border: OutlineInputBorder(),
                //           border: InputBorder.none,
                //           hintText: 'Select Doj.',
                //         ),
                //         readOnly: true,
                //         onTap: () async {
                //           DateTime? pickedDate = await showDatePicker(
                //             context: context,
                //             initialDate: DateTime.now(),
                //             firstDate:
                //                 // DateTime.now().add(const Duration(days: -(365 * 50))),
                //                 DateTime.now(),
                //             lastDate:
                //                 DateTime.now().add(const Duration(days: 120)),
                //           );

                //           if (pickedDate != null) {
                //             String formattedDate =
                //                 DateFormat('yyyy-MM-dd').format(pickedDate);
                //             setState(() {
                //               dateOfJoin.text = formattedDate;
                //               dtDOJ = DateFormat('yyyy-MM-dd HH:mm:ss')
                //                   .format(pickedDate);
                //               //set output date to TextField value.
                //             });
                //           }
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                // Visibility(
                //   visible: statusController.text == 'Join' ? true : false,
                //   child: TextFormField(
                //     validator: (val) {
                //       if (val == null && statusController.text != 'Join') {
                //         return 'Remark is required';
                //       }
                //     },
                //     decoration: const InputDecoration(
                //       icon: Icon(Icons.person),
                //       label: Text("Remark *"),
                //       //border: OutlineInputBorder(),
                //       border: InputBorder.none,
                //       hintText: 'Please enter reson for not joining',
                //     ),
                //     controller: remarkController,
                //   ),
                // ),
                const SizedBox(
                  height: 30,
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
                  height: 40,
                ),
                ThemeButton(
                  width: 200,
                  radious: 0,
                  onPressed: () async {
                    bool issuccess = await save();
                    if (issuccess) {
                      Navigator.pop(context, "refresh");
                    }
                  },
                  text: "SUBMIT",
                  themeButtonSize: ThemeButtonSize.small,
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
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
    bool validate = _formKey4.currentState!.validate();

    if (graduateActive == 0 && underGradActive == 0) {
      setState(() {
        isGraduatValidate = true;
      });
    }
    if (exprinceActive == 0 && fresherActive == 0) {
      setState(() {
        isExpValidate = true;
      });
    }
    if (!validate) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all the details"),
        backgroundColor: Color.fromARGB(255, 153, 10, 0),
      ));
      return;
    }
    if (selectedLevel.value == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select level details"),
        backgroundColor: Color.fromARGB(255, 153, 10, 0),
      ));
      return;
    }
    if (selectedProcess.value == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select process details"),
        backgroundColor: Color.fromARGB(255, 153, 10, 0),
      ));
      return;
    }

    if (profileCv.cv_link == null || profileCv.cv_link == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please upload Resume first"),
        backgroundColor: Color.fromARGB(255, 153, 10, 0),
      ));
      return;
    }

    if (_formKey4.currentState!.validate() &&
        !isGraduatValidate &&
        !isExpValidate) {
      Utils.showLoaderDialog(context, "Saving...");
      SharedPreferences prefs = await Utils.getSharedPreferences();
      var userId = await Utils.getPreferencesValue(
          prefs, ESharedPreferences.user_id.name);
      var param = {"jobid": jobId, "userid": userId};

      var result = await ApplicationService().saveApplication(param);
      var apiresult = Utils.parseResponse(result);
      Navigator.pop(context);
      if (apiresult.resultKey == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Request has been submitted successfully"),
        ));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(apiresult.errorMessage),
        ));
        return false;
      }

      // Navigator.popAndPushNamed(context, "refresh");
      // return Future(() => false);
    }
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
