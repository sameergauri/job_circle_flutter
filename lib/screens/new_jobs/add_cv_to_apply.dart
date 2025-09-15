// ignore_for_file: unused_result, unused_local_variable, use_build_context_synchronously, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print

import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';

import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class AddCvtoApply extends ConsumerStatefulWidget {
  final int jobId;
  final int userid;
  /*  final Map<String, dynamic> params;
  final int userID; */
  // const AddCvtoApply({super.key, required this.params, required this.userID});
  const AddCvtoApply({
    super.key,
    required this.jobId,
    required this.userid,
  });

  @override
  ConsumerState<AddCvtoApply> createState() => _AddCvtoApplyState();
}

class _AddCvtoApplyState extends ConsumerState<AddCvtoApply> {
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  FileUploader fileUploader = FileUploader();
  String? resume;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return resume != null
        ? Stack(
            children: [
              Scaffold(
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await FileUploadService().deleteSingleFile(resume!);
                          ref.refresh(userDataProvider);
                          // Navigator.pop(context);
                          setState(() {
                            resume = null;
                          });
                          setState(() {
                            isLoading = false;
                          });
                        },
                        icon: const Icon(Icons.delete_outline_outlined,
                            color: Constants.darkBlue)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CustomButtonForSave(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            ProfileUpdateRequestDto profileUpdateRequestDto =
                                ProfileUpdateRequestDto(
                              id: widget.userid,
                              cvLink: resume,
                            );

                            UserUpdateRequestModel userUpdateRequestModel =
                                UserUpdateRequestModel(
                                    certificationsRequestDtos: null,
                                    educationRequestDtos: null,
                                    experienceRequestDtos: null,
                                    profileUpdateRequestDto:
                                        profileUpdateRequestDto);

                            await JobPostApiService.PostUserInfo(
                              userUpdateRequestModel,
                            );
                            ref.refresh(profileSummaryProvider);
                            ref.refresh(ProfileDataProvider);

                            ref.refresh(fetchAllApplyProvider);
                           
                            ref.refresh(userDataProvider);
                            ref.refresh(profileSummaryProvider);
                            /* Navigator.pop(context);
                          Navigator.pop(context); */
                            await JobPostApiService.postJobApply(
                              addcv: true,
                                jobId: widget.jobId,
                                userId: widget.userid,
                                context: context);

                            setState(() {
                              isLoading = false;
                            });
                          },
                          title: "Apply"),
                    ),
                  ],
                ),
                body: SizedBox()/* Container(
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
                          return const Center(
                              child: Text('Failed to load PDF'));
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ), */
              ),
              if (isLoading)
                Positioned.fill(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Blur Effect
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.black
                              .withOpacity(0.2), // Semi-transparent overlay
                        ),
                      ),
                      // Circular Progress Indicator
                      const CircularProgressIndicator(
                        color: Constants.darkBlue,
                      ),
                    ],
                  ),
                ),
            ],
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Constants.borderColor,
              automaticallyImplyLeading: true,
              elevation: 0,
              iconTheme: const IconThemeData(color: Constants.black),
              title: const OnboardingTitle(
                title: "Add Resume to apply",
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                        child: Image.asset(
                          "assets/images/profiledata.gif",
                          height: 300.0,
                          fit: BoxFit.contain,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            // If there's an error loading the image, you can return an error image or message here.
                            return Image.asset(
                              "assets/images/cv.png",
                              height: 200,
                            ); // Replace 'assets/error_image.png' with your error image.
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
                  CustomDocumentUploadButton(
                      onTab: () async {
                        resume = await fileUploader.uploadFile(
                            context, ['pdf'], "resume");

                        setState(() {});
                      },
                      title: "Add Resume"),
                  SizedBox(
                    height: 10.h,
                  ),
                  const customTextForWeather(
                    title:
                        "- Uploading your resume increases your visibility to recruiters, enhancing your job search experience.\n\n- Ensure your resume is up-to-date and relevant to maximize your opportunities.",
                    fontSize: 10,
                    color: Constants.subtitleclr,
                  ),
                ],
              ),
            ),
          );
  }
}
