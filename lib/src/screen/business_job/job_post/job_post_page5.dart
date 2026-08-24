import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_add_skill.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_title/content_heading.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class JobPostPageFive extends StatelessWidget {
  const JobPostPageFive({super.key});

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
                  const contentHeading(title: "Add Certificate"),

                  // --- Search TextField ---
                  CustomTextFieldforAll(
                    hint: "Type to search Certificate",
                    controller: provider.certificateSearchController,
                    onChanged: (text) => provider.filterCertificates(text),
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      provider.filterCertificates("");
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                      provider.filterCertificates("");
                    },
                  ),

                  // --- No Certificate Found / Add Custom State ---
                  if (provider.filteredCertificates.isEmpty &&
                      provider.certificateSearchController.text.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            customText(
                              color: colors.subTitleColor,
                              textAlign: TextAlign.center,
                              title:
                                  "No certificate found as per your search result. \n click 'ADD NEW CERTIFICATE' button to add new certificate",
                            ),
                            const SizedBox(height: 8),
                            CustomAddButton(
                              title: "Add New Certificate",
                              onTab: () => provider.addCustomCertificate(),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- Filtered Certificate Dropdown List ---
                  if (provider.filteredCertificates.isNotEmpty &&
                      provider.certificateSearchController.text.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: colors.bottomsheetbgColor,
                        border: Border.all(color: Constants.borderColor),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.filteredCertificates.length,
                        itemBuilder: (context, index) {
                          final isOdd = index % 2 == 0;
                          final backgroundColor = isOdd
                              ? colors.bottomsheerCard1Color
                              : colors.bottomsheerCard2Color;
                          final suggestion =
                              provider.filteredCertificates[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomListTile(
                              contentPadding: EdgeInsetsGeometry.only(left: 10),
                              dense: true,
                              title: customText(
                                color: colors.headingColor,
                                title: suggestion.value.toString(),
                                fontSize: 12,
                              ),
                              onTap: () => provider.addCertificate(suggestion),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  // --- Selected Certificates Chips Display ---
                  if (provider.selectedCertificates.isNotEmpty) ...[
                    customText(
                      title: "Selected Certificates:",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: colors.headingColor,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.selectedCertificates
                          .asMap()
                          .entries
                          .map((entry) {
                            final idx = entry.key;
                            final cert = entry.value;
                            final isMandatory = cert.mandatory == 1;

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colors.bottomsheetbgColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Constants.borderColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Toggle Mandatory Star
                                  GestureDetector(
                                    onTap: () => provider
                                        .toggleCertificateMandatory(idx),
                                    child: Icon(
                                      isMandatory
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 20,
                                      color: isMandatory
                                          ? Constants.darkBlue
                                          : Constants.subtitleclr,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  customText(
                                    title: cert.value ?? '',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colors.headingColor,
                                  ),
                                  const SizedBox(width: 6),
                                  // Remove Certificate Chip
                                  GestureDetector(
                                    onTap: () =>
                                        provider.removeCertificate(idx),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Constants.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: CustomButtonForSave(
              title: "Save & Continue",
              onTap: () {
                provider.setStep(6); // Move to Step 6 (Eligibility)
              },
            ),
          ),
        );
      },
    );
  }
}
