// ignore_for_file: unused_field, unused_result, non_constant_identifier_names, use_full_hex_values_for_flutter_colors, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, unused_local_variable
// ignore_for_file: todo
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/cuustom_radio_button.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/models/job_detail/job_detail_page_model.dart';
import 'package:job_circle/models/refer_add_resume_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_container_for_gender.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/referral_page.dart';
// import 'package:pdftron_flutter/pdftron_flutter.dart' as pdftron;
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:document_viewer/document_viewer.dart';
import '../../enums/enums.dart';
import '../../service/FileUploadService.dart';
import '../../service/job_post_api_service.dart';
import '../../themes/colors.dart';

class AddResume extends ConsumerStatefulWidget {
  final String company_name, role, process, nature_of_work, interviewRounds;
  final int company_id, jobId, spocId;

  final bool is90;
  final bool is30;
  final int userNumber;
  final int useAlternateNumber;
  final PayoutDetails payoutDetails;

  const AddResume({
    super.key,
    required this.company_name,
    required this.role,
    required this.process,
    required this.nature_of_work,
    required this.company_id,
    required this.jobId,
    required this.spocId,
    required this.is90,
    required this.is30,
    required this.userNumber,
    required this.useAlternateNumber,
    required this.interviewRounds,
    required this.payoutDetails,
  });

  @override
  ConsumerState<AddResume> createState() => _AddResumeState();
}

