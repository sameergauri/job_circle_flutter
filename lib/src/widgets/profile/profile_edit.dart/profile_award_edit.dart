// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class ProfileAwardEdit extends StatelessWidget {
  final FromEditOrAdd fromEditOrAdd;
  const ProfileAwardEdit({super.key, required this.fromEditOrAdd});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: colors.bgColor,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: colors.appbarColor,
                elevation: 0,
                titleSpacing: 0.0,
                iconTheme: IconThemeData(color: colors.headingColor),
                title: const OnboardingTitle(
                  title: "Awards & Achievements",
                  fontSize: 16,
                ),
                actions: [
                  !provider.showAwardForm &&
                          provider.profile!.awardsAndAchievements!.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            provider.clearAwardForm();
                            provider.setShowAwardForm(true);
                          },
                          icon: const Icon(Icons.add),
                        )
                      : (provider.profile!.awardsAndAchievements != null &&
                            provider
                                .profile!
                                .awardsAndAchievements!
                                .isNotEmpty &&
                            fromEditOrAdd == FromEditOrAdd.edit)
                      ? IconButton(
                          onPressed: () {
                            provider.cancelAwardEdit();
                            if (provider.profile!.awardsAndAchievements !=
                                    null &&
                                provider
                                        .profile!
                                        .awardsAndAchievements!
                                        .length ==
                                    1) {
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
                    provider.profile!.awardsAndAchievements == null ||
                        provider.profile!.awardsAndAchievements!.isEmpty ||
                        provider.showAwardForm
                    ? customForm(provider, context, colors)
                    : CustomBody(provider, colors),
              ),
            ),
            if (provider.isUpdating) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  Widget customForm(
    ProfileProvider provider,
    BuildContext context,
    AppColors colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            customText(
              title: "Title*",
              fontStyle: FontStyle.italic,
              color: colors.headingColor,
            ),
            CustomTextFieldforAll(
              maxLength: 30,
              controller: provider.awardTitleController,
              hint: "Enter award title",
            ),
            SizedBox(height: 15),
            customText(title: "Description*", color: colors.headingColor),
            CustomAutoSizeTextField(
              controller: provider.awardDescriptionController,
              hintText: "Enter award description",
              maxline: 4,
              maxLength: 500,
            ),

            const SizedBox(height: 15),
            if (provider.isEditingAward &&
                provider.profile!.awardsAndAchievements!.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.removeAward(provider.editingAwardIndex!);
                      provider.clearAwardForm();
                      provider.setShowAwardForm(false);
                    },
                    child: customText(
                      title: "Delete Award",
                      color: colors.headingColor,
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () {
                  if (provider.awardTitleController.text.isEmpty) {
                    CustomSnackbar.show("Enter Award title to save", true);
                  } else if (provider.awardDescriptionController.text.isEmpty) {
                    CustomSnackbar.show(
                      "Enter award description to save",
                      true,
                    );
                  } else {
                    provider.addOrUpdateAward();
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

  Widget CustomBody(ProfileProvider provider, AppColors colors) {
    // Sort the list but keep track of original indices
    final sortedAwardsWithIndex = List.generate(
      provider.profile!.awardsAndAchievements!.length,
      (index) => {
        'award': provider.profile!.awardsAndAchievements![index],
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
        itemCount: sortedAwardsWithIndex.length,
        itemBuilder: (context, index) {
          final item = sortedAwardsWithIndex[index];
          final data = item['award'] as AwardsAndAchievementsModel;
          final originalIndex = item['originalIndex'] as int;
          return Column(
            children: [
              CustomNewListTile(
                onTap: () {},
                contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                /*  leading: Container(
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
                ), */
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
                              color: colors.headingColor,
                            ),
                          ),

                          // 2. Main Content (Expanded me wrap kiya taki width restricted rahe)
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  // Part 1: Title (Bold & 14)
                                  TextSpan(
                                    text: "${data.title} : ",
                                    style: GoogleFonts.merriweather(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: colors.headingColor,
                                    ),
                                  ),
                                  // Part 2: Description (Normal & 12)
                                  TextSpan(
                                    text: data.description,
                                    style: GoogleFonts.merriweather(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: colors.subTitleColor,
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
                /* subtitle: data.description != null && data.description != 'null'
                    ? customText(
                        title: MonthRangeFormatter.formatMonthRange(
                          data.description!,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Constants.subtitleclr,
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox.shrink(), */
                trailing: IconButton(
                  onPressed: () {
                    provider.editAward(originalIndex);
                  },
                  icon: CustomNetworkImage(
                    imageUrl: CustomIconUrl.editicon,
                    defaultIcon: Icons.cast_for_education,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
