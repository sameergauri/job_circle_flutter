import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:job_circle/src/widgets/text_field/custom_textfield_for_business_company.dart';
import 'package:provider/provider.dart';

class Page4IdentityVerification extends StatelessWidget {
  const Page4IdentityVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusinessCompanyProvider>();
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.memberRole != "OWNER") ...[
            customText(
              title: "Company / Agency Name*",
              color: colors.headingColor,
            ),
            CustomTextFieldForBusinessCompany(
              // focusNode: provider.selectedFirmFocusNode,
              controller: provider.suggestionSelectedFirmController,
              hintText: "Company name",
              title: "Company / Agency Name*",
              onIdSelected: (p0) {
                provider.setCompanyId(p0);
              },
              onChanged: (p0) {},
            ),
            SizedBox(height: 10),
          ],

          /*  CustomTextFieldforAll(
            controller: provider.firmLegalNameController,
            hint: "Company name",
          ), */
          customText(title: "Designation*", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.designationController,
            hint: "Hr Manager",
          ),
          SizedBox(height: 10),
          customText(title: "Official Contact No*", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.officialContactController,
            hint: "XXXXXXXX86",
            isNumber: true,
            isGmail: true,
          ),
          SizedBox(height: 10),
          customText(title: "Official E-Mail ID*", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.officialEmailController,
            hint: "XXXXX@domain.com",
            isGmail: true,
          ),
          SizedBox(height: 20),
          CustomCheckboxRow(
            title: "I don't have a company domain Email ID.",
            value: provider.isNoDomainEmail,
            onChanged: (value) {
              provider.toggleNoDomainEmail(value!);
            },
          ),
        ],
      ),
    );
  }
}
