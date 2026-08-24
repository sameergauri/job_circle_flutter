import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_add_skill.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/button/custom_toggle_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class JobPostPageFour extends StatelessWidget {
  const JobPostPageFour({super.key});

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
                  // --- Search TextField ---
                  CustomTextFieldforAll(
                    maxLength: 60,
                    isGmail: true,
                    hint: "Enter your skills that match your role",
                    controller: provider.skillsSearchController,
                    onChanged: (text) => provider.filterSkills(text),
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      provider.filterSkills("");
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                      provider.filterSkills("");
                    },
                  ),

                  // --- No Skill Found State ---
                  if (provider.filteredSkills.isEmpty &&
                      provider.skillsSearchController.text.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            customText(
                              color: colors.subTitleColor,
                              textAlign: TextAlign.center,
                              title:
                                  "No skill found as per your search result. \n click 'ADD NEW SKILL' button to add new skill",
                            ),
                            const SizedBox(height: 8),
                            CustomAddButton(
                              title: "Add New Skill",
                              onTab: () {
                                final text = provider
                                    .skillsSearchController
                                    .text
                                    .trim();
                                if (text.isNotEmpty) {
                                  provider.addSkill(text);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- Search Dropdown List ---
                  if (provider.filteredSkills.isNotEmpty &&
                      provider.skillsSearchController.text.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: colors.bottomsheetbgColor,
                        border: Border.all(color: Constants.borderColor),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.filteredSkills.length,
                        itemBuilder: (context, index) {
                          final isOdd = index % 2 == 0;
                          final backgroundColor = isOdd
                              ? colors.bottomsheerCard1Color
                              : colors.bottomsheerCard2Color;
                          final skill = provider.filteredSkills[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomListTile(
                              contentPadding: EdgeInsets.only(left: 10),
                              dense: true,
                              title: customText(
                                title: skill,
                                fontSize: 12,
                                color: colors.headingColor,
                              ),
                              onTap: () => provider.addSkill(skill),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  // --- Selected Skills Section ---
                  if (provider.selectedSkills.isNotEmpty) ...[
                    customText(
                      title: "Selected Skills",
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colors.headingColor,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.selectedSkills.map((skill) {
                        return CustomToggleButton(
                          isSelect: true,
                          title: skill,
                          onTap: () => provider.removeSkill(skill),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // --- AI Suggested Skills Section ---
                  if (provider.aiSuggestedSkills.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colors.bottomsheetbgColor,
                        border: Border.all(color: Constants.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomNetworkImage(
                                imageUrl: CustomIconUrl.aiicon,
                                defaultIcon: Icons.star_border_outlined,
                              ),
                              const SizedBox(width: 6),
                              customText(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                title: "AI Suggested Skills",
                                color: colors.headingColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: provider.aiSuggestedSkills.map((skill) {
                              final isAlreadySelected = provider.selectedSkills
                                  .contains(skill);
                              return CustomToggleButton(
                                isSelect: isAlreadySelected,
                                title: skill,
                                onTap: () {
                                  if (!isAlreadySelected) {
                                    provider.addSkill(skill);
                                  } else {
                                    provider.removeSkill(skill);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
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
                if (provider.selectedSkills.isEmpty) {
                  CustomSnackbar.show("Select atleast one skill", true);
                } else {
                  provider.setStep(5); // Move to Step 5 (Certificates)
                }
              },
            ),
          ),
        );
      },
    );
  }
}
