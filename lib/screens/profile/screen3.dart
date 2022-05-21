import 'package:flutter/material.dart';
import 'package:job_circle/components/smart_card.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../components/autocompletecustom.dart';
import '../../models/autocompleteModel.dart';
import '../../models/card_model.dart';
import '../../service/UserDataService.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  int _widgetId = 2;
  late Widget previousWidget;
  CardModel model = CardModel();
  bool expirieanceFlag = false;

  var ddlValues;
  late TextEditingController companyController = TextEditingController();
  late List<AutoCompleteModel> jobTitleList = [];
  late List<AutoCompleteModel> totalExperienceList = [];
  late List<AutoCompleteModel> currentSalaryList = [];
  AutoCompleteModel selectedJobTitle = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedtotalExperience = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedcurrentSalary = AutoCompleteModel("", "", {});

  @override
  void initState() {
    bindJobTitle();
    bindTotalExperiance();
    bindCurrentSalary();
    super.initState();
  }

  bindJobTitle() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'job_title', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      jobTitleList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedJobTitle = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindTotalExperiance() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'total_exp', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      totalExperienceList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedtotalExperience = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindCurrentSalary() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'current_salary', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      currentSalaryList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedcurrentSalary = AutoCompleteModel("0", "", {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/experience.png",
                height: 30,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Experience",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Constants.bgPanelColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ThemeButton(
              icon: const Icon(
                Icons.arrow_forward,
                color: Color(0xffffffff),
                size: 25,
              ),
              radious: 0,
              onPressed: () {
                save();
              },
              text: "NEXT",
              themeButtonSize: ThemeButtonSize.medium,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SmartCard(model: model),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 39, 39, 39),
                              blurRadius: 17.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                          color: Constants.bgPanelColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      //child:
                      // Card(
                      //     shape: BeveledRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     elevation: 4,
                      //     child: const Padding(
                      //       padding: EdgeInsets.all(20.0),
                      //       child: SizedBox(
                      //         child: Text("teddd"),
                      //         height: 200,
                      //       ),
                      //     )),,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  _education(),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // AnimatedSwitcher(
                    //   duration: const Duration(milliseconds: 500),
                    //   switchInCurve: Curves.easeIn,
                    //   switchOutCurve: Curves.easeOut,
                    //   // child: _renderWidget(),

                    //   transitionBuilder: (child, animation) {
                    //     return SlideTransition(
                    //       position: Tween<Offset>(
                    //               begin: Offset(1.2, 0), end: Offset(0, 0))
                    //           .animate(animation),
                    //       child: child,
                    //     );
                    //   },
                    //   // layoutBuilder: (currentChild, _) {
                    //   //   return currentChild!;
                    //   // },
                    //   child: _renderWidget(),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _education() {
    return Container(
      key: const Key('second'),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Do you have any work experience?",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ThemeButton(
                    width: 100,
                    onPressed: () {
                      setState(() {
                        expirieanceFlag = true;
                      });
                    },
                    themeButtonSize: ThemeButtonSize.xsmall,
                    radious: 0,
                    text: "YES",
                    isText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ThemeButton(
                    width: 100,
                    onPressed: () {
                      setState(() {
                        expirieanceFlag = false;
                      });
                    },
                    themeButtonSize: ThemeButtonSize.xsmall,
                    radious: 0,
                    text: "NO",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: expirieanceFlag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: companyController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.location_city),
                      label: Text("Company Name"),
                      // border: OutlineInputBorder(),
                      hintText: 'Enter company name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomControls.AutoCompleteCustom(
                      context,
                      "Job title",
                      "Enter Job title",
                      ((AutoCompleteModel item) => {
                            setState(() {
                              selectedJobTitle = item;
                            }),
                            // print(selectedEducation.label),
                          }),
                      selectedJobTitle,
                      jobTitleList),
                  const SizedBox(height: 10),
                  CustomControls.AutoCompleteCustom(
                      context,
                      "Total Years Of Experience",
                      "Enter total experience",
                      ((AutoCompleteModel item) => {
                            setState(() {
                              selectedtotalExperience = item;
                            }),
                            // print(selectedEducation.label),
                          }),
                      selectedtotalExperience,
                      totalExperienceList),
                  const SizedBox(height: 20),
                  CustomControls.AutoCompleteCustom(
                      context,
                      "Current Salary",
                      "Enter current salary",
                      ((AutoCompleteModel item) => {
                            setState(() {
                              selectedcurrentSalary = item;
                            }),
                            // print(selectedEducation.label),
                          }),
                      selectedcurrentSalary,
                      currentSalaryList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  save() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().saveUserStages({
      "stage": "experiene",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "experience": selectedtotalExperience.value,
        "job_title": selectedJobTitle.value,
        "work_experience": selectedtotalExperience.value,
        "company_name": companyController.text
      }
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      Navigator.pushNamedAndRemoveUntil(
          context, ERoute.home.name, (Route<dynamic> route) => false);
    }
    setState(() {});
  }
}
