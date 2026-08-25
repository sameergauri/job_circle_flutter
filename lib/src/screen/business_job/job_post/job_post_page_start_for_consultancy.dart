import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:job_circle/src/widgets/text_field/custom_textfield_for_business_company.dart';
import 'package:provider/provider.dart';

class JobPostStartPageForConsultancy extends StatelessWidget {
  final bool isEdit;

  const JobPostStartPageForConsultancy({super.key, required this.isEdit});

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
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          title: "Which company are you hiring for?",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.headingColor,
                        ),
                        SizedBox(height: 10),
                        customText(
                          title:
                              "Company name help us to understand your job better and help you to find the right candidate",
                          fontSize: 14,
                          color: colors.subTitleColor,
                        ),
                        /*  //============= If Job posted from somewhere else ======================//
                        if (0 == 0) ...[
                          const contentHeading(title: "Company Name*"),
                          CustomTextFieldForBusinessCompany(
                            // focusNode: provider.selectedFirmFocusNode,
                            controller:
                                provider.suggestionSelectedFirmController,
                            hintText: "Company name",
                            title: "Company / Agency Name*",
                            onIdSelected: (p0) {
                              provider.setSelectedCompanyId(p0);
                            },
                            onChanged: (p0) {},
                          ),
                          const SizedBox(height: 10),
                        ],
                        //============= if user is from consultancy =============================// */
                        SizedBox(height: 20),
                        if (0 == 0) ...[
                          const contentHeading(title: "Hiring For*"),
                          CustomTextFieldForBusinessCompany(
                            // focusNode: provider.selectedFirmFocusNode,
                            controller: provider.hiringFor,
                            hintText: "Company name",
                            title: "Company / Agency Name*",
                            onIdSelected: (p0) {
                              provider.setSelectedCompanyId(p0);
                            },
                            onChanged: (p0) {},
                          ),
                          const SizedBox(height: 10),
                          CustomCheckboxRow(
                            title: "Don't show the compnay name to applicant",
                            value: provider.shouldShowToCandidate,
                            onChanged: (value) {
                              provider.setShouldShowToCandidate(value!);
                            },
                          ),
                          if (provider.shouldShowToCandidate) ...[
                            const SizedBox(height: 20),
                            customText(
                              title:
                                  "Help us to understand the reason for not disclosing the company name !",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.headingColor,
                            ),
                            const SizedBox(height: 12),

                            // Option 1: Confidential
                            CustomCheckboxRow(
                              title:
                                  "This is confidential job. Company doesn't wish to disclose.",
                              value:
                                  provider.selectedReasonOption ==
                                  "This is confidential job. Company doesn't wish to disclose.",
                              onChanged: (value) {
                                provider.selectReasonNotShowOption(
                                  value == true
                                      ? "This is confidential job. Company doesn't wish to disclose."
                                      : "",
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            // Option 2: Multiple Companies
                            CustomCheckboxRow(
                              title: "We are hiring for multiple companies.",
                              value:
                                  provider.selectedReasonOption ==
                                  "We are hiring for multiple companies.",
                              onChanged: (value) {
                                provider.selectReasonNotShowOption(
                                  value == true
                                      ? "We are hiring for multiple companies."
                                      : "",
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            // Option 3: Other
                            CustomCheckboxRow(
                              title: "Other",
                              value: provider.selectedReasonOption == "Other",
                              onChanged: (value) {
                                provider.selectReasonNotShowOption(
                                  value == true ? "Other" : "",
                                );
                              },
                            ),
                            SizedBox(height: 5),
                            // Show custom reason input only when "Other" is selected
                            if (provider.selectedReasonOption == "Other") ...[
                              const SizedBox(height: 10),
                              CustomTextFieldforAll(
                                hint: "Reason",
                                controller:
                                    provider.reasonForNotshowToCandidate,
                                maxLength: 60,
                              ),
                            ],
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: SafeArea(
            child: CustomButtonForSave(
              title: "Save & Continue",
              onTap: () {
                // provider.setStep(2);
                if (provider.validateAndSavePage1()) {
                  provider.setStep(2);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
