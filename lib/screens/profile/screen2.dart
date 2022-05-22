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

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  int _widgetId = 2;
  late Widget previousWidget;
  late TextEditingController educationController = TextEditingController();
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
    super.initState();
  }

  bindLevelOfEducation() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'level_education', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      levelOfEducationList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedEducation = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindUniversityEducation() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'university', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      universityInstitueList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedUniversity = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindDegree() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'degree', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      degreeList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedDegree = AutoCompleteModel("0", "", {});
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
              CustomControls.AutoCompleteCustom(
                  context,
                  "Level Of Education",
                  "Enter Level Of Education",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedEducation = item;
                        }),
                        // print(selectedEducation.label),
                      }),
                  selectedEducation,
                  levelOfEducationList,
                  Icons.school_outlined),
              const SizedBox(height: 10),
              CustomControls.AutoCompleteCustom(
                  context,
                  "University / Institute",
                  "Enter college name",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedUniversity = item;
                        }),
                        // print(selectedEducation.label),
                      }),
                  selectedUniversity,
                  universityInstitueList,
                  Icons.school_sharp),
              const SizedBox(height: 10),
              CustomControls.AutoCompleteCustom(
                  context,
                  "Degree / Specialization",
                  "Enter degree",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedDegree = item;
                        }),
                        // print(selectedEducation.label),
                      }),
                  selectedDegree,
                  degreeList,
                  Icons.cast_for_education),
              const SizedBox(height: 10),
              TextFormField(
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                // ],
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
        // "passing_year": emailadr.text,
      }
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      Navigator.pushNamed(context, ERoute.screen3.name);
    }
    setState(() {});
  }
}
