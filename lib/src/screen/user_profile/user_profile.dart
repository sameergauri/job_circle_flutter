// ignore_for_file: must_be_immutable, unused_local_variable, unrelated_type_equality_checks, unused_element

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/profile/career_preference_view_card.dart';
import 'package:job_circle/src/widgets/profile/custom_app_bar.dart';
import 'package:job_circle/src/widgets/profile/custom_award_achivmnt.dart';
import 'package:job_circle/src/widgets/profile/custom_basic_info.dart';
import 'package:job_circle/src/widgets/profile/custom_certificate.dart';
import 'package:job_circle/src/widgets/profile/custom_education.dart';
import 'package:job_circle/src/widgets/profile/custom_experience.dart';
import 'package:job_circle/src/widgets/profile/custom_floating_action_button.dart';
import 'package:job_circle/src/widgets/profile/custom_language.dart';
import 'package:job_circle/src/widgets/profile/custom_missing_info.dart';
import 'package:job_circle/src/widgets/profile/custom_projects.dart';
import 'package:job_circle/src/widgets/profile/custom_skill.dart';
import 'package:job_circle/src/widgets/profile/custom_summary.dart';
import 'package:job_circle/src/widgets/profile/custom_technical_skill.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FileUploader fileUploader = FileUploader();
  final bool _localLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
      context.read<CareerPreferenceProvider>().fetchCareerPreference(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer2<ProfileProvider, CareerPreferenceProvider>(
      builder: (context, provider, careerPreferenceProvider, child) {
        if (provider.isFetching && provider.profile == null) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: CircularProgressIndicator(color: Constants.darkBlue),
            ),
          );
        }

        final profileData = provider.profile ?? ProfileModel();
        final hasError = provider.profile == null;

        if (hasError) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: CircularProgressIndicator(color: Constants.themeBgColor),
            ),
          );
        }

        return Stack(
          children: [
            Scaffold(
              backgroundColor: colors.bgColor,
              floatingActionButton:
                  profileData.resume != null &&
                      profileData.resume != " " &&
                      profileData.resume != 'null'
                  ? CustomFloatingButton(data: profileData)
                  : const SizedBox(),
              appBar: CustomAppBar(data: profileData),
              body: RefreshIndicator(
                color: Constants.darkBlue,
                onRefresh: () async {
                  await provider.fetchProfile();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        CustomBasicInfoContainer(profileProvider: provider),
                        if (_hasMissingInfo(
                          profileData,
                          careerPreferenceProvider,
                        ))
                          CustomMissingInfoContainer(
                            provider: provider,
                            careerPreferenceProvider: careerPreferenceProvider,
                          ),
                        if ((profileData.bio != null &&
                                profileData.bio != " " &&
                                profileData.bio != "null") &&
                            (profileData.resume != null &&
                                profileData.resume != " " &&
                                profileData.allSkills!.isNotEmpty &&
                                profileData.profilePic != " " &&
                                profileData.profilePic != null))
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        if (profileData.bio != null &&
                            profileData.bio != " " &&
                            profileData.bio != "" &&
                            profileData.bio != "null")
                          CustomSummaryContainer(provider: provider),
                        if (profileData.bio != null &&
                            profileData.bio != " " &&
                            profileData.bio != "null" &&
                            profileData.bio != "")
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        CustomExperienceContainer(profileProvider: provider),
                        if (profileData.educationDetails != null &&
                            profileData.educationDetails != "" &&
                            profileData.educationDetails != [] &&
                            profileData.educationDetails!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        if (profileData.educationDetails != null &&
                            profileData.educationDetails != "" &&
                            profileData.educationDetails != [] &&
                            profileData.educationDetails!.isNotEmpty)
                          CustomEducationContainer(provider: provider),
                        if (profileData.certifications != null &&
                            profileData.certifications != "" &&
                            profileData.certifications != [] &&
                            profileData.certifications!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        if (profileData.certifications != null &&
                            profileData.certifications != "" &&
                            profileData.certifications != [] &&
                            profileData.certifications!.isNotEmpty)
                          CertificationSection(provider: provider),
                        if (profileData.projects != null &&
                            profileData.projects != "" &&
                            profileData.projects != [] &&
                            profileData.projects!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        if (profileData.projects != null &&
                            profileData.projects != "" &&
                            profileData.projects != [] &&
                            profileData.projects!.isNotEmpty)
                          ProjectSection(provider: provider),
                        if (profileData.awardsAndAchievements != null &&
                            profileData.awardsAndAchievements != "" &&
                            profileData.awardsAndAchievements != [] &&
                            profileData.awardsAndAchievements!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        if (profileData.awardsAndAchievements != null &&
                            profileData.awardsAndAchievements != "" &&
                            profileData.awardsAndAchievements != [] &&
                            profileData.awardsAndAchievements!.isNotEmpty)
                          CustomAwardAchievment(provider: provider),
                        if (profileData.allSkills != null &&
                            profileData.allSkills != "" &&
                            profileData.allSkills != [] &&
                            profileData.allSkills!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        if (profileData.allSkills != null &&
                            profileData.allSkills != "" &&
                            profileData.allSkills != [] &&
                            profileData.allSkills!.isNotEmpty)
                          SkillsSection(provider: provider),
                        //for technical skills
                        if (profileData.technicalSkills != null &&
                            profileData.technicalSkills != "" &&
                            profileData.technicalSkills != [] &&
                            profileData.technicalSkills!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Divider(
                              color: colors.bottomsheerCard1Color,
                              thickness: 6,
                            ),
                          ),
                        if (profileData.technicalSkills != null &&
                            profileData.technicalSkills != "" &&
                            profileData.technicalSkills != [] &&
                            profileData.technicalSkills!.isNotEmpty)
                          CustomTechnicalSkill(provider: provider),
                        //
                        if (profileData.languagesKnown != null &&
                            profileData.languagesKnown!.isNotEmpty) ...[
                          Divider(
                            color: colors.bottomsheerCard1Color,
                            thickness: 6,
                          ),
                          CustomLanguageKnownContainer(
                            profileProvider: provider,
                          ),
                        ],
                        const SizedBox(height: 10),
                        if (careerPreferenceProvider.hasExistingData)
                          Divider(
                            color: colors.bottomsheerCard1Color,
                            thickness: 6,
                          ),
                        if (careerPreferenceProvider.hasExistingData)
                          CareerProfileCard(
                            // career preference card
                            careerPreferenceProvider: careerPreferenceProvider,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Divider(
                                color: colors.appbarColor,
                                thickness: 6,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (provider.isUpdating || _localLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  bool _hasMissingInfo(
    ProfileModel profileData,
    CareerPreferenceProvider careerPreferenceProvider,
  ) {
    return ((profileData.resume == null ||
            profileData.resume == " " ||
            profileData.resume == 'null') ||
        profileData.allSkills!.isEmpty ||
        (profileData.bio == null ||
            profileData.bio == " " ||
            profileData.bio == "" ||
            profileData.bio == "null") ||
        (profileData.profilePic == " " ||
            profileData.profilePic == null ||
            profileData.profilePic == "null") ||
        (profileData.educationDetails == null ||
            profileData.educationDetails == "" ||
            profileData.educationDetails == [] ||
            profileData.educationDetails!.isEmpty) ||
        (profileData.projects == " " ||
            profileData.projects == null ||
            profileData.projects!.isEmpty) ||
        (profileData.certifications == " " ||
            profileData.certifications == null ||
            profileData.certifications == "null" ||
            profileData.certifications!.isEmpty) ||
        (profileData.awardsAndAchievements == " " ||
            profileData.awardsAndAchievements == null ||
            profileData.awardsAndAchievements == "null" ||
            profileData.awardsAndAchievements!.isEmpty) ||
        (!careerPreferenceProvider.hasExistingData) ||
        (careerPreferenceProvider.hasExistingData &&
            (careerPreferenceProvider.model.industry == null ||
                careerPreferenceProvider.model.industry == " " ||
                careerPreferenceProvider.model.industry == "" ||
                careerPreferenceProvider.model.industry == "null" ||
                (careerPreferenceProvider.model.industry is List<String> &&
                    (careerPreferenceProvider.model.industry as List)
                        .isEmpty) ||
                careerPreferenceProvider.model.role == null ||
                careerPreferenceProvider.model.role == " " ||
                careerPreferenceProvider.model.role == "" ||
                careerPreferenceProvider.model.role == "null" ||
                (careerPreferenceProvider.model.role is List<String> &&
                    (careerPreferenceProvider.model.role as List).isEmpty) ||
                careerPreferenceProvider.model.location == null ||
                careerPreferenceProvider.model.location == " " ||
                careerPreferenceProvider.model.location == "" ||
                careerPreferenceProvider.model.location == "null" ||
                (careerPreferenceProvider.model.location is List<String> &&
                    (careerPreferenceProvider.model.location as List)
                        .isEmpty) ||
                careerPreferenceProvider.model.startSalary == null ||
                careerPreferenceProvider.model.startSalary == " " ||
                careerPreferenceProvider.model.startSalary == "" ||
                careerPreferenceProvider.model.startSalary == "null" ||
                careerPreferenceProvider.model.endSalary == null ||
                careerPreferenceProvider.model.endSalary == " " ||
                careerPreferenceProvider.model.endSalary == "" ||
                careerPreferenceProvider.model.endSalary == "null" ||
                careerPreferenceProvider.model.noticePeriod == null ||
                careerPreferenceProvider.model.noticePeriod == " " ||
                careerPreferenceProvider.model.noticePeriod == "" ||
                careerPreferenceProvider.model.noticePeriod == "null" ||
                careerPreferenceProvider.model.empType == null ||
                careerPreferenceProvider.model.empType == " " ||
                careerPreferenceProvider.model.empType == "" ||
                careerPreferenceProvider.model.empType == "null" ||
                (careerPreferenceProvider.model.empType is List<String> &&
                    (careerPreferenceProvider.model.empType as List).isEmpty) ||
                careerPreferenceProvider.model.shiftTime == null ||
                careerPreferenceProvider.model.shiftTime == " " ||
                careerPreferenceProvider.model.shiftTime == "" ||
                careerPreferenceProvider.model.shiftTime == "null" ||
                (careerPreferenceProvider.model.shiftTime is List<String> &&
                    (careerPreferenceProvider.model.shiftTime as List)
                        .isEmpty))));
  }
}
