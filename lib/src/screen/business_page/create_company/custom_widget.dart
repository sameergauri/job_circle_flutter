import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

/// Reusable Radio List Tile
Widget buildCompanyRadioTile({
  required String title,
  required String subtitle,
  required String value,
  required String groupValue,
  required AppColors colors,
  required ValueChanged<String?> onChanged,
}) {
  return RadioListTile<String>(
    title: customText(
      title: title,
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: colors.headingColor,
    ),
    subtitle: customText(
      title: subtitle,
      fontSize: 12,
      color: colors.subTitleColor,
    ),
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
    contentPadding: EdgeInsets.zero,
    activeColor: colors.darkBlue,
  );
}

void showRoleIdentificationBottomSheet(BuildContext context) {
  final colors = context.appColors;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: colors.bottomsheetbgColor,
    builder: (modalContext) {
      return Consumer<BusinessCompanyProvider>(
        builder: (context, provider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      title: 'Role Identification',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.darkBlue,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: colors.subTitleColor,
                      ),
                      onPressed: () => Navigator.pop(modalContext),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              buildCompanyRadioTile(
                colors: context.appColors,
                title: 'Business Owner / Founder / Director',
                subtitle:
                    'Holds legal authority over company proof/KYC - Granted Primary Admin Rights.',
                value: 'OWNER',
                groupValue: provider.memberRole ?? '',
                onChanged: (v) {
                  provider.setMemberRole(v!);
                  Navigator.pop(modalContext); // Dismiss on selection
                },
              ),
              buildCompanyRadioTile(
                colors: context.appColors,
                title: 'Recruiter / TA Professional',
                subtitle:
                    'Executes hiring for an existing workspace - Access to post jobs & source candidates.',
                value: 'RECRUITER',
                groupValue: provider.memberRole ?? '',
                onChanged: (v) {
                  provider.setMemberRole(v!);
                  Navigator.pop(modalContext); // Dismiss on selection
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      );
    },
  );
}
