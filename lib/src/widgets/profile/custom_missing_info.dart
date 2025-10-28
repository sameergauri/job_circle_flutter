// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/custom_row.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_skills_edit.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_summary_edit.dart';

class CustomMissingInfoContainer extends StatelessWidget {
  final ProfileProvider provider;
  const CustomMissingInfoContainer({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    FileUploader fileUploader = FileUploader();
    final profileData = provider.profile;
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
            if (profileData!.resume == null ||
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
            if (profileData.profilePic == null || profileData.profilePic == " ")
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
                      provider.updateProfilePic(profileData, profilePicPath);
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
