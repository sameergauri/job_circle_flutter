// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Billing/ui/banking_detal.dart';
import 'package:job_circle/screens/Billing/ui/payment_status_home_page.dart';
import 'package:job_circle/screens/Billing/ui/view_and_generate_invoice.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends ConsumerWidget {
  final VoidCallback onClose;
  // Callback to close drawer

  const CustomDrawer({
    required this.onClose,
    super.key,
  });
  String cleanedLocation(String userLocation) {
    // Split by comma, trim each part, remove duplicates, and join back
    final uniqueParts =
        userLocation.split(',').map((e) => e.trim()).toSet().toList();

    return uniqueParts.reversed.join(', ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user data from the provider
    final userData = ref.watch(jobListProvider.notifier).userData;
    final userName = userData?.userName ?? "Guest";
    final userLocation = userData?.userLocation ?? "Unknown Location";
    final userProfileImage = userData?.userProfilePic;
    final userGender = userData?.userGender ?? ""; // Assuming this field exists
    return Container(
      width: 250, // Set width of the drawer
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 10),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 150,
            color: Constants.borderColor,
            padding: const EdgeInsets.only(
                top: kTextTabBarHeight,
                left: kTextTabBarHeight / 2,
                bottom: 10),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    onClose();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserProfile()));
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants.bgColorWhite,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Constants.lightdull,
                      backgroundImage: userProfileImage != null &&
                              userProfileImage != " " &&
                              userProfileImage != ''
                          ? NetworkImage(
                              "${GlobalConstants.Image_url}$userProfileImage")
                          : userGender == "Male"
                              ? const AssetImage("assets/images/leadmale.png")
                                  as ImageProvider
                              : const AssetImage("assets/images/leadfemal.png")
                                  as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                customTextForWeather(
                  title: userName,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                customTextForWeather(
                    title: cleanedLocation(userLocation), fontSize: 12),
              ],
            ),
          ),
          ExpansionTile(
            dense: true,
            textColor: Constants.darkBlue,

            iconColor: Constants.darkBlue,
            collapsedIconColor: Constants.darkBlue,
            //  collapsedTextColor: Constants.darkBlue,
            //  collapsedIconColor: Constants.black,
            leading: Image.network(
              'https://assets.api.uizard.io/api/cdn/stream/768b2a61-82db-4e34-b49b-1e8a12feea17.png',
              height: 20,
              color: Constants.darkBlue,
            ),
            title: const customTextForWeather(
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
                leading: Image.network(
                  'https://assets.api.uizard.io/api/cdn/stream/5fdfd683-2909-4188-b2e4-2f02ad6e7f91.png',
                  height: 20,
                  color: Colors.black,
                ),
                title: const customTextForWeather(
                    title: "Joiner's",
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
                onTap: () {
                  /*    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TempPage())); */
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateInvoice(),
                      ));
                  onClose();
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth: 0.0,
                minVerticalPadding: 5.1,
                leading: Image.network(
                  'https://assets.api.uizard.io/api/cdn/stream/e512a1a4-0c69-49d2-a063-fd4f83727d79.png',
                  height: 20,
                  color: Colors.black,
                ),
                title: const customTextForWeather(
                    title: 'Payment Tracker',
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
                onTap: () {
                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TempPage())); */
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentStatusHomePage()));
                  onClose();
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth: 0.0,
                minVerticalPadding: 5.1,
                leading: Image.network(
                  'https://assets.api.uizard.io/api/cdn/stream/68a2443e-6941-40d9-8948-f61e8a319a72.png',
                  height: 20,
                  color: Colors.black,
                ),
                title: const customTextForWeather(
                    title: 'My Banking Detail',
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BankingDetals(
                                name: userName,
                                profilePic: userProfileImage.toString(),
                                gender: userGender,
                              )));
                  onClose();
                },
              ),
            ],
          ),
          ListTile(
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: Image.network(
              'https://assets.api.uizard.io/api/cdn/stream/d19cf674-b262-4aa5-86b5-32d1942f8966.png',
              //color: Colors.black,
              height: 20,
            ),
            title: const customTextForWeather(
                title: 'Write to us',
                fontSize: 12,
                fontWeight: FontWeight.normal),
            onTap: () async {
              await launchUrl(Uri.parse("mailto:support@jobcircle.co.in?"));
              onClose();
            },
          ),
          /*   ListTile(  //TODO: Career Preference
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: const Icon(Icons.perm_data_setting_outlined),
            title: const customText(
                title: 'Career Preference',
                fontSize: 12,
                fontWeight: FontWeight.normal),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CareerPreferrence()));
              onClose();
            },
          ), */
          ListTile(
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: Image.asset(
              "assets/images/share.png",
              height: 18,
            ),
            title: const customTextForWeather(
                title: 'Share App',
                fontSize: 12,
                fontWeight: FontWeight.normal),
            onTap: () {
              share();
              onClose();
            },
          ),
          ListTile(
              dense: true,
              minLeadingWidth: 0.0,
              minVerticalPadding: 5.1,
              leading: Image.asset(
                'assets/images/logout.png',
                height: 20,
              ),
              title: const customTextForWeather(
                  title: 'LogOut', fontSize: 12, fontWeight: FontWeight.normal),
              onTap: () async {
                JobPostApiService jobPostApiService = JobPostApiService();
                final prefs = await SharedPreferences.getInstance();

                // Clear preferences
                await prefs.clear();
                await prefs.setString('selectedLocation', "");

                // Clear session and cache
                await AppUtils.clearSession();
                await jobPostApiService.clearCache();

                // Safely navigate to login screen
                if (context.mounted) {
                  await Navigator.pushNamedAndRemoveUntil(
                    context,
                    ERoute.login.value,
                    (Route<dynamic> route) => false,
                  );
                }

                onClose();
              }),
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
                        final url = Uri.parse(
                            "https://www.linkedin.com/company/job-circle/");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Image.asset(
                            "assets/images/linkdin.png",
                            height: 18,
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                            "https://whatsapp.com/channel/0029VaWd8KB7NoZwpZQLCN35");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Image.asset(
                            "assets/images/whatsapp.png",
                            height: 18,
                            color: Colors.green,
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                            "https://www.instagram.com/jobcircleofficial?igsh=MTZzbXJ4dGJjaGt3ag==");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Image.asset(
                            "assets/images/instagram.png",
                            height: 18,
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                            "https://www.facebook.com/JobCircleOfficial");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Image.asset(
                            "assets/images/facebook.png",
                            height: 18,
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: customTextForWeather(
                    title: 'Version 1.0.27',
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Job circle App',
        text: 'Install jobcircle app',
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.job_circle_flutter',
        chooserTitle: 'Example Chooser Title');
  }
}
