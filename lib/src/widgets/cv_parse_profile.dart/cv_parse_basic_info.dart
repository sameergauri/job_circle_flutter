// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_edit/basic_info_edit.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CvParseBasicInfoState extends StatelessWidget {
  final CreateNewUserModel profileData;
  final SignupCreateUserProvider provider;

  CvParseBasicInfoState({
    super.key,
    required this.profileData,
    required this.provider,
  });

  bool _localLoading = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(color: Colors.white),
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
                        provider.profilePic != null && provider.profilePic != ''
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
                                            provider.profilePic != null &&
                                                provider.profilePic != ''
                                            ? Image.network(
                                                "${GlobalConstants.Image_url}${provider.profilePic}",
                                                fit: BoxFit.fill,
                                              ).image
                                            : Image.asset(
                                                profileData
                                                            .userRequest!
                                                            .gender ==
                                                        "Male"
                                                    ? CustomAssetUrl.maleicon
                                                    : profileData
                                                              .userRequest!
                                                              .gender ==
                                                          "Female"
                                                    ? CustomAssetUrl.femalicon
                                                    : CustomAssetUrl.maleicon,
                                                fit: BoxFit.fill,
                                              ).image,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () async {
                                            FileUploadService
                                            fileUploadService =
                                                FileUploadService();
                                            await fileUploadService
                                                .deleteSingleFile(
                                                  provider.profilePic!,
                                                );
                                            provider.setProfilePic("");
                                           NavigationService.pop();
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
                          provider.profilePic != null &&
                              provider.profilePic != '' &&
                              provider.profilePic != "null"
                          ? NetworkImage(
                              "${GlobalConstants.Image_url}${provider.profilePic}",
                            )
                          : profileData.userRequest!.gender == "Male"
                          ? AssetImage(CustomAssetUrl.maleicon)
                          : profileData.userRequest!.gender == "Female"
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
                          provider.setProfilePic(data1);
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
              const SizedBox(width: 30), // placeholder for left space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profileData.userRequest!.middleName != null &&
                            profileData.userRequest!.middleName != 'null'
                        ? customText(
                            title:
                                "${profileData.userRequest!.firstName.toString().toTitleCase()} ${profileData.userRequest!.middleName.toString().toTitleCase()} ${profileData.userRequest!.lastName.toString().toTitleCase()}",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        : customText(
                            title:
                                "${profileData.userRequest!.firstName.toString().toTitleCase()} ${profileData.userRequest!.lastName.toString().toTitleCase()}",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: customTextFornCambria(
                            title:
                                profileData.userRequest!.profileHeadline !=
                                        null &&
                                    profileData
                                        .userRequest!
                                        .profileHeadline!
                                        .isNotEmpty
                                ? profileData.userRequest!.profileHeadline
                                      .toString()
                                : profileData.experienceRequest!.isNotEmpty
                                ? "${profileData.experienceRequest!.first.jobTitle} at ${profileData.experienceRequest!.first.companyName}"
                                : "${profileData.educationRequest?.first.degreeSpc} from ${profileData.educationRequest?.first.university}",
                            softwrap: true,
                            maxlines: 3,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    if (profileData.userRequest!.userLocation != null)
                      customText(
                        title:
                            ' ${capitalizeFirstLetter(formatLocality(profileData.userRequest!.userLocation.toString()))}',
                        softwrap: true,
                        maxlines: 3,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Constants.subtitleclr,
                      ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  /*   provider.clearbasicDetail();
                  provider.assignCvParseDataToControllers(); */
                  NavigationService.push(EditBasicInfo());
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
