// ignore_for_file: unused_field, unused_result, duplicate_ignore, unused_local_variable, non_constant_identifier_names, use_build_context_synchronously, avoid_unnecessary_containers, avoid_print
// ignore_for_file: todo
import 'dart:convert';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/profile/screen1.dart';
import 'package:job_circle/screens/profile/screen2.dart';
import 'package:job_circle/screens/profile/screen3.dart';
import 'package:job_circle/screens/profile/screen5.dart';
import 'package:job_circle/screens/profile/screen6.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* final fetchUserData = FutureProvider<ProfileSummaryModel>((ref) async {
  final response = await _ProfileSummaryState.bindProfileSummary();

  if (response != null) {
    return ProfileSummaryModel.fromJson(response);
  } else {
    // Handle the case where the response is null or an error occurred.
    return ProfileSummaryModel(); // Return a default model or handle the error.
  }
}); */

class UserDataModel {
  final ProfileSummaryModel profileSummary;
  final List<Education> education;
  final List<Experience> experiences;

  UserDataModel({
    required this.profileSummary,
    required this.education,
    required this.experiences,
  });
}

final educationProvider = FutureProvider<List<Education>>((ref) async {
  final educationResponse =
      await _ProfileSummaryPartnerState.bindProfileEducation();
  return (educationResponse).map((item) => Education.fromJson(item)).toList();
});

final experienceProvider = FutureProvider<List<Experience>>((ref) async {
  final experienceResponse =
      await _ProfileSummaryPartnerState.bindProfileExperience();
  return (experienceResponse).map((item) => Experience.fromJson(item)).toList();
});

final userDataProvider = FutureProvider<UserDataModel>((ref) async {
  final profileSummary = await _ProfileSummaryPartnerState
      .bindProfileSummary(); //ref.watch(profileSummaryProvider);
  final profileSummaryData = ProfileSummaryModel.fromJson(profileSummary);
  final education = await _ProfileSummaryPartnerState.bindProfileEducation();
  final educationData =
      (education).map((item) => Education.fromJson(item)).toList();
  final experiences = await _ProfileSummaryPartnerState.bindProfileExperience();
  final experienceData =
      (experiences).map((item) => Experience.fromJson(item)).toList(); //next ?
  return UserDataModel(
    profileSummary: profileSummaryData,
    education: educationData,
    experiences: experienceData,
  );
});

class ProfileSummaryPartner extends ConsumerStatefulWidget {
  final String role;
  const ProfileSummaryPartner({super.key, required this.role});

  @override
  ConsumerState<ProfileSummaryPartner> createState() =>
      _ProfileSummaryPartnerState();
}

