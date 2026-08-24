import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_bullet_textfield_for_jobpost.dart';
import 'package:provider/provider.dart';

class JobPostPageThree extends StatelessWidget {
  const JobPostPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Consumer<BusinessJobProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Scaffold(
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
                      // --- Key Responsibilities Header & AI / Clear Action Button ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const contentHeading(title: "Key Responsibility*"),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable:
                                provider.keyResponsibilitiesController,
                            builder: (context, value, _) {
                              // If field is empty & AI is not yet generated -> Show AI Writer Button
                              if ((value.text.isEmpty || value.text == "• ") &&
                                  !provider.isRespGenereted) {
                                return InkWell(
                                  onTap: () => provider
                                      .generateKeyResponsibilitiesWithAI(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
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
                                        const SizedBox(width: 4),
                                        customText(
                                          title: "AI writer",
                                          color: Constants.winecolor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              // If text is not empty -> Show Clear All Button
                              else if (value.text.isNotEmpty &&
                                  value.text != "• ") {
                                return InkWell(
                                  onTap: () =>
                                      provider.clearKeyResponsibilities(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: customText(
                                      title: "Clear All",
                                      color: Constants.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // --- Key Responsibilities Input ---
                      CustomBulletTextFieldForJobPost(
                        maxLength: 256,
                        hintText: "Enter Key Responsibilities",
                        maxLines: 8,
                        controller: provider.keyResponsibilitiesController,
                        onChanged: (p0) {
                          // Provider auto-parses this string upon final submit
                        },
                      ),
                      const SizedBox(height: 20),

                      // --- Boundary Limits Input ---
                      const contentHeading(title: "Boundary Limits"),
                      const SizedBox(height: 8),
                      CustomBulletTextFieldForJobPost(
                        maxLength: 256,
                        hintText: "Any Boundary Limit",
                        maxLines: 6,
                        controller: provider.boundaryController,
                        onChanged: (p0) {
                          // Provider auto-parses this string upon final submit
                        },
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: CustomButtonForSave(
                  title: "Save & Continue",
                  onTap: () {
                    if (provider.keyResponsibilitiesController.text
                            .trim()
                            .isEmpty ||
                        provider.keyResponsibilitiesController.text == "• ") {
                      CustomSnackbar.show("Enter key responsibility", true);
                    } else {
                      provider.setStep(4); // Navigate to next step
                    }
                  },
                ),
              ),
            ),

            // --- Loading Overlay for AI Generation ---
            if (provider.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Constants.darkBlue),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
