// ignore_for_file: use_build_context_synchronously, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
// ignore_for_file: todo

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/digi_locker/digilocker_status_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
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
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class ProfileBasicInforEdit extends StatefulWidget {
  const ProfileBasicInforEdit({super.key});

  @override
  State<ProfileBasicInforEdit> createState() => _ProfileBasicInforEditState();
}

class _ProfileBasicInforEditState extends State<ProfileBasicInforEdit> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).initializeController(
        SharedPrefsHelper.getInt(ESharedPreferences.user_mobile).toString(),
      );
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: CustomButtonForSave(
                isPading: false,
                /*  onTap: () {
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
                  } else if (provider.locality.text.isEmpty) {
                    CustomSnackbar.show("Enter locality", true);
                  } else if (provider.pincode.text.isEmpty) {
                    CustomSnackbar.show("Enter Pin Code", true);
                  } else if (provider.selectedLanguages.isEmpty) {
                    CustomSnackbar.show("Select Atleast one language", true);
                  } else if (provider.emailid.text.isNotEmpty &&
                      !RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(provider.emailid.text)) {
                    CustomSnackbar.show("Enter valid email id", true);
                  } else if ((provider.profile?.isUserVerified != null &&
                      provider.profile?.isUserVerified == true)) {
                    CustomSnackbar.show("Enter Pin Code", true);
                  } else {
                    // Update profile model from controllers if it's CV parse profile
                    if (provider.profile != null) {
                      provider.updateProfileModelForBasicInfo();
                      provider.clearBasicProfile();
                      Future.delayed(Duration(seconds: 2), () {
                        jobProvider.fetchJobs(applyCityFilter: true);
                      });
                    }
                    NavigationService.pop();
                  }
                }, */
                onTap: () async {
                  // ===== Basic validations (same as before) =====
                  if (provider.firstname.text.trim().isEmpty) {
                    CustomSnackbar.show("Enter First Name", true);
                    return;
                  }
                  if (provider.lastname.text.trim().isEmpty) {
                    CustomSnackbar.show("Enter Last Name", true);
                    return;
                  }
                  if (_areAllNamesSame(
                    provider.firstname.text.trim(),
                    provider.middlename.text.trim(),
                    provider.lastname.text.trim(),
                  )) {
                    CustomSnackbar.show(
                      "First, Middle and Last name cannot be the same",
                      true,
                    );
                    return;
                  }
                  if (!provider.male && !provider.female) {
                    CustomSnackbar.show("Select Gender", true);
                    return;
                  }
                  if (provider.dateofbirth.text.isEmpty) {
                    CustomSnackbar.show("Enter Date Of Birth", true);
                    return;
                  }
                  if (provider.location.text.isEmpty) {
                    CustomSnackbar.show("Enter your location", true);
                    return;
                  }
                  if (provider.locality.text.isEmpty) {
                    CustomSnackbar.show("Enter locality", true);
                    return;
                  }
                  if (provider.pincode.text.isEmpty) {
                    CustomSnackbar.show("Enter Pin Code", true);
                    return;
                  }
                  if (provider.selectedLanguages.isEmpty) {
                    CustomSnackbar.show("Select Atleast one language", true);
                    return;
                  }
                  if (provider.emailid.text.isNotEmpty &&
                      !RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(provider.emailid.text)) {
                    CustomSnackbar.show("Enter valid email id", true);
                    return;
                  }

                  final bool isVerified =
                      provider.profile?.isUserVerified == true;

                  // ===== Agar verified NAHI hai → normal save =====
                  if (!isVerified) {
                    await _saveProfile(provider, jobProvider);
                    return;
                  }

                  // ===== VERIFIED user → name check =====
                  final first = provider.firstname.text.trim();
                  final middle = provider.middlename.text.trim();
                  final last = provider.lastname.text.trim();

                  // 1. Teenon same to nahi?
                  if (_areAllNamesSame(first, middle, last)) {
                    CustomSnackbar.show(
                      "First, Middle and Last name cannot be the same",
                      true,
                    );
                    return;
                  }

                  // 2. DigiLocker name lao
                  final digilockerProvider = context.read<DigilockerProvider>();

                  // Agar pehle se data nahi hai to fetch karo
                  if (digilockerProvider.name.isEmpty) {
                    await digilockerProvider.fetchDigilockerStatus();
                  }

                  final digiName = digilockerProvider
                      .name; // e.g. "Gauri Mohd Sameer Mohd Jameel"

                  if (digiName.isEmpty) {
                    // DigiLocker name nahi mila → safe side pe warning
                    final shouldContinue = await _showNameChangeWarningDialog(
                      context,
                      "$first $middle $last",
                    );
                    if (shouldContinue == true) {
                      await _saveProfile(provider, jobProvider);
                      // Badge hatao + save
                      await digilockerProvider.updateVerifiedStatus(
                        isVerified: false,
                      );
                      await digilockerProvider.deleteDigilockerData();
                      await provider.fetchProfile();
                    }
                    return;
                  }

                  // 3. Name match check
                  final nameStillValid = _isNameContainedInDigilocker(
                    first: first,
                    middle: middle,
                    last: last,
                    digilockerName: digiName,
                  );

                  if (nameStillValid) {
                    // Match hai → normal save
                    await _saveProfile(provider, jobProvider);
                  } else {
                    // Match nahi → confirmation dialog
                    final shouldContinue = await _showNameChangeWarningDialog(
                      context,
                      "$first $middle $last",
                    );
                    if (shouldContinue == true) {
                      await _saveProfile(provider, jobProvider);
                      // Verification badge hatao
                      await digilockerProvider.updateVerifiedStatus(
                        isVerified: false,
                      );
                      await digilockerProvider.deleteDigilockerData();
                      await provider.fetchProfile();
                    }
                    // Cancel → kuch mat karo
                  }
                },
                title: "Save",
                // buttonColor: Constants.darkBlue,
                textColor: colors.buttonTextColor,
              ),
            ),
          ),
          //  extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: colors.appbarColor,
            elevation: 0,
            titleSpacing: 0.0,
            iconTheme: IconThemeData(color: colors.headingColor),
            title: customText(
              title: "Personal Detail",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.headingColor,
            ),
          ),
          backgroundColor: colors.bgColor,
          body: _customBody(provider, colors),
        );
      },
    );
  }

  /// Teenon names same hain kya?
  /// Returns true agar names invalid hain (same hain)
  bool _areAllNamesSame(String first, String middle, String last) {
    final f = first.trim().toLowerCase();
    final m = middle.trim().toLowerCase();
    final l = last.trim().toLowerCase();

    if (f.isEmpty || l.isEmpty)
      return false; // empty pehle basic validation handle karegi

    // First aur Last same nahi hone chahiye
    if (f == l) return true;

    // Middle empty hai → OK (optional)
    if (m.isEmpty) return false;

    // Middle bhara hai → teenon alag hone chahiye
    // Agar koi bhi do same hain to invalid
    if (f == m || m == l || f == l) return true;

    return false; // sab alag hain → valid
  }

  /// Form ke names DigiLocker name mein contained hain kya?
  bool _isNameContainedInDigilocker({
    required String first,
    required String middle,
    required String last,
    required String digilockerName,
  }) {
    final digiParts = digilockerName
        .toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (digiParts.isEmpty) return false;

    // Field ke words mein se koi ek digi list mein hai?
    bool fieldHasAtLeastOneMatch(String value) {
      final words = value
          .toLowerCase()
          .trim()
          .split(RegExp(r'\s+'))
          .where((e) => e.isNotEmpty)
          .toList();

      if (words.isEmpty) return true; // empty = OK (middle ke liye)
      return words.any((word) => digiParts.contains(word)); // koi ek kaafi
    }

    // First — zaroori + kam se kam 1 word match
    if (first.trim().isEmpty) return false;
    if (!fieldHasAtLeastOneMatch(first)) return false;

    // Middle — empty OK, warna kam se kam 1 word match
    if (middle.trim().isNotEmpty && !fieldHasAtLeastOneMatch(middle)) {
      return false;
    }

    // Last — zaroori + kam se kam 1 word match
    if (last.trim().isEmpty) return false;
    if (!fieldHasAtLeastOneMatch(last)) return false;

    return true;
  }

  /// Warning dialog
  Future<bool?> _showNameChangeWarningDialog(
    BuildContext context,
    String name,
  ) {
    final colors = context.appColors;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: colors.bottomsheetbgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFF57C00),
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 20),
                  customText(
                    title: "Name Mismatch Detected",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.headingColor,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  customText(
                    title:
                        "The name entered ($name) does not match the name on your Verified ID. Continuing will remove your current verification badge. Do you want to proceed?",
                    fontSize: 12,
                    color: colors.subTitleColor,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.darkBlue!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: customText(
                              title: "Cancel",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.darkBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.darkBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: customText(
                              title: "Continue",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Normal save logic (pehle wala code)
  Future<void> _saveProfile(
    ProfileProvider provider,
    JobProvider jobProvider,
  ) async {
    if (provider.profile != null) {
      await provider.updateProfileModelForBasicInfo();
      provider.clearBasicProfile();
      Future.delayed(const Duration(seconds: 2), () {
        jobProvider.fetchJobs(applyCityFilter: true);
      });
    }
    NavigationService.pop();
  }

  Widget _customBody(ProfileProvider provider, AppColors colors) {
    final bool isVerified = provider.profile?.isUserVerified == true;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              title: "First Name*",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              controller: provider.firstname,
              hint: "Enter First Name",
            ),
            const SizedBox(height: 15),
            customText(
              title: "Middle Name",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              controller: provider.middlename,
              hint: "Enter Middle Name",
            ),
            const SizedBox(height: 15),
            customText(
              title: "Last Name*",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              controller: provider.lastname,
              hint: "Enter Last Name",
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                customText(
                  title: "Contact Number",
                  fontStyle: FontStyle.italic,
                  color: colors.headingColor,
                ),
                Icon(
                  Icons.lock_outline_rounded,
                  color: colors.darkBlue,
                  size: 15,
                ),
              ],
            ),
            CustomTextFieldforAll(
              controller: provider.contactno,
              hint: "Enter Contact Number",
              isPrimaryNumber: true,
              isDisabled: false,
            ),
            const SizedBox(height: 15),
            customText(
              title: "Alternate Number",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              controller: provider.alternateno,
              hint: "Enter Alternate Number",
              isNumber: true,
              maxLength: 10,
            ),

            const SizedBox(height: 15),
            customText(
              title: "Email ID",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              controller: provider.emailid,
              hint: "Enter Email ID",
              isGmail: true,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                customText(
                  title: "Gender*",
                  fontStyle: FontStyle.italic,
                  color: colors.headingColor,
                ),
                if (isVerified)
                  Icon(
                    Icons.lock_outline_rounded,
                    color: colors.darkBlue,
                    size: 15,
                  ),
              ],
            ),
            Builder(
              builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomGenderButton(
                      width: MediaQuery.of(context).size.width / 2.33,
                      height: 40,
                      title: "  Male  ",
                      isSelect: provider.male,
                      onTap: isVerified
                          ? () {}
                          : () {
                              provider.setGender('male');
                            },
                    ),
                    CustomGenderButton(
                      width: MediaQuery.of(context).size.width / 2.33,
                      height: 40,
                      title: "  Female  ",
                      isSelect: provider.female,
                      onTap: isVerified
                          ? () {}
                          : () {
                              provider.setGender('female');
                            },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                customText(
                  title: "Date of Birth*",
                  fontStyle: FontStyle.italic,
                  color: colors.headingColor,
                ),
                if (isVerified)
                  Icon(
                    Icons.lock_outline_rounded,
                    color: colors.darkBlue,
                    size: 15,
                  ),
              ],
            ),
            CustomTextFieldforAll(
              isPrimaryNumber: isVerified ? true : false,
              sufix: provider.age,
              prefixicon: CustomIconUrl.dojicon,
              controller: provider.dateofbirth,
              hint: "Select DOB",
              readonly: true, // Make field read-only to prevent manual input
              onTab: isVerified
                  ? () {}
                  : () async {
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
                        provider.setage(
                          AgeCalculator.calculateAge(
                            provider.dateofbirth.text,
                          )!,
                        );
                      }
                    },
            ),
            const SizedBox(height: 15),
            customText(
              title: "Locality*",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.locality,
              hintText: "Type to search",
              name: "location",
              title: "Locality",
            ),
            const SizedBox(height: 15),
            customText(
              title: "City*",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.location,
              hintText: "Type to search",
              name: "city",
              title: "Location",
            ),
            const SizedBox(height: 15),
            customText(
              title: "Pin Code*",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.pincode,
              hintText: "Type to search",
              name: "pin_code",
              title: "Pin Code",
            ),
            const SizedBox(height: 15),
            customText(
              title: "Languages*",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: provider.language
                  .map(
                    (e) => CustomToggleButton(
                      isSelect: provider.selectedLanguages.contains(e),
                      title: e,
                      onTap: () => provider.toggleLanguage(e),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 15),
            customText(
              title: "Profile Headline",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomAutoSizeTextField(
              maxLength: 120,
              controller: provider.profileHeadline,
              hintText: "Enter your profile headline",
              maxline: 3,
            ),
            SizedBox(height: 15),
            customText(
              title: "Linkdin URL",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              controller: provider.linkdinUrl,
              hint: "Enter Linkdin URL",
              isGmail: true,
            ),
            SizedBox(height: 15),
            customText(
              title: "Profile Role",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              controller: provider.profileRole,
              hint: "Enter Profile Role",
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
            if (provider.vaccinated &&
                (provider.vaccinationCertificate == null ||
                    provider.vaccinationCertificate == '' ||
                    provider.vaccinationCertificate == 'null'))
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
            if (provider.vaccinated &&
                provider.vaccinationCertificate != null &&
                provider.vaccinationCertificate != '' &&
                provider.vaccinationCertificate != 'null')
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
                      title: "Vaccination Certificate",
                      pdfUrl:
                          "${GlobalConstants.Image_url}${provider.vaccinationCertificate}",
                      isFromAts: false,
                      onDelete: () async {
                        await FileUploadService().deleteSingleFile(
                          provider.vaccinationCertificate.toString(),
                        );
                        provider.setVaccinationCertificate('null');
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
