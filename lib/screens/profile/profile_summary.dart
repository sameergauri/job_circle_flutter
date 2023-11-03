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
import 'package:job_circle/constants/assets_images_url.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/profile/screen1.dart';
import 'package:job_circle/screens/profile/screen2.dart';
import 'package:job_circle/screens/profile/screen3.dart';
import 'package:job_circle/screens/profile/screen5.dart';
import 'package:job_circle/screens/profile/screen6.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/customRow.dart';

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

/* final profileSummaryProvider = FutureProvider<ProfileSummaryModel>((ref) async {
  final summaryResponse = await _ProfileSummaryState.bindProfileSummary();
  if (summaryResponse != null) {
    return ProfileSummaryModel.fromJson(summaryResponse);
  } else {
    throw Exception('Failed to load profile summary data');
  }
}); */
final profileSummaryProvider = FutureProvider<ProfileSummaryModel>((ref) async {
  final summaryResponse = await _ProfileSummaryState.bindProfileSummary();
  // Simulate fetching profile summary data (replace with actual API call)
  // await Future.delayed(const Duration(seconds: 2));
  if (summaryResponse != null) {
    return ProfileSummaryModel.fromJson(summaryResponse);
  } else {
    throw Exception('Failed to load profile summary data');
  }
  // return ProfileSummaryModel('John Doe');
});

