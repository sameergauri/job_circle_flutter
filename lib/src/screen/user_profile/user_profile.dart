// ignore_for_file: must_be_immutable, unused_local_variable, unrelated_type_equality_checks

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
    return Consumer2<ProfileProvider, CareerPreferenceProvider>(
      builder: (context, provider, careerPreferenceProvider, child) {
        if (provider.isFetching && provider.profile == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Constants.darkBlue),
            ),
          );
        }

        final profileData = provider.profile ?? ProfileModel();
        final hasError = provider.profile == null;

        if (hasError) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Constants.themeBgColor),
            ),
          );
        }

        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
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
                  child: Column(
                    children: [
                      CustomBasicInfoContainer(profileProvider: provider),
                      if ((profileData.resume == null ||
                              profileData.resume == " " ||
                              profileData.resume == 'null') ||
                          profileData.allSkills!.isEmpty ||
                          (profileData.bio == null ||
                              profileData.bio == " " ||
                              profileData.bio == "" ||
                              profileData.bio == "null") ||
                          (profileData.profilePic == " " ||
                              profileData.profilePic == null ||
                              profileData.profilePic == "null"))
                        CustomMissingInfoContainer(provider: provider),
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
                            color: Constants.lightdull,
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
                          child: const Divider(
                            color: Constants.lightdull,
                            thickness: 6,
                          ),
                        ),
                      CustomExperienceContainer(profileProvider: provider),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: const Divider(
                          color: Constants.lightdull,
                          thickness: 6,
                        ),
                      ),
                      CustomEducationContainer(provider: provider),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: const Divider(
                          color: Constants.lightdull,
                          thickness: 6,
                        ),
                      ),
                      CertificationSection(provider: provider),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: const Divider(
                          color: Constants.lightdull,
                          thickness: 6,
                        ),
                      ),
                      ProjectSection(provider: provider),
                        Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: const Divider(
                          color: Constants.lightdull,
                          thickness: 6,
                        ),
                      ),
                      CustomAwardAchievment(provider: provider),
                      if (profileData.allSkills != null &&
                          profileData.allSkills != "" &&
                          profileData.allSkills != [])
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: const Divider(
                            color: Constants.lightdull,
                            thickness: 6,
                          ),
                        ),
                      if (profileData.allSkills != null &&
                          profileData.allSkills != "" &&
                          profileData.allSkills != [])
                        SkillsSection(provider: provider),
                      //for technical skills
                      if (profileData.technicalSkills != null &&
                          profileData.technicalSkills != "" &&
                          profileData.technicalSkills != [])
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: const Divider(
                            color: Constants.lightdull,
                            thickness: 6,
                          ),
                        ),
                      if (profileData.technicalSkills != null &&
                          profileData.technicalSkills != "" &&
                          profileData.technicalSkills != [])
                        CustomTechnicalSkill(provider: provider),
                      //
                      const Divider(color: Constants.lightdull, thickness: 6),
                      CustomLanguageKnownContainer(profileProvider: provider),
                      const SizedBox(height: 10),
                      if (careerPreferenceProvider.hasExistingData)
                        const Divider(color: Constants.lightdull, thickness: 6),
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
                              color: Constants.borderColor,
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
            if (provider.isUpdating || _localLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }
}
