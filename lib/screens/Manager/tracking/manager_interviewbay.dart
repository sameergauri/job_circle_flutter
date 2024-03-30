// ignore_for_file: unused_result, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, use_full_hex_values_for_flutter_colors, deprecated_member_use
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
import 'package:timelines/timelines.dart';

class ManagerInterViewBayStatus extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> dropDownItemList;
  final List<DropDownItem> finalDropDownItem;
  final List<String>? finalinterviewRounds;
  final int selectedRoundIndex;
  const ManagerInterViewBayStatus(
      {super.key,
      required this.item,
      required this.dropDownItemList,
      required this.finalDropDownItem,
      required this.finalinterviewRounds,
      required this.selectedRoundIndex});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerInterViewBayStatusState();
}

class _ManagerInterViewBayStatusState
    extends ConsumerState<ManagerInterViewBayStatus> {
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
                                " ${widget.item.role_code != null && widget.item.role_code != "" ? widget.item.role_code : widget.item.lead_level}",
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

              //TODO:: Drop out and on hold interview rounds....
              if (widget.item.hr_sub_status == "Drop-out" ||
                  widget.item.hr_sub_status == "On-Hold")
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Constants.borderColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Constants.borderColor)),
                  //  padding: const EdgeInsets.only(bottom: 5),
                  height: MediaQuery.of(context).size.height / 15,
                  child: Timeline.tileBuilder(
                    //  scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 10),

                    shrinkWrap: true,
                    // padding: const EdgeInsets.only(top: 0),
                    theme: TimelineThemeData(
                      direction: Axis.horizontal,
                      connectorTheme: const ConnectorThemeData(
                        space: 8.0,
                        thickness: 2.0,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      contentsAlign: ContentsAlign.basic,
                      connectionDirection: ConnectionDirection.before,
                      itemCount: widget.finalinterviewRounds != null
                          ? widget.finalinterviewRounds!.length
                          : 0,
                      itemExtentBuilder: (_, __) {
                        return (MediaQuery.of(context).size.width - 50) /
                            widget.finalinterviewRounds!.length.toDouble();
                      },
                      oppositeContentsBuilder: (context, index) {
                        return Container();
                      },
                      contentsBuilder: (context, index) {
                        return widget.finalinterviewRounds != null
                            ? Text(widget.finalinterviewRounds![index])
                            : const Text("");
                      },
                      indicatorBuilder: (_, index) {
                        if (index == widget.selectedRoundIndex) {
                          // Customize the selected round indicator
                          return const OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: Colors.red,
                          );
                        } else if (index > widget.selectedRoundIndex) {
                          // Customize indicators for other rounds
                          return OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: Colors.grey.shade400,
                          );
                        } else {
                          return CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 8.r,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 13.h,
                            ),
                          ); /* const DotIndicator(
                                                              //   borderWidth: 4.0,
                                                              color: Colors.green,
                                                            ); */
                        }
                      },
                      connectorBuilder: (_, index, type) {
                        if (index == widget.selectedRoundIndex) {
                          // Customize the selected round connector
                          return const DashedLineConnector(
                            color: Colors.green,
                          );
                        } else if (index > widget.selectedRoundIndex) {
                          // Customize connectors for other rounds
                          return DashedLineConnector(
                            color: Colors.grey.shade400,
                          );
                        } else {
                          return const DashedLineConnector(
                            color: Colors.green,
                          );
                        }
                      },
                    ),
                  ),
                ),

              //
              //
              //
              //
              //
              //
              //TODO:: Interview Rounds....
              if (widget.item.hr_sub_status != "Drop-out" &&
                  widget.item.hr_sub_status != "On-Hold")
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: List.generate(widget.finalinterviewRounds!.length,
                      (index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: widget.item.interview_rounds ==
                                        widget.finalinterviewRounds![index]
                                    ? Colors.grey
                                        .shade200 // Set color when the condition is true
                                    : index <
                                            widget.finalinterviewRounds!
                                                .indexOf(widget
                                                    .item.interview_rounds
                                                    .toString())
                                        ? Colors.grey
                                            .shade200 // Set color for items before the matching item
                                        : Colors.grey.shade300,
                              ),
                              color: widget.item.interview_rounds ==
                                      widget.finalinterviewRounds![index]
                                  ? Colors.grey
                                      .shade200 // Set color when the condition is true
                                  : index <
                                          widget.finalinterviewRounds!.indexOf(
                                              widget.item.interview_rounds
                                                  .toString())
                                      ? Colors.grey
                                          .shade200 // Set color for items before the matching item
                                      : Colors.white,

                              /*  index == 0 ||
                                    widget.item.interview_rounds ==
                                        widget.finalInterviewRounds[index]
                                ? Constants.borderColor
                                : Colors.white, */
                              borderRadius: BorderRadius.circular(8.r)),
                          child: Text(widget.finalinterviewRounds![index],
                              style: GoogleFonts.varela(
                                color: widget.item.interview_rounds ==
                                        widget.finalinterviewRounds![index]
                                    ? Colors.grey
                                        .shade500 // Set color when the condition is true
                                    : index <
                                            widget.finalinterviewRounds!
                                                .indexOf(widget
                                                    .item.interview_rounds
                                                    .toString())
                                        ? Colors.grey
                                            .shade500 // Set color for items before the matching item
                                        : Colors.black,
                              ))),
                    );
                  }),
                ),

//
//
//
              if (widget.item.hr_sub_status == "Drop-out" ||
                  widget.item.hr_sub_status == "On-Hold")
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                    // border: Border.all(color: Colors.grey.shade400)
                  ),
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.only(
                      left: 4.w, right: 4.w, top: 6.h, bottom: 6.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.remark ?? "",
                          style: GoogleFonts.varela(
                            fontStyle: FontStyle.italic,
                            // color: Constants.subtitleclr,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                            widget.item.spoc_name ?? "No Source",
                            style: GoogleFonts.varela(
                                color: Constants.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ],
              ),
              //
              //
              //
              //
              if (widget.item.hr_sub_status != "Drop-out" &&
                  widget.item.hr_sub_status != "On-Hold")
                if (widget.item.notes != null && widget.item.notes != "")
                  const Divider(),
              if (widget.item.notes != null &&
                  widget.item.notes != "" &&
                  (widget.item.hr_sub_status != "Drop-out" &&
                      widget.item.hr_sub_status != "On-Hold"))
                Row(
                  children: [
                    Expanded(
                      child: Text("Note : ${widget.item.notes.toString()}",
                          style: GoogleFonts.varela(fontSize: 12.sp)),
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
