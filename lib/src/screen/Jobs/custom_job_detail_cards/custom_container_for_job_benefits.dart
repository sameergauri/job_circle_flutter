import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/widgets/container/custom_container_for_skills.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ViewContainerForCerAndBenefits extends StatelessWidget {
  final JobDetailPageModel job;
  final String title;
  final ConListType type;

  const ViewContainerForCerAndBenefits({
    super.key,
    required this.job,
    required this.title,
    required this.type,
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
                ? job.certifications!
                      .map(
                        (c) => CustomContainerFoeSkill(
                          isicon: false,
                          title:
                              "${c.value.toString()}${c.mandatory == 1 ? " (Mandate)" : ''}",
                        ),
                      )
                      .toList()
                : job.jobBenefits!
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
