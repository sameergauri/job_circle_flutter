import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/screens/jobs/pdf.dart';

import '../../models/my_team_model.dart';
import '../../themes/colors.dart';

class MyTeamDetail extends ConsumerStatefulWidget {
  final Applicant leadModel;
  const MyTeamDetail({
    Key? key,
    required this.leadModel,
  }) : super(key: key);

  @override
  ConsumerState<MyTeamDetail> createState() => _MyTeamDetailState();
}

class _MyTeamDetailState extends ConsumerState<MyTeamDetail> {
  bool descTextShowFlag = false;
  final Color appBgColor = Constants.themeBgColor;
  final Color appBgScrolledColor = Constants.bgPanelColor;
  late Color currentAppBarColor = appBgColor;
  late double appBarElevate = 0;
  late Color appBarIconColor = Colors.white;
  var usertype = 0;

  var titleText = "";
  var subtitleText = "";
  int? lId;

  NumberFormat format = NumberFormat.compact();
  List lea = [];

  String extractText(String input) {
    RegExp regex = RegExp(r'[a-zA-Z\s]+');
    Iterable<Match> matches = regex.allMatches(input);
    List<String?> textList = matches.map((match) => match.group(0)).toList();
    String text = textList.join('');
    return text.trim();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Lead Details",
            style: GoogleFonts.varela(fontSize: 16.h),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Constants.bgPanelColor,
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(
              left: 20, right: 20, top: kToolbarHeight * 1.7),
          child: widget.leadModel.id == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: const [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://media.istockphoto.com/id/503040171/photo/middle-eastern-businessman-portrait.jpg?s=612x612&w=0&k=20&c=7t6c_HQHfUZNgrVtR-G1rQpJAMaCbFsuxppDRKBnXDw="),
                              // child: Text(item.applicantName[0].toUpperCase()),
                              radius: 30,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${widget.leadModel.applicantName.toString()} ${widget.leadModel.last_name.toString()}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.varela(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.h,
                                  ),
                                ),
                                if (widget.leadModel.resume != "")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PDFViewerScreen(
                                                pdfAssetPath: widget
                                                    .leadModel.resume
                                                    .toString(),
                                                phoneNumber1: widget
                                                    .leadModel.contactNo!
                                                    .toInt(),
                                                phoneNumber2: widget.leadModel
                                                            .alternateNo !=
                                                        null
                                                    ? widget
                                                        .leadModel.alternateNo!
                                                        .toInt()
                                                    : 0,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.asset(
                                          "assets/images/cv.png",
                                          height: 15.h,
                                        )),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/128/8093/8093468.png",
                                  height: 12.5.h,
                                  color: Colors.grey.shade700,
                                ),
                                SizedBox(
                                  width: 7.w,
                                ),
                                Text(
                                  widget.leadModel.qualification.toString(),
                                  style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                // Text(
                                //   "|",
                                //   style: GoogleFonts.varela(
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      "https://cdn-icons-png.flaticon.com/128/2910/2910791.png",
                                      height: 12.5.h,
                                      color: Colors.grey.shade700,
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    Text(
                                      widget.leadModel.isExperienced.toString(),
                                      style: GoogleFonts.varela(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/cmpny.png",
                              height: 13.h,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              // widget.leadModel!.name
                              widget.leadModel.short_name.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.h,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/128/11519/11519032.png",
                              height: 12.h,
                              //color: Colors.black45,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.leadModel.process.toString(),
                              style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            // Text(
                            //   "|",
                            //   style: GoogleFonts.varela(
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            const SizedBox(
                              width: 8,
                            ),
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/128/5837/5837489.png",
                              height: 12.h,
                              //color: Colors.black45,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              widget.leadModel.natureOfWork.toString(),
                              style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/128/4727/4727553.png",
                              height: 12.h,
                              //color: Colors.black45,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.leadModel.status.toString(),
                              style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            // Text(
                            //   "|",
                            //   style: GoogleFonts.varela(
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/128/9759/9759052.png",
                              height: 12.h,
                              //color: Colors.black45,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              widget.leadModel.sub_status.toString(),
                              style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        if (widget.leadModel.interview_rounds != null)
                          Row(
                            children: [
                              Text(
                                "Interview Rounds",
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h),
                              ),
                            ],
                          ),
                        if (widget.leadModel.interview_rounds != null)
                          /* Wrap(
                            children: [
                              ...widget.leadModel.interview_rounds!
                                  .take(5)
                                  .map((item) => customSkill(item, true))
                                  .toList(),
                            ],
                          ), */
                          const SizedBox(
                            height: 6,
                          ),
                        if (widget.leadModel.document_status != null)
                          Row(
                            children: [
                              Text(
                                "Doc Status : ",
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h),
                              ),
                              Text(
                                widget.leadModel.document_status.toString(),
                                style: GoogleFonts.varela(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.leadModel.doj != null)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "DOJ ",
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.h),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5, right: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 3),
                                          decoration: BoxDecoration(
                                              color:
                                                  Constants.themeBgColorLight,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Constants.subtitleclr,
                                                  width: 0.5)),
                                          child: Text(
                                            widget.leadModel.doj.toString(),
                                            style: GoogleFonts.varela(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            if (widget.leadModel.dol != null)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "DOL ",
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.h),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5, right: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 3),
                                          decoration: BoxDecoration(
                                              color:
                                                  Constants.themeBgColorLight,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Constants.subtitleclr,
                                                  width: 0.5)),
                                          child: Text(
                                            widget.leadModel.doj.toString(),
                                            style: GoogleFonts.varela(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              )
                          ],
                        ),
                        if (widget.leadModel.emp_id != null)
                          const SizedBox(
                            height: 6,
                          ),
                        Row(
                          children: [
                            if (widget.leadModel.emp_id != null)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "EMP ID : ",
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.h),
                                      ),
                                      Text(
                                        widget.leadModel.emp_id.toString(),
                                        style: GoogleFonts.varela(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            if (widget.leadModel.emp_id != null)
                              const SizedBox(
                                width: 8,
                              ),
                            if (widget.leadModel.resume != null)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Client Resume Id : ",
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.h),
                                      ),
                                      Text(
                                        widget.leadModel.resume.toString(),
                                        style: GoogleFonts.varela(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (widget.leadModel.resume != null)
                          const SizedBox(
                            height: 6,
                          ),
                        if (widget.leadModel.skills != null ||
                            widget.leadModel.remark != null ||
                            widget.leadModel.remark != null)
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: const Offset(0, 0),
                                      blurRadius: 2)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(
                                left: 10, right: 5, top: 10, bottom: 10),
                            margin: const EdgeInsets.only(
                                top: 10, left: 1, right: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.leadModel.skills != null &&
                                    widget.leadModel.skills!.isNotEmpty)
                                  Container(
                                    margin: EdgeInsets.only(top: 5.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Skill's",
                                          style: GoogleFonts.varela(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.h),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Wrap(
                                          children: [
                                            ...widget.leadModel.skills!
                                                .map((item) =>
                                                    customSkill(item, true))
                                                .toList(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                if (widget.leadModel.remark != null)
                                  Container(
                                    margin: EdgeInsets.only(top: 5.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Remark ",
                                          style: GoogleFonts.varela(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.h),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 6,
                                                      child: Text("•"),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        widget.leadModel
                                                                .remark ??
                                                            '', // Display the remark string
                                                        style:
                                                            GoogleFonts.varela(
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontSize: 13.sp,
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
                                    ),
                                  ),
                                if (widget.leadModel.remark != null)
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                if (widget.leadModel.remark != null)
                                  Text(
                                    "Feedback",
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.h),
                                  ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.leadModel.remark != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 6,
                                                child: Text("•"),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  widget.leadModel.remark
                                                      .toString(),
                                                  style: GoogleFonts.varela(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset: const Offset(0, 0),
                                    blurRadius: 2)
                              ],
                              color: Constants.themeBgColorLight,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(
                              left: 10, right: 5, top: 10, bottom: 10),
                          margin:
                              const EdgeInsets.only(top: 10, left: 1, right: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Recruitment Details",
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.sp),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Spoc : ",
                                          style: GoogleFonts.varela(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.h),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          widget.leadModel.spoc_name.toString(),
                                          style: GoogleFonts.varela(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (widget.leadModel.source_name != null &&
                                        widget
                                            .leadModel.source_name!.isNotEmpty)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Source : ",
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.h),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(
                                            widget.leadModel.source_name
                                                .toString(),
                                            style: GoogleFonts.varela(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (widget.leadModel.referral_name !=
                                            null &&
                                        widget.leadModel.referral_name!
                                            .isNotEmpty)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Referral : ",
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.h),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(
                                            widget.leadModel.referral_name
                                                .toString(),
                                            style: GoogleFonts.varela(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    /*  if (widget.leadModel.subSource != null &&
                                        widget.leadModel.subSource!.isNotEmpty) */
                                    /*  Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Sub Source : ",
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.h),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(
                                            widget.leadModel.subSource
                                                .toString(),
                                            style: GoogleFonts.varela(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ), */
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        )));
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  Widget customSkill(String title, bool isHash) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color: Constants.themeBgColorLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Constants.subtitleclr, width: 0.5)),
      child: isHash
          ? Text(
              "#$title",
              style: GoogleFonts.varela(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            )
          : Text(
              title,
              style: GoogleFonts.varela(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
    );
  }

  Column keyPair(String imageName, String key, String value, bool devider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon(
            //   icon,
            //   size: 17,
            // ),
            const SizedBox(
              width: 3,
            ),
            Text(
              key,
              style:
                  GoogleFonts.varela(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            value,
            style: GoogleFonts.varela(
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (devider)
          const Divider(
            height: 1,
          )
      ],
    );
  }
}
