import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/smart_card.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/service/DataService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late Widget previousWidget;

  // Veriable Declaration
  CardModel model = CardModel();
  TextEditingController username = TextEditingController();
  TextEditingController joblocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  String gendor = "";

  final basicForm = GlobalKey<FormState>();

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
                  saveTo();
                  Navigator.pushNamed(context, ERoute.screen2.name);
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
                    if (value == null ||
                        value.isEmpty && !value.contains(' ')) {
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
                TextFormField(
                  controller: joblocation,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.maps_home_work),
                    label: Text("Job Location"),
                    //border: OutlineInputBorder(),
                    hintText: 'Enter Job Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Job Location';
                    }
                    return null;
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
                                    groupValue: gendor,
                                    onChanged: (value) {
                                      setState(() {
                                        gendor = value.toString();
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
                                    groupValue: gendor,
                                    onChanged: (value) {
                                      setState(() {
                                        gendor = value.toString();
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

  saveTo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('username', username.text);
    save();
    setState(() {});
  }

  save() async {
    // var result = await UserDataService().getUser(1);

    // print(Utils.parseResponse(result).resultData);

    var result = await UserDataService().saveUserStages({
      "stage": "otp",
      "data": {
        "mobile":"9321284090"
      }
    });
    print(Utils.parseResponse(result));
  }
}
