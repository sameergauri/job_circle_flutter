// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
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

class ProjectList extends StatelessWidget {
  final FromEditOrAdd fromEditOrAdd;
  const ProjectList({super.key, required this.fromEditOrAdd});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Constants.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            titleSpacing: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const OnboardingTitle(title: "Projects"),
            actions: [
              !provider.showProjectForm && provider.projectModel.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        provider.clearProjectFoorm();
                        provider.setShowProjectForm(true);
                      },
                      icon: const Icon(Icons.add),
                    )
                  : (provider.projectModel.isNotEmpty &&
                        fromEditOrAdd == FromEditOrAdd.edit)
                  ? IconButton(
                      onPressed: () {
                        provider.cancelProjectEdit();
                        if (provider.projectModel.length == 1) {
                          NavigationService.pop();
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          body: SafeArea(
            child: provider.projectModel.isEmpty || provider.showProjectForm
                ? customForm(provider, context)
                : CustomBody(provider),
          ),
        );
      },
    );
  }

  Widget customForm(SignupCreateUserProvider provider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const customText(
              title: "Project Title",
              fontStyle: FontStyle.italic,
            ),
            CustomTextFieldforAll(
              maxLength: 30,
              controller: provider.project_title,
              hint: "Enter project title",
            ),
            SizedBox(height: 15),
            const customText(title: "Description"),
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
            const customText(title: "Project url", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.project_url,
              hint: "Enter the url of projects",
            ),
            SizedBox(height: 10),
            const customText(title: "Skills*", fontStyle: FontStyle.italic),
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
            SizedBox(height: 10),
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
                provider.projectModel.length > 1 &&
                fromEditOrAdd != FromEditOrAdd.add)
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
            Padding(
               padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () {
                  if (provider.project_title.text.isEmpty) {
                    CustomSnackbar.show("Enter Project title to save", true);
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
                title: /* provider.isEditingCertificate &&
                        fromEditOrAdd == FromEditOrAdd.edit ? "Update" : */
                    "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomBody(SignupCreateUserProvider provider) {
    final sortedProjectsWithIndex = List.generate(
      provider.projectModel.length,
      (index) => {
        'project': provider.projectModel[index],
        'originalIndex': index,
      },
    );
    return ListView.separated(
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: const Divider(height: 1),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedProjectsWithIndex.length,
      itemBuilder: (context, index) {
        final item = sortedProjectsWithIndex[index];
        final proj = item['project'] as UserProjectRequest;
        final originalIndex = item['originalIndex'] as int;
        return Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
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
                      if (proj.duration != null && proj.duration != 'null')
                        customText(
                          title: MonthRangeFormatter.formatMonthRange(
                            proj.duration!,
                          ),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Constants.subtitleclr,
                          overflow: TextOverflow.ellipsis,
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
                /*  if (proj.description != null && proj.description!.isNotEmpty)
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
                  ), */
              ],
            ),
          ),
        );
      },
    );
  }
}
