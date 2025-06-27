// ignore_for_file: unused_result, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/screens/Billing/ui/banking_detal.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/applied_page.dart';
import 'package:job_circle/screens/login.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/screens/referral_page.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/utils.dart';

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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                  const customTextForWeather(
                    title: 'OTP Verification',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const customTextForWeather(
                      title: 'Enter the OTP sent to',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customTextForMonst(
                        title: "+91 ${widget.no}",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login(
                                        number: int.tryParse(mobileno),
                                      )));
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
                          style: GoogleFonts.montserrat(),
                          controller: otpChar1Controller,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          focusNode: otpChar1FocusNode,
                          onChanged: ((value) => {
                                if (value != "")
                                  {otpChar2FocusNode.requestFocus()},
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
                          style: GoogleFonts.montserrat(),
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
                          style: GoogleFonts.montserrat(),
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
                          style: GoogleFonts.montserrat(),
                          controller: otpChar4Controller,
                          focusNode: otpChar4FocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 1,
                          onChanged: ((value) => {
                                strOTP += value.toString(),
                                if (value == "")
                                  {otpChar3FocusNode.requestFocus()},
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
                                  const customTextForWeather(
                                    title: "Dont recieve the OTP ?",
                                    color: Constants.subtitleclr,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        saveOTP();
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        child: const customTextForWeather(
                                          title: "Resend OTP",
                                          color: Constants.darkBlue,
                                        ),
                                      )),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width /
                                        4.6),
                                child: Text(
                                  timerText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                      color: Constants.darkBlue,
                      radious: 8.r,
                      // disabled: vrifyButtonDisabled,
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await verifyOTP();

                        ref.refresh(fetchBankingDetails);
                        ref.refresh(referAts);
                        ref.refresh(appliedAts);
                        ref.refresh(ProfileDataProvider);
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
        ),
        if (isLoading)
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Blur Effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.2), // Semi-transparent overlay
                  ),
                ),
                // Circular Progress Indicator
                const CircularProgressIndicator(
                  color: Constants.darkBlue,
                ),
              ],
            ),
          ),
      ],
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

