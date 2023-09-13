import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/models/add_resume_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/enums.dart';
import '../../models/get_user_for_add_Resume.dart';
import '../../models/profileSummary.dart';
import '../../service/FileUploadService.dart';
import '../../service/UserDataService.dart';
import '../../service/data_get_api_service.dart';
import '../../service/job_post_api_service.dart';
import '../../themes/colors.dart';

class AddResume extends StatefulWidget {
  final String company_name, role, process, nature_of_work, sourceName;
  final int company_id, jobId, spocId, sourceId;
  final bool isRefer;

  const AddResume(
      {super.key,
      required this.company_name,
      required this.role,
      required this.process,
      required this.nature_of_work,
      required this.company_id,
      required this.jobId,
      required this.sourceId,
      required this.sourceName,
      required this.spocId,
      required this.isRefer});

  @override
  State<AddResume> createState() => _AddResumeState();
}

class _AddResumeState extends State<AddResume> {
  @override
  void initState() {
    //fetchData();
    // TODO: implement initState
    super.initState();
  }

  ProfileSummaryModel profilemodel = ProfileSummaryModel();

  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromJson(dataResult);

      // user_selected_lcoation = user_selected_lcoation;
    }
    setState(() {});
  }

  TextEditingController firt_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController primary_number = TextEditingController();
  TextEditingController secondry = TextEditingController();
  bool graduate = false,
      underGraduate = false,
      experience = false,
      fresher = false;

  bool isFirstName = false;
  bool isLastName = false;
  bool isprimaryNumber = false;
  bool isSecondaryNumber = false;

  FocusNode text1 = FocusNode();
  FocusNode text2 = FocusNode();
  FocusNode text3 = FocusNode();
  FocusNode text4 = FocusNode();

  String? icon_data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffedf6f9),
      appBar: AppBar(
          title: const Text(
            "Candidate Detail's",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: const Color(0xfff729995)),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(1, 1),
                            blurRadius: 1.1,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(8.r),
                      // border: Border.all(color: Constants.borderColor)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r)),
                            color: const Color(0xfffb4d8d4),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          child: Text(
                            "Candidate Name",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 20.sp,
                                color: const Color(0xfff729995),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /*  isFirstName
                            ? customContainerSelect(
                                isVacancy: true,
                                isCross: true,
                                //isNumOfOpening: true,
                                onPressed: () {
                                  setState(() {
                                    isFirstName = false;
                                    // FocusScope.of(context).autofocus(focusNode);
                                    firt_name.clear();
                                    // numberOfOpeneningFocus.requestFocus();
                                  });
                                },
                                isSelect: true,
                                title: firt_name.text,
                                heading: "First Name")
                            : */
                        CustomTextField(
                            context: context,
                            controller: firt_name,
                            title: "First Name",
                            hintText: "Rahul",
                            isNumber: false,
                            focusNode1: text1,
                            isLastName: false),
                        const SizedBox(
                          height: 5,
                        ),
                        /*  isFirstName
                            ? customContainerSelect(
                                isVacancy: true,
                                isCross: true,
                                onPressed: () {
                                  setState(() {
                                    isFirstName = false;
                                    // FocusScope.of(context).autofocus(focusNode);
                                    last_name.clear();
                                    // numberOfOpeneningFocus.requestFocus();
                                  });
                                },
                                isSelect: true,
                                title: last_name.text,
                                heading: "Last Name")
                            : */
                        CustomTextField(
                            context: context,
                            controller: last_name,
                            title: "Last Name",
                            isLastName: true,
                            focusNode1: text2,
                            hintText: "Sharma",
                            isNumber: false),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(1, 1),
                            blurRadius: 1.1,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(8.r),
                      //border: Border.all(color: Constants.borderColor)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r)),
                            color: const Color(0xfffb4d8d4),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          child: Text(
                            "Contact No.'s",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 20.sp,
                                color: const Color(0xfff729995),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /* isFirstName
                            ? customContainerSelect(
                                isVacancy: true,
                                isCross: true,
                                //isNumOfOpening: true,
                                onPressed: () {
                                  setState(() {
                                    isFirstName = false;
                                    // FocusScope.of(context).autofocus(focusNode);
                                    primary_number.clear();
                                    // numberOfOpeneningFocus.requestFocus();
                                  });
                                },
                                isSelect: true,
                                title: primary_number.text,
                                heading: "Primary Number")
                            : */
                        CustomTextField(
                            context: context,
                            controller: primary_number,
                            title: "Primary Number",
                            isLastName: false,
                            hintText: "956846****",
                            focusNode1: text3,
                            isNumber: true),
                        const SizedBox(
                          height: 5,
                        ),
                        /*  isFirstName
                            ? customContainerSelect(
                                isVacancy: true,
                                isCross: true,
                                onPressed: () {
                                  setState(() {
                                    isFirstName = false;
                                    // FocusScope.of(context).autofocus(focusNode);
                                    secondry.clear();
                                    // numberOfOpeneningFocus.requestFocus();
                                  });
                                },
                                isSelect: true,
                                title: secondry.text,
                                heading: "Secondary Number")
                            : */
                        CustomTextField(
                            context: context,
                            controller: secondry,
                            title: "Secondary Number",
                            isLastName: false,
                            hintText: "856495****",
                            focusNode1: text4,
                            isNumber: true),
                        Padding(
                          padding: const EdgeInsets.only(right: 14, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Optional",
                                style: GoogleFonts.varela(
                                  fontSize: 8,
                                  color: const Color(0xfff729995),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(1, 1),
                            blurRadius: 1.1,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(8.r),
                      //border: Border.all(color: Constants.borderColor)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  topRight: Radius.circular(8.r)),
                              color: const Color(0xfffb4d8d4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: Text(
                              "Education",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 20.sp,
                                  color: const Color(0xfff729995),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    graduate = false;
                                    underGraduate = true;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: underGraduate
                                          ? const Color(0xfffedf6f9)
                                          : Colors.white),
                                  child: Center(
                                    child: Text("Under-Graduate",
                                        style: GoogleFonts.sourceSansPro(
                                            color: underGraduate
                                                ? const Color(0xfff729995)
                                                : Colors.grey,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    graduate = true;
                                    underGraduate = false;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  margin: const EdgeInsets.only(
                                      right: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: graduate
                                          ? const Color(0xfffedf6f9)
                                          : Colors.white),
                                  child: Center(
                                    child: Text("Graduate or Above",
                                        style: GoogleFonts.sourceSansPro(
                                            color: graduate
                                                ? const Color(0xfff729995)
                                                : Colors.grey,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(1, 1),
                            blurRadius: 1.1,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(8.r),
                      //border: Border.all(color: Constants.borderColor)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  topRight: Radius.circular(8.r)),
                              color: const Color(0xfffb4d8d4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: Text(
                              "Work Status",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 20.sp,
                                  color: const Color(0xfff729995),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    fresher = true;
                                    experience = false;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: fresher
                                          ? const Color(0xfffedf6f9)
                                          : Colors.white),
                                  child: Center(
                                    child: Text("Fresher",
                                        style: GoogleFonts.sourceSansPro(
                                            color: fresher
                                                ? const Color(0xfff729995)
                                                : Colors.grey,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    fresher = false;
                                    experience = true;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  margin: const EdgeInsets.only(
                                      right: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: experience
                                          ? const Color(0xfffedf6f9)
                                          : Colors.white),
                                  child: Center(
                                    child: Text("Experience",
                                        style: GoogleFonts.sourceSansPro(
                                            color: experience
                                                ? const Color(0xfff729995)
                                                : Colors.grey,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(1, 1),
                            blurRadius: 1.1,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(8.r),
                      //border: Border.all(color: Constants.borderColor)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  topRight: Radius.circular(8.r)),
                              color: const Color(0xfffb4d8d4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Pursuing For",
                                  style: GoogleFonts.sourceSansPro(
                                      fontSize: 20.sp,
                                      color: const Color(0xfff729995),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  "(${widget.company_name})",
                                  style: GoogleFonts.sourceSansPro(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin: const EdgeInsets.only(
                                    left: 10, bottom: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: const Color(0xfffedf6f9)),
                                child: Text(widget.process.toString(),
                                    style: GoogleFonts.sourceSansPro(
                                        color: const Color(0xfff729995),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    fresher = false;
                                    experience = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: const Color(0xfffedf6f9)),
                                  child: Text(widget.role.toString(),
                                      style: GoogleFonts.sourceSansPro(
                                          color: const Color(0xfff729995),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              var data =
                                  await uploadFile(['pdf', 'doc', 'docx']);
                              if (data != null) {
                                setState(() {
                                  icon_data = data;
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              // width: double.maxFinite,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xfff729995)),
                                borderRadius: BorderRadius.circular(8.r),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/cv.png",
                                    height: 15.h,
                                    color: const Color(0xfff729995),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    icon_data != null
                                        ? "Update Resume"
                                        : "Add Resume",
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 18.sp,
                                        color: const Color(0xfff729995),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                icon_data != null ? icon_data.toString() : "",
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 8.sp,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xfff729995),
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Word or pdf file.",
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 8.sp,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xfff729995),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          submit();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, bottom: 20, right: 20),
                          // width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: const Color(0xfff60807c),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 16),
                          child: Text(
                            "Submit",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 5, sigmaY: 5), // Adjust blur intensity as needed
                  child: const Center(
                    child: AbsorbPointer(
                      absorbing:
                          true, // Prevent interaction with elements behind
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  String? _filePath;

  //TODO: old code to upload file.

  /*  Future uploadFile(allowExt) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowExt,
        withReadStream: true);

    if (result != null) {
      var res = await FileUploadService()
          .uploadSingleFile("icon", result.files.single);
      var resultD = Utils.parseResponse(res);
      // Navigator.pop(context);

      if (resultD.resultKey == 'SUCCESS') {
        // Extract the filename from the path
        String filePath = result.files.single.path ?? '';
        String filename = filePath.split('/').last;

        print("Filename: $filename"); // Debugging print
        return filename;
      } else {
        Navigator.pop(context);
        return null;
      }
    } else {
      Navigator.pop(context);
      return null;
    }
  } */

  Future<String?> uploadFile(allowExt) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile("cv", result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          print(filename);
          print("Filename: $filePath");

          // Close the loading dialog when the upload is successful
          Navigator.pop(context);

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
      return null;
    }
  }

  /*  Future<void> pickAndUploadPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String? _filePath = result.files.single.path;

        if (_filePath != null) {
          var apiUrl = Uri.parse(
              'http://${GlobalConstants.API_Host}/files/v1/multiUpload');

          var request = http.MultipartRequest('POST', apiUrl);

          // Add custom headers here
          request.headers['Authorization'] = 'Bearer your_access_token';
          // Add more headers if needed

          request.files
              .add(await http.MultipartFile.fromPath('file', _filePath));

          final response = await request.send();

          if (response.statusCode == 200) {
            final responseJson =
                jsonDecode(await response.stream.bytesToString());
            // Handle the response data here
            print('Response: $responseJson');
          } else {
            print('Upload failed with status ${response.statusCode}');
          }
        } else {
          print('File path is null.');
        }
      } else {
        print('User canceled the file picking or selected a non-PDF file');
      }
    } catch (e) {
      print('Error during file upload: $e');
    }
  } */

  List<UserDataForAddResumeModelResultData>? applicationList = [];
  void fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      ApplicationAPI api = ApplicationAPI();
      applicationList =
          await api.getUserForAddResume(int.parse(primary_number.text));
      if (widget.isRefer) {
        if (applicationList![0].id == 0) {
          // Call the `addResume` function with the specific data
          final addResumeModel = JobApplicationModel(
              resume: icon_data,
              isRef: 1,
              uid: 0,
              id: 0,
              applicantName: "${firt_name.text} ${last_name.text}",
              lastName: last_name.text,
              contactNo: int.parse(primary_number.text.trim()),
              qualification: graduate == true ? "Graduate" : "Under Graduate",
              isExperienced: fresher ? 0 : 1,
              companyName: widget.company_name,
              process: widget.process,
              level: widget.role,
              naturofwork: widget.nature_of_work,
              shortListFor: widget.company_id,
              status: "TP1",

              // subStatus: "Shortlist",
              sourceId: widget.sourceId,
              sourceName: widget.sourceName,
              jobid: widget.jobId,
              spoc: widget.spocId,
              dos: DateTime.now()
              // ... fill in other properties as needed
              );
          final jsonData = addResumeModel.toJson();
          await JobPostApiService.addResume(jsonData, context, false);
          setState(() {
            isLoading = false;
          });
        } else {
          // Call the `addResume` function with a different set of data
          final addResumeModel = JobApplicationModel(
              isRef: 1,
              resume: icon_data,
              uid: applicationList![0].id,
              id: 0,
              applicantName:
                  "${applicationList![0].firstName} ${applicationList![0].lastName}",
              lastName: applicationList![0].lastName,
              contactNo: int.parse(primary_number.text.trim()),
              qualification: graduate == true ? "Graduate" : "Under Graduate",
              isExperienced: fresher ? 0 : 1,
              companyName: widget.company_name,
              process: widget.process,
              level: widget.role,
              naturofwork: widget.nature_of_work,
              shortListFor: widget.company_id,
              status: "TP1",
              // subStatus: "Shortlist",
              sourceId: widget.sourceId,
              sourceName: widget.sourceName,
              jobid: widget.jobId,
              alternateNo: int.parse(secondry.text.trim()),
              spoc: widget.spocId,
              dos: DateTime.now());
          final jsonData = addResumeModel.toJson();
          await JobPostApiService.addResume(jsonData, context, false);
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (applicationList![0].id == 0) {
          // Call the `addResume` function with the specific data
          final addResumeModel = JobApplicationModel(
              isRef: 1,
              uid: 0,
              resume: icon_data,
              id: 0,
              applicantName: "${firt_name.text} ${last_name.text}",
              lastName: last_name.text,
              contactNo: int.parse(primary_number.text.trim()),
              qualification: graduate == true ? "Graduate" : "Under Graduate",
              isExperienced: fresher ? 0 : 1,
              companyName: widget.company_name,
              process: widget.process,
              level: widget.role,
              naturofwork: widget.nature_of_work,
              shortListFor: widget.company_id,
              status: "IB4",
              subStatus: "Shortlist",
              sourceId: widget.sourceId,
              sourceName: widget.sourceName,
              jobid: widget.jobId,
              spoc: widget.spocId,
              dos: DateTime.now()
              // ... fill in other properties as needed
              );
          final jsonData = addResumeModel.toJson();
          await JobPostApiService.addResume(jsonData, context, false);
          setState(() {
            isLoading = false;
          });
        } else {
          // Call the `addResume` function with a different set of data
          final addResumeModel = JobApplicationModel(
              isRef: 1,
              uid: applicationList![0].id,
              id: 0,
              resume: icon_data,
              applicantName:
                  "${applicationList![0].firstName.toString()} ${applicationList![0].lastName.toString()}",
              lastName: applicationList![0].lastName.toString(),
              contactNo: int.parse(primary_number.text.trim()),
              qualification: graduate == true ? "Graduate" : "Under Graduate",
              isExperienced: fresher ? 0 : 1,
              companyName: widget.company_name.toString(),
              process: widget.process.toString(),
              level: widget.role.toString(),
              naturofwork: widget.nature_of_work.toString(),
              shortListFor: widget.company_id.toInt(),
              status: "IB4",
              subStatus: "Shortlist",
              sourceId: widget.sourceId.toInt(),
              sourceName: widget.sourceName.toString(),
              jobid: widget.jobId.toInt(),
              //alternateNo: int.parse(secondry.text),
              spoc: widget.spocId.toInt(),
              dos: DateTime.now());
          final jsonData = addResumeModel.toJson();
          await JobPostApiService.addResume(jsonData, context, false);
          setState(() {
            isLoading = false;
          });
        }
      }

      // Use the applicationList as needed
      // For example, you can print the groupName of each Application object:
      // for (var application in applicationList) {
      // print(applicationList.map((e) => e.value));
      // }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  bool isLoading = false;

  void submit() async {
    if (firt_name.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
            subtitle: "First name is mandatory",
            onClose: () {
              Navigator.pop(context);
              text1.requestFocus();
            },
          );
        },
      );
    } else if (last_name.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              onClose: () {
                Navigator.pop(context);
                text2.requestFocus();
              },
              subtitle: "Last Name is mandatory");
        },
      );
    } else if (primary_number.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              onClose: () {
                Navigator.pop(context);
                text3.requestFocus();
              },
              subtitle: "Primary number is mandatory");
        },
      );
    } else if (graduate == false && underGraduate == false) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              onClose: () {
                Navigator.pop(context);
                // text3.requestFocus();
              },
              subtitle: "Select any one option from education");
        },
      );
    } else if (fresher == false && experience == false) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              onClose: () {
                Navigator.pop(context);
                // text3.requestFocus();
              },
              subtitle: "Select any one option from work status");
        },
      );
    } else if (primary_number.text.length < 10) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              onClose: () {
                Navigator.pop(context);
                // text3.requestFocus();
              },
              subtitle: "Number should have 10 digit");
        },
      );
    } else if (icon_data == null) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              onClose: () {
                Navigator.pop(context);
                text2.requestFocus();
              },
              subtitle: "Add resume first");
        },
      );
    } else {
      fetchData();
      /*  JobApplicationModel addResumeModel = JobApplicationModel(
      
        uid: 0,
        id: 0,
        applicantName: "firt_name.text",
        lastName: "lastname",
        contactNo: 8446265646,
        qualification: "Under Graduate",
        isExperienced: 1,
        companyName: "ICICI Lombard",
        process: "E-Channel",
        level: "Sales Advisor",
        naturofwork: "Outbound",
        shortListFor: 2,
        status: "MP4",
        subStatus: "Shortlist",
        sourceId: 2,
        sourceName: widget.sourceName,
        jobid: 243,
        // ... fill in other properties as needed
      );
      Map<String, dynamic> jsonData = addResumeModel.toJson();
      JobPostApiService.addResume(jsonData, context); */
    }
  }

  final TextCapitalization _textCapitalization = TextCapitalization.sentences;

  Container CustomTextField(
      {required BuildContext context,
      required TextEditingController controller,
      required String title,
      required String hintText,
      required bool isLastName,
      required FocusNode focusNode1,
      required bool isNumber}) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5.h),
              height: MediaQuery.of(context).size.height / 25.h,
              color: Colors.white,
              child: TextFormField(
                focusNode: focusNode1,
                cursorColor: const Color(0xfff729995),
                textCapitalization: _textCapitalization,
                style: const TextStyle(color: Color(0xfff729995)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This Text field Cant be empty";
                  }
                  return null;
                },

                inputFormatters: isNumber
                    ? [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ]
                    : isLastName
                        ? [
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[^a-zA-Z]'))
                          ]
                        : [
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[^a-zA-Z\s]'))
                          ],
                // focusNode: numberOfOpeneningFocus,
                // maxLength: 3,
                /*   onFieldSubmitted: (value) {
                  setState(() {
                    focusNode1.nextFocus();
                    // _showContainer1 = value.isEmpty;
                  });
                }, */

                onTapOutside: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                /* onEditingComplete: () {
                  firt_name.text.isNotEmpty
                      ? setState(() {
                          isFirstName = true;
                          // _showContainer1 = value.isEmpty;
                        })
                      : null;
                }, */
                keyboardType: isNumber
                    ? TextInputType.number
                    : TextInputType.streetAddress,
                controller: controller,

                //enabled: enableShortListFor,
                onTap: (() {}),
                maxLength: isNumber ? 10 : 15,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 10, right: 10),

                    // suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                    // Icons.workspace_premium
                    // label: const Text("Company Name *"),
                    //border: OutlineInputBorder(),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xfff729995)),
                    ),
                    focusColor: const Color(0xfff729995),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xfff729995)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xfff729995)),
                    ),
                    labelText: title,
                    labelStyle: const TextStyle(color: Color(0xfff729995)),
                    hintText: hintText,
                    hintStyle: GoogleFonts.sourceSansPro(
                        color: Constants.subtitleclr, fontSize: 15.sp)
                    //  prefixIcon: Icon(Icons.list)
                    ),
              ),
            ),
          ],
        ));
  }

  /*  Widget customContainerSelect(
      {required final VoidCallback onPressed,
      required bool isSelect,
      required String title,
      required String heading,
      bool isHalf = false,
      bool isVacancy = false,
      bool isNumOfOpening = false,
      bool isAnother = false,
      bool isCross = false,
      bool isExp = false,
      bool? isSalary = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: GoogleFonts.sourceSansPro(
                fontSize: 18.sp,
                // color: Colors.grey.shade500,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
              onTap: onPressed,
              child: Container(
                  width: double.maxFinite,
                  // height: MediaQuery.of(context).size.height / 26.h,
                  margin: const EdgeInsets.only(top: 5, bottom: 5, right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelect
                        ? const Color(0xfff310d44)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: isSelect
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isSalary!
                                ? const Icon(
                                    Icons.currency_rupee_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                : const SizedBox(),
                            Text(title,
                                style: GoogleFonts.sourceSansPro(
                                    color: Colors.white, fontSize: 15.sp)),
                            isVacancy
                                ? const Spacer()
                                : const SizedBox(
                                    width: 5,
                                  ),
                            isCross
                                ? Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 15.h,
                                  )
                                : const Icon(
                                    Icons.check,
                                    size: 15,
                                    color: Colors.white,
                                  )
                          ],
                        )
                      : Text(title,
                          style: GoogleFonts.sourceSansPro(fontSize: 15.sp)))),
        ],
      ),
    );
  } */
}
