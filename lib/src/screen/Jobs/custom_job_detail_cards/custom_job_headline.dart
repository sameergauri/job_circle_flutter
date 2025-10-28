// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/container/custom_container_for_skills.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomJobHeadline extends StatelessWidget {
  final String experience;
  final String salary;
  final String location;
  final String empType;
  final String noVacancy;
  final String companyIcon;
  final String? jobHeadline;

  const CustomJobHeadline({
    super.key,
    required this.experience,
    required this.salary,
    required this.location,
    required this.empType,
    required this.noVacancy,
    required this.companyIcon,
    this.jobHeadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        //p: 4,
        bottom: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (jobHeadline != null)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              trailing:
                  companyIcon != null &&
                      companyIcon != "" &&
                      companyIcon != "null"
                  ? CustomNetworkImage(
                      imageUrl: "${GlobalConstants.Image_url}$companyIcon",
                      height: 50,
                      width: 50,
                      defaultIcon: Icons.home,
                    )
                  : Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Constants.lightdull,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.network(
                        CustomIconUrl.companyicon,
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                    ),
              title: customText(
                title: jobHeadline.toString(),
                fontWeight: FontWeight.w700,
                fontSize: jobHeadline!.length < 30 ? 16 : 14,
              ),
              // subtitle: const customText(title: ""),
            ),
          _buildInfoRow(
            Icons.work_outline_outlined,
            formatExperience(experience.replaceAll("Years", 'yrs')),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.currency_rupee, salary),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.location_on_outlined, location),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              const CustomContainerFoeSkill(
                isicon: true,
                title: "Verified",
                icon: Icons.verified,
              ),
              CustomContainerFoeSkill(
                isicon: true,
                title: empType,
                icon: Icons.work_outline_outlined,
              ),
              CustomContainerFoeSkill(
                isicon: false,
                title: "$noVacancy Vacancies",
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatExperience(String exp) {
    final regex = RegExp(r'^(\d+)\s*-\s*& above yrs$');
    final match = regex.firstMatch(exp);

    if (exp.contains("6 months & Above")) {
      return "6 months and above";
    }

    if (match != null) {
      final number = match.group(1);
      return "${number}yrs and above";
    }
    return exp; // default return if pattern doesn't match
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Constants.subtitleclr),
        const SizedBox(width: 5),
        Expanded(
          child: customText(title: text, fontSize: 12, color: Constants.black),
        ),
      ],
    );
  }
}