class _ProfileSummaryPartnerState extends ConsumerState<ProfileSummaryPartner>
    with TickerProviderStateMixin {
  late Widget previousWidget;
  // ignore: non_constant_identifier_names
  var profile_final_pic = "";
  // ignore: non_constant_identifier_names
  var profile_cv_link = "";
  // ignore: non_constant_identifier_names
  var profile_cv_file = "";
  late String experienceText;

  List<Education> educationList = []; // Declare educationList variable
  List<Experience> experienceList = [];
  late AnimationController _animationController;

  String primaryNumber = '';

  // Veriable Declaration
  CardModel model = CardModel();
  TextEditingController username = TextEditingController();
  TextEditingController joblocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();

  var usertype = 0;
  String gendor = "";
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  late Education educationmodel = Education();
  late Experience expmodel = Experience();

  final spinkit = const SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  bool get kDebugMode => false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      usertype = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);

      setState(() {});
    });

    //  bindProfileSummary();
    super.initState();
    // Initialize the animation controller with the desired duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    // Don't forget to dispose of the animation controller
    _animationController.dispose();
    super.dispose();
  }

  bool isSearchVisible = false;
  // ignore: prefer_final_fields
  FocusNode _searchFocusNode = FocusNode();

  void toggleSearchVisibility() {
    setState(() {
      isSearchVisible = !isSearchVisible;
    });
  }

  static Future<Map<String, dynamic>> bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/details/$id'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("resultData") &&
          parsedResponse["resultData"].containsKey("users")) {
        return parsedResponse["resultData"]["users"] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> bindProfileEducation() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/details/$id'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("resultData") &&
          parsedResponse["resultData"].containsKey("users")) {
        return parsedResponse["resultData"]["educations"];
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> bindProfileExperience() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/details/$id'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("resultData") &&
          parsedResponse["resultData"].containsKey("users")) {
        return parsedResponse["resultData"]["experiences"];
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool visible = true;
  bool notvisible = false;
  String? icon_data;

  String? resume;
  String? previousResume;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final combinedData = ref.watch(userDataProvider);
// yaha bhi laga sakta hai or data me scaffold return krle usme sab datas milega
//lekin error or loading me bhi tere ko scaffold return krna padega
    return combinedData.when(
      data: (data) {
        bool hasCurrentExperience =
            data.experiences.any((experience) => experience.isCurrent == 1);
        return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: usertype == 1 &&
                    data.profileSummary.cv_link != null
                ? FloatingActionButton(
                    backgroundColor: Constants.themeBgColor,
                    onPressed: () {
                      //  log("message");
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Scaffold(
                            floatingActionButton: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    resume = await Delete(true);
                                    var payload = {
                                      "stage": "upload_cv",
                                      "data": {
                                        "id": await Utils.getPreferencesValue(
                                            null,
                                            ESharedPreferences.user_id.name),
                                        "cv_link": null
                                      }
                                    };
                                    await save(null, payload);
                                    // ignore: unused_result
                                    ref.refresh(userDataProvider);
                                    ref.refresh(profileSummaryProvider);
                                    ref.refresh(jobsProvider);
                                    Navigator.pop(context);
                                    setState(() {});

                                    /*  setState(() {
                                resume = Delete(true).toString();
                              }); */
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4.h, horizontal: 8.r),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                            color: Constants.themeBgColor)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          size: 15.h,
                                          color: Constants.themeBgColor,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        const Text("Remove"),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      previousResume = resume;
                                    });
                                    resume = await uploadFile(['pdf'], "cv",
                                        data.profileSummary.cv_link);
                                    if (resume != null) {
                                      var payload = {
                                        "stage": "upload_cv",
                                        "data": {
                                          "id": await Utils.getPreferencesValue(
                                              null,
                                              ESharedPreferences.user_id.name),
                                          "cv_link": resume
                                        }
                                      };
                                      await save(resume, payload);
                                      ref.refresh(userDataProvider);
                                      ref.refresh(profileSummaryProvider);
                                      ref.refresh(jobsProvider);
                                    } else {
                                      setState(() {
                                        resume = previousResume;
                                      });
                                    }

                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4.h, horizontal: 8.r),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                            color: Constants.themeBgColor)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          size: 15.h,
                                          color: Constants.themeBgColor,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        const Text("Replace"),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            body: Container(
                              child: FutureBuilder<PDFDocument>(
                                future: PDFDocument.fromURL(
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profileSummary.cv_link}"),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return PDFViewer(
                                        scrollDirection: Axis.vertical,
                                        panLimit: 1.1,
                                        document: snapshot.data!,
                                        zoomSteps: 3,
                                        showNavigation: false,
                                        showPicker: false,

                                        // numberPickerConfirmWidget: f,
                                      );
                                    } else {
                                      return const Center(
                                          child: Text('Failed to load PDF'));
                                    }
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      "assets/images/cv.png",
                      height: 30.h,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox(),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0,
                title: SizedBox(
                  //margin: const EdgeInsets.only(right: 20),
                  height: height / 26.h,
                  // width: width / 1.10.w,
                  child: TextField(
                      style: GoogleFonts.varela(color: Constants.subtitleclr),
                      cursorColor: Colors.grey.shade600,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
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
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                        contentPadding: const EdgeInsets.only(left: 5, top: 10),
                        hintText:
                            "${data.profileSummary.first_name} ${data.profileSummary.last_name}",
                      )),
                )),
            // backgroundColor: Constants.themeBgColorLight,
            body: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    thickness: 10,
                    radius: Radius.circular(8.r),
                    child: SingleChildScrollView(
                      child: data.profileSummary.first_name == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SafeArea(
                              child: Container(
                                //  padding: const EdgeInsets.only(top: 20),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            InkWell(
                                              onTap:
                                                  data.profileSummary
                                                              .profile_pic !=
                                                          null
                                                      ? () {
                                                          showDialog(
                                                            context: context,
                                                            // Set this property to true
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                elevation: 0,
                                                                content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    CircleAvatar(
                                                                        backgroundColor:
                                                                            Constants
                                                                                .themeBgColor,
                                                                        radius: height /
                                                                            6.r,
                                                                        backgroundImage: data.profileSummary.profile_pic !=
                                                                                null
                                                                            ? Image.network(
                                                                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profileSummary.profile_pic}",
                                                                                fit: BoxFit.fill,
                                                                              ).image
                                                                            : Image.asset(
                                                                                data.profileSummary.gender != "Male" ? "assets/images/leadfemal.png" : "assets/images/leadmale.png",
                                                                                //  height: 8.h,
                                                                                fit: BoxFit.fill,
                                                                              ).image),
                                                                    CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      child: IconButton(
                                                                          onPressed: () async {
                                                                            setState(() async {
                                                                              var data = await Delete(false);
                                                                              var payload = {
                                                                                "stage": "profile_pic",
                                                                                "data": {
                                                                                  "id": await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name),
                                                                                  "profile_pic": null
                                                                                }
                                                                              };
                                                                              await save(data, payload);
                                                                              ref.refresh(profileSummaryProvider);

                                                                              ref.refresh(userDataProvider);

                                                                              //  Navigator.pop(context);
                                                                              if (data != null) {
                                                                                setState(() {
                                                                                  icon_data = null;
                                                                                });
                                                                              }
                                                                              Navigator.pop(context);
                                                                            });
                                                                          },
                                                                          icon: Image.asset(
                                                                            "assets/images/bin.gif",
                                                                            height:
                                                                                40.h,
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
                                                  backgroundColor:
                                                      Constants.themeBgColor,
                                                  radius: 45,
                                                  backgroundImage: data
                                                              .profileSummary
                                                              .profile_pic !=
                                                          null
                                                      ?
                                                      // ignore: unnecessary_null_comparison
                                                      Image.network(
                                                              "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profileSummary.profile_pic}")
                                                          .image
                                                      : Image.asset(
                                                          data.profileSummary
                                                                      .gender !=
                                                                  "Male"
                                                              ? "assets/images/leadfemal.png"
                                                              : "assets/images/leadmale.png",
                                                          // height: 8.h,
                                                        ).image),
                                            ),
                                            Positioned(
                                              right: width / 160.w,
                                              bottom: height / 85.h,
                                              child: InkWell(
                                                onTap: () async {
                                                  setState(() async {
                                                    var data1 =
                                                        await uploadFile(
                                                            [
                                                          'jpeg',
                                                          'jpg',
                                                          "png"
                                                        ],
                                                            "icon",
                                                            data.profileSummary
                                                                .profile_pic);
                                                    var payload = {
                                                      "stage": "profile_pic",
                                                      "data": {
                                                        "id": await Utils
                                                            .getPreferencesValue(
                                                                null,
                                                                ESharedPreferences
                                                                    .user_id
                                                                    .name),
                                                        "profile_pic": data1
                                                      }
                                                    };
                                                    await save(data1, payload);

                                                    icon_data = data1;
                                                    ref.refresh(
                                                        userDataProvider);

                                                    ref.refresh(
                                                        profileSummaryProvider);
                                                    //  Navigator.pop(context);
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  radius: 9,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 8.r,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 15.h,
                                                      color: Constants
                                                          .themeBgColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${data.profileSummary.first_name.toString().toTitleCase()} ${data.profileSummary.last_name.toString().toTitleCase()}",
                                              style: GoogleFonts.varela(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              widget.role.toTitleCase(),
                                              style: GoogleFonts.varela(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: (usertype == 1 ? true : false),
                                      child: experience(
                                          //experienceList
                                          data.experiences,
                                          data.education,
                                          data.profileSummary),
                                    ),
                                    Visibility(
                                      visible: (usertype == 1 ? true : false),
                                      child: education(
                                          // educationList
                                          data.education,
                                          data.experiences,
                                          data.profileSummary),
                                    ),
                                    Visibility(
                                      visible: usertype == 1,
                                      child: skills(
                                          // experienceList
                                          data.experiences,
                                          data.education,
                                          data.profileSummary),
                                    ),
                                    Visibility(
                                      visible: (usertype == 1 ? true : false),
                                      child: languages(
                                          data.profileSummary.languages ?? [],
                                          data.profileSummary),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ));
      },
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: Text("Failed to fetch data"),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget basicInfo(ProfileSummaryModel profileSummaryModel,
      List<Education> educationList, List<Experience> experienceList) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: cardCustom(
            profileSummaryModel: profileSummaryModel,
            experienceList: experienceList,
            educationList: educationList,
            // icon: Icons.account_circle_outlined,
            title: "",
            onPress: (() {
              // Navigator.pushNamed(context, ERoute.screen1.value,
              //     arguments: 1);
              sendToBasicInfo(false, profileSummaryModel);
            }),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profilemodel.first_name.toString().toTitleCase()} ${profilemodel.last_name.toString().toTitleCase()}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Location",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      profilemodel.user_location.toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Gender",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      profilemodel.gender.toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Languages",
                      style: GoogleFonts.varela(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      profilemodel.languages!.join(',').toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Date Of Birth",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      DateFormat('MMMM dd,yyyy').format(
                          DateTime.parse(profilemodel.dateofbirth.toString())),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget educationTitle(List<Education> education) {
    return titleCard('Highest Education : $education');
  }

  Widget experienceTitle(ProfileSummaryModel profileSummaryModel) {
    return titleCard('Work Status : ${profileSummaryModel.experience}');
  }

  Widget education(
      List<Education> educationList,
      List<Experience> experienceList,
      ProfileSummaryModel profileSummaryModel) {
    bool shouldShowAddButton = educationList.isNotEmpty;
    bool showEducation = educationList.isEmpty;

    if (showEducation) {
      educationList.sort((a, b) => b.passingYear!.compareTo(a.passingYear!));
      return SizedBox(
        child: cardCustom(
          educationList: educationList,
          profileSummaryModel: profileSummaryModel,
          experienceList: experienceList,
          onPress: () {
            // sendToEducation();
          },
          // icons: Icons.school_outlined, // Education icon for the card
          imageUrl: "https://cdn-icons-png.flaticon.com/128/123/123402.png",
          title: "Education",
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Screen2(
                            selectedLevel: profilemodel.education,
                            educationList: educationList,
                            isFirst: false,
                            underGraduate:
                                profileSummaryModel.education != "Graduate"
                                    ? true
                                    : false,
                            isEdit: false,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 0),
                    leading: SizedBox(
                      width: 70.w,
                      height: 70.h,
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/3562/3562693.png",
                        fit: BoxFit.contain,
                        color: Constants.themeBgColor,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileSummaryModel.education == "Graduate"
                                ? "Graduate"
                                : "Under Graduate / 10+2",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.varela(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          "Add Detail",
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
            },
          ),
        ),
      );
    } else if (shouldShowAddButton) {
      educationList.sort((a, b) => b.firstYear!.compareTo(a.firstYear!));
      return SizedBox(
        width: double.infinity,
        child: cardCustom(
          experienceList: experienceList,
          profileSummaryModel: profileSummaryModel,
          educationList: educationList,
          onPress: () {
            // sendToEducation();
          },
          // icons: Icons.school_outlined, // Education icon for the card
          imageUrl: "https://cdn-icons-png.flaticon.com/128/123/123402.png",
          title: "Education",

          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: educationList.length,
            itemBuilder: (context, index) {
              educationList.sort((a, b) {
                final aYear = a.passingYear ?? 0;
                final bYear = b.passingYear ?? 0;
                return bYear.compareTo(aYear);
              });
              final education = educationList[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      sendToEducation(
                        education,
                        educationList,
                        education.degree_spc == "H.S.C" ? true : false,
                      );
                    },
                    contentPadding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 0),
                    leading: SizedBox(
                        width: 70.w,
                        height: 70.h,
                        child: education.icon != null || education.icon != ""
                            ? CustomImage(
                                imageUrl:
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${education.icon}",
                                defaultImageUrl:
                                    "https://cdn-icons-png.flaticon.com/128/3562/3562693.png")
                            : education.ficon != null || education.ficon != ""
                                ? CustomImage(
                                    imageUrl:
                                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${education.ficon}",
                                    defaultImageUrl:
                                        "https://cdn-icons-png.flaticon.com/128/3562/3562693.png")
                                : Image.network(
                                    "https://cdn-icons-png.flaticon.com/128/3562/3562693.png",
                                    //  "https://cdn-icons-png.flaticon.com/128/10693/10693407.png",
                                    fit: BoxFit.contain,
                                  )),
                    title: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            education.board != null
                                ? education.board.toString()
                                : education.university.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.varela(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            education.degree_spc.toString(),
                            style: GoogleFonts.varela(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        if (education.firstYear != 0)
                          Text(
                            education.firstYear.toString(),
                            style: GoogleFonts.varela(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        if (education.firstYear != 0 &&
                            education.passingYear != null &&
                            education.passingYear != 0 &&
                            education.firstYear != null)
                          Text(
                            " - ",
                            style: GoogleFonts.varela(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        if (education.passingYear != 0)
                          Text(
                            education.passingYear.toString(),
                            style: GoogleFonts.varela(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    } else {
      return const SizedBox
          .shrink(); // Return an empty widget if the list is empty
    }
  }

  String calculateMonthDifference(DateTime startDate, DateTime endDate) {
    int monthsDifference = endDate.year * 12 +
        endDate.month -
        (startDate.year * 12 + startDate.month);

    if (monthsDifference <= 0) {
      return ""; // Return an empty string when there is no positive month difference.
    }

    if (monthsDifference < 12) {
      // If the difference is less than 12 months, return it as months in parentheses.
      return "(${monthsDifference}mo)";
    } else {
      // If the difference is a year or more, break it down into years and remaining months.
      int years = monthsDifference ~/ 12;
      int remainingMonths = monthsDifference % 12;

      String result = "";

      if (remainingMonths > 0) {
        if (result.isNotEmpty) {
          result += " ";
        }
        result += "${remainingMonths}mo";
      }
      if (years > 0) {
        if (remainingMonths > 0) {
          result += "${years}yr,";
        } else {
          result += "${years}yr";
        }
      }

      return "($result)";
    }
  }

  Widget experience(List<Experience> experienceList,
      List<Education> educationList, ProfileSummaryModel profileSummaryModel) {
    bool shouldShowAddButton = experienceList.isNotEmpty;
    // ignore: unused_local_variable
    bool hasExperienceData = profilemodel.experience != null;

    if (experienceList.isEmpty) {
      return SizedBox(
        child: cardCustom(
          educationList: educationList,
          experienceList: experienceList,
          profileSummaryModel: profileSummaryModel,
          onPress: () {
            // sendToEducation();
          },
          // icons: Icons.work_outline,
          imageUrl: "https://cdn-icons-png.flaticon.com/128/9119/9119081.png",
          title: "Employment Details",
          child: ListTile(
            onTap: profilemodel.experience == "Experience" &&
                    experienceList.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Screen3(
                          experiencelist: experienceList,
                          isEdit: false,
                          isFirst: false,
                        ),
                      ),
                    );
                  }
                : () {},
            contentPadding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            // ignore: sized_box_for_whitespace
            leading: Container(
              width: 70.w,
              height: 70.h,
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/128/2098/2098316.png",

                //  "https://cdn-icons-png.flaticon.com/128/10693/10693407.png",
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              "Fresher",
              // experience.job_title.toString(),
              style: GoogleFonts.varela(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    } else if (shouldShowAddButton) {
      experienceList
          .sort((a, b) => b.isCurrent!.compareTo(a.isCurrent!.toInt()));
      return SizedBox(
        width: double.infinity,
        child: cardCustom(
          educationList: educationList,
          experienceList: experienceList,
          profileSummaryModel: profileSummaryModel,
          onPress: (() {
            // sendToExperience(visible);
          }),
          // icons: Icons.work_outlined,
          imageUrl: "https://cdn-icons-png.flaticon.com/128/9119/9119081.png",
          title: "Employment Details",
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: experienceList.length,
            separatorBuilder: (context, index) {
              if (index == experienceList.length - 1) {
                // Don't add a separator after the last item
                return const SizedBox.shrink();
              } else {
                // Add a separator between other items
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    thickness: 0.5,
                  ),
                ); // You can customize the separator height here
              }
            },
            itemBuilder: (context, index) {
              String monthsDifference = "";
              if (experienceList[index].joining_date != null &&
                  experienceList[index].last_working_date != null) {
                monthsDifference = calculateMonthDifference(
                    experienceList[index].joining_date!,
                    experienceList[index].last_working_date!);
              }

              /*  final experience = experienceList[index];
              final joiningDate = experience.joining_date;
              final lastWorkingDate = experience.last_working_date;

              final formattedJoiningDate = joiningDate != null
                  ? DateFormat('MM yyyy').format(joiningDate)
                  : null;

              final formattedLastWorkingDate = lastWorkingDate != null
                  ? DateFormat('MM yyyy')
                      .format(lastWorkingDate ?? DateTime.now())
                  : null;
              final duration = joiningDate != null && lastWorkingDate != null
                  ? lastWorkingDate.difference(joiningDate)
                  : null;
              var totalYears = joiningDate != null && lastWorkingDate != null
                  ? duration!.inDays ~/ 365
                  : null;
              final totalMonths = joiningDate != null && lastWorkingDate != null
                  ? (duration!.inDays % 365) ~/ 30
                  : null; */

              String experienceText;

              return ListTile(
                onTap: () {
                  sendToExperience(experienceList[index], experienceList);
                },
                contentPadding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                // ignore: sized_box_for_whitespace
                leading: Container(
                    width: 70.w,
                    height: 70.h,
                    child: experienceList[index].icon == null ||
                            experienceList[index].icon == ""
                        ? Image.network(
                            "https://cdn-icons-png.flaticon.com/128/2098/2098316.png",

                            //  "https://cdn-icons-png.flaticon.com/128/10693/10693407.png",
                            fit: BoxFit.contain,
                          )
                        : CustomImage(
                            imageUrl:
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${experienceList[index].icon}",
                            defaultImageUrl:
                                "https://cdn-icons-png.flaticon.com/128/2098/2098316.png")),
                title: Text(
                  experienceList[index].job_title.toString(),
                  // experience.job_title.toString(),
                  style: GoogleFonts.varela(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          experienceList[index].shortname != null &&
                                  experienceList[index].shortname != ""
                              ? experienceList[index].shortname.toString()
                              : experienceList[index].company_name.toString(),
                          // experience.company_name.toString(),
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Text(" · "),
                        Text(
                          experienceList[index].emptype.toString(),
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          experienceList[index].joining_date != null
                              ? DateFormat('MMM-yyyy')
                                  .format(experienceList[index].joining_date!)
                              : "",
                          /*  experienceList[index].joining_date != null
                              ? experienceList[index].joining_date.toString()
                              : "", */
                          // '$formattedJoiningDate - $formattedLastWorkingDate ($experience)',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (experienceList[index].last_working_date != null)
                          SizedBox(
                            child: Row(
                              children: [
                                const Text(" - "),
                                Text(
                                  DateFormat('MMM-yyyy').format(
                                      experienceList[index].last_working_date!),

                                  /*  experienceList[index].joining_date != null
                                    ? experienceList[index].joining_date.toString()
                                    : "", */
                                  // '$formattedJoiningDate - $formattedLastWorkingDate ($experience)',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (experienceList[index].last_working_date == null)
                          SizedBox(
                            child: Row(
                              children: [
                                const Text(" - "),
                                Text(
                                  "Present",
                                  style: GoogleFonts.varela(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (experienceList[index].joining_date != null &&
                            experienceList[index].last_working_date != null)
                          Text(
                            " $monthsDifference",
                            style: GoogleFonts.varela(
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          experienceList[index].company_location.toString(),
                          // experience.company_location.toString(),
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Text(" · "),
                        Text(
                          experienceList[index].work_type.toString(),
                          // experience.company_location.toString(),
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } else {
      return const SizedBox
          .shrink(); // Return an empty widget if the list is empty
    }
  }

  Widget languages(
      List<dynamic> languages, ProfileSummaryModel profileSummaryModel) {
    // Filter out languages other than English, Hindi, and Marathi
    //print(profilemodel.languages);
    List filteredLanguages = languages;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Constants.borderColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Icon(
                        //   Icons.language,
                        //   size: 16,
                        // ),
                        // // Icon(image.assets()),
                        Image.asset(
                          "assets/images/languages.png",
                          height: 20,
                          // width: 16,
                          fit: BoxFit
                              .contain, // or BoxFit.cover, depending on your requirement
                          colorBlendMode: BlendMode.clear,
                        ),

                        const SizedBox(width: 5),
                        Text(
                          "Languages",
                          style: GoogleFonts.varela(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (filteredLanguages.length <= 11)
                      InkWell(
                        onTap: () {
                          sendToLanguges(
                              filteredLanguages, profileSummaryModel);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 15,
                            bottom: 0,
                          ),
                          child: Icon(
                            Icons
                                .add, // Replace this with the icon of your choice
                            size:
                                20.h, // Replace this with the size of the icon
                            // color: Colors.greenAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              const Divider(
                color: Constants.borderColor,
                thickness: 2.0,
                height: 4,
              ),
              if (filteredLanguages.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Please add additional language that you know.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              if (filteredLanguages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
                  child: Wrap(
                    spacing: 3, // Adjust the spacing between the skills chips
                    runSpacing:
                        0.0, // Remove the spacing between the rows of chips
                    children: filteredLanguages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final skill = entry.value;

                      if (index < 11) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5, top: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            skill,
                            style: GoogleFonts.varela(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        );
                      } else if (index == 11) {
                        return InkWell(
                          onTap: () {
                            sendToLanguges(
                                filteredLanguages, profileSummaryModel);
                            // sendToSkills(skills);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5, top: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'View More',
                              style: GoogleFonts.varela(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox(); // Return an empty container for the remaining items
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget skills(List<Experience> experienceList, List<Education> educationList,
      ProfileSummaryModel profileSummaryModel) {
    List<String> skills = [];

    // Add skills from experienceList
    for (Experience experience in experienceList) {
      if (experience.skills_exp != null) {
        skills.addAll(experience.skills_exp!);
      }
    }

    // Add skills from profilemodel
    if (profileSummaryModel.skills != null) {
      skills.addAll(profileSummaryModel.skills!);
    }

    // Remove duplicates and convert to a list
    skills = skills.toSet().toList();

    return Column(
      children: [
        Container(
          // padding: const EdgeInsets.only(left: 6),
          margin: const EdgeInsets.only(
            top: 3,
            bottom: 3,
            left: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Constants.borderColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 9.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Icon(
                        //   Icons.star_border_outlined,
                        //   size: 16,
                        // ),
                        Image.network(
                          "https://cdn-icons-png.flaticon.com/128/10484/10484259.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Skills",
                          style: GoogleFonts.varela(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (skills.length <= 12)
                      InkWell(
                        //TODO: previous add button which is use to send to the skills page using sendToSkills.
                        onTap: () {
                          sendToSkills(
                              skills, profileSummaryModel, experienceList);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 15,
                            bottom: 0,
                          ),
                          child: Icon(
                            Icons
                                .add, // Replace this with the icon of your choice
                            size:
                                20.h, // Replace this with the size of the icon
                            // color: Colors.greenAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              const Divider(
                color: Constants.borderColor,
                thickness: 2.0,
                height: 4,
              ),
              if (skills.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Recruiters look for candidates with specific skills.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              if (skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
                  child: Wrap(
                    spacing: 3, // Adjust the spacing between the skills chips
                    runSpacing:
                        0.0, // Remove the spacing between the rows of chips
                    children: skills.asMap().entries.map((entry) {
                      final index = entry.key;
                      final skill = entry.value;

                      if (index < 12) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            skill,
                            style: GoogleFonts.varela(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        );
                      } else if (index == 12) {
                        return InkWell(
                          onTap: () {
                            sendToSkills(
                                skills, profileSummaryModel, experienceList);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5, top: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'View More',
                              style: GoogleFonts.varela(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox(); // Return an empty container for the remaining items
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void sendToSkills(
      List<String> skills,
      ProfileSummaryModel profileSummaryModel,
      List<Experience> experience) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillsMulti(
          prevPageModel: profileSummaryModel,
          experienceList: experience,
          initialSkills: skills,
        ),
      ),
    );
    if (result != null) {
      skills = result.skills;
      setState(() {});
    }
  }

  void sendToLanguges(
      List<dynamic>? language, ProfileSummaryModel profileSummaryModel) async {
    // ignore: unused_local_variable
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguageMulti(
          prevPageModel: profileSummaryModel,
          languageList: language!,
          isFirst: false,
          // experienceList: experienceList,
        ),
      ),
    );
    // if (result != null) {
    //   p.skills_exp = result.skills_exp;
    //   setState(() {});
    // }
  }

  void sendToEducationLevel(Education education) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen2(
          selectedLevel: profilemodel.education,
          educationList: educationList,
          isFirst: false,
          underGraduate: profilemodel.education != "Graduate" ? true : false,
          isEdit: true,
        ),
      ),
    );
  }

  Widget titleCard(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   // border: Border.all(color: Constants.borderColor),
      //   // borderRadius: BorderRadius.circular(15),
      // ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.varela(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardCustom(
      {required List<Education> educationList,
      required List<Experience> experienceList,
      required ProfileSummaryModel profileSummaryModel,
      required String? title,
      IconData? icon,
      IconData? icons,
      Widget? child,
      bool? isskiil = false,
      bool? isresume = false,
      bool? isedit = true,
      Function()? onPress,
      String? imageUrl}) {
    bool shouldShowExperienceAddButton = experienceList.isNotEmpty ||
        profileSummaryModel.experience == "Fresher" ||
        profileSummaryModel.experience == "Experience";
    bool shouldShowEducationAddButton = educationList.isNotEmpty;

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
              if (isskiil == true)
                Icon(
                  Icons.star_border_outlined,
                  size: 16.h,
                ),
              SizedBox(width: 2.h),
              if (imageUrl != null) // Check if the icon is not null
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Image.network(
                    imageUrl,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(width: 5),
              if (isresume == false)
                Text(
                  title.toString(),
                  style: GoogleFonts.varela(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isresume! &&
                        ((title == "Employment Details" &&
                                shouldShowExperienceAddButton) ||
                            (title == "Education" &&
                                shouldShowEducationAddButton)))
                      // Display the "+" button here
                      InkWell(
                        onTap: () {
                          if (title == "Employment Details") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Screen3(
                                  experiencelist: experienceList,
                                  isEdit: false,
                                  isFirst: true,
                                ),
                              ),
                            );
                          } else if (title == "Education") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Screen2(
                                    educationList: educationList,
                                    underGraduate: false,
                                    isFirst: true,
                                    isEdit: false),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            // left: 10,
                            //right: 14,
                            bottom: 0,
                            top: 0,
                          ),
                          // child: Icon(Icons.add, size: 18.h),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons
                                  .add, // Replace this with the icon of your choice
                              size: 20
                                  .h, // Replace this with the size of the icon
                              // color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (isresume == false)
            Divider(
              color: Constants.borderColor,
              thickness: 2.w,
            ),
          Container(
            // padding: const EdgeInsets.only(top: 0),
            child: child,
          ),
        ],
      ),
    );
  }

  updateCard(CardModel items) {
    model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    // model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    setState(() {});
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  sendToBasicInfo(bool isBio, ProfileSummaryModel profileSummaryModel) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen1(
          prevPageModel: profileSummaryModel,
          isbio: isBio,
          isfirst: false,
        ),
      ),
    );
    if (result != null) {
      profilemodel.first_name = result.first_name;
      profilemodel.last_name = result.last_name;
      profilemodel.user_location = result.user_location;
      profilemodel.gender = result.gender;
      profilemodel.languages = result.languages;
      setState(() {});
    }
  }

  sendToEducation(Education education, List<Education> educationList,
      bool isGraduate) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen2(
          prevPageModel: education,
          educationList: educationList,
          isFirst: false,
          underGraduate: isGraduate,
          isEdit: true,
        ),
      ),
    );
    if (result != null) {
      education.level = result.level;
      setState(() {});
    }
  }

  int calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 0;

    DateTime currentDate = DateTime.now();
    DateTime dob = DateTime.parse(dateOfBirth);

    int age = currentDate.year - dob.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    return age;
  }

  sendToExperience(
      Experience experience, List<Experience>? experienceList) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen3(
          prevPageModel: experience,
          experiencelist: experienceList,
          isEdit: true,
          isFirst: false,
        ),
      ),
    );
    if (result != null) {
      experience.job_title = result.job_title;
      experience.company_name = result.company_name;
      experience.skills_exp = result.skills_exp;

      setState(() {});
    }
  }

  Future<String?> Delete(bool iscv) async {
    try {
      var res = await FileUploadService().deleteSingleFile(iscv
          ? profilemodel.cv_link.toString()
          : profilemodel.profile_pic.toString());
    } catch (e) {
      // Close the loading dialog in case of exceptions
      Navigator.pop(context);

      // Handle any exceptions that occur during the upload
      print("Error during file upload: $e");
      return null;
    }
    return null;
  }

  Future<String?> uploadFile(allowExt, String folder, String? pic) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile(folder, result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          print(filename);
          print("Filename: $filePath");

          // Close the loading dialog when the upload is successful
          Navigator.pop(context);
          //save(filename, data);

          return filename;
        } else {
          // Close the loading dialog when there is an error
          Navigator.pop(context);

          // Handle the case where the server returns an error
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error while uploading cv"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
          return null;
        }
      } catch (e) {
        // Close the loading dialog in case of exceptions
        Navigator.pop(context);

        // Handle any exceptions that occur during the upload
        print("Error during file upload: $e");
        return null;
      }
    } else {
      // Close the loading dialog when the user cancels file selection
      Navigator.pop(context);

      // Handle the case where the user cancels file selection
      return pic;
    }
  }

  save(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'profile_pic') {
        profilemodel.profile_pic = filePath;
        profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      } else if (data['stage'] == 'upload_cv') {
        profilemodel.cv_link = filePath;
        profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
        profile_cv_file = Utils.getFileName(profile_cv_link);

        profilemodel.cv_upladted_date =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }
}









/* // ignore_for_file: use_super_parameters, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/profile/screen1.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSummaryPartner extends StatefulWidget {
  const ProfileSummaryPartner({Key? key}) : super(key: key);

  @override
  State<ProfileSummaryPartner> createState() => _ProfileSummaryPartnerState();
}

class _ProfileSummaryPartnerState extends State<ProfileSummaryPartner> {
  late Widget previousWidget;
  var profile_final_pic = "";
  var profile_cv_link = "";
  var profile_cv_file = "";
  var partner_request = 1;

  // Veriable Declaration
  CardModel model = CardModel();
  TextEditingController username = TextEditingController();
  TextEditingController joblocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  var usertype = 0;
  String gendor = "";
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  late Education educationmodel = Education();
  late Experience expmodel = Experience();

  final spinkit = const SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  bool get kDebugMode => false;
  @override
  void initState() {
    super.initState();
    bindProfileSummary();
  }

  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    usertype = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_type.name);

    partner_request = await Utils.getCacheData('partner_request');
    setState(() {});
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromJson(dataResult);
      educationmodel = Education.fromJson(dataResult);
      expmodel = Experience.fromJson(dataResult);
      profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
      profile_cv_file = Utils.getFileName(profile_cv_link);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: const [
             
            ],
          ),
        ));
  }

  Widget basicInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, top: 100, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              // icon: Icons.account_circle_outlined,
              title: "",
              onPress: (() {
                // Navigator.pushNamed(context, ERoute.screen1.value,
                //     arguments: 1);
                // sendToBasicInfo();
              }),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profilemodel.first_name.toString().toTitleCase() +
                        ' ' +
                        profilemodel.last_name.toString().toTitleCase(),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Location",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.user_location.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Gender",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.gender.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Languages",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.languages!.join(',').toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Date Of Birth",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          DateFormat('MMMM dd,yyyy').format(DateTime.parse(
                              profilemodel.dateofbirth.toString())),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget education() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              onPress: (() {
                // sendToEducation();
              }),
              icon: Icons.school_outlined,
              title: "Education",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Highest Education",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        educationmodel.level.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "University / Institite",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        educationmodel.university.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Degree / Specialization",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        educationmodel.degree_spc.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Passing Year",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        educationmodel.passingYear.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget experience() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 3, right: 3),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           width: double.infinity,
  //           child: cardCustom(
  //             onPress: (() {
  //               sendToExperience();
  //             }),
  //             icon: Icons.business_center_outlined,
  //             title: "Experience",
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     if (profilemodel.has_experience == 1)
  //                       const Text(
  //                         "Years of Experience",
  //                         style: TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.w300),
  //                       ),
  //                     if (profilemodel.has_experience == 1)
  //                       Text(
  //                         profilemodel.experience.toString(),
  //                         style: const TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.w400),
  //                       ),
  //                     if (profilemodel.has_experience == 0)
  //                       const Text(
  //                         "No Experience",
  //                         style: TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.w300),
  //                       ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Visibility(
  //                   visible: profilemodel.has_experience == 1,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         "Company Name",
  //                         style: TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.w300),
  //                       ),
  //                       Text(
  //                         profilemodel.companyName.toString(),
  //                         style: const TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.w400),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Visibility(
  //                   visible: profilemodel.has_experience == 1,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         "Job Title",
  //                         style: TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.w300),
  //                       ),
  //                       Text(
  //                         profilemodel.job_title.toString(),
  //                         style: const TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.w400),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget contactDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              isedit: false,
              icon: Icons.alternate_email_outlined,
              title: "Contact Details",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mobile",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.mobile.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.email.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card cardCustom(
      {required String title,
      IconData? icon,
      Widget? child,
      bool? isedit = false,
      Function()? onPress}) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isedit == true)
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: onPress,
                              )
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: child,
                )
              ],
            )));
  }

  updateCard(CardModel items) {
    model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    // model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    setState(() {});
  }

  // saveTo() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString('username', username.text);
  //   save();
  //   setState(() {});
  // }

  // save() async {
  //   // var result = await UserDataService().getUser(1);

  //   // print(Utils.parseResponse(result).resultData);

  //   var result = await UserDataService().saveUserStages({
  //     "stage": "otp",
  //     "data": {"mobile": "9321284090"}
  //   });
  //   print(Utils.parseResponse(result));
  // }

  sendToBasicInfo() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen1(
          isbio: false,
          prevPageModel: profilemodel,
          isfirst: false,
        ),
      ),
    );
    if (result != null) {
      profilemodel.first_name = result.first_name;
      profilemodel.last_name = result.last_name;
      profilemodel.user_location = result.job_location_city;
      profilemodel.gender = result.gender;
      profilemodel.languages = result.languages;
      setState(() {});
    }
  }

  // sendToEducation() async {
  //   var result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Screen2(
  //         prevPageModel: education,
  //       ),
  //     ),
  //   );
  //   if (result != null) {
  //     educationmodel.level = result.education;
  //     setState(() {});
  //   }
  // }

  // sendToExperience() async {
  //   var result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Screen3(
  //         prevPageModel: profilemodel,
  //         expirieanceFlag: false,
  //       ),
  //     ),
  //   );
  //   if (result != null) {
  //     expmodel.job_title = result.experience;
  //     setState(() {});
  //   }
  // }

  uploadFile(allowExt) async {
    Utils.showLoaderDialog(context, "Uploading...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowExt,
        withReadStream: true);

    if (result != null) {
      var res =
          await FileUploadService().uploadSingleFile("cv", result.files.single);
      var resultD = Utils.parseResponse(res);
      Navigator.pop(context);
      if (resultD.resultKey == 'SUCCESS') {
        return resultD.resultData[0];
      }
      // File file = File(result.files.single.readStream.first!);
    } else {
      Navigator.pop(context);
      return null;
      // User canceled the picker
    }
  }

  save(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'profile_pic') {
        profilemodel.profile_pic = filePath;
        profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      } else if (data['stage'] == 'upload_cv') {
        profilemodel.cv_link = filePath;
        profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
        profile_cv_file = Utils.getFileName(profile_cv_link);

        profilemodel.cv_upladted_date =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }
}
 */