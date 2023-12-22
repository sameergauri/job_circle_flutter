import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:job_circle/themes/typography.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessPartnerConfirmation extends StatefulWidget {
  const BusinessPartnerConfirmation({Key? key}) : super(key: key);

  @override
  State<BusinessPartnerConfirmation> createState() =>
      _BusinessPartnerConfirmationState();
}

class _BusinessPartnerConfirmationState
    extends State<BusinessPartnerConfirmation> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  GlobalKey<FormState> basicForm1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          // elevation: 0,
          title: const Text('Sourcing Partner'),
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
              text: "I AGREE",
              themeButtonSize: ThemeButtonSize.medium,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
                child: TypographyStyle.textH4(
                    "Thank you for showing the interest.", Colors.black)),
            const SizedBox(
              height: 20,
            ),
            TypographyStyle.textH1(
                "Our executive will call you once you agree.", Colors.black),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: basicForm1,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                        // ],
                        controller: firstname,
                        onChanged: ((value) => {}),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid first name';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text("First Name"),
                          //border: OutlineInputBorder(),
                          border: InputBorder.none,
                          hintText: 'Please enter first name',
                        ),
                      ),
                      TextFormField(
                        autofocus: true,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                        // ],
                        controller: lastname,
                        onChanged: ((value) => {}),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid last name';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text("Last Name"),
                          //border: OutlineInputBorder(),
                          border: InputBorder.none,
                          hintText: 'Please enter last name',
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
                    ],
                  )),
            )
          ]),
        )));
  }

  save() async {
    // var result = await UserDataService().masterGetByGroup(
    //     {'groupName': 'location', 'pageNumber': '1', 'pageSize': '10'});
    // print(Utils.parseResponse(result).resultData);
    // return;
    SharedPreferences prefs = await Utils.getSharedPreferences();
    // prefs.setString('username', username.text);

    //String userName = firstname.text;
    // if (userName.isNotEmpty) {
    //   if (!GlobalConstants.spaceMatch
    //       .hasMatch(username.text.trim().toTitleCase())) {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text("Please enter valid name"),
    //     ));
    //     return;
    //   }
    // }

    var firstName = firstname.text.trim();
    var lastName = lastname.text.trim();
    var mobilenumber = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_mobile.name);

    var params = {
      "stage": "basic_info",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "mobile": mobilenumber,
        "first_name": firstName.toTitleCase(),
        "last_name": lastName.toTitleCase(),
        "languages": [],
        "job_location_id": 0,
        "email": emailadr.text,
        "gender": "",
        "dateofbirth": null,
        "usertype": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_type.name),
      }
    };

    // CardModel model = CardModel();
    // model.mobile = mobilenumber;
    // model.cardName = (firstName + " " + lastName).toTitleCase();
    // model.email = emailadr.text;
    var result = await UserDataService().saveUserStages(params);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      Navigator.pushNamedAndRemoveUntil(
          context, ERoute.partnerHome.name, (Route<dynamic> route) => false);
      // if (widget.prevPageModel == null) {
      //   await Utils.setPreference(
      //       prefs, ESharedPreferences.user_data.name, jsonEncode(model));
      //   Navigator.pushNamed(context, ERoute.screen2.name);
      // } else {
      //   widget.prevPageModel.first_name = firstName;
      //   widget.prevPageModel.last_name = lastName;
      //   widget.prevPageModel.job_location_city = selectedLocation.label;
      //   widget.prevPageModel.job_location_id =
      //       int.parse(selectedLocation.value);
      //   widget.prevPageModel.gender = gender;

      //   Navigator.pop(context, widget.prevPageModel);
      // }
    }
    setState(() {});
  }
}