/*   varifyOTP() async {
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
  } */

  Future<void> verifyOTP() async {
    //TODO:: New function to validate otp...
    // Fetch mobile number from shared preferences
    SharedPreferences pres = await Utils.getSharedPreferences();
    /*  String mobileNumber = await Utils.getPreferencesValue(
        pres, ESharedPreferences.user_mobile.name); */

    // Combine the OTP from text fields
    String otp = otpChar1Controller.text +
        otpChar2Controller.text +
        otpChar3Controller.text +
        otpChar4Controller.text;

    // Construct the API URL with query parameters
    String baseUrl = GlobalConstants.API_Host_one;
    String endpoint = "/api/otp/v1/validate";
    Uri url = Uri.http(baseUrl, endpoint, {"mobile": widget.no, "otp": otp});

    try {
      // Make HTTP GET request
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var response = await http.post(url, headers: headers);

      // Handle HTTP response
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['resultKey'] == 'SUCCESS') {
          var data = res['resultData'];
          var datafinal = res['resultData']['userOtpResponse'];

          if (data.containsKey('msg')) {
            // Create and save user model
            CardModel model = CardModel();
            model.mobile = widget.no;
            model.cardName = "${datafinal['firstName']}";
            model.firstName = datafinal['firstName'];
            model.role = datafinal['role'];
            // model.cardName = "${datafinal['firstName']} ${data['lastName']}";
            // model.lastName = datafinal['lastName'];
            // model.email = datafinal['email'];
            // model.gender = datafinal['gender'];
            // model.report_to = datafinal['report_to'];
            /*   await Utils.setPreference(
                pres, ESharedPreferences.user_id.name, datafinal['id'] ?? ""); */
            /* await Utils.setPreference(pres, ESharedPreferences.report_to.name,
                datafinal['report_to'] ?? ""); */
            await Utils.setPreference(pres, ESharedPreferences.user_id.name,
                datafinal['userId'].toString());
            await Utils.setPreference(pres,
                ESharedPreferences.user_rawData.name, jsonEncode(datafinal));
            await Utils.setPreference(
                pres, ESharedPreferences.role.name, datafinal['role'] ?? 0);
            await Utils.setPreference(pres, ESharedPreferences.user_type.name,
                datafinal['usertype'] ?? 0);
            await Utils.setPreference(pres, ESharedPreferences.user_mobile.name,
                datafinal['mobile'] ?? 0);
            await Utils.setPreference(
                pres, ESharedPreferences.role.name, datafinal['role'] ?? 0);
            await Utils.setPreference(pres, ESharedPreferences.user_data.name,
                jsonEncode(model.toJson()));
            await Utils.setPreference(pres, ESharedPreferences.user_token.name,
                    data['token'] ?? "")
                .then((_) {
              ref.read(jobListProvider.notifier).fetchInitialJobs();
              Future.delayed(const Duration(seconds: 3), () async {
                Utils.gotoScreen(
                  context,
                  datafinal,
                  model.mobile,
                );
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackbarfinal(
                    title: "OTP Verified Successfully", error: false));
              });
            });

            //
            //
            //
            //
            /*   await Utils.setPreference(pres, ESharedPreferences.user_type.name,
                int.parse(datafinal['usertype'] ?? ""));
            await Utils.setPreference(
                pres, ESharedPreferences.role.name, datafinal['role'] ?? "");
            await Utils.setPreference(
                    pres, ESharedPreferences.user_token.name, data['token']) ??
                "";
            await Utils.setPreference(pres, ESharedPreferences.user_data.name,
                jsonEncode(model.toJson()));

            // Navigate to the appropriate screen
            Utils.gotoScreen(context, datafinal, model.mobile);

            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackbarfinal(
                title: "OTP Verified Successfully", error: false)); */
            //
            //
            //
            //
            // Clear OTP fields and show error message
          } else {
            // Save user data to shared preferences
            clearOTPText();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid OTP. Please try again"),
            ));
          }
        } else {
          // Show error message if resultKey is not SUCCESS
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res['errorMessage'] ?? "Unknown error occurred"),
          ));
        }
      } else {
        // Handle HTTP errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("HTTP Error: ${response.statusCode}"),
        ));
      }
    } catch (e) {
      // Handle exceptions
      print("Error in verifyOTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. Please try again."),
      ));
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

    String baseUrl = GlobalConstants.API_Host_one;
    String endpoint = "/api/otp/v1/generate";
    Uri url = Uri.http(baseUrl, endpoint, {
      "mobile": await Utils.getPreferencesValue(
          null, ESharedPreferences.user_mobile.name)
    });
    // setState(() {});

    /* var result = await UserDataService().authenticate({
      "mobile": await Utils.getPreferencesValue(
          null, ESharedPreferences.user_mobile.name)
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP Resend Successfully"),
      ));
    } */
    try {
      // Headers for the HTTP request
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Send the GET request to the API
      var response = await http.post(url, headers: headers);

      // Handle the API response
      if (response.statusCode == 200) {
        // Parse the response body
        var res = jsonDecode(response.body);

        if (res['resultKey'] == 'SUCCESS') {
          // Display OTP message if available
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("OTP Resend Successfully"),
          ));
        } else {
          // Handle failure response
          print("Failed to generate OTP: ${res['errorMessage']}");
        }
      } else {
        // Handle HTTP errors
        print("HTTP Error: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      // Handle exceptions
      print("Error in generateOTP: $e");
    }
  }

  void clearOTPText() {
    otpChar1Controller.text = "";
    otpChar2Controller.text = "";
    otpChar3Controller.text = "";
    otpChar4Controller.text = "";
  }
}
