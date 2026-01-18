// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_add_skill.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class CvParseEditTechnicalSkill extends StatelessWidget {
  const CvParseEditTechnicalSkill({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SignupCreateUserProvider>(
        context,
        listen: false,
      );
      provider.fetchSkills();
      provider.skillController.clear();
      provider.clearTechnicalSkills();
      if (provider.profileModel != null &&
          provider.profileModel!.userRequest != null &&
          provider.profileModel!.userRequest!.technicalSkills != null &&
          provider.profileModel!.userRequest!.technicalSkills!.isNotEmpty) {
        provider.assignTechnicalSkillsToSelectedSkillList(
          provider.profileModel!.userRequest!.technicalSkills ?? [],
        );
      }
    });

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: CustomButtonForSave(
          isPading: false,
          title: "Save",
          onTap: () {
            final provider = Provider.of<SignupCreateUserProvider>(
              context,
              listen: false,
            );
            if (provider.tempSelectedTechSkill.isEmpty) {
              CustomSnackbar.show("Please select at least one skill.", true);
              return;
            }
            provider.updateAndSaveTechnicalSkills();
            NavigationService.pop();
          },
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0.0,
        title: OnboardingTitle(title: "Technical Skills"),
        backgroundColor: Constants.borderColor,
        elevation: 0,
      ),
      backgroundColor: Constants.white,
      body: _customBody(),
    );
  }

  Widget _customBody() {
    return Consumer<SignupCreateUserProvider>(
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
                  controller: provider.skillController,
                  hint: "Type to search technical skills",
                  onChanged: (value) {
                    provider.fetchSkills();
                  },
                ),
                const SizedBox(height: 10),
                if (provider.apiFetchSkills != null &&
                    provider.apiFetchSkills.isNotEmpty &&
                    provider.apiFetchSkills
                        .where((element) {
                          return element.contains(
                            provider.skillController.text,
                          );
                        })
                        .toList()
                        .isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const customText(
                          textAlign: TextAlign.center,
                          title:
                              "No technical skill found for your search.\nClick 'Add New Technical Skill' to add it.",
                          fontSize: 14,
                        ),
                        const SizedBox(height: 10),
                        CustomAddButton(
                          title: "Add New Technical Skill",
                          onTab: () {
                            final newSkill = provider.skillController.text
                                .trim();
                            if (newSkill.isNotEmpty) {
                              if (!provider.apiFetchSkills.contains(newSkill)) {
                                provider.toggleTechnicalSkill(newSkill);
                                provider.skillController.clear();
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
                if (provider.skillController.text.isNotEmpty &&
                    provider.apiFetchSkills.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Constants.borderColor),
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
                      itemCount: provider.apiFetchSkills
                          .where((element) {
                            return element.contains(
                              provider.skillController.text,
                            );
                          })
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        final isOdd = index % 2 == 0;
                        final backgroundColor = isOdd
                            ? Constants.lightdull
                            : Colors.white;
                        final suggestion = provider.apiFetchSkills.where((
                          element,
                        ) {
                          return element.toLowerCase().contains(
                            provider.skillController.text.toLowerCase(),
                          );
                        }).toList()[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            dense: true,
                            title: customText(title: suggestion, fontSize: 14),
                            onTap: () {
                              if (provider.tempSelectedTechSkill.contains(
                                suggestion,
                              )) {
                                CustomSnackbar.show(
                                  "$suggestion is already added.",
                                  true,
                                );
                              } else {
                                provider.toggleTechnicalSkill(suggestion);
                                provider.skillController.clear();
                                provider.fetchSkills();
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                if (provider.tempSelectedTechSkill.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const customText(
                        title: "Selected Skills",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.tempSelectedTechSkill.map((skill) {
                          return CustomToggleButton(
                            isSelect: true,
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
                      title: provider.skillError,
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
