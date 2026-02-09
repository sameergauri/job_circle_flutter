// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_add_skill.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class ProfileAddTechnicalSkill extends StatelessWidget {
  const ProfileAddTechnicalSkill({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.fetchSkills();
      provider.technicalSkillController.clear();
      provider.clearTechnicalSkill();
      provider.assignTechnicalSkillsToSelectedSkillList(
        provider.profile?.technicalSkills ?? [],
      );
    });

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: CustomButtonForSave(
          isPading: false,
          title: "Save",
          onTap: () {
            final provider = Provider.of<ProfileProvider>(
              context,
              listen: false,
            );
            if (provider.tempSelectedTechnicalSkills.isEmpty) {
              CustomSnackbar.show("Please select at least one skill.", true);
              return;
            }
            provider.updateAndSaveTechSkills();
            NavigationService.pop();
          },
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0.0,
        title: OnboardingTitle(title: "Technical Skills", fontSize: 16),
        backgroundColor: colors.appbarColor,
        elevation: 0,
      ),
      backgroundColor: colors.bgColor,
      body: _customBody(colors),
    );
  }

  Widget _customBody(AppColors colors) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFieldforAll(
                  maxLength: 20,
                  controller: provider.technicalSkillController,
                  hint: "Type to search technical skills",
                  onChanged: (value) {
                    provider.fetchSkills();
                  },
                ),
                const SizedBox(height: 10),
                if (provider.apifetchSkills != null &&
                    provider.apifetchSkills.isNotEmpty &&
                    provider.apifetchSkills
                        .where((element) {
                          return element.contains(
                            provider.technicalSkillController.text,
                          );
                        })
                        .toList()
                        .isEmpty)
                  Center(
                    child: Column(
                      children: [
                        customText(
                          textAlign: TextAlign.center,
                          title:
                              "No skill found for your search.\nClick 'Add New Skill' to add it.",
                          fontSize: 14,
                          color: colors.subTitleColor,
                        ),
                        const SizedBox(height: 10),
                        CustomAddButton(
                          title: "Add New Technical Skill",
                          onTab: () {
                            final newSkill = provider
                                .technicalSkillController
                                .text
                                .trim();
                            if (newSkill.isNotEmpty) {
                              if (!provider.apifetchSkills.contains(newSkill)) {
                                provider.toggleTechnicalSkill(newSkill);
                                provider.technicalSkillController.clear();
                                provider.fetchSkills();
                              } else {
                                CustomSnackbar.show(
                                  "$newSkill is already in the list.",
                                  true,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                if (provider.technicalSkillController.text.isNotEmpty &&
                    provider.apifetchSkills.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: colors.bottomsheetbgColor,
                      border: Border.all(color: colors.appbarColor!),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.apifetchSkills
                          .where((element) {
                            return element.contains(
                              provider.technicalSkillController.text,
                            );
                          })
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        final isOdd = index % 2 == 0;
                        final backgroundColor = isOdd
                            ? colors.bottomsheerCard1Color
                            : colors.bottomsheerCard2Color;

                        final suggestion = provider.apifetchSkills.where((
                          element,
                        ) {
                          return element.toLowerCase().contains(
                            provider.technicalSkillController.text
                                .toLowerCase(),
                          );
                        }).toList()[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            dense: true,
                            title: customText(
                              title: suggestion,
                              fontSize: 14,
                              color: colors.headingColor,
                            ),
                            onTap: () {
                              if (provider.tempSelectedTechnicalSkills.contains(
                                suggestion,
                              )) {
                                CustomSnackbar.show(
                                  "$suggestion is already added.",
                                  true,
                                );
                              } else {
                                provider.toggleTechnicalSkill(suggestion);
                                provider.technicalSkillController.clear();
                                provider.fetchSkills();
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                if (provider.tempSelectedTechnicalSkills.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      customText(
                        title: "Selected Technical Skills",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.headingColor,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.tempSelectedTechnicalSkills.map((
                          skill,
                        ) {
                          return CustomSelectedSkillButton(
                            title: skill,
                            onTap: () {
                              provider.toggleTechnicalSkill(skill);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (provider.skillError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: customText(
                      title: provider.skillError!,
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
