import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart'
    show CustomToggleButton;
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/button/custom_radio_button.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class JobPostPageTwo extends StatelessWidget {
  const JobPostPageTwo({super.key});

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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Week Off ---
                  const contentHeading(title: "Week Off*"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: provider.availableWeekOffs.map((wo) {
                        return CustomToggleButton(
                          title: wo,
                          isSelect: provider.weekOff == wo,
                          onTap: () => provider.selectWeekOff(wo),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Qualification ---
                  const contentHeading(title: "Qualification*"),
                  Row(
                    children: ["Under-Graduate", "Graduate or above"].map((q) {
                      return CustomToggleButton(
                        title: q,
                        isSelect: provider.qualification == q,
                        onTap: () => provider.selectQualification(q),
                      );
                    }).toList(),
                  ),
                  if (provider.qualification == "Graduate or above") ...[
                    const SizedBox(height: 6),
                    CustomCheckboxRow(
                      title:
                          "Under Graduate with relevant experience can apply",
                      value: provider.isUndergradWithExperience,
                      onChanged: provider.toggleUndergradWithExperience,
                    ),
                    /*  CheckboxListTile(
                      title: customText(
                        title:
                            "Under Graduate with relevant experience can apply",
                        fontSize: 12,
                      ),
                      value: provider.isUndergradWithExperience,
                      onChanged: provider.toggleUndergradWithExperience,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ), */
                  ],
                  const SizedBox(height: 16),

                  // --- Gender Preference ---
                  const contentHeading(title: "Gender Preference"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CustomToggleButton(
                          title: "Only Male",
                          isSelect: provider.genderPreference == "Male",
                          onTap: () => provider.selectGenderPreference("Male"),
                        ),
                        CustomToggleButton(
                          title: "Only Female",
                          isSelect: provider.genderPreference == "Female",
                          onTap: () =>
                              provider.selectGenderPreference("Female"),
                        ),
                        CustomToggleButton(
                          title: "Female Preferred",
                          isSelect:
                              provider.genderPreference == "Female Preferred",
                          onTap: () => provider.selectGenderPreference(
                            "Female Preferred",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Age Limit ---
                  const contentHeading(title: "Age Limit"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: CustomTextFieldforAll(
                          maxLength: 2,
                          isNumber: true,
                          hint: "Min Age",
                          controller: provider.minAgeController,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: CustomTextFieldforAll(
                          maxLength: 2,
                          isNumber: true,
                          hint: "Max Age",
                          controller: provider.maxAgeController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // --- Experience Required ---
                  const contentHeading(title: "Experience Required*"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CustomToggleButton(
                          title: "Fresher",
                          isSelect: provider.experienceRequired == "FRESHER",
                          onTap: () =>
                              provider.selectExperienceRequired("FRESHER"),
                        ),
                        CustomToggleButton(
                          title: "6 month or above",
                          isSelect: provider.experienceRequired == "SIX_MONTHS",
                          onTap: () =>
                              provider.selectExperienceRequired("SIX_MONTHS"),
                        ),
                        CustomToggleButton(
                          title: "Other",
                          isSelect: provider.experienceRequired == "OTHERS",
                          onTap: () =>
                              provider.selectExperienceRequired("OTHERS"),
                        ),
                      ],
                    ),
                  ),
                  if (provider.experienceRequired == "OTHERS") ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: CustomTextFieldforAll(
                            maxLength: 2,
                            isNumber: true,
                            hint: "Min Year",
                            controller: provider.minYearController,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("-"),
                        ),
                        if (!provider.isAndAbove)
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: CustomTextFieldforAll(
                              maxLength: 2,
                              isNumber: true,
                              hint: "Max Year",
                              controller: provider.maxYearController,
                            ),
                          ),
                        CustomToggleButton(
                          title: "& above",
                          isSelect: provider.isAndAbove,
                          onTap: provider.toggleAndAbove,
                        ),
                      ],
                    ),
                  ],
                  if (provider.experienceRequired == "SIX_MONTHS" ||
                      provider.experienceRequired == "OTHERS") ...[
                    const SizedBox(height: 6),
                    CustomCheckboxRow(
                      title:
                          "Candidate should be from relevant experience background",
                      value: provider.isRelevantBackgroundRequired,
                      onChanged: provider.toggleRelevantBackgroundRequired,
                    ),
                    /*  CheckboxListTile(
                      title: customText(
                        title:
                            "Candidate should be from relevant experience background",
                        fontSize: 12,
                      ),
                      value: provider.isRelevantBackgroundRequired,
                      onChanged: provider.toggleRelevantBackgroundRequired,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ), */
                  ],
                  const SizedBox(height: 16),

                  // --- Salary ---
                  const contentHeading(title: "Salary*"),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFieldforAll(
                          hint: "Min",
                          controller: provider.minSalController,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextFieldforAll(
                          hint: "Max",
                          controller: provider.maxSalController,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      CustomRadioButton(
                        title: "P.M",
                        isSelected: provider.isPerMonth,
                        onChanged: (_) => provider.toggleSalaryType(true),
                      ),
                      const SizedBox(width: 6),
                      CustomRadioButton(
                        title: "P.A",
                        isSelected: !provider.isPerMonth,
                        onChanged: (_) => provider.toggleSalaryType(false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Language Required ---
                  const contentHeading(title: "Language Required"),
                  Wrap(
                    spacing: 8,
                    children: provider.availableLanguages.map((lang) {
                      final isSelected = provider.selectedLanguages.contains(
                        lang,
                      );
                      return CustomToggleButton(
                        title: lang,
                        isSelect: isSelected,
                        onTap: () => provider.toggleLanguage(lang),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // --- English Communication Rating ---
                  const contentHeading(title: "English Communication Rating*"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                            "Excellent",
                            "Very Good",
                            "Average",
                            "No English",
                          ].map((rating) {
                            return CustomToggleButton(
                              title: rating,
                              isSelect: provider.englishCommsRating == rating,
                              onTap: () => provider.selectEnglishRating(rating),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: CustomButtonForSave(
              title: "Save & Continue",
              onTap: () {
                // provider.setStep(3);
                if (provider.validateAndSavePage2()) {
                  provider.setStep(3); // Moves to Page 3
                }
              },
            ),
          ),
        );
      },
    );
  }
}
