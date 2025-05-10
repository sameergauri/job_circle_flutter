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

import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/themes/colors.dart';


import '../service/job_post_api_service.dart';

class CustomDialogueForSelect extends ConsumerStatefulWidget {
  final Applicant item;
  final Function refreshCallback;
  final DropDownItem finalDropDown;
  final Function onCancel;
  const CustomDialogueForSelect(
      {super.key,
      required this.item,
      required this.refreshCallback,
      required this.finalDropDown,
      required this.onCancel});

  @override
  ConsumerState<CustomDialogueForSelect> createState() =>
      _CustomDialogueForSelectState();
}

class _CustomDialogueForSelectState
    extends ConsumerState<CustomDialogueForSelect> {
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

  bool f2f = false, online = false;

  void someFunction() {
    // Perform some action...

    // Trigger the refresh callback
    widget.refreshCallback();
  }

  TextEditingController empid = TextEditingController();
  TextEditingController salary = TextEditingController();

  bool isMale = false;
  bool isFemale = false;
  bool fresher = false;
  bool experience = false;
  bool isSalary = false;

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
                Text("Selected ?",
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold, fontSize: 18.sp)),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            if (widget.item.company_gender == 1)
              Container(
                margin: EdgeInsets.only(top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Gender",
                            style: GoogleFonts.varela(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(" * ",
                            style: GoogleFonts.varela(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    singleSelectPicker();
                    //Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.subtitleclr)),
                    // margin: const EdgeInsets.only(top: 6),
                    child: singleSelect != null
                        ? Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Constants.borderColor,
                                radius: 11.8.r,
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 15.h,
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(singleSelect!),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Constants.borderColor,
                                radius: 11.8.r,
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 15.h,
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              const Text("Select DOJ"),
                            ],
                          ),
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
                      "assets/images/close.png",
                      height: 12.h,
                      color: Colors.grey.shade400,
                    ),
                  ),
              ],
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
            //  if (widget.item.is_ctc_pay == 1 || widget.item.is_work_pay == 1)
            Container(
              margin: EdgeInsets.only(top: 8.h),
              height: MediaQuery.of(context).size.height / 24,
              child: TextField(
                maxLength:
                    widget.item.is_ctc_pay == 1 || widget.item.is_work_pay == 1
                        ? 7
                        : 5,
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
                    prefixIcon: Icon(Icons.currency_rupee_outlined,
                        color: isSalary ? Colors.red : Constants.subtitleclr),
                    contentPadding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 10, right: 10),
                    counterText: '',
                    labelText: "Offered Salary",
                    labelStyle: GoogleFonts.varela(
                      color: isSalary ? Colors.red : Constants.subtitleclr,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                          color: isSalary ? Colors.red : Constants.lightdull),
                    ),
                    focusColor: const Color(0xffff0eceb),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: isSalary ? Colors.red : Constants.subtitleclr,
                      ),
                    ),
                    hintText: "20,000",
                    hintStyle: GoogleFonts.sourceSansPro(
                        color: isSalary ? Colors.red : Constants.hintColor,
                        fontSize: 15.sp)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    widget.onCancel();
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
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (widget.item.company_gender == 1
                    ? isMale || isFemale
                    : !isMale)
                  InkWell(
                    onTap: () async {
                      int digitCount = salary.text.length;
                      if ((widget.item.is_ctc_pay == 1 ||
                              widget.item.is_work_pay == 1) &&
                          digitCount < 6 &&
                          salary.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Salary Should be CTC based",
                                error: true));
                      } else if ((widget.item.is_ctc_pay == 0 ||
                              widget.item.is_work_pay == 0) &&
                          digitCount < 4 &&
                          salary.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbarfinal(
                                title: "Salary Should be Monthly bases",
                                error: true));
                      } else {
                        NewChangeStatusModel changeStatusModel =
                            NewChangeStatusModel(
                                empId: empid.text.isEmpty ? null : empid.text,

                                /* widget.secStatusId ==
                                      16 //TODO:: ID of "not join"..
                                  ? 0
                                  : widget.statusId, */

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
                                hrStatusId: widget.finalDropDown.priStatusId,
                                //  statusId: widget.finalDropDown.statusId, //TODO:: Previous one before new modification
                                statusId: 0,
                                doj: singleSelect,
                                // mode_document: f2f ? 0 : 1,
                                document_status: "Not Submitted");
                        Map<String, dynamic> jsonData =
                            changeStatusModel.toJson();
                        try {
                          await JobPostApiService.NewchangeStatus(
                              jsonData, widget.item.id!.toInt());
                          /* fetchApplicants = ref
                .refresh(fetchAllApplicantProvider(profilemodel.id!.toInt())); */
                          setState(() {});
                          someFunction();
                         
                          ref.refresh(fetchAllReferalProvider);
                          ref.refresh(fetchAllApplyProvider);
                         
                          Navigator.pop(context);
                        } catch (e) {
                          print('Error: $e');
                          // Handle error...
                        }
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
            width: MediaQuery.of(context).size.width / 3.w,

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color:
                    // isSelect ? const Color(0xfff310d44) :
                    isSelect ? Colors.grey : null,
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
                        color: isSelect ? Colors.white : null,
                        fontSize: 15.sp,
                        fontWeight:
                            isSelect ? FontWeight.bold : FontWeight.normal)),
              ],
            )));
  }
}

class CustomDialogueForRemark extends StatefulWidget {
  final Function onTab;
  final TextEditingController controller;
  final Function(String) callBack;
  final Applicant item;
  final String hint;
  final Function onCancel;

  const CustomDialogueForRemark(
      {super.key,
      required this.onTab,
      required this.controller,
      required this.item,
      required this.callBack,
      required this.hint,
      required this.onCancel});

  @override
  State<CustomDialogueForRemark> createState() =>
      _CustomDialogueForRemarkState();
}

class _CustomDialogueForRemarkState extends State<CustomDialogueForRemark> {
  @override
  void dispose() {
    // Clear the controller when the state is disposed
    remarkController.dispose();
    super.dispose();
  }

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
                    widget.onCancel();
                    Navigator.pop(context);
                    // remarkController.clear();
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

                GestureDetector(
                  onTap: () async {
                    if (remarkController.text.isNotEmpty) {
                      await widget.onTab();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbarfinal(
                              title: "Specify proper reason", error: true));
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
