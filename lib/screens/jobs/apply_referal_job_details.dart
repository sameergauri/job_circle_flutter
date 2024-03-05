import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/themes/colors.dart';

final jobDetailsProvider =
    FutureProvider.family<JobDetailsModel, int>((ref, id) async {
  try {
    final paymentDetails =
        await _ApplyAndReferalJobDetailsState.getJobDetails(id);
    return paymentDetails ??
        JobDetailsModel(); // Provide a default value if paymentDetails is null
  } catch (e) {
    throw Exception('Failed to fetch payment details'); // Throw an exception
  }
});

class ApplyAndReferalJobDetails extends ConsumerStatefulWidget {
  int? id;
  ApplyAndReferalJobDetails({super.key, this.id});

  @override
  ConsumerState<ApplyAndReferalJobDetails> createState() =>
      _ApplyAndReferalJobDetailsState();
}

class _ApplyAndReferalJobDetailsState
    extends ConsumerState<ApplyAndReferalJobDetails> {
  JobDetailsModel jobDetailsModel = JobDetailsModel();

  static Future<JobDetailsModel?> getJobDetails(int id) async {
    try {
      var result =
          await JobSearchService().getJobDetails({'id': id.toString()});
      if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
        return JobDetailsModel.fromMap(Utils.parseResponse(result).resultData);
      }
      // Return null if result key is not 'SUCCESS'
      return null;
    } catch (error) {
      // Handle the error within the function
      print('Error occurred during job details retrieval: $error');
      // Return null if an error occurs
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAllJobDetails = ref.watch(jobDetailsProvider(widget.id!.toInt()));
    return getAllJobDetails.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            titleTextStyle: GoogleFonts.varela(color: Constants.themeBgColor),
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobDetailsModel.rolename != null
                      ? jobDetailsModel.rolename.toString()
                      : "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.varela(
                    fontSize: 16.h,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      jobDetailsModel.process != null
                          ? jobDetailsModel.process.toString()
                          : "",
                      style: GoogleFonts.varela(
                        fontSize: 12.h,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      jobDetailsModel.naturofwork != null ? " ||" : "",
                      style: GoogleFonts.varela(
                        fontSize: 12.h,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      jobDetailsModel.naturofwork != null
                          ? jobDetailsModel.naturofwork.toString()
                          : "",
                      style: GoogleFonts.varela(
                        fontSize: 12.h,
                      ),
                    )
                  ],
                )
              ],
            ),
            actions: [
              jobDetailsModel.icon != ""
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 20.h,
                      width: 40.w,
                      child: CustomImage(
                        imageUrl:
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobDetailsModel.icon}",
                        defaultImageUrl: "assets/images/logo.png",
                      ))
                  : const SizedBox()
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Container(),
        );
      },
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: Text("Error while fetching the data"),
          ),
        );
      },
      loading: () {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
