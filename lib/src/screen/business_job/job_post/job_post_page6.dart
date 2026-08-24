import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_bullet_textfield_for_jobpost.dart';
import 'package:provider/provider.dart';

class JobPostPageSix extends StatelessWidget {
  const JobPostPageSix({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<BusinessJobProvider>(
      builder: (context, provider, _) {
        return Scaffold(
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
                  if (provider.autoEligibilityList.isNotEmpty) ...[
                    const contentHeading(title: "Auto-Generated Rules:*"),
                    const SizedBox(height: 8),
                    Column(
                      children: provider.autoEligibilityList.map((rule) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                title: "• ",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: colors.headingColor,
                              ),
                              Expanded(
                                child: customText(
                                  title: rule,
                                  fontSize: 13,
                                  color: colors.headingColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  contentHeading(title: "Any Other Eligibility Criteria*"),
                  CustomBulletTextFieldForJobPost(
                    maxLength: 256,
                    hintText: "• Type custom eligibility rules...",
                    maxLines: 8,
                    controller: provider.eligibilityController,
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
              onTap: () => provider.setStep(7), // Move to Summary / Final Page
            ),
          ),
        );
      },
    );
  }
}
