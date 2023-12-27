// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFloatCall extends StatelessWidget {
  final int phoneNumber1;
  final int phoneNumber2;
  final bool isCall;

  const CustomFloatCall(
      {super.key,
      required this.isCall,
      required this.phoneNumber1,
      required this.phoneNumber2});

  String formatNumber(int number) {
    String numberString = number.toString();
    int length = numberString.length;

    if (length <= 3) {
      return numberString;
    }

    String asterisks = '*' * (length - 3);
    return '$asterisks${numberString.substring(length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      iconTheme: const IconThemeData(color: Colors.white),
      //  animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 28.0),
      buttonSize: Size(10, 45.h),
      backgroundColor: isCall ? Constants.themeBgColor : Colors.green[900],
      visible: true,
      icon: isCall ? Icons.call : Icons.sms_outlined,
      activeIcon: Icons.close,

      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
            child: isCall
                ? const Icon(Icons.call, color: Colors.red)
                : Image.asset(
                    "assets/images/whatsapp.png",
                    height: 24.h,
                    color: Colors.green[900],
                  ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: isCall
                ? () {
                    FlutterPhoneDirectCaller.callNumber("+91$phoneNumber2");
                  }
                : () async {
                    Uri url =
                        Uri.parse("whatsapp://send?phone=91$phoneNumber2");
                    await canLaunchUrl(url)
                        ? await launchUrl(url)
                        : throw "could not launch $url";
                  },
            label: formatNumber(phoneNumber2).toString(),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: isCall ? Constants.themeBgColor : Colors.white),
            labelBackgroundColor:
                isCall ? Constants.borderColor : Colors.green[900],
            labelShadow: [
              const BoxShadow(blurRadius: 0, color: Colors.transparent)
            ]),
        SpeedDialChild(
          child: isCall
              ? const Icon(Icons.call, color: Colors.red)
              : Image.asset(
                  "assets/images/whatsapp.png",
                  height: 24.h,
                  color: Colors.green[900],
                ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: isCall
              ? () {
                  FlutterPhoneDirectCaller.callNumber("+91$phoneNumber1");
                }
              : () async {
                  Uri url = Uri.parse("whatsapp://send?phone=91$phoneNumber1");
                  await canLaunchUrl(url)
                      ? await launchUrl(url)
                      : throw "could not launch $url";
                },
          labelShadow: [
            const BoxShadow(blurRadius: 0, color: Colors.transparent)
          ],
          label: formatNumber(phoneNumber1).toString(),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: isCall ? Constants.themeBgColor : Colors.white),
          labelBackgroundColor:
              isCall ? Constants.borderColor : Colors.green[900],
        ),
      ],
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final int phoneNumber1;
  final int phoneNumber2;
  final bool isCall;
  // Add any other required parameters

  const CustomAlertDialog(
      {super.key,
      required this.phoneNumber1,
      required this.phoneNumber2,
      required this.isCall});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isCall
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        FlutterPhoneDirectCaller.callNumber("+91$phoneNumber1");
                        // TODO: Add functionality for the first button here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call,
                              color: Colors.red,
                              size: 17.h,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(formatNumber(phoneNumber1)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        FlutterPhoneDirectCaller.callNumber("+91$phoneNumber2");
                        // TODO: Add functionality for the second button here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call,
                              color: Colors.red,
                              size: 17.h,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(formatNumber(phoneNumber2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        Uri url =
                            Uri.parse("whatsapp://send?phone=91$phoneNumber1");
                        await canLaunchUrl(url)
                            ? await launchUrl(url)
                            : throw "could not launch $url";
                        // TODO: Add functionality for the first button here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/whatsapp.png",
                              height: 15.h,
                              color: Colors.greenAccent[400],
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(formatNumber(phoneNumber1)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Uri url =
                            Uri.parse("whatsapp://send?phone=91$phoneNumber1");
                        await canLaunchUrl(url)
                            ? await launchUrl(url)
                            : throw "could not launch $url";
                        // TODO: Add functionality for the first button here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/whatsapp.png",
                              height: 15.h,
                              color: Colors.greenAccent[400],
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(formatNumber(phoneNumber2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  String formatNumber(int number) {
    String numberString = number.toString();
    int length = numberString.length;

    if (length <= 3) {
      return numberString;
    }

    String asterisks = '*' * (length - 3);
    return '$asterisks${numberString.substring(length - 3)}';
  }
}
