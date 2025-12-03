// ignore_for_file: null_check_always_fails, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unused_local_variable

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_onboarding_titlle.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/add_certificate.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/add_bullet_point.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_confirmation.dart';
import 'package:job_circle/src/widgets/dropdown/month_drop_down.dart';
import 'package:job_circle/src/widgets/dropdown/year_drop_down.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/custom_text_with_underline.dart';
import 'package:job_circle/src/widgets/text/expandable_text_widget.dart';
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:job_circle/src/widgets/text_field/custom_textfield_for_skills.dart';
import 'package:provider/provider.dart';

class AddProjects extends StatelessWidget {
  const AddProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              bottomNavigationBar:
                  (provider.projectModel.isEmpty &&
                          (!provider.hasProjectData)) ||
                      !provider.showProjectForm
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10,bottom: 5 ),
                        child: CustomButtonForSave(
                          isPading: false,
                          onTap: () {
                            if (provider.projectModel.isEmpty &&
                                (provider.project_title.text.isNotEmpty ||
                                    provider
                                        .project_decription
                                        .text
                                        .isNotEmpty)) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialogForConfirmation(
                                    title: "Are Sure? wannt to skip",
                                    onYes: () {
                                      NavigationService.push(AddCertificate());
                                    },
                                    subtitle:
                                        "You enter a skip button without saving the project data",
                                    button1text: "Yes",
                                    onlysinglebutton: true,
                                  );
                                },
                              );
                            } else {
                              NavigationService.push(AddCertificate());
                            }

                            // NavigationService.push(AddCertificate());
                          },
                          title: provider.projectModel.isEmpty
                              ? "Skip"
                              : "Next",
                          buttonColor: Constants.darkBlue,
                          textColor: Constants.white,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              appBar: AppBar(
                titleSpacing: 0.0,
                backgroundColor: Constants.borderColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnboardingAppBarHeading(),
                    OnboardingAppBarSubTitle(),
                  ],
                ),
                actions: [
                  (provider.projectModel.isNotEmpty && provider.showProjectForm)
                      ? IconButton(
                          onPressed: () {
                            provider.cancelProjectEdit();
                          },
                          icon: const Icon(Icons.cancel_outlined),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              backgroundColor: Constants.white,
              floatingActionButton:
                  !provider.showProjectForm && provider.projectModel.isNotEmpty
                  ? FloatingActionButton(
                      backgroundColor: Constants.borderColor,
                      onPressed: () {
                        provider.clearProjectFoorm();
                        provider.setShowProjectForm(true);
                      },
                      child: const Icon(Icons.add),
                    )
                  : const SizedBox.shrink(),

              body: _customBody(context, provider),
            ),
            if (provider.isLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  Widget _customBody(BuildContext context, SignupCreateUserProvider provider) {
    var width = MediaQuery.of(context).size.width;

    // Automatically show form if no certificates are added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.projectModel.isEmpty && !provider.showProjectForm) {
        provider.setShowProjectForm(true);
      }
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show form if needed
          if (provider.showProjectForm || provider.projectModel.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWithUnderLine(title: "Projects", fontSize: 16),
                    ],
                  ),
                  SizedBox(height: 10),
                  const customText(
                    title: "Project Title*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldforAll(
                    maxLength: 30,
                    controller: provider.project_title,
                    hint: "Enter project title",
                  ),
                  SizedBox(height: 15),
                  const customText(title: "Description*"),
                  CustomAutoSizeTextField(
                    controller: provider.project_decription,
                    hintText: "Enter project description",
                    maxline: 4,
                    maxLength: 1200,
                  ),
                  const SizedBox(height: 15),
                  const customText(title: "Role*", fontStyle: FontStyle.italic),
                  CustomTextFieldforAll(
                    controller: provider.project_role,
                    hint: "Enter your role in the project",
                  ),
                  const SizedBox(height: 15),
                  const customText(
                    title: "Project url",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldforAll(
                    controller: provider.project_url,
                    hint: "Enter the url of projects",
                  ),
                  SizedBox(height: 10),
                  const customText(
                    title: "Skills",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForSkills(
                    title: "Skills",
                    initialSkills: provider.projectItSkills,
                    onSkillsChanged: (skills) {
                      provider.assignSkillsToProjects(skills);
                    },
                    name: "skills",
                    controller: provider.project_skill_controller,
                    hintText: "Enter your skills",
                  ),
                  const SizedBox(height: 15),
                  const customText(title: "Start Month"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: MonthDropdown(
                          controller: provider.proj_startMonth,
                          hint: "Select Month",
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: DropDownYear(
                          hint: "Select Year",
                          controller: provider.proj_startYear,
                          isFirst: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  const customText(title: "Valid till"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: MonthDropdown(
                          controller: provider.proj_endMonth,
                          hint: "Select Month",
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: DropDownYear(
                          hint: "Select Year",
                          controller: provider.proj_endYear,
                          isFirst: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  if (provider.isEditingProject &&
                      provider.projectModel.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            provider.removeProject(provider.editProjectIndex!);
                            provider.clearProjectFoorm();
                            provider.setShowProjectForm(false);
                          },
                          child: customText(title: "Delete Project"),
                        ),
                      ],
                    ),
                  if (provider.hasProjectData)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomButtonForSave(
                        isPading: false,
                        onTap: () {
                          if (provider.project_title.text.isEmpty) {
                            CustomSnackbar.show(
                              "Enter Project title to save",
                              true,
                            );
                          } else if (provider.project_decription.text.isEmpty) {
                            CustomSnackbar.show(
                              "Enter project descripton to save",
                              true,
                            );
                          } else if (provider.project_role.text.isEmpty) {
                            CustomSnackbar.show("Enter role to save", true);
                          } else {
                            provider.addOrUpdateProject();
                          }
                        },
                        title: /*  provider.isEditingCertificate
                            ? "Update"
                            : */
                            "Save",
                      ),
                    ),
                ],
              ),
            ),
          // Display list of certificates if any
          if (provider.projectModel.isNotEmpty && !provider.showProjectForm)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Builder(
                builder: (context) {
                  // Sort the list but keep track of original indices
                  final sortedProjectsWithIndex = List.generate(
                    provider.projectModel.length,
                    (index) => {
                      'project': provider.projectModel[index],
                      'originalIndex': index,
                    },
                  );
                  return ListView.separated(
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Divider(height: 1),
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedProjectsWithIndex.length,
                    itemBuilder: (context, index) {
                      final item = sortedProjectsWithIndex[index];
                      final proj = item['project'] as UserProjectRequest;
                      final originalIndex = item['originalIndex'] as int;
            
                      return Column(
                        children: [
                          CustomNewListTile(
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Constants.lightdull),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const CustomNetworkImage(
                                height: 24,
                                imageUrl: CustomIconUrl.projectConstantIcon,
                                defaultIcon: Icons.workspace_premium_outlined,
                              ),
                            ),
                            title: customText(
                              title: proj.projectTitle ?? '',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (proj.role != null && proj.role != '')
                                  customText(
                                    title: proj.role!,
                                    fontWeight: FontWeight.w500,
                                    color: Constants.subtitleclr,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (proj.duration != null && proj.duration != '')
                                  customText(
                                    title: proj.duration!,
                                    fontWeight: FontWeight.w500,
                                    color: Constants.subtitleclr,
                                    fontSize: 12,
                                  ),
                              ],
                            ),
                            trailing: CustomIconButton(
                              imageUrl: CustomIconUrl.editicon,
                              onTap: () {
                                provider.editProject(originalIndex);
                              },
                            ),
                          ),
                          if (proj.description != null &&
                              proj.description!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(4),
                              margin: EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Constants.lightdull,
                              ),
                              child: ExpandableTextWidget(
                                initialMaxLines: 5,
                                text: BulletFormatter.formatWithBullets(
                                  proj.description!,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                }
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
