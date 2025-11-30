// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/screen/career_preference.dart';
import 'package:job_circle/src/screen/login_and_signup/login/login.dart';
import 'package:job_circle/src/screen/referal_program/bank_detail_page.dart';
import 'package:job_circle/src/screen/referal_program/joiners_home_page.dart';
import 'package:job_circle/src/screen/referal_program/payment_status_home_page.dart';
import 'package:job_circle/src/screen/user_profile/user_profile.dart';
import 'package:job_circle/src/services/cache_clear_and_app_version/cache_clear_and_app_version_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onClose;
  final GlobalKey<ScaffoldState> scaffoldKey; // Callback to close drawer

  const CustomDrawer({
    required this.onClose,
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final userdetail = jobProvider.userData;
    return Container(
      width: 250, // Set width of the drawer
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 150,
            color: Constants.borderColor,
            padding: const EdgeInsets.only(
              top: kTextTabBarHeight,
              left: kTextTabBarHeight / 2,
              bottom: 10,
            ),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    scaffoldKey.currentState!.closeDrawer();
                    NavigationService.push(UserProfile());
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants.white,
                    backgroundImage:
                        userdetail!.userProfilePic != "" &&
                            userdetail.userProfilePic != null &&
                            userdetail.userProfilePic != " " &&
                            userdetail.userProfilePic != "null"
                        ? NetworkImage(
                            "${GlobalConstants.Image_url}${userdetail.userProfilePic}",
                          )
                        : userdetail.userGender == "Male"
                        ? AssetImage(CustomAssetUrl.maleicon)
                        : userdetail.userGender == "Female"
                        ? AssetImage(CustomAssetUrl.femalicon)
                        : NetworkImage(CustomIconUrl.usericon),
                  ),
                ),
                const SizedBox(height: 10),
                customText(
                  title: userdetail.userName.toString(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                customText(
                  title: cleanedLocation(userdetail.userLocation.toString()),
                  fontSize: 14,
                ),
              ],
            ),
          ),
          CareerPreferenceToggle(onClose: onClose, scaffoldKey: scaffoldKey),
          ExpansionTile(
            dense: true,
            textColor: Constants.darkBlue,

            iconColor: Constants.darkBlue,
            collapsedIconColor: Constants.darkBlue,
            //  collapsedTextColor: Constants.darkBlue,
            //  collapsedIconColor: Constants.black,
            leading: CustomNetworkImage(
              imageUrl: CustomIconUrl.referalprogramicon,
              defaultIcon: Icons.room_preferences_sharp,
            ),
            title: const customText(
              title: 'Referral Program',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Constants.darkBlue,
            ),
            children: [
              ListTile(
                dense: true,
                minLeadingWidth: 0.0,
                minVerticalPadding: 5.1,
                leading: CustomNetworkImage(
                  imageUrl: CustomIconUrl.joinersicon,
                  defaultIcon: Icons.room_preferences_sharp,
                ),
                title: const customText(
                  title: "Joiner's",
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                onTap: () {
                  NavigationService.push(JoinersHomePage());

                  onClose();
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth: 0.0,
                minVerticalPadding: 5.1,
                leading: CustomNetworkImage(
                  imageUrl: CustomIconUrl.walleticon,
                  defaultIcon: Icons.room_preferences_sharp,
                ),
                title: const customText(
                  title: 'Payment Tracker',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                onTap: () {
                  NavigationService.push(PaymentStatusHomePage());

                  onClose();
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth: 0.0,
                minVerticalPadding: 5.1,
                leading: CustomNetworkImage(
                  imageUrl: CustomIconUrl.bankicon,
                  defaultIcon: Icons.room_preferences_sharp,
                ),
                title: const customText(
                  title: 'My Banking Detail',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                onTap: () {
                  NavigationService.push(
                    BankingDetails(
                      name: userdetail.userName,
                      profilePic: userdetail.userProfilePic.toString(),
                      gender: userdetail.userGender,
                    ),
                  );

                  onClose();
                },
              ),
            ],
          ),
          ListTile(
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: CustomNetworkImage(
              imageUrl: CustomIconUrl.mailicon,
              defaultIcon: Icons.room_preferences_sharp,
            ),
            title: const customText(
              title: 'Write to us',
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            onTap: () async {
              await launchUrl(Uri.parse("mailto:support@jobcircle.co.in?"));
              onClose();
            },
          ),
          ListTile(
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: CustomNetworkImage(
              imageUrl: CustomIconUrl.shareicon,
              defaultIcon: Icons.room_preferences_sharp,
            ),
            title: const customText(
              title: 'Share App',
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              shareApp();
              onClose();
            },
          ),
          ListTile(
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: const Icon(Icons.logout_outlined),
            title: const customText(
              title: 'LogOut',
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            onTap: () async {
              SharedPrefsHelper.clearAllPreferences();
              await CacheClearAppVersionService.clearCache();
              NavigationService.pushAndRemoveUntil(const LoginPage());
              onClose();
            },
          ),

          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        final Uri url = Uri.parse(
                          "https://www.linkedin.com/company/job-circle/",
                        );
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // important!
                        )) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: CustomNetworkImage(
                          imageUrl: CustomIconUrl.linkdinicon,
                          defaultIcon: Icons.switch_access_shortcut_rounded,
                          height: 18,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                          "https://whatsapp.com/channel/0029VaWd8KB7NoZwpZQLCN35",
                        );
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // important!
                        )) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: CustomNetworkImage(
                          imageUrl: CustomIconUrl.whatsappicon,
                          defaultIcon: Icons.switch_access_shortcut_rounded,
                          height: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                          "https://www.instagram.com/jobcircleofficial?igsh=MTZzbXJ4dGJjaGt3ag==",
                        );
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // important!
                        )) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: CustomNetworkImage(
                          imageUrl: CustomIconUrl.instagramicon,
                          defaultIcon: Icons.switch_access_shortcut_rounded,
                          height: 18,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                          "https://www.facebook.com/JobCircleOfficial",
                        );
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // important!
                        )) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: CustomNetworkImage(
                          imageUrl: CustomIconUrl.facebookicon,
                          defaultIcon: Icons.switch_access_shortcut_rounded,
                          height: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: kToolbarHeight / 2,
                  ),
                  child: customText(
                    title: 'Version 1.1.4',
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String cleanedLocation(String userLocation) {
    // Split by comma, trim each part, remove duplicates, and join back
    final uniqueParts = userLocation
        .split(',')
        .map((e) => e.trim())
        .toSet()
        .toList();

    return uniqueParts.reversed.join(', ');
  }

  void shareApp() {
    const playStoreLink =
        'https://play.google.com/store/apps/details?id=com.job_circle_flutter';
    Share.share('Check out this app on Play Store: $playStoreLink');
  }
}

class CareerPreferenceToggle extends StatelessWidget {
  final VoidCallback onClose;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CareerPreferenceToggle({
    required this.onClose,
    required this.scaffoldKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CareerPreferenceProvider>(
      builder: (context, provider, child) {
        return ListTile(
          dense: true,
          minLeadingWidth: 0.0,
          minVerticalPadding: 5.1,
          leading: CustomNetworkImage(
            imageUrl: CustomIconUrl.careerpreficon,
            defaultIcon: Icons.work_outline,
          ),
          title: customText(
            title: 'Career Preference',
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          trailing: Transform.scale(
            alignment: Alignment.centerRight,
            scale: 0.6,
            child: Switch(
              padding: EdgeInsets.zero,
              value:
                  SharedPrefsHelper.getInt(
                        ESharedPreferences.jobpreferenceEnable,
                      ) ==
                      0
                  ? false
                  : true,
              activeColor: Constants.darkBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (value) async {
                if (!value) {
                  provider.updateJobPrefEnable(0);
                }
                if (value) {
                  scaffoldKey.currentState!.closeDrawer();
                  NavigationService.push(const CareerPreference());
                  onClose();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
