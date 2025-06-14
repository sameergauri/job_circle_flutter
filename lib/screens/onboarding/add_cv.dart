// ignore_for_file: unused_result, unused_local_variable, avoid_unnecessary_containers, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:ui';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/models/user_data_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/screens/new_jobs/job_provider.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCv extends ConsumerStatefulWidget {
  final int userID;
  final UserRequest introData;
  final ExperienceRequest? experience;
  final EducationRequest? educationRequest;
  final bool isexperience;
  final bool isUnderGraduate;
  final List<dynamic>? selectedSkillSet;
  final CertificationRequest? certificationRequest;

  /*  final Map<String, dynamic> params;
  final int userID; */
  // const AddCv({super.key, required this.params, required this.userID});
  const AddCv(
      {required this.userID,
      required this.introData,
      required this.isexperience,
      required this.isUnderGraduate,
      this.educationRequest,
      this.certificationRequest,
      this.experience,
      this.selectedSkillSet,
      super.key});

  @override
  ConsumerState<AddCv> createState() => _AddCvState();
}

class _AddCvState extends ConsumerState<AddCv> {
  FileUploader fileUploader = FileUploader();
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  String? resume;

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return resume != null
        ? WillPopScope(
            onWillPop: () async {
              // Returning false disables the back button
              return false;
            },
            child: Stack(
              children: [
                Scaffold(
                  floatingActionButton: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: IconButton(
                            onPressed: () async {
                              await FileUploadService()
                                  .deleteSingleFile(resume!);
                              ref.refresh(userDataProvider);
                              // Navigator.pop(context);
                              setState(() {
                                resume = null;
                              });
                            },
                            icon: const Icon(Icons.delete_outline_outlined,
                                color: Constants.darkBlue)),
                      ),

                      /*  SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: CustomButtonForSave(
                          isBorder: true,
                          textColor: Constants.darkBlue,
                          buttonColor: Colors.white,
                          title: "Update",
                          onTap: () async {
                            resume = await fileUploader.uploadFile(
                                context, ['pdf'], "resume");
                            setState(() {});
                          },
                        ),
                      ), */
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: CustomButtonForSave(
                            onTap: () {
                              Save();
                            },
                            title: "Submit"),
                      )
                    ],
                  ),
                  body: Container(
                    child: FutureBuilder<PDFDocument>(
                      future: PDFDocument.fromURL(
                          "https://s3.ap-south-1.amazonaws.com/job-circle-2/$resume"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
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
                ),
                isloading
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      )
                    : const SizedBox(),
                isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Constants.themeBgColor,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          )
        : Stack(
            children: [
              Scaffold(
                bottomNavigationBar: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (resume == null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: CustomButtonForSave(
                            isBorder: true,
                            textColor: Constants.darkBlue,
                            buttonColor: Colors.white,
                            onTap: () async {
                              Skip();
                            },
                            title: "Skip"),
                      ),
                    if (resume != null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: CustomButtonForSave(
                          title: "Submit",
                          onTap: () {
                            Save();
                          },
                        ),
                      ),
                  ],
                ),
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Constants.borderColor,
                  automaticallyImplyLeading: true,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Constants.black),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OnboardingAppBarHeading(),
                      OnboardingAppBarSubTitle()
                    ],
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.sp, left: 10.sp, right: 10.sp),
                        child: LinearProgressIndicator(
                          value: resume != null ? 1 : 0.835,
                          // value: _calculateProgress(, // Set progress value
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Constants.darkBlue),
                          minHeight: 9.9.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.sp, top: 10.sp, bottom: 10.sp, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const OnboardingTitle(
                              title: "Upload your Resume",
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomDocumentUploadButton(
                                onTab: () async {
                                  resume = await fileUploader.uploadFile(
                                      context, ['pdf'], "resume");

                                  /*  resume = await uploadFile(['pdf'], "cv"); */
                                  /*  var payload = {
                                    "stage": "upload_cv",
                                    "data": {
                                      "id": await Utils.getPreferencesValue(
                                          null, ESharedPreferences.user_id.name),
                                      "cv_link": resume
                                    }
                                  };
                                  save(resume, payload); */
                                  setState(() {});
                                },
                                title: "Add Resume"),
                            SizedBox(
                              height: 10.h,
                            ),
                            const customTextForWeather(
                              title:
                                  "- Uploading your resume increases your visibility to recruiters, enhancing your job search experience.\n\n- Ensure your resume is up-to-date and relevant to maximize your opportunities.",
                              fontSize: 10,
                              color: Constants.subtitleclr,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              isloading
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    )
                  : const SizedBox(),
              isloading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Constants.themeBgColor,
                      ),
                    )
                  : const SizedBox()
            ],
          );
  }

  Skip() async {
    setState(() {
      isloading = true;
    });
    var prefs = await Utils.getSharedPreferences();

    var userTocken = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_token.name);

    UserRequest updatedUser = widget.introData.copyWith(
      cvUpdatedDate: "2025-01-27",
      reportTo: 0,
    );
    UserData userData = UserData(
      userRequest: updatedUser,
      certificationsRequest: widget.certificationRequest != null
          ? [widget.certificationRequest!]
          : [],
      /*    ? [widget.certificationRequest!]
          : [], */ // Use an empty list if null
      educationRequest:
          widget.educationRequest != null ? [widget.educationRequest!] : [],
      experienceRequest: widget.experience != null ? [widget.experience!] : [],
    );
    await saveUserData(userData, userTocken);
    /* ref.refresh(fetchAllApplyProvider);
    ref.refresh(fetchAllTalentPoolProvider);
    ref.refresh(userDataProvider);
    ref.refresh(profileSummaryProvider);
    ref.refresh(fetchAllApplicantProvider); */
  }

  Save() async {
    setState(() {
      isloading = true;
    });
    var prefs = await Utils.getSharedPreferences();

    var userTocken = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_token.name);
    UserRequest updatedUser = widget.introData.copyWith(
      cvLink: resume,
      cvUpdatedDate: "2025-01-27",
      reportTo: 0,
    );
    UserData userData = UserData(
      userRequest: updatedUser,
      certificationsRequest: widget.certificationRequest != null
          ? [widget.certificationRequest!]
          : [], // Use an empty list if null
      educationRequest:
          widget.educationRequest != null ? [widget.educationRequest!] : [],
      experienceRequest: widget.experience != null ? [widget.experience!] : [],
    );
    await saveUserData(userData, userTocken);
    /*  ref.refresh(fetchAllApplyProvider);
    ref.refresh(fetchAllTalentPoolProvider);
    ref.refresh(userDataProvider);
    ref.refresh(profileSummaryProvider);
    ref.refresh(fetchAllApplicantProvider); */
  }

  Future<void> saveUserData(UserData requestBody, String token) async {
    SharedPreferences pres = await Utils.getSharedPreferences();
    String url =
        'http://${GlobalConstants.API_Host}/users/v1/save?token=$token';

    try {
      // Headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("User data saved successfully!");
        Utils.clearAllSharedPreferences;
        print("Response: ${response.body}");

        final parsedResponse = await json.decode(response.body);
        print("User Body:$parsedResponse");
        final userType = await parsedResponse['resultData']['profile']
            ['userResponse']['userType'];
        await Utils.setPreference(
            pres, ESharedPreferences.user_type.name, userType.toString());
        final userId = parsedResponse['resultData']['profile']['userResponse']
                ['id']
            .toString();
        await Utils.setPreference(
            pres, ESharedPreferences.user_id.name, userId.toString());
        var rawdata =
            await parsedResponse['resultData']['profile']['userResponse'];
        await Utils.setPreference(
            pres, ESharedPreferences.user_data.name, rawdata);
        int mobile = await parsedResponse['resultData']['profile']
            ['userResponse']['mobile'];
        await Utils.setPreference(
            pres, ESharedPreferences.user_mobile.name, mobile.toString());
        int usertype = await parsedResponse['resultData']['profile']
            ['userResponse']['userType'];
        ref.refresh(profileSummaryProvider);
        ref.read(jobListProvider.notifier).fetchInitialJobs();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
        setState(() {
          isloading = false;
        });
      } else {
        var jsonResponse = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialogueForAddResume(
                error: true,
                onClose: () {
                  setState(() {
                    isloading = false;
                  });
                  Navigator.pop(context);
                },
                subtitle: jsonResponse['errorMessage']
                // "Error while doing signup process please try after some time",
                );
          },
        );
        print(
            "Signu Up Failed to save user data. Status code: ${response.statusCode}");
        print("Error: ${response.body}");
        print("Response: ${response.headers}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  /* Future<String?> Delete(bool iscv) async {
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
  } */

  save(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'upload_cv') {
        profilemodel.cv_link = filePath;

        profilemodel.cv_upladted_date =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }
}
