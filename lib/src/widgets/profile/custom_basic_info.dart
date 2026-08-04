// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_basic_info_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class CustomBasicInfoContainer extends StatelessWidget {
  final ProfileProvider profileProvider;

  const CustomBasicInfoContainer({super.key, required this.profileProvider});
  final bool _localLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final profile = profileProvider.profile;

    String subHeadlineText = "";
    if (profile != null) {
      if (profile.profileHeadline != null &&
          profile.profileHeadline!.isNotEmpty &&
          profile.profileHeadline != "null") {
        subHeadlineText = profile.profileHeadline!;
      } else if (profile.experiences != null &&
          profile.experiences!.isNotEmpty) {
        final exp = profile.experiences!.first;
        subHeadlineText = "${exp.jobTitle} at ${exp.companyName}";
      } else if (profile.educationDetails != null &&
          profile.educationDetails!.isNotEmpty) {
        final edu = profile.educationDetails!.first;
        subHeadlineText = "${edu.degreeSpc} from ${edu.university}";
      }
    }

    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(color: colors.bgColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------------- Profile Pic Section ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap:
                        profileProvider.profile!.profilePic != null &&
                            profileProvider.profile!.profilePic != " " &&
                            profileProvider.profile!.profilePic != 'null'
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Constants.themeBgColor,
                                        radius: height / 6,
                                        backgroundImage:
                                            profileProvider
                                                        .profile!
                                                        .profilePic !=
                                                    null &&
                                                profileProvider
                                                        .profile!
                                                        .profilePic !=
                                                    " " &&
                                                profileProvider
                                                        .profile!
                                                        .profilePic !=
                                                    'null'
                                            ? Image.network(
                                                "${GlobalConstants.Image_url}${profileProvider.profile!.profilePic}",
                                                fit: BoxFit.fill,
                                              ).image
                                            : Image.asset(
                                                profileProvider
                                                            .profile!
                                                            .gender !=
                                                        "Male"
                                                    ? CustomAssetUrl.femalicon
                                                    : CustomAssetUrl.maleicon,
                                                fit: BoxFit.fill,
                                              ).image,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () async {
                                            NavigationService.pop();
                                            await profileProvider
                                                .deleteProfilePic(
                                                  profileProvider.profile!,
                                                );
                                            jobProvider.fetchJobs(
                                              applyCityFilter: true,
                                            );
                                          },
                                          icon: CustomNetworkImage(
                                            imageUrl: CustomIconUrl.deleteicon,
                                            defaultIcon:
                                                Icons.cast_for_education,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        : () {},
                    child: CircleAvatar(
                      backgroundColor: Constants.borderColor,
                      radius: 45,
                      backgroundImage:
                          profileProvider.profile!.profilePic != null &&
                              profileProvider.profile!.profilePic != " " &&
                              profileProvider.profile!.profilePic != "null"
                          ? NetworkImage(
                              "${GlobalConstants.Image_url}${profileProvider.profile!.profilePic}",
                            )
                          : profileProvider.profile!.gender == "Male"
                          ? AssetImage(CustomAssetUrl.maleicon)
                          : profileProvider.profile!.gender == "Female"
                          ? AssetImage(CustomAssetUrl.femalicon)
                          : NetworkImage(CustomIconUrl.usericon),
                    ),
                  ),

                  /// Add Icon for profile upload
                  Positioned(
                    right: width / 160,
                    bottom: height / 85,
                    child: InkWell(
                      onTap: () async {
                        FileUploader fileUploader = FileUploader();
                        var data1 = await fileUploader.uploadFile(context, [
                          'jpeg',
                          'jpg',
                          "png",
                        ], "profile_pic");
                        if (data1 != null) {
                          await profileProvider.updateProfilePic(
                            profileProvider.profile!,
                            data1,
                          );
                          jobProvider.fetchJobs(applyCityFilter: true);
                        }
                      },
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 8,
                          child: Icon(
                            Icons.add_circle_outlined,
                            size: 15,
                            color: Constants.themeBgColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// ---------------- Profile Info Section ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 20), // placeholder for left space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Always shows FirstName and LastName
                    if (profile != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText(
                            title:
                                "${profile.firstName.toString().toTitleCase()} ${profile.lastName.toString().toTitleCase()}",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.headingColor,
                          ),
                          if (profile.isUserVerified == true)
                            Icon(
                              Icons.verified,
                              color: Constants.darkBlue,
                              size: 18,
                            ),
                          if (profile.isUserVerified != true ||
                              profile.isUserVerified == null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomToggleButton(
                                title: "Verify",
                                onTap: () {},
                              ),
                            ),
                        ],
                      ),
                    if (subHeadlineText.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: customTextFornCambria(
                              monst: false,
                              title: subHeadlineText,
                              softwrap: true,
                              maxlines: 3,
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: colors.headingColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (profile?.userLocation != null) ...[
                      customText(
                        title: capitalizeFirstLetter(
                          formatLocality(profile!.userLocation.toString()),
                        ),
                        softwrap: true,
                        maxlines: 3,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.subTitleColor,
                      ),
                    ],
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  profileProvider.assignDataFromModelToController();
                  NavigationService.push(ProfileBasicInforEdit());
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: CustomNetworkImage(
                    imageUrl: CustomIconUrl.editicon,
                    defaultIcon: Icons.cast_for_education,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  String formatLocality(String locality) {
    List<String> parts = locality.split(',');
    if (parts.length >= 2) {
      String part1 = parts[0].trim();
      String part2 = parts[1].trim();
      return '$part1, $part2';
    }
    return locality;
  }
}
