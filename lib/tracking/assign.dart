// ignore_for_file: unused_result, library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/custom_dialogue_select.dart';
import 'package:job_circle/constants/custom_dialogue_update_crpf_in_new.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class AssignData extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> dropDownItemList;

  const AssignData(
      {super.key, required this.item, required this.dropDownItemList});

  @override
  _AssignDataState createState() => _AssignDataState();
}

class _AssignDataState extends ConsumerState<AssignData> {
  TextEditingController remark = TextEditingController();
  bool showDialogue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        radius: 22,
                      )
                    : CircleAvatar(
                        backgroundColor: Constants.bgColorWhite,
                        backgroundImage: AssetImage(widget.item.gender == "Male"
                            ? "assets/images/leadmale.png"
                            : "assets/images/leadfemal.png"),
                        radius: 22,
                      ),
              if (widget.item.gender == null)
                widget.item.profilePic != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                        radius: 22,
                      )
                    : CircleAvatar(
                        backgroundColor: Constants.borderColor,
                        radius: 22,
                        child: Text(
                          widget.item.applicantName!.isNotEmpty
                              ? widget.item.applicantName![0].toUpperCase()
                              : 'N',
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${widget.item.applicantName.toString().toTitleCase()} ${widget.item.last_name.toString().toTitleCase()}",
                        style: GoogleFonts.varela(
                          fontStyle: FontStyle.normal,
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
                      widget.item.qualification == null
                          ? Row(
                              children: [
                                Image.asset(
                                  "assets/images/bag.png",
                                  height: 12.h,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  widget.item.isExperienced.toString(),
                                  style: GoogleFonts.varela(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Image.asset(
                                  "assets/images/education_d.png",
                                  height: 15.h,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "${widget.item.qualification.toString()}  |  ",
                                  style: GoogleFonts.varela(
                                    color: Colors.black54,
                                  ),
                                ),
                                Image.asset(
                                  "assets/images/bag.png",
                                  height: 12.h,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  " ${widget.item.isExperienced}",
                                  style: GoogleFonts.varela(
                                    color: Colors.black54,
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
          Container(
            margin: EdgeInsets.only(top: 4.h),
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
                color: Constants.borderColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.short_name != null
                          ? widget.item.short_name.toString()
                          : widget.item.companyName.toString(),
                      style: GoogleFonts.varela(
                        color: Colors.black54,
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!note)
                      widget.item.notes != null && widget.item.notes != ""
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  note = true;
                                });
                                noteFocusNote.requestFocus();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.post_add_outlined,
                                      size: 20.h,
                                      color: Colors.grey,
                                    )
                                    /* Icon(
                                      Icons.add,
                                      size: 15.h,
                                    ),
                                    Text("Add Note",
                                        style: GoogleFonts.varela(
                                            fontSize: 12.sp,
                                            color: Colors.black)), */
                                  ],
                                ),
                              ),
                            )
                  ],
                ),
              ),
              PopupMenuButton<String>(
                // position: PopupMenuPosition.over,
                onSelected: (value) async {
                  int checkRemark = 0;
                  String? dialoguehint;
                  for (var app in widget.dropDownItemList) {
                    if (app.statusDd.toString() == value &&
                        app.statusDdId != null) {
                      if (app.status_dd_remark == 1) {
                        setState(() {
                          checkRemark = 1;
                          dialoguehint = app.statusDd.toString();
                        });
                      }
                      break;
                    }
                  }

                  // widget.item.status_remark == 1
                  checkRemark == 1
                      ? showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialogueForRemark(
                                hint: dialoguehint!,
                                callBack: (p0) {
                                  remark.text = p0;
                                },
                                item: widget.item,
                                controller: remark,
                                onTab: () {
                                  setState(() async {
                                    int subValue = 0;
                                    int getstatusId = 0;
                                    for (var app in widget.dropDownItemList) {
                                      if (app.statusDd.toString() == value &&
                                          app.statusDdId != null) {
                                        subValue = app.statusDdId!.toInt();
                                        getstatusId = app.statusId!.toInt();
                                        if (app.status_dd_remark == 1) {}
                                        break;
                                      }
                                    }

                                    // Now you can use both value and subValue for further operations
                                    NewChangeStatusModel changeStatusModel =
                                        NewChangeStatusModel(
                                            remark: remark.text,
                                            statusId: subValue == 6
                                                ? subValue
                                                : subValue == 5
                                                    ? subValue
                                                    : subValue == 7
                                                        ? subValue
                                                        : 0,
                                            hrStatusId: subValue == 6
                                                ? getstatusId
                                                : subValue == 5
                                                    ? getstatusId
                                                    : subValue == 7
                                                        ? getstatusId
                                                        : subValue,
                                            /* subValue ==
                                                    14 //TODO: intervewbay..
                                                ? subValue
                                                : subValue ==
                                                        5 //TODO for ringing
                                                    ? getstatusId
                                                    : subValue ==
                                                            6 //TODO: busy....
                                                        ? getstatusId
                                                        : 0, */
                                            interviewRounds: widget
                                                .item.inteviewrounds!.first
                                                .replaceAll('[', '')
                                                .replaceAll(']', '')
                                                .replaceAll('"', ''));
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
                                    /*   Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => Recruitz(
                                                    key: _talentPollKey,
                                                  )))); */
                                  });
                                });
                          },
                        )
                      : setState(() async {
                          int subValue = 0;
                          int getstatusId = 0;
                          for (var app in widget.dropDownItemList) {
                            if (app.statusDd.toString() == value &&
                                app.statusDdId != null) {
                              subValue = app.statusDdId!.toInt();
                              getstatusId = app.statusId!.toInt();
                              if (subValue == 14) {
                                showDialogue = true;
                              }
                              break;
                            }
                          }

                          // Now you can use both value and subValue for further operations
                          NewChangeStatusModel changeStatusModel =
                              NewChangeStatusModel(
                                  statusId: subValue == 14
                                      ? 1
                                      : subValue == 6
                                          ? subValue
                                          : subValue == 5
                                              ? subValue
                                              : subValue == 7
                                                  ? subValue
                                                  : 0,
                                  hrStatusId: subValue == 14
                                      ? subValue
                                      : subValue == 6
                                          ? getstatusId
                                          : subValue == 5
                                              ? getstatusId
                                              : subValue == 7
                                                  ? getstatusId
                                                  : subValue,
                                  interviewRounds: widget
                                      .item.inteviewrounds!.first
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .replaceAll('"', ''));
                          Map<String, dynamic> jsonData =
                              changeStatusModel.toJson();
                          try {
                            subValue == 14
                                ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialogueForNew(
                                        title: 'Register ',
                                        title2: "for an Interview.",
                                        company_name:
                                            widget.item.companyName.toString(),
                                        nature_of_work:
                                            widget.item.natureOfWork.toString(),
                                        process: widget.item.process.toString(),
                                        role: widget.item.lead_level.toString(),
                                        companyId:
                                            widget.item.short_list_for!.toInt(),
                                        item: widget.item,
                                        refreshCallback: () {
                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                        },
                                        statusDdId: subValue,
                                      );
                                    },
                                  )
                                : await JobPostApiService.NewchangeStatus(
                                    jsonData, widget.item.id!.toInt());
                            ref.refresh(fetchAllApplicantProvider);
                            ref.refresh(fetchAllReferalProvider);
                            ref.refresh(fetchAllApplyProvider);
                          } catch (e) {
                            print('Error: $e');
                          }
                        });
                },
                itemBuilder: (BuildContext context) {
                  return widget.dropDownItemList
                      .where((element) =>
                          element.statusId == widget.item.hr_status_id)
                      .map((option) {
                    return customMenuItem(option, true);
                  }).toList();
                },
                offset: const Offset(0, 32),
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 2.h),
                  //height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constants.blue)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        widget.item.hr_sub_status != null
                            ? widget.item.hr_sub_status.toString()
                            : "Select",
                        style: GoogleFonts.varela(
                          color: Constants.blue,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 13,
                        color: Colors.black,
                      )
                    ],
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
                            borderSide: BorderSide(color: Colors.grey.shade400),
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
                              color: Constants.hintColor, fontSize: 12.sp)),
                    ))
                : widget.item.notes != null && widget.item.notes != ""
                    ? SizedBox(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                                "Note : ${widget.item.notes.toString()}",
                                style: GoogleFonts.varela(fontSize: 12.sp)),
                          ),
                          if (!note)
                            widget.item.notes != null && widget.item.notes != ""
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        note = true;
                                        notes.text =
                                            widget.item.notes.toString();
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
                                          /* Icon(
                                            Icons.edit_outlined,
                                            size: 18.h,
                                          ), */
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                        ],
                      ))
                    : const SizedBox(),
          ),
          note
              ? SizedBox(
                  height: 8.h,
                )
              : const SizedBox(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (note)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        note = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Cancel",
                          style: GoogleFonts.varela(
                            color: Colors.red,
                            fontSize: 12.sp,
                          )),
                    ),
                  ),
                if (note)
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Submit",
                          style: GoogleFonts.varela(
                            color: Constants.blue,
                            fontSize: 12.sp,
                          )),
                    ),
                  ),
                /*  : widget.item.notes != null && widget.item.notes != ""
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                note = true;
                                notes.text = widget.item.notes.toString();
                              });
                              noteFocusNote.requestFocus();
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Edit Note",
                                  style: GoogleFonts.varela(
                                    color: Constants.blue,
                                    fontSize: 12.sp,
                                  )),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                note = true;
                              });
                              noteFocusNote.requestFocus();
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Add Note",
                                  style: GoogleFonts.varela(
                                      fontSize: 12.sp, color: Constants.blue)),
                            ),
                          ) */
              ],
            ),
          )
        ],
      ),
    );
  }

  FocusNode noteFocusNote = FocusNode();

  TextEditingController notes = TextEditingController();

  bool note = false;

  PopupMenuItem<String> customMenuItem(DropDownItem option, bool isOdd) {
    return PopupMenuItem<String>(
      value: option
          .statusDd, // Replace 'someValue' with the actual property you want to use as the value
      child: Text(
        option.statusDd
            .toString(), // Replace 'applicantName' with the actual property you want to use as the label
        style: const TextStyle(
            color: Colors.black // Example: custom styling based on isOdd
            ),
      ),
    );
  }
}
