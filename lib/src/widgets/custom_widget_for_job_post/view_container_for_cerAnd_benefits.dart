import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/widgets/container/custom_container_for_skills.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ViewCerBenefitsForJobPost extends StatelessWidget {
  final List<CertificateModel> job;
  final List<String> benefits;
  final String title;
  final ConListType type;

  const ViewCerBenefitsForJobPost({
    super.key,
    required this.job,
    required this.title,
    required this.type,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title: title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colors.headingColor,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: type == ConListType.Certificate
                ? job
                      .map(
                        (c) => CustomContainerFoeSkill(
                          isicon: false,
                          title:
                              "${c.value.toString()}${c.mandatory == 1 ? " (Mandate)" : ''}",
                        ),
                      )
                      .toList()
                : benefits
                      .map(
                        (e) => CustomContainerFoeSkill(
                          isicon: false,
                          title: e.toString(),
                        ),
                      )
                      .toList(),
          ),
        ],
      ),
    );
  }
}
