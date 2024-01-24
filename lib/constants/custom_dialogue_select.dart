// ignore_for_file: avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, unused_local_variable, duplicate_ignore, unused_result, use_full_hex_values_for_flutter_colors
// ignore_for_file: todo
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/themes/colors.dart';

import '../service/job_post_api_service.dart';

class CustomDialogueForSelect extends StatefulWidget {
  final Applicant item;
  final Function refreshCallback;
  final DropDownItem finalDropDown;
  const CustomDialogueForSelect(
      {super.key,
      required this.item,
      required this.refreshCallback,
      required this.finalDropDown});

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
    // ignore: unused_local_variable
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*  Text(
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                topRight: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r)),
                            border: Border.all(color: Constants.borderColor)),
                        // margin: const EdgeInsets.only(top: 6),
                        child: const Text("Manual / F2F"),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                topRight: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r)),
                            border: Border.all(color: Constants.borderColor)),
                        // margin: const EdgeInsets.only(top: 6),
                        child: const Text("Digital / E-Mail"),
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
            ), */
            Text(
              "Date of Joining",
              style: GoogleFonts.varela(
                  fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                bottomLeft: const Radius.circular(15),
                                topRight: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r)),
                            border: Border.all(color: Constants.borderColor)),
                        // margin: const EdgeInsets.only(top: 6),
                        child: singleSelect != null
                            ? Text(
                                DateFormat('dd MMM yyyy').format(singleSelect!),
                              )
                            : const Text("Select DOJ"),
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
                if (singleSelect != null)
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
                InkWell(
                  onTap: () async {
                    NewChangeStatusModel changeStatusModel =
                        NewChangeStatusModel(
                            hrStatusId: widget.finalDropDown.priStatusId,
                            statusId: widget.finalDropDown.statusId,
                            doj: singleSelect,
                            // mode_document: f2f ? 0 : 1,
                            document_status: "Not Submitted");
                    Map<String, dynamic> jsonData = changeStatusModel.toJson();
                    try {
                      await JobPostApiService.NewchangeStatus(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text("Submit",
                        style: GoogleFonts.varela(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialogueForRemark extends StatefulWidget {
  final Function onTab;
  final TextEditingController controller;
  final Function(String) callBack;
  final Applicant item;
  final String hint;

  const CustomDialogueForRemark({
    super.key,
    required this.onTab,
    required this.controller,
    required this.item,
    required this.callBack,
    required this.hint,
  });

  @override
  State<CustomDialogueForRemark> createState() =>
      _CustomDialogueForRemarkState();
}

class _CustomDialogueForRemarkState extends State<CustomDialogueForRemark> {
  TextEditingController remarkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Feedback on",
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold, fontSize: 18.sp)),
                Text(
                    " ${widget.item.applicantName.toString().toTitleCase()} ${widget.item.last_name.toString().toTitleCase()} ",
                    style: GoogleFonts.varela(
                        color: Constants.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp)),
                Text("application.",
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold, fontSize: 18.sp)),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              height: MediaQuery.of(context).size.height / 24.h,
              child: TextField(
                /*   inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ], */
                /* <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter,
                ], */
                /*  validator: (value) {
                        if (value == null || value.isEmpty) {
              //return "This Text field Cant be empty";
                        }
                        return null;
                      }, */

                keyboardType: TextInputType.name,
                //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                textCapitalization: TextCapitalization.sentences,
                controller: remarkController,
                onChanged: (value) {
                  widget.callBack(value);
                },
                onTap: (() {}),
                style: GoogleFonts.varela(
                    color: Constants.subtitleclr, fontSize: 14.sp),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Constants.borderColor,
                    prefixIcon: const Icon(Icons.rate_review_outlined),
                    prefixIconColor: Constants.themeBgColor,
                    contentPadding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 10, right: 10),
                    counterText: '',
                    labelText: "Remark",
                    labelStyle: const TextStyle(
                      color: Constants.themeBgColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: Color(0xffff0eceb)),
                    ),
                    focusColor: const Color(0xffff0eceb),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: Constants.themeBgColor,
                      ),
                    ),
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.sourceSansPro(
                        color: Constants.hintColor, fontSize: 15.sp)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    remarkController.clear();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text("Cancel",
                        style: GoogleFonts.varela(fontWeight: FontWeight.bold)),
                  ),
                ),
                //if (remarkController.text.isNotEmpty)

                InkWell(
                  onTap: remarkController.text.isNotEmpty
                      ? () async {
                          await widget.onTab();
                          remarkController.clear();
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackbarfinal(
                                  title: "Specify proper reason", error: true));
                        },
                  child: Container(
                    margin: EdgeInsets.only(top: 15.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text("Submit",
                        style: GoogleFonts.varela(
                            color: Constants.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialogueForJoin extends ConsumerStatefulWidget {
  final Applicant item;
  final int secStatusId;
  final int statusId;

  const CustomDialogueForJoin(
      {super.key,
      required this.item,
      required this.secStatusId,
      required this.statusId
      //   required this.controller,
      //  required this.callBack
      });

  @override
  ConsumerState<CustomDialogueForJoin> createState() =>
      _CustomDialogueForJoinState();
}

class _CustomDialogueForJoinState extends ConsumerState<CustomDialogueForJoin> {
  TextEditingController empid = TextEditingController();
  TextEditingController salary = TextEditingController();
  bool isMale = false;
  bool isFemale = false;
  bool fresher = false;
  bool experience = false;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.item.empCID == 0 &&
                widget.item.company_gender == 0 &&
                (widget.item.is_ctc_pay == 0 || widget.item.is_work_pay == 0) &&
                // widget.item.company_salary == 0 &&
                (widget.item.company_workstatus == 0 ||
                    widget.item.company_workstatus == null))
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Has",
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  Text(
                      " ${widget.item.applicantName.toString().toTitleCase()} ${widget.item.last_name.toString().toTitleCase()} ",
                      style: GoogleFonts.varela(
                          color: Constants.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp)),
                  Text("Joined ?",
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 18.sp)),
                ],
              ),
            if (widget.item.empCID != 0 &&
                widget.item.company_gender != 0 &&
                (widget.item.is_ctc_pay != 0 || widget.item.is_work_pay != 0)
                // widget.item.company_salary != 0
                &&
                (widget.item.company_workstatus != 0 ||
                    widget.item.company_workstatus != null))
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Additional details of ",
                      style: GoogleFonts.varela(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp)),
                  Text(
                      "${widget.item.applicantName.toString().toTitleCase()} ${widget.item.last_name.toString().toTitleCase()}",
                      style: GoogleFonts.varela(
                          color: Constants.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp))
                ],
              ),
            if (widget.item.company_gender == 1)
              Container(
                margin: EdgeInsets.only(top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Gender",
                        style: GoogleFonts.varela(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    // if (widget.item.company_gender == 1)
                    Row(
                      children: [
                        customContainerMale(
                            onPressed: () {
                              setState(() {
                                isMale = true;
                                isFemale = false;
                              });
                            },
                            isSelect: isMale,
                            title: "Male",
                            img: "assets/images/male1.png",
                            isimage: true),
                        customContainerMale(
                            onPressed: () {
                              setState(() {
                                isMale = false;

                                isFemale = true;
                              });
                            },
                            isSelect: isFemale,
                            title: "Female",
                            img: "assets/images/female1.png",
                            isimage: true)
                      ],
                    ),
                  ],
                ),
              ),
            if (widget.item.company_workstatus != null &&
                widget.item.company_workstatus == 1)
              Container(
                // margin: EdgeInsets.only(top: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Work Status",
                        style: GoogleFonts.varela(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    // if (widget.item.company_gender == 1)
                    Row(
                      children: [
                        customContainerMale(
                            onPressed: () {
                              setState(() {
                                fresher = !fresher;
                                experience = false;
                              });
                            },
                            isSelect: fresher,
                            title: "Fresher",
                            img: "",
                            isimage: false),
                        customContainerMale(
                            onPressed: () {
                              setState(() {
                                fresher = false;

                                experience = !experience;
                              });
                            },
                            isSelect: experience,
                            title: "Experience",
                            img: "",
                            isimage: false)
                      ],
                    ),
                  ],
                ),
              ),
            if (widget.item.empCID == 1)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                height: MediaQuery.of(context).size.height / 24,
                child: TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                  ],

                  keyboardType: TextInputType.name,
                  //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                  textCapitalization: TextCapitalization.sentences,
                  controller: empid,

                  style: GoogleFonts.varela(
                      color: Constants.subtitleclr, fontSize: 14.sp),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: Constants.subtitleclr,
                      ),
                      prefixIconColor: Constants.themeBgColor,
                      contentPadding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 10, right: 10),
                      counterText: '',
                      labelText: "Emp ID",
                      labelStyle: const TextStyle(
                        color: Constants.subtitleclr,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Constants.lightdull),
                      ),
                      focusColor: const Color(0xffff0eceb),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: Constants.subtitleclr,
                        ),
                      ),
                      hintText: "E1515115....",
                      hintStyle: GoogleFonts.sourceSansPro(
                          color: Constants.hintColor, fontSize: 15.sp)),
                ),
              ),
            if (widget.item.is_ctc_pay == 1 || widget.item.is_work_pay == 1)
              Container(
                margin: EdgeInsets.only(top: 8.h),
                height: MediaQuery.of(context).size.height / 24,
                child: TextField(
                  maxLength: 7,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],

                  keyboardType: TextInputType.number,
                  //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                  textCapitalization: TextCapitalization.sentences,
                  controller: salary,

                  style: GoogleFonts.varela(
                      color: Constants.subtitleclr, fontSize: 14.sp),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      prefixIcon: const Icon(Icons.currency_rupee_outlined,
                          color: Constants.subtitleclr),
                      contentPadding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 10, right: 10),
                      counterText: '',
                      labelText: "Salary",
                      labelStyle: const TextStyle(
                        color: Constants.subtitleclr,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Constants.lightdull),
                      ),
                      focusColor: const Color(0xffff0eceb),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: Constants.subtitleclr,
                        ),
                      ),
                      hintText: "20,000",
                      hintStyle: GoogleFonts.sourceSansPro(
                          color: Constants.hintColor, fontSize: 15.sp)),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.item.empCID != 0 ||
                    widget.item.company_gender != 0 ||
                    // widget.item.company_salary != 0 ||
                    widget.item.is_ctc_pay == 1 ||
                    widget.item.is_work_pay == 1 ||
                    (widget.item.company_workstatus != 0 ||
                        widget.item.company_workstatus != null))
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      empid.clear();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15.h),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text("Cancel",
                          style: GoogleFonts.varela(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                //if (remarkController.text.isNotEmpty)
                if (widget.item.company_gender == 1
                    ? isMale || isFemale
                    : !isMale)
                  InkWell(
                    onTap: () async {
                      NewChangeStatusModel changeStatusModel =
                          NewChangeStatusModel(
                              empId: empid.text.isEmpty ? null : empid.text,
                              doj: widget.item.doj,
                              hrStatusId: widget.item.hr_status_id,
                              /* widget.secStatusId ==
                                      16 //TODO:: ID of "not join"..
                                  ? 0
                                  : widget.statusId, */
                              statusId: widget.secStatusId,
                              salary: salary.text.isNotEmpty
                                  ? double.tryParse(salary.text)
                                  : null,
                              commercial_gender: isMale
                                  ? "Male"
                                  : isFemale
                                      ? "Female"
                                      : null,
                              isExp: fresher
                                  ? 0
                                  : experience
                                      ? 1
                                      : null,
                              isJoinSubmitted: widget.item.company_workstatus == 1 &&
                                      widget.item.empCID == 1 &&
                                      (widget.item.is_ctc_pay == 1 ||
                                          widget.item.is_work_pay == 1) &&
                                      (fresher || experience) &&
                                      empid.text.isNotEmpty &&
                                      salary.text.isNotEmpty &&
                                      widget.item.document_status == "Submitted"
                                  ? 1
                                  : widget.item.company_workstatus == 1 &&
                                          (widget.item.empCID == 0 ||
                                              widget.item.empCID == null) &&
                                          (widget.item.is_ctc_pay == 0 ||
                                              widget.item.is_work_pay == 0) &&
                                          (fresher || experience) &&
                                          empid.text.isEmpty &&
                                          salary.text.isEmpty &&
                                          widget.item.document_status ==
                                              "Submitted"
                                      ? 1
                                      : (widget.item.company_workstatus == 0 ||
                                                  widget.item.company_workstatus ==
                                                      null) &&
                                              widget.item.empCID == 1 &&
                                              (widget.item.is_ctc_pay == 0 ||
                                                  widget.item.is_work_pay ==
                                                      0) &&
                                              (!fresher || !experience) &&
                                              empid.text.isNotEmpty &&
                                              salary.text.isEmpty &&
                                              widget.item.document_status ==
                                                  "Submitted"
                                          ? 1
                                          : (widget.item.company_workstatus == 0 || widget.item.company_workstatus == null) &&
                                                  (widget.item.empCID == 0 ||
                                                      widget.item.empCID ==
                                                          null) &&
                                                  (widget.item.is_ctc_pay == 1 ||
                                                      widget.item.is_work_pay ==
                                                          1) &&
                                                  (!fresher || !experience) &&
                                                  empid.text.isEmpty &&
                                                  salary.text.isNotEmpty &&
                                                  widget.item.document_status ==
                                                      "Submitted"
                                              ? 1
                                              : (widget.item.company_workstatus == 0 || widget.item.company_workstatus == null) &&
                                                      (widget.item.empCID == 0 ||
                                                          widget.item.empCID == null) &&
                                                      (widget.item.is_ctc_pay == 0 || widget.item.is_work_pay == 0) &&
                                                      (!fresher || !experience) &&
                                                      empid.text.isEmpty &&
                                                      salary.text.isEmpty &&
                                                      widget.item.document_status == "Submitted"
                                                  ? 1
                                                  : null

                              /* widget.item.company_salary == 1 &&
                                            widget.item.company_workstatus ==
                                                1 &&
                                            widget.item.empCID == 1 &&
                                            (fresher || experience) &&
                                            empid.text.isNotEmpty &&
                                            salary.text.isNotEmpty &&
                                            widget.item.document_status ==
                                                "Submitted"
                                        ? 1
                                        : widget.item.company_salary == 1 &&
                                                widget.item.company_workstatus ==
                                                    1 &&
                                                (fresher || experience) &&
                                                salary.text.isNotEmpty &&
                                                widget.item.document_status ==
                                                    "Submitted"
                                            ? 1
                                            : widget.item.company_workstatus == 1 &&
                                                    widget.item.empCID == 1 &&
                                                    (fresher || experience) &&
                                                    empid.text.isNotEmpty &&
                                                    widget.item.document_status ==
                                                        "Submitted"
                                                ? 1
                                                : widget.item.company_salary == 1 &&
                                                        widget.item.empCID ==
                                                            1 &&
                                                        salary
                                                            .text.isNotEmpty &&
                                                        empid.text.isNotEmpty &&
                                                        widget.item.document_status ==
                                                            "Submitted"
                                                    ? 1
                                                    : widget.item.company_salary == 0 &&
                                                            widget.item.empCID ==
                                                                1 &&
                                                            salary
                                                                .text.isEmpty &&
                                                            empid.text
                                                                .isNotEmpty &&
                                                            widget.item.company_workstatus ==
                                                                0 &&
                                                            widget.item.document_status ==
                                                                "Submitted"
                                                        ? 1
                                                        : widget.item.company_salary == 0 &&
                                                                widget.item.empCID ==
                                                                    0 &&
                                                                salary.text
                                                                    .isEmpty &&
                                                                widget.item.company_workstatus ==
                                                                    1 &&
                                                                empid.text
                                                                    .isEmpty &&
                                                                (fresher || experience) &&
                                                                widget.item.document_status == "Submitted"
                                                            ? 1
                                                            : widget.item.company_salary == 1 && widget.item.empCID == 0 && salary.text.isNotEmpty && widget.item.company_workstatus == 1 && empid.text.isEmpty && widget.item.document_status == "Submitted"
                                                                ? 1
                                                                : null */
                              );
                      Map<String, dynamic> jsonData =
                          changeStatusModel.toJson();
                      try {
                        await JobPostApiService.NewchangeStatus(
                            jsonData, widget.item.id!.toInt());
                        ref.refresh(fetchAllApplicantProvider);
                        ref.refresh(fetchAllReferalProvider);
                        ref.refresh(fetchAllApplyProvider);
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error: $e');
                        // Handle error...
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15.h),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                          widget.item.empCID == 0 &&
                                  widget.item.company_gender == 0 &&
                                  widget.item.company_salary == 0 &&
                                  (widget.item.company_workstatus == 0 ||
                                      widget.item.company_workstatus == null)
                              ? "Yes"
                              : "Submit",
                          style: GoogleFonts.varela(
                              color: Constants.blue,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                /*          InkWell(
                          onTap: () async {
                            NewChangeStatusModel changeStatusModel =
                                NewChangeStatusModel(
                                    empId:
                                        empid.text.isEmpty ? null : empid.text,
                                    doj: widget.item.doj,
                                    hrStatusId: (fresher || experience) &&
                                            empid.text.isNotEmpty &&
                                            salary.text.isNotEmpty &&
                                            widget.item.document_status ==
                                                "Submitted"
                                        ? 0
                                        : widget.item.hr_status_id,
                                    /* widget.secStatusId ==
                                      16 //TODO:: ID of "not join"..
                                  ? 0
                                  : widget.statusId, */
                                    statusId: widget.secStatusId,
                                    salary: salary.text.isNotEmpty
                                        ? double.tryParse(salary.text)
                                        : null,
                                    commercial_gender: isMale
                                        ? "Male"
                                        : isFemale
                                            ? "Female"
                                            : null,
                                    isExp: fresher
                                        ? 0
                                        : experience
                                            ? 1
                                            : null);
                            Map<String, dynamic> jsonData =
                                changeStatusModel.toJson();
                            try {
                              await JobPostApiService.NewchangeStatus(
                                  jsonData, widget.item.id!.toInt());
                              ref.refresh(fetchAllApplicantProvider);
                              ref.refresh(fetchAllReferalProvider);
                              ref.refresh(fetchAllApplyProvider);
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
                            child: Text(
                                widget.item.empCID == 0 &&
                                        widget.item.company_gender == 0 &&
                                        widget.item.company_salary == 0 &&
                                        (widget.item.company_workstatus == 0 ||
                                            widget.item.company_workstatus ==
                                                null)
                                    ? "Yes"
                                    : "Submit",
                                style: GoogleFonts.varela(
                                    color: Constants.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
              */
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell customContainerMale(
      {required final VoidCallback onPressed,
      required bool isSelect,
      required String title,
      required String img,
      required bool isimage,
      bool? isSalary = false}) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            //  width: MediaQuery.of(context).size.width / 2.5.w,

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color:
                    // isSelect ? const Color(0xfff310d44) :
                    isSelect ? Constants.lightdull : null,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Constants.subtitleclr)),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isimage)
                  Image.asset(
                    img,
                    height: 20,
                  ),
                if (isimage)
                  const SizedBox(
                    width: 10,
                  ),
                Text(title,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.subtitleclr,
                        fontSize: 15.sp,
                        fontWeight:
                            isSelect ? FontWeight.bold : FontWeight.normal)),
              ],
            )));
  }
}
