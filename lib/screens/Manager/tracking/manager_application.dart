// ignore_for_file: unnecessary_null_comparison, unused_result, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print, avoid_unnecessary_containers, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/themes/colors.dart';

class ManagerApplication extends ConsumerStatefulWidget {
  final Applicant item;
  final int id;
  final List<DropDownItem> dropDownItemList;
  final String sourcename;
  final int report_to;

  ManagerApplication(
      {required this.item,
      required this.dropDownItemList,
      required this.id,
      required this.sourcename,
      required this.report_to});

  @override
  _ManagerApplicationState createState() => _ManagerApplicationState();
}

class _ManagerApplicationState extends ConsumerState<ManagerApplication> {
  var userType;
  var userrole;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
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
            ],
          ),
        ),
      ],
    );
  }
}