final educationProvider = FutureProvider<List<Education>>((ref) async {
  final educationResponse = await _ProfileSummaryState.bindProfileEducation();
  if (educationResponse != null) {
    return (educationResponse).map((item) => Education.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load education data');
  }
});

final experienceProvider = FutureProvider<List<Experience>>((ref) async {
  final experienceResponse = await _ProfileSummaryState.bindProfileExperience();
  if (experienceResponse != null) {
    return (experienceResponse)
        .map((item) => Experience.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load experience data');
  }
});

final userDataProvider = FutureProvider<UserDataModel>((ref) async {
  final profileSummary = await _ProfileSummaryState
      .bindProfileSummary(); //ref.watch(profileSummaryProvider);
  final profileSummaryData = ProfileSummaryModel.fromJson(profileSummary);
  final education = await _ProfileSummaryState.bindProfileEducation();
  final educationData =
      (education).map((item) => Education.fromJson(item)).toList();
  final experiences = await _ProfileSummaryState.bindProfileExperience();
  final experienceData =
      (experiences).map((item) => Experience.fromJson(item)).toList(); //next ?
  return UserDataModel(
    profileSummary: profileSummaryData,
    education: educationData,
    experiences: experienceData,
  );
  //neeche ka code hata de comment krde or bs ye p
  /* return profileSummary.when(
    data: (profileData) {
      return education.when(
        data: (educationData) {
          return experiences.when(
            data: (experienceData) {
              return UserDataModel(
                profileSummary: profileData,
                education: educationData,
                experiences: experienceData,
              );
            },
            loading: () {
              // Handle loading state for experiences
              throw Exception('Loading experiences');
            },
            error: (error, stackTrace) {
              // Handle error state for experiences
              throw error;
            },
          );
        },
        loading: () {
          // Handle loading state for education
          throw Exception('Loading education');
        },
        error: (error, stackTrace) {
          // Handle error state for education
          throw error;
        },
      );
    },
    loading: () {
      // Handle loading state for profile summary
      throw Exception('Loading profile summary');
    },
    error: (error, stackTrace) {
      // Handle error state for profile summary
      throw error;
    },
  ); */

  //abhi yeh bata ke riverpod .when or watch kaha lagega? jaha bhi to ye provider use krega wahi
});

/* final fetchAllApplicantProvider = FutureProvider<ProfileSummaryModel>(
    (ref) => _ProfileSummaryState.bindProfileSummary); */

class ProfileSummary extends ConsumerStatefulWidget {
  const ProfileSummary({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends ConsumerState<ProfileSummary>
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
  final basicForm = GlobalKey<FormState>();
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

  // bindProfileSummary() async {
  //   SharedPreferences prefs = await Utils.getSharedPreferences();
  //   var result = await UserDataService().getUserDetails(
  //       await Utils.getPreferencesValue(
  //           prefs, ESharedPreferences.user_id.name));
  //   if (Utils.parseResponse(result).resultData) {
  //     print(result);
  //     var dataResult = Utils.parseResponse(result).resultData;
  //     profilemodel = ProfileSummaryModel.fromJson(dataResult);
  //     educationmodel = Education.fromJson(dataResult);
  //     expmodel = Experience.fromJson(dataResult);
  //     profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
  //     profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
  //     profile_cv_file = Utils.getFileName(profile_cv_link);
  //   }
  //   setState(() {});
  // }

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

  /*  Future<void> bindProfileSummary() async {
    try {
      SharedPreferences prefs = await Utils.getSharedPreferences();
      var result = await UserDataService().getUserDetails(
          await Utils.getPreferencesValue(
              prefs, ESharedPreferences.user_id.name));
      var parsedResult = Utils.parseResponse(result);

      if (parsedResult.resultData != null) {
        var dataResult = parsedResult.resultData;
        var userData = dataResult["users"];
        var educationData = dataResult["educations"] as List<dynamic>;
        var experienceData = dataResult["experiences"] as List<dynamic>;

        // Initialize the model and lists here
        profilemodel = ProfileSummaryModel.fromJson(userData);
        educationList =
            educationData.map((item) => Education.fromMap(item)).toList();
        experienceList =
            experienceData.map((item) => Experience.fromMap(item)).toList();
      } else {
        // Handle cases where data is missing or not in the expected format
      }
    } catch (e) {
      // Handle any exceptions or errors that occur during data retrieval or processing
    }
  } */

  /*  bindProfileSummary() async {
    try {
      SharedPreferences prefs = await Utils.getSharedPreferences();
      var result = await UserDataService().getUserDetails(
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name),
      );
      var parsedResult = Utils.parseResponse(result);

      if (parsedResult.resultData != null) {
        var dataResult = parsedResult.resultData;
        var userData = dataResult["users"];
        var educationData = dataResult["educations"] as List<dynamic>;
        var experienceData = dataResult["experiences"] as List<dynamic>;

        // Initialize the model and lists here
        profilemodel = ProfileSummaryModel.fromJson(userData);
        educationList =
            educationData.map((item) => Education.fromMap(item)).toList();
        experienceList =
            experienceData.map((item) => Experience.fromMap(item)).toList();
      } else {
        // Handle cases where data is missing or not in the expected format
      }
    } catch (e) {
      // Handle any exceptions or errors that occur during data retrieval or processing
    }
  } */

  /* bindProfileSummary() async { //TODO : old bindProfile 
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().getUserDetails(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultData != null) {
      var dataResult = Utils.parseResponse(result).resultData;
      var userData = dataResult["users"];
      var educationData = dataResult["educations"] as List<dynamic>;
      var experienceData = dataResult["experiences"] as List<dynamic>;
      //  print(userData);
      //print(educationData);
      //print(experienceData);
      profilemodel = ProfileSummaryModel.fromJson(userData);

      // Check if educationData and experienceData are not empty before converting them
      if (educationData.isNotEmpty) {
        educationList =
            educationData.map((item) => Education.fromMap(item)).toList();
        educationList.sort((a, b) => b.firstYear!.compareTo(a.firstYear!));
        // Convert list of educationData into List<Education>
      } else {
        educationList = []; // Empty list if educationData is empty
      }

      if (experienceData.isNotEmpty) {
        experienceList = experienceData
            .map((item) => Experience.fromMap(item))
            .toList(); // Convert list of experienceData into List<Experience>

        // Sort the experienceList based on joining date in descending order
        experienceList
            .sort((a, b) => b.joining_date!.compareTo(a.joining_date!));
      } else {
        experienceList = []; // Empty list if experienceData is empty
      }

      /* if (experienceData.isNotEmpty) {   //TODO: old experience data list without filter data
        experienceList = experienceData
            .map((item) => Experience.fromMap(item))
            .toList(); // Convert list of experienceData into List<Experience>
      } else {
        experienceList = []; // Empty list if experienceData is empty
      } */

      // if (profilemodel.profile_pic != null) {
      //   profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      // } else {
      //   // If "profile_pic" is null, provide a default image or handle it accordingly
      // }
      // profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
      // profile_cv_file = Utils.getFileName(profile_cv_link);
    }
  } */

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
                                    ref.refresh(userDataProvider);
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
                                    resume = await uploadFile(['pdf'], "cv");
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
                    /*  onPressed: () async {
                resume = await uploadFile(['pdf'], "cv");
                var payload = {
                  "stage": "upload_cv",
                  "data": {
                    "id": await Utils.getPreferencesValue(
                        null, ESharedPreferences.user_id.name),
                    "cv_link": resume
                  }
                };
                save(resume, payload);
                setState(() {});
              }, */
                    child: Image.network(
                      ConstImageUrl.cv,
                      height: 30.h,
                      color: Colors.white,
                    ),
                  )
                /* FloatingActionButton(
              onPressed: () {},
              child: CVWidget(
                profileCv: ProfileCv(
                  cv_link: profilemodel.cv_link,
                  cv_upladted_date: profilemodel.cv_upladted_date,
                  profile_cv_file:
                      profilemodel.cv_link, // Use the same value as cv_link
                  profile_cv_link: profile_cv_link,
                ),
                onUpload: (fileName, payload) async =>
                    await save(fileName, payload),
              ),
            ) */
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
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(8.r)),
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.only(left: 5, top: 10),
                        border: OutlineInputBorder(
                            /* borderSide:
                  const BorderSide(color: Constants.borderColor), */
                            borderRadius: BorderRadius.circular(8.r)),
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
                                                                      radius:
                                                                          height /
                                                                              6.r,
                                                                      backgroundImage: data.profileSummary.profile_pic !=
                                                                              null
                                                                          ? Image.network("https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profileSummary.profile_pic}")
                                                                              .image
                                                                          : Image
                                                                              .asset(
                                                                              "assets/images/add.png",
                                                                              height: 8.h,
                                                                            ).image,
                                                                    ),
                                                                    CircleAvatar(
                                                                      backgroundColor:
                                                                          Constants
                                                                              .themeBgColor,
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
                                                                          icon: const Icon(
                                                                            Icons.delete_outline,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                    )
                                                                    /* Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              vertical: 6.h,
                                                              horizontal:
                                                                  12.w),
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: Constants
                                                              .themeBgColor,
                                                          border: Border.all(
                                                              color: Constants
                                                                  .themeBgColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r)),
                                                      child: Text(
                                                          "Remove Profile pic"),
                                                    ) */
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      : () {},
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 190, 190, 190),
                                                  radius: 45,
                                                  /* onBackgroundImageError: ((error,
                                        stackTrace) =>
                                    Image.asset(
                                        "assets/images/company.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.contain)), */
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
                                                          "assets/images/add.png",
                                                          height: 8.h,
                                                        ).image
                                                  /*  : Image.asset(
                                            "assets/images/man.png",
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.contain,
                                          ).image, */
                                                  ),
                                            ),
                                            Positioned(
                                              right: width / 160.w,
                                              bottom: height / 85.h,
                                              child: InkWell(
                                                onTap: () async {
                                                  setState(() async {
                                                    var data = await uploadFile(
                                                        ['jpeg', 'jpg'],
                                                        "icon");
                                                    var payload = {
                                                      "stage": "profile_pic",
                                                      "data": {
                                                        "id": await Utils
                                                            .getPreferencesValue(
                                                                null,
                                                                ESharedPreferences
                                                                    .user_id
                                                                    .name),
                                                        "profile_pic": data
                                                      }
                                                    };
                                                    await save(data, payload);

                                                    icon_data = data;
                                                    ref.refresh(
                                                        userDataProvider);
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /*  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color:
                                          Colors.transparent,
                                    )), */
                                          InkWell(
                                            child: Container(
                                              child: Icon(
                                                Icons.edit_outlined,
                                                size: 18.h,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                          data.profileSummary.experience ==
                                                  "Experience"
                                              ? Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${data.profileSummary.first_name.toString().toTitleCase()} ${data.profileSummary.last_name.toString().toTitleCase()}",
                                                        style:
                                                            GoogleFonts.varela(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      if (data.experiences
                                                          .every((element) =>
                                                              element
                                                                  .last_working_date ==
                                                              null))
                                                        Text(
                                                          "${data.experiences.last.job_title.toString()} at ${data.experiences.last.company_name.toString()}",
                                                          style: GoogleFonts
                                                              .varela(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      /* if (data.experiences
                                                          .isNotEmpty)
                                                        Text(
                                                          "${data.experiences.last.job_title.toString()} at ${data.experiences.last.company_name.toString()}",
                                                          style: GoogleFonts
                                                              .varela(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ), */
                                                      if ((data.profileSummary.bio ==
                                                                  null ||
                                                              data.profileSummary
                                                                      .bio ==
                                                                  "" ||
                                                              data
                                                                  .profileSummary
                                                                  .bio!
                                                                  .isEmpty) ||
                                                          data.experiences.every(
                                                                  (element) =>
                                                                      element
                                                                          .last_working_date ==
                                                                      null) &&
                                                              data.experiences
                                                                  .isEmpty &&
                                                              data.education
                                                                  .isEmpty)
                                                        InkWell(
                                                          onTap: () {
                                                            sendToBasicInfo(
                                                                true,
                                                                data.profileSummary);
                                                          },
                                                          child: Text(
                                                            "Add Bio",
                                                            style: GoogleFonts.varela(
                                                                fontSize: 12.sp,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        ),
                                                      if (data.experiences.every((element) =>
                                                              element
                                                                      .last_working_date !=
                                                                  null &&
                                                              data.profileSummary
                                                                      .bio !=
                                                                  null) ||
                                                          (data.profileSummary
                                                                      .bio !=
                                                                  null &&
                                                              data
                                                                  .profileSummary
                                                                  .bio!
                                                                  .isNotEmpty &&
                                                              data.education
                                                                  .isEmpty &&
                                                              data.experiences
                                                                  .isEmpty))
                                                        Text(
                                                          data.profileSummary
                                                              .bio!,
                                                          style: GoogleFonts
                                                              .varela(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      if (data.experiences
                                                              .isEmpty &&
                                                          data.education
                                                              .isNotEmpty)
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "${data.education.last.degree_spc.toString()} from ${data.education.last.university.toString()}",
                                                                softWrap: true,
                                                                // maxLines: 3,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      Text(
                                                        '${capitalizeFirstLetter(data.profileSummary.user_locality)}, ${capitalizeFirstLetter(data.profileSummary.user_location)}',
                                                        softWrap: true,
                                                        maxLines: 3,
                                                        style:
                                                            GoogleFonts.varela(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${data.profileSummary.first_name.toString().toTitleCase()} ${data.profileSummary.last_name.toString().toTitleCase()}",
                                                      style: GoogleFonts.varela(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (data.experiences
                                                            .isNotEmpty)
                                                          Text(
                                                            "${data.education.last.degree_spc.toString()} from ${data.education.last.university.toString()}",
                                                            style: GoogleFonts
                                                                .varela(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    if ((data.profileSummary.bio ==
                                                                null ||
                                                            data.profileSummary
                                                                    .bio ==
                                                                "" ||
                                                            data
                                                                .profileSummary
                                                                .bio!
                                                                .isEmpty) &&
                                                        data.experiences
                                                            .isEmpty &&
                                                        data.education.isEmpty)
                                                      InkWell(
                                                        onTap: () {
                                                          sendToBasicInfo(true,
                                                              data.profileSummary);
                                                        },
                                                        child: Text(
                                                          "Add Bio",
                                                          style: GoogleFonts
                                                              .varela(
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                        ),
                                                      ),
                                                    if (data.profileSummary
                                                                .bio !=
                                                            null &&
                                                        data.profileSummary.bio!
                                                            .isNotEmpty)
                                                      Text(
                                                        data.profileSummary
                                                            .bio!,
                                                        style:
                                                            GoogleFonts.varela(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${capitalizeFirstLetter(data.profileSummary.user_locality)}, ${capitalizeFirstLetter(data.profileSummary.user_location)}',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                          InkWell(
                                            onTap: () {
                                              sendToBasicInfo(
                                                  false, data.profileSummary);
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.edit_outlined,
                                                size: 18.h,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (data.profileSummary.cv_link == null ||
                                        data.profileSummary.skills!.isEmpty ||
                                        (data.profileSummary.languages !=
                                                null &&
                                            data.profileSummary.languages!
                                                .isEmpty) ||
                                        data.education
                                            .isEmpty /* ||
                                  experienceList.isEmpty */
                                    )
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 102,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            // color: Colors.brown.shade50,
                                          ),
                                          //  padding: const EdgeInsets.all(10.0),
                                          child: Scrollbar(
                                            child: ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                if (data.profileSummary
                                                        .cv_link ==
                                                    null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4,
                                                            right: 4.0),
                                                    child: CustomFieldBlock(
                                                      iconColor:
                                                          const Color.fromRGBO(
                                                              37, 150, 190, 0),
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/3135/3135752.png",
                                                      description:
                                                          "Recruiters identify prospective candidates through their CV.",
                                                      buttonText:
                                                          "+ Upload Resume",
                                                      onPressed: () async {
                                                        resume =
                                                            await uploadFile(
                                                                ['pdf'], "cv");
                                                        var payload = {
                                                          "stage": "upload_cv",
                                                          "data": {
                                                            "id": await Utils
                                                                .getPreferencesValue(
                                                                    null,
                                                                    ESharedPreferences
                                                                        .user_id
                                                                        .name),
                                                            "cv_link": resume
                                                          }
                                                        };
                                                        await save(
                                                            resume, payload);
                                                        ref.refresh(
                                                            userDataProvider);
                                                        setState(() {
                                                          /* var data = await uploadFile(
                                                        'pdf', "icon");
                                                    if (data != null) {
                                                      setState(() {
                                                        icon_data = data;
                                                      });
                                                    } */
                                                        });
                                                      },
                                                    ),
                                                  ),

                                                // Block 2: Email
                                                // Block 2: Email
                                                // CustomFieldBlock(
                                                //   imageUrl:
                                                //       "https://cdn-icons-png.flaticon.com/128/726/726623.png",
                                                //   description:
                                                //       "Ensure your contact email",
                                                //   buttonText: "Verify Now",
                                                //   onPressed: () {
                                                //     sendToBasicInfo();
                                                //   },
                                                // ),

                                                // Block 3: Skills
                                                if (data.profileSummary.skills!
                                                        .isEmpty &&
                                                    data.experiences
                                                        .isEmpty /*  &&
                                                    data.profileSummary
                                                            .experience ==
                                                        "Fresher" */
                                                )
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4,
                                                            right: 4.0),
                                                    child: CustomFieldBlock(
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/10484/10484259.png",
                                                      description:
                                                          "Your skills will connect you with relevant job opportunities",
                                                      buttonText:
                                                          "+ Add Skills",
                                                      onPressed: () {
                                                        List<String> skills =
                                                            [];
                                                        sendToSkills(
                                                            skills,
                                                            data.profileSummary,
                                                            data.experiences);
                                                      },
                                                    ),
                                                  ),

                                                // Block 4: Language

                                                if (data.profileSummary
                                                            .languages !=
                                                        null &&
                                                    data.profileSummary
                                                        .languages!.isEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            right: 4.0),
                                                    child: CustomFieldBlock(
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/3898/3898150.png",
                                                      description:
                                                          "Specify the languages",
                                                      buttonText:
                                                          "+ Add Languages",
                                                      onPressed: () {
                                                        sendToLanguges([],
                                                            data.profileSummary);
                                                      },
                                                    ),
                                                  ),
                                                /* if (experienceList.isEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0),
                                              child: CustomFieldBlock(
                                                imageUrl:
                                                    "https://cdn-icons-png.flaticon.com/128/5131/5131890.png",
                                                description:
                                                    "Keep your profile updated with your recent work experience.",
                                                buttonText:
                                                    "+ Add Experience",
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Screen3(
                                                        experiencelist:
                                                            experienceList,
                                                        isEdit: false,
                                                        isFirst: false,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ), */
                                                if (data.education.isEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4.0,
                                                            left: 4),
                                                    child: CustomFieldBlock(
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/123/123402.png",
                                                      description:
                                                          "Share Educational detail to maximize your potential.",
                                                      buttonText:
                                                          "+ Add Education",
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Screen2(
                                                              isFirst: false,
                                                              isEdit: false,
                                                              underGraduate:
                                                                  profilemodel.education !=
                                                                          "Graduate"
                                                                      ? true
                                                                      : false,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    Visibility(
                                      visible: (usertype == 1 ? true : false),
                                      child: experience(
                                          //experienceList
                                          data.experiences ?? [],
                                          data.education ?? [],
                                          data.profileSummary),
                                    ),
                                    Visibility(
                                      visible: (usertype == 1 ? true : false),
                                      child: education(
                                          // educationList
                                          data.education ?? [],
                                          data.experiences ?? [],
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
                                    /*  Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 150.w),
                                child: const Divider(
                                  color: Constants.borderColor,
                                  thickness: 2.5,
                                ),
                              ) */
                                    /*  Visibility(  //TODO: previous add cv button at the bottom.
                                visible: (usertype == 1 ? true : false),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, right: 3),
                                  child: cardCustom(
                                    icon: Icons.file_copy,
                                    isedit: false,
                                    isresume: true,
                                    title: "",
                                    child: CVWidget(
                                      profileCv: ProfileCv(
                                        cv_link: data.profileSummary.cv_link,
                                        cv_upladted_date:
                                            data.profileSummary.cv_upladted_date,
                                        profile_cv_file: data
                                            .cv_link, // Use the same value as cv_link
                                        profile_cv_link: profile_cv_link,
                                      ),
                                      onUpload: (fileName, payload) async =>
                                          await save(fileName, payload),
                                    ),
                                  ),
                                ),
                              ), */
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
                  profilemodel.first_name.toString().toTitleCase() +
                      ' ' +
                      profilemodel.last_name.toString().toTitleCase(),
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
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(15),
                      //   border: Border.all(
                      //     color: Colors.transparent,
                      //   ),
                      // ),
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
                        /*  Text(
                          " - ",
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          education.passingYear.toString(),
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ), */
                      ],
                    ),
                    /*   trailing: InkWell(
                      onTap: () {
                        sendToEducation(education);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 4, bottom: 10),
                        child: Icon(Icons.edit_outlined, size: 18.h),
                      ),
                    ), */
                  ),
                ],
              );
            },
          ),
        ),
      );
    } else if (shouldShowAddButton) {
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
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(15),
                      //   border: Border.all(
                      //     color: Colors.transparent,
                      //   ),
                      // ),
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
                            education.university.toString(),
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
                    /*   trailing: InkWell(
                      onTap: () {
                        sendToEducation(education);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 4, bottom: 10),
                        child: Icon(Icons.edit_outlined, size: 18.h),
                      ),
                    ), */
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
    int yearsDifference = endDate.year - startDate.year;
    int monthsDifference = endDate.month - startDate.month;

    if (yearsDifference == 0 && monthsDifference == 0) {
      return ""; // Return an empty string when both years and months are 0.
    } else {
      String result = "";

      if (yearsDifference > 0) {
        result += "${yearsDifference}yr";
      }

      if (monthsDifference > 0) {
        if (result.isNotEmpty) {
          result += ", ";
        }
        result += "${monthsDifference}mo";
      }

      return "($result)";
    }
  }

  /* String calculateMonthDifference(DateTime startDate, DateTime endDate) {
    int yearsDifference = endDate.year - startDate.year;
    int monthsDifference = endDate.month - startDate.month;
    return "${(yearsDifference)}yr, ${monthsDifference}mo";
  } */

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
              // deco5ration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(15),
              //   border: Border.all(
              //     color: Colors.transparent,
              //   ),
              // ),
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

            /* trailing: InkWell(
                    onTap: () {
                      sendToExperience(experienceList[index]
                          // experience
                          ); // Pass the selected experience object
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, right: 4, bottom: 10),
                      child: Icon(Icons.edit_outlined, size: 18.h),
                    )), */
          ),

          /*  Row(
            children: [
              Text(
                "Work Status ",
                style: GoogleFonts.varela(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(), // Added Spacer widget
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
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
                  },
                  child: Row(
                    children: [
                      Text(
                        "${profilemodel.experience}",
                        style: GoogleFonts.varela(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons
                            .arrow_forward_ios, // Replace this with the icon of your choice
                        size: 16,
                        // color: Colors.greenAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ), */
        ),
      );
    } else if (shouldShowAddButton) {
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
              /*  if (joiningDate != null && lastWorkingDate != null) {
                if (totalYears! > 0 && totalMonths! > 0) {
                  experienceText = "${totalYears}y, ${totalMonths}m";
                } else if (totalYears > 0) {
                  experienceText = "${totalYears}y";
                } else {
                  experienceText = "${totalMonths}m";
                }
              }

              

// Additional logic to increment totalYears if totalMonths >= 12

              if (totalMonths != null && totalMonths >= 12) {
                totalYears = 1;
                experienceText = "${totalYears}y";
              } */

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
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(15),
                  //   border: Border.all(
                  //     color: Colors.transparent,
                  //   ),
                  // ),
                  child: Image.network(
                    experienceList[index].icon == null ||
                            experienceList[index].icon == ""
                        ? "https://cdn-icons-png.flaticon.com/128/2098/2098316.png"
                        : "https://s3.ap-south-1.amazonaws.com/job-circle-2/${experienceList[index].icon}",
                    //  "https://cdn-icons-png.flaticon.com/128/10693/10693407.png",
                    fit: BoxFit.contain,
                  ),
                ),
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
                          experienceList[index].shortname != null
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
                /* trailing: InkWell(
                    onTap: () {
                      sendToExperience(experienceList[index]
                          // experience
                          ); // Pass the selected experience object
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, right: 4, bottom: 10),
                      child: Icon(Icons.edit_outlined, size: 18.h),
                    )), */
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
    /* .where((language) =>  //TODO: hide language for recruiter when recruiter view use profile.
            language != "English" &&
            language != "Hindi" &&
            language != "Marathi")
        .toList(); */

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
              /*  const Divider(
                color: Constants.borderColor,
                thickness: 2.5,
                indent: 10,
                endIndent: 18,
                height: 4,
              ), */
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

                  /* Wrap(  //TODO: previous language without limit and different ui.
                    spacing:
                        3, // Adjust the spacing between the language chips
                    runSpacing:
                        0.0, // Remove the spacing between the rows of chips
                    children: filteredLanguages.map((language) {
                      return Chip(
                        label: Text(
                          language,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        backgroundColor: Colors
                            .grey.shade200, // Set the grey background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.grey
                                .shade200, // Set the same color as the background color
                          ),
                        ),
                      );
                    }).toList(),
                  ), */
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

                  /* Wrap(  //TODO: previous all skill without any condition
                    spacing: 3, // Adjust the spacing between the skills chips
                    runSpacing:
                        0.0, // Remove the spacing between the rows of chips
                    children: skills.take(13).map((skill) {
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
                        // Set the grey background color
                      );
                    }).toList(),
                  ), */
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

  // void sendToSkills(Experience experience) async {
  //   var result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SkillsMulti(
  //         prevPageModel: experience,
  //       ),
  //     ),
  //   );
  //   if (result != null) {
  //     experience.skills_exp = result.skills_exp;

  //     setState(() {});
  //   }
  // }

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

  Future<String?> uploadFile(allowExt, String folder) async {
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
      return profilemodel.profile_pic;
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

/* import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/cv.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/profile/screen1.dart';
import 'package:job_circle/screens/profile/screen2.dart';
import 'package:job_circle/screens/profile/screen3.dart';
import 'package:job_circle/screens/profile/screen5.dart';
import 'package:job_circle/screens/profile/screen6.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/customRow.dart';

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({Key? key}) : super(key: key);

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary>
    with TickerProviderStateMixin {
  late Widget previousWidget;
  var profile_final_pic = "";
  var profile_cv_link = "";
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
  final basicForm = GlobalKey<FormState>();
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
    bindProfileSummary();
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
  FocusNode _searchFocusNode = FocusNode();

  void toggleSearchVisibility() {
    setState(() {
      isSearchVisible = !isSearchVisible;
    });
  }

  // bindProfileSummary() async {
  //   SharedPreferences prefs = await Utils.getSharedPreferences();
  //   var result = await UserDataService().getUserDetails(
  //       await Utils.getPreferencesValue(
  //           prefs, ESharedPreferences.user_id.name));
  //   if (Utils.parseResponse(result).resultData) {
  //     print(result);
  //     var dataResult = Utils.parseResponse(result).resultData;
  //     profilemodel = ProfileSummaryModel.fromJson(dataResult);
  //     educationmodel = Education.fromJson(dataResult);
  //     expmodel = Experience.fromJson(dataResult);
  //     profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
  //     profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
  //     profile_cv_file = Utils.getFileName(profile_cv_link);
  //   }
  //   setState(() {});
  // }
  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().getUserDetails(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultData != null) {
      var dataResult = Utils.parseResponse(result).resultData;
      var userData = dataResult["users"];
      var educationData = dataResult["educations"] as List<dynamic>;
      var experienceData = dataResult["experiences"] as List<dynamic>;
      print(userData);
      print(educationData);
      print(experienceData);
      profilemodel = ProfileSummaryModel.fromJson(userData);

      // Check if educationData and experienceData are not empty before converting them
      if (educationData.isNotEmpty) {
        educationList = educationData
            .map((item) => Education.fromMap(item))
            .toList(); // Convert list of educationData into List<Education>
      } else {
        educationList = []; // Empty list if educationData is empty
      }

      if (experienceData.isNotEmpty) {
        experienceList = experienceData
            .map((item) => Experience.fromMap(item))
            .toList(); // Convert list of experienceData into List<Experience>
      } else {
        experienceList = []; // Empty list if experienceData is empty
      }

      // if (profilemodel.profile_pic != null) {
      //   profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      // } else {
      //   // If "profile_pic" is null, provide a default image or handle it accordingly
      // }
      // profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
      // profile_cv_file = Utils.getFileName(profile_cv_link);

      setState(() {});
    }
  }

  bool visible = true;
  bool notvisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: () {
        // Handle tap on the parent widget (outside the Row)
        FocusManager.instance.primaryFocus?.unfocus(); // Unfocus the keyboard
        if (isSearchVisible) {
          setState(() {
            isSearchVisible = false;
            _animationController.reverse(); // Reverse the animation
            _searchFocusNode.unfocus(); // Clear focus when it becomes invisible
          });
        }
      },

      child: Scaffold(
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   iconTheme: const IconThemeData(color: Colors.black),
          //   backgroundColor: Constants.themeBgColorLight,
          //   elevation: 0,
          //   actions: [
          // Row(
          //   children: [
          //     Container(
          //         width: MediaQuery.of(context).size.width / 1.1,
          //         height: 40,
          //         // color: Colors.red,
          //         padding: const EdgeInsets.only(left: 20, right: 30),
          //         child: TextField(
          //             decoration: InputDecoration(
          //           fillColor: Colors.white,
          //           focusedBorder: OutlineInputBorder(
          //               borderSide: const BorderSide(),
          //               borderRadius: BorderRadius.circular(15)),
          //           filled: true,
          //           contentPadding:
          //               const EdgeInsets.only(bottom: 10, left: 5, top: 10),
          //           border: OutlineInputBorder(
          //               /* borderSide:
          //                   const BorderSide(color: Constants.borderColor), */
          //               borderRadius: BorderRadius.circular(15)),
          //           hintText: "${profilemodel.first_name}",
          //         )))
          //   ],
          // )
          //   ],
          // ),

          backgroundColor: Constants.themeBgColorLight,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: profilemodel.first_name == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle tap on the parent widget (outside the Row)
                                  // if (isSearchVisible) {
                                  //   toggleSearchVisibility();
                                  // }
                                },
                                child: Container(
                                  height: 200, // Set the height as needed
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: profilemodel.cover_pic != null
                                          ? NetworkImage(
                                              profilemodel.cover_pic!)
                                          : const NetworkImage(
                                              "https://media.sproutsocial.com/uploads/2018/04/Facebook-Cover-Photo-Size.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: SafeArea(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 140),
                                      Container(
                                        padding: const EdgeInsets.only(top: 17),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  /*  IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                        color:
                                                            Colors.transparent,
                                                      )), */
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween, // Adjust the alignment here
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "${profilemodel.first_name.toString().toTitleCase()} ",
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${profilemodel.last_name.toString().toTitleCase()}",
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              if (profilemodel
                                                                          .dateofbirth !=
                                                                      null &&
                                                                  profilemodel
                                                                      .dateofbirth!
                                                                      .isNotEmpty)
                                                                Text(
                                                                  "(${calculateAge(profilemodel.dateofbirth)} yr's)",
                                                                  style:
                                                                      GoogleFonts
                                                                          .varela(
                                                                    fontSize:
                                                                        13.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              if (profilemodel
                                                                          .bio !=
                                                                      null &&
                                                                  profilemodel
                                                                      .bio!
                                                                      .isNotEmpty)
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      profilemodel
                                                                          .bio!,
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        fontSize:
                                                                            12.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              if (experienceList
                                                                  .isNotEmpty)
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      experienceList
                                                                          .last
                                                                          .job_title
                                                                          .toString(),
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        fontSize:
                                                                            12.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      " at ",
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        fontSize:
                                                                            12.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      experienceList
                                                                          .last
                                                                          .company_name
                                                                          .toString(),
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        fontSize:
                                                                            12.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${capitalizeFirstLetter(profilemodel.user_locality)}, ${capitalizeFirstLetter(profilemodel.user_location)}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      // Edit Icon Column
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end, // Align the icon to the right
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end, // Adjust vertical alignment here
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              sendToBasicInfo();
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              size: 18.h,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 12.h,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Container(
                                                height: 102,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.brown.shade50,
                                                ),
                                                //  padding: const EdgeInsets.all(10.0),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: CustomFieldBlock(
                                                        iconColor:
                                                            Color.fromRGBO(37,
                                                                150, 190, 0),
                                                        imageUrl:
                                                            "https://cdn-icons-png.flaticon.com/128/3135/3135752.png",
                                                        description:
                                                            "Recruiters identify prospective candidates through their CV.",
                                                        buttonText:
                                                            "+ Upload Resume",
                                                        onPressed: () {
                                                          setState(() async {
                                                            var data =
                                                                await uploadFile([
                                                              'pdf',
                                                              'doc'
                                                            ]);
                                                            var payload = {
                                                              "stage":
                                                                  "upload_cv",
                                                              "data": {
                                                                "id": await Utils
                                                                    .getPreferencesValue(
                                                                  null,
                                                                  ESharedPreferences
                                                                      .user_id
                                                                      .name,
                                                                ),
                                                                "cv_link": data[
                                                                    'fileName'],
                                                              },
                                                            };
                                                            await save(
                                                                data[
                                                                    'fileName'],
                                                                payload);
                                                          });
                                                        },
                                                      ),
                                                    ),

                                                    // Block 2: Email
                                                    // Block 2: Email
                                                    // CustomFieldBlock(
                                                    //   imageUrl:
                                                    //       "https://cdn-icons-png.flaticon.com/128/726/726623.png",
                                                    //   description:
                                                    //       "Ensure your contact email",
                                                    //   buttonText: "Verify Now",
                                                    //   onPressed: () {
                                                    //     sendToBasicInfo();
                                                    //   },
                                                    // ),

                                                    // Block 3: Skills
                                                    CustomFieldBlock(
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/10484/10484259.png",
                                                      description:
                                                          "Your Skills Will Connect You with Relevant Job Opportunities",
                                                      buttonText:
                                                          "+ Add Skills",
                                                      onPressed: () {
                                                        sendToSkills(
                                                            Experience());
                                                      },
                                                    ),

                                                    // Block 4: Language
                                                    CustomFieldBlock(
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/3898/3898150.png",
                                                      description:
                                                          "Specify the languages",
                                                      buttonText:
                                                          "+ Add Languages",
                                                      onPressed: () {
                                                        sendToBasicInfo();
                                                      },
                                                    ),
                                                    CustomFieldBlock(
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/5131/5131890.png",
                                                      description:
                                                          "Keep your profile updated with your recent work experience.",
                                                      buttonText:
                                                          "+ Add Experience",
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Screen3(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    CustomFieldBlock(
                                                      imageUrl:
                                                          "https://cdn-icons-png.flaticon.com/128/123/123402.png",
                                                      description:
                                                          "Share Educational detail to maximize your potential.",
                                                      buttonText:
                                                          "+ Add Education",
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Screen2(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: (usertype == 1
                                                  ? true
                                                  : false),
                                              child: experience(
                                                  experienceList ?? []),
                                            ),
                                            Visibility(
                                              visible: (usertype == 1
                                                  ? true
                                                  : false),
                                              child: education(
                                                  educationList ?? []),
                                            ),
                                            Visibility(
                                              visible: usertype == 1,
                                              child: skills(experienceList),
                                            ),
                                            Visibility(
                                              visible: usertype == 1,
                                              child: languages(
                                                  profilemodel.languages ?? []),
                                            ),
                                            Visibility(
                                              visible: (usertype == 1
                                                  ? true
                                                  : false),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3, right: 3),
                                                child: cardCustom(
                                                  icon: Icons.file_copy,
                                                  isedit: false,
                                                  isresume: true,
                                                  title: "",
                                                  child: CVWidget(
                                                    profileCv: ProfileCv(
                                                      cv_link:
                                                          profilemodel.cv_link,
                                                      cv_upladted_date:
                                                          profilemodel
                                                              .cv_upladted_date,
                                                      profile_cv_file: profilemodel
                                                          .cv_link, // Use the same value as cv_link
                                                      profile_cv_link:
                                                          profile_cv_link,
                                                    ),
                                                    onUpload: (fileName,
                                                            payload) async =>
                                                        await save(
                                                            fileName, payload),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle tap on the parent widget (outside the Row)
                                  if (isSearchVisible) {
                                    setState(() {
                                      isSearchVisible = false;
                                      _animationController
                                          .reverse(); // Reverse the animation
                                      _searchFocusNode
                                          .unfocus(); // Clear focus when it becomes invisible
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Handle tap inside the search container (Expanded)
                                          // if (!isSearchVisible) {
                                          //   setState(() {
                                          //     isSearchVisible = true;
                                          //     _animationController
                                          //         .forward(); // Start the animation
                                          //     _searchFocusNode
                                          //         .requestFocus(); // Request focus on the search field when it becomes visible
                                          //   });
                                          // }
                                        },
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: isSearchVisible
                                              ? 1.0
                                              : 0.0, // Fade in/out the search container
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(-1,
                                                  0), // Start from the left side of the screen
                                              end: Offset(0,
                                                  0), // Slide to the center of the screen
                                            ).animate(CurvedAnimation(
                                              parent:
                                                  _animationController, // Use the same animation controller from your code
                                              curve: Curves
                                                  .easeInOut, // Set the desired animation curve
                                            )),
                                            child: Container(
                                              height: 85,
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 12, top: 45),
                                              child: TextField(
                                                focusNode: _searchFocusNode,
                                                style: GoogleFonts.varela(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  filled: true,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 5,
                                                    top: 10,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  hintText:
                                                      "${profilemodel.first_name.toString().toTitleCase()} "
                                                      "${profilemodel.last_name.toString().toTitleCase()}",
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      // Handle tap on the search icon inside the search container
                                                      setState(() {
                                                        isSearchVisible = false;
                                                        _animationController
                                                            .reverse(); // Reverse the animation
                                                        _searchFocusNode
                                                            .unfocus(); // Clear focus on the search field when it becomes invisible
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.search,
                                                      size: 24,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Handle tap on the search icon outside the search container
                                        if (!isSearchVisible) {
                                          setState(() {
                                            isSearchVisible = true;
                                            _animationController
                                                .forward(); // Start the animation
                                            _searchFocusNode
                                                .requestFocus(); // Request focus on the search field when it becomes visible
                                          });
                                        }
                                      },
                                      child: Visibility(
                                        visible: !isSearchVisible,
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              right: 20, top: 55),
                                          child: Icon(
                                            Icons.search,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 128),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 190, 190, 190),
                                            radius: 43,
                                            onBackgroundImageError: ((error,
                                                    stackTrace) =>
                                                Image.asset(
                                                    "assets/images/company.png",
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.contain)),
                                            backgroundImage:
                                                profile_final_pic == null
                                                    ? Image.network(
                                                            profile_final_pic)
                                                        .image
                                                    : Image.asset(
                                                        "assets/images/man.png",
                                                        height: 80,
                                                        width: 80,
                                                        fit: BoxFit.contain,
                                                      ).image,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() async {
                                              var data = await uploadFile(
                                                  ['jpeg', 'jpg']);
                                              var payload = {
                                                "stage": "profile_pic",
                                                "data": {
                                                  "id": await Utils
                                                      .getPreferencesValue(
                                                          null,
                                                          ESharedPreferences
                                                              .user_id.name),
                                                  "profile_pic":
                                                      data['fileName']
                                                }
                                              };
                                              await save(
                                                  data['fileName'], payload);
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 17,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Constants.borderColor,
                                              radius: 12.r,
                                              child: const Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                ),
              )
            ],
          )),
    );
  }

  Widget basicInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, top: 120, right: 3),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              // icon: Icons.account_circle_outlined,
              title: "",
              onPress: (() {
                // Navigator.pushNamed(context, ERoute.screen1.value,
                //     arguments: 1);
                sendToBasicInfo();
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
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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

  Widget educationTitle() {
    return titleCard('Highest Education : ${profilemodel.education}');
  }

  Widget experienceTitle() {
    return titleCard('Work Status : ${profilemodel.experience}');
  }

  Widget education(List<Education> educationList) {
    bool shouldShowAddButton = educationList.isNotEmpty;
    bool showEducation = educationList.isEmpty;

    if (showEducation) {
      return SizedBox(
        child: cardCustom(
          onPress: () {
            // sendToEducation();
          },
          // icons: Icons.school_outlined, // Education icon for the card
          imageUrl: "https://cdn-icons-png.flaticon.com/128/123/123402.png",
          title: "Education",
          child: Row(
            children: [
              Text(
                "Highest Education ",
                style: GoogleFonts.varela(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Screen2(selectedLevel: profilemodel.education),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "${profilemodel.education}",
                        style: GoogleFonts.varela(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (shouldShowAddButton) {
      return SizedBox(
        width: double.infinity,
        child: cardCustom(
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
              final education = educationList[index];
              return Column(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                    leading: Container(
                      width: 70.w,
                      height: 70.h,
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(15),
                      //   border: Border.all(
                      //     color: Colors.transparent,
                      //   ),
                      // ),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/123/123402.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            education.university.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.varela(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            education.level.toString(),
                            style: GoogleFonts.varela(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          education.firstYear.toString(),
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          " - ",
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          education.passingYear.toString(),
                          style: GoogleFonts.varela(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        sendToEducation(education);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 4, bottom: 10),
                        child: Icon(Icons.edit_outlined, size: 18.h),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    } else {
      return SizedBox.shrink(); // Return an empty widget if the list is empty
    }
  }

  Widget experience(List<Experience> experienceList) {
    bool shouldShowAddButton = experienceList.isNotEmpty;
    bool hasExperienceData = profilemodel.experience != null;

    if (experienceList.isEmpty) {
      return SizedBox(
        child: cardCustom(
          onPress: () {
            // sendToEducation();
          },
          // icons: Icons.work_outline,
          imageUrl: "https://cdn-icons-png.flaticon.com/128/9119/9119081.png",
          title: "Employment Details",
          child: Row(
            children: [
              Text(
                "Work Status ",
                style: GoogleFonts.varela(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(), // Added Spacer widget
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Screen3(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "${profilemodel.experience}",
                        style: GoogleFonts.varela(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons
                            .arrow_forward_ios, // Replace this with the icon of your choice
                        size: 16,
                        // color: Colors.greenAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (shouldShowAddButton) {
      return SizedBox(
        width: double.infinity,
        child: cardCustom(
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
            separatorBuilder: (context, index) => SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              final experience = experienceList[index];
              final joiningDate = experience.joining_date;
              final lastWorkingDate = experience.last_working_date;

              final formattedJoiningDate =
                  DateFormat('MMM yyyy').format(joiningDate!);
              final formattedLastWorkingDate =
                  DateFormat('MMM yyyy').format(lastWorkingDate!);
              final duration = lastWorkingDate.difference(joiningDate);
              var totalYears = duration.inDays ~/ 365;
              final totalMonths = (duration.inDays % 365) ~/ 30;

              String experienceText;
              if (totalYears > 0 && totalMonths > 0) {
                experienceText = "${totalYears}y, ${totalMonths}m";
              } else if (totalYears > 0) {
                experienceText = "${totalYears}y";
              } else {
                experienceText = "${totalMonths}m";
              }

// Additional logic to increment totalYears if totalMonths >= 12
              if (totalMonths >= 12) {
                totalYears += 1;
                experienceText = "${totalYears}y";
              }

              return ListTile(
                contentPadding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                leading: Container(
                  width: 70.w,
                  height: 70.h,
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(15),
                  //   border: Border.all(
                  //     color: Colors.transparent,
                  //   ),
                  // ),
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/128/10693/10693407.png",
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  experience.job_title.toString(),
                  style: GoogleFonts.varela(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.company_name.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '$formattedJoiningDate - $formattedLastWorkingDate ($experienceText)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      experience.company_location.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                trailing: InkWell(
                    onTap: () {
                      sendToExperience(
                          experience); // Pass the selected experience object
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 4, bottom: 10),
                      child: Icon(Icons.edit_outlined, size: 18.h),
                    )),
              );
            },
          ),
        ),
      );
    } else {
      return SizedBox.shrink(); // Return an empty widget if the list is empty
    }
  }

  Widget languages(List<dynamic> languages) {
    // Filter out languages other than English, Hindi, and Marathi
    List filteredLanguages = languages
        .where((language) =>
            language != "English" &&
            language != "Hindi" &&
            language != "Marathi")
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 2,
              bottom: 4,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Constants.borderColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                          height: 16,
                          // width: 16,
                          fit: BoxFit
                              .contain, // or BoxFit.cover, depending on your requirement
                          colorBlendMode: BlendMode.clear,
                        ),

                        SizedBox(width: 5),
                        Text(
                          "Languages",
                          style: GoogleFonts.varela(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        sendToLanguges();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 18,
                          bottom: 0,
                        ),
                        child: Icon(Icons.add, size: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Constants.borderColor,
                  thickness: 2.5,
                  indent: 10,
                  endIndent: 18,
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
                      spacing:
                          3, // Adjust the spacing between the language chips
                      runSpacing:
                          0.0, // Remove the spacing between the rows of chips
                      children: filteredLanguages.map((language) {
                        return Chip(
                          label: Text(
                            language,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          backgroundColor: Colors
                              .grey.shade200, // Set the grey background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey
                                  .shade200, // Set the same color as the background color
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget skills(List<Experience> experienceList) {
    List<String> skills = [];

    // Add skills from experienceList
    for (Experience experience in experienceList) {
      if (experience.skills_exp != null) {
        skills.addAll(experience.skills_exp!);
      }
    }

    // Add skills from profilemodel
    if (profilemodel.skills != null) {
      skills.addAll(profilemodel.skills!);
    }

    // Remove duplicates and convert to a list
    skills = skills.toSet().toList();

    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 2,
              bottom: 4,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Constants.borderColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Icon(
                        //   Icons.star_border_outlined,
                        //   size: 16,
                        // ),
                        Image.network(
                          "https://cdn-icons-png.flaticon.com/128/9666/9666850.png",
                          height: 16,
                          // width: 16,
                          fit: BoxFit
                              .contain, // or BoxFit.cover, depending on your requirement
                          colorBlendMode: BlendMode.clear,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Skills",
                          style: GoogleFonts.varela(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        sendToSkills(Experience(skills_exp: skills));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 18,
                          bottom: 0,
                        ),
                        child: Icon(Icons.add, size: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Constants.borderColor,
                  thickness: 2.5,
                  indent: 10,
                  endIndent: 18,
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
                      children: skills.map((skill) {
                        return Chip(
                          label: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          backgroundColor: Colors
                              .grey.shade200, // Set the grey background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey
                                  .shade200, // Set the same color as the background color
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendToSkills(Experience experience) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillsMulti(
          prevPageModel: profilemodel,
          // experienceList: experienceList,
        ),
      ),
    );
    if (result != null) {
      experience.skills_exp = result.skills_exp;
      setState(() {});
    }
  }

  void sendToLanguges() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguageMulti(
          prevPageModel: profilemodel,
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
        builder: (context) => Screen2(selectedLevel: profilemodel.education),
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
      {required String? title,
      IconData? icon,
      IconData? icons,
      Widget? child,
      bool? isskiil = false,
      bool? isresume = false,
      bool? isedit = true,
      Function()? onPress,
      String? imageUrl}) {
    bool shouldShowExperienceAddButton = experienceList.isNotEmpty;
    bool shouldShowEducationAddButton = educationList.isNotEmpty;

    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Constants.borderColor),
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
                Image.network(
                  imageUrl!,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              SizedBox(width: 5),
              if (isresume == false)
                Text(
                  title.toString(),
                  style: GoogleFonts.varela(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
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
                                builder: (context) => Screen3(),
                              ),
                            );
                          } else if (title == "Education") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Screen2(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 14,
                            bottom: 0,
                            top: 0,
                          ),
                          // child: Icon(Icons.add, size: 18.h),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons
                                  .add, // Replace this with the icon of your choice
                              size:
                                  16, // Replace this with the size of the icon
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
              thickness: 2.5.w,
            ),
          Container(
            padding: const EdgeInsets.only(top: 0),
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

  sendToBasicInfo() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen1(
          prevPageModel: profilemodel,
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

  sendToEducation(Education education) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen2(
          prevPageModel: education,
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

  sendToExperience(Experience experience) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen3(
          prevPageModel: experience,
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

  // void sendToSkills(Experience experience) async {
  //   var result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SkillsMulti(
  //         prevPageModel: experience,
  //       ),
  //     ),
  //   );
  //   if (result != null) {
  //     experience.skills_exp = result.skills_exp;

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
