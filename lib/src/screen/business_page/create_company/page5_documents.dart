import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class Page5Documents extends StatelessWidget {
  const Page5Documents({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final provider = context.watch<BusinessCompanyProvider>();

    final docs = [
      'GST Certificate',
      'PAN of Firm',
      'MSME Certificate',
      'Certificate of Incorporation',
      'Employee ID Card',
      'Official Appointment / Offer Letter',
      'Send Approval Request to Admin',
    ];

    return Column(
      children: [
        ...docs.map(
          (doc) => RadioListTile<String>(
            title: customText(
              title: doc,
              fontSize: 14,
              color: colors.headingColor,
            ),
            value: doc,
            groupValue: provider.selectedDocumentType,
            onChanged: provider.setSelectedDocumentType,
            activeColor: colors.darkBlue,
          ),
        ),
      ],
    );
  }
}
