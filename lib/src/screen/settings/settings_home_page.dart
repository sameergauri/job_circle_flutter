import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/screen/business_page/business_home_page.dart';
import 'package:job_circle/src/screen/digi_locker/digilocker_one.dart';
import 'package:job_circle/src/screen/digi_locker/digilocker_verified_page.dart';
import 'package:job_circle/src/screen/login_and_signup/login/login.dart';
import 'package:job_circle/src/screen/referal_program/bank_detail_page.dart';
import 'package:job_circle/src/services/cache_clear_and_app_version/cache_clear_and_app_version_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_bottom_sheet_for_app_theme.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SettingHomePage extends StatelessWidget {
  final ProfileModel profile;
  const SettingHomePage({super.key, required this.profile});

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
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return _buildSettingsTile('Verifications', () {
                  if (profileProvider.profile!.isUserVerified == true) {
                    NavigationService.push(DigiLockerVerifiedPage());
                  } else {
                    final hasRequiredInfo =
                        (profile.firstName?.trim().isNotEmpty ?? false) &&
                        (profile.lastName?.trim().isNotEmpty ?? false) &&
                        (profile.dob?.trim().isNotEmpty ?? false) &&
                        (profile.gender?.trim().isNotEmpty ?? false);

                    if (!hasRequiredInfo) {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: colors.bottomsheetbgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFF3E0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    color: colors.orangeLine,
                                    size: 38,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Complete Your Profile',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: colors.headingColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Please fill in your first name, last name, date of birth, and gender in your profile before starting verification.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.subTitleColor,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 26),
                                SizedBox(
                                  width: double.infinity,
                                  height: 46,
                                  child: ElevatedButton(
                                    onPressed: () => NavigationService.pop(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.darkBlue,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: colors.bottomsheetbgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Constants.borderColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shield_outlined,
                                    color: colors.darkBlue,
                                    size: 38,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Before You Continue',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: colors.headingColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Please ensure your name (${profile.firstName} ${profile.middleName} ${profile.lastName}) in the profile matches exactly as it appears on your Aadhaar card for successful verification.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.subTitleColor,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 26),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 46,
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              NavigationService.pop(),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: colors.darkBlue!,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: colors.darkBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: SizedBox(
                                        height: 46,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            NavigationService.pop();
                                            NavigationService.push(
                                              DigiLockerOne(profile: profile),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colors.darkBlue,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            'Continue',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }, colors);
              },
            ),
            _buildSettingsTile('My Banking Detail', () {
              // NavigationService.push(SelfieCaptureScreen());
              NavigationService.push(
                BankingDetails(
                  name: "${profile.firstName} ${profile.lastName}",
                  profilePic: profile.profilePic.toString(),
                  gender: profile.gender.toString(),
                ),
              );
            }, colors),
            Divider(thickness: 10, color: colors.bottomsheerCard1Color),
            _buildHeader('Business', colors),
            _buildSettingsTile('Business Page', () {
              NavigationService.push(BusinessHomePage());
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
            _buildSettingsTile('Logout', () async {
              // Clear Shared Preferences and navigate to Login Page
              final client = StreamChat.of(context).client;
              // 1. Disconnect Stream
              await client.disconnectUser();
              SharedPrefsHelper.clearAllPreferences();
              await CacheClearAppVersionService.clearCache();
              NavigationService.pushAndRemoveUntil(LoginPage());
            }, colors),
            _buildSettingsTile('Deactivate Account', () {
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
