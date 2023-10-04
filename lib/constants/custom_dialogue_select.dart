import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/themes/colors.dart';

import '../service/job_post_api_service.dart';

class CustomDialogueForSelect extends StatefulWidget {
  final Applicant item;
  final Function refreshCallback;
  const CustomDialogueForSelect(
      {super.key, required this.item, required this.refreshCallback});

  @override
  State<CustomDialogueForSelect> createState() =>
      _CustomDialogueForSelectState();
}

class _CustomDialogueForSelectState extends State<CustomDialogueForSelect> {
  DateTime initialDate = DateTime.now();
  DateTime lastAllowedDate = DateTime.now().add(const Duration(days: 4 * 31));
  DateTime? singleSelect;

  Future<void> singleSelectPicker() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AwesomeCalendarDialog(
            initialDate: initialDate,
            startDate: initialDate,
            endDate: lastAllowedDate,
            selectionMode: SelectionMode.single,
            cancelBtnText: "Back",
            confirmBtnText: "OK",
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        singleSelect = picked;
      });
      print(picked);
    }
  }

  /* Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    DateTime lastAllowedDate = currentDate.add(const Duration(days: 4 * 31));

    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = currentDate;

        return AlertDialog(
          title: const Text("Date of Joining"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DatePickerWidget(
                    initialDate: currentDate,
                    firstDate: currentDate,
                    lastDate: lastAllowedDate,
                    dateFormat: "dd-MMM-yyyy",
                    locale: DateTimePickerLocale.en_us,
                    looping: false,
                    pickerTheme: const DateTimePickerTheme(
                      itemTextStyle:
                          TextStyle(color: Colors.black, fontSize: 19),
                      dividerColor: Colors.blue,
                    ),
                    onChange: (DateTime newDate, _) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                  ),
                  InkWell(
                    onTap: () {
                      ChangeStatusModel changeStatusModel = ChangeStatusModel(
                        status: "IB7",
                        subStatus: "Confirmation Pending",
                        doj: selectedDate,
                        id: widget.item.id,
                        sourceId: widget.item.sourceId,
                      );
                      Map<String, dynamic> jsonData =
                          changeStatusModel.toJson();
                      try {
                        JobPostApiService.changeStatus(
                            jsonData, widget.item.id!.toInt());
                        setState(() {});
                      } catch (e) {
                        print('Error: $e');
                        // Handle error...
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: Text(
                        "Submit",
                        style: GoogleFonts.varela(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  } */

  /*  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DatePickerWidget picked = DatePickerWidget(
      looping: false, // default is not looping
      firstDate: DateTime(1990, 01, 01),
      lastDate: DateTime(2030, 1, 1),
      initialDate: DateTime(1991, 10, 12),
      dateFormat: "dd-MMM-yyyy",
      locale: DatePicker.localeFromString('en'),
      onChange: (DateTime newDate, _) => selectedDate = newDate,
      pickerTheme: const DateTimePickerTheme(
        itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
        dividerColor: Colors.blue,
      ),
    );

    /* showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: currentDate,
            minimumDate: currentDate,
            maximumDate: DateTime(2101),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        );
      },
    ); */
    /* if (picked != selectedDate) {
      setState(() {
        selectedDate = picked as DateTime;
      });
    } */
  } */

  bool f2f = false, online = false;

  void someFunction() {
    // Perform some action...

    // Trigger the refresh callback
    widget.refreshCallback();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding:
            EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w, bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Mode of Documentation",
              style: GoogleFonts.varela(
                  fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      f2f = true;
                      online = false;
                    });
                    //  singleSelectPicker();
                    //Navigator.pop(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 2.4.h,
                            bottom: 2.4.h,
                            left: width / 15.w,
                            right: 6.h),
                        // margin: const EdgeInsets.only(top: 6),
                        child: const Text("Manual / F2F"),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                topRight: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r)),
                            border: Border.all(color: Constants.borderColor)),
                      ),
                      CircleAvatar(
                        backgroundColor: Constants.borderColor,
                        radius: 11.8.r,
                        child: Icon(
                          f2f ? Icons.check_sharp : null,
                          size: 15.h,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      f2f = false;
                      online = true;
                    });
                    //  singleSelectPicker();
                    //Navigator.pop(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 2.4.h,
                            bottom: 2.4.h,
                            left: width / 15.w,
                            right: 6.h),
                        // margin: const EdgeInsets.only(top: 6),
                        child: const Text("Digital / E-Mail"),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                topRight: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r)),
                            border: Border.all(color: Constants.borderColor)),
                      ),
                      CircleAvatar(
                        backgroundColor: Constants.borderColor,
                        radius: 11.8.r,
                        child: Icon(
                          online ? Icons.check_sharp : null,
                          size: 15.h,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Date of Joining",
              style: GoogleFonts.varela(
                  fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    singleSelectPicker();
                    //Navigator.pop(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 2.4.h,
                            bottom: 2.4.h,
                            left: width / 15.w,
                            right: 6.h),
                        // margin: const EdgeInsets.only(top: 6),
                        child: singleSelect != null
                            ? Text(
                                DateFormat('dd MMM yyyy').format(singleSelect!),
                              )
                            : const Text("Select DOJ"),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                topRight: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r)),
                            border: Border.all(color: Constants.borderColor)),
                      ),
                      CircleAvatar(
                        backgroundColor: Constants.borderColor,
                        radius: 11.8.r,
                        child: Icon(
                          Icons.calendar_month,
                          size: 15.h,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      singleSelect = null;
                    });
                  },
                  child: Image.asset(
                    "assets/images/close (1).png",
                    height: 16.h,
                    color: Colors.grey.shade400,
                  ),
                ),
                /* InkWell(
                  onTap: () {
                    ChangeStatusModel changeStatusModel = ChangeStatusModel(
                      status: "IB7",
                      subStatus: "Confirmation Pending",
                      id: widget.item.id,
                      sourceId: widget.item.sourceId,
                    );
                    Map<String, dynamic> jsonData = changeStatusModel.toJson();
                    try {
                      JobPostApiService.changeStatus(
                          jsonData, widget.item.id!.toInt());
                      setState(() {});
                    } catch (e) {
                      print('Error: $e');
                      // Handle error...
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 2.4.h,
                            bottom: 2.4.h,
                            left: width / 15.w,
                            right: 6.h),
                        // margin: const EdgeInsets.only(top: 6),
                        child: const Text("Not Confirmed Yet"),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                topRight: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r)),
                            border: Border.all(color: Constants.borderColor)),
                      ),
                      CircleAvatar(
                        backgroundColor: Constants.borderColor,
                        radius: 11.r,
                        backgroundImage: const AssetImage(
                          "assets/images/canceled_select.png",
                        ),
                      )
                    ],
                  ),
                ), */
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                f2f == true || online == true
                    ? InkWell(
                        onTap: () async {
                          ChangeStatusModel changeStatusModel =
                              ChangeStatusModel(
                                  status: "IB7",
                                  subStatus: "Confirmation Pending",
                                  doj: singleSelect,
                                  id: widget.item.id,
                                  sourceId: widget.item.sourceId,
                                  mode_document: f2f ? 0 : 1,
                                  document_status:
                                      f2f ? "Schedule F2F" : "Not Submitted");
                          Map<String, dynamic> jsonData =
                              changeStatusModel.toJson();
                          try {
                            await JobPostApiService.changeStatus(
                                jsonData, widget.item.id!.toInt());
                            /* fetchApplicants = ref
                .refresh(fetchAllApplicantProvider(profilemodel.id!.toInt())); */
                            setState(() {});
                            someFunction();
                            Navigator.pop(context);
                          } catch (e) {
                            print('Error: $e');
                            // Handle error...
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text("Submit",
                              style: GoogleFonts.varela(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    : const SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }
}
