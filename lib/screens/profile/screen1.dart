import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/autocompletecustom.dart';
import 'package:job_circle/components/smart_card.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

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
  AutoCompleteModel selectedLocation = AutoCompleteModel("", "", {});

  @override
  void initState() {
    super.initState();
    bindLocation();
    dateOfBirth.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  bindLocation() async {
    var result = await UserDataService().masterGetByGroup(
        {'groupName': 'location', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      jobLocationList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        selectedLocation = AutoCompleteModel("0", "", {});
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

  final spaceMatch = RegExp(r"^[A-Z][a-z]+\s[A-Z][a-z]+$");
  Widget basicInfo() {
    return Container(
      key: const Key('second'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicForm,
            child: Column(
              children: [
                TextFormField(
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                  // ],
                  controller: username,
                  onChanged: ((value) => {
                        model.cardName = value,
                        updateCard(model),
                      }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid first and last name';
                    } else if (!spaceMatch.hasMatch(username.text.trim())) {
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
                        firstDate: DateTime.now().add(const Duration(days: -(365*50))),
                        lastDate: DateTime.now(),
                        );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
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
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 150.0,
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.green,
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/male.png',
                                scale: 11,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio(
                                    value: "MALE",
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value.toString();
                                      });
                                    },
                                  ),
                                  const Text(
                                    "MALE",
                                    style: TextStyle(fontSize: 18),
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
                      height: 100,
                      width: 150.0,
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.green,
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/female.png',
                                scale: 11,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio(
                                    value: "FEMALE",
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value.toString();
                                      });
                                    },
                                  ),
                                  const Text(
                                    "FEMALE",
                                    style: TextStyle(fontSize: 18),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateCard(CardModel items) {
    model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
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
      final spaceMatch = RegExp(r"^[A-Z][a-z]+\s[A-Z][a-z]+$");

      if (!spaceMatch.hasMatch(username.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter valid name"),
        ));
        return;
      }
    }

    var firstName = username.text.trim().split(' ')[0];
    var lastName = username.text.trim().split(' ')[1];

    var result = await UserDataService().saveUserStages({
      "stage": "basic_info",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "mobile": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_mobile.name),
        "first_name": firstName,
        "last_name": lastName,
        "job_location_id": selectedLocation.value,
        "email": emailadr.text,
        "gender": gender,
        "usertype": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_type.name),
      }
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      Navigator.pushNamed(context, ERoute.screen2.name);
    }
    setState(() {});
    print(Utils.parseResponse(result));
  }
}
