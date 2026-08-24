import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_bullet_textfield_for_jobpost.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class JobPostPageSeven extends StatefulWidget {
  const JobPostPageSeven({super.key});

  @override
  State<JobPostPageSeven> createState() => _JobPostPageSevenState();
}

class _JobPostPageSevenState extends State<JobPostPageSeven> {
  @override
  void initState() {
    super.initState();
    // Auto-check and generate summary if required on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessJobProvider>().needSummary();
    });
  }

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
                      if (provider.jobSummaryController.text.isNotEmpty) ...[
                        // --- Job Summary Header with AI / Clear Button ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const contentHeading(title: "Job summary*"),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: provider.jobSummaryController,
                              builder: (context, value, _) {
                                // If summary is empty and not generated -> Show AI Writer
                                if (value.text.isEmpty &&
                                    !provider.isSummaryGenereted) {
                                  return InkWell(
                                    onTap: () =>
                                        provider.generateJobSummaryWithAI(),
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
                                // If summary is present -> Show Clear All
                                else if (value.text.isNotEmpty) {
                                  return InkWell(
                                    onTap: () => provider.clearJobSummary(),
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
                        // --- Job Summary Field ---
                        CustomTextFieldforAll(
                          controller: provider.jobSummaryController,
                          hint: "Add Job Summary",
                          maxline: 10,
                        ),

                        const SizedBox(height: 10),
                      ],

                      // --- Eligibility Guidelines Field ---
                      const contentHeading(title: "Additional Detail*"),
                      const SizedBox(height: 8),
                      CustomBulletTextFieldForJobPost(
                        hintText: "Any Additional details",
                        maxLines: 8,
                        maxLength: 500,
                        controller: provider.additionalDetailsController,
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
                  title: provider.isEditMode ? "Update Job" : "Post Job",
                  onTap: () async {
                    provider.setStep(8);
                  },
                ),
              ),
            ),

            // --- Loading Overlay ---
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
