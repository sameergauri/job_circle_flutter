// ignore_for_file: prefer_final_fields, use_build_context_synchronously, unused_element, use_full_hex_values_for_flutter_colors
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/otp.dart';
import 'package:job_circle/themes/colors.dart';

class Login extends StatefulWidget {
  final int? number;
  const Login({this.number, super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  bool isManual = true;
  TextEditingController otpcontroller = TextEditingController();
  final String _mobileNumber = '';
  //List<SimCard> _simCard = <SimCard>[];
  FocusNode mobileFocus = FocusNode();

  // Future<void> initMobileNumberState() async {
  //   if (!await MobileNumber.hasPhonePermission) {
  //     await MobileNumber.requestPhonePermission;
  //     return;
  //   }
  //   String mobileNumber = '';
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     mobileNumber = (await MobileNumber.mobileNumber)!;
  //     _simCard = (await MobileNumber.getSimCards)!;
  //   } on PlatformException catch (e) {
  //     debugPrint("Failed to get mobile number because of '${e.message}'");
  //   }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // // setState to update our non-existent appearance.
  // if (!mounted) return;

  // setState(() {
  //   isManual = false;
  //   _mobileNumber = mobileNumber;
  // });
  // }

  @override
  void initState() {
    super.initState();

    if (widget.number != null) {
      setState(() {
        otpcontroller.text = widget.number.toString();
      });
    }

    // if (!kIsWeb && Platform.isAndroid) {
    //   MobileNumber.listenPhonePermission((isPermissionGranted) {
    //     if (isPermissionGranted) {
    //       initMobileNumberState();
    //     } else {}
    //   });

    //   initMobileNumberState();
    // }

    Future.delayed(Duration.zero, () async {
      await AppUtils.clearSession();
      BottomDialog()
          .showBottomDialog(context, _buildDialogContent(context), false);
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 8),
                  width: MediaQuery.of(context).size.width / 1.8,
                  color: Colors.white,
                  child: Image.asset(
                    "assets/images/jclogo.png",
                    fit: BoxFit.cover,
                  )),
              /*   Container(
                height: 160.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)),
                  color:
                      Colors.white, ////TODO: logo background container color.
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        spreadRadius:
                            3), //TODO: Border color of ogin page of background container.
                  ],
                ),
              ), */
              /*  Container(
                margin: EdgeInsets.only(top: 180.h),
                // height: .h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)),
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(color: Colors.transparent, spreadRadius: 3),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                    text: "JOB",
                    style: GoogleFonts.signika(
                      fontSize: 40,
                      color: Constants.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "CIRCLE",
                        style: GoogleFonts.signika(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      )
                    ]),
              ), */
              GestureDetector(
                onTap: (() => Future.delayed(Duration.zero, () {
                      BottomDialog().showBottomDialog(
                          context, _buildDialogContent(context), false);
                    })),
                child: const Text(
                  "",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const customTextForWeather(
                                title: 'Made in',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Constants.black),
                            const SizedBox(
                              width: 7,
                            ),
                            Image.asset(
                              "./assets/images/india.png",
                              height: 22,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            const customTextForWeather(
                                title: 'with',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Constants.black),
                            const SizedBox(
                              width: 7,
                            ),
                            Image.asset(
                              "./assets/images/heart.png",
                              height: 22,
                              //color: Constants.blue,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const customTextForMonst(
                            title: '@ All rights reserved - 2025-26',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Constants.black),

                        // TextButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   const MasterOfMasterView()));
                        //     },
                        //     child: const Text('Opem Moms Page'))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Material(
          child: Column(
            children: [
              // const SizedBox(height: 16),
              // _buildImage(),

              const SizedBox(height: 10),
              _buildContinueText(),
              const SizedBox(height: 16),
              _buildEmapleText(),
              const SizedBox(height: 30),
              if (isManual == true) _buildManualForm(),
              if (isManual == true) const SizedBox(height: 16),
              if (isManual == false) _buildContinueButton(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const image =
        'https://user-images.githubusercontent.com/47568606/134579553-da578a80-b842-4ab9-ab0b-41f945fbc2a7.png';
    return SizedBox(
      height: 88,
      child: Image.network(image, fit: BoxFit.cover),
    );
  }

  Widget _buildContinueText() {
    return const customTextForWeather(
      title: 'Enter Mobile Number',
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildEmapleText() {
    return const Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customTextForWeather(
            title: 'We will send you the ',
            fontSize: 15,
            color: Constants.subtitleclr,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
          customTextForSignika(
            title: '4 digit ',
            fontSize: 15,
            fontWeight: FontWeight.w800,
            overflow: TextOverflow.ellipsis,
          ),
          customTextForWeather(
            title: 'verification code',
            color: Constants.subtitleclr,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    const iconSize = 40.0;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.4)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Center(
              child: Text('Е'),
            ),
          ),
          const SizedBox(height: 16),
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'elisa.g.beckett@gmail.com',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('**********'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ThemeButton(
            text: _mobileNumber,
            disabled: false,
            onPressed: () => {
              Navigator.pushNamedAndRemoveUntil(context, ERoute.otpscreen.name,
                  (Route<dynamic> route) => false)
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ThemeButton(
            onPressed: () {
              setState(() {
                isManual = true;
              });
              Navigator.of(context, rootNavigator: true).pop();
              BottomDialog().showBottomDialog(
                  context, _buildDialogContent(context), false);
            },
            text: 'Enter Manually',
            isText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildManualForm() {
    return Column(
      children: [
        Form(
          key: _formKey2,
          child: TextFormField(
            cursorColor: Colors.grey,
            controller: otpcontroller,
            focusNode: mobileFocus,
            autofocus: true,
            validator: (value) {
              if (value == null || value.length < 10) {
                return 'Please enter your 10 digit mobile number.';
              }
              return null;
            },
            maxLength: 10,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            /*  decoration: const InputDecoration(
              label: Text("Your mobile number"),
              prefix: Text(
                "+91 ",
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              border: OutlineInputBorder(),
              hintText: 'Enter your mobile number',
            ), */
            style: GoogleFonts.montserrat(
                color: Constants.black, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 10, right: 10),

                // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                // Icons.workspace_premium
                // label: const Text("Company Name *"),
                //border: OutlineInputBorder(),
                prefix: const customTextForMonst(
                  title: "+91 ",
                  color: Constants.subtitleclr,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusColor: const Color(0xfff729995),
                enabled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelText: "Mobile",
                labelStyle: GoogleFonts.montserrat(
                  color: Constants.subtitleclr,
                ),
                hintText: '865156****',
                hintStyle: GoogleFonts.montserrat(
                    color: Constants.subtitleclr, fontSize: 15)
                //  prefixIcon: Icon(Icons.list)
                ),
          ),
        ),
        const SizedBox(height: 20),
        ThemeButton(
          color: Constants.darkBlue,
          radious: 8.r,
          text: "Get OTP",
          onPressed: () {
            if (_formKey2.currentState!.validate()) {
              setState(() {
                isLoading = true;
              });
            } else {
              return;
            }
            generateOTP(otpcontroller.text);

            // setState(() {
            //   isManual = true;
            // });
            // Navigator.of(context, rootNavigator: true).pop();
            // BottomDialog()
            //     .showBottomDialog(context, _buildDialogContent(context), false);
          },
        ),
      ],
    );
  }

  /* saveOTP(String no) async {
    bool validate = _formKey2.currentState!.validate();
    if (!validate) {
      return;
    }
    var result =
        await UserDataService().authenticate({"mobile": otpcontroller.text});
    var res = Utils.parseResponse(result);
    if (res.resultKey == 'SUCCESS') {
      if (res.resultData['val'] == 0) {
        Widget continueButton = TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        );

        AlertDialog alert = AlertDialog(
          title: const Text("!!Alert!!"),
          content: Text(res.resultData['otpmsg']),
          actions: [continueButton],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else {
        // prefs.remove('userid');
        // prefs.remove('user_mob');
        // prefs.setInt('userid',Utils.parseResponse(result).resultData[1]);
        Utils.setPreference(
            null, ESharedPreferences.user_mobile.name, otpcontroller.text);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreen(
                      no: no,
                    )));
      }
      // Navigator.pushNamedAndRemoveUntil(
      //     context, ERoute.otpscreen.name, (Route<dynamic> route) => false);
    }
  } */

  Future<void> generateOTP(String mobileNumber) async {
    //TODO:: New function to generate otp....
    // Construct the API URL
    String baseUrl = GlobalConstants.API_Host_one;
    String endpoint = "/api/otp/v1/generate";
    Uri url = Uri.http(baseUrl, endpoint, {"mobile": mobileNumber});

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
          var otp = res['resultData']['userOtpResponse']['otp'];
          print("OTP:$otp");
          // Display OTP message if avail17able
          await Utils.setPreference(
              null, ESharedPreferences.user_mobile.name, mobileNumber);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(no: mobileNumber),
            ),
          );
        } else {
          // Handle failure response
          print("Failed to generate OTP: ${res['errorMessage']}");
          showAlert(context, "Error",
              res['errorMessage'] ?? "Unknown error occurred");
        }
      } else {
        // Handle HTTP errors
        print("HTTP Error: ${response.statusCode}, Body: ${response.body}");
        showAlert(
            context, "Error", "Failed to generate OTP. Please try again.");
      }
    } catch (e) {
      // Handle exceptions
      print("Error in generateOTP: $e");
      showAlert(context, "Error", "Something went wrong. Please try again.");
    }
  }

  /* Future<void> generateAndHandleOTP(String mobileNumber) async {
    // Validate form inputs
    bool validate = _formKey2.currentState!.validate();
    if (!validate) {
      print("Form validation failed");
      return;
    }

    // API Call to generate OTP
    try {
      var result =
          await UserDataService().authenticate({"mobile": mobileNumber});
      var res = Utils.parseResponse(result);

      if (res.resultKey == 'SUCCESS') {
        // Handle response with val == 0 (e.g., alert user)
        if (res.resultData['val'] == 0) {
          showOTPAlert(context, res.resultData['otpmsg']);
        }
        // Handle response with val == 1 (e.g., new user flow)
        else if (res.resultData['val'] == 1) {
          await Utils.setPreference(
              null, ESharedPreferences.user_mobile.name, mobileNumber);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(no: mobileNumber),
            ),
          );
        }
        // Handle unexpected val values
        else {
          print("Unexpected value for 'val': ${res.resultData['val']}");
          showAlert(context, "Error", "Unexpected server response.");
        }
      }
      // Handle API response failure
      else {
        showAlert(
            context, "Error", "Failed to generate OTP: ${res.errorMessage}");
      }
    } catch (e) {
      print("Error while generating OTP: $e");
      showAlert(context, "Error", "Something went wrong. Please try again.");
    }
  } */

  void showOTPAlert(BuildContext context, String message) {
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("!!Alert!!"),
      content: Text(message),
      actions: [continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlert(BuildContext context, String title, String message) {
    Widget closeButton = TextButton(
      child: const Text("Close"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [closeButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
