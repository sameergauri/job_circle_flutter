// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_career_pref.dart';
import 'package:provider/provider.dart';

class CareerPreference extends StatefulWidget {
  final bool isFromDrawer;
  const CareerPreference({super.key, required this.isFromDrawer});

  @override
  State<CareerPreference> createState() => _CareerPreferenceState();
}

class _CareerPreferenceState extends State<CareerPreference> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CareerPreferenceProvider>(
        context,
        listen: false,
      ).fetchCareerPreference(widget.isFromDrawer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<CareerPreferenceProvider>(
      builder: (context, provider, child) {
        {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: colors.bgColor,
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  backgroundColor: colors.appbarColor,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        title: 'Set your Career Preferences',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.headingColor,
                      ),
                      customText(
                        title: 'Help us match you with the right opportunities',
                        fontSize: 12,
                        color: colors.subTitleColor,
                      ),
                    ],
                  ),
                ),
                body: Form(
                  key: provider.formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Preferred Industry
                        customText(
                          title: 'Preferred Industry',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        CustomTextFieldForCareerPreference(
                          title: "Industries",
                          initialList: provider.selectedIndustries,
                          onListChnaged: provider.updateIndustry,
                          controller: provider.industriesController,
                          name: PrefTextFieldType.Industry,
                          hintText: "Enter your industry",
                          focusNode: provider.industriesFocusNode,
                        ),
                        const SizedBox(height: 10),

                        // Preferred Job Role
                        customText(
                          title: 'Preferred Job Role',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        CustomTextFieldForCareerPreference(
                          title: "Job Role",
                          initialList: provider.selectedJobRole,
                          onListChnaged: provider.updateJobRole,
                          controller: provider.jobRoleController,
                          name: PrefTextFieldType.JobRole,
                          hintText: "Enter your role",
                          focusNode: provider.jobRoleFocusNode,
                        ),
                        const SizedBox(height: 10),

                        // Employment Type
                        customText(
                          title: 'Employment Type',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CustomToggleButton(
                                isSelect: provider.fullTime,
                                title: "Full Time",
                                onTap: () =>
                                    provider.selectEmploymentType("fullTime"),
                              ),
                              CustomToggleButton(
                                isSelect: provider.partTime,
                                title: "Part Time",
                                onTap: () =>
                                    provider.selectEmploymentType("partTime"),
                              ),
                              CustomToggleButton(
                                isSelect: provider.contractJob,
                                title: "Contract",
                                onTap: () =>
                                    provider.selectEmploymentType("contract"),
                              ),
                              CustomToggleButton(
                                isSelect: provider.freelance,
                                title: "Freelance",
                                onTap: () =>
                                    provider.selectEmploymentType("freelance"),
                              ),
                              CustomToggleButton(
                                isSelect: provider.internship,
                                title: "Internship",
                                onTap: () =>
                                    provider.selectEmploymentType("internship"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Preferred Work Mode
                        customText(
                          title: 'Preferred Work Mode',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        Wrap(
                          children: [
                            CustomToggleButton(
                              isSelect: provider.workFromOffice,
                              title: "Work from Office",
                              onTap: () => provider.toggleWorkMode("office"),
                            ),
                            CustomToggleButton(
                              isSelect: provider.workFromHome,
                              title: "Work from Home",
                              onTap: () => provider.toggleWorkMode("home"),
                            ),
                            CustomToggleButton(
                              isSelect: provider.hybrid,
                              title: "Hybrid",
                              onTap: () => provider.toggleWorkMode("hybrid"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        customText(
                          title: 'Shift Time',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CustomToggleButton(
                                isSelect: provider.day ?? false,
                                title: "Day",
                                onTap: () => provider.setShiftTime("day"),
                              ),
                              CustomToggleButton(
                                isSelect: provider.night ?? false,
                                title: "Night",
                                onTap: () => provider.setShiftTime("night"),
                              ),
                              CustomToggleButton(
                                isSelect: provider.rotational ?? false,
                                title: "Rotational",
                                onTap: () =>
                                    provider.setShiftTime("rotational"),
                              ),
                              CustomToggleButton(
                                isSelect: provider.flexibleShift ?? false,
                                title: "Flexible",
                                onTap: () => provider.setShiftTime("flexible"),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Preferred Location
                        customText(
                          title: 'Preferred Location',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        CustomTextFieldForCareerPreference(
                          title: "Preferred Locations",
                          initialList: provider.preferredLocations,
                          onListChnaged: provider.updatePreferredLocation,
                          controller: provider.preferredLocationController,
                          name: PrefTextFieldType.Location,
                          hintText: "Enter preferred locations",
                          focusNode: provider.preferredLocationFocusNode,
                        ),
                        const SizedBox(height: 10),

                        // Salary Range
                        customText(
                          title: 'Expected Salary Range (Annual)',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Min: ${(provider.salaryRange.start / 100000).toStringAsFixed(1)} LPA",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Constants.darkBlue,
                                    ),
                                  ),
                                  Text(
                                    "Max: ${(provider.salaryRange.end / 100000).toStringAsFixed(1)} LPA",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Constants.darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                              RangeSlider(
                                padding: EdgeInsets.zero,
                                /*  labels: RangeLabels(
                                  "₹${provider.salaryRange.start.toInt()}",
                                  "₹${provider.salaryRange.end.toInt()}",
                                ), */
                                values: provider.salaryRange,
                                min: 0,
                                max: 5000000,
                                divisions: 100,
                                onChanged: provider.updateSalaryRange,
                                activeColor: Constants.darkBlue,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Relocation
                        _switch(
                          "Open to Relocation",
                          provider.openToRelocation,
                          provider.updateRelocation,
                          colors,
                        ),

                        const SizedBox(height: 10),

                        // Immediate Joiner
                        /*  _switch(
                          "Immediate Joiner",
                          provider.immediateJoiner,
                          provider.updateImmediateJoiner,
                        ), */
                        customText(
                          title: 'Notice Period',
                          fontSize: 12,
                          color: colors.headingColor,
                        ),
                        Wrap(
                          children: [
                            CustomToggleButton(
                              isSelect: provider.immediateJoiner,
                              title: "Immediate Joiner",
                              onTap: () =>
                                  provider.selectNoticePeriod("immediate"),
                            ),
                            CustomToggleButton(
                              isSelect: provider.fifteenDays,
                              title: "15 Days",
                              onTap: () =>
                                  provider.selectNoticePeriod("fifteenDays"),
                            ),
                            CustomToggleButton(
                              isSelect: provider.thirtyDays,
                              title: "30 Days",
                              onTap: () =>
                                  provider.selectNoticePeriod("thirtyDays"),
                            ),
                            CustomToggleButton(
                              isSelect: provider.fortyFiveDays,
                              title: "45 Days",
                              onTap: () =>
                                  provider.selectNoticePeriod("fortyFiveDays"),
                            ),
                            CustomToggleButton(
                              isSelect: provider.sixtyDays,
                              title: "60 Days",
                              onTap: () =>
                                  provider.selectNoticePeriod("sixtyDays"),
                            ),
                            CustomToggleButton(
                              isSelect: provider.ninetyDays,
                              title: "90 Days",
                              onTap: () =>
                                  provider.selectNoticePeriod("ninetyDays"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Save Button
                        CustomButtonForSave(
                          isPading: false,
                          onTap: () async {
                            if (!provider.immediateJoiner &&
                                !provider.fifteenDays &&
                                !provider.thirtyDays &&
                                !provider.fortyFiveDays &&
                                !provider.sixtyDays &&
                                !provider.ninetyDays) {
                              CustomSnackbar.show(
                                "Please select notice period",
                                true,
                              );
                              return;
                            }
                            await provider.savePreferences(
                              context,
                              isFromDrawer: widget.isFromDrawer,
                            );
                            NavigationService.pop();
                          },
                          title: "Save",
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (provider.isLoading) CustomLoadingIndicator(),
            ],
          );
        }
      },
    );
  }

  Widget _switch(
    String title,
    bool value,
    Function(bool) onChanged,
    AppColors colors,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colors.bottomsheerCard1Color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            title: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Constants.darkBlue,
          ),
          Transform.scale(
            scale: 0.6,
            child: Switch(
              value: value,
              activeThumbColor: Constants.darkBlue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
