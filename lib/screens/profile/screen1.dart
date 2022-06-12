import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/autocompletecustom.dart';
import 'package:job_circle/components/smart_card.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key, this.prevPageModel}) : super(key: key);
  final dynamic prevPageModel;

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late Widget previousWidget;

  // Veriable Declaration
  // DropdownModel ddlModel;
  List locationList = [];
  CardModel model = CardModel();
  TextEditingController username = TextEditingController();
  TextEditingController joblocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  var dt;

  int locationid = 0;

  String gender = "";
  var ddlValues;

  late List list;

  final basicForm = GlobalKey<FormState>();

  late List<AutoCompleteModel> jobLocationList = [];
  late List languageList = [];
  AutoCompleteModel selectedLocation = AutoCompleteModel("", "", {});

  @override
  void initState() {
    super.initState();
    bindLocation();
    dateOfBirth.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    if (widget.prevPageModel != null) {
      username.text = widget.prevPageModel.first_name +
          " " +
          widget.prevPageModel.last_name;
      selectedLocation = widget.prevPageModel.job_location_city == null
          ? AutoCompleteModel("", "", {})
          : AutoCompleteModel(widget.prevPageModel.job_location_id.toString(),
              widget.prevPageModel.job_location_city, {});
      emailadr.text = widget.prevPageModel.email.toString();
      gender = widget.prevPageModel.gender.toString();
    }
  }

  bindLocation() async {
    var result = await MasterService().masterGetByGroups({
      'groupName': 'location,language',
      'pageNumber': '1',
      'pageSize': '1000'
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      for (var e in (ddlValues["content"] as List)) {
        if (e['group_name'] == 'location') {
          jobLocationList
              .add(AutoCompleteModel(e['id'].toString(), e['value'], e));
        } else if (e['group_name'] == 'language') {
          e['checked'] = false;
          languageList.add(e);
        }
      }
      languageList.sort((a, b) => a['order'].compareTo(b['order']));
      setState(() {});
      // jobLocationList =
      //     .map<AutoCompleteModel>(
      //         (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
      //     .toList();
      final productId = ModalRoute.of(context)!.settings.arguments;

      // 07/06/2022
      // print(productId);
      // setState(() {
      //   selectedLocation = AutoCompleteModel("0", "", {});
      // });
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
                "assets/images/id-card.png",
                height: 30,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Basic Info",
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
                if (basicForm.currentState!.validate()) {
                  save();
                }
              },
              text: widget.prevPageModel == null ? "NEXT" : "SAVE",
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
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // const Text(
                          //   "Basic Info",
                          //   style: TextStyle(
                          //     fontSize: 30,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  basicInfo(),
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

  Widget basicInfo() {
    return Container(
      key: const Key('second'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: true,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                  // ],
                  controller: username,
                  onChanged: ((value) => {
                        model.cardName = value.toTitleCase(),
                        // username.text = model.cardName!,
                        updateCard(model),
                      }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid first and last name';
                    } else if (!GlobalConstants.spaceMatch
                        .hasMatch(username.text.trim().toTitleCase())) {
                      return 'Please enter valid first and last name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    label: Text("Enter your name"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Please enter first and last name',
                  ),
                ),
                // const SizedBox(height: 10),
                // TextFormField(
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter Job city';
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     border: InputBorder.none,
                //     icon: Icon(Icons.location_city),
                //     label: Text("Job City"),
                //     // border: OutlineInputBorder(),
                //     hintText: 'Enter Job city',
                //   ),
                // ),
                const SizedBox(height: 10),
                CustomControls.AutoCompleteCustom(
                  context,
                  "Job Location",
                  "Enter Job Location",
                  ((AutoCompleteModel item) => {
                        setState(() {
                          selectedLocation = item;
                        }),
                        print(selectedLocation.label),
                      }),
                  selectedLocation,
                  jobLocationList,
                  Icons.location_city,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty && !value.contains(' ')) {
                      return 'Please enter valid job location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateOfBirth,
                  // validator: (value) {
                  //   if (value == null ||
                  //       value.isEmpty && !value.contains(' ')) {
                  //     return 'Please enter valid first and last name';
                  //   }
                  //   return null;
                  // },

                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month),
                    label: Text("Date Of Birth"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Please enter date of birth',
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().add(const Duration(days: -(365 * 50))),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateOfBirth.text = formattedDate;
                        dt = DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(pickedDate);
                        //set output date to TextField value.
                      });
                    } else {
                      // ignore: avoid_print
                      print("Date is not selected");
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  // initialValue: "+9004390874",
                  // enabled: false,
                  controller: emailadr,
                  onChanged: ((value) => {
                        model.email = value,
                        updateCard(model),
                      }),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.email),
                    label: Text("Email Address"),
                    //border: OutlineInputBorder(),
                    hintText: 'test@email.com',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty && !value.contains(' ')) {
                      return 'Please enter valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 150.0,
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.green,
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/male.png',
                                scale: 11,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                      scale: 0.8,
                                      child: Radio(
                                        value: "MALE",
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value.toString();
                                          });
                                        },
                                      )),
                                  const Text(
                                    "MALE",
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 60,
                      width: 150.0,
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.green,
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/female.png',
                                scale: 11,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                      scale: 0.8,
                                      child: Radio(
                                        value: "FEMALE",
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value.toString();
                                          });
                                        },
                                      )),
                                  const Text(
                                    "FEMALE",
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "Language Known",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Container(
                  child: ResponsiveGridRow(children: [
                    for (var s in languageList)
                      ResponsiveGridCol(
                        xs: 4,
                        md: 3,
                        child: CheckboxListTile(
                          title: Text(s['value'] ?? ''),
                          value: s['checked'],
                          onChanged: (newValue) {
                            s['checked'] = !s['checked'];
                            setState(() {});
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      )
                  ]),
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateCard(CardModel items) {
    model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    model.email = items.email;

    // model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    setState(() {});
  }

  save() async {
    // var result = await UserDataService().masterGetByGroup(
    //     {'groupName': 'location', 'pageNumber': '1', 'pageSize': '10'});
    // print(Utils.parseResponse(result).resultData);
    // return;
    SharedPreferences prefs = await Utils.getSharedPreferences();
    // prefs.setString('username', username.text);

    String userName = username.text;
    if (userName.isNotEmpty) {
      if (!GlobalConstants.spaceMatch
          .hasMatch(username.text.trim().toTitleCase())) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter valid name"),
        ));
        return;
      }
    }

    var firstName = username.text.trim().split(' ')[0];
    var lastName = username.text.trim().split(' ')[1];
    var mobilenumber = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_mobile.name);
    var selectedLanguages = languageList
        .where((element) => element['checked'] == true)
        .map((e) => e['value'])
        .toList();

    var params = {
      "stage": "basic_info",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "mobile": mobilenumber,
        "first_name": firstName,
        "last_name": lastName,
        "languages": selectedLanguages,
        "job_location_id": selectedLocation.value,
        "email": emailadr.text,
        "gender": gender,
        "dateofbirth": dateOfBirth.text,
        "usertype": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_type.name),
      }
    };

    CardModel model = CardModel();
    model.mobile = mobilenumber;
    model.cardName = (firstName + " " + lastName).toTitleCase();
    model.email = emailadr.text;
    var result = await UserDataService().saveUserStages(params);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (widget.prevPageModel == null) {
        await Utils.setPreference(
            prefs, ESharedPreferences.user_data.name, jsonEncode(model));
        Navigator.pushNamed(context, ERoute.screen2.name);
      } else {
        widget.prevPageModel.first_name = firstName;
        widget.prevPageModel.last_name = lastName;
        widget.prevPageModel.job_location_city = selectedLocation.label;
        widget.prevPageModel.job_location_id =
            int.parse(selectedLocation.value);
        widget.prevPageModel.gender = gender;

        Navigator.pop(context, widget.prevPageModel);
      }
    }
    setState(() {});
  }
}
