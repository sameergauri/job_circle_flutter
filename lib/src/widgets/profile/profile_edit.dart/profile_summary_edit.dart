// ignore_for_file: unused_result, must_be_immutable

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_add_resume.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:provider/provider.dart';

class ProfileSummaryEdit extends StatelessWidget {
  const ProfileSummaryEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CustomButtonForSave(
                  title:
                      /*  provider.profile!.bio != null &&
                          provider.profile!.bio != "" &&
                          provider.profile!.bio != " "
                      ? "Update"
                      : */
                      "Save",
                  onTap: () async {
                    if (provider.summary.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialogueForAddResume(
                            confirmationDialogue: true,
                            error: false,
                            onClose: () {
                              provider.updateProfileModelForSummary();
                              provider.clearBasicProfile();
                              NavigationService.pop();
                              NavigationService.pop();
                            },
                            subtitle: "Delete Summary ?",
                          );
                        },
                      );
                    } else {
                      provider.updateProfileModelForSummary();
                      provider.clearBasicProfile();
                      NavigationService.pop();
                    }
                  },
                ),
              ),
              resizeToAvoidBottomInset: true, // Add this line
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                titleSpacing: 0.0,
                automaticallyImplyLeading: true,
                backgroundColor: Constants.borderColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [OnboardingTitle(title: "Summary", fontSize: 16)],
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const customText(title: ""),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: provider.summary,
                              builder: (context, value, child) {
                                if (value.text.isEmpty &&
                                    provider.isSummaryGenereted == false) {
                                  return InkWell(
                                    onTap: () async {
                                      provider.fetchSummaryUsingAi();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
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
                                            defaultIcon:
                                                Icons.star_border_outlined,
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
                                      provider.clearSummary();
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
                              },
                            ),
                          ],
                        ),
                      ),
                      CustomAutoSizeTextField(
                        needClearAll: false,
                        controller: provider.summary,
                        hintText:
                            "Boost visibility with a compelling career summary.",
                        maxline: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (provider.isSummaryLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }
}
