// ignore_for_file: unused_field, unused_result, non_constant_identifier_names, use_full_hex_values_for_flutter_colors, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, unused_local_variable, unused_element, unnecessary_null_comparison, override_on_non_overriding_member
// ignore_for_file: todo
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
import 'package:job_circle/src/provider/add_resume/add_resume_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/age_calculater.dart';
import 'package:job_circle/src/utils/date_picker/custom_date_picker.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/button/custom_radio_option_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class AddResume extends StatefulWidget {
  final String company_name, role, process, nature_of_work;
  final int company_id, jobId, spocId;
  final int userNumber;
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
    required this.userNumber,
    required this.payoutDetails,
  });

  @override
  State<AddResume> createState() => _AddResumeState();
}

class _AddResumeState extends State<AddResume> {
  @override
  void initState() {
    super.initState();
    /* final provider = Provider.of<ReferResumeProvider>(context, listen: false);
    provider.clear(); */
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Consumer<ReferResumeProvider>(
      builder: (context, provider, child) {
        print("UI Provider First Name: ${provider.firstname.text}");
        return Stack(
          children: [
            Scaffold(
              // backgroundColor: const Color(0xfffedf6f9), //TODO: old background color
              backgroundColor: colors.bgColor,
              bottomNavigationBar: SafeArea(
                minimum: const EdgeInsets.all(
                  8,
                ), // optional: thoda padding aur de do
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: CustomButtonForSave(
                        isPading: false,
                        onTap: () {
                          if (provider.firstname.text.isEmpty) {
                            CustomSnackbar.show("Enter First name", true);
                          } else if (provider.lastname.text.isEmpty) {
                            CustomSnackbar.show("Enter last name", true);
                          } else if (provider.contactnumber.text.isEmpty) {
                            CustomSnackbar.show("enter contact no", true);
                          } else if (provider.contactnumber.text ==
                              widget.userNumber.toString()) {
                            CustomSnackbar.show(
                              "you cant enter your own number ",
                              true,
                            );
                          } else if (provider.alternatenumber.text ==
                              widget.userNumber.toString()) {
                            CustomSnackbar.show(
                              "you cant enter your own number in alternate no.",
                              true,
                            );
                          } else if (provider.contactnumber.text.startsWith(
                            '0',
                          )) {
                            CustomSnackbar.show(
                              "number cant start with '0' ",
                              true,
                            );
                          } else if (provider.contactnumber.text.startsWith(
                            '0',
                          )) {
                            CustomSnackbar.show(
                              "alternate number cant start with '0'",
                              true,
                            );
                          } else if (provider.graduate == false &&
                              provider.undergraduate == false) {
                            CustomSnackbar.show("select education", true);
                          } else if (provider.fresher == false &&
                              provider.experience == false) {
                            CustomSnackbar.show(
                              "select level of experience",
                              true,
                            );
                          } else if (provider.contactnumber.text.length < 10) {
                            CustomSnackbar.show(
                              "number should be 10 digit",
                              true,
                            );
                          } else if (provider.contactnumber.text ==
                              widget.userNumber.toString()) {
                            CustomSnackbar.show(
                              "you cant enter your own number ",
                              true,
                            );
                          } else if (provider.alternatenumber.text ==
                              widget.userNumber.toString()) {
                            CustomSnackbar.show(
                              "you cant enter your own number ",
                              true,
                            );
                          } else if (provider.contactnumber.text.startsWith(
                            '0',
                          )) {
                            CustomSnackbar.show("Error", true);
                          } else if (provider.alternatenumber.text.startsWith(
                            '0',
                          )) {
                            CustomSnackbar.show("Error", true);
                          } else if (provider.resume == null ||
                              provider.resume == "" ||
                              provider.resume == "null" ||
                              provider.resume == " ") {
                            CustomSnackbar.show("Add resume to submit", true);
                          } else if (provider.termandconditionone == false &&
                              provider.termandconditiontwo == false) {
                            CustomSnackbar.show(
                              "Select any one payout type",
                              true,
                            );
                          } else {
                            AddLineUpToApiFunction(provider);
                          }
                        },
                        title: "Submit",
                      ),
                    ),
                  ],
                ),
              ),
              resizeToAvoidBottomInset: true, // Add this line

              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: colors.appbarColor,
                elevation: 0,
                titleSpacing: 0,
                iconTheme: IconThemeData(color: colors.headingColor),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: widget.role.toString(),
                      color: colors.headingColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    Row(
                      children: [
                        customText(
                          title: widget.process,
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        customText(
                          title: " || ",
                          fontSize: 14,
                          color: colors.headingColor,
                        ),
                        customText(
                          title: widget.nature_of_work,
                          fontSize: 14,
                          color: colors.headingColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            customText(
                              title: "Candidate First Name*",
                              color: colors.headingColor,
                            ),
                            CustomTextFieldforAll(
                              controller: provider.firstname,
                              hint: "Enter First Name",
                            ),
                            const SizedBox(height: 10),
                            customText(
                              title: "Candidate Last Name*",
                              color: colors.headingColor,
                            ),
                            CustomTextFieldforAll(
                              controller: provider.lastname,
                              hint: "Enter Last Name",
                            ),
                            const SizedBox(height: 10),
                            customText(
                              title: "Contact Number*",
                              color: colors.headingColor,
                            ),
                            CustomTextFieldforAll(
                              isPrimaryNumber:
                                  provider.contactnumber.text != null &&
                                      provider.contactnumber.text != ""
                                  ? true
                                  : false,
                              isDisabled:
                                  provider.contactnumber.text != null &&
                                      provider.contactnumber.text != ''
                                  ? false
                                  : true,
                              maxLength: 10,
                              isNumber: true,
                              controller: provider.contactnumber,
                              hint: "Enter Contact Number",
                            ),
                            const SizedBox(height: 10),
                            customText(
                              title: "Alternate Number",
                              color: colors.headingColor,
                            ),
                            CustomTextFieldforAll(
                              maxLength: 10,
                              controller: provider.alternatenumber,
                              isNumber: true,
                              hint: "Enter Alternate Number",
                            ),

                            const SizedBox(height: 10),
                            customText(
                              title: "Email ID",
                              color: colors.headingColor,
                            ),
                            CustomTextFieldforAll(
                              isGmail: true,
                              controller: provider.email,
                              hint: "Enter Email ID",
                            ),
                            const SizedBox(height: 10),
                            customText(
                              title: "Gender",
                              color: colors.headingColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomGenderButton(
                                  isSelect: provider.male,
                                  title: "Male",
                                  width:
                                      MediaQuery.of(context).size.width / 2.33,
                                  height: 40,
                                  onTap: () {
                                    provider.setGender('male');
                                  },
                                ),
                                CustomGenderButton(
                                  width:
                                      MediaQuery.of(context).size.width / 2.33,
                                  height: 40,
                                  onTap: () {
                                    provider.setGender('female');
                                  },
                                  isSelect: provider.female,
                                  title: "Female",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            customText(
                              title: "Date of Birth",
                              color: colors.headingColor,
                            ),
                            CustomTextFieldforAll(
                              sufix: provider.age,
                              prefixicon: CustomIconUrl.dojicon,
                              controller: provider.dateofbirth,
                              hint: "Select DOB",
                              readonly:
                                  true, // Make field read-only to prevent manual input
                              onTab: () async {
                                DateTime today = DateTime.now();
                                DateTime fifteenYearsAgo = DateTime(
                                  today.year - 18,
                                  today.month,
                                  today.day,
                                );

                                // Parse previously selected date if exists
                                DateTime? initialDate;
                                if (provider.dateofbirth.text.isNotEmpty) {
                                  try {
                                    initialDate = DateFormat(
                                      'dd MMM yyyy',
                                    ).parse(provider.dateofbirth.text);
                                  } catch (e) {
                                    initialDate = fifteenYearsAgo;
                                  }
                                } else {
                                  initialDate = fifteenYearsAgo;
                                }

                                // Open date picker
                                DateTime? selectedDate =
                                    await CustomDateOfBirth.selectDate(
                                      initialDate: initialDate,
                                      context: context,
                                      minDate: DateTime(1970),
                                      maxDate: fifteenYearsAgo,
                                      title: "Select Date of Birth",
                                    );

                                if (selectedDate != null) {
                                  String formattedDate = DateFormat(
                                    'dd MMM yyyy',
                                  ).format(selectedDate);
                                  provider.dateofbirth.text = formattedDate;
                                  provider.setAge(
                                    AgeCalculator.calculateAge(
                                      provider.dateofbirth.text,
                                    )!,
                                  );
                                }
                              },
                            ),
                            /*  GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  provider.setDob(pickedDate);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Constants.borderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  provider.dob != null
                                      ? DateFormat(
                                          'dd MMM y',
                                        ).format(provider.dob!)
                                      : "Select Date of Birth",
                                  style: TextStyle(
                                    color: provider.dob != null
                                        ? Constants.black
                                        : Constants.subtitleclr,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ), */
                            SizedBox(height: 10),
                            customText(
                              title: "Level of Education*",
                              color: colors.headingColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomGenderButton(
                                  width:
                                      MediaQuery.of(context).size.width / 2.33,
                                  height: 40,
                                  onTap: () {
                                    provider.setEducation('under');
                                  },
                                  isSelect: provider.undergraduate,
                                  title: "Under - Graduate",
                                ),
                                CustomGenderButton(
                                  width:
                                      MediaQuery.of(context).size.width / 2.33,
                                  height: 40,
                                  onTap: () {
                                    provider.setEducation('graduate');
                                  },
                                  isSelect: provider.graduate,
                                  title: "Graduate & Above",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            customText(
                              title: "Level of Work Status*",
                              color: colors.headingColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomGenderButton(
                                  width:
                                      MediaQuery.of(context).size.width / 2.33,
                                  height: 40,
                                  onTap: () {
                                    provider.setExperience('fresher');
                                  },
                                  isSelect: provider.fresher,
                                  title: "Fresher",
                                ),
                                CustomGenderButton(
                                  width:
                                      MediaQuery.of(context).size.width / 2.33,
                                  height: 40,
                                  onTap: () {
                                    provider.setExperience('experience');
                                  },
                                  isSelect: provider.experience,
                                  title: "Experience",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (provider.resume == "" ||
                                provider.resume == null)
                              const SizedBox(height: 20),
                            if (provider.resume == "" ||
                                provider.resume == null)
                              CustomDocumentUploadButton(
                                onTab: () async {
                                  FileUploader fileUploader = FileUploader();
                                  var data = await fileUploader.uploadFile(
                                    context,
                                    ['pdf', 'docx', 'doc'],
                                    "resume",
                                  );
                                  if (data != null) {
                                    provider.setResume(data);
                                  }
                                },
                                title: "Add Resume",
                              ),
                            if (provider.resume != "" &&
                                provider.resume != null)
                              CustomContainerSelectToViewDoc(
                                isDocx:
                                    provider.resume!.contains('.docx') ||
                                        provider.resume!.contains('.doc')
                                    ? true
                                    : false,
                                candidateName:
                                    provider.firstname.text +
                                    provider.lastname.text,
                                heading: "Resume",
                                title: provider.resume.toString(),
                                onPressed: () {
                                  NavigationService.push(
                                    CustomPDFViewerDialog(
                                      pdfUrl:
                                          "${GlobalConstants.Image_url}${provider.resume}",
                                      isFromAts: false,
                                      onDelete: () async {
                                        provider.setLoading(true);
                                        await FileUploadService()
                                            .deleteSingleFile(
                                              provider.resume.toString(),
                                            );
                                        provider.setResume(null);
                                        NavigationService.pop();
                                      },
                                    ),
                                  );
                                },
                              ),
                            SizedBox(height: 10),
                            CustomRadioOption(
                              isSelected1: provider.termandconditionone,
                              isSelected2: provider.termandconditiontwo,
                              onTap1: () {
                                provider.setTermConditionOne();
                              },
                              onTap2: () {
                                provider.setTermConditionTwo();
                              },
                              payoutDetails: widget.payoutDetails,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            provider.isLoading
                ? BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ), // Adjust blur intensity as needed
                    child: const Center(
                      child: AbsorbPointer(
                        absorbing:
                            true, // Prevent interaction with elements behind
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }

  //TODO:: Add Resume Function......

  void AddLineUpToApiFunction(ReferResumeProvider provider) async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    try {
      ReferAddResumeModel referAddResumeModel = ReferAddResumeModel(
        alternateNo: provider.alternatenumber.text.isNotEmpty
            ? int.parse(provider.alternatenumber.text.trim())
            : null,
        applicantName: provider.firstname.text,
        companyName: widget.company_name,
        contactNo: int.parse(provider.contactnumber.text.trim()),
        isExperienced: provider.fresher ? 0 : 1,
        jobId: widget.jobId,
        lastName: provider.lastname.text,
        level: widget.role,
        naturofwork: widget.nature_of_work,
        process: widget.process,
        qualification: provider.graduate ? "Graduate" : "Under Graduate",
        resume: provider.resume,
        shortListFor: widget.company_id,
        spoc: widget.spocId,
        email: provider.email.text,
        gender: provider.male
            ? "Male"
            : provider.female
            ? "Female"
            : null,
        dob: provider.dob,
        // uid: userid,
        uid: 0,
        payoutMode: provider.termandconditionone ? "DEFAULT" : "SPECIAL",
      );
      await provider.postResume(
        context: context,
        jsonData: referAddResumeModel,
        fromDialog: true,
        refId: userid,
      );
      provider.clear();
    } catch (e) {
      print('Error fetching data: $e');
      CustomSnackbar.show("Error While Uploading connect with tech team", true);
    }
  }
}
