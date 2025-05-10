import 'package:flutter/material.dart';
import 'package:job_circle/constants/job_detail/custom_container_for_skill.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class CustomJobHeadline extends StatelessWidget {
  final String experience;
  final String salary;
  final String location;
  final String empType;
  final String noVacancy;
  final String? jobHeadline;

  const CustomJobHeadline(
      {super.key,
      required this.experience,
      required this.salary,
      required this.location,
      required this.empType,
      required this.noVacancy,
      this.jobHeadline});

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
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: customTextForWeather(
                title: jobHeadline.toString(),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          _buildInfoRow(Icons.work_outline_outlined, experience),
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
                  icon: Icons.work_outline_outlined),
              CustomContainerFoeSkill(
                  isicon: false, title: "$noVacancy Vacancies"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Constants.subtitleclr,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: customTextForWeather(
            title: text,
            fontSize: 12,
            color: Constants.black,
          ),
        ),
      ],
    );
  }
}
