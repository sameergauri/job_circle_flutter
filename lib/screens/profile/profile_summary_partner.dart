// ignore_for_file: unused_result

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/screen1.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PartnerProfileData = FutureProvider<ProfileModel>((ref) async {
  //ref.watch(profileSummaryProvider);
  return _PartnerProfileState.bindPartnerProfileSummary();
});

class PartnerProfile extends ConsumerStatefulWidget {
  const PartnerProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PartnerProfileState();
}

class _PartnerProfileState extends ConsumerState<PartnerProfile> {
  static Future<ProfileModel> bindPartnerProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);

    final response = await http.post(
      Uri.parse(
          "http://${GlobalConstants.API_Host_one}/users/v1/getprofileById?userId=$id"),
    );

    /*  final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/profileSummary/$id')); */

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("resultData")) {
        return ProfileModel.fromJson(parsedResponse["resultData"]['profile']);
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool isLoading = false;
  FileUploader fileUploader = FileUploader();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final Partner = ref.watch(PartnerProfileData);
    return Partner.when(
      data: (data) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              /* floatingActionButton:
                  profileData.resume != null && profileData.resume != " "
                      ? customFloatingButton(context, profileData)
                      : const SizedBox(), */
              appBar: customAppBar(height, data),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SafeArea(
                      child: customContainerforBasicInfo(
                          data, context, height, width),
                    ),
                    /*  if (profileData.resume == null ||
                        profileData.resume == " " ||
                        profileData.allSkills!.isEmpty ||
                        profileData.bio == null ||
                        profileData.profilePic == " " ||
                        profileData.profilePic == null ||
                        profileData.bio == " ")
                      customMissingInfo(profileData),
                    if (profileData.bio != null && profileData.bio != " ")
                      customContainerforSummary(profileData),
                    customcontainerForExperience(profileData),
                    customcontainerForEducation(profileData),
                    customcontainerForcertification(profileData),
                    if (profileData.allSkills != null &&
                        profileData.allSkills != "" &&
                        profileData.allSkills != [])
                      customcontainerForSkills(profileData),
                    customcontainerForLanguageKnown(profileData), */
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3,
                          child: const Divider(
                            color: Constants.borderColor,
                            thickness: 6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
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
        );
      },
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: Text("No data found"),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Constants.darkBlue,
            ),
          ),
        );
      },
    );
  }

  //
  //
  //
  //
  //
  //
  //
  Container customContainerforBasicInfo(ProfileModel profileData,
      BuildContext context, double height, double width) {
    return Container(
      //  padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: profileData.profilePic != null &&
                            profileData.profilePic != " "
                        ? () {
                            showDialog(
                              context: context,
                              // Set this property to true
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor:
                                              Constants.themeBgColor,
                                          radius: height / 6,
                                          backgroundImage: profileData
                                                          .profilePic !=
                                                      null &&
                                                  profileData.profilePic != " "
                                              ? Image.network(
                                                  "https://s3.ap-south-1.amazonaws.com/job-circle-2/${profileData.profilePic}",
                                                  fit: BoxFit.fill,
                                                ).image
                                              : Image.asset(
                                                  profileData.gender != "Male"
                                                      ? "assets/images/leadfemal.png"
                                                      : "assets/images/leadmale.png",
                                                  //  height: 8.h,
                                                  fit: BoxFit.fill,
                                                ).image),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              setState(() {
                                                isLoading = true;
                                              });

                                              /*  resume = await uploadFile(['pdf'], "cv", profileData.cv_ink); */

                                              ProfileUpdateRequestDto
                                                  profileUpdateRequestDto =
                                                  ProfileUpdateRequestDto(
                                                      id: profileData.id,
                                                      profilePic: " ",
                                                      skills: profileData
                                                          .allSkills);

                                              UserUpdateRequestModel
                                                  userUpdateRequestModel =
                                                  UserUpdateRequestModel(
                                                      certificationsRequestDtos:
                                                          null,
                                                      educationRequestDtos:
                                                          null,
                                                      experienceRequestDtos:
                                                          null,
                                                      profileUpdateRequestDto:
                                                          profileUpdateRequestDto);
                                              await FileUploadService()
                                                  .deleteSingleFile(
                                                      profileData.profilePic!);
                                              await JobPostApiService
                                                  .PostUserInfo(
                                                userUpdateRequestModel,
                                              );
                                              ref.refresh(ProfileDataProvider);
                                              ref.refresh(
                                                  profileSummaryProvider);
                                              ref.refresh(PartnerProfileData);
                                              Future.delayed(
                                                  const Duration(seconds: 5));
                                              setState(() {
                                                isLoading = false;
                                              });
                                              /*  setState(() async {
                                                var data = await Delete(
                                                    profileData.profilePic
                                                        .toString());
                                                var payload = {
                                                  "stage": "profile_pic",
                                                  "data": {
                                                    "id": await Utils
                                                        .getPreferencesValue(
                                                            null,
                                                            ESharedPreferences
                                                                .user_id.name),
                                                    "profile_pic": null
                                                  }
                                                };
                                                await save(data, payload);
                                                ref.refresh(
                                                    ProfileDataProvider);
                                                ref.refresh(
                                                    profileSummaryProvider);

                                                //  Navigator.pop(context);
                                                if (data != null) {
                                                  setState(() {
                                                    icon_data = null;
                                                  });
                                                }
                                                Navigator.pop(context);
                                              }); */
                                            },
                                            icon: Image.asset(
                                              "assets/images/bin.gif",
                                              height: 40,
                                            )),
                                      )
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
                        backgroundImage: profileData.profilePic != null &&
                                profileData.profilePic != " "
                            ?
                            // ignore: unnecessary_null_comparison
                            Image.network(
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${profileData.profilePic}")
                                .image
                            : Image.asset(
                                profileData.gender != "Female"
                                    ? "assets/images/leadmale.png"
                                    : "assets/images/leadfemal.png",
                                // height: 8.h,
                              ).image),
                  ),
                  Positioned(
                    right: width / 160,
                    bottom: height / 85,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        var data1 = await fileUploader.uploadFile(
                            context, ['jpeg', 'jpg', "png"], "profile_pic");
                        setState(() {
                          isLoading = false;
                        });
                        /*  resume = await uploadFile(['pdf'], "cv", profileData.cv_ink); */

                        if (data1 != null) {
                          setState(() {
                            isLoading = true;
                          });
                          ProfileUpdateRequestDto profileUpdateRequestDto =
                              ProfileUpdateRequestDto(
                                  id: profileData.id,
                                  profilePic: data1.toString(),
                                  skills: profileData.allSkills);

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
                          ref.refresh(ProfileDataProvider);
                          ref.refresh(profileSummaryProvider);
                          setState(() {
                            isLoading = false;
                          });
                        }
                        /* setState(() async {
                          var data1 = await uploadFile(['jpeg', 'jpg', "png"],
                              "icon", profileData.profilePic);
                          var payload = {
                            "stage": "profile_pic",
                            "data": {
                              "id": await Utils.getPreferencesValue(
                                  null, ESharedPreferences.user_id.name),
                              "profile_pic": data1
                            }
                          };
                          await save(data1, payload);

                          icon_data = data1;
                          ref.refresh(ProfileDataProvider);
                          ref.refresh(profileSummaryProvider);
                          //  Navigator.pop(context);
                        }); */
                      },
                      child: const CircleAvatar(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    customTextForWeather(
                      title:
                          "${profileData.firstName.toString().toTitleCase()} ${profileData.lastName.toString().toTitleCase()}",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: /* Text(
                            profileData.profileHeadline != null &&
                                    profileData.profileHeadline != ""
                                ? "${profileData.profileHeadline}"
                                : profileData.experiences!.isNotEmpty
                                    ? "${profileData.experiences!.first.jobTitle.toString()} at ${profileData.experiences!.first.companyName}"
                                    : "${profileData.educationDetails?.first.degree_spc.toString()} from ${profileData.educationDetails?.first.university != null ? profileData.educationDetails?.first.university.toString() : profileData.educationDetails?.first.board}",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 3,
                            style: GoogleFonts.merriweather(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ), */
                                profileData.educationDetails!.isNotEmpty
                                    ? customTextForSignika(
                                        title: profileData.profileHeadline !=
                                                    null &&
                                                profileData.profileHeadline !=
                                                    "" &&
                                                profileData.profileHeadline !=
                                                    "null"
                                            ? "${profileData.profileHeadline}"
                                            : profileData
                                                    .experiences!.isNotEmpty
                                                ? "${profileData.experiences!.first.jobTitle.toString()} at ${profileData.experiences!.first.companyName}"
                                                : profileData.educationDetails!
                                                        .isNotEmpty
                                                    ? "${profileData.educationDetails?.first.degree_spc.toString()} from ${profileData.educationDetails?.first.university != null ? profileData.educationDetails?.first.university.toString() : profileData.educationDetails?.first.board}"
                                                    : "",
                                        softwrap: true,
                                        maxlines: 3,
                                        textAlign: TextAlign.center,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )
                                    : const SizedBox()),
                      ],
                    ),
                    customTextForMonst(
                      title:
                          ' ${capitalizeFirstLetter(formatLocality(profileData.userLocality.toString()))}',
                      softwrap: true,
                      maxlines: 3,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Constants.subtitleclr,
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Screen1(
                                profileskill: profileData.allSkills!,
                                userid: profileData.id!,
                                prevPageModel: profileData,
                                isbio: false,
                                isfirst: false,
                                primaryNumberValue:
                                    profileData.mobile.toString(),
                              )));
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    "assets/images/edit_user.png",
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar customAppBar(double height, ProfileModel data) {
    return AppBar(
        leadingWidth: 25,
        titleSpacing: 10,
        /* actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: const Icon(
              Icons.notifications,
              color: Constants.themeBgColor,
            ),
          )
        ], */
        //  automaticallyImplyLeading: true,

        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 4, left: 6),
          child: SizedBox(
            //margin: const EdgeInsets.only(right: 20),
            height: height / 26,
            // width: width / 1.10.w,
            child: TextField(
                style: GoogleFonts.merriweather(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusColor: Colors.grey.shade400,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    filled: true,
                    /*  prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ), */
                    contentPadding: const EdgeInsets.only(left: 5, top: 10),
                    hintText:
                        "${capitalizeFirstLetter(data.firstName)} ${capitalizeFirstLetter(data.lastName)}",
                    hintStyle: GoogleFonts.merriweather(
                      color: Colors.grey.shade400,
                    ))),
          ),
        ));
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  String formatLocality(String locality) {
    // Split the string by comma
    List<String> parts = locality.split(',');

    if (parts.length >= 2) {
      // Trim any leading or trailing spaces/tabs from both parts
      String part1 = parts[0].trim();
      String part2 = parts[1].trim();

      // Combine the parts with a single space after the comma
      return '$part1, $part2';
    }

    // If there's no comma, return the original string
    return locality;
  }

  //
  //
  //
  //
  //
}
