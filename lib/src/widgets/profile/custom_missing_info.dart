// ignore_for_file: unused_field, use_build_context_synchronously
// ignore_for_file: todo

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/screen/career_preference.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/custom_row.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_award_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_certificate_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_education_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_project_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_skills_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_summary_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_technical_skills_edit.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder_kit/resume_builder_kit.dart';

class CustomMissingInfoContainer extends StatefulWidget {
  final ProfileProvider provider;
  final CareerPreferenceProvider careerPreferenceProvider;
  const CustomMissingInfoContainer({
    super.key,
    required this.provider,
    required this.careerPreferenceProvider,
  });

  @override
  State<CustomMissingInfoContainer> createState() =>
      _CustomMissingInfoContainerState();
}

class _CustomMissingInfoContainerState
    extends State<CustomMissingInfoContainer> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;
  List<Widget> _cards = [];

  @override
  void initState() {
    super.initState();
    // Initialize cards first to know the length
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (_cards.isEmpty) return;

      if (_currentIndex < _cards.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Generate the list of cards based on missing info
  List<Widget> _buildCardList(
    BuildContext context,
    FileUploader fileUploader,
    dynamic profileData,
  ) {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    List<Widget> cards = [];

    /// ---------------- Career Preference  ----------------
    if (widget.careerPreferenceProvider.hasExistingData == false) {
      cards.add(
        CustomFieldBlock(
          description: "Add Career Preferences",
          buttonText: "+ Add Career Preferences",
          onPressed: () {
            NavigationService.push(CareerPreference(isFromDrawer: false));
          },
        ),
      );
    }

    /// ---------------- Resume (Build) ----------------
    if (profileData!.resume == null ||
        profileData.resume == " " ||
        profileData.resume == "null") {
      cards.add(
        CustomFieldBlock(
          description: "Never skip adding your resume.",
          buttonText: "+ Build Resume",
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResumeTemplateSelectionScreen(
                  userProfileJson: profileData.toJson(),
                  geminiApiKey: 'AIzaSyAnhaXULIUPpgeewuV7_bFZBhZBPL1PLBc',
                  onPdfGenerated: (Uint8List pdfBytes) async {
                    String? uploadedFileName = await fileUploader
                        .uploadGeneratedPdf(context, pdfBytes);
                    if (uploadedFileName != null) {
                      await widget.provider.updateResume(
                        profileData,
                        uploadedFileName,
                      );
                      CustomSnackbar.show(
                        "Resume Uploaded Successfully",
                        false,
                      );
                      NavigationService.pop();
                      NavigationService.pop();
                    }
                  },
                ),
              ),
            );
          },
        ),
      );
    }

    /// ---------------- Resume (Upload) ----------------
    if (profileData.resume == null ||
        profileData.resume == " " ||
        profileData.resume == "null") {
      cards.add(
        CustomFieldBlock(
          description: "Never skip adding your resume.",
          buttonText: "+ Add Resume",
          onPressed: () async {
            widget.provider.setLoading(true);
            // provider.setShowExperienceForm(false);
            FileUploader fileUploader = FileUploader();
            var data = await fileUploader.pickFileAndUpload(
              //TODO:: this function is use to return file path and uploaded file name ....
              needToUpload: true,
              context,
              allowedExt: ['pdf', 'doc', 'docx'],
              folder: "resume",
            );
            if (data == null) {
              widget.provider.setLoading(false);
              return;
            }
            widget.provider.fetchParseData(
              File(data.file.path),
              data.uploadedFileName!,
              context,
              profileData,
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              widget.provider.setLoading(false);
            });
            /*  String? resumePath = await fileUploader.uploadFile(context, [
              'pdf',
              'doc',
              'docx',
            ], "resume");
            if (resumePath != null) {
              widget.provider.updateResume(profileData, resumePath);
            } */
          },
        ),
      );
    }

    /// ---------------- Profile Pic ----------------
    if (profileData.profilePic == null ||
        profileData.profilePic == " " ||
        profileData.profilePic == "null") {
      cards.add(
        CustomFieldBlock(
          description: "A profile photo boosts credibility.",
          buttonText: "+ Add Profile Pic",
          onPressed: () async {
            String? profilePicPath = await fileUploader.uploadFile(context, [
              'jpeg',
              'jpg',
              "png",
            ], "icon");
            if (profilePicPath != null) {
              await widget.provider.updateProfilePic(
                profileData,
                profilePicPath,
              );
              await jobProvider.fetchJobs(applyCityFilter: true);
            }
          },
        ),
      );
    }

    /// ---------------- Skills ----------------
    if (profileData.allSkills!.isEmpty) {
      cards.add(
        CustomFieldBlock(
          description: "Skills that showcase your expertise",
          buttonText: "+ Add Skill",
          onPressed: () {
            NavigationService.push(ProfileAddSkill());
          },
        ),
      );
    }

    /// ---------------- Bio / Summary ----------------
    if (profileData.bio == null ||
        profileData.bio == " " ||
        profileData.bio == "" ||
        profileData.bio == "null") {
      cards.add(
        CustomFieldBlock(
          description: "Stand out with strong summary.",
          buttonText: "+ Add Summary",
          onPressed: () {
            widget.provider.assignSummaryToController();
            NavigationService.push(ProfileSummaryEdit());
          },
        ),
      );
    }

    /// ---------------- Education ----------------
    if (profileData.educationDetails!.isEmpty) {
      cards.add(
        CustomFieldBlock(
          description: "Showcase your education",
          buttonText: "+ Add Education",
          onPressed: () {
            widget.provider.clearEducationForm();
            widget.provider.setShowEducationForm(true);
            NavigationService.push(
              ProfileEducationEdit(fromEditOrAdd: FromEditOrAdd.add),
            );
          },
        ),
      );
    }

    /// ---------------- Projects ----------------
    if (profileData.projects!.isEmpty) {
      cards.add(
        CustomFieldBlock(
          description: "Showcase your projects",
          buttonText: "+ Add Project",
          onPressed: () {
            widget.provider.clearProjectForm();
            widget.provider.setShowProjectForm(true);
            NavigationService.push(
              ProfileProjectEdit(fromEditOrAdd: FromEditOrAdd.add),
            );
          },
        ),
      );
    }

    /// ---------------- Certifications ----------------
    if (profileData.certifications!.isEmpty) {
      cards.add(
        CustomFieldBlock(
          description: "Highlight your certifications",
          buttonText: "+ Add Certification",
          onPressed: () {
            widget.provider.clearCertificateForm();
            widget.provider.setShowCertificateForm(true);
            NavigationService.push(
              ProfileCertificateEdit(fromEditOrAdd: FromEditOrAdd.add),
            );
          },
        ),
      );
    }

    /// ---------------- Achievements ----------------
    if (profileData.awardsAndAchievements!.isEmpty) {
      cards.add(
        CustomFieldBlock(
          description: "Show your achievements to stand out",
          buttonText: "+ Add Achievement",
          onPressed: () {
            widget.provider.clearAwardForm();
            widget.provider.setShowAwardForm(true);
            NavigationService.push(
              ProfileAwardEdit(fromEditOrAdd: FromEditOrAdd.add),
            );
          },
        ),
      );
    }

    /// ---------------- Technical Skills  ----------------
    if (profileData.technicalSkills!.isEmpty) {
      cards.add(
        CustomFieldBlock(
          description: "Highlight your technical skills",
          buttonText: "+ Add Technical Skill",
          onPressed: () {
            NavigationService.push(ProfileAddTechnicalSkill());
          },
        ),
      );
    }

    /// ---------------- Career Preferences Sub Section  ----------------
    if (widget.careerPreferenceProvider.hasExistingData) {
      if (widget.careerPreferenceProvider.model.industry is List<String> &&
          (widget.careerPreferenceProvider.model.industry as List).isEmpty) {
        cards.add(
          CustomFieldBlock(
            description: "Industries you are interested in",
            buttonText: "+ Add Industry",
            onPressed: () {
              NavigationService.push(CareerPreference(isFromDrawer: false));
            },
          ),
        );
      }
      if (widget.careerPreferenceProvider.model.role is List<String> &&
          (widget.careerPreferenceProvider.model.role as List).isEmpty) {
        cards.add(
          CustomFieldBlock(
            description: "Preferred job roles",
            buttonText: "+ Add Job Role",
            onPressed: () {
              NavigationService.push(CareerPreference(isFromDrawer: false));
            },
          ),
        );
      }
      if (widget.careerPreferenceProvider.model.location is List<String> &&
          (widget.careerPreferenceProvider.model.location as List).isEmpty) {
        cards.add(
          CustomFieldBlock(
            description: "Preferred job locations",
            buttonText: "+ Add Location",
            onPressed: () {
              NavigationService.push(CareerPreference(isFromDrawer: false));
            },
          ),
        );
      }
      if (widget.careerPreferenceProvider.model.workMode is List<String> &&
          (widget.careerPreferenceProvider.model.workMode as List).isEmpty) {
        cards.add(
          CustomFieldBlock(
            description: "Preferred work type",
            buttonText: "+ Add Work Type",
            onPressed: () {
              NavigationService.push(CareerPreference(isFromDrawer: false));
            },
          ),
        );
      }
      if (widget.careerPreferenceProvider.model.shiftTime == null ||
          (widget.careerPreferenceProvider.model.shiftTime == "null" ||
              widget.careerPreferenceProvider.model.shiftTime == "")) {
        cards.add(
          CustomFieldBlock(
            description: "Preferred job shifts",
            buttonText: "+ Add Job Shift",
            onPressed: () {
              NavigationService.push(CareerPreference(isFromDrawer: false));
            },
          ),
        );
      }
      if (widget.careerPreferenceProvider.model.startSalary == null ||
          (widget.careerPreferenceProvider.model.startSalary == "null" ||
              widget.careerPreferenceProvider.model.startSalary == "" ||
              widget.careerPreferenceProvider.model.endSalary == null ||
              widget.careerPreferenceProvider.model.endSalary == "" ||
              widget.careerPreferenceProvider.model.endSalary == "null")) {
        cards.add(
          CustomFieldBlock(
            description: "Your salary expectations",
            buttonText: "+ Add Salary Expectation",
            onPressed: () {
              NavigationService.push(CareerPreference(isFromDrawer: false));
            },
          ),
        );
      }
      if (widget.careerPreferenceProvider.model.empType == null ||
          (widget.careerPreferenceProvider.model.empType == "null" ||
              widget.careerPreferenceProvider.model.empType == "")) {
        cards.add(
          CustomFieldBlock(
            description: "Preferred Emp types",
            buttonText: "+ Add Emp Type",
            onPressed: () {
              NavigationService.push(CareerPreference(isFromDrawer: false));
            },
          ),
        );
      }
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    FileUploader fileUploader = FileUploader();
    final profileData = widget.provider.profile;

    // Generate the list of available cards
    _cards = _buildCardList(context, fileUploader, profileData);

    // If no missing info, hide the container
    if (_cards.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: double.maxFinite,
      height:
          MediaQuery.of(context).size.height / 11, // Fixed height for PageView
      decoration: const BoxDecoration(color: Constants.borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------------- PageView Slider ----------------
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _cards.length,
              physics: const BouncingScrollPhysics(), // Allow manual scroll
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _cards[index],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, bottom: 5),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_cards.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: _currentIndex == index ? 6 : 6,
                      width: _currentIndex == index ? 12 : 6,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Constants.orange
                            : Constants.subtitleclr,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



/* // ignore_for_file: unused_field, use_build_context_synchronously
// ignore_for_file: todo

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/custom_row.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_skills_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_summary_edit.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder_kit/resume_builder_kit.dart';

class CustomMissingInfoContainer extends StatelessWidget {
  final ProfileProvider provider;
  const CustomMissingInfoContainer({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    FileUploader fileUploader = FileUploader();
    final profileData = provider.profile;
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: double.maxFinite,
      decoration: const BoxDecoration(color: Constants.borderColor),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// ---------------- Resume ----------------
            ///
            if (profileData!.resume == null ||
                profileData.resume == " " ||
                profileData.resume == "null")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CustomFieldBlock(
                  isAssets: false,
                  height: MediaQuery.of(context).size.height / 8,
                  iconColor: const Color.fromRGBO(37, 150, 190, 0),
                  imageUrl: CustomIconUrl.buildresumeicon,
                  description: "Never skip adding your resume.",
                  buttonText: "+ Build Resume",
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResumeTemplateSelectionScreen(
                          userProfileJson: profileData.toJson(),
                          geminiApiKey:
                              'AIzaSyAnhaXULIUPpgeewuV7_bFZBhZBPL1PLBc', // null = skip AI polishing
                          onPdfGenerated: (Uint8List pdfBytes) async {
                            //TODO:: save the selected resume file path to user profile
                            String? uploadedFileName = await fileUploader
                                .uploadGeneratedPdf(context, pdfBytes);
                            if (uploadedFileName != null) {
                              await provider.updateResume(
                                profileData,
                                uploadedFileName,
                              );
                              CustomSnackbar.show(
                                "Resume Uploaded Successfully",
                                false,
                              );
                              NavigationService.pop(); // Close the loader
                              NavigationService.pop();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            /// ---------------- Resume ----------------
            if (profileData.resume == null ||
                profileData.resume == " " ||
                profileData.resume == "null")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CustomFieldBlock(
                  isAssets: false,
                  height: MediaQuery.of(context).size.height / 8,
                  iconColor: const Color.fromRGBO(37, 150, 190, 0),
                  imageUrl: CustomIconUrl.resumeicon,
                  description: "Never skip adding your resume.",
                  buttonText: "+ Add Resume",
                  onPressed: () async {
                    String? resumePath = await fileUploader.uploadFile(
                      context,
                      ['pdf', 'doc', 'docx'],
                      "resume",
                    );
                    if (resumePath != null) {
                      provider.updateResume(profileData, resumePath);
                    }
                  },
                ),
              ),

            /// ---------------- Profile Pic ----------------
            if (profileData.profilePic == null ||
                profileData.profilePic == " " ||
                profileData.profilePic == "null")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CustomFieldBlock(
                  isAssets:
                      profileData.gender == "Male" ||
                          profileData.gender == "Female"
                      ? true
                      : false,
                  height: MediaQuery.of(context).size.height / 8,
                  imageUrl: profileData.gender == "Female"
                      ? CustomAssetUrl.femalicon
                      : profileData.gender == "Male"
                      ? CustomAssetUrl.maleicon
                      : CustomIconUrl.usericon,
                  description: "A profile photo boosts credibility.",
                  buttonText: "+ Add Profile Pic",
                  onPressed: () async {
                    String? profilePicPath = await fileUploader.uploadFile(
                      context,
                      ['jpeg', 'jpg', "png"],
                      "icon",
                    );
                    if (profilePicPath != null) {
                      await provider.updateProfilePic(
                        profileData,
                        profilePicPath,
                      );
                      await jobProvider.fetchJobs(applyCityFilter: true);
                    }
                  },
                ),
              ),

            /// ---------------- Skills ----------------
            if (profileData.allSkills!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CustomFieldBlock(
                  isAssets: false,
                  height: MediaQuery.of(context).size.height / 8,
                  imageUrl: CustomIconUrl.staricon,
                  description: "Skills that showcase your expertise",
                  buttonText: "+ Add Skill",
                  onPressed: () {
                    NavigationService.push(ProfileAddSkill());
                  },
                ),
              ),

            /// ---------------- Bio / Summary ----------------
            if (profileData.bio == null ||
                profileData.bio == " " ||
                profileData.bio == "" ||
                profileData.bio == "null")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CustomFieldBlock(
                  isAssets: true,
                  height: MediaQuery.of(context).size.height / 8,
                  imageUrl: CustomAssetUrl.summaryicon,
                  description: "Stand out with strong summary.",
                  buttonText: "+ Add Summary",
                  onPressed: () {
                    provider.assignSummaryToController();
                    NavigationService.push(ProfileSummaryEdit());
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
 */