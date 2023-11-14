import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/otp.dart';
import 'package:job_circle/themes/colors.dart';

import '../common/utils.dart';
import '../service/UserDataService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
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
              ),
              const SizedBox(
                height: 120,
              ),
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
                          children: [
                            const Text(
                              'MADE IN ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  color: Colors.black87),
                            ),
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
                            const Text(
                              ' WITH ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Image.asset(
                              "./assets/images/heart.png",
                              height: 22,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          '@ All rights reserved - 2022-23',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              color: Colors.black54),
                        ),
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
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 110,
                height: 170,
                child: Container(
                  height: 170,
                  width: 170,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/images/job-logo.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -6),
                          color: Color(0xffce3538),
                          spreadRadius: 2,
                          blurStyle: BlurStyle.inner,
                          blurRadius: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
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
    return const Text(
      'Hi, Welcome',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmapleText() {
    return const Text(
      'To get started, please verify mobile number',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
          key: _formKey,
          child: TextFormField(
            controller: otpcontroller,
            focusNode: mobileFocus,
            autofocus: true,
            validator: (value) {
              if (value == null || value.length < 10) {
                return 'Please enter valid number.';
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
            style: GoogleFonts.varela(color: Constants.themeBgColor),
            decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 10, right: 10),

                // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                // Icons.workspace_premium
                // label: const Text("Company Name *"),
                //border: OutlineInputBorder(),
                prefix: Text(
                  "+91 ",
                  style: GoogleFonts.varela(
                    color: Constants.themeBgColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xfff729995)),
                ),
                focusColor: const Color(0xfff729995),
                enabled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xfff729995)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xfff729995)),
                ),
                labelText: "Your mobile number",
                labelStyle: const TextStyle(color: Color(0xfff729995)),
                hintText: 'Enter your mobile number',
                hintStyle: GoogleFonts.sourceSansPro(
                    color: Constants.subtitleclr, fontSize: 15.sp)
                //  prefixIcon: Icon(Icons.list)
                ),
          ),
        ),
        const SizedBox(height: 20),
        ThemeButton(
          radious: 8.r,
          text: "Confirm",
          onPressed: () {
            saveOTP(otpcontroller.text);

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

  saveOTP(String no) async {
    bool validate = _formKey.currentState!.validate();
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreen(
                      no: no,
                    )));
      }
      // Navigator.pushNamedAndRemoveUntil(
      //     context, ERoute.otpscreen.name, (Route<dynamic> route) => false);
    }
  }
}
