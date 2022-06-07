import 'package:flutter/material.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/utils.dart';
import '../components/autocompletecustom.dart';
import '../components/theme_button.dart';
import '../enums/enums.dart';
import '../models/autocompleteModel.dart';
import '../service/UserDataService.dart';
import '../themes/colors.dart';

class MasterOfMaster extends StatefulWidget {
  const MasterOfMaster({Key? key}) : super(key: key);

  @override
  State<MasterOfMaster> createState() => _MasterOfMasterState();
}

class _MasterOfMasterState extends State<MasterOfMaster> {
  final formKey = GlobalKey<FormState>();
  var ddlValues;
  int id = 0;
  late List<AutoCompleteModel> groupList = [];
  AutoCompleteModel selectedGroup = AutoCompleteModel("", "", {});
  TextEditingController textValue = TextEditingController();
  bool? isActive = true;

  @override
  void initState() {
    bindGroups();
    super.initState();
  }

  bindGroups() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'location', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      groupList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedGroup = AutoCompleteModel("0", "", {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Master Of Master'),
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
                if (formKey.currentState!.validate()) {
                  save();
                }
              },
              text: "Save",
              themeButtonSize: ThemeButtonSize.medium,
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomControls.AutoCompleteCustom(
                  context,
                  "Group",
                  "Enter group name",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedGroup = item;
                        }),
                      }),
                  selectedGroup,
                  groupList,
                  Icons.location_city,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty && !value.contains(' ')) {
                      return 'Please selected any group';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autofocus: true,
                  controller: textValue,
                  onChanged: ((value) => {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    label: Text("Enter your value"),
                    border: InputBorder.none,
                    hintText: 'Please enter value',
                  ),
                ),
                Row(
                  children: [
                    const Text('Active'),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: isActive,
                      onChanged: (bool? value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  save() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var params = {
      "active": isActive,
      "code": "string",
      "deleted": 0,
      "group_name": selectedGroup.value,
      "id": 0,
      "order": 0,
      "parentid": 0,
      "url_slug": "",
      "value": textValue.text
    };
    var result = await MasterService().saveMaster(params);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      // Message Box
    }
    setState(() {});
  }
}
