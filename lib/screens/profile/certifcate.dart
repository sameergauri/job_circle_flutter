// ignore_for_file: unused_result, use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/customdialogue_for_education_selecton.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/Manager/constant/month_drop_down.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class CertificateEdit extends ConsumerStatefulWidget {
  late CertificationDetailModel? prevPageModel;
  final bool isFirst, isEdit;
  final int certlength;
  final int userid;
  final List<String> profileskill;
  CertificateEdit(
      {super.key,
      this.prevPageModel,
      required this.isEdit,
      required this.userid,
      required this.certlength,
      required this.profileskill,
      required this.isFirst});

  @override
  ConsumerState<CertificateEdit> createState() => _CertificateEditState();
}

class _CertificateEditState extends ConsumerState<CertificateEdit> {
  //
  //
  //
  //
  TextEditingController Name = TextEditingController();
  TextEditingController Organization = TextEditingController();
  TextEditingController credentialId = TextEditingController();
  TextEditingController credentialUrl = TextEditingController();
  TextEditingController issueDateMonth = TextEditingController();
  TextEditingController issueDateYear = TextEditingController();
  TextEditingController validTillMonth = TextEditingController();
  TextEditingController validTillYear = TextEditingController();
  //
  //
  //
  //
  FocusNode credentialFocus = FocusNode();
  FocusNode urlFocus = FocusNode();

  //
  //
  //
  //

