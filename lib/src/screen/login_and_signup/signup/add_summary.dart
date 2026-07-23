// ignore_for_file: unused_result, must_be_immutable
// ignore_for_file: todo


import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_onboarding_titlle.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/custom_text_with_underline.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder_kit/resume_builder_kit.dart';

class AddSummary extends StatelessWidget {
  const AddSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final jobprovider = Provider.of<JobProvider>(context, listen: false);
    final provider = Provider.of<SignupCreateUserProvider>(
      context,
      listen: false,
    );
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () async {
                  if (provider.bio.text.isEmpty) {
                    CustomSnackbar.show("Please enter summary", true);
                  } else {
                    // provider.updateProfileModelForSummary();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResumeTemplateSelectionScreen(
                          themeMode: ThemeMode.light,
                          buttonTitle: "Save & Continue",
                          userProfileJson: provider
                              .buildProfileModelFromProvider(provider)
                              .toJson(),
                          geminiApiKey:
                              'AIzaSyAnhaXULIUPpgeewuV7_bFZBhZBPL1PLBc', // null = skip AI polishing
                          onPdfGenerated: (Uint8List pdfBytes) async {
                            FileUploader fileUploader = FileUploader();
                            //TODO:: save the selected resume file path to user profile
                            String? uploadedFileName = await fileUploader
                                .uploadGeneratedPdf(context, pdfBytes);
                            if (uploadedFileName != null) {
                              provider.setResume(uploadedFileName);
                              if (provider.resume != null &&
                                  provider.resume != '') {
                                final done = await provider.saveUserData();
                                if (done) {
                                  await jobprovider.fetchJobs(
                                    applyCityFilter: false,
                                  );
                                }
                              }
                              CustomSnackbar.show(
                                "Resume Uploaded Successfully",
                                false,
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
                title: "Select Template & Continue",
                buttonColor: Constants.darkBlue,
                textColor: Constants.white,
              ),
            ),
          ),
          resizeToAvoidBottomInset: true, // Add this line
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWithUnderLine(title: "Summary", fontSize: 16),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const customText(title: ""),
                        ValueListenableBuilder<TextEditingValue>(
                          // <-- Delete this line if not using ValueListenableBuilder
                          valueListenable: provider.bio,
                          builder: (context, value, child) {
                            if (value.text.isEmpty &&
                                provider.isSummaryGenereted == false) {
                              return InkWell(
                                onTap: () async {
                                  provider.fetchSummaryUsingAi();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    color: Constants.lightdull,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Constants.subtitleclr,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: CustomIconUrl.aiicon,
                                        defaultIcon: Icons.star_border_outlined,
                                      ),
                                      customText(
                                        title: "AI writer",
                                        color: Constants.winecolor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () async {
                                  provider.clearProfileSummary();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  child: customText(
                                    title: "Clear All",
                                    color: Constants.red,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  /*  CustomAutoSizeTextField(
                    needClearAll: false,
                    controller: provider.bio,
                    hintText:
                        "Boost visibility with a compelling career summary.",
                    maxline: 15,
                  ), */
                ],
              ),
            ),
          ),
        ),
        if (provider.isSummaryLoading) CustomLoadingIndicator(),
      ],
    );
  }
}
