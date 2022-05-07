import 'package:flutter/material.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:job_circle/themes/typography.dart';

class BusinessPartnerConfirmation extends StatelessWidget {
  const BusinessPartnerConfirmation({Key? key}) : super(key: key);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: TypographyStyle.textH4(
                        "Thank you for showing the interest.", Colors.black)),
                const SizedBox(
                  height: 20,
                ),
                TypographyStyle.textH1(
                    "Our executive will call you once you agree.", Colors.black)
              ],
            ),
          ),
        ));
  }
}