  String? certificateFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (widget.prevPageModel != null) {
        Name.text = widget.prevPageModel!.certificationName.toString();
        Organization.text =
            widget.prevPageModel!.issuingOrganization.toString();
        if (widget.prevPageModel!.credentialId != null &&
            widget.prevPageModel!.credentialId != "") {
          credentialId.text = widget.prevPageModel!.credentialId.toString();
        }
        if (widget.prevPageModel!.credentialUrl != null &&
            widget.prevPageModel!.credentialUrl != "") {
          credentialUrl.text = widget.prevPageModel!.credentialUrl.toString();
        }
        if (widget.prevPageModel!.startMonth != null &&
            widget.prevPageModel!.startMonth != "") {
          issueDateMonth.text = widget.prevPageModel!.startMonth.toString();
        }
        if (widget.prevPageModel!.startYear != null) {
          issueDateYear.text = widget.prevPageModel!.startYear.toString();
        }
        if (widget.prevPageModel!.endMonth != null &&
            widget.prevPageModel!.endMonth != "") {
          validTillMonth.text = widget.prevPageModel!.endMonth.toString();
        }
        if (widget.prevPageModel!.endYear != null) {
          validTillYear.text = widget.prevPageModel!.endYear.toString();
        }
        if (widget.prevPageModel!.certificate != null &&
            widget.prevPageModel!.certificate != "") {
          certificateFile = widget.prevPageModel?.certificate.toString();
        }
      }
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            bottomNavigationBar: CustomButtonForSave(
              title: "Save",
              onTap: () {
                int? firstyear = int.tryParse(issueDateYear.text.toString());
                int? passingyear = int.tryParse(validTillYear.text.toString());
                if (Name.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackbarfinal(
                          title: "Enter your certificate name", error: true));
                } else if (Organization.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackbarfinal(
                          title: "Enter issuing org name", error: true));
                } else if (issueDateMonth.text.isEmpty ||
                    issueDateYear.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackbarfinal(
                          title: "Mentioned issue date of certificate",
                          error: true));
                } else if (validTillYear.text.isNotEmpty &&
                    firstyear! > passingyear!) {
                  CustomSnackbar.show(
                      "Passing year should be greater the issue date", true);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  Save();
                }
              },
            ),
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Constants.borderColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Constants.black),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.prevPageModel == null
                      ? const OnboardingTitle(
                          title: "Add Certificate",
                        )
                      : const OnboardingTitle(
                          title: "Edit Certificate",
                        ),

                  //const Spacer(),
                ],
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(top: kToolbarHeight / 6.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.sp, top: 10.sp, bottom: 10.sp, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const customTextForWeather(
                              title: "Course or Certification Name*",
                            ),
                            CustomJobTitleForExperience(
                              onIDSelected: () {},
                              // isSelected: isIndustry,
                              //focusNode: titleFocus,
                              role: "",
                              isCompany: false,
                              isIndustry: true,
                              name: "certificate",
                              title: "Cirtificate Name",
                              controller: Name,
                              onChanged: (p0) {},
                              getid: (p0) {},
                              contextIn: context,
                              hintText: "type to serach",
                            ),
                            /*   CustomTextField(
                                hint: "Type to search", controller: Name), */
                            SizedBox(
                              height: 20.h,
                            ),
                            const customTextForWeather(
                              title: "Issuing Organization*",
                            ),
                            CustomJobTitleForExperience(
                              onIDSelected: () {},
                              // isSelected: isIndustry,
                              //focusNode: titleFocus,
                              role: "",
                              isCompany: false,
                              isIndustry: true,
                              name: "organization",
                              title: "Organization Name",
                              controller: Organization,
                              onChanged: (p0) {},
                              getid: (p0) {},
                              contextIn: context,
                              hintText: "type to serach",
                            ),
                            /*  CustomTextField(
                                hint: "Type to search", controller: Organization), */
                            SizedBox(
                              height: 20.h,
                            ),
                            const customTextForWeather(
                              title: "Credential ID",
                            ),
                            CustomTextFieldforAll(
                                isGmail: true,
                                focusNode: credentialFocus,
                                hint: "Enter Credential Id",
                                controller: credentialId),
                            SizedBox(
                              height: 20.h,
                            ),
                            const customTextForWeather(
                              title: "Credential Url",
                            ),
                            CustomTextFieldforAll(
                                isGmail: true,
                                focusNode: urlFocus,
                                hint: "Enter Credential Url",
                                controller: credentialUrl),
                            SizedBox(
                              height: 20.h,
                            ),
                            const customTextForWeather(
                              title: "Issue Date*",
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: MonthDropdown(
                                      controller: issueDateMonth,
                                      hint: issueDateMonth.text.isNotEmpty
                                          ? issueDateMonth.text
                                          : "Select Month",
                                    )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: DropDownYear(
                                      issueDateYear.text.isNotEmpty
                                          ? issueDateYear.text
                                          : "Select Year",
                                      issueDateYear,
                                      true),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            const customTextForWeather(
                              title: "Valid till",
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: MonthDropdown(
                                      controller: validTillMonth,
                                      hint: validTillMonth.text.isNotEmpty
                                          ? validTillMonth.text
                                          : "Select Month",
                                    )),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: DropDownYear(
                                      validTillYear.text.isNotEmpty
                                          ? validTillYear.text
                                          : "Select Year",
                                      validTillYear,
                                      false,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            if (certificateFile != null)
                              CustomContainerSelectToViewDoc(
                                title: "Cirtification Document",
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return CustomPDFViewerDialog(
                                        pdfUrl:
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$certificateFile",
                                        onRemove: () async {
                                          await FileUploadService()
                                              .deleteSingleFile(
                                                  certificateFile!);
                                          setState(() {
                                            certificateFile = null;
                                          });
                                        },
                                        onReplace: () {},
                                      );
                                    },
                                  );
                                },
                              ),
                            if (certificateFile == null)
                              CustomDocumentUploadButton(
                                  onTab: () async {
                                    FileUploader fileUploader = FileUploader();

                                    certificateFile =
                                        await fileUploader.uploadFile(context,
                                            ['pdf'], "certificateFile");
                                    setState(() {});

                                    /*  setState(() async {
                                      certificateFile = await uploadFile(['pdf']);
                                    });
                                    setState(() {}); */
                                  },
                                  title: "Add Certificate"),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (certificateFile == null)
                              const customTextForWeather(
                                title:
                                    "Add you certificate here. These confidential document are only visible to recruiters.",
                                fontSize: 10,
                                color: Constants.subtitleclr,
                              ),
                          ],
                        ),
                      ),
                      if (widget.isEdit)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: InkWell(
                                  onTap: () async {
                                    /*  widget.educationList!.length <= 1
                                    ? */
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return EducationSelectionDialog(
                                          explegth: widget.certlength,
                                          type: "cert",
                                          text: "Certificate",
                                          id: widget.prevPageModel!.id!.toInt(),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/images/bin.gif",
                                    height: 40.h,
                                  ) /* Text(
                            "Delete Education",
                            style: GoogleFonts.varela(color: Colors.red),
                          ) */
                                  ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            )),
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
  }

  Widget DropDownYear(
      String hint, TextEditingController controller, bool isFirst) {
    late List<int> years;
    late int currentYear;
    int? selectedYear;
    currentYear = DateTime.now().year;

    int startYear =
        int.tryParse(isFirst ? 1995.toString() : issueDateYear.text) ?? 1995;
    years = isFirst
        ? List.generate(
                currentYear - startYear + 1, (index) => startYear + index)
            .reversed
            .toList()
        : List.generate(
            currentYear - startYear + 1, (index) => startYear + index);

    return DropdownButtonFormField<int>(
      value: selectedYear,
      hint: customTextForMonst(title: hint),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Constants.black),
            borderRadius: BorderRadius.circular(8)),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Constants.subtitleclr)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Constants.subtitleclr),
            borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: years
          .map((year) => DropdownMenuItem<int>(
                value: year,
                child: customTextForMonst(title: year.toString()),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value;
          controller.text = value.toString();
          setState(() {});
        });
      },
    );
  }

  Save() async {
    CertificationRequestDto certificationRequestDto = CertificationRequestDto(
      userId: widget.userid,
      certificate: certificateFile,
      certificationName: Name.text,
      credentialId: credentialId.text,
      credentialUrl: credentialUrl.text,
      issuingOrganization: Organization.text,
      id: widget.isEdit == true ? widget.prevPageModel?.id : null,
      startMonth: issueDateMonth.text,
      startYear: int.tryParse(issueDateYear.text),
      endMonth: validTillMonth.text.isNotEmpty ? validTillMonth.text : null,
      endYear: validTillYear.text.isNotEmpty
          ? int.tryParse(validTillYear.text)
          : null,
      //  issueDate: issueDateMonth.toString()
    );
    ProfileUpdateRequestDto profileUpdateRequestDto =
        ProfileUpdateRequestDto(id: widget.userid, skills: widget.profileskill
            // cvUpdatedDate: DateTime.now()
            );

    UserUpdateRequestModel userUpdateRequestModel = UserUpdateRequestModel(
        certificationsRequestDtos: [certificationRequestDto],
        educationRequestDtos: null,
        experienceRequestDtos: null,
        profileUpdateRequestDto: profileUpdateRequestDto);

    await JobPostApiService.PostUserInfo(
      userUpdateRequestModel,
    );

    ref.refresh(ProfileDataProvider);
    CustomSnackbar.show(
        widget.isEdit == false
            ? "Your Certificate added succesfully"
            : "Your Certificate updated succesfully.",
        false);
    Navigator.pop(context);
    if (widget.certlength > 1) {
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }
}
