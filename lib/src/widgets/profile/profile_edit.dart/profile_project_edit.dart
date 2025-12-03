// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/dropdown/month_drop_down.dart';
import 'package:job_circle/src/widgets/dropdown/year_drop_down.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:job_circle/src/widgets/text_field/custom_textfield_for_skills.dart';
import 'package:provider/provider.dart';

class ProfileProjectEdit extends StatelessWidget {
  final FromEditOrAdd fromEditOrAdd;
  const ProfileProjectEdit({super.key, required this.fromEditOrAdd});

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
                title: const OnboardingTitle(title: "Projects", fontSize: 16),
                actions: [
                  !provider.showProjectForm &&
                          provider.profile!.projects!.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            provider.clearProjectForm();
                            provider.setShowProjectForm(true);
                          },
                          icon: const Icon(Icons.add),
                        )
                      : (provider.profile!.projects != null &&
                            provider.profile!.projects!.isNotEmpty &&
                            fromEditOrAdd == FromEditOrAdd.edit)
                      ? IconButton(
                          onPressed: () {
                            provider.cancelProjectEdit();
                            if (provider.profile!.projects != null &&
                                provider.profile!.projects!.length == 1) {
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
                    provider.profile!.projects == null ||
                        provider.profile!.projects!.isEmpty ||
                        provider.showProjectForm
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              controller: provider.project_description,
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
            const customText(title: "Project url", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              isGmail: true,
              controller: provider.project_url,
              hint: "Enter the url of projects",
            ),
            SizedBox(height: 15),
            const customText(title: "Skills", fontStyle: FontStyle.italic),
            CustomTextFieldForSkills(
              title: "Skills",
              initialSkills: provider.projectItSkills,
              onSkillsChanged: (skills) {
                provider.assignSkillsToProjects(skills);
              },
              name: "skills",
              controller: provider.proj_skillController,
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
            if (provider.isEditProject &&
                provider.profile!.projects!.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.removeProjects(provider.isEditProjectIndex!);
                      provider.clearProjectForm();
                      provider.setShowProjectForm(false);
                    },
                    child: customText(title: "Delete Project"),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () {
                  if (provider.project_title.text.isEmpty) {
                    CustomSnackbar.show("Enter Project title to save", true);
                  } else if (provider.project_description.text.isEmpty) {
                    CustomSnackbar.show(
                      "Enter project descripton to save",
                      true,
                    );
                  } else if ((provider.proj_startMonth.text.isNotEmpty &&
                          provider.proj_startYear.text.isEmpty) ||
                      (provider.proj_startYear.text.isNotEmpty &&
                          provider.proj_startMonth.text.isEmpty)) {
                    CustomSnackbar.show(
                      "Select start month and year both",
                      true,
                    );
                  } else if (provider.project_role.text.isEmpty) {
                    CustomSnackbar.show("Enter role to save", true);
                  } else if ((provider.proj_endMonth.text.isNotEmpty &&
                          provider.proj_endYear.text.isEmpty) ||
                      (provider.proj_endYear.text.isNotEmpty &&
                          provider.proj_endMonth.text.isEmpty)) {
                    CustomSnackbar.show("Select end month and end both", true);
                  } else {
                    provider.addUpdateProjects();
                  }
                },
                title: /* provider.isEditProject ? "Update" : */ "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomBody(ProfileProvider provider) {
    // Sort the list but keep track of original indices
    final sortedProjectsWithIndex = List.generate(
      provider.profile!.projects!.length,
      (index) => {
        'project': provider.profile!.projects![index],
        'originalIndex': index,
      },
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Divider(height: 1),
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: sortedProjectsWithIndex.length,
        itemBuilder: (context, index) {
          final item = sortedProjectsWithIndex[index];
          final data = item['project'] as ProjectModel;
          final originalIndex = item['originalIndex'] as int;
          return Column(
            children: [
              CustomNewListTile(
                onTap: () {},
                contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
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
                  child: CustomNetworkImage(
                    imageUrl: CustomIconUrl.projectConstantIcon,
                    defaultIcon: Icons.cast_for_education,
                    color: Constants.subtitleclr,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        title: data.projectTitle.toString(),
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      customText(
                        monst: true,
                        title: data.role.toString(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                subtitle: data.duration != null && data.duration != 'null'
                    ? customText(
                        title: MonthRangeFormatter.formatMonthRange(
                          data.duration!,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Constants.subtitleclr,
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox.shrink(),
                trailing: IconButton(
                  onPressed: () {
                    provider.editProject(originalIndex);
                  },
                  icon: CustomNetworkImage(
                    imageUrl: CustomIconUrl.editicon,
                    defaultIcon: Icons.cast_for_education,
                  ),
                ),
              ),
              /*  if (data.description != null && data.description!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(4),
                  margin: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Constants.lightdull,
                  ),
                  child: ExpandableTextWidget(
                    initialMaxLines: 5,
                    text: BulletFormatter.formatWithBullets(data.description!),
                  ),
                ), */
            ],
          );
        },
      ),
    );
  }
}