class _AddResumeState extends ConsumerState<AddResume> {
  @override
  void initState() {
    //fetchData();

    // TODO: implement initState
    super.initState();
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

  bool termAndConditionOne = false, termAndConditionTwo = false;
  FocusNode firstname = FocusNode();
  FocusNode lastname = FocusNode();
  FocusNode prinumber = FocusNode();
  FocusNode seconumber = FocusNode();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: const Color(0xfffedf6f9), //TODO: old background color
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Add this line

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Constants.borderColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingTitle(
              title: widget.role.toString(),
            ),
            Row(
              children: [
                customTextForWeather(
                  title: widget.process,
                  fontSize: 12,
                  color: Constants.black,
                ),
                const customTextForWeather(
                    title: " || ", fontSize: 14, color: Constants.black),
                customTextForWeather(
                    title: widget.nature_of_work,
                    fontSize: 14,
                    color: Constants.black),
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                      title: "Referral profile detail",
                      fontSize: 14,
                      color: Constants.black,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const customTextForWeather(
                      title: "Candidate First Name*",
                    ),
                    CustomTextFieldforAll(
                      focusNode: firstname,
                      controller: firt_name,
                      hint: "Enter First Name",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const customTextForWeather(
                      title: "Candidate Last Name*",
                    ),
                    CustomTextFieldforAll(
                      focusNode: lastname,
                      controller: last_name,
                      hint: "Enter Last Name",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const customTextForWeather(
                      title: "Contact Number*",
                    ),
                    CustomTextFieldforAll(
                      maxLength: 10,
                      focusNode: prinumber,
                      isNumber: true,
                      controller: primary_number,
                      hint: "Enter Contact Number",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const customTextForWeather(
                      title: "Alternate Number",
                    ),
                    CustomTextFieldforAll(
                      maxLength: 10,
                      focusNode: seconumber,
                      controller: secondry,
                      isNumber: true,
                      hint: "Enter Alternate Number",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const customTextForWeather(
                      title: "Level of Education*",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainerForGender(
                          onPressed: () {
                            setState(() {
                              graduate = false;
                              underGraduate = true;
                            });
                          },
                          isSelect: underGraduate,
                          title: "Under - Graduate",
                        ),
                        CustomContainerForGender(
                          onPressed: () {
                            setState(() {
                              graduate = true;
                              underGraduate = false;
                            });
                          },
                          isSelect: graduate,
                          title: "Graduate & Above",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const customTextForWeather(
                      title: "Level of Work Status*",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainerForGender(
                          onPressed: () {
                            setState(() {
                              experience = false;
                              fresher = true;
                            });
                          },
                          isSelect: fresher,
                          title: "Fresher",
                        ),
                        CustomContainerForGender(
                          onPressed: () {
                            setState(() {
                              experience = true;
                              fresher = false;
                            });
                          },
                          isSelect: experience,
                          title: "Experience",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (icon_data == null)
                      CustomDocumentUploadButton(
                        onTab: () async {
                          FileUploader fileUploader = FileUploader();
                          var data = await fileUploader.uploadFile(
                              context, ['pdf'], "resume");

                          if (data != null) {
                            setState(() {
                              icon_data = data;
                            });
                          }
                        },
                        title: "Add Resume",
                      ),
                    if (icon_data != null)
                      CustomContainerSelectToViewDoc(
                        title: "Resume",
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return CustomPDFViewerDialog(
                                pdfUrl:
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$icon_data",
                                onRemove: () async {
                                  await FileUploadService()
                                      .deleteSingleFile(icon_data!);
                                  setState(() {
                                    icon_data = null;
                                  });
                                },
                                onReplace: () {},
                              );
                            },
                          );
                        },
                      ),

                    const SizedBox(
                      height: 20,
                    ),
                    // if (widget.isRefer && widget.is90)
                    //TODO:: commented because display 90days clause for the hiring who dont have payout.
                    CustomRadioOption(
                        isSelected1: termAndConditionOne,
                        isSelected2: termAndConditionTwo,
                        onTap1: () {
                          setState(() {
                            termAndConditionOne = !termAndConditionOne;
                            termAndConditionTwo = false;
                          });
                        },
                        onTap2: () {
                          setState(() {
                            termAndConditionTwo = !termAndConditionTwo;
                            termAndConditionOne = false;
                          });
                        },
                        payoutDetails: widget.payoutDetails),

                    InkWell(
                      onTap: () {
                        submit();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        decoration: BoxDecoration(
                            color: Constants.darkBlue,
                            borderRadius: BorderRadius.circular(8.r)),
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(bottom: 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Submit",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            isLoading
                ? BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5), // Adjust blur intensity as needed
                    child: const Center(
                      child: AbsorbPointer(
                        absorbing:
                            true, // Prevent interaction with elements behind
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  String? _filePath;

  //TODO: old code to upload file.

  Future<String?> uploadFile(allowExt, bool isSecond) async {
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
          if (isSecond) {
            //  Navigator.pop(context);
            Navigator.pop(context);
          }
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
        return showDialog(
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
      }
    } else {
      // Close the loading dialog when the user cancels file selection
      Navigator.pop(context);

      // Handle the case where the user cancels file selection
      return null;
    }
  }

  int differenceInDays(DateTime? date1, DateTime date2) {
    final difference = date1!.difference(date2).inDays;
    return difference
        .abs(); // Return the absolute value to handle negative differences
  }

  bool isDifferenceLessThan30Days(DateTime? date1, DateTime date2) {
    if (date1 != null) {
      return differenceInDays(date1, date2) < 30;
    } else {
      // Handle the case where date1 is null
      // For example, you could consider it as greater than 30 days
      return false; // Or you can return false, depending on your use case
    }
  }

  bool isDifferenceGreaterThan30Days(DateTime? date1, DateTime date2) {
    if (date1 != null) {
      return differenceInDays(date1, date2) > 30;
    } else {
      // Handle the case where date1 is null
      // For example, you could consider it as greater than 30 days
      return false; // Or you can return false, depending on your use case
    }
  }

  /*  List<UserDataForAddResumeModelResultData>? applicationList = [];
  List<CoolingModel>? ListOfCoolingData = []; */
  void fetchData() async {
    SharedPreferences pref = await Utils.getSharedPreferences();

    final usertoken = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_token.name);
    final userId =
        await Utils.getPreferencesValue(pref, ESharedPreferences.user_id.name);
    try {
      setState(() {
        isLoading = true;
      });

      ReferAddResumeModel referAddResumeModel = ReferAddResumeModel(
        
          // partnerPaymentMode: "Special",
          alternateNo:
              secondry.text.isNotEmpty ? int.parse(secondry.text.trim()) : null,
          applicantName: firt_name.text,
          companyName: widget.company_name,
          contactNo: int.parse(primary_number.text.trim()),
          interviewRounds: widget.interviewRounds,
          isExperienced: fresher ? 0 : 1,
          jobId: widget.jobId,
          lastName: last_name.text,
          level: widget.role,
          naturofwork: widget.nature_of_work,
          process: widget.process,
          qualification: graduate == true ? "Graduate" : "Under Graduate",
          resume: icon_data,
          shortListFor: widget.company_id,
          spoc: widget.spocId,
          payoutMode: termAndConditionOne ? "DEFAULT" : "SPECIAL",
          uid: int.tryParse(userId));
      await JobPostApiService.ReferAndAddResume(
        referAddResumeModel.toJson(),
        context,
        false,
        userId,
      );

      ref.refresh(referAts);
      ref.refresh(fetchAllApplyProvider);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
            error: true,
            onClose: () {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context);
            },
            subtitle: "Error While Uplaoding. Connect with tech Team.",
          );
        },
      );
    }
  }

  bool isLoading = false;

  void submit() async {
    if (firt_name.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
            error: true,
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
              error: true,
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
              error: true,
              onClose: () {
                Navigator.pop(context);
                text3.requestFocus();
              },
              subtitle: "Primary number is mandatory");
        },
      );
    } else if (primary_number.text == secondry.text) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              error: true,
              onClose: () {
                Navigator.pop(context);
                text2.requestFocus();
              },
              subtitle: "Primary and secondary number could not be same");
        },
      );
    } else if (primary_number.text.length < 10) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              error: true,
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
              error: true,
              onClose: () {
                Navigator.pop(context);
                text2.requestFocus();
              },
              subtitle: "Add resume first");
        },
      );
    } else if (primary_number.text == widget.userNumber.toString()) {
      showDialog(
        context: context,
        builder: (context) {
          return customDialogueforDublicate(
            onClose: () {
              Navigator.pop(context);
              //  text3.requestFocus();
            },
          );
        },
      );
    } else if (secondry.text == widget.userNumber.toString()) {
      showDialog(
        context: context,
        builder: (context) {
          return customDialogueforDublicate(
            onClose: () {
              Navigator.pop(context);
              //  text3.requestFocus();
            },
          );
        },
      );
    } else if (primary_number.text == widget.useAlternateNumber.toString()) {
      showDialog(
        context: context,
        builder: (context) {
          return customDialogueforDublicate(
            onClose: () {
              Navigator.pop(context);
              // text3.requestFocus();
            },
          );
        },
      );
    } else if (primary_number.text.startsWith('0')) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              error: true,
              onClose: () {
                Navigator.pop(context);
                text2.requestFocus();
              },
              subtitle: "Provide valid number");
        },
      );
    } else if (secondry.text.startsWith('0')) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              error: true,
              onClose: () {
                Navigator.pop(context);
                text2.requestFocus();
              },
              subtitle: "Provide valid Secondary number");
        },
      );
    } else if (graduate == false && underGraduate == false) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              error: true,
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
              error: true,
              onClose: () {
                Navigator.pop(context);
                // text3.requestFocus();
              },
              subtitle: "Select any one option from work status");
        },
      );
    } else if (secondry.text == widget.useAlternateNumber.toString()) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              error: true,
              onClose: () {
                Navigator.pop(context);
                // text3.requestFocus();
              },
              subtitle: "You cant use your own number as secondry number");
        },
      );
    } else if (termAndConditionOne == false && termAndConditionTwo == false) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
              error: true,
              onClose: () {
                Navigator.pop(context);
                //  text3.requestFocus();
              },
              subtitle: "Select Payout type");
        },
      );
    } else {
      fetchData();
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
