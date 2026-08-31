// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, use_build_context_synchronously
// idnore_for_file: todo

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/provider/business_page/company_member_provider.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/screen/business_page/business_home_page.dart';
import 'package:job_circle/src/screen/business_page/create_company/create_company_page.dart';
import 'package:job_circle/src/screen/career_preference.dart';
import 'package:job_circle/src/screen/faq/faq_home_screen.dart';
import 'package:job_circle/src/screen/referal_program/joiners_home_page.dart';
import 'package:job_circle/src/screen/referal_program/payment_status_home_page.dart';
import 'package:job_circle/src/screen/user_profile/user_profile.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_expansion_list_tile.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback onClose;
  final GlobalKey<ScaffoldState> scaffoldKey; // Callback to close drawer

  const CustomDrawer({
    required this.onClose,
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
      if (userId != 0) {
        context.read<CompanyMembershipProvider>().fetchMembershipSummary(
          userId: userId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final userdetail = jobProvider.userData;
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Material(
        color: colors.draweBgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 150,
              color: colors.appbarColor,
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
                      widget.scaffoldKey.currentState!.closeDrawer();
                      NavigationService.push(UserProfile());
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: colors.circlebgColor,
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
                    color: colors.headingColor,
                  ),
                  customText(
                    title: cleanedLocation(userdetail.userLocation.toString()),
                    fontSize: 14,
                    color: colors.headingColor,
                  ),
                ],
              ),
            ),
            CareerPreferenceToggle(
              onClose: widget.onClose,
              scaffoldKey: widget.scaffoldKey,
            ),
            CustomExpansionTile(
              dense: true,
              textColor: Constants.darkBlue,
              childrenPadding: EdgeInsets.only(left: 30, right: 10),
              tilePadding: EdgeInsets.only(left: 10, right: 10),
              iconColor: Constants.darkBlue,
              collapsedIconColor: Constants.darkBlue,
              //  collapsedTextColor: Constants.darkBlue,
              //  collapsedIconColor: Constants.black,
              leading: CustomNetworkImage(
                imageUrl: CustomIconUrl.referalprogramicon,
                defaultIcon: Icons.room_preferences_sharp,
                color: colors.subtitleTextColor,
              ),
              title: customText(
                title: 'Referral Program',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: colors.subtitleTextColor,
                // color: Constants.darkBlue,
              ),
              children: [
                CustomListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  dense: true,
                  minLeadingWidth: 0.0,
                  minVerticalPadding: 5.1,
                  leading: CustomNetworkImage(
                    imageUrl: CustomIconUrl.joinersicon,
                    defaultIcon: Icons.room_preferences_sharp,
                    color: colors.subtitleTextColor,
                  ),
                  title: customText(
                    title: "Joiner's",
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: colors.subtitleTextColor,
                  ),
                  onTap: () {
                    NavigationService.push(JoinersHomePage());

                    widget.onClose();
                  },
                ),
                CustomListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  dense: true,
                  minLeadingWidth: 0.0,
                  minVerticalPadding: 5.1,
                  leading: CustomNetworkImage(
                    imageUrl: CustomIconUrl.walleticon,
                    defaultIcon: Icons.room_preferences_sharp,
                    color: colors.subtitleTextColor,
                  ),
                  title: customText(
                    title: 'Payment Tracker',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: colors.subtitleTextColor,
                  ),
                  onTap: () {
                    NavigationService.push(PaymentStatusHomePage());

                    widget.onClose();
                  },
                ),
                /*  CustomListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  dense: true,
                  minLeadingWidth: 0.0,
                  minVerticalPadding: 5.1,
                  leading: CustomNetworkImage(
                    imageUrl: CustomIconUrl.bankicon,
                    defaultIcon: Icons.room_preferences_sharp,
                    color: colors.subtitleTextColor,
                  ),
                  title: customText(
                    title: 'My Banking Detail',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: colors.subtitleTextColor,
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
                ), */
              ],
            ),
            /* CustomListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              dense: true,
              minLeadingWidth: 0.0,
              minVerticalPadding: 5.1,
              leading: CustomNetworkImage(
                imageUrl: CustomIconUrl.mailicon,
                defaultIcon: Icons.room_preferences_sharp,
                color: colors.subtitleTextColor,
              ),
              title: customText(
                title: 'Write to us',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: colors.subtitleTextColor,
              ),
              onTap: () async {
                await launchUrl(Uri.parse("mailto:support@jobcircle.co.in?"));
                onClose();
              },
            ), */
            CustomListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              dense: true,
              minLeadingWidth: 0.0,
              minVerticalPadding: 5.1,
              leading: CustomNetworkImage(
                imageUrl: CustomIconUrl.shareicon,
                defaultIcon: Icons.room_preferences_sharp,
                color: colors.subtitleTextColor,
              ),
              title: customText(
                title: 'Share App',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: colors.subtitleTextColor,
              ),
              onTap: () {
                shareApp();
                widget.onClose();
              },
            ),
            CustomListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              dense: true,
              minLeadingWidth: 0.0,
              minVerticalPadding: 5.1,
              leading: CustomNetworkImage(
                imageUrl: CustomIconUrl.faqicon,
                defaultIcon: Icons.room_preferences_sharp,
                color: colors.subtitleTextColor,
              ),
              title: customText(
                title: 'FAQ',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: colors.subtitleTextColor,
              ),
              onTap: () async {
                NavigationService.push(FaqScreen());
                widget.onClose();
              },
            ),
            // --- Conditional Job Post / Manage Company Buttons ---
            Consumer<CompanyMembershipProvider>(
              builder: (context, membershipProvider, _) {
                final memberships = membershipProvider.memberships;
                final bool hasNoCompany = memberships.isEmpty;
                final bool isOwner = memberships.any(
                  (m) => m.memberRole?.toUpperCase() == 'OWNER',
                );

                return Column(
                  children: [
                    // 1. Show 'Job Post' ONLY if user belongs to NO company
                    if (hasNoCompany)
                      CustomListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        dense: true,
                        minLeadingWidth: 0.0,
                        minVerticalPadding: 5.1,
                        leading: CustomNetworkImage(
                          imageUrl: CustomIconUrl.addcrpficon,
                          defaultIcon: Icons.room_preferences_sharp,
                          color: colors.subtitleTextColor,
                        ),
                        title: customText(
                          title: 'Job Post',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: colors.subtitleTextColor,
                        ),
                        onTap: () {
                          context.read<BusinessCompanyProvider>().resetForm();
                          NavigationService.push(
                            CreateCompanyPage(forNewJob: ForNewJob.NEW),
                          );
                          /* NavigationService.push(
                            JobPostMasterScreen(isEdit: false),
                          ); */
                          widget.onClose();
                        },
                      ),
                    // 2. Show 'Manage Company' ONLY if user is an OWNER
                    if (isOwner)
                      CustomListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        dense: true,
                        minLeadingWidth: 0.0,
                        minVerticalPadding: 5.1,
                        leading: CustomNetworkImage(
                          imageUrl: CustomIconUrl.websiteicon,
                          defaultIcon: Icons.business_outlined,
                          color: colors.subtitleTextColor,
                        ),
                        title: customText(
                          title: 'Manage Company',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: colors.subtitleTextColor,
                        ),
                        onTap: () {
                          NavigationService.push(BusinessHomePage());
                          widget.onClose();
                        },
                      ),
                  ],
                );
              },
            ),
            /*   CustomListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              dense: true,
              minLeadingWidth: 0.0,
              minVerticalPadding: 5.1,
              leading: Icon(
                Icons.logout_outlined,
                color: colors.subtitleTextColor,
              ),
              title: customText(
                title: 'Testing',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: colors.subtitleTextColor,
              ),
              onTap: () async {
                NavigationService.push(
                  JobPostStartPageForConsultancy(
                    isEdit: false,
                    isConsultancy: true,
                  ),
                );
                widget.onClose();
              },
            ), */
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
                          final url = Uri.parse("https://www.jobcircle.co.in");
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
                            imageUrl: CustomIconUrl.websiteicon,
                            defaultIcon: Icons.switch_access_shortcut_rounded,
                            height: 18,
                            color: Constants.darkBlue,
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
                      title: 'Version 1.1.18',
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      color: colors.headingColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

