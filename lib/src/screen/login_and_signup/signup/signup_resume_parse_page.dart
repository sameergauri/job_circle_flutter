// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously
// ignore_for_file: todo

import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/basic_profile_detail.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/no_profile/basic_simple_detail_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class ResumeParsePage extends StatefulWidget {
  const ResumeParsePage({super.key});

  @override
  State<ResumeParsePage> createState() => _ResumeParsePageState();
}

class _ResumeParsePageState extends State<ResumeParsePage> {
  @override
  void initState() {
    super.initState();
    context.read<SignupCreateUserProvider>().startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Constants.white,
              appBar: AppBar(
                leadingWidth: 40,
                iconTheme: const IconThemeData(color: Colors.black87),
                backgroundColor: Constants.white,
                elevation: 0,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(
                      right: 20,
                      top: 12,
                      bottom: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: Constants.red,
                          ),
                          const SizedBox(width: 4),
                          customText(
                            title: provider.formattedTime,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Constants.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 1),
                      // Main Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText(
                            title: "Your Career Quest ",
                            fontSize: 26,
                            fontWeight: FontWeight
                                .w800, // 🎯 Ekdum sahi production standard weight
                            color: Constants.winecolor,
                          ),
                          customText(
                            title: "Begins",
                            fontSize: 26,
                            fontWeight: FontWeight
                                .w800, // 🎯 Ekdum sahi production standard weight
                            color: Constants.indigo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      customText(
                        title: "Let's level up your professional profile",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                      const Spacer(flex: 1),

                      // Onboarding Center Illustration
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.22,
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            CustomAssetUrl.onboardingicon,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),

                      // BUTTON 1: AI Resume Upload (Primary CTA)
                      customButton(
                        img: CustomIconUrl.ailogo,
                        title: "Upload Your Resume",
                        subtitle: "Our AI will build your profile in seconds",
                        onTab: () async {
                          provider.setLoading(true);
                          provider.setShowExperienceForm(false);
                          FileUploader fileUploader = FileUploader();
                          var data = await fileUploader.pickFileAndUpload(
                            needToUpload: true,
                            context,
                            allowedExt: ['pdf', 'doc', 'docx'],
                            folder: "resume",
                          );
                          if (data == null) {
                            provider.setLoading(false);
                            return;
                          }
                          await provider.fetchParseData(
                            File(data.file.path),
                            data.uploadedFileName!,
                            context,
                          );
                          Future.delayed(const Duration(milliseconds: 500), () {
                            provider.setLoading(false);
                          });
                        },
                        isPrimary: true,
                        clrone: Constants.diffblue,
                        clrtwo: Constants.indigo,
                        titleColor: Constants.white,
                        subtitleColor: Constants.white.withValues(alpha: 0.85),
                        iconcolor: Constants.white,
                      ),

                      // BUTTON 2: Manual Profile Creation
                      customButton(
                        img: CustomIconUrl.updatedetailicon,
                        title: "Build it yourself",
                        subtitle: "No resume? No problem. We'll guide you",
                        onTab: () {
                          provider.clearAll();
                          NavigationService.push(BasicProfileDetail());
                        },
                        isPrimary: false,
                        clrone: Constants.white,
                        clrtwo: Constants.white,
                        titleColor: Colors.black87,
                        subtitleColor: Constants.subtitleclr,
                        iconcolor: Constants.winecolor,
                      ),

                      // BUTTON 3: Guest / Fast Continue
                      customButton(
                        img: CustomIconUrl.without,
                        title: "Continue without profile",
                        subtitle: "Skip for now and jump right in",
                        onTab: () {
                          provider.clearAll();
                          NavigationService.push(SimpleBasicDetail());
                        },
                        isPrimary: false,
                        clrone: Colors.grey.shade50,
                        clrtwo: Colors.grey.shade50,
                        titleColor: Colors.black87,
                        subtitleColor: Constants.subtitleclr,
                        iconcolor: Colors.grey.shade700,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
            if (provider.isLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  // Optimized, Modern Custom Button Architecture
  Widget customButton({
    required String img,
    required String title,
    required String subtitle,
    required Function onTab,
    required bool isPrimary,
    required Color clrone,
    required Color clrtwo,
    required Color titleColor,
    required Color subtitleColor,
    required Color iconcolor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isPrimary
                ? Constants.indigo.withValues(alpha: 0.22)
                : Colors.grey.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTab(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [Constants.indigo, Constants.diffblue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isPrimary ? null : Colors.white,
              border: isPrimary
                  ? null
                  : Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Row(
              children: [
                // Icon Wrapper
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: CustomNetworkImage(
                    imageUrl: img,
                    defaultIcon: Icons.description_outlined,
                    height: 32,
                    width: 32,
                    color: iconcolor,
                  ),
                ),
                const SizedBox(width: 16),
                // Text Fields
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        title: title,
                        fontSize: 16,
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      customText(
                        title: subtitle,
                        fontSize: 12,
                        color: subtitleColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
                // Premium trailing arrow element
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isPrimary
                      ? Constants.white.withValues(alpha: 0.7)
                      : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
