import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/screen/digi_locker/digilocker_two.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class DigiLockerOne extends StatelessWidget {
  final ProfileModel profile;

  const DigiLockerOne({super.key, required this.profile});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Profile Image with Badge
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundColor: Constants.borderColor,
                    radius: 50,
                    backgroundImage:
                        profile.profilePic != null &&
                            profile.profilePic != " " &&
                            profile.profilePic != 'null' &&
                            profile.profilePic != ""
                        ? Image.network(
                            "${GlobalConstants.Image_url}${profile.profilePic}",
                            fit: BoxFit.fill,
                          ).image
                        : Image.asset(
                            profile.gender != "Male"
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
                title: "Get verified. Get noticed.",
                textAlign: TextAlign.center,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.headingColor,
              ),

              const SizedBox(height: 28),

              // Benefits List
              _buildBenefitItem("60% more profile views on average", colors),
              const SizedBox(height: 14),
              _buildBenefitItem("Protection against impersonation", colors),
              const SizedBox(height: 14),
              _buildBenefitItem("Expedited customer support", colors),

              const SizedBox(height: 40),

              // Verify Card
              InkWell(
                onTap: () {
                  NavigationService.push(
                    DigiLockerTwo(
                      gender: profile.gender ?? "",
                      user_photo: profile.profilePic ?? "",
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: colors.bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: colors.headingColor!.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.badge_outlined,
                          color: Color(0xFF2E7D32),
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              title: "Verify your identity",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colors.headingColor,
                            ),
                            SizedBox(height: 4),
                            customText(
                              title: "Using government ID",
                              fontSize: 13,
                              color: colors.subtitleTextColor,
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3F2FD),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF1976D2),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, AppColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: customText(
            title: text,
            fontSize: 14,
            color: colors.headingColor,
          ),
        ),
      ],
    );
  }
}
