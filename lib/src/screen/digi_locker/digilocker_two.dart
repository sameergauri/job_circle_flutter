import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/screen/digi_locker/digilocker_three.dart';
import 'package:job_circle/src/services/digi_locker/digi_locker_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class DigiLockerTwo extends StatelessWidget {
  final String user_photo;
  final String gender;
  const DigiLockerTwo({
    super.key,
    required this.user_photo,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: colors.appbarColor,
        elevation: 0,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: colors.headingColor),
        title: customText(
          title: "Verification",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.headingColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Profile Image with Badge
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Constants.borderColor,
                          radius: 50,
                          backgroundImage:
                              user_photo != " " &&
                                  user_photo != 'null' &&
                                  user_photo != ""
                              ? Image.network(
                                  "${GlobalConstants.Image_url}$user_photo",
                                  fit: BoxFit.fill,
                                ).image
                              : Image.asset(
                                  gender != "Male"
                                      ? CustomAssetUrl.femalicon
                                      : CustomAssetUrl.maleicon,
                                  fit: BoxFit.fill,
                                ).image,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Color(0xFF4CAF50),
                            size: 22,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Title
                    customText(
                      title: "Verify your identity",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.headingColor,
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    customText(
                      title:
                          "Verified members get 60% more profile views on average.",
                      fontSize: 14,
                      color: colors.headingColor,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 28),

                    // Steps Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            title: "Verify in just a few steps:",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colors.headingColor,
                          ),
                          const SizedBox(height: 14),
                          _buildStep(
                            "Sign in to DigiLocker and consent to share limited DigiLocker profile data with Job Circle",
                            colors,
                          ),
                          const SizedBox(height: 12),
                          _buildStep(
                            "Take a live selfie for Job Circle to match with your DigiLocker profile data",
                            colors,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // How does this work?
                    TextButton(
                      onPressed: () {
                        NavigationService.push(DigiLockeThree());
                      },
                      child: customText(
                        title: "How does this work?",
                        fontSize: 15,
                        color: colors.darkBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  customText(
                    title:
                        "You must be at least 18 years old to complete this process.",
                    fontSize: 12,
                    color: colors.subTitleColor,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        startDigiLockerVerification(
                          userId: SharedPrefsHelper.getInt(
                            ESharedPreferences.user_id,
                          ), // aapka actual userId
                          context: context,
                        );
                        NavigationService.pop();
                        NavigationService.pop();
                        NavigationService.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.darkBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const customText(
                        title: "Verify with Digilocker",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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

  Widget _buildStep(String text, AppColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title: "•  ", fontSize: 15, color: colors.headingColor),
        Expanded(
          child: customText(
            title: text,
            fontSize: 12,
            color: colors.headingColor,
          ),
        ),
      ],
    );
  }
}
