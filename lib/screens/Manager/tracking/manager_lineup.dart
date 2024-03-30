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

class ManagerLineUp extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> dropDownItemList;
  final bool mylineup;

  const ManagerLineUp(
      {super.key,
      required this.item,
      required this.dropDownItemList,
      required this.mylineup});

  @override
  _ManagerLineUpState createState() => _ManagerLineUpState();
}

class _ManagerLineUpState extends ConsumerState<ManagerLineUp> {
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
              if (widget.item.notes != null && widget.item.notes != "")
                const Divider(),
              if (widget.item.notes != null && widget.item.notes != "")
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
