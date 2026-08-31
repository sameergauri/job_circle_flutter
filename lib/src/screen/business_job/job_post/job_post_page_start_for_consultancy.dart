// lib/src/screen/business_job/job_post/job_post_page_start_for_consultancy.dart

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:job_circle/src/widgets/text_field/custom_textfield_for_business_company.dart';
import 'package:provider/provider.dart';

class JobPostStartPageForConsultancy extends StatefulWidget {
  final bool isEdit;
  final bool isConsultancy;

  const JobPostStartPageForConsultancy({
    super.key,
    required this.isEdit,
    required this.isConsultancy,
  });

  @override
  State<JobPostStartPageForConsultancy> createState() =>
      _JobPostStartPageForConsultancyState();
}

class _JobPostStartPageForConsultancyState
    extends State<JobPostStartPageForConsultancy> {
  bool _isDirectEmployerCompanyFromDropdown = false;
  bool _isHiringForFromDropdown = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final companyProvider = context.watch<BusinessCompanyProvider>();
    final isDirectRecruiter =
        !widget.isConsultancy && companyProvider.memberRole != 'OWNER';

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
                      children: isDirectRecruiter
                          ? _buildDirectRecruiterFields(
                              context,
                              companyProvider,
                              provider,
                              colors,
                            )
                          : _buildConsultancyFields(
                              context,
                              provider,
                              companyProvider,
                              colors,
                            ),
                    ),
                  ),
                ),
          bottomNavigationBar: SafeArea(
            child: CustomButtonForSave(
              title: "Save & Continue",
              onTap: () {
                if (isDirectRecruiter) {
                  if (companyProvider.suggestionSelectedFirmController.text
                      .trim()
                      .isEmpty) {
                    CustomSnackbar.show("Please enter company name", true);
                    return;
                  }
                  if (!_isDirectEmployerCompanyFromDropdown &&
                      provider.industryController.text.trim().isEmpty) {
                    CustomSnackbar.show("Please enter industry", true);
                    return;
                  }
                  provider.setStep(1);
                } else {
                  // Consultancy validation
                  if (provider.hiringFor.text.trim().isEmpty) {
                    CustomSnackbar.show("Please enter Hiring For", true);
                    return;
                  }
                  if (!_isHiringForFromDropdown &&
                      provider.industryController.text.trim().isEmpty) {
                    CustomSnackbar.show("Please enter Job Industry", true);
                    return;
                  }
                  if (provider.shouldShowToCandidate &&
                      provider.reasonForNotshowToCandidate.text
                          .trim()
                          .isEmpty) {
                    CustomSnackbar.show(
                      "Please enter reason for not showing company name",
                      true,
                    );
                    return;
                  }
                  provider.setStep(1);
                }
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDirectRecruiterFields(
    BuildContext context,
    BusinessCompanyProvider companyProvider,
    BusinessJobProvider jobProvider,
    AppColors colors,
  ) {
    return [
      customText(
        title: "Tell us about your company",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: colors.headingColor,
      ),
      const SizedBox(height: 10),
      customText(
        title: "This sets up your company profile and job post together",
        fontSize: 14,
        color: colors.subTitleColor,
      ),
      const SizedBox(height: 20),
      const contentHeading(title: "Company Name*"),
      CustomTextFieldForBusinessCompany(
        controller: companyProvider.suggestionSelectedFirmController,
        hintText: "Company name",
        title: "Company / Agency Name*",
        onIdSelected: (id) {
          companyProvider.setCompanyId(id);
          setState(() {
            _isDirectEmployerCompanyFromDropdown = (id != null && id != 0);
          });
        },
        onChanged: (text) {
          if (_isDirectEmployerCompanyFromDropdown) {
            setState(() {
              _isDirectEmployerCompanyFromDropdown = false;
            });
          }
        },
      ),
      if (!_isDirectEmployerCompanyFromDropdown) ...[
        const SizedBox(height: 10),
        const contentHeading(title: "Industry*"),
        CustomTextFieldForMasterData(
          contextIn: context,
          controller: jobProvider.industryController,
          hintText: "Type to search",
          name: "industry",
          title: "Industry",
        ),
      ],
    ];
  }

  List<Widget> _buildConsultancyFields(
    BuildContext context,
    BusinessJobProvider provider,
    BusinessCompanyProvider companyProvider,
    AppColors colors,
  ) {
    return [
      customText(
        title: "Which company are you hiring for?",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: colors.headingColor,
      ),
      const SizedBox(height: 10),
      customText(
        title:
            "Company name helps us understand your job better and find the right candidate",
        fontSize: 14,
        color: colors.subTitleColor,
      ),
      const SizedBox(height: 20),
      const contentHeading(title: "Hiring For*"),
      CustomTextFieldForBusinessCompany(
        controller: provider.hiringFor,
        hintText: "Client company name",
        title: "Hiring For*",
        onIdSelected: (id) {
          provider.setSelectedCompanyId(id ?? 0);
          setState(() {
            _isHiringForFromDropdown = (id != null && id != 0);
          });
        },
        onChanged: (p0) {
          if (_isHiringForFromDropdown) {
            setState(() {
              _isHiringForFromDropdown = false;
            });
          }
        },
      ),
      const SizedBox(height: 10),
      CustomCheckboxRow(
        title: "Don't show the company name to applicant",
        value: provider.shouldShowToCandidate,
        onChanged: (value) {
          provider.setShouldShowToCandidate(value!);
        },
      ),
      if (provider.shouldShowToCandidate) ...[
        const SizedBox(height: 20),
        customText(
          title:
              "Help us understand the reason for not disclosing the company name!",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colors.headingColor,
        ),
        const SizedBox(height: 12),
        CustomCheckboxRow(
          title:
              "This is a confidential job. Company doesn't wish to disclose.",
          value:
              provider.selectedReasonOption ==
              "This is a confidential job. Company doesn't wish to disclose.",
          onChanged: (value) {
            provider.selectReasonNotShowOption(
              value == true
                  ? "This is a confidential job. Company doesn't wish to disclose."
                  : "",
            );
          },
        ),
        const SizedBox(height: 10),
        CustomCheckboxRow(
          title: "We are hiring for multiple companies.",
          value:
              provider.selectedReasonOption ==
              "We are hiring for multiple companies.",
          onChanged: (value) {
            provider.selectReasonNotShowOption(
              value == true ? "We are hiring for multiple companies." : "",
            );
          },
        ),
        const SizedBox(height: 10),
        CustomCheckboxRow(
          title: "Other",
          value: provider.selectedReasonOption == "Other",
          onChanged: (value) {
            provider.selectReasonNotShowOption(value == true ? "Other" : "");
          },
        ),
        if (provider.selectedReasonOption == "Other") ...[
          const SizedBox(height: 10),
          CustomTextFieldforAll(
            hint: "Reason",
            controller: provider.reasonForNotshowToCandidate,
            maxLength: 60,
          ),
        ],
      ],
      if (!_isHiringForFromDropdown) ...[
        const SizedBox(height: 10),
        const contentHeading(title: "Job Industry*"),
        CustomTextFieldForMasterData(
          contextIn: context,
          controller: provider.industryController,
          hintText: "Type to search",
          name: "industry",
          title: "Job Industry",
        ),
      ],
    ];
  }
}
