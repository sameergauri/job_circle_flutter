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

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({Key? key}) : super(key: key);

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
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
            children: const [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Center(child: SmartCard(model: model)),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    basicInfo(),
                    education(),
                    experience(),
                    contactDetails()
                  ]),
                ),
              ),
            ],
          ),
        ));
  }

  Widget basicInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CardCustom(
              icon: Icons.account_circle_outlined,
              title: "Basic Info",
              onPress: (() {print("basic info")}),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PRATIK NAIK",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w200),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Location",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "Mumbai",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "Male",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Date Of Birth",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "11 AUG 1989",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget education() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CardCustom(
              icon: Icons.school_outlined,
              title: "Education",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Highest Education",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "12th Pass",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget experience() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CardCustom(
              icon: Icons.business_center_outlined,
              title: "Experience",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Level",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "Fresher",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contactDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CardCustom(
              isedit: false,
              icon: Icons.alternate_email_outlined,
              title: "Contact Details",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Mobile",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "12th Pass",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "Pratik@gmail.com",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card CardCustom(
      {required String title,
      required IconData icon,
      Widget? child,
      bool? isedit = true,
      Function()? onPress}) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isedit == true)
                              IconButton(
                                icon: Icon(Icons.edit, size: 18),
                                onPressed: onPress,
                              )
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: child,
                )
              ],
            )));
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
      "data": {"mobile": "9321284090"}
    });
    print(Utils.parseResponse(result));
  }
}
