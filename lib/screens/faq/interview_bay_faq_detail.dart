import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:job_circle/constants/custom_network_image.dart';
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

  const InterviewFaqPage({
    super.key,
    required this.crpfid,
  });

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
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.varela(color: Constants.themeBgColor),
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.first.roleName.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.varela(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16.h,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      data.first.process.toString(),
                      style: GoogleFonts.varela(
                        //fontWeight: FontWeight.bold,
                        fontSize: 12.h,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      " ||",
                      style: GoogleFonts.varela(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12.h,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      data.first.natureOfWork.toString(),
                      style: GoogleFonts.varela(
                        //  fontWeight: FontWeight.bold,
                        fontSize: 12.h,
                      ),
                    )
                  ],
                )
              ],
            ),
            actions: [
              data.first.icon != ""
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 30.h,
                      width: 60.w,
                      child: CustomImage(
                        imageUrl:
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.first.icon}",
                        defaultImageUrl: "assets/images/logo.png",
                      ))
                  : const SizedBox()
            ]),
        floatingActionButton: FloatingActionButton(
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
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.red, // Change this to your desired color
        ),
        body: Column(
          children: [
            // Visibility(
            //   visible: data.isEmpty,
            //   child: Center(
            //     child: Column(
            //       children: [
            //         Image.asset(
            //           "./assets/images/nodata.gif",
            //           height: 350.0.h,
            //           width: 500.0.w,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 20),
            //           child: Text(
            //             "Oops! We couldn't find any results. please add some Interview FAQ",
            //             textAlign: TextAlign.center,
            //             style: GoogleFonts.varela(
            //               fontSize: 15.sp,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Define the "Posted By" outside of the ListView.builder

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

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InterviewFaqForm(
                              id: faq.id!.toInt(),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (faq.question != null)
                              Text(
                                'Question ${index + 1}: ${faq.question}',
                                style: GoogleFonts.varela(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            const SizedBox(height: 8),
                            if (faq.answer != null)
                              Text(
                                'Answer: ${faq.answer}',
                                style: GoogleFonts.varela(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            const SizedBox(height: 16),
                            if (faq.firstName != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                    '${data.first.firstName} ${data.first.lastName}',
                                    style: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      );
    }, error: (error, stackTrace) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Image.asset(
                "./assets/images/nodata.gif",
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
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
