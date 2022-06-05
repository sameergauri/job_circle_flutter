import 'package:flutter/material.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:job_circle/themes/typography.dart';

class BusinessPartnerConfirmation extends StatefulWidget {
  const BusinessPartnerConfirmation({Key? key}) : super(key: key);

  @override
  State<BusinessPartnerConfirmation> createState() =>
      _BusinessPartnerConfirmationState();
}

class _BusinessPartnerConfirmationState
    extends State<BusinessPartnerConfirmation> {
  TextEditingController username = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  final basicForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          // elevation: 0,
          title: const Text('Business Partner'),
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
                Navigator.pushNamedAndRemoveUntil(
                    context, ERoute.home.name, (Route<dynamic> route) => false);
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
                  key: basicForm,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                        // ],
                        controller: username,
                        onChanged: ((value) => {}),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
}
