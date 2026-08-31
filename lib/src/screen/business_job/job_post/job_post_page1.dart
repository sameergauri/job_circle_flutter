import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_popup_for_location.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class JobPostPageOne extends StatelessWidget {
  final bool isEdit;

  const JobPostPageOne({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<BusinessJobProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: colors.bgColor,
          appBar: AppBar(
            title: customText(
              title: "Job Post",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.headingColor,
            ),
            actions: [
              CustomIconButton(
                color: colors.headingColor,
                imageUrl: CustomIconUrl.cancelicon,
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
            backgroundColor: colors.appbarColor,
            elevation: 0,
            titleSpacing: 0,
            iconTheme: IconThemeData(color: colors.headingColor),
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //============= If Job posted from somewhere else ======================//
                       /*  if (0 == 0) ...[
                          const contentHeading(title: "Company Name*"),
                          CustomTextFieldForBusinessCompany(
                            // focusNode: provider.selectedFirmFocusNode,
                            controller:
                                provider.suggestionSelectedFirmController,
                            hintText: "Company name",
                            title: "Company / Agency Name*",
                            onIdSelected: (p0) {
                              provider.setSelectedCompanyId(p0);
                            },
                            onChanged: (p0) {},
                          ),
                          const SizedBox(height: 10),
                        ],
                        //============= if user is from consultancy =============================//
                        if (0 == 0) ...[
                          const contentHeading(title: "Hiring For*"),
                          CustomTextFieldforAll(
                            hint: "Hiring For",
                            controller: provider.hiringFor,
                            maxLength: 60,
                          ),
                          const SizedBox(height: 5),
                          CustomCheckboxRow(
                            title: "Dont show to candidate",
                            value: provider.shouldShowToCandidate,
                            onChanged: (value) {
                              provider.setShouldShowToCandidate(value!);
                            },
                          ),
                          if (provider.shouldShowToCandidate) ...[
                            SizedBox(height: 5),
                            const contentHeading(
                              title: "Reason for not showing to the candidate*",
                            ),
                            CustomTextFieldforAll(
                              hint: "Reason",
                              controller: provider.reasonForNotshowToCandidate,
                              maxLength: 60,
                            ),
                          ],
                          SizedBox(height: 10),
                        ], */
                        const contentHeading(title: "Role*"),
                        CustomTextFieldForMasterData(
                          controller: provider.roleForBusinessHiiringController,
                          contextIn: context,
                          title: "Role",
                          hintText: "Select role",
                          name: "role",
                        ),
                        SizedBox(height: 10),
                        const contentHeading(title: "Functional Area*"),
                        CustomTextFieldForMasterData(
                          controller: provider
                              .functioonalAreaForBusinessHiringController,
                          contextIn: context,
                          title: "Functional Area",
                          hintText: "Select Functional Area",
                          name: "functional_area",
                        ),
                        SizedBox(height: 10),
                        const contentHeading(title: "Job Headline*"),
                        CustomTextFieldforAll(
                          hint: "Enter Job Headline",
                          controller: provider.jobHeadlineController,
                          maxLength: 60,
                        ),
                        const SizedBox(height: 10),
                        contentHeading(title: "Industry*"),
                        CustomTextFieldForMasterData(
                          contextIn: context,
                          controller: provider.industryController,
                          hintText: "Type to search",
                          name: "industry",
                          title: "Industry",
                        ),
                        const SizedBox(height: 10),
                        contentHeading(title: "Number of vacancies*"),
                        CustomTextFieldforAll(
                          hint: "Vacancies",
                          controller: provider.noOfVacancyController,
                          isNumber: true,
                        ),
                        const SizedBox(height: 10),
                        contentHeading(title: "Level of Hiring*"),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ["Entry Level", "Senior Level", "Leader"]
                                .map((lvl) {
                                  return CustomToggleButton(
                                    title: lvl,
                                    isSelect: provider.levelOfHiring == lvl,
                                    onTap: () =>
                                        provider.selectLevelOfHiring(lvl),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        contentHeading(title: "Employment Type*"),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                [
                                  "Full Time",
                                  "Part Time",
                                  "Internship",
                                  "Contractual",
                                  "Freelancer",
                                ].map((type) {
                                  return CustomToggleButton(
                                    title: type,
                                    isSelect: provider.empType == type,
                                    onTap: () => provider.selectEmpType(type),
                                  );
                                }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        contentHeading(title: "Job Benefits*"),
                        Wrap(
                          spacing: 8,
                          children: provider.availableBenefits.map((b) {
                            return CustomToggleButton(
                              title: b,
                              isSelect: provider.selectedBenefits.contains(b),
                              onTap: () => provider.toggleBenefit(b),
                            );
                          }).toList(),
                        ),
                        // --- Work Mode Section ---
                        const SizedBox(height: 10),
                        const contentHeading(title: "Work Mode*"),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // On-Site Button
                              CustomPopUpForLocation(
                                initiallySelectedItems:
                                    provider.jobLocationListOnsite,
                                onSelectionComplete: (selectedItems) {
                                  provider.selectOnsiteLocations(selectedItems);
                                },
                                isSelect: provider.isOnsite,
                                title: "On-Site",
                                name: "location",
                                hintText: "Mumbai",
                                onSubmit: (p0) {},
                              ),
                              // Hybrid Button
                              CustomPopUpForLocation(
                                initiallySelectedItems:
                                    provider.jobLocationListHybrid,
                                onSelectionComplete: (selectedItems) {
                                  provider.selectHybridLocations(selectedItems);
                                },
                                isSelect: provider.isHybrid,
                                title: "Hybrid",
                                name: "location",
                                hintText: "Mumbai",
                                onSubmit: (p0) {},
                              ),
                              // Remote Button
                              CustomPopUpForLocation(
                                initiallySelectedItems:
                                    provider.jobLocationListRemote,
                                onSelectionComplete: (selectedItems) {},
                                isSelect: provider.isRemote,
                                title: "Remote",
                                name: "city",
                                hintText: "Mumbai",
                                onSubmit: (p0) {
                                  provider.selectRemoteLocation(p0);
                                },
                              ),
                            ],
                          ),
                        ),

                        // --- Selected Job Locations Tags Display ---
                        if ((provider.isOnsite ||
                                provider.isHybrid ||
                                provider.isRemote) &&
                            (provider.jobLocationListRemote.isNotEmpty ||
                                provider.jobLocationListOnsite.isNotEmpty ||
                                provider.jobLocationListHybrid.isNotEmpty)) ...[
                          const SizedBox(height: 10),
                          const contentHeading(title: "Job Location"),
                        ],

                        // Display Remote Location
                        if (provider.isRemote &&
                            provider.jobLocationListRemote.isNotEmpty)
                          CustomToggleButton(
                            title:
                                provider
                                        .jobLocationListRemote
                                        .first
                                        .formateData !=
                                    null
                                ? provider
                                      .jobLocationListRemote
                                      .first
                                      .formateData!
                                      .split(',')[0]
                                      .toString()
                                : "",
                            onTap: () {},
                            isSelect: true,
                          ),

                        // Display Onsite or Hybrid Selected Location Chips
                        if (provider.isOnsite || provider.isHybrid)
                          Wrap(
                            spacing: 8.0,
                            children: provider.isOnsite
                                ? provider.jobLocationListOnsite.map((item) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Constants.borderColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          customText(
                                            title: item.formateData!
                                                .split(',')[0]
                                                .toString(),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(width: 6),
                                          InkWell(
                                            onTap: () => provider
                                                .removeOnsiteLocation(item),
                                            child: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList()
                                : provider.jobLocationListHybrid.map((item) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Constants.borderColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          customText(
                                            title: item.formateData!
                                                .split(',')[0]
                                                .toString(),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(width: 6),
                                          InkWell(
                                            onTap: () => provider
                                                .removeHybridLocation(item),
                                            child: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                          ),
                        const SizedBox(height: 10),
                        contentHeading(title: "Shift Timing*"),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: provider.availableShiftTimes.map((st) {
                              return CustomToggleButton(
                                title: st,
                                isSelect: provider.shiftTime == st,
                                onTap: () => provider.selectShiftTime(st),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: SafeArea(
            child: CustomButtonForSave(
              title: "Save & Continue",
              onTap: () {
                // provider.setStep(2);
                if (provider.validateAndSavePage1()) {
                  provider.setStep(2);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
