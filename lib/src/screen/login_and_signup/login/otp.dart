// ignore_for_file: unused_result, use_build_context_synchronously
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/login_signup_provider/login_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/login/login.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:job_circle/src/widgets/button/theme_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
// Import your LoginProvider

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // Focus nodes
  late FocusNode otpChar1FocusNode;
  late FocusNode otpChar2FocusNode;
  late FocusNode otpChar3FocusNode;
  late FocusNode otpChar4FocusNode;

  // Timer variables
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 120;
  int currentSeconds = 0;
  late Timer timerCountdown;
  bool vrifyButtonDisabled = true;
  bool resendOtpHide = true;
  bool resendOtpTimerHide = false;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    // Initialize focus nodes
    otpChar1FocusNode = FocusNode();
    otpChar2FocusNode = FocusNode();
    otpChar3FocusNode = FocusNode();
    otpChar4FocusNode = FocusNode();

    // Request focus on first OTP field
    Future.delayed(Duration.zero, () {
      otpChar1FocusNode.requestFocus();
      timerCountdown = startTimer();
    });
  }

  @override
  void dispose() {
    // Dispose focus nodes
    otpChar1FocusNode.dispose();
    otpChar2FocusNode.dispose();
    otpChar3FocusNode.dispose();
    otpChar4FocusNode.dispose();
    timerCountdown.cancel();
    super.dispose();
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

  void validateOtp(LoginProvider provider) {
    if (provider.otp1.text.isNotEmpty &&
        provider.otp2.text.isNotEmpty &&
        provider.otp3.text.isNotEmpty &&
        provider.otp4.text.isNotEmpty) {
      vrifyButtonDisabled = false;
    } else {
      vrifyButtonDisabled = true;
    }
    setState(() {});
  }

  Future<void> resendOTP(LoginProvider provider) async {
    clearOTPText(provider);
    resendOtpHide = true;
    resendOtpTimerHide = false;
    Future.delayed(Duration.zero, () {
      otpChar1FocusNode.requestFocus();
      timerCountdown = startTimer();
    });

    bool success = await provider.generateOTP(context);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Verified successfully : 👋 Welcome to Job Circle"),
        ),
      );
    }
  }

  Future<void> verifyOTP(LoginProvider provider) async {
    String otp =
        provider.otp1.text +
        provider.otp2.text +
        provider.otp3.text +
        provider.otp4.text;

    bool success = await provider.verifyOtp(
      context,
      provider.mobileController.text,
      otp,
    );

    if (success) {
      final firstName = SharedPrefsHelper.getString(
        ESharedPreferences.user_firstName,
      );
      final userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
      final usertype = SharedPrefsHelper.getInt(ESharedPreferences.user_type);
      final msg = SharedPrefsHelper.getString(ESharedPreferences.msg);
      clearOTPText(provider);
      provider.mobileController.clear();
      Utils.gotoScreen(
        context: context,
        firstname: firstName,
        empid: userid,
        usertype: usertype,
        msg: msg,
        from: "otp",
      );
    }
  }

  void clearOTPText(LoginProvider provider) {
    provider.otp1.clear();
    provider.otp2.clear();
    provider.otp3.clear();
    provider.otp4.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: IntrinsicHeight(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(CustomAssetUrl.otplogoicon),
                  const customText(
                    title: 'OTP Verification',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 20),
                  const customText(
                    title: 'Enter the OTP sent to',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(
                        monst: true,
                        title: "+91 ${provider.mobileController.text}",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          NavigationService.pushReplacement(LoginPage());
                        },
                        child: CustomNetworkImage(
                          imageUrl: CustomIconUrl.editicon,
                          defaultIcon: Icons.edit,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextField(
                          style: GoogleFonts.montserrat(),
                          controller: provider.otp1,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          focusNode: otpChar1FocusNode,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              otpChar2FocusNode.requestFocus();
                            }
                            validateOtp(provider);
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(counterText: ""),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          style: GoogleFonts.montserrat(),
                          controller: provider.otp2,
                          maxLength: 1,
                          focusNode: otpChar2FocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isEmpty) {
                              otpChar1FocusNode.requestFocus();
                            } else {
                              otpChar3FocusNode.requestFocus();
                            }
                            validateOtp(provider);
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(counterText: ""),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          style: GoogleFonts.montserrat(),
                          controller: provider.otp3,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          focusNode: otpChar3FocusNode,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              otpChar2FocusNode.requestFocus();
                            } else {
                              otpChar4FocusNode.requestFocus();
                            }
                            validateOtp(provider);
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(counterText: ""),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          style: GoogleFonts.montserrat(),
                          controller: provider.otp4,
                          focusNode: otpChar4FocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              otpChar3FocusNode.requestFocus();
                            }
                            validateOtp(provider);
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(counterText: ""),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: resendOtpTimerHide
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.end,
                      children: [
                        resendOtpTimerHide
                            ? Row(
                                children: [
                                  const customText(
                                    title: "Don't receive the OTP?",
                                    color: Constants.subtitleclr,
                                  ),
                                  InkWell(
                                    onTap: () => resendOTP(provider),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      child: const customText(
                                        title: "Resend OTP",
                                        color: Constants.darkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width / 4.6,
                                ),
                                child: Text(
                                  timerText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 300,
                    child: ThemeButton(
                      color: Constants.darkBlue,
                      radious: 8,
                      disabled: vrifyButtonDisabled,
                      onPressed: () => verifyOTP(provider),
                      text: "Verify & Proceed",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (provider.isLoading)
          const CustomLoadingIndicator(
            loaderColor: Constants.darkBlue,
            blurSigma: 5,
          ),
      ],
    );
  }
}
