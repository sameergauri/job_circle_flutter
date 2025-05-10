// ignore_for_file: must_be_immutable, unused_result, use_build_context_synchronously, avoid_print
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';


import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/themes/colors.dart';

import '../models/changeStatusModel.dart';
import '../models/fetch_applied_job_model.dart';
import '../service/job_post_api_service.dart';

class CustomDialogueForJoin extends ConsumerStatefulWidget {
  Applicant item;
  CustomDialogueForJoin({super.key, required this.item});

  @override
  ConsumerState<CustomDialogueForJoin> createState() =>
      _CustomDialogueForJoinState();
}

class _CustomDialogueForJoinState extends ConsumerState<CustomDialogueForJoin> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        //  backgroundColor: Colors.trans,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Joining Status",
                  style: GoogleFonts.varela(
                      fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.item.applicantName.toString(),
                      style: GoogleFonts.varela(
                          fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  Text(" Join today",
                      style: GoogleFonts.varela(fontSize: 16.sp)),
                  Image.asset(
                    "assets/images/question_mark.png",
                    height: 15.h,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: MediaQuery.of(context).size.height / 26,
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10.h, left: 6.w),
                          labelText: "Emp ID",
                          hintText: "E1000",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: Constants.themeBgColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: Constants.themeBgColor))),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0.5, 2),
                                blurRadius: 2,
                                spreadRadius: 2,
                                color: Colors.grey.shade200)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          // border: Border.all(color: Constants.themeBgColor)
                        ),
                        // margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 16.w),
                        child: const Text("Cancel")
                        /*  Image.asset(  //TODO: old code which were use image instead if text
                          "assets/images/thumbs_down.png",
                          height: 20.h,
                          color: Constants.themeBgColor,
                        ) */
                        ),
                  ),
                  InkWell(
                    onTap: () async {
                      ChangeStatusModel changeStatusModel = ChangeStatusModel(
                          status: "IB7",
                          subStatus: "Join",
                          doj: widget.item.doj,
                          id: widget.item.id,
                          sourceId: widget.item.sourceId,
                          empId: textEditingController.text.isNotEmpty
                              ? int.tryParse(textEditingController.text)
                              : null);
                      Map<String, dynamic> jsonData =
                          changeStatusModel.toJson();
                      try {
                        await JobPostApiService.changeStatus(
                            jsonData, widget.item.id!.toInt());
                        setState(() {});
                   
                         ref.refresh(fetchAllReferalProvider);
                        ref.refresh(fetchAllApplyProvider);
                       
                       
                        Navigator.pop(context);
                        // First pop to close the dialog
                      } catch (e) {
                        print('Error: $e');
                        // Handle error...
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0.5, 2),
                                blurRadius: 2,
                                spreadRadius: 2,
                                color: Colors.grey.shade200)
                          ],
                          color: Colors.white,
                          //  color: Colors.green,
                          borderRadius: BorderRadius.circular(8.r),
                          // border: Border.all(color: Colors.green)
                        ),
                        // margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 16.w),
                        child: const Text("Submit")
                        /* Image.asset(//TODO: old code which were use image instead if text
                          "assets/images/thumbs_up.png",
                          height: 20.h,
                          color: Colors.green,
                        ) */
                        ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
