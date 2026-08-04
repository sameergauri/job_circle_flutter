import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class DigiLockeThree extends StatelessWidget {
  const DigiLockeThree({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Title
                    customText(
                      title: "How verifying your identity works",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.headingColor,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Info Card
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
                          _buildBullet(
                            "To start the process, you'll be prompted to sign into your DigiLocker account",
                            colors,
                          ),
                          const SizedBox(height: 14),
                          _buildBullet(
                            "Your Aadhaar number must be linked to your DigiLocker account",
                            colors,
                          ),
                          const SizedBox(height: 14),
                          _buildBullet(
                            "DigiLocker will ask for your permission to share the following with Job Circle: your full name, date of birth, gender, phone number, and photo, as well as a unique identifier and a confirmation of whether your DigiLocker account is linked to an Aadhaar number",
                            colors,
                          ),
                          const SizedBox(height: 14),
                          _buildBullet(
                            "Once you consent to this sharing, Job Circle will ask you for a selfie",
                            colors,
                          ),
                          const SizedBox(height: 14),
                          _buildBullet(
                            "If your DigiLocker photo matches your selfie, and your name and birth year match your Job Circle profile information, you'll be able to display a [verification/badge] on your Job Circle profile",
                            colors,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(String text, AppColors colors) {
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
