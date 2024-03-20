// ignore_for_file: unused_result

import 'dart:convert';

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/interviewbay_faq_model.dart';
import 'package:job_circle/screens/faq/interview_faq_form.dart';
import 'package:job_circle/themes/colors.dart';

final interviewFaqByjobProvider =
    FutureProvider.family<List<InterviewFaqGetModel>, int>((ref, crpfid) async {
  try {
    final interviewList = await _InterviewFaqPageState._loadData(crpfid);
    return interviewList;
  } catch (e) {
    throw Exception('Failed to fetch faq details'); // Throw an exception
  }
});

class InterviewFaqPage extends ConsumerStatefulWidget {
  final int crpfid;
  final int userid;
  final String userRole;

  const InterviewFaqPage(
      {super.key,
      required this.crpfid,
      required this.userid,
      required this.userRole});

  @override
  ConsumerState<InterviewFaqPage> createState() => _InterviewFaqPageState();
}

class _InterviewFaqPageState extends ConsumerState<InterviewFaqPage> {
  bool isLoading = false;

  static Future<List<InterviewFaqGetModel>> _loadData(int crpfid) async {
    final url = Uri.parse(
      'http://${GlobalConstants.API_Host_one}/interviewfaqs/getFaqByCrpfId?crpfid1=$crpfid&crpfid2=$crpfid&page=1&size=50',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['resultData']['content'];

        return List<InterviewFaqGetModel>.from(
            jsonData.map((item) => InterviewFaqGetModel.fromJson(item)));
      } else {
        throw Exception(
            'Failed to fetch interview FAQ details. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error occurred while fetching interview FAQ details: $e');
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(interviewFaqByjobProvider(widget.crpfid));
  }

  @override
  Widget build(BuildContext context) {
    var finalData = ref.watch(interviewFaqByjobProvider(widget.crpfid));

    return finalData.when(data: (data) {
      return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: widget.userRole != "1"
              ? DraggableFab(
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InterviewFaqForm(
                              process: data.first.process,
                              roleName: data.first.roleName,
                              now: data.first.natureOfWork,
                              icon: data.first.icon,
                              crpfid: data.first.crpfid,
                            ),
                          ));
                    },
                    backgroundColor: Constants.borderColor,
                    child: const Icon(
                      Icons.add,
                      color: Constants.blue,
                    ), // Change this to your desired color
                  ),
                )
              : const SizedBox(),
          body: data.first.question != null
              ? Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        displacement: 100.0,
                        color: Colors.blue,
                        onRefresh: () async {
                          await _onRefresh();
                        },
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final faq = data[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (faq.question != null)
                                    Text(
                                      'Q ${index + 1} : ${faq.question}',
                                      style: GoogleFonts.varela(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  if (faq.answer != null)
                                    Text(
                                      'Ans: ${faq.answer}',
                                      style: GoogleFonts.varela(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  //const SizedBox(height: 16),
                                  if (faq.firstName != null &&
                                      faq.userId != widget.userid)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Posted By: ',
                                          style: GoogleFonts.varela(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight
                                                .bold, // Making "Posted By" bold
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${faq.firstName} ${faq.lastName}',
                                          style: GoogleFonts.varela(
                                            fontSize: 14.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (faq.userId == widget.userid)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_outline_outlined,
                                            color: Colors.red,
                                            size: 20.sp,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return CustomDialogueToDeleteFAQ(
                                                  onSubmit: () {
                                                    String apiUrl =
                                                        'http://${GlobalConstants.API_Host}/interviewfaqs/${faq.id}';

                                                    http
                                                        .delete(
                                                            Uri.parse(apiUrl))
                                                        .then((response) {
                                                      if (response.statusCode ==
                                                              200 ||
                                                          response.statusCode ==
                                                              204) {
                                                        ref.refresh(
                                                            interviewFaqByjobProvider(
                                                                widget.crpfid));

                                                        Navigator.pop(context);
                                                      } else {}
                                                    }).catchError((error) {});
                                                  },
                                                  error: true,
                                                  onClose: () {
                                                    Navigator.pop(context);
                                                  },
                                                  subtitle:
                                                      "Delete Question No. ${index + 1} ?",
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      InterviewFaqForm(
                                                    id: faq.id!.toInt(),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Image.asset(
                                              "assets/images/pencil.png",
                                              height: 16.sp,
                                            )),
                                      ],
                                    )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                )
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/nodata.png",
                          height: 500.0.h,
                          width: 500.0.w,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "No Data Found",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.varela(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
    }, error: (error, stackTrace) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/images/nodata.png",
                height: 500.0.h,
                width: 500.0.w,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Technical Error we Will available in while...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.varela(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }, loading: () {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
