// ignore_for_file: unused_result, unused_local_variable, avoid_unnecessary_containers, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/jobs/talent_pool.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';

class AddCv extends ConsumerStatefulWidget {
  /*  final Map<String, dynamic> params;
  final int userID; */
  // const AddCv({super.key, required this.params, required this.userID});
  const AddCv({super.key});

  @override
  ConsumerState<AddCv> createState() => _AddCvState();
}

class _AddCvState extends ConsumerState<AddCv> {
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  String? resume;

  @override
  Widget build(BuildContext context) {
    return resume != null
        ? Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    resume = await Delete(true);
                    var payload = {
                      "stage": "upload_cv",
                      "data": {
                        "id": await Utils.getPreferencesValue(
                            null, ESharedPreferences.user_id.name),
                        "cv_link": null
                      }
                    };
                    await save(null, payload);
                    ref.refresh(userDataProvider);
                    // Navigator.pop(context);
                    setState(() {});

                    /*  setState(() {
                                    resume = Delete(true).toString();
                                  }); */
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.themeBgColor)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        const Text("Remove"),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    resume = await uploadFile(['pdf'], "cv");
                    var payload = {
                      "stage": "upload_cv",
                      "data": {
                        "id": await Utils.getPreferencesValue(
                            null, ESharedPreferences.user_id.name),
                        "cv_link": resume
                      }
                    };
                    await save(resume, payload);
                    ref.refresh(userDataProvider);
                    // Navigator.pop(context);
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.themeBgColor)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        const Text("Replace"),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    ref.refresh(fetchAllApplyProvider);
                    ref.refresh(fetchAllTalentPool);
                    ref.refresh(userDataProvider);
                    ref.refresh(profileSummaryProvider);
                    ref.refresh(fetchAllApplicantProvider);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false);
                    /* resume = await uploadFile(['pdf'], "cv");
                    var payload = {
                      "stage": "upload_cv",
                      "data": {
                        "id": await Utils.getPreferencesValue(
                            null, ESharedPreferences.user_id.name),
                        "cv_link": resume
                      }
                    };
                    save(resume, payload);
                    Navigator.pop(context);
                    setState(() {}); */
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.themeBgColor)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        const Text("Submit"),
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              child: FutureBuilder<PDFDocument>(
                future: PDFDocument.fromURL(
                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$resume"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return PDFViewer(
                        scrollDirection: Axis.vertical,
                        panLimit: 1.1,
                        document: snapshot.data!,
                        zoomSteps: 3,
                        showNavigation: false,
                        showPicker: false,

                        // numberPickerConfirmWidget: f,
                      );
                    } else {
                      return const Center(child: Text('Failed to load PDF'));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(
                          "Skip",
                          style:
                              GoogleFonts.varela(color: Constants.themeBgColor),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: Text(
                      "Recruiters identify prospective candidates through their CV.",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold,
                          color: Constants.themeBgColor,
                          fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                          /*  boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                //  blurRadius: 10,
                                blurRadius: 15.0,
                                offset: const Offset(1, 1))
                          ], */ //"assets/images/cv_doc.png"
                        ),
                        child: Image.network(
                          "https://cdn.discordapp.com/attachments/1095606068614283337/1169234100503191562/Profile_data.gif?ex=6554a91c&is=6542341c&hm=7d792b032b842e88e73481281c9281d951545f3e8d8988abd07ed4f91b85ff41&",
                          height: 300.0,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // If the image is fully loaded, return the child (original image)
                              return child;
                            } else {
                              // While the image is loading, you can return a loading indicator here (e.g., CircularProgressIndicator).
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            // If there's an error loading the image, you can return an error image or message here.
                            return Image.asset(
                                "assets/images/cv.png"); // Replace 'assets/error_image.png' with your error image.
                          },
                        ),
                        /*  child: Image.network(
                          "https://cdn.discordapp.com/attachments/1095606068614283337/1169234100503191562/Profile_data.gif?ex=6554a91c&is=6542341c&hm=7d792b032b842e88e73481281c9281d951545f3e8d8988abd07ed4f91b85ff41&",
                          height: 300.h,
                          fit: BoxFit.contain,
                        ), */
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      resume = await uploadFile(['pdf'], "cv");
                      var payload = {
                        "stage": "upload_cv",
                        "data": {
                          "id": await Utils.getPreferencesValue(
                              null, ESharedPreferences.user_id.name),
                          "cv_link": resume
                        }
                      };
                      save(resume, payload);
                      setState(() {});
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 15, right: 15),
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                          color: Constants.themeBgColor,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Center(
                          child: Text(
                        "Add Resume",
                        style: GoogleFonts.varela(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  Text(
                    "Never miss adding your resume",
                    style: GoogleFonts.varela(
                        fontSize: 14.sp, color: Constants.subtitleclr),
                  ),
                ],
              ),
            ),
          );
  }

  Future<String?> Delete(bool iscv) async {
    try {
      var res = await FileUploadService().deleteSingleFile(iscv
          ? profilemodel.cv_link.toString()
          : profilemodel.profile_pic.toString());
    } catch (e) {
      // Close the loading dialog in case of exceptions
      Navigator.pop(context);

      // Handle any exceptions that occur during the upload
      print("Error during file upload: $e");
      return null;
    }
    return null;
  }

  Future<String?> uploadFile(allowExt, String folder) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile(folder, result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          print(filename);
          print("Filename: $filePath");

          // Close the loading dialog when the upload is successful
          Navigator.pop(context);
          //save(filename, data);

          return filename;
        } else {
          // Close the loading dialog when there is an error
          Navigator.pop(context);

          // Handle the case where the server returns an error
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error while uploading cv"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
          return null;
        }
      } catch (e) {
        // Close the loading dialog in case of exceptions
        Navigator.pop(context);

        // Handle any exceptions that occur during the upload
        print("Error during file upload: $e");
        return null;
      }
    } else {
      // Close the loading dialog when the user cancels file selection
      Navigator.pop(context);

      // Handle the case where the user cancels file selection
      return profilemodel.profile_pic;
    }
  }

  save(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'upload_cv') {
        profilemodel.cv_link = filePath;

        profilemodel.cv_upladted_date =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }
}
