// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/service/job_post_api_service.dart';
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

class CustomAlertDialog extends ConsumerStatefulWidget {
  final int phoneNumber1;
  final int phoneNumber2;
  final bool isCall;
  final String firstName;
  final String lastName;
  final int leadID;
  final Applicant item;
  final int id;
  final String sourcename;
  // Add any other required parameters

  const CustomAlertDialog(
      {super.key,
      required this.phoneNumber1,
      required this.phoneNumber2,
      required this.isCall,
      required this.firstName,
      required this.lastName,
      required this.leadID,
      required this.item,
      required this.id,
      required this.sourcename,
      
      });

  @override
  ConsumerState<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends ConsumerState<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 10),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isCall
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Initiate call to ${widget.firstName.toTitleCase()} ${widget.lastName.toTitleCase()}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              await FlutterPhoneDirectCaller.callNumber(
                                  "+91${widget.phoneNumber1}");
                              if (widget.item.hr_status_id == 10 ||
                                  widget.item.s2DdHrStatusId == 10) {
                                try {
                                  NewChangeStatusModel changeStatusModel =
                                      NewChangeStatusModel(
                                          statusId: 6,
                                          hrStatusId: 18,
                                          sourceId: widget.id,
                                          sourceName: widget.sourcename,
                                          dol: DateTime.now(),
                                          );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();

                                  await JobPostApiService.NewchangeStatus(
                                      jsonData, widget.leadID);

                                  // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                                  ref.refresh(fetchAllApplicantProvider);
                                } catch (e) {
                                  print('Error: $e');
                                  // Handle error...
                                }
                              }
                              Navigator.pop(context);
                              // TODO: Add functionality for the first button here
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0.5, 2),
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: Colors.grey.shade200)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Constants.themeBgColor,
                                    size: 17.h,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(formatNumber(widget.phoneNumber1)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await FlutterPhoneDirectCaller.callNumber(
                                  "+91${widget.phoneNumber2}");

                              if (widget.item.hr_status_id == 10 ||
                                  widget.item.s2DdHrStatusId == 10) {
                                try {
                                  NewChangeStatusModel changeStatusModel =
                                      NewChangeStatusModel(
                                          statusId: 6,
                                          hrStatusId: 18,
                                          sourceId: widget.id,
                                          dol: DateTime.now(),
                                           sourceName: widget.sourcename);
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();

                                  await JobPostApiService.NewchangeStatus(
                                      jsonData, widget.leadID);

                                  // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                                  ref.refresh(fetchAllApplicantProvider);
                                } catch (e) {
                                  print('Error: $e');
                                  // Handle error...
                                }
                              }
                              Navigator.pop(context);

                              // TODO: Add functionality for the second button here
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0.5, 2),
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: Colors.grey.shade200)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Constants.themeBgColor,
                                    size: 17.h,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(formatNumber(widget.phoneNumber2)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Initiate chat with ${widget.firstName.toTitleCase()} ${widget.lastName.toTitleCase()}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              Uri url = Uri.parse(
                                  "whatsapp://send?phone=91${widget.phoneNumber1}");
                              await canLaunchUrl(url)
                                  ? await launchUrl(url)
                                  : throw "could not launch $url";
                              if (widget.item.hr_status_id == 10 ||
                                  widget.item.s2DdHrStatusId == 10) {
                                try {
                                  NewChangeStatusModel changeStatusModel =
                                      NewChangeStatusModel(
                                          statusId: 6,
                                          hrStatusId: 18,
                                          sourceId: widget.id,
                                          dol: DateTime.now(),
                                           sourceName: widget.sourcename
                                          );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();

                                  await JobPostApiService.NewchangeStatus(
                                      jsonData, widget.leadID);

                                  // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                                  ref.refresh(fetchAllApplicantProvider);
                                } catch (e) {
                                  print('Error: $e');
                                  // Handle error...
                                }
                              }
                              // TODO: Add functionality for the first button here
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0.5, 2),
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: Colors.grey.shade200)
                                ],
                                color: Colors.white,
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
                                  Text(formatNumber(widget.phoneNumber1)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              Uri url = Uri.parse(
                                  "whatsapp://send?phone=91${widget.phoneNumber2}");
                              await canLaunchUrl(url)
                                  ? await launchUrl(url)
                                  : throw "could not launch $url";
                              if (widget.item.hr_status_id == 10 ||
                                  widget.item.s2DdHrStatusId == 10) {
                                try {
                                  NewChangeStatusModel changeStatusModel =
                                      NewChangeStatusModel(
                                          statusId: 6,
                                          hrStatusId: 18,
                                          sourceId: widget.id,
                                          dol: DateTime.now(),
                                           sourceName: widget.sourcename);
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();

                                  await JobPostApiService.NewchangeStatus(
                                      jsonData, widget.leadID);

                                  // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                                  ref.refresh(fetchAllApplicantProvider);
                                } catch (e) {
                                  print('Error: $e');
                                  // Handle error...
                                }
                              }
                              // TODO: Add functionality for the first button here
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0.5, 2),
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: Colors.grey.shade200)
                                ],
                                color: Colors.white,
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
                                  Text(formatNumber(widget.phoneNumber2)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
          ],
        ),
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
