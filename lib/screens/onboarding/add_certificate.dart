import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/models/user_data_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/Manager/constant/month_drop_down.dart';
import 'package:job_circle/screens/onboarding/add_cv.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/themes/colors.dart';

class AddCertificate extends StatefulWidget {
  final int userID;
  final UserRequest introData;
  final EducationRequest education;
  final ExperienceRequest? experience;
  final bool isexperience;
  final bool isUnderGraduate;
  final List<dynamic>? selectedSkillSet;

  const AddCertificate(
      {required this.userID,
      required this.introData,
      required this.isexperience,
      required this.isUnderGraduate,
      required this.education,
      this.experience,
      this.selectedSkillSet,
      super.key});

  @override
  State<AddCertificate> createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
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

  String? certificateFile;

  FileUploader fileUploader = FileUploader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Name.text.isEmpty &&
                    Organization.text.isEmpty &&
                    credentialId.text.isEmpty &&
                    credentialUrl.text.isEmpty &&
                    issueDateYear.text.isEmpty &&
                    validTillYear.text.isEmpty &&
                    certificateFile == null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: CustomButtonForSave(
                      buttonColor: Colors.white,
                      textColor: Constants.darkBlue,
                      isBorder: true,
                      onTap: () {
                        if (Name.text.isEmpty && Organization.text.isEmpty) {
                          Skip();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackbarfinal(
                                  title: "for skip all field should be empty",
                                  error: true));
                        }
                      },
                      title: "Skip",
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: CustomButtonForSave(
                  onTap: () {
                    int? firstyear =
                        int.tryParse(issueDateYear.text.toString());
                    int? passingyear =
                        int.tryParse(validTillYear.text.toString());
                    if (Name.text.isEmpty) {
                      CustomSnackbar.show(
                        "Enter your certificate name",
                        true,
                      );
                    } else if (Organization.text.isEmpty) {
                      CustomSnackbar.show(
                        "Enter issuing organization name",
                        true,
                      );
                    } else if (issueDateMonth.text.isEmpty ||
                        issueDateYear.text.isEmpty) {
                      CustomSnackbar.show(
                        "Mentioned issue date of certificate",
                        true,
                      );
                    } else if (validTillYear.text.isNotEmpty &&
                        firstyear! > passingyear!) {
                      CustomSnackbar.show(
                          "Passing year should be greater the issue date",
                          true);
                    } else {
                      Save();
                    }
                  },
                  title: "Next"),
            )
          ],
        ),
        appBar: AppBar(
          backgroundColor: Constants.borderColor,
          automaticallyImplyLeading: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Constants.black),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(top: kToolbarHeight / 6.h),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.sp, left: 10.sp, right: 10.sp),
                    child: LinearProgressIndicator(
                      value: 0.835,
                      // value: _calculateProgress(, // Set progress value
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Constants.themeBgColor),
                      minHeight: 9.9.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.sp, top: 10.sp, bottom: 10.sp, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OnboardingTitle(
                          title: "Add Certification",
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
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
                          hintText: "Type to serach",
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
                          hintText: "Type to serach",
                        ),
                        /*   CustomTextField(
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
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: MonthDropdown(
                                  controller: issueDateMonth,
                                  hint: "Select Month",
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: DropDownYear(
                                  "Select Year", issueDateYear, true),
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
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: MonthDropdown(
                                  controller: validTillMonth,
                                  hint: "Select Month",
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: DropDownYear(
                                  "Select Year",
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
                                          .deleteSingleFile(certificateFile!);
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
                                certificateFile = await fileUploader.uploadFile(
                                    context, ['pdf'], "certificateFile");
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
                ],
              ),
            ),
          ),
        ));
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

  InkWell customContainerSelectToViewDoc({
    required final VoidCallback onPressed,
    required String title,
  }) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: MediaQuery.of(context).size.width,

            //height: MediaQuery.of(context).size.height / 30,
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: EdgeInsets.only(
              bottom: 7.h,
            ),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2.1,
                    spreadRadius: 2.1,
                    offset: const Offset(1.0, 2.0))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.picture_as_pdf_outlined,

                  color: Constants.themeBgColor,
                  //size: 18.h,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(title,
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.normal,
                        color: Constants.black,
                        fontSize: 12.sp)),
              ],
            )));
  }

  Save() async {
    CertificationRequest certificateModel = CertificationRequest(
      userId: 0,
      certificateId: 0,
      certificationName: Name.text,
      issuingOrganization: Organization.text,
      credentialId: credentialId.text,
      credentialUrl: credentialUrl.text,
      startMonth: issueDateMonth.text.toString(),
      startYear: int.tryParse(issueDateYear.text.toString()),
      endMonth: validTillMonth.text.toString(),
      endYear: int.tryParse(validTillYear.text.toString()),
      certificate: certificateFile,
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddCv(
                  educationRequest: widget.education,
                  certificationRequest: certificateModel,
                  introData: widget.introData,
                  isUnderGraduate: widget.isUnderGraduate,
                  isexperience: widget.isexperience,
                  userID: widget.userID,
                  experience: widget.experience,
                  selectedSkillSet: widget.selectedSkillSet,
                )));
  }

  Skip() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddCv(
                  introData: widget.introData,
                  educationRequest: widget.education,
                  isUnderGraduate: widget.isUnderGraduate,
                  isexperience: widget.isexperience,
                  userID: widget.userID,
                  experience: widget.experience,
                  selectedSkillSet: widget.selectedSkillSet,
                  certificationRequest: null,
                )));
  }
}

/* class YearDropdown extends StatefulWidget {
  final TextEditingController controller;

  final String hint;
  final bool isNumber;
  final int maxLength;
  final String? previousyear;

  const YearDropdown({
    super.key,
    required this.controller,
    this.previousyear,
    this.hint = "Select Year",
    this.isNumber = true,
    this.maxLength = 4,
  });

  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  late List<int> years;
  late int currentYear;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year;
    years = List.generate(currentYear - 1994, (index) => 1995 + index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          value: selectedYear,
          hint: Text(widget.hint),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: years
              .map((year) => DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedYear = value;
              widget.controller.text = value.toString();
            });
          },
        ),
      ],
    );
  }
} */
