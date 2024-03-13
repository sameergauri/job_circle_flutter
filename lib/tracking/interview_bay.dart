// ignore_for_file: unused_result, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, use_full_hex_values_for_flutter_colors, deprecated_member_use
// ignore_for_file: todo
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/custom_dialogue_select.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class InterViewBayStatus extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> dropDownItemList;
  final List<dynamic> finalInterviewRounds;
  final List<DropDownItem> finalDropDownItem;
  const InterViewBayStatus(
      {super.key,
      required this.item,
      required this.dropDownItemList,
      required this.finalDropDownItem,
      required this.finalInterviewRounds});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InterViewBayStatusState();
}

class _InterViewBayStatusState extends ConsumerState<InterViewBayStatus> {
  TextEditingController remark2 = TextEditingController();
  TextEditingController remark = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.item.gender != null)
                    widget.item.profilePic != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                            // child: Text(widget.item.applicantName[0].toUpperCase()),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.bgColorWhite,
                            backgroundImage: AssetImage(
                                widget.item.gender == "Male"
                                    ? "assets/images/leadmale.png"
                                    : "assets/images/leadfemal.png"),
                            // child: Text(widget.item.applicantName[0].toUpperCase()),
                            radius: 22,
                          ),
                  if (widget.item.gender == null)
                    widget.item.profilePic != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                            // child: Text(widget.item.applicantName[0].toUpperCase()),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.borderColor,
                            // child: Text(widget.item.applicantName[0].toUpperCase()),
                            radius: 22,
                            child: Text(
                              widget.item.applicantName!.isNotEmpty
                                  ? widget.item.applicantName![0].toUpperCase()
                                  : 'N', // Default to 'N' if the name is empty
                              style: const TextStyle(
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                  const SizedBox(
                    width: 6,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.item.applicantName.toString().toTitleCase()} ${widget.item.last_name.toString().toTitleCase()}",
                            style: GoogleFonts.varela(
                              fontStyle: FontStyle.normal,
                              // color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.item.dateOfBirth != null)
                            Text(
                              " (${calculateAge(widget.item.dateOfBirth.toString())} yr's)",
                              style: GoogleFonts.varela(
                                  color: Colors.black54, fontSize: 12.sp),
                            )
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/process.png",
                                height: 12.h,
                                //  color: Constants.subtitleclr,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${widget.item.process.toString()}  |  ",
                                style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.asset(
                                "assets/images/designation.png",
                                height: 12.h,
                                //  color: Constants.subtitleclr,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                " ${widget.item.role_code ?? widget.item.lead_level}",
                                style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              /*  Container(
                margin: EdgeInsets.only(top: 4.h),
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                    color: Constants.borderColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.short_name != null
                          ? widget.item.short_name.toString()
                          : widget.item.companyName.toString(),
                      style: GoogleFonts.varela(
                        color: Colors.black54,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.item.role_code != null &&
                                  widget.item.role_code != ""
                              ? "${widget.item.process} || ${widget.item.role_code}"
                              : "${widget.item.process} || ${widget.item.lead_level}",
                          style: GoogleFonts.varela(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ), */
              //TODO:: Interview Rounds....
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children:
                    List.generate(widget.finalInterviewRounds.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: index >
                              widget.finalInterviewRounds
                                  .indexOf(widget.item.interview_rounds)
                          ? () async {
                              setState(() {
                                isLoading = true;
                              });
                              NewChangeStatusModel changeStatusModel =
                                  NewChangeStatusModel(
                                      statusId: widget.item.status_id,
                                      interviewRounds:
                                          widget.finalInterviewRounds[index]);
                              Map<String, dynamic> jsonData =
                                  changeStatusModel.toJson();
                              try {
                                await JobPostApiService.NewchangeStatus(
                                    jsonData, widget.item.id!.toInt());
                                ref.refresh(fetchAllApplicantProvider);
                                ref.refresh(fetchAllReferalProvider);
                                ref.refresh(fetchAllApplyProvider);
                                ref.refresh(fetchAllExecutiveProvide);
                                Future.delayed(const Duration(seconds: 2), () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              } catch (e) {
                                print('Error: $e');
                                // Handle error...
                              }
                            }
                          : () {},
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: widget.item.interview_rounds ==
                                        widget.finalInterviewRounds[index]
                                    ? Colors.grey
                                        .shade200 // Set color when the condition is true
                                    : index <
                                            widget.finalInterviewRounds.indexOf(
                                                widget.item.interview_rounds)
                                        ? Colors.grey
                                            .shade200 // Set color for items before the matching item
                                        : Colors.grey.shade300,
                              ),
                              color: widget.item.interview_rounds ==
                                      widget.finalInterviewRounds[index]
                                  ? Colors.grey
                                      .shade200 // Set color when the condition is true
                                  : index <
                                          widget.finalInterviewRounds.indexOf(
                                              widget.item.interview_rounds)
                                      ? Colors.grey
                                          .shade200 // Set color for items before the matching item
                                      : Colors.white,

                              /*  index == 0 ||
                                      widget.item.interview_rounds ==
                                          widget.finalInterviewRounds[index]
                                  ? Constants.borderColor
                                  : Colors.white, */
                              borderRadius: BorderRadius.circular(8.r)),
                          child: Text(widget.finalInterviewRounds[index],
                              style: GoogleFonts.varela(
                                color: widget.item.interview_rounds ==
                                        widget.finalInterviewRounds[index]
                                    ? Colors.grey
                                        .shade500 // Set color when the condition is true
                                    : index <
                                            widget.finalInterviewRounds.indexOf(
                                                widget.item.interview_rounds)
                                        ? Colors.grey
                                            .shade500 // Set color for items before the matching item
                                        : Colors.black,
                              ))),
                    ),
                  );
                }),
              ),
              //TODO:: DropOut ...
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    children: List.generate(
                      widget.finalDropDownItem.length,
                      (index) => GestureDetector(
                        onTap: widget.finalDropDownItem[index]
                                    .sec_status_remark ==
                                1
                            ? () async {
                                setState(() {
                                  isLoading = true;
                                });
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return WillPopScope(
                                      onWillPop: () async {
                                        // Return false to prevent dialog from closing with back button
                                        return Future.value(false);
                                      },
                                      child: CustomDialogueForRemark(
                                        onCancel: () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        hint: widget
                                            .finalDropDownItem[index].secStatus
                                            .toString(),
                                        item: widget.item,
                                        onTab: () async {
                                          NewChangeStatusModel
                                              changeStatusModel =
                                              NewChangeStatusModel(
                                            // hrStatusId: 0, // TODO:: Previous one before new modification
                                            hrStatusId: widget
                                                .finalDropDownItem[index]
                                                .statusId,
                                            remark: remark.text,
                                            interviewRounds: widget
                                                .item.interview_rounds
                                                .toString(),
                                            /*  hrStatusId:
                                                          finalDropDownItem[index]
                                                              .statusId, */
                                            statusId: widget
                                                .finalDropDownItem[index]
                                                .secStatusId,
                                          );
                                          Map<String, dynamic> jsonData =
                                              changeStatusModel.toJson();
                                          try {
                                            await JobPostApiService
                                                .NewchangeStatus(jsonData,
                                                    widget.item.id!.toInt());
                                            ref.refresh(
                                                fetchAllApplicantProvider);
                                            ref.refresh(
                                                fetchAllReferalProvider);
                                            ref.refresh(fetchAllApplyProvider);
                                            ref.refresh(
                                                fetchAllExecutiveProvide);
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            });
                                            Navigator.pop(context);
                                          } catch (e) {
                                            print('Error: $e');
                                            // Handle error...
                                          }
                                        },
                                        controller: remark,
                                        callBack: (p0) {
                                          remark.text = p0;
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                NewChangeStatusModel changeStatusModel =
                                    NewChangeStatusModel(
                                  interviewRounds:
                                      widget.item.interview_rounds.toString(),
                                  /*  hrStatusId:
                                                        finalDropDownItem[index]
                                                            .statusId, */
                                  // hrStatusId: 0, //TODO:: Previous one before new modification
                                  hrStatusId:
                                      widget.finalDropDownItem[index].statusId,
                                  statusId: widget
                                      .finalDropDownItem[index].secStatusId,
                                );
                                Map<String, dynamic> jsonData =
                                    changeStatusModel.toJson();
                                try {
                                  await JobPostApiService.NewchangeStatus(
                                      jsonData, widget.item.id!.toInt());
                                  ref.refresh(fetchAllApplicantProvider);
                                  ref.refresh(fetchAllReferalProvider);
                                  ref.refresh(fetchAllApplyProvider);
                                  ref.refresh(fetchAllExecutiveProvide);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                } catch (e) {
                                  print('Error: $e');
                                  // Handle error...
                                }
                              },
                        child: Container(
                            margin: EdgeInsets.only(right: 4.w),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: widget.finalDropDownItem[index].statusId ==
                                        widget.item.dd_hr_status_id ||
                                    widget.finalDropDownItem[index].statusId ==
                                        widget.item.hr_status_id
                                ? Text(
                                    widget.finalDropDownItem[index].secStatus
                                        .toString(),
                                    style:
                                        GoogleFonts.varela(color: Colors.blue),
                                  )
                                : null),
                      ),
                    ),
                  ),

                  //TODO:: Select Reject
                  Wrap(
                    children: List.generate(
                      widget.finalDropDownItem.length,
                      (index) => GestureDetector(
                        onTap: widget.finalDropDownItem[index].priStatusId !=
                                13 //TODO : Select
                            ? widget.finalDropDownItem[index]
                                        .pri_status_remark ==
                                    1
                                ? () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return WillPopScope(
                                          onWillPop: () async {
                                            // Return false to prevent dialog from closing with back button
                                            return Future.value(false);
                                          },
                                          child: CustomDialogueForRemark(
                                            onCancel: () {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            hint: widget
                                                .finalDropDownItem[index]
                                                .primaryStatus
                                                .toString(),
                                            item: widget.item,
                                            onTab: () async {
                                              NewChangeStatusModel
                                                  changeStatusModel =
                                                  NewChangeStatusModel(
                                                      interviewRounds: widget
                                                          .item.interview_rounds
                                                          .toString(),
                                                      /*  hrStatusId:
                                                                finalDropDownItem[
                                                                        index]
                                                                    .statusId, */
                                                      hrStatusId: widget
                                                          .finalDropDownItem[
                                                              index]
                                                          .priStatusId, //TODO : hrstatus id = 0 if click on reject...
                                                      statusId:
                                                          0 /*  widget
                                                          .finalDropDownItem[index]
                                                          .priStatusId */ //TODO for local..
                                                      );
                                              Map<String, dynamic> jsonData =
                                                  changeStatusModel.toJson();
                                              try {
                                                await JobPostApiService
                                                    .NewchangeStatus(
                                                        jsonData,
                                                        widget.item.id!
                                                            .toInt());
                                                ref.refresh(
                                                    fetchAllApplicantProvider);
                                                ref.refresh(
                                                    fetchAllReferalProvider);
                                                ref.refresh(
                                                    fetchAllApplyProvider);
                                                ref.refresh(
                                                    fetchAllExecutiveProvide);
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                });
                                                Navigator.pop(context);
                                              } catch (e) {
                                                print('Error: $e');
                                                // Handle error...
                                              }
                                            },
                                            controller: remark2,
                                            callBack: (p0) {
                                              remark2.text = p0;
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    NewChangeStatusModel changeStatusModel =
                                        NewChangeStatusModel(
                                            hrStatusId: widget
                                                .finalDropDownItem[index]
                                                .priStatusId,
                                            interviewRounds: widget
                                                .item.interview_rounds
                                                .toString(),
                                            /*  hrStatusId:
                                                              finalDropDownItem[
                                                                      index]
                                                                  .statusId, */
                                            statusId:
                                                0 /*  widget
                                                .finalDropDownItem[index]
                                                .priStatusId */
                                            );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      await JobPostApiService.NewchangeStatus(
                                          jsonData, widget.item.id!.toInt());
                                      ref.refresh(fetchAllApplicantProvider);
                                      ref.refresh(fetchAllReferalProvider);
                                      ref.refresh(fetchAllApplyProvider);
                                      ref.refresh(fetchAllExecutiveProvide);
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    }
                                  }
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return WillPopScope(
                                      onWillPop: () async {
                                        // Return false to prevent dialog from closing with back button
                                        return Future.value(false);
                                      },
                                      child: CustomDialogueForSelect(
                                        onCancel: () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        item: widget.item,
                                        refreshCallback: () {
                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
                                          ref.refresh(fetchAllExecutiveProvide);
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                        },
                                        finalDropDown:
                                            widget.finalDropDownItem[index],
                                      ),
                                    );
                                  },
                                );
                                ref.refresh(fetchAllApplicantProvider);
                                ref.refresh(fetchAllReferalProvider);
                                ref.refresh(fetchAllApplyProvider);
                                ref.refresh(fetchAllExecutiveProvide);
                                /*    Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => CC(
                                                    key: _talentPollKey,
                                                  )))); */
                              },
                        child: Container(
                            margin: EdgeInsets.only(right: 4.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.h, horizontal: 8.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: widget.finalDropDownItem[index]
                                            .priStatusId ==
                                        13
                                    ? Border.all(color: Constants.blue)
                                    : Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.r)),
                            child: Text(
                              widget.finalDropDownItem[index].primaryStatus
                                  .toString(),
                              style: GoogleFonts.varela(
                                  color: widget.finalDropDownItem[index]
                                              .priStatusId ==
                                          13
                                      ? Constants.blue
                                      : Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  )
                ],
              ),

              if (widget.item.notes != null && widget.item.notes != "")
                const Divider(),
              Container(
                  child: note
                      ? Container(
                          margin: EdgeInsets.only(top: 8.h),
                          height: MediaQuery.of(context).size.height / 28,
                          child: TextField(
                            focusNode: noteFocusNote,
                            maxLines: 2,
                            controller: notes,
                            textCapitalization: TextCapitalization.sentences,
                            style: GoogleFonts.varela(
                                color: Constants.subtitleclr, fontSize: 14.sp),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                counterText: '',
                                labelText: "Note",
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                focusColor: const Color(0xffff0eceb),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                hintText: "Add Notes .... ",
                                hintStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.hintColor,
                                    fontSize: 12.sp)),
                          ))
                      : widget.item.notes != null && widget.item.notes != ""
                          ? SizedBox(
                              child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        "Note : ${widget.item.notes.toString()}",
                                        style: GoogleFonts.varela(
                                            fontSize: 12.sp))),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      note = true;
                                      notes.text = widget.item.notes.toString();
                                    });
                                    noteFocusNote.requestFocus();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/pencil.png",
                                          height: 18.h,
                                        )
                                        /*  Icon(
                                          Icons.edit_outlined,
                                          size: 18.h,
                                        ), */
                                        /*  Text("Edit Note",
                                            style: GoogleFonts.varela(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                            )), */
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ))
                          : const SizedBox()),
              note
                  ? SizedBox(
                      height: 8.h,
                    )
                  : const SizedBox(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    note
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    note = false;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text("Cancel",
                                      style: GoogleFonts.varela(
                                        color: Colors.red,
                                        fontSize: 12.sp,
                                      )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    note = false;
                                  });

                                  {
                                    NewChangeStatusModel changeStatusModel =
                                        NewChangeStatusModel(notes: notes.text);
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      await JobPostApiService.NewchangeStatus(
                                          jsonData, widget.item.id!.toInt());

                                      ref.refresh(fetchAllApplicantProvider);
                                      ref.refresh(fetchAllExecutiveProvide);
                                      // ref.refresh(fetchAllReferalProvider);
                                      // ref.refresh(fetchAllApplyProvider);
                                      notes.clear();
                                      //  Navigator.pop(context);
                                    } catch (e) {
                                      print('Error: $e');
                                      //
                                    }
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text("Submit",
                                      style: GoogleFonts.varela(
                                          color: Constants.blue)),
                                ),
                              ),
                            ],
                          )
                        : widget.item.notes != null && widget.item.notes != ""
                            ? const SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    note = true;
                                  });
                                  noteFocusNote.requestFocus();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 6.h),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.post_add_outlined,
                                        size: 20.h,
                                        color: Colors.grey,
                                      ),
                                      /* Text("Add Note",
                                          style: GoogleFonts.varela(
                                              fontSize: 12.sp,
                                              color: Colors.black)), */
                                    ],
                                  ),
                                ),
                              )
                  ],
                ),
              )
            ],
          ),
        ),
        isLoading
            ? BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5, sigmaY: 5), // Adjust blur intensity as needed
                child: const Center(
                  child: AbsorbPointer(
                    absorbing: true, // Prevent interaction with elements behind
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  FocusNode noteFocusNote = FocusNode();

  TextEditingController notes = TextEditingController();

  bool note = false;
}
