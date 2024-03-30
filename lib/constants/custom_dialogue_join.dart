// ignore_for_file: unused_result, use_build_context_synchronously, avoid_print, unused_local_variable, duplicate_ignore
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class CustomDialogueForJoin extends ConsumerStatefulWidget {
  final Applicant item;
  final int secStatusId;
  final int statusId;
  final Function onCancel;
  final Function onTab;

  const CustomDialogueForJoin(
      {super.key,
      required this.item,
      required this.secStatusId,
      required this.statusId,
      required this.onCancel,
      required this.onTab
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
                      widget.onCancel();
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

                InkWell(
                  onTap: () async {
                    NewChangeStatusModel changeStatusModel =
                        NewChangeStatusModel(
                            doj: widget.item.doj,
                            hrStatusId: widget.item.hr_status_id,
                            /* widget.secStatusId ==
                                      16 //TODO:: ID of "not join"..
                                  ? 0
                                  : widget.statusId, */
                            statusId: widget.secStatusId,
                            attrStatus: "Under Clause",
                            /*  attrStatus: widget.item.is_ref == 1  //TODO: old
                                  ? "Under Clause"
                                  : null, */
                            isJoinSubmitted: widget.item.company_workstatus == 1 &&
                                    widget.item.empCID == 1 &&
                                    (widget.item.is_exp == 1 ||
                                        widget.item.is_exp == 0) &&
                                    widget.item.emp_id != null &&
                                    widget.item.salary != null &&
                                    widget.item.document_status == "Submitted"
                                ? 1
                                : widget.item.company_workstatus == 1 &&
                                        (widget.item.empCID == 0 ||
                                            widget.item.empCID == null) &&
                                        (widget.item.is_exp == 1 ||
                                            widget.item.is_exp == 0) &&
                                        widget.item.emp_id == null &&
                                        widget.item.salary == null &&
                                        widget.item.document_status ==
                                            "Submitted"
                                    ? 1
                                    : (widget.item.company_workstatus == 0 ||
                                                widget.item.company_workstatus ==
                                                    null) &&
                                            widget.item.empCID == 1 &&
                                            (widget.item.is_exp == null ||
                                                widget.item.is_exp == null) &&
                                            widget.item.emp_id != null &&
                                            widget.item.salary == null &&
                                            widget.item.document_status ==
                                                "Submitted"
                                        ? 1
                                        : (widget.item.company_workstatus == 0 ||
                                                    widget.item.company_workstatus ==
                                                        null) &&
                                                (widget.item.empCID == 0 ||
                                                    widget.item.empCID ==
                                                        null) &&
                                                (widget.item.is_exp == null ||
                                                    widget.item.is_exp ==
                                                        null) &&
                                                widget.item.emp_id == null &&
                                                widget.item.document_status ==
                                                    "Submitted"
                                            ? 1
                                            : (widget.item.company_workstatus == 0 ||
                                                        widget.item.company_workstatus == null) &&
                                                    (widget.item.empCID == 0 || widget.item.empCID == null) &&
                                                    (widget.item.is_exp == null || widget.item.is_exp == null) &&
                                                    widget.item.emp_id == null &&
                                                    widget.item.salary != null &&
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
                                                        widget.itzem.empCID ==
                                                            1 &&zzzzzzzzzzzzzz
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
                    Map<String, dynamic> jsonData = changeStatusModel.toJson();
                    try {
                      await JobPostApiService.NewchangeStatus(
                          jsonData, widget.item.id!.toInt());
                      ref.refresh(fetchAllApplicantProvider);
                      ref.refresh(fetchAllReferalProvider);
                      ref.refresh(fetchAllApplyProvider);
                      widget.onTab();
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
