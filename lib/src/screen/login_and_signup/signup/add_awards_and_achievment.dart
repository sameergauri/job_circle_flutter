// ignore_for_file: null_check_always_fails, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_onboarding_titlle.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/add_summary.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_confirmation.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/custom_text_with_underline.dart';
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class AddAwardsAndAchievment extends StatelessWidget {
  const AddAwardsAndAchievment({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              bottomNavigationBar:
                  (provider.awardsModel.isEmpty && (!provider.hasAwardsData)) ||
                      !provider.showAwardsForm
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        child: CustomButtonForSave(
                          isPading: false,
                          onTap: () {
                            if (provider.awardsModel.isEmpty &&
                                (provider.awards_title.text.isNotEmpty ||
                                    provider
                                        .awards_description
                                        .text
                                        .isNotEmpty)) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialogForConfirmation(
                                    title: "Are you Sure? want to skip",
                                    onYes: () {
                                      NavigationService.push(AddSummary());
                                      // NavigationService.push(AddCertificate());
                                    },
                                    subtitle:
                                        "You enter a skip button without saving the Awards data",
                                    button1text: "Yes",
                                    onlysinglebutton: true,
                                  );
                                },
                              );
                            } else {
                              // NavigationService.push(AddCertificate());
                              NavigationService.push(AddSummary());
                            }

                            // NavigationService.push(AddCertificate());
                          },
                          title: provider.awardsModel.isEmpty ? "Skip" : "Next",
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
                  (provider.awardsModel.isNotEmpty && provider.showAwardsForm)
                      ? IconButton(
                          onPressed: () {
                            provider.cancelAwardsEdit();
                          },
                          icon: const Icon(Icons.cancel_outlined),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              backgroundColor: Constants.white,
              floatingActionButton:
                  !provider.showAwardsForm && provider.awardsModel.isNotEmpty
                  ? FloatingActionButton(
                      backgroundColor: Constants.borderColor,
                      onPressed: () {
                        provider.clearAwardsForm();
                        provider.setShowAwardsForm(true);
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
      if (provider.awardsModel.isEmpty && !provider.showAwardsForm) {
        provider.setShowAwardsForm(true);
      }
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show form if needed
          if (provider.showAwardsForm || provider.awardsModel.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWithUnderLine(
                        title: "Awards And Achievements",
                        fontSize: 16,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  const customText(
                    title: "Title*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldforAll(
                    maxLength: 30,
                    controller: provider.awards_title,
                    hint: "Enter awards title",
                  ),
                  SizedBox(height: 15),
                  const customText(title: "Description*"),
                  CustomAutoSizeTextField(
                    controller: provider.awards_description,
                    hintText: "Enter awards description",
                    maxline: 4,
                    maxLength: 1200,
                  ),

                  const SizedBox(height: 15),
                  if (provider.isEditingAward &&
                      provider.awardsModel.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            provider.removeAwards(provider.editAwardIndex!);
                            provider.clearAwardsForm();
                            provider.setShowAwardsForm(false);
                          },
                          child: customText(title: "Delete Award"),
                        ),
                      ],
                    ),
                  if (provider.hasAwardsData)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomButtonForSave(
                        isPading: false,
                        onTap: () {
                          if (provider.awards_title.text.isEmpty) {
                            CustomSnackbar.show(
                              "Enter Awards title to save",
                              true,
                            );
                          } else if (provider.awards_description.text.isEmpty) {
                            CustomSnackbar.show(
                              "Enter awards description to save",
                              true,
                            );
                          } else {
                            provider.addOrUpdateAwards();
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
          if (provider.awardsModel.isNotEmpty && !provider.showAwardsForm)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Builder(
                builder: (context) {
                  // Sort the list but keep track of original indices
                  final sortedAwardsWithIndex = List.generate(
                    provider.awardsModel.length,
                    (index) => {
                      'award': provider.awardsModel[index],
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
                    itemCount: sortedAwardsWithIndex.length,
                    itemBuilder: (context, index) {
                      final item = sortedAwardsWithIndex[index];
                      final award = item['award'] as AwardsAndAchievementsModel;
                      final originalIndex = item['originalIndex'] as int;

                      return Column(
                        children: [
                          CustomNewListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Bullet ko top par rakhne ke liye
                                    children: [
                                      // 1. Bullet Point (Alag Widget)
                                      Text(
                                        "•  ", // Thoda space extra diya taki chipak na jaye
                                        style: GoogleFonts.merriweather(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      // 2. Main Content (Expanded me wrap kiya taki width restricted rahe)
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              // Part 1: Title (Bold & 14)
                                              TextSpan(
                                                text: "${award.title} : ",
                                                style: GoogleFonts.merriweather(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              // Part 2: Description (Normal & 12)
                                              TextSpan(
                                                text: award.description,
                                                style: GoogleFonts.merriweather(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Constants.subtitleclr,
                                                ),
                                              ),
                                            ],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4, // Text limit
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: CustomIconButton(
                              imageUrl: CustomIconUrl.editicon,
                              onTap: () {
                                provider.editAwards(originalIndex);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