// ignore_for_file: todo
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
    final colors = context.appColors;
    return Consumer<CareerPreferenceProvider>(
      builder: (context, provider, child) {
        return CustomListTile(
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          dense: true,
          minLeadingWidth: 0.0,
          minVerticalPadding: 5.1,
          leading: CustomNetworkImage(
            imageUrl: CustomIconUrl.careerpreficon,
            defaultIcon: Icons.work_outline,
            color: colors.subtitleTextColor,
          ),
          title: customText(
            title: 'Looking for Job',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: colors.subtitleTextColor,
          ),
          trailing: Transform.scale(
            alignment: Alignment.centerRight,
            scale: 0.6,
            child: Switch(
              thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                return Icon(
                  Icons.circle,
                  size: 22, // ⭐ Increase thumb size here
                  color: Colors.white,
                );
              }),
              padding: EdgeInsets.zero,
              value: provider.jobPrefEnable,
              activeColor: Constants.tongleColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (value) {
                if (!value) {
                  provider.updateJobPrefEnable(false);
                  provider.savePreferences(context, isFromDrawer: true);
                } else {
                  provider.updateJobPrefEnable(true);
                  onClose();
                  provider.savePreferences(context, isFromDrawer: true);
                  NavigationService.push(
                    const CareerPreference(isFromDrawer: true),
                  );
                  /* if (provider.hasExistingData) { //TODO:: Phle aisa tha and thn change hua as above
                    provider.updateJobPrefEnable(true);
                    onClose();
                    provider.savePreferences(context, isFromDrawer: true);
                  } else {
                    onClose();
                    NavigationService.push(
                      const CareerPreference(isFromDrawer: true),
                    );
                  } */
                }
              },
            ),
          ),
        );
      },
    );
  }
}
