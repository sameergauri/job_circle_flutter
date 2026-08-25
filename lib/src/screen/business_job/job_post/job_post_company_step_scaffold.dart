import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

/// Shared scaffold for the company-setup steps (Identity Verification,
/// Documents, Declaration) that get shown after all job-post form steps in
/// the combined "post job for a new company" flow — the content widgets
/// themselves are reused unmodified from the normal Create Company flow.
class JobPostCompanyStepScaffold extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final Widget child;
  final VoidCallback onContinue;

  const JobPostCompanyStepScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.onContinue,
    this.buttonTitle = "Continue",
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        title: customText(
          title: title,
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
      body: SafeArea(child: SingleChildScrollView(child: child)),
      bottomNavigationBar: SafeArea(
        child: CustomButtonForSave(title: buttonTitle, onTap: onContinue),
      ),
    );
  }
}
