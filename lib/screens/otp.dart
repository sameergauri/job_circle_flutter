import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/utils.dart';
import '../service/UserDataService.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // controller
  late TextEditingController otpChar1Controller;
  late TextEditingController otpChar2Controller;
  late TextEditingController otpChar3Controller;
  late TextEditingController otpChar4Controller;

  late bool vrifyButtonDisabled = true;
  late bool resendOtpHide = true;
  late bool resendOtpTimerHide = false;

  // focus node;
  late FocusNode otpChar1FocusNode;
  late FocusNode otpChar2FocusNode;
  late FocusNode otpChar3FocusNode;
  late FocusNode otpChar4FocusNode;
  String mobileno = '';
  // variables
  String strOTP = '';
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 10;
  int currentSeconds = 0;
  late Timer timerCountdown;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mobileno = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_mobile.name);
      setState(() {});
    });

    otpChar1FocusNode = FocusNode();
    //otpChar1FocusNode.requestFocus();
    otpChar2FocusNode = FocusNode();
    otpChar3FocusNode = FocusNode();
    otpChar4FocusNode = FocusNode();

    otpChar1Controller = TextEditingController();
    otpChar2Controller = TextEditingController();
    otpChar3Controller = TextEditingController();
    otpChar4Controller = TextEditingController();

    Future.delayed(Duration.zero, () {
      otpChar1FocusNode.requestFocus();
      timerCountdown = startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            'We sent OTP to $mobileno',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: TextField(
                  controller: otpChar1Controller,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  focusNode: otpChar1FocusNode,
                  onChanged: ((value) => {
                        if (value != "") {otpChar2FocusNode.requestFocus()},
                        validateOtp()
                      }),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    counterText: "",
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: otpChar2Controller,
                  maxLength: 1,
                  focusNode: otpChar2FocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: ((value) => {
                        if (value == "")
                          {otpChar1FocusNode.requestFocus()}
                        else
                          {otpChar3FocusNode.requestFocus()},
                        validateOtp()
                      }),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    counterText: "",
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: otpChar3Controller,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  focusNode: otpChar3FocusNode,
                  onChanged: ((value) => {
                        if (value == "")
                          {otpChar2FocusNode.requestFocus()}
                        else
                          {otpChar4FocusNode.requestFocus()},
                        validateOtp()
                      }),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    counterText: "",
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: otpChar4Controller,
                  focusNode: otpChar4FocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 1,
                  onChanged: ((value) => {
                        strOTP += value.toString(),
                        if (value == "") {otpChar3FocusNode.requestFocus()},
                        validateOtp()
                      }),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    counterText: "",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 230,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ThemeButton(
                  width: 100,
                  themeButtonSize: ThemeButtonSize.xsmall,
                  isText: true,
                  onPressed: () {
                    saveOTP();
                    //Navigator.pushReplacementNamed(context, ERoute.login.name);
                    // Navigator.pushReplacementNamed(context, ERoute.login.name);
                  },
                  text: "Resend OTP",
                  hide: resendOtpHide,
                ),
                resendOtpTimerHide == false
                    ? Text(
                        timerText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            width: 300,
            child: ThemeButton(
              disabled: vrifyButtonDisabled,
              onPressed: () {
                varifyOTP();
              },
              text: "VARIFY OTP",
            ),
          )
        ],
      ),
    );
  }

  void validateOtp() {
    if (otpChar1Controller.text != "" &&
        otpChar2Controller.text != "" &&
        otpChar3Controller.text != "" &&
        otpChar4Controller.text != "") {
      vrifyButtonDisabled = false;
    } else {
      vrifyButtonDisabled = true;
    }
    setState(() {});
  }

  @override
  void deactivate() {
    timerCountdown.cancel();
    super.deactivate();
  }

  Timer startTimer() {
    var duration = interval;
    return Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          resendOtpHide = false;
          resendOtpTimerHide = true;
          timer.cancel();
        }
      });
    });
  }

  varifyOTP() async {
    SharedPreferences pres = await Utils.getSharedPreferences();

    String mobileno = await Utils.getPreferencesValue(
        pres, ESharedPreferences.user_mobile.name);
    var result = await UserDataService().validateOTP({
      "mobile": mobileno, //prefs.getString('user_mob'),
      "otp": otpChar1Controller.text +
          otpChar2Controller.text +
          otpChar3Controller.text +
          otpChar4Controller.text
    });

    RequestResult res = Utils.parseResponse(result);

    if (res.resultKey == 'SUCCESS') {
      dynamic data = res.resultData;

      if (res.resultData.containsKey('msg')) {
        clearOTPText();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid otp. please try again"),
        ));
      } else {
        await Utils.setPreference(
            pres, ESharedPreferences.user_id.name, data['id']);

        await Utils.setPreference(
            pres, ESharedPreferences.user_type.name, data['usertype']);

        CardModel model = CardModel();
        model.mobile = mobileno;
        model.cardName = (data['firstName'] + " " + data['lastName']);
        model.email = data['email'];
        await Utils.setPreference(pres, ESharedPreferences.user_data.name,
            jsonEncode(model.toJson()));

        if (data['usertype'] != null) {
          final String usertype = data['usertype'].toString();

          if (usertype.toString() == EUserType.jobSeeker.value.toString()) {
            ERoute nextRoute = ERoute.screen1;
            if (data['firstName'] == '') {
              nextRoute = ERoute.screen1;
            } else if (data['education'] == null || data['firstName'] == 0) {
              nextRoute = ERoute.screen2;
            } else if (data['experience'] == null || data['experience'] == 0) {
              nextRoute = ERoute.screen3;
            } else {
              nextRoute = ERoute.home;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, nextRoute.value, (Route<dynamic> route) => false);
            // Future.delayed(const Duration(seconds: 1), () {
            //   // Navigator.pushReplacementNamed(context, nextRoute.value);
            // });
          } else if (usertype.toString() ==
              EUserType.businessPartner.value.toString()) {
            //Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamedAndRemoveUntil(context, ERoute.partnerHome.name,
                (Route<dynamic> route) => false);
            // Navigator.pushReplacementNamed(
            //     context, ERoute.businesspartner_confirmation.name);
            // });
          } else if (usertype.toString() ==
              EUserType.employee.value.toString()) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, ERoute.jobs.name, (Route<dynamic> route) => false);
              //Navigator.pushReplacementNamed(context, ERoute.jobs.name);
            });
          } else {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushNamedAndRemoveUntil(context, ERoute.logintype.name,
                  (Route<dynamic> route) => false);
              //Navigator.pushReplacementNamed(context, ERoute.logintype.name);
            });
          }
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamedAndRemoveUntil(context, ERoute.logintype.name,
                (Route<dynamic> route) => false);
            //Navigator.pushReplacementNamed(context, ERoute.logintype.name);
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP Verified Successfully"),
        ));
      }
    }
  }

  saveOTP() async {
    clearOTPText();

    var result = await UserDataService().authenticate({
      "mobile": await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name)
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP Resend Successfully"),
      ));
    }
  }

  void clearOTPText() {
    otpChar1Controller.text = "";
    otpChar2Controller.text = "";
    otpChar3Controller.text = "";
    otpChar4Controller.text = "";
  }
}
