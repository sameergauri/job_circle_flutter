// ignore_for_file: must_be_immutable, non_constant_identifier_names, unrelated_type_equality_checks, invalid_use_of_visible_for_testing_member, avoid_unnecessary_containers, deprecated_member_use
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/date_picker/custom_date_picker.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_popup_for_location.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_suggestion_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:job_circle/src/widgets/text_field/custom_textfield_for_skills.dart';
import 'package:provider/provider.dart';

class ProfileExperienceEdit extends StatelessWidget {
  final FromEditOrAdd fromEditOrAdd;
  const ProfileExperienceEdit({super.key, required this.fromEditOrAdd});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Constants.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            titleSpacing: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const OnboardingTitle(title: "Experience", fontSize: 16),
            actions: [
              !provider.showExperienceForm &&
                      provider.profile!.experiences!.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        provider.clearExperienceForm();
                        provider.setShowExperienceForm(true);
                      },
                      icon: const Icon(Icons.add),
                    )
                  : (provider.profile!.experiences != null &&
                        provider.profile!.experiences!.isNotEmpty &&
                        fromEditOrAdd == FromEditOrAdd.edit)
                  ? IconButton(
                      onPressed: () {
                        provider.cancelExperienceEdit();
                        if (provider.profile!.experiences != null &&
                            provider.profile!.experiences!.length == 1) {
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
                provider.profile!.experiences!.isEmpty ||
                    provider.showExperienceForm
                ? customForm(provider, context)
                : CustomBody(provider),
          ),
        );
      },
    );
  }

  Widget CustomBody(ProfileProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Divider(height: 1),
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.profile!.experiences!.length,
        itemBuilder: (context, index) {
          final sortedExperiences = [...provider.profile!.experiences!];

          sortedExperiences.sort((a, b) {
            // If a is currently working and b is not, a comes first
            if (a.isCurrent == true && b.isCurrent != true) return -1;
            if (b.isCurrent == true && a.isCurrent != true) return 1;

            // If both are not currently working, compare by lastDate or startDate
            DateTime aDate = (a.lastWorkingDate is DateTime
                ? a.lastWorkingDate as DateTime
                : DateTime(1900));
            DateTime bDate = b.lastWorkingDate is DateTime
                ? b.lastWorkingDate as DateTime
                : DateTime(1900);
            return bDate.compareTo(aDate); // Descending order
          });
          var exp = sortedExperiences[index];
          return CustomNewListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Constants.lightdull),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (exp.companyLogo != null && exp.companyLogo!.isNotEmpty)
                  ? CustomNetworkImage(
                      imageUrl:
                          "${GlobalConstants.Image_url}${exp.companyLogo}",
                      defaultIcon: Icons.home,
                    )
                  : CustomNetworkImage(
                      imageUrl: CustomIconUrl.companyicon,
                      defaultIcon: Icons.business,
                      color: Constants.subtitleclr,
                    ),
            ),
            title: customText(
              title: exp.jobTitle!,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    customText(
                      title: exp.companyName!,
                      fontWeight: FontWeight.w500,
                      color: Constants.subtitleclr,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (exp.empType != null && exp.empType != '')
                      customText(
                        title: ' • ${exp.empType!}',
                        fontWeight: FontWeight.w500,
                        color: Constants.subtitleclr,
                      ),
                  ],
                ),
                if (exp.workingPeriod != null && exp.workingPeriod != "")
                  customText(
                    title:
                        exp.workingPeriod
                            ?.split(',')
                            .map((part) => part.trim())
                            .toList()
                            .asMap()
                            .map(
                              (i, part) => i == 1
                                  ? MapEntry(i, '($part)')
                                  : MapEntry(i, part),
                            )
                            .values
                            .join(' ')
                            .replaceAll('months', 'mos') ??
                        "",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Constants.subtitleclr,
                    overflow: TextOverflow.ellipsis,
                  ),
                Row(
                  children: [
                    if (exp.jobLocation != null)
                      customText(
                        title: exp.jobLocation!,
                        fontWeight: FontWeight.w500,
                        color: Constants.subtitleclr,
                      ),
                    if (exp.workType != null && exp.workType != '')
                      customText(
                        title: ' • ${exp.workType!}',
                        fontWeight: FontWeight.w500,
                        color: Constants.subtitleclr,
                      ),
                  ],
                ),
              ],
            ),
            trailing: CustomIconButton(
              imageUrl: CustomIconUrl.editicon,
              onTap: () {
                provider.editExperience(index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget customForm(ProfileProvider provider, BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            const customText(title: "Job Title*", fontStyle: FontStyle.italic),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.jobtitle,
              hintText: "Type to search",
              name: "job_role",
              title: "Job Title",
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Company Name*",
              fontStyle: FontStyle.italic,
            ),
            CustomSuggestionTextField(
              EnableAddOption: true,
              type: SuggestionType.company,
              onIdSelected: (p0) {
                // ignore: invalid_use_of_protected_member
                provider.notifyListeners();
              },
              name: "company",
              title: "Company Name",
              controller: provider.companyname,
              onChanged: (p0) {},
              hintText: "Company Name",
            ),
            const SizedBox(height: 15),
            const customText(title: "Industry*", fontStyle: FontStyle.italic),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.industry,
              hintText: "Type to search",
              name: "industry",
              title: "Industry",
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Functional Area*",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.functionalArea,
              hintText: "Type to search",
              name: "functional_area",
              title: "Functional Area",
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Employment Type*",
              fontStyle: FontStyle.italic,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  CustomToggleButton(
                    isSelect: provider.fullTime,
                    title: "Full Time",
                    onTap: () {
                      provider.setEmpType("Full Time");
                    },
                  ),
                  CustomToggleButton(
                    isSelect: provider.partTime,
                    title: "Part Time",
                    onTap: () {
                      provider.setEmpType("Part Time");
                    },
                  ),
                  CustomToggleButton(
                    isSelect: provider.contractual,
                    title: "Contractual",
                    onTap: () {
                      provider.setEmpType("Contractual");
                    },
                  ),
                  CustomToggleButton(
                    isSelect: provider.freelancer,
                    title: "Freelancer",
                    onTap: () {
                      provider.setEmpType("Freelancer");
                    },
                  ),
                  CustomToggleButton(
                    isSelect: provider.internship,
                    title: "Internship",
                    onTap: () {
                      provider.setEmpType("Internship");
                    },
                  ),
                  CustomToggleButton(
                    isSelect: provider.selfemployee,
                    title: "Self Employed",
                    onTap: () {
                      provider.setEmpType("Self Employee");
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const customText(title: "Work Mode*", fontStyle: FontStyle.italic),
            Wrap(
              children: [
                CustomPopUpForLocation(
                  isWorkspace: true,
                  initiallySelectedItems: provider.onSiteLocation != null
                      ? [provider.onSiteLocation!]
                      : [],
                  onSelectionComplete: (selectedItems) {},
                  isSelect: provider.onSite,
                  title: "On-Site",
                  name: "location",
                  hintText: "Mumbai",
                  onSubmit: (p0) {
                    provider.setWorkType(1, p0);
                  },
                ),
                CustomPopUpForLocation(
                  onSelectionComplete: (selectedItems) {},
                  isWorkspace: true,
                  initiallySelectedItems: provider.hybridLocation != null
                      ? [provider.hybridLocation!]
                      : [],
                  onSubmit: (selectedItems) {
                    provider.setWorkType(2, selectedItems);
                  },
                  isSelect: provider.hybrid,
                  title: "Hybrid",
                  name: "location",
                  hintText: "Mumbai",
                ),
                CustomPopUpForLocation(
                  onSelectionComplete: (selectedItems) {},
                  isWorkspace: true,
                  initiallySelectedItems: provider.remoteLocation != null
                      ? [provider.remoteLocation!]
                      : [],
                  onSubmit: (selectedItems) {
                    provider.setWorkType(3, selectedItems);
                  },
                  isSelect: provider.remote,
                  title: "Remote",
                  name: "city",
                  hintText: "Mumbai",
                ),
                /*  CustomToggleButton(
                            isSelect: provider.remote,
                            title: "Remote",
                            onTap: () {
                              provider.setWorktype(3, null);
                            },
                          ), */
              ],
            ),
            if ((provider.onSiteLocation != null ||
                provider.hybridLocation != null ||
                provider.remoteLocation != null))
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const customText(title: "Job Location"),
                    CustomToggleButton(
                      isSelect: true,
                      title: provider.onSiteLocation != null
                          ? provider.onSiteLocation!.formateData.toString()
                          : provider.hybridLocation != null
                          ? provider.hybridLocation!.formateData.toString()
                          : provider.remoteLocation != null
                          ? provider.remoteLocation!.formateData.toString()
                          : "",
                      onTap: () {},
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customText(
                      title: "Start Date*",
                      fontStyle: FontStyle.italic,
                    ),
                    SizedBox(
                      width: width / 2.6,
                      child: CustomTextFieldforAll(
                        prefixicon: CustomIconUrl.dojicon,
                        controller: provider.startDate,
                        hint: "Select start date",
                        readonly: true,
                        onTab: () async {
                          DateTime? initialDate;
                          if (provider.startDate.text.isNotEmpty) {
                            try {
                              initialDate = DateFormat(
                                'dd MMM yyyy',
                              ).parse(provider.startDate.text);
                            } catch (e) {
                              initialDate = DateTime.now();
                            }
                          } else {
                            initialDate = DateTime.now();
                          }

                          // Get lastDate for maxDate constraint
                          DateTime? maxDate;
                          if (provider.lastWorkingDate.text.isNotEmpty) {
                            try {
                              maxDate = DateFormat(
                                'dd MMM yyyy',
                              ).parse(provider.lastWorkingDate.text);
                            } catch (e) {
                              maxDate = null;
                            }
                          }

                          DateTime? selectedDate =
                              await CustomDatePickerForWorkSpace.selectDate(
                                context: context,
                                initialDate: initialDate,
                                title: "Select Start Date",
                                maxDate: maxDate,
                                isStartDate: true,
                              );

                          if (selectedDate != null) {
                            String formattedDate = DateFormat(
                              'dd MMM yyyy',
                            ).format(selectedDate);
                            provider.setStartDate(formattedDate);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (!provider.currentlyWorking &&
                    provider.startDate.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const customText(
                        title: "Last Date*",
                        fontStyle: FontStyle.italic,
                      ),
                      SizedBox(
                        width: width / 2.6,
                        child: CustomTextFieldforAll(
                          prefixicon: CustomIconUrl.dojicon,
                          controller: provider.lastWorkingDate,
                          hint: "Select last date",
                          readonly: true,
                          onTab: () async {
                            DateTime? initialDate;
                            if (provider.lastWorkingDate.text.isNotEmpty) {
                              try {
                                initialDate = DateFormat(
                                  'dd MMM yyyy',
                                ).parse(provider.lastWorkingDate.text);
                              } catch (e) {
                                initialDate = DateTime.now();
                              }
                            } else {
                              initialDate = DateTime.now();
                            }

                            // Get startDate for minDate constraint
                            DateTime? minDate;
                            if (provider.startDate.text.isNotEmpty) {
                              try {
                                minDate = DateFormat(
                                  'dd MMM yyyy',
                                ).parse(provider.startDate.text);
                                // Add 1 day to minDate to ensure lastDate is after startDate
                                minDate = minDate.add(const Duration(days: 1));
                              } catch (e) {
                                minDate = null;
                              }
                            }

                            DateTime? selectedDate =
                                await CustomDatePickerForWorkSpace.selectDate(
                                  context: context,

                                  initialDate:
                                      provider.startDate.text.isNotEmpty
                                      ? DateFormat('dd MMM yyyy')
                                            .parse(provider.startDate.text)
                                            .add(const Duration(days: 1))
                                      : initialDate,
                                  title: "Select Last Date",
                                  minDate: provider.startDate.text.isNotEmpty
                                      ? DateFormat('dd MMM yyyy')
                                            .parse(provider.startDate.text)
                                            .add(const Duration(days: 1))
                                      : minDate,
                                  isStartDate: false,
                                );

                            if (selectedDate != null) {
                              String formattedDate = DateFormat(
                                'dd MMM yyyy',
                              ).format(selectedDate);
                              provider.setLastDate(formattedDate);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            CustomCheckboxRow(
              title: "Currently Working*",
              value: provider.currentlyWorking,
              onChanged: (value) {
                provider.lastWorkingDate.clear();
                //  provider.clearExp();
                provider.setCurrentlyWorking(value!);
              },
            ),
            SizedBox(height: 15),

            //
            //
            //
            //
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const customText(title: "Job Responsibiity"),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: provider.jobrole,
                    builder: (context, value, child) {
                      if (provider.jobtitle.text.isNotEmpty) {
                        if (value.text.isEmpty &&
                            provider.isResponsibilityGenerated == false) {
                          return InkWell(
                            onTap: () async {
                              provider.fetchResponsibilityUsingAi();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                color: Constants.lightdull,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Constants.subtitleclr,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CustomNetworkImage(
                                    imageUrl: CustomIconUrl.aiicon,
                                    defaultIcon: Icons.star_border_outlined,
                                  ),
                                  customText(
                                    title: "AI writer",
                                    color: Constants.winecolor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () async {
                              provider.clearResponsibility();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 4,
                                bottom: 4,
                              ),
                              child: customText(
                                title: "Clear All",
                                color: Constants.red,
                              ),
                            ),
                          );
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
            //
            //
            //
            //
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                CustomAutoSizeTextField(
                  needClearAll: false,
                  controller: provider.jobrole,
                  hintText: "My job profile is",
                  maxline: 8,
                  maxLength: 1200,
                ),
                if (provider.isResponsibilityLoading)
                  Container(
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Constants.darkBlue,
                        strokeWidth: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 15),
            const customText(title: "Skills*", fontStyle: FontStyle.italic),
            CustomTextFieldForSkills(
              title: "Skills",
              initialSkills: provider.skills,
              onSkillsChanged: (skills) {
                provider.assignSkillsToExperience(skills);
              },
              name: "skills",
              controller: provider.skillController,
              hintText: "Enter your skills",
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Anual Salary",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldforAll(
              isGmail: true,
              maxLength: 7,
              isNumber: true,
              controller: provider.anualSalary,
              hint: "Enter salary",
            ),

            SizedBox(height: 15),
            const customText(
              title: "Profile Headline",
              fontStyle: FontStyle.italic,
            ),
            CustomAutoSizeTextField(
              maxLength: 120,
              controller: provider.profileHeadline,
              hintText: "Enter your profile headline",
              maxline: 3,
            ),

            const SizedBox(height: 15),
            //
            //
            //
            const customText(
              title: "Career Assets",
              fontStyle: FontStyle.italic,
            ),
            //
            //
            //
            //
            //
            //
            //
            //
            //
            provider.offerLetter != null
                ? CustomContainerSelectToViewDoc(
                    heading: "",
                    candidateName: "Offer Letter",
                    isDocx:
                        provider.offerLetter!.contains('doocx') ||
                            provider.offerLetter!.contains('doc')
                        ? true
                        : false,
                    onPressed: () {
                      NavigationService.push(
                        CustomPDFViewerDialog(
                          title: "Offer Letter",
                          isFromAts: true,
                          pdfUrl:
                              "${GlobalConstants.Image_url}${provider.offerLetter}",
                          onDelete: () async {
                            await FileUploadService().deleteSingleFile(
                              provider.offerLetter!,
                            );
                            provider.setOfferLetter("");
                            // Add your logic for removing here
                          },
                        ),
                      );
                    },
                    title: "Offer Letter",
                  )
                : const SizedBox(),

            provider.appointmentLetter != null
                ? CustomContainerSelectToViewDoc(
                    heading: "",
                    candidateName: "Appointment Letter",
                    isDocx:
                        provider.appointmentLetter!.contains('doocx') ||
                            provider.appointmentLetter!.contains('doc')
                        ? true
                        : false,
                    onPressed: () {
                      NavigationService.push(
                        CustomPDFViewerDialog(
                          title: 'Appointment Letter',
                          isFromAts: true,
                          pdfUrl:
                              "${GlobalConstants.Image_url}${provider.appointmentLetter}",
                          onDelete: () async {
                            await FileUploadService().deleteSingleFile(
                              provider.appointmentLetter!,
                            );
                            provider.setAppointmentLetter("");
                            // Add your logic for removing here
                          },
                        ),
                      );
                    },
                    title: "Appointment Letter",
                  )
                : const SizedBox(),
            provider.salarySlip != null
                ? CustomContainerSelectToViewDoc(
                    heading: '',
                    candidateName: "Salary Slip",
                    isDocx:
                        provider.salarySlip!.contains('doocx') ||
                            provider.salarySlip!.contains('doc')
                        ? true
                        : false,
                    onPressed: () {
                      NavigationService.push(
                        CustomPDFViewerDialog(
                          title: "Salary Slip",
                          isFromAts: true,
                          pdfUrl:
                              "${GlobalConstants.Image_url}${provider.salarySlip}",
                          onDelete: () async {
                            await FileUploadService().deleteSingleFile(
                              provider.salarySlip!,
                            );
                            provider.setSalarySlip("");
                            // Add your logic for removing here
                          },
                        ),
                      );
                    },
                    title: "Salary Slip",
                  )
                : const SizedBox(),
            provider.incrementLetter != null
                ? CustomContainerSelectToViewDoc(
                    heading: "",
                    candidateName: "Increament Letter",
                    isDocx:
                        provider.incrementLetter!.contains('doocx') ||
                            provider.incrementLetter!.contains('doc')
                        ? true
                        : false,
                    onPressed: () {
                      NavigationService.push(
                        CustomPDFViewerDialog(
                          title: 'Increment Letter',
                          isFromAts: true,
                          pdfUrl:
                              "${GlobalConstants.Image_url}${provider.incrementLetter}",
                          onDelete: () async {
                            await FileUploadService().deleteSingleFile(
                              provider.incrementLetter!,
                            );
                            provider.setIncrementLetter("");
                            // Add your logic for removing here
                          },
                        ),
                      );
                    },
                    title: "Increment Letter",
                  )
                : const SizedBox(),
            provider.experienceLetter != null
                ? CustomContainerSelectToViewDoc(
                    heading: "",
                    candidateName: "Experience Letter",
                    isDocx:
                        provider.experienceLetter!.contains('doocx') ||
                            provider.experienceLetter!.contains('doc')
                        ? true
                        : false,
                    onPressed: () {
                      NavigationService.push(
                        CustomPDFViewerDialog(
                          title: 'Experience Letter',
                          isFromAts: true,
                          pdfUrl:
                              "${GlobalConstants.Image_url}${provider.experienceLetter}",
                          onDelete: () async {
                            await FileUploadService().deleteSingleFile(
                              provider.experienceLetter!,
                            );
                            provider.setExperienceLetter("");
                            // Add your logic for removing here
                          },
                        ),
                      );
                    },
                    title: "Experience Letter",
                  )
                : !provider.currentlyWorking
                ? const SizedBox()
                : const SizedBox(),
            //
            //
            //
            //
            //
            //
            //
            //
            if (provider.offerLetter == null ||
                provider.appointmentLetter == null ||
                provider.salarySlip == null ||
                provider.incrementLetter == null ||
                (provider.lastWorkingDate.text.isNotEmpty &&
                    provider.experienceLetter == null))
              CustomDocumentUploadButton(
                subTitle: "Supported format : PDF",
                onTab: () {
                  showModalBottomSheet(
                    barrierColor: Colors.black.withOpacity(0.5),
                    isScrollControlled: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return _buildBottomSheetContent(context, provider);
                    },
                  );
                },
                title: "Add Document",
              ),

            const SizedBox(height: 15),
            if (provider.isEditingExperience &&
                provider.profile!.experiences!.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.removeExperience(
                        provider.isEditExperienceIndex!,
                      );
                      provider.clearExperienceForm();
                      provider.setShowExperienceForm(false);
                    },
                    child: customText(title: "Delete Experience"),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () {
                  if (provider.jobtitle.text.isEmpty) {
                    CustomSnackbar.show("Enter Job Title", true);
                  } else if (provider.companyname.text.isEmpty) {
                    CustomSnackbar.show("Enter Company Name", true);
                  } else if (provider.industry.text.isEmpty) {
                    CustomSnackbar.show("Enter Industry", true);
                  } else if (provider.functionalArea.text.isEmpty) {
                    CustomSnackbar.show("Enter Functional Area", true);
                  } else if (provider.startDate.text.isEmpty) {
                    CustomSnackbar.show("Enter Start date", true);
                  } else if (!provider.currentlyWorking &&
                      provider.lastWorkingDate.text.isEmpty) {
                    CustomSnackbar.show("Enter Last date", true);
                  } else if (!provider.onSite &&
                      !provider.hybrid &&
                      !provider.remote) {
                    CustomSnackbar.show("Select work mode", true);
                  } else if (!provider.fullTime &&
                      !provider.partTime &&
                      !provider.contractual &&
                      !provider.freelancer &&
                      !provider.internship) {
                    CustomSnackbar.show("Select employmentType", true);
                  } else {
                    provider.addOrUpdateExperience();
                  }
                },
                title: /*  provider.isEditingExperience ? "Update" : */ "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
  // TODO::: Custom bottomsheet for document upload...
  //
  //
  //
  //

  Widget _buildBottomSheetContent(
    BuildContext context,
    ProfileProvider provider,
  ) {
    final List<String> options = [
      "Offer Letter",
      "Appointment Letter",
      "Salary Slip",
      "Increment Letter",
      "Experience / Relieving Letter",
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Career Assets",
            style: GoogleFonts.varela(
              color: Constants.themeBgColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              return GestureDetector(
                onTap: () async {
                  FileUploader fileUploader = FileUploader();
                  if (option == "Offer Letter") {
                    final offer = await fileUploader.uploadFile(context, [
                      'pdf',
                    ], "offerLetter");
                    provider.setOfferLetter(offer!);
                  NavigationService.pop();
                  } else if (option == "Appointment Letter") {
                    final app = await fileUploader.uploadFile(context, [
                      'pdf',
                    ], "appointmentLetter");
                    provider.setAppointmentLetter(app!);
                   NavigationService.pop();
                  } else if (option == "Salary Slip") {
                    final sal = await fileUploader.uploadFile(context, [
                      'pdf',
                    ], "alarySlip");
                    provider.setSalarySlip(sal!);
                   NavigationService.pop();
                  } else if (option == "Increment Letter") {
                    final incrementLetter = await fileUploader.uploadFile(
                      context,
                      ['pdf'],
                      "incrementLetter",
                    );
                    provider.setIncrementLetter(incrementLetter!);
                   NavigationService.pop();
                  } else if (option == "Experience / Relieving Letter") {
                    final experienceLetter = await fileUploader.uploadFile(
                      context,
                      ['pdf'],
                      "experienceLetter",
                    );
                    provider.setExperienceLetter(experienceLetter!);
                  NavigationService.pop();
                    /*  experienceLetter = await uploadFile(
                          allowExt: ['pdf'], isexperience: true); */
                  }
                },
                child: provider.offerLetter != null && option == "Offer Letter"
                    ? const SizedBox()
                    : provider.appointmentLetter != null &&
                          option == "Appointment Letter"
                    ? const SizedBox()
                    : provider.salarySlip != null && option == "Salary Slip"
                    ? const SizedBox()
                    : provider.incrementLetter != null &&
                          option == "Increment Letter"
                    ? const SizedBox()
                    : provider.experienceLetter != null &&
                          option == "Experience / Relieving Letter" &&
                          provider.lastWorkingDate.text.isEmpty
                    ? const SizedBox()
                    : option == "Experience / Relieving Letter" &&
                          provider.lastWorkingDate.text.isEmpty
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Constants.subtitleclr,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                          color: index % 2 == 0
                              ? Constants.lightdull
                              : Constants.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          trailing: const Icon(Icons.add),
                          title: customText(fontSize: 12, title: option),
                        ),
                      ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
