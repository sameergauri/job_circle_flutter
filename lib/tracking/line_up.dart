// ignore_for_file: unused_result, library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print, use_full_hex_values_for_flutter_colors, deprecated_member_use
// ignore_for_file: todo
import 'dart:ui';

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
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/talent_pool.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class LineUp extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> dropDownItemList;
  final bool mylineup;

  const LineUp(
      {super.key,
      required this.item,
      required this.dropDownItemList,
      required this.mylineup});

  @override
  _LineUpState createState() => _LineUpState();
}

class _LineUpState extends ConsumerState<LineUp> {
  @override
  void dispose() {
    // Clear the controller when the state is disposed
    isLoading = false;
    super.dispose();
  }

  TextEditingController remark = TextEditingController();
  bool showDialogue = false;
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
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.bgColorWhite,
                            backgroundImage: AssetImage(
                                widget.item.gender == "Male"
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
                            " ${widget.item.role_code != null && widget.item.role_code != "" ? widget.item.role_code : widget.item.lead_level}",
                            style: GoogleFonts.varela(
                              color: Colors.black54,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.mylineup)
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
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
                  if (widget.mylineup)
                    Wrap(
                      children: List.generate(widget.dropDownItemList.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            widget.dropDownItemList[index].pri_status_remark ==
                                    1 //TODO:: if true revok else interviewBay
                                ? showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return WillPopScope(
                                        onWillPop: () async {
                                          return Future.value(false);
                                        },
                                        child: CustomDialogueForRemark(
                                            onCancel: () {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            hint: widget.dropDownItemList[index]
                                                .statusDd
                                                .toString(),
                                            callBack: (p0) {
                                              remark.text = p0;
                                            },
                                            item: widget.item,
                                            controller: remark,
                                            onTab: () {
                                              setState(() async {
                                                NewChangeStatusModel
                                                    changeStatusModel =
                                                    NewChangeStatusModel(
                                                        remark: remark.text,
                                                        statusId: 0,
                                                        hrStatusId: widget
                                                            .dropDownItemList[
                                                                index]
                                                            .priStatusId,
                                                        interviewRounds: widget
                                                            .item
                                                            .inteviewrounds!
                                                            .first
                                                            .replaceAll('[', '')
                                                            .replaceAll(']', '')
                                                            .replaceAll(
                                                                '"', ''));
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
                                                      fetchAllTalentPoolProvider);
                                                  ref.refresh(
                                                      fetchAllExecutiveProvide);
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 5), () {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  print('Error: $e');
                                                  // Handle error...
                                                }
                                              });
                                            }),
                                      );
                                    },
                                  )
                                : showDialog(
                                    context: context,
                                    builder: (context) {
                                      isLoading = true;

                                      return CustomDialogueForNew(
                                        cancel: () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
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
                                          ref.refresh(
                                              fetchAllTalentPoolProvider);
                                          ref.refresh(fetchAllExecutiveProvide);

                                          isLoading = false;
                                        },
                                        statusDdId: widget
                                            .dropDownItemList[index]
                                            .priStatusId!
                                            .toInt(),
                                      );
                                    },
                                  );
                          },
                          child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: widget.dropDownItemList[index]
                                                  .priStatusId ==
                                              17
                                          ? Colors.red
                                          : Constants.blue),
                                  // color: Colors.red,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Text(
                                widget.dropDownItemList[index].primaryStatus
                                    .toString(),
                                style: GoogleFonts.varela(
                                    color: widget.dropDownItemList[index]
                                                .priStatusId ==
                                            17
                                        ? Colors.red
                                        : Constants.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                        );
                      }),
                    ),
                ],
              ),
              /*  if (!widget.mylineup)  //TODO:: source name as per source
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 8.w),
                        decoration: BoxDecoration(

                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/source.png",
                              height: 15.sp,
                            ),
                            SizedBox(
                              width: 4.sp,
                            ),
                            Text(
                              "${widget.item.source_name}",
                              style: GoogleFonts.varela(
                                  color: Constants.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ), */
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
                              if (!note && widget.mylineup)
                                widget.item.notes != null &&
                                        widget.item.notes != ""
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
                              ref.refresh(fetchAllTalentPoolProvider);
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
