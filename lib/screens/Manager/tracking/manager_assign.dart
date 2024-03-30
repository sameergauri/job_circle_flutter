// ignore_for_file: unused_result, library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print, use_full_hex_values_for_flutter_colors, deprecated_member_use
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/themes/colors.dart';

class ManagerAssign extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> dropDownItemList;
  final bool myLineUp;

  const ManagerAssign(
      {super.key,
      required this.item,
      required this.dropDownItemList,
      required this.myLineUp});

  @override
  _ManagerAssignState createState() => _ManagerAssignState();
}

class _ManagerAssignState extends ConsumerState<ManagerAssign> {
  @override
  void dispose() {
    // Clear the controller when the state is disposed

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
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      decoration: BoxDecoration(

                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Text(
                            widget.item.source_name ?? "No Source",
                            style: GoogleFonts.varela(
                                color: Constants.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      decoration: BoxDecoration(

                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Text(
                            "${widget.item.hr_sub_status ?? widget.item.s2HrSubStatus}",
                            style: GoogleFonts.varela(
                                color: Constants.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ],
              ),
              if (widget.item.notes != null && widget.item.notes != "")
                Row(
                  children: [
                    Text("Note : ${widget.item.notes.toString()}",
                        style: GoogleFonts.varela(fontSize: 12.sp)),
                  ],
                ),
            ],
          ),
        ),
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
