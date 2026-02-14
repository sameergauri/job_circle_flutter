// ignore_for_file: unused_local_variable, must_be_immutable

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_basic_info.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_certificate.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_education.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_experience.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_language.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_project.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_skill.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_summary.dart';
import 'package:job_circle/src/widgets/cv_parse_profile.dart/cv_parse_technical_skill.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder_kit/resume_builder_kit.dart';

class CvParseUserProfile extends StatelessWidget {
  const CvParseUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final jobprovider = Provider.of<JobProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        var profileModel = provider.profileModel;
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                leadingWidth: 25,
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Constants.borderColor,
                elevation: 0,
                title: customText(
                  title: "Profile",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: customText(
                      title: "Timer : ${provider.formattedTime}",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Constants.red,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 5,
                      top: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Constants.darkBlue,
                            ),
                          ),
                          onPressed: () async {
                            final done = await provider.saveCvParseProfile();
                            if (done) {
                              await jobprovider.fetchJobs(
                                applyCityFilter: false,
                              );
                            }
                          },
                          child: customText(title: "Submit"),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Constants.darkBlue,
                            ),
                          ),
                          onPressed: () {
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
                                    String? uploadedFileName =
                                        await fileUploader.uploadGeneratedPdf(
                                          context,
                                          pdfBytes,
                                        );
                                    if (uploadedFileName != null) {
                                      provider.setResume(uploadedFileName);
                                      if (provider.resume != null &&
                                          provider.resume != '') {
                                        final done = await provider
                                            .saveCvParseProfile();
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
                          },
                          child: customText(title: "Select Templete"),
                        ),
                        /*  CustomButtonForSave(
                          isPading: false,
                          onTap: () async {
                            final done = await provider.saveCvParseProfile();
                            if (done) {
                              await jobprovider.fetchJobs(applyCityFilter: false);
                            }
                          },
                          title: "Submit",
                          buttonColor: Constants.darkBlue,
                          textColor: Constants.white,
                        ), */
                      ],
                    ),
                  ),
                ),
              ),
              backgroundColor: Constants.white,
              //   appBar: CustomAppBar(height: height, data: profileModel),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      CvParseBasicInfoState(
                        profileData: profileModel!,
                        provider: provider,
                      ),
                      Divider(color: Constants.lightdull, thickness: 6),
                      if (profileModel.userRequest!.bio != null &&
                          profileModel.userRequest!.bio!.isNotEmpty)
                        CvParseSummary(
                          profileData: profileModel.userRequest!,
                          provider: provider,
                        ),
                      if (profileModel.userRequest!.bio != null &&
                          profileModel.userRequest!.bio!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),
                      CvParseExperience(provider: provider),
                      if (profileModel.educationRequest != null &&
                          profileModel.educationRequest!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),
                      if (profileModel.educationRequest != null &&
                          profileModel.educationRequest!.isNotEmpty)
                        CvParseEducation(provider: provider),
                      if (profileModel.certificationsRequest != null &&
                          profileModel.certificationsRequest!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),
                      if (profileModel.certificationsRequest != null &&
                          profileModel.certificationsRequest!.isNotEmpty)
                        CvParseCertificate(provider: provider),
                      if (profileModel.userProjectRequest != null &&
                          profileModel.userProjectRequest!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),
                      if (profileModel.userProjectRequest != null &&
                          profileModel.userProjectRequest!.isNotEmpty)
                        CvParseProject(provider: provider),
                      if (profileModel.userRequest!.skills != null &&
                          profileModel.userRequest!.skills!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),
                      if (profileModel.userRequest!.skills != null &&
                          profileModel.userRequest!.skills!.isNotEmpty)
                        CvParseSkills(provider: provider),
                      //
                      //
                      if (profileModel.userRequest!.technicalSkills != null &&
                          profileModel.userRequest!.technicalSkills!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),
                      if (profileModel.userRequest!.technicalSkills != null &&
                          profileModel.userRequest!.technicalSkills!.isNotEmpty)
                        CvParseTechnicalSkill(provider: provider),
                      //
                      //
                      if (profileModel.userRequest!.languages != null &&
                          profileModel.userRequest!.languages!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),
                      if (profileModel.userRequest!.languages != null &&
                          profileModel.userRequest!.languages!.isNotEmpty)
                        CvParseLanguage(
                          profileData: profileModel.userRequest!,
                          provider: provider,
                        ),
                      if (profileModel.userRequest!.profileHeadline != null &&
                          profileModel.userRequest!.profileHeadline!.isNotEmpty)
                        Divider(color: Constants.lightdull, thickness: 6),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Divider(
                              color: Constants.borderColor,
                              thickness: 6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            if (provider.isLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }
}
