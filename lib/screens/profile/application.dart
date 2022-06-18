import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/autocomplete.dart';
import 'package:job_circle/service/applicationService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/autocompletecustom.dart';
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

  TextEditingController contactno = TextEditingController();
  TextEditingController applicationname = TextEditingController();

  var ddlValues;
  late List<AutoCompleteModel> shortList = [];
  late List<AutoCompleteModel> proccessList = [];
  late List<AutoCompleteModel> levelList = [];
  AutoCompleteModel selectedshort = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedproccess = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedlevel = AutoCompleteModel("", "", {});

  // dynamic applicantName = {};
  String mobileno = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Bind All Dropdown
    bindShortList();
    bindProccessList();
    bindLevelList();

    if (widget.prevModel != null) {
      applicationname.text = widget.prevModel.name;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print(await Utils.getPreferencesValue(
          null, ESharedPreferences.user_data.name));
      mobileno = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_mobile.name);
      contactno.text = mobileno;
      setState(() {});
    });
  }

  bindShortList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'cmp_short', 'pageNumber': '1', 'pageSize': '10'});
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

  bindProccessList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'appl_status', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      proccessList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedproccess = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindLevelList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'job_title', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      levelList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedlevel = AutoCompleteModel("0", "", {});
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
          child: Column(
            children: [
              TextField(
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
              CustomControls.AutoCompleteCustom(
                  context,
                  "Shortlist For",
                  "Select shortlist",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedshort = item;
                        }),
                        // print(selectedEducation.label),
                      }),
                  selectedshort,
                  shortList,
                  // onClick: () => {showCompanyDialog(context)},
                  Icons.list),
              CustomControls.AutoCompleteCustom(
                  context,
                  "Proccess",
                  "Select proccess",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedproccess = item;
                        }),
                        // print(selectedEducation.label),
                      }),
                  selectedproccess,
                  proccessList,
                  Icons.circle_outlined),
              CustomControls.AutoCompleteCustom(
                  context,
                  "Level",
                  "Select level",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedlevel = item;
                        }),
                        // print(selectedEducation.label),
                      }),
                  selectedlevel,
                  levelList,
                  Icons.label),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload your resume'),
                  )
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

/*
  showCompanyDialog(context) {
    BottomDialog().showBottomDialog(
        enableDrag: true,
        context,
        IntrinsicHeight(
          child: Container(
              width: double.maxFinite,
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    height: 7,
                    width: 60,
                  ),
                  Material(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 120,
                          width: double.infinity,
                        ),
                        // ThemeButton(
                        //   onPressed: () {},
                        //   text: "APPLY",
                        //   width: 130,
                        //   radious: 5,
                        //   themeButtonSize:
                        //       ThemeButtonSize
                        //           .small,
                        // )
                      ])),
                ],
              )),
        ),
        true);
  }
*/
  save() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await ApplicationService().saveApplication({
      "applicantName": applicationname.text.trim(),
      "contactNo": contactno.text.trim(),
      "experience": "string",
      "id": 0,
      "level": selectedlevel.value,
      "process": selectedproccess.value,
      "qualification": "string",
      "resume": "string",
      "shortListFor": selectedshort.value,
      "sourceId": await Utils.getPreferencesValue(
          prefs, ESharedPreferences.user_id.name),
      "uid": await Utils.getPreferencesValue(
          prefs, ESharedPreferences.user_id.name)
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {}
  }
}
