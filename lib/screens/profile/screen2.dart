import 'package:flutter/material.dart';
import 'package:job_circle/components/smart_card.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../components/autocompletecustom.dart';
import '../../components/autolistviewmodal.dart';
import '../../models/autocompleteModel.dart';
import '../../models/card_model.dart';
import '../../service/UserDataService.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key, this.prevPageModel}) : super(key: key);
  final dynamic prevPageModel;
  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  int _widgetId = 2;
  late Widget previousWidget;
  late TextEditingController educationController = TextEditingController();
  late TextEditingController passingYearController = TextEditingController();
  late TextEditingController universityController = TextEditingController();
  late TextEditingController degreeController = TextEditingController();
  CardModel model = CardModel();

  var ddlValues;
  late List<AutoCompleteModel> levelOfEducationList = [];
  late List<AutoCompleteModel> universityInstitueList = [];
  late List<AutoCompleteModel> degreeList = [];
  AutoCompleteModel selectedEducation = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedUniversity = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedDegree = AutoCompleteModel("", "", {});

  @override
  void initState() {
    bindLevelOfEducation();
    bindUniversityEducation();
    bindDegree();
    if (widget.prevPageModel != null) {
      selectedEducation = AutoCompleteModel(
          widget.prevPageModel.education_id.toString(),
          widget.prevPageModel.education, {});
      educationController.text = widget.prevPageModel.education.toString();

      selectedUniversity = AutoCompleteModel(
          widget.prevPageModel.univercity_id.toString(),
          widget.prevPageModel.univercity, {});
      universityController.text = widget.prevPageModel.univercity.toString();

      selectedDegree = AutoCompleteModel(
          widget.prevPageModel.degree_spc_id.toString(),
          widget.prevPageModel.degree_spc ?? '', {});
      degreeController.text = widget.prevPageModel.degree_spc.toString();
      passingYearController.text = widget.prevPageModel.passing_year.toString();
    }
    super.initState();
  }

  bindLevelOfEducation() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'level_education', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      levelOfEducationList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        //selectedEducation = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindUniversityEducation() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'university', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      universityInstitueList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedUniversity = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindDegree() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'degree', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      degreeList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedDegree = AutoCompleteModel("0", "", {});
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
                "assets/images/education.png",
                height: 30,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Education",
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
              text: widget.prevPageModel == null ? "NEXT" : "Save",
              themeButtonSize: ThemeButtonSize.medium,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SmartCard(model: model),
              ),
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // CustomControls.AutoCompleteCustom(
              //     context,
              //     "Level Of Education",
              //     "Enter Level Of Education",
              //     ((AutoCompleteModel item) => {
              //           setState(() {
              //             selectedEducation = item;
              //           }),
              //           // print(selectedEducation.label),
              //         }),
              //     selectedEducation,
              //     levelOfEducationList,
              //     Icons.school_outlined),
              TextFormField(
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select any job location';
                //   }
                // },
                controller: educationController,
                enabled: true,
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          tile: null,
                          dialogTitle: "Level Of Education",
                          onSelected: (AutoCompleteModel model) => {
                            educationController.text = model.label,
                            selectedEducation = model,
                            Navigator.pop(context)
                          },
                          itemsData: levelOfEducationList,
                        );
                      });
                }),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    // Icons.workspace_premium
                    label: Text("Level Of Education"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: "Select level of education",
                    prefixIcon: Icon(Icons.school_outlined)),
              ),
              const SizedBox(height: 10),
              // CustomControls.AutoCompleteCustom(
              //     context,
              //     "University / Institute",
              //     "Enter college name",
              //     ((AutoCompleteModel item) => {
              //           setState(() {
              //             selectedUniversity = item;
              //           }),
              //           // print(selectedEducation.label),
              //         }),
              //     selectedUniversity,
              //     universityInstitueList,
              //     Icons.school_sharp),
              TextFormField(
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select any job location';
                //   }
                // },
                controller: universityController,
                enabled: true,
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          tile: null,
                          dialogTitle: "University / Institute",
                          onSelected: (AutoCompleteModel model) => {
                            universityController.text = model.label,
                            selectedUniversity = model,
                            Navigator.pop(context)
                          },
                          itemsData: universityInstitueList,
                        );
                      });
                }),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    // Icons.workspace_premium
                    label: Text("University / Institute"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: "Select university / institute",
                    prefixIcon: Icon(Icons.school_sharp)),
              ),
              const SizedBox(height: 10),
              // CustomControls.AutoCompleteCustom(
              //     context,
              //     "Degree / Specialization",
              //     "Enter degree",
              //     ((AutoCompleteModel item) => {
              //           setState(() {
              //             selectedDegree = item;
              //           }),
              //           // print(selectedEducation.label),
              //         }),
              //     selectedDegree,
              //     degreeList,
              //     Icons.cast_for_education),
              TextFormField(
                controller: degreeController,
                enabled: true,
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogList(
                          tile: null,
                          dialogTitle: "Degree / Specialization",
                          onSelected: (AutoCompleteModel model) => {
                            degreeController.text = model.label,
                            selectedDegree = model,
                            Navigator.pop(context)
                          },
                          itemsData: degreeList,
                        );
                      });
                }),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    // Icons.workspace_premium
                    label: Text("Degree / Specialization"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: "Select degree / specialization",
                    prefixIcon: Icon(Icons.cast_for_education)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                // ],
                controller: passingYearController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: ((value) => {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid first and last name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month),
                  label: Text("Passing Year"),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: 'Please enter year of passing',
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  save() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().saveUserStages({
      "stage": "education",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "education": selectedEducation.value,
        "degree_spc": selectedDegree.value,
        "university": selectedUniversity.value,
        "passing_year": passingYearController.text,
      }
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (widget.prevPageModel == null) {
        Navigator.pushNamed(context, ERoute.screen3.name);
      } else {
        if (selectedEducation.label.isNotEmpty) {
          widget.prevPageModel.education = selectedEducation.label;
          widget.prevPageModel.education_id =
              int.parse(selectedEducation.value);
        }

        if (selectedUniversity.label.isNotEmpty) {
          widget.prevPageModel.univercity = selectedUniversity.label;
          widget.prevPageModel.univercity_id =
              int.parse(selectedUniversity.value);
        }

        if (selectedDegree.label.isNotEmpty) {
          widget.prevPageModel.degree_spc = selectedDegree.label;
          widget.prevPageModel.degree_spc_id = int.parse(selectedDegree.value);
        }
        if (passingYearController.text != "") {
          widget.prevPageModel.passing_year =
              int.parse(passingYearController.text);
        }

        Navigator.pop(context, widget.prevPageModel);
      }
      Utils.setCacheData('education', int.parse(selectedEducation.value));
    }
    setState(() {});
  }
}
