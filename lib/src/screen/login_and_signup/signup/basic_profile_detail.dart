// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
// ignore_for_file: todo

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_onboarding_titlle.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/select_exp_education.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/age_calculater.dart';
import 'package:job_circle/src/utils/date_picker/custom_date_picker.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class BasicProfileDetail extends StatefulWidget {
  const BasicProfileDetail({super.key});

  @override
  State<BasicProfileDetail> createState() => _BasicProfileDetailState();
}

class _BasicProfileDetailState extends State<BasicProfileDetail> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SignupCreateUserProvider>(
        context,
        listen: false,
      ).initializeController(
        SharedPrefsHelper.getInt(ESharedPreferences.user_mobile).toString(),
      );
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () {
                  if (provider.firstname.text.isEmpty) {
                    CustomSnackbar.show("Enter First Name", true);
                  } else if (provider.lastname.text.isEmpty) {
                    CustomSnackbar.show("Enter Last Name", true);
                  } else if (!provider.male && !provider.female) {
                    CustomSnackbar.show("Select Gender", true);
                  } else if (provider.dateofbirth.text.isEmpty) {
                    CustomSnackbar.show("Enter Date Of Birth", true);
                  } else if (provider.location.text.isEmpty) {
                    CustomSnackbar.show("Enter your location", true);
                  } else if (provider.pincode.text.isEmpty) {
                    CustomSnackbar.show("Enter Pin Code", true);
                  } else if (provider.locality.text.isEmpty) {
                    CustomSnackbar.show("Enter locality", true);
                  } else if (provider.selectedLanguages == null ||
                      provider.selectedLanguages!.isEmpty) {
                    CustomSnackbar.show("Select Atleast one language", true);
                  } else if (provider.emailid.text.isNotEmpty &&
                      !RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(provider.emailid.text)) {
                    CustomSnackbar.show("Enter valid email id", true);
                  } else {
                    NavigationService.push(SelectExpEducation());
                  }
                },
                title: "Next",
                buttonColor: Constants.darkBlue,
                textColor: Constants.white,
              ),
            ),
          ),
          //  extendBodyBehindAppBar: true,
          appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
            ),
          ),
          backgroundColor: Constants.white,
          body: _customBody(provider),
        );
      },
    );
  }

  Widget _customBody(SignupCreateUserProvider provider) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const customText(title: "First Name*", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.firstname,
              hint: "Enter First Name",
            ),
            const SizedBox(height: 15),
            const customText(title: "Middle Name", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.middlename,
              hint: "Enter Middle Name",
            ),
            const SizedBox(height: 15),
            const customText(title: "Last Name*", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.lastname,
              hint: "Enter Last Name",
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Contact Number",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldforAll(
              controller: provider.contactno,
              hint: "Enter Contact Number",
              isPrimaryNumber: true,
              isDisabled: false,
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Alternate Number",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldforAll(
              controller: provider.alternnateno,
              hint: "Enter Alternate Number",
              isNumber: true,
              maxLength: 10,
            ),

            const SizedBox(height: 15),
            const customText(title: "Email ID", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.emailid,
              hint: "Enter Email ID",
              isGmail: true,
            ),
            const SizedBox(height: 15),
            const customText(title: "Gender*", fontStyle: FontStyle.italic),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomGenderButton(
                  width: MediaQuery.of(context).size.width / 2.33,
                  height: 40,
                  title: "  Male  ",
                  isSelect: provider.male,
                  onTap: () {
                    provider.setGender('male');
                  },
                ),
                CustomGenderButton(
                  width: MediaQuery.of(context).size.width / 2.33,
                  height: 40,
                  title: "  Female  ",
                  isSelect: provider.female,
                  onTap: () {
                    provider.setGender('female');
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Date of Birth*",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldforAll(
              sufix: provider.age,
              prefixicon: CustomIconUrl.dojicon,
              controller: provider.dateofbirth,
              hint: "Select DOB",
              readonly: true, // Make field read-only to prevent manual input
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
                DateTime? selectedDate = await CustomDateOfBirth.selectDate(
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
                    AgeCalculator.calculateAge(provider.dateofbirth.text)!,
                  );
                }
              },
            ),
            const SizedBox(height: 15),
            const customText(title: "Locality*", fontStyle: FontStyle.italic),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.locality,
              hintText: "Type to search",
              name: "location",
              title: "Location",
            ),
            const SizedBox(height: 15),
            const customText(title: "city*", fontStyle: FontStyle.italic),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.location,
              hintText: "Type to search",
              name: "city",
              title: "Location",
            ),

            const SizedBox(height: 15),
            const customText(title: "Pin Code*", fontStyle: FontStyle.italic),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.pincode,
              hintText: "Type to search",
              name: "pin_code",
              title: "Pin Code",
            ),
            const SizedBox(height: 15),
            const customText(title: "Languages*", fontStyle: FontStyle.italic),
            Wrap(
              direction: Axis.horizontal,
              children: provider.languages
                  .map(
                    (e) => CustomToggleButton(
                      isSelect: provider.selectedLanguages!.contains(e),
                      title: e,
                      onTap: () => provider.toggleLanguage(e),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 10),
            const customText(title: "Linkdin URL", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.linkedInUrl,
              hint: "Enter your LinkedIn URL",
            ),
            SizedBox(height: 15),
            CustomCheckboxRow(
              title: "I am Fully Vaccinated",
              value: provider.vaccinated,
              onChanged: (value) {
                provider.setVaccination(value!);
              },
            ),
            SizedBox(height: 10),
            if (provider.vaccinated && provider.vaccinationCertificate == null)
              CustomDocumentUploadButton(
                subTitle: "Supported format : PDF",
                onTab: () async {
                  FileUploader fileUploader = FileUploader();
                  var data = await fileUploader.uploadFile(context, [
                    'pdf',
                  ], "vaccination");
                  if (data != null) {
                    provider.setVaccinationCertificate(data);
                  }
                },
                title: "Vaccination Certificate",
              ),
            if (provider.vaccinated && provider.vaccinationCertificate != null)
              CustomContainerSelectToViewDoc(
                isDocx:
                    provider.vaccinationCertificate!.contains('.docx') ||
                        provider.vaccinationCertificate!.contains('.doc')
                    ? true
                    : false,
                candidateName: 'Vaccination_Certificate',
                heading: "Vaccination Certificate",
                title: provider.vaccinationCertificate.toString(),
                onPressed: () {
                  NavigationService.push(
                    CustomPDFViewerDialog(
                      title: 'Vaccination Certificate',
                      pdfUrl:
                          "${GlobalConstants.Image_url}${provider.vaccinationCertificate}",
                      isFromAts: false,
                      onDelete: () async {
                        await FileUploadService().deleteSingleFile(
                          provider.vaccinationCertificate.toString(),
                        );
                        provider.setVaccinationCertificate(null);
                      },
                    ),
                  );
                },
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
