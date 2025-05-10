import 'package:flutter/material.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class ReferralProgramCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const ReferralProgramCard({
    super.key,
    this.title = "Refer and Earn",
    this.subtitle = "Referral Program",
    this.imageUrl = "https://cdn-icons-png.flaticon.com/256/14356/14356000.png",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextForWeather(
            title: title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Constants.borderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextForWeather(
                  title: subtitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Constants.darkBlue,
                ),
                Image.network(
                  imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
