// ignore_for_file: unused_result, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/screens/Billing/banking_detal.dart';
import 'package:job_circle/screens/Billing/list_of_invoice.dart';
import 'package:job_circle/screens/Billing/view_and_generate_invoice.dart';
import 'package:job_circle/screens/Manager/manager_piepline.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/jobs/cc_my_team.dart';
import 'package:job_circle/screens/jobs/talent_pool.dart';
import 'package:job_circle/screens/login.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/utils.dart';
import '../service/UserDataService.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key, this.no});
  final String? no;

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
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
  final int timerMaxSeconds = 120;
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
      //resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      /* appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ), */
      body: IntrinsicHeight(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/otplogo.png"),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Enter the OTP sent to',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "+91 $mobileno",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: Image.asset(
                      "assets/images/pencil.png",
                      height: 16.h,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
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
                      autofocus: true,
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
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                //width: 230,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: resendOtpTimerHide
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.end,
                  children: [
                    resendOtpTimerHide
                        ? Row(
                            children: [
                              Text(
                                "Dont recieve the OTP ?",
                                style: GoogleFonts.varela(color: Colors.grey),
                              ),
                              InkWell(
                                onTap: () {
                                  saveOTP();
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Text(
                                    "Resend OTP",
                                    style:
                                        GoogleFonts.varela(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width / 4.6),
                            child: Text(
                              timerText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                    /*  ThemeButton(
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
                    ), */
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 300,
                child: ThemeButton(
                  color: Constants.blue,
                  radious: 8.r,
                  // disabled: vrifyButtonDisabled,
                  onPressed: () async {
                    await varifyOTP();
                    ref.refresh(
                        fetchAllApplicantProvider); //TODO:: refresh when new user login
                    ref.refresh(fetchAllApplyProvider);
                    ref.refresh(fetchAllReferalProvider);
                    ref.refresh(profileSummaryProvider);
                    ref.refresh(jobsProvider);
                    ref.refresh(fetchAllBillingDataProvider);
                    ref.refresh(fetchAllInvoice);
                    ref.refresh(fetchBankingDetails);
                    ref.refresh(userDataProvider);
                    ref.refresh(experienceProvider);
                    ref.refresh(educationProvider);
                    ref.refresh(fetchAllTalentPoolProvider);
                    ref.refresh(fetchAllTeamData);
                    ref.refresh(fetchAllManagerProvider);
                  },
                  text: "Verify & Proceed",
                ),
              ),

              /* InkWell(  //TODO: 
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    "Edit Number",
                    style: GoogleFonts.varela(color: Colors.red),
                  ),
                ),
              ), */
            ],
          ),
        ),
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

  SnackBar customSnackbar(String title, bool error) {
    return SnackBar(
      elevation: 1.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: Constants.themeBgColorLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 8), // Remove shadow
      content: Row(
        children: [
          error
              ? Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                  size: 15.h,
                )
              : Image.asset(
                  "assets/images/check.png",
                  color: Constants.themeBgColor,
                  height: 15.h,
                ),
          /* Icon(
                  Icons.check,
                  color: Constants.themeBgColor,
                  size: 15.h,
                ),  */ // Add an icon if needed
          const SizedBox(width: 8.0), // Add spacing between icon and text
          Text(
            title,
            style: const TextStyle(
              color: Colors.black, // Text color
              fontSize: 14.0, // Text size
            ),
          ),
        ],
      ),
      // duration: const Duration(seconds: 3),
    );
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

        await Utils.setPreference(pres, ESharedPreferences.user_type.name,
            int.parse(data['usertype']));

        CardModel model = CardModel();
        model.mobile = mobileno;
        model.cardName = (data['firstName'] + " " + data['lastName']);
        model.firstName = data['firstName'];
        model.lastName = data['lastName'];
        model.email = data['email'];
        model.role = data['role'];
        model.gender = data['gender'];
        model.report_to = data['report_to'];
        await Utils.setPreference(
            pres, ESharedPreferences.role.name, data['role']);
        await Utils.setPreference(
            pres, ESharedPreferences.report_to.name, data['report_to']);

        await Utils.setPreference(pres, ESharedPreferences.user_data.name,
            jsonEncode(model.toJson()));

        await Utils.setPreference(
            pres, ESharedPreferences.user_rawData.name, jsonEncode(data));
        // ref.refresh(userJobDataProvider);
        // ref.refresh(fetchAllApplyProvider);
        // ref.refresh(fetchAllTalentPool);
        // ref.refresh(userDataProvider);
        // ref.refresh(profileSummaryProvider);
        // ref.refresh(fetchAllApplicantProvider);

        Utils.gotoScreen(context, data, model.mobile);

        ScaffoldMessenger.of(context).showSnackBar(CustomSnackbarfinal(
            title: "OTP Verified Successfully", error: false));
      }
    }
  }

  saveOTP() async {
    clearOTPText();
    resendOtpHide = true;
    resendOtpTimerHide = false;
    Future.delayed(Duration.zero, () {
      otpChar1FocusNode.requestFocus();
      timerCountdown = startTimer();
    });
    // setState(() {});

    var result = await UserDataService().authenticate({
      "mobile": await Utils.getPreferencesValue(
          null, ESharedPreferences.user_mobile.name)
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
