// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart'
    show NavigationService;
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/dropdown/month_drop_down.dart';
import 'package:job_circle/src/widgets/dropdown/year_drop_down.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:provider/provider.dart';

class ProfileEducationEdit extends StatelessWidget {
  final FromEditOrAdd fromEditOrAdd;
  const ProfileEducationEdit({super.key, required this.fromEditOrAdd});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Constants.white,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Constants.borderColor,
                elevation: 0,
                titleSpacing: 0.0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const OnboardingTitle(title: "Education", fontSize: 16),
                actions: [
                  !provider.showEducationForm &&
                          provider.profile!.educationDetails!.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            provider.clearEducationForm();
                            provider.setShowEducationForm(true);
                          },
                          icon: const Icon(Icons.add),
                        )
                      : (provider.profile!.educationDetails != null &&
                            provider.profile!.educationDetails!.isNotEmpty &&
                            fromEditOrAdd == FromEditOrAdd.edit)
                      ? IconButton(
                          onPressed: () {
                            provider.cancelEducationEdit();
                            if (provider.profile!.educationDetails != null &&
                                provider.profile!.educationDetails!.length ==
                                    1) {
                              NavigationService.pop();
                            }
                          },
                          icon: const Icon(Icons.cancel_outlined),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              body: SafeArea(
                child:
                    provider.profile!.educationDetails!.isEmpty ||
                        provider.showEducationForm
                    ? customForm(provider, context)
                    : CustomBody(provider),
              ),
            ),
            if (provider.isUpdating) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  Widget customForm(ProfileProvider provider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            const customText(
              title: "School / College Name",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldForMasterData(
              focusNode: provider.schoolCollegeNameFocusNode,
              contextIn: context,
              controller: provider.schoolCollegeName,
              hintText: "Type to search",
              name: "school",
              title: "School/College Name",
            ),
            if (provider.schoolCollegeName.text.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: CustomCheckboxRow(
                  title: "Study Remotely",
                  value: provider.isRemote,
                  onChanged: (value) {
                    provider.setIsRemote(value!);
                  },
                ),
              ),
            const SizedBox(height: 15),
            const customText(
              title: "University / Board Name*",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldForMasterData(
              focusNode: provider.universityBoardNameFocusNode,
              contextIn: context,
              controller: provider.universityBoardName,
              hintText: "Type to search",
              name: "university",
              title: "University / Board Name",
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Course / Degree*",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldForMasterData(
              focusNode: provider.degreeFocusNode,
              contextIn: context,
              controller: provider.degree,
              hintText: "Type to search",
              name: "degree",
              title: "Course / Degree",
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Field of Study",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldForMasterData(
              focusNode: provider.fieldOfStudyFocusNode,
              contextIn: context,
              controller: provider.fieldOfStudy,
              hintText: "Type to search",
              name: "field_of_study",
              title: "Field of study",
            ),
            SizedBox(height: 10),
            const customText(title: "Course Type", fontStyle: FontStyle.italic),
            Wrap(
              spacing: 10,
              children: [
                CustomToggleButton(
                  title: "Full Time",
                  isSelect: provider.fullTimeCourse,
                  onTap: () {
                    provider.setCourseType("FullTime");
                  },
                ),
                CustomToggleButton(
                  title: "Part Time",
                  isSelect: provider.partTimeCourse,
                  onTap: () {
                    provider.setCourseType("PartTime");
                  },
                ),
                CustomToggleButton(
                  title: "Distance Learning",
                  isSelect: provider.distanceLearning,
                  onTap: () {
                    provider.setCourseType("Distance Learning");
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            customText(title: "Start Year*"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: MonthDropdown(
                    controller: provider.startmonth,
                    hint: "Select Month",
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: DropDownYear(
                    hint: 'Select Year',
                    controller: provider.startyear,
                    isFirst: true,
                    onChanged: (value) {
                      // ignore: invalid_use_of_visible_for_testing_member
                      provider.notifyListeners();

                      // Also clear the End Year because the old value might be invalid now
                      provider.endyear.clear();
                    },
                  ),
                  // child: DropDownYear("Select Year", provider.startYear, true)
                ),
              ],
            ),
            if (!provider.currentlyStudying) const SizedBox(height: 15),
            if (!provider.currentlyStudying)
              const customText(title: "End Year*"),
            if (!provider.currentlyStudying)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: MonthDropdown(
                      controller: provider.endmonth,
                      hint: "Select Month",
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: DropDownYear(
                      hint: "Select Year",
                      controller: provider.endyear,
                      isFirst: false,
                      firstYearController: provider.startyear,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 10),
            CustomCheckboxRow(
              title: "Currently Studying",
              value: provider.currentlyStudying,
              onChanged: (value) {
                provider.endmonth.clear();
                provider.endyear.clear();
                provider.setCurrentlyStudying(value!);
              },
            ),

            SizedBox(height: 10),
            if (provider.markSheet == null ||
                provider.markSheet == '' ||
                provider.markSheet == "null")
              CustomDocumentUploadButton(
                subTitle: "Supported format : PDF",
                onTab: () async {
                  FileUploader fileUploader = FileUploader();
                  var data = await fileUploader.uploadFile(context, [
                    'pdf',
                  ], "resume");
                  if (data != null) {
                    provider.setMarkSheet(data);
                  }
                },
                title: "MarkSheet",
              ),
            if (provider.markSheet != null &&
                provider.markSheet != '' &&
                provider.markSheet != "null")
              CustomContainerSelectToViewDoc(
                isDocx:
                    provider.markSheet!.contains('.docx') ||
                        provider.markSheet!.contains('.doc')
                    ? true
                    : false,
                candidateName: 'MarkSheet',
                heading: "MarkSheet",
                title: provider.markSheet.toString(),
                onPressed: () {
                  NavigationService.push(
                    CustomPDFViewerDialog(
                      title: 'MarkSheet',
                      pdfUrl:
                          "${GlobalConstants.Image_url}${provider.markSheet}",
                      isFromAts: false,
                      onDelete: () async {
                        await FileUploadService().deleteSingleFile(
                          provider.markSheet.toString(),
                        );
                        provider.setMarkSheet('');
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 15),
            if (provider.isEditingEducation &&
                provider.profile!.educationDetails!.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.removeEducation(provider.isEditEducationIndex!);
                      provider.clearEducationForm();
                      provider.setShowEducationForm(false);
                    },
                    child: customText(title: "Delete Education"),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () {
                  if (provider.schoolCollegeName.text.isEmpty &&
                      !provider.isRemote) {
                    CustomSnackbar.show(
                      "Enter School/College Name to save education",
                      true,
                    );
                  } else if (provider.universityBoardName.text.isEmpty) {
                    CustomSnackbar.show("Enter university name", true);
                  } else if (provider.degree.text.isEmpty) {
                    CustomSnackbar.show("Enter Degree to save education", true);
                  } else if (provider.startmonth.text.isEmpty ||
                      provider.startyear.text.isEmpty) {
                    CustomSnackbar.show("Enter Start Year", true);
                  } else if ((provider.endmonth.text.isEmpty ||
                          provider.endyear.text.isEmpty) &&
                      !provider.currentlyStudying) {
                    CustomSnackbar.show("Enter End Year", true);
                  } else {
                    provider.addOrUpdateEducation();
                    // Update profile model if it's CV parse profile
                    if (provider.profile != null) {
                      // provider.updateProfileModelFromControllers();
                    }
                  }
                },
                title: /* provider.isEditingEducation ? "Update" : */ "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomBody(ProfileProvider provider) {
    // Sort the list but keep track of original indices
    final sortedEducationsWithIndex = List.generate(
      provider.profile!.educationDetails!.length,
      (index) => {
        'education': provider.profile!.educationDetails![index],
        'originalIndex': index,
      },
    );

    sortedEducationsWithIndex.sort((a, b) {
      final eduA = a['education'] as EducationDetail;
      final eduB = b['education'] as EducationDetail;

      // Priority 1: Currently Pursuing/Studying सबसे ऊपर
      if (eduA.isCurrent == 1 && eduB.isCurrent != 1) return -1;
      if (eduB.isCurrent == 1 && eduA.isCurrent != 1) return 1;

      // Priority 2: Year के हिसाब से (Latest Year First)
      int aYear = eduA.passingYear ?? eduA.firstYear ?? 0;
      int bYear = eduB.passingYear ?? eduB.firstYear ?? 0;
      return bYear.compareTo(aYear); // Descending order
    });
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Divider(height: 1),
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedEducationsWithIndex.length,
        itemBuilder: (context, index) {
          final item = sortedEducationsWithIndex[index];
          final edu = item['education'] as EducationDetail;
          final originalIndex = item['originalIndex'] as int;
          return CustomNewListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Constants.lightdull),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  (edu.universityLogo != null && edu.universityLogo!.isNotEmpty)
                  ? CustomNetworkImage(
                      imageUrl:
                          "${GlobalConstants.Image_url}${edu.universityLogo}",
                      defaultIcon: Icons.business_sharp,
                    )
                  : const CustomNetworkImage(
                      height: 24,
                      color: Constants.subtitleclr,
                      imageUrl: CustomIconUrl.schoolicon,
                      defaultIcon: Icons.school_outlined,
                    ),
            ),
            title: customText(
              title: edu.degreeSpc ?? '',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (edu.schoolOrCollegeName != null &&
                    edu.schoolOrCollegeName != '')
                  customText(
                    title: edu.schoolOrCollegeName ?? '',
                    fontWeight: FontWeight.w500,
                    color: Constants.subtitleclr,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (edu.university != null && edu.university != '')
                  customText(
                    title: edu.university!,
                    fontWeight: FontWeight.w500,
                    color: Constants.subtitleclr,
                  ),
                Row(
                  children: [
                    edu.isCurrent == 1
                        ? customText(
                            monst: true,
                            title: "Pursuing",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Constants.subtitleclr,
                            overflow: TextOverflow.ellipsis,
                          )
                        : edu.passingYear != null
                        ? customText(
                            monst: true,
                            title:
                                edu.endMonth != null &&
                                    edu.endMonth != "Unknown"
                                ? '${MonthNameConverter.getShortMonthName(edu.endMonth)} - ${edu.passingYear.toString()}'
                                : edu.passingYear.toString(),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Constants.subtitleclr,
                            overflow: TextOverflow.ellipsis,
                          )
                        : customText(
                            monst: true,
                            title:
                                edu.startMonth != null &&
                                    edu.startMonth != "Unknown"
                                ? '${MonthNameConverter.getShortMonthName(edu.startMonth)} - ${edu.firstYear.toString()}'
                                : edu.firstYear.toString(),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Constants.subtitleclr,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ],
            ),
            trailing: CustomIconButton(
              imageUrl: CustomIconUrl.editicon,
              onTap: () {
                provider.editEducation(originalIndex);
              },
            ),
          );
        },
      ),
    );
  }
}
