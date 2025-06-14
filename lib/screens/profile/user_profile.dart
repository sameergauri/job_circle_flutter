// ignore_for_file: unused_result, unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customRow.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/add_space_between_location.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/customtextwithviewmoreoption.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/add_profile_summary.dart';
import 'package:job_circle/screens/profile/certifcate.dart';
import 'package:job_circle/screens/profile/certificate_list.dart';
import 'package:job_circle/screens/profile/education_list.dart';
import 'package:job_circle/screens/profile/experience_list.dart';
import 'package:job_circle/screens/profile/screen1.dart';
import 'package:job_circle/screens/profile/screen2.dart';
import 'package:job_circle/screens/profile/screen3.dart';
import 'package:job_circle/screens/profile/screen5.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ProfileDataProvider = FutureProvider<ProfileModel>((ref) async {
  //ref.watch(profileSummaryProvider);
  return _UserProfileState.bindProfileSummary();
});

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

String? resume;
String? icon_data;

final _refreshControllers = RefreshController(initialRefresh: false);

class _UserProfileState extends ConsumerState<UserProfile> {
  FileUploader fileUploader = FileUploader();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final userProfileData = ref.watch(ProfileDataProvider);
    return userProfileData.when(data: (profileData) {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton:
                profileData.resume != null && profileData.resume != " "
                    ? customFloatingButton(context, profileData)
                    : const SizedBox(),
            appBar: customAppBar(height, profileData),
            body: SmartRefresher(
              controller: _refreshControllers,
              physics: const BouncingScrollPhysics(),
              onRefresh: () {
                ref.refresh(ProfileDataProvider);
                _refreshControllers.refreshCompleted();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    customContainerforBasicInfo(
                        profileData, context, height, width),
                    if (profileData.resume == null ||
                        profileData.resume == " " ||
                        profileData.allSkills!.isEmpty ||
                        profileData.bio == null ||
                        profileData.profilePic == " " ||
                        profileData.profilePic == null ||
                        profileData.bio == " " ||
                        profileData.bio == "" ||
                        profileData.bio == "null")
                      customMissingInfo(profileData),
                    if (profileData.bio != null &&
                        profileData.bio != " " &&
                        profileData.bio != "null" &&
                        (profileData.resume != null &&
                            profileData.resume != " " &&
                            profileData.allSkills!.isNotEmpty &&
                            profileData.bio != null &&
                            profileData.profilePic != " " &&
                            profileData.profilePic != null &&
                            profileData.bio != " " &&
                            profileData.bio != "null"))
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Constants.dividercolor,
                          thickness: 6,
                        ),
                      ),
                    if (profileData.bio != null &&
                        profileData.bio != " " &&
                        profileData.bio != "" &&
                        profileData.bio != "null")
                      customContainerforSummary(profileData),
                    if (profileData.bio != null &&
                        profileData.bio != " " &&
                        profileData.bio != "null" &&
                        profileData.bio != "")
                      const Divider(
                        color: Constants.dividercolor,
                        thickness: 6,
                      ),
                    customcontainerForExperience(profileData),
                    const Divider(
                      color: Constants.dividercolor,
                      thickness: 6,
                    ),
                    customcontainerForEducation(profileData),
                    const Divider(
                      color: Constants.dividercolor,
                      thickness: 6,
                    ),
                    customcontainerForcertification(profileData),
                    if (profileData.allSkills != null &&
                        profileData.allSkills != "" &&
                        profileData.allSkills != [])
                      const Divider(
                        color: Constants.dividercolor,
                        thickness: 6,
                      ),
                    if (profileData.allSkills != null &&
                        profileData.allSkills != "" &&
                        profileData.allSkills != [])
                      customcontainerForSkills(profileData),
                    const Divider(
                      color: Constants.dividercolor,
                      thickness: 6,
                    ),
                    customcontainerForLanguageKnown(profileData),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Divider(
                            color: Constants.borderColor,
                            thickness: 6.w,
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
    }, error: (error, stackTrace) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Constants.themeBgColor,
          ),
        ),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Constants.themeBgColor,
          ),
        ),
      );
    });
  }

  // TODO:: Custom and api fetch function....
  //
  //
  //
  //
  //
  static Future<ProfileModel> bindProfileSummary() async {
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

  Container customMissingInfo(ProfileModel profileData) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      // height: MediaQuery.of(context).size.height / 7.2,
      width: double.maxFinite,

      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(15),
        color: Constants.borderColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (profileData.resume == null || profileData.resume == " ")
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4.0),
                child: CustomFieldBlock(
                  height: MediaQuery.of(context).size.height / 8,
                  iconColor: const Color.fromRGBO(37, 150, 190, 0),
                  imageUrl: "assets/images/resume.png",
                  description: "Never skip adding your resume.",
                  buttonText: "+ Add Resume",
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    resume = await fileUploader.uploadFile(
                        context, ['pdf'], "resume");
                    setState(() {});
                    /*  resume = await uploadFile(['pdf'], "cv", profileData.cv_ink); */

                    if (resume != null) {
                      ProfileUpdateRequestDto profileUpdateRequestDto =
                          ProfileUpdateRequestDto(
                              id: profileData.id,
                              cvLink: resume.toString(),
                              skills: profileData.allSkills);

                      UserUpdateRequestModel userUpdateRequestModel =
                          UserUpdateRequestModel(
                              certificationsRequestDtos: null,
                              educationRequestDtos: null,
                              experienceRequestDtos: null,
                              profileUpdateRequestDto: profileUpdateRequestDto);

                      await JobPostApiService.PostUserInfo(
                        userUpdateRequestModel,
                      );
                      ref.refresh(ProfileDataProvider);
                      Future.delayed(const Duration(seconds: 10));
                      setState(() {
                        isLoading = false;
                      });
                    }

                    /* var data = await uploadFile(
                                                      'pdf', "icon");
                                                  if (data != null) {
                                                    setState(() {
                                                      icon_data = data;
                                                    });
                                                  } */
                  },
                ),
              ),
            if (profileData.profilePic == null || profileData.profilePic == " ")
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4.0),
                child: CustomFieldBlock(
                  height: MediaQuery.of(context).size.height / 8,
                  imageUrl: profileData.gender == "Female"
                      ? "assets/images/leadfemal.png"
                      : "assets/images/leadmale.png",
                  description: "A profile photo boosts credibility.",
                  buttonText: "+ Add Profile Pic",
                  onPressed: () async {
                    var profilepic = await fileUploader.uploadFile(
                        context, ['jpeg', 'jpg', "png"], "icon");
                    setState(() {});
                    if (profilepic != null) {
                      ProfileUpdateRequestDto profileUpdateRequestDto =
                          ProfileUpdateRequestDto(
                        id: profileData.id,
                        skills: profileData.allSkills,
                        profilePic: profilepic.toString(),
                      );

                      UserUpdateRequestModel userUpdateRequestModel =
                          UserUpdateRequestModel(
                              certificationsRequestDtos: null,
                              educationRequestDtos: null,
                              experienceRequestDtos: null,
                              profileUpdateRequestDto: profileUpdateRequestDto);

                      await JobPostApiService.PostUserInfo(
                        userUpdateRequestModel,
                      );
                      ref.refresh(ProfileDataProvider);
                      ref.refresh(profileSummaryProvider);
                    }

                    /*  setState(() async {
                  var data1 = await uploadFile(
                      ['jpeg', 'jpg', "png"], "icon", profileData.profilePic);
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
                  //  Navigator.pop(context);
                }); */
                  },
                ),
              ),
            if (profileData.allSkills!.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4.0),
                child: CustomFieldBlock(
                  height: MediaQuery.of(context).size.height / 8,
                  imageUrl: "assets/images/stars.png",
                  description: "Skills that showcase your expertise",
                  buttonText: "+ Add Skill",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SkillsMulti(
                                  isEdit: false,
                                  Skill: const [],
                                  userid: profileData.id!,
                                )));
                  },
                ),
              ),
            if (profileData.bio == null ||
                profileData.bio == " " ||
                profileData.bio == "" ||
                profileData.bio == "null")
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4.0),
                child: CustomFieldBlock(
                  height: MediaQuery.of(context).size.height / 8,
                  imageUrl: "assets/images/write.png",
                  description: "Stand out with strong summary.",
                  buttonText: "+ Add Summary",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProfileSummary(
                                  profileskill: profileData.allSkills!,
                                  userid: profileData.id!,
                                  isEdit: false,
                                  summaryData: "",
                                )));
                    setState(() {});
                  },
                ),
              ),
            /*  if (profileData.certifications!.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4.0),
            child: CustomFieldBlock(
              imageUrl: "assets/images/certifcate.png",
              description:
                  "Share your Certificate details to maximize your potential",
              buttonText: "+ Add Certificate",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SkillsMulti(
                              Skill: const [],
                              userid: profileData.id!,
                            )));
              },
            ),
          ), */
          ],
        ),
      ),
    );
  }

  Container customcontainerForLanguageKnown(ProfileModel profileData) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Constants.borderColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Image.network(
                  'https://assets.api.uizard.io/api/cdn/stream/0b61b3c1-890b-4231-9349-ba85ac765701.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const customTextForWeather(
                title: "Language Known",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (profileData.languagesKnown == null)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Screen1(
                                            profileskill:
                                                profileData.allSkills!,
                                            userid: profileData.id!,
                                            isbio: false,
                                            isfirst: false,
                                            prevPageModel: profileData,
                                          ) /* LanguageMulti(
                                            languageList:
                                                profileData.languagesKnown!,
                                            userid: profileData.id!,
                                          ) */
                                      ));
                              setState(() {});
                            },
                            child: Container(
                              // child: Icon(Icons.add, size: 18.h),
                              child: Icon(
                                Icons.add,
                                color: Constants
                                    .subtitleclr, // Replace this with the icon of your choice
                                size: 20
                                    .h, // Replace this with the size of the icon
                                // color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        if (profileData.languagesKnown != null)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Screen1(
                                            profileskill:
                                                profileData.allSkills!,
                                            userid: profileData.id!,
                                            isbio: false,
                                            isfirst: false,
                                            prevPageModel: profileData,
                                            primaryNumberValue:
                                                profileData.mobile.toString(),
                                          ) /* LanguageMulti(
                                            languageList:
                                                profileData.languagesKnown!,
                                            userid: profileData.id!,
                                          ) */
                                      ));
                              setState(() {});
                            },
                            child: Container(
                              // child: Icon(Icons.add, size: 18.h),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Constants
                                    .subtitleclr, // Replace this with the icon of your choice
                                size: 20
                                    .h, // Replace this with the size of the icon
                                // color: Colors.greenAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*   Divider(
            color: Constants.borderColor,
            thickness: 2.w,
          ), */
          Wrap(
            spacing: 3, // Adjust the spacing between the skills chips
            runSpacing: 0.0, // Remove the spacing between the rows of chips
            children: profileData.languagesKnown!.asMap().entries.map((entry) {
              final index = entry.key;
              final skill = entry.value;

              // if (index < 12) {
              return Container(
                margin: EdgeInsets.only(top: 10, right: 4.w, left: 5),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: Constants.lightdull,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: customTextForWeather(
                  title: skill,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              );
              /*  } else if (index == 12) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const customTextForAll(
                      title: 'View More',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              }
              return const SizedBox();  */ // Return an empty container for the remaining items
            }).toList(),
          ),
        ],
      ),
    );
  }

  Container customcontainerForSkills(ProfileModel profileData) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Constants.borderColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Image.network(
                  'https://assets.api.uizard.io/api/cdn/stream/a8ac9b17-39f2-4c95-a432-2d18cd35abd4.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const customTextForWeather(
                title: "Skills",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (profileData.allSkills!.isEmpty)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SkillsMulti(
                                      isEdit: false,
                                      Skill: profileData.allSkills!,
                                      userid: profileData.id!,
                                    ),
                                  ));
                            },
                            child: Container(
                              child: Icon(
                                Icons.add,
                                color: Constants
                                    .subtitleclr, // Replace this with the icon of your choice
                                size: 20
                                    .h, // Replace this with the size of the icon
                                // color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        if (profileData.allSkills!.isNotEmpty)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SkillsMulti(
                                      isEdit: true,
                                      Skill: profileData.allSkills!,
                                      userid: profileData.id!,
                                    ),
                                  ));
                              setState(() {});
                            },
                            child: Container(
                              child: Icon(
                                Icons.edit_outlined,
                                color: Constants
                                    .subtitleclr, // Replace this with the icon of your choice
                                size: 20
                                    .h, // Replace this with the size of the icon
                                // color: Colors.greenAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*  Divider(
            color: Constants.borderColor,
            thickness: 2.w,
          ), */
          profileData.allSkills!.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(left: 6, top: 10),
                  child: const customTextForWeather(
                      title: "Add skills that best define your experties.",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue),
                )
              : Wrap(
                  spacing: 3, // Adjust the spacing between the skills chips
                  runSpacing:
                      0.0, // Remove the spacing between the rows of chips
                  children: profileData.allSkills!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final skill = entry.value;

                    // if (index < 12) {
                    return Container(
                      margin: EdgeInsets.only(top: 10, right: 4.w, left: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Constants.lightdull,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: customTextForWeather(
                        title: skill,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                    /*  } else if (index == 12) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5, top: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const customTextForAll(
                            title: 'View More',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();  */ // Return an empty container for the remaining items
                  }).toList(),
                ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  bool isLoading = false;

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
                                          radius: height / 6.r,
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
                                              ref
                                                  .read(
                                                      jobListProvider.notifier)
                                                  .fetchInitialJobs();
                                              ref.refresh(ProfileDataProvider);
                                              ref.refresh(
                                                  profileSummaryProvider);

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
                                              height: 40.h,
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
                    right: width / 160.w,
                    bottom: height / 85.h,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        var data1 = await fileUploader.uploadFile(
                            context, ['jpeg', 'jpg', "png"], "profile_pic");
                        setState(() {});
                        /*  resume = await uploadFile(['pdf'], "cv", profileData.cv_ink); */
                        setState(() {
                          isLoading = false;
                        });
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
                          ref.read(jobListProvider.notifier).fetchInitialJobs();
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
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 8.r,
                          child: Icon(
                            Icons.add_circle_outlined,
                            size: 15.h,
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
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18.h,
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
                    height: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container customcontainerForcertification(ProfileModel profileData) {
    Map<String, int> monthMap = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12
    };
    profileData.certifications!.sort((a, b) {
      // Ensure startYear is a String before parsing it to an int
      var yearA = int.tryParse(a.startYear?.toString() ?? '0') ?? 0;
      var yearB = int.tryParse(b.startYear?.toString() ?? '0') ?? 0;

      // If years are the same, compare the startMonth
      if (yearA == yearB) {
        // Use the monthMap to convert month names to numbers
        var monthA = monthMap[a.startMonth?.toString() ?? 'January'] ?? 1;
        var monthB = monthMap[b.startMonth?.toString() ?? 'January'] ?? 1;
        return monthB.compareTo(monthA); // Descending order for month
      } else {
        return yearB.compareTo(yearA); // Descending order for year
      }
    });

    /*  profileData.certifications!.sort((a, b) {
      var endDateA = a.startYear ?? 0;
      var endDateB = b.startYear ?? 0;
      return endDateB.compareTo(endDateA);
    }); */
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Constants.borderColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Image.network(
                  'https://assets.api.uizard.io/api/cdn/stream/eed8017f-a011-413a-9126-fd97ca0a1eab.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const customTextForWeather(
                title: "Certifications",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CertificateEdit(
                                          profileskill: profileData.allSkills!,
                                          userid: profileData.id!,
                                          certlength: 1,
                                          isEdit: false,
                                          isFirst: true,
                                        )));
                          },
                          child: Container(
                            child: Icon(
                              Icons.add,
                              color: Constants
                                  .subtitleclr, // Replace this with the icon of your choice
                              size: 20
                                  .h, // Replace this with the size of the icon
                              // color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        if (profileData.certifications != null &&
                            profileData.certifications!.isNotEmpty)
                          const SizedBox(
                            width: 8,
                          ),
                        if (profileData.certifications != null &&
                            profileData.certifications!.isNotEmpty)
                          InkWell(
                            onTap: () {
                              if (profileData.certifications!.length != 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CertificateList(
                                              profileskill:
                                                  profileData.allSkills!,
                                              userid: profileData.id!,
                                              certificateList:
                                                  profileData.certifications,
                                            )));
                                setState(() {});
                              }
                              if (profileData.certifications!.length == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CertificateEdit(
                                              profileskill:
                                                  profileData.allSkills!,
                                              userid: profileData.id!,
                                              certlength: profileData
                                                  .certifications!.length,
                                              isEdit: true,
                                              isFirst: false,
                                              prevPageModel: profileData
                                                  .certifications!.first,
                                            )));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 14),
                              // child: Icon(Icons.add, size: 18.h),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Constants
                                    .subtitleclr, // Replace this with the icon of your choice
                                size: 20
                                    .h, // Replace this with the size of the icon
                                // color: Colors.greenAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*   Divider(
            color: Constants.borderColor,
            thickness: 2.w,
          ), */
          profileData.certifications!.isEmpty
              ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 6, top: 10),
                      child: const customTextForWeather(
                          title: "Add your certification detail.",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )
              : Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profileData.certifications!.length,
                    itemBuilder: (context, index) {
                      var data = profileData.certifications;

                      return Column(
                        children: [
                          ListTile(
                            onTap: () {},
                            contentPadding: const EdgeInsets.only(
                                left: 4, right: 10, top: 0, bottom: 0),
                            leading: SizedBox(
                                width: 70.w,
                                height: 70.h,
                                child: data![index].certLogo != null
                                    ? Image.network(
                                        "${GlobalConstants.Image_url}${data[index].certLogo.toString()}",
                                        fit: BoxFit.contain,
                                        // color: Constants.themeBgColor,
                                      )
                                    : Image.asset(
                                        "assets/images/certificate.png",
                                        fit: BoxFit.contain,
                                      )),
                            title: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextForWeather(
                                    title: data[index]
                                        .certificationName
                                        .toString()
                                        .toTitleCase(),
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  customTextForMonst(
                                    title: data[index]
                                        .issuingOrganization
                                        .toString(),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            subtitle: customTextForMonst(
                              title:
                                  "${data[index].startMonth.toString()} - ${data[index].startYear.toString()}",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Constants.subtitleclr,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (index != data.length - 1)
                            const Divider(
                              thickness: 1.0,
                            )
                        ],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Container customcontainerForEducation(ProfileModel profileData) {
    profileData.educationDetails!.sort((a, b) {
      // Check if 'present' is in the end of the education period
      var isPresentA = a.educationPeriod!.toLowerCase().contains('present');
      var isPresentB = b.educationPeriod!.toLowerCase().contains('present');

      // If A is present but B is not, A should come first
      if (isPresentA && !isPresentB) return -1;
      // If B is present but A is not, B should come first
      if (!isPresentA && isPresentB) return 1;

      // If both are present or both are not present, sort by end year
      var endDateA = int.tryParse(a.educationPeriod!.split(' - ').last) ?? 0;
      var endDateB = int.tryParse(b.educationPeriod!.split(' - ').last) ?? 0;

      // Sort in descending order (latest date first)
      return endDateB.compareTo(endDateA);
    });
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Constants.borderColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Image.network(
                  'https://assets.api.uizard.io/api/cdn/stream/82f1da0d-aab3-4275-a9f8-d413bf45f63f.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),

              // Check if the icon is not null

              const customTextForWeather(
                title: "Education",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Screen2(
                                          userid: profileData.id!,
                                          profileskill: profileData.allSkills!,
                                          edulength: 1,
                                          isEdit: false,
                                          isFirst: true,
                                          underGraduate: false,
                                        )));
                            setState(() {});
                          },
                          child: Container(
                            child: Icon(
                              Icons.add,
                              color: Constants
                                  .subtitleclr, // Replace this with the icon of your choice
                              size: 20
                                  .h, // Replace this with the size of the icon
                              // color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        if (profileData.educationDetails != null &&
                            profileData.educationDetails!.isNotEmpty)
                          InkWell(
                            onTap: () {
                              if (profileData.educationDetails!.length != 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EducationList(
                                              userid: profileData.id!,
                                              profileskill:
                                                  profileData.allSkills!,
                                              educationList:
                                                  profileData.educationDetails,
                                            )));
                                setState(() {});
                              }
                              if (profileData.educationDetails!.length == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Screen2(
                                              userid: profileData.id!,
                                              profileskill:
                                                  profileData.allSkills!,
                                              edulength: profileData
                                                  .educationDetails!.length,
                                              underGraduate: false,
                                              isEdit: true,
                                              isFirst: false,
                                              prevPageModel: profileData
                                                  .educationDetails!.first,
                                            )));
                                setState(() {});
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 14),
                              // child: Icon(Icons.add, size: 18.h),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Constants
                                    .subtitleclr, // Replace this with the icon of your choice
                                size: 20
                                    .h, // Replace this with the size of the icon
                                // color: Colors.greenAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*  Divider(
            color: Constants.borderColor,
            thickness: 2.w,
          ), */
          profileData.educationDetails!.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  child: const Column(
                    children: [
                      customTextForWeather(
                          title: "Add your education detail.",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profileData.educationDetails!.length,
                    itemBuilder: (context, index) {
                      var data = profileData.educationDetails;

                      // if (data != null) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {},
                            contentPadding: const EdgeInsets.only(
                                left: 4, right: 10, top: 0, bottom: 0),
                            leading: SizedBox(
                                width: 70.w,
                                height: 70.h,
                                child: data![index].icon != null
                                    ? Image.network(
                                        "${GlobalConstants.Image_url}${data[index].icon.toString()}",
                                        fit: BoxFit.contain,
                                        // color: Constants.themeBgColor,
                                      )
                                    : Image.asset(
                                        "assets/images/education_d.png",
                                        fit: BoxFit.contain,
                                        color: Constants.subtitleclr,
                                      )),
                            title: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextForWeather(
                                    title:
                                        "${data[index].degree_spc.toString()} in ${data[index].fieldOfStudy.toString()}",
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  customTextForMonst(
                                    title: data[index].university.toString(),
                                    fontSize: 12,
                                    softwrap: true,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            subtitle: customTextForMonst(
                              title: data[index].educationPeriod.toString(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Constants.subtitleclr,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (index != data.length - 1)
                            const Divider(
                              thickness: 1.0,
                            )
                        ],
                      );
                      /* else {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              contentPadding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 0, bottom: 0),
                              leading: SizedBox(
                                  width: 70.w,
                                  height: 70.h,
                                  child: Image.asset(
                                    "assets/images/education_d.png",
                                    fit: BoxFit.contain,
                                  )),
                              title: Row(
                                children: [
                                  CustomTextForAll(
                                    "Add Your Education Detail.",
                                    style: GoogleFonts.varela(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } */
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget customContainerforSummary(ProfileModel profileData) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: EdgeInsets.only(
        left: 10.w,
        right: 8.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Constants.borderColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Image.asset(
                  "assets/images/summary.png",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const customTextForWeather(
                title: "Summary",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddProfileSummary(
                                          profileskill: profileData.allSkills!,
                                          userid: profileData.id!,
                                          summaryData:
                                              profileData.bio.toString(),
                                          isEdit: true,
                                        )));
                            setState(() {});
                          },
                          child: Container(
                            child: Icon(
                              Icons.edit_outlined,
                              color: Constants
                                  .subtitleclr, // Replace this with the icon of your choice
                              size: 20
                                  .h, // Replace this with the size of the icon
                              // color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*  Divider(
            color: Constants.borderColor,
            thickness: 2.w,
          ), */
          const SizedBox(
            height: 10,
          ),
          Container(
            padding:
                const EdgeInsets.only(right: 4, top: 4, bottom: 4, left: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r), color: Colors.white),
            child: ExpandableTextWidget(
              key: ValueKey(DateTime.now().millisecondsSinceEpoch),
              initialMaxLines: 5,
              text: (profileData.bio.toString()),
            ),
          ),
          /*  Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ExpandableTextWidget(
                text: profileData.bio.toString(),
                initialMaxLines: 4,
              )), */
        ],
      ),
    );
  }

  Container customcontainerForExperience(ProfileModel profileData) {
    profileData.experiences!.sort((a, b) {
      // Convert working periods to lowercase for case-insensitive comparison
      var workingPeriodA = a.workingPeriod!.toLowerCase();
      var workingPeriodB = b.workingPeriod!.toLowerCase();

      // Check if 'Present' is mentioned
      var isPresentA = workingPeriodA.contains('present');
      var isPresentB = workingPeriodB.contains('present');

      // If A is present but B is not, A should come first
      if (isPresentA && !isPresentB) return -1;
      // If B is present but A is not, B should come first
      if (!isPresentA && isPresentB) return 1;

      // If both are present or both are not present, sort by end year
      int extractYear(String period) {
        // Extract last part (end date) safely
        var parts = period.split(' - ');
        if (parts.length < 2) return 0; // Fallback in case of unexpected format

        // Extract the year safely
        var lastPart = parts.last; // "Jul 2014, 4 months" or "Present"
        var yearMatch = RegExp(r'\b\d{4}\b').firstMatch(lastPart);

        return yearMatch != null ? int.parse(yearMatch.group(0)!) : 0;
      }

      var endDateA = extractYear(a.workingPeriod!);
      var endDateB = extractYear(b.workingPeriod!);

      // Sort in descending order (latest date first)
      return endDateB.compareTo(endDateA);
    });

    return Container(
      // padding: const EdgeInsets.only(),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Constants.borderColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Image.asset(
                  "assets/images/exp_bag.png",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),

              // Check if the icon is not null

              const customTextForWeather(
                title: "Experience",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Screen3(
                                          userid: profileData.id!,
                                          expelength:
                                              profileData.experiences!.length,
                                          skills: profileData.allSkills!,
                                          profileHeadline:
                                              profileData.profileHeadline,
                                          isFirst: true,
                                          isEdit: false,
                                        )));
                            setState(() {});
                          },
                          child: Container(
                            child: Icon(
                              Icons.add,
                              color: Constants
                                  .subtitleclr, // Replace this with the icon of your choice
                              size: 20
                                  .h, // Replace this with the size of the icon
                              // color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        if (profileData.experiences!.isNotEmpty)
                          InkWell(
                            onTap: () {
                              if (profileData.experiences!.length == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Screen3(
                                              userid: profileData.id!,
                                              skills: profileData.allSkills!,
                                              expelength: profileData
                                                  .experiences!.length,
                                              profileHeadline:
                                                  profileData.profileHeadline,
                                              isFirst: false,
                                              isEdit: true,
                                              prevPageModel: profileData
                                                  .experiences?.first,
                                              experiencelist:
                                                  profileData.experiences,
                                            )));
                                setState(() {});
                              }
                              if (profileData.experiences!.length != 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ExperienceListEdit(
                                              userid: profileData.id!,
                                              profileHeadline: profileData
                                                  .profileHeadline
                                                  .toString(),
                                              skills: profileData.allSkills!,
                                              experiencelist:
                                                  profileData.experiences,
                                            )));
                                setState(() {});
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 14),

                              // child: Icon(Icons.add, size: 18.h),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Constants
                                    .subtitleclr, // Replace this with the icon of your choice
                                size: 20
                                    .h, // Replace this with the size of the icon
                                // color: Colors.greenAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*   Divider(
            color: Constants.borderColor,
            thickness: 2.w,
          ), */
          profileData.experiences!.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  child: const Column(
                    children: [
                      customTextForWeather(
                          title: "Fresher.",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profileData.experiences!.length,
                    itemBuilder: (context, index) {
                      var data = profileData.experiences;

                      if (data != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: () {},
                              contentPadding: const EdgeInsets.only(
                                  left: 4, right: 10, top: 0, bottom: 0),
                              leading: SizedBox(
                                  width: 70.w,
                                  height: 70.h,
                                  child: data[index].companyLogo != null
                                      ? Image.network(
                                          "${GlobalConstants.Image_url}${data[index].companyLogo.toString()}",
                                          fit: BoxFit.contain,
                                          // color: Constants.themeBgColor,
                                        )
                                      : Image.asset(
                                          "assets/images/cmpny.png",
                                          fit: BoxFit.contain,
                                          color: Constants.subtitleclr,
                                        )),
                              title: Padding(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextForWeather(
                                      title: data[index].jobTitle.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    customTextForMonst(
                                      title:
                                          "${data[index].companyName.toString()} - ${data[index].empType.toString()}",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextForMonst(
                                    title: data[index]
                                        .workingPeriod!
                                        .split(',')
                                        .map((part) =>
                                            part.trim()) // Trim extra spaces
                                        .toList() // Convert map to list
                                        .asMap() // Convert list to map with index
                                        .map((i, part) {
                                          if (i == 1) {
                                            // Check if it's the part after comma
                                            return MapEntry(i,
                                                '($part)'); // Wrap in parentheses
                                          }
                                          return MapEntry(
                                              i, part); // Keep as is
                                        })
                                        .values
                                        .join(' '),
                                    /*  data[index]
                                        .workingPeriod!
                                        .replaceAll(',', '')
                                        .toString(), */
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Constants.subtitleclr,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  customTextForMonst(
                                    title: AddSpaceBetween.capitalizeWords(
                                      data[index].jobLocation.toString(),
                                    ),
                                    color: Constants.subtitleclr,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            /*  if (data[index].jobRole != null &&
                                data[index].jobRole != "")
                              SizedBox(
                                height: 4.h,
                              ), */
                            if (data[index].jobRole != null &&
                                data[index].jobRole != "")
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 4, right: 4, top: 4, bottom: 4),
                                margin: const EdgeInsets.only(
                                    top: 4, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Constants.lightdull),
                                child: ExpandableTextWidget(
                                  initialMaxLines: 5,
                                  text: addBulletPoints(data[index].jobRole!),
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (index != data.length - 1)
                              const Divider(
                                thickness: 1.0,
                              )
                            /*  Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 4.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Constants.lightdull),
                                child: CustomTextForAll(
                                  addBulletPoints(data[index].jobRole!),
                                  style: GoogleFonts.varela(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ), */
                            /*   if (data[index].jobRole != null &&
                                data[index].jobRole != "")
                              SizedBox(
                                height: 4.h,
                              ), */
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              contentPadding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 0, bottom: 0),
                              leading: SizedBox(
                                  width: 70.w,
                                  height: 70.h,
                                  child: Image.asset(
                                    "assets/images/cmpny.png",
                                    fit: BoxFit.contain,
                                  )),
                              subtitle: Row(
                                children: [
                                  customTextForAll(
                                      title: "Add your experience detail.",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  String addBulletPoints(String input) {
    // Split the text into lines, then add bullet points to each line.
    return input.split('\n').map((line) {
      return '• ${line.trim()}'; // Add bullet point to each line, trimming excess spaces
    }).join('\n'); // Join the lines back into a single string
  }

  String cleanLocation(String location) {
    List<String> parts = location.split(",").map((e) => e.trim()).toList();
    List<String> uniqueParts = [];

    for (String part in parts) {
      if (!uniqueParts.contains(part)) {
        uniqueParts.add(part);
      }
    }

    return uniqueParts.join(", ");
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
          padding: EdgeInsets.only(right: 4.w, left: 6.w),
          child: SizedBox(
            //margin: const EdgeInsets.only(right: 20),
            height: height / 26.h,
            // width: width / 1.10.w,
            child: TextField(
                style: GoogleFonts.merriweather(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusColor: Colors.grey.shade400,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
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
                        color: Constants.subtitleclr, fontSize: 12))),
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

  /*  Future<String?> Delete(String url) async {
    try {
      var res = 
    } catch (e) {
      // Close the loading dialog in case of exceptions
      Navigator.pop(context);

      // Handle any exceptions that occur during the upload
      print("Error during file upload: $e");
      return null;
    }
    return null;
  } */

  /* save(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      return print("Save");
    }
    setState(() {});
  } */

  FloatingActionButton customFloatingButton(
      BuildContext context, ProfileModel data) {
    return FloatingActionButton(
      backgroundColor: Constants.bgColorWhite,
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return CustomPDFViewerDialog(
              pdfUrl:
                  "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.resume}",
              onRemove: () async {
                await FileUploadService().deleteSingleFile(data.resume!);
                setState(() {
                  isLoading = true;
                });

                setState(() {
                  resume = " ";
                });
                if (resume == null || resume == " ") {
                  ProfileUpdateRequestDto profileUpdateRequestDto =
                      ProfileUpdateRequestDto(
                          id: data.id, cvLink: resume, skills: data.allSkills);

                  UserUpdateRequestModel userUpdateRequestModel =
                      UserUpdateRequestModel(
                          certificationsRequestDtos: null,
                          educationRequestDtos: null,
                          experienceRequestDtos: null,
                          profileUpdateRequestDto: profileUpdateRequestDto);

                  await JobPostApiService.PostUserInfo(
                    userUpdateRequestModel,
                  );
                  ref.refresh(ProfileDataProvider);
                  Future.delayed(const Duration(seconds: 10));
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              onReplace: () {},
            );
          },
        );
      },
      child: Image.asset(
        "assets/images/cv.png",
        height: 30.h,
        color: Constants.darkBlue,
      ),
    );
  }
}
