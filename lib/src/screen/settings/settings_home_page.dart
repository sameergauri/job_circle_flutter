import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_bottom_sheet_for_app_theme.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class SettingHomePage extends StatelessWidget {
  const SettingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: colors.bgColor,
        appBar: AppBar(
          leadingWidth: 25,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: colors.headingColor),
          backgroundColor: colors.appbarColor,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: customText(
              title: 'Account preferences',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.headingColor,
            ),
          ),
          /* actions: [
            IconButton(
              icon: Icon(Icons.help_outline, color: colors.headingColor),
              onPressed: () {
                CustomSnackbar.show(
                  "For Help go to app drawer and click on write to us option",
                  true,
                );
              },
            ),
          ], */
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Profile information', colors),
            _buildSettingsTile('Verifications', () {
              // Navigate to Verifications Page
            }, colors),
            Divider(thickness: 10, color: colors.bottomsheerCard1Color),
            _buildHeader('Display', colors),
            _buildSettingsTile('Dark mode', () {
              CustomBottomSheet.showCustomBottomSheetForAppTheme(
                context: context,
              );
            }, colors),
            Divider(thickness: 10, color: colors.bottomsheerCard1Color),
            _buildHeader('Syncing & storage', colors),
            _buildSettingsTile('Contact sync', () {
              // Navigate to Contact Sync Settings
            }, colors),
            Divider(thickness: 10, color: colors.bottomsheerCard1Color),
            _buildHeader('Account management', colors),
            _buildSettingsTile('Delete Account', () {
              // Navigate to Account Management Settings
            }, colors),
          ],
        ),
      ),
    );
  }

  // Widget for the Bold Section Headers
  Widget _buildHeader(String title, AppColors colors) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 5),
      child: customText(
        title: title,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.headingColor,
      ),
    );
  }

  // Widget for the clickable Setting Rows
  Widget _buildSettingsTile(String title, Function()? onTap, AppColors colors) {
    return Column(
      children: [
        ListTile(
          title: customText(
            title: title,
            fontSize: 14,
            color: colors.headingColor,
          ),
          trailing: Icon(
            Icons.arrow_forward,
            size: 20,
            color: colors.subTitleColor,
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
