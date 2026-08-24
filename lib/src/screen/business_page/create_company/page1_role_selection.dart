import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/screen/business_page/create_company/custom_widget.dart';
import 'package:provider/provider.dart';

class Page1RoleSelection extends StatelessWidget {
  const Page1RoleSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusinessCompanyProvider>();
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCompanyRadioTile(
          colors: colors,
          title: 'Direct Employer (In-House)',
          subtitle: 'Hiring directly on their own company.',
          value: 'DIRECT_EMPLOYER',
          groupValue: provider.companyType ?? '', // Defaults to unselected
          onChanged: (v) {
            provider.setCompanyType(
              v!,
              context,
              () => showRoleIdentificationBottomSheet(context),
            );
          },
        ),
        buildCompanyRadioTile(
          colors: colors,
          title: 'Consultant / Staffing Agency',
          subtitle:
              'Third-party recruiters / agencies hiring on behalf of client.',
          value: 'CONSULTANT',
          groupValue: provider.companyType ?? '', // Defaults to unselected
          onChanged: (v) {
            provider.setCompanyType(
              v!,
              context,
              () => showRoleIdentificationBottomSheet(context),
            );
          },
        ),
      ],
    );
  }
}
