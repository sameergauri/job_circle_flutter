// ignore_for_file: unused_local_variable, avoid_unnecessary_containers
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:timelines/timelines.dart';

class NegativeStatus extends StatefulWidget {
  final Applicant item;
  final List<String>? finalinterviewRounds;
  final int selectedRoundIndex;
  const NegativeStatus(
      {super.key,
      required this.item,
      required this.finalinterviewRounds,
      required this.selectedRoundIndex});

  @override
  State<NegativeStatus> createState() => _NegativeStatusState();
}

class _NegativeStatusState extends State<NegativeStatus> {
  int calculateAge(String dateOfBirth) {
    DateTime now = DateTime.now();
    DateTime dob = DateTime.parse(dateOfBirth);

    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.bgColorWhite,
                            backgroundImage: AssetImage(
                                widget.item.gender == "Male"
                                    ? "assets/images/leadmale.png"
                                    : "assets/images/leadfemal.png"),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          ),
                  if (widget.item.gender == null)
                    widget.item.profilePic != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.borderColor,
                            // child: Text(item.applicantName[0].toUpperCase()),
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
              Row(
                children: [
                  SizedBox(
                    width: width / 2.5,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/cmpny.png",
                          height: 12.h,
                          //  color: Constants.subtitleclr,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          "${widget.item.short_name.toString()}  |  ",
                          style: GoogleFonts.varela(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width / 2.5,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/loc.png",
                          height: 12.h,
                          //  color: Constants.subtitleclr,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: Text(
                            " ${widget.item.workLocation}",
                            style: GoogleFonts.varela(
                              color: Colors.black54,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              //
              //
              //
              //
              if (widget.item.hr_status_id ==
                  16) //TODO:: interview rounds for reject
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
              if (widget.item.remark != null && widget.item.remark != "")
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
            ],
          ),
        )
      ],
    );
  }
}
