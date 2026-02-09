import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/container/custom_container_for_skills.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ViewContainerForCerAndBenefits extends StatelessWidget {
  final List<String> stringList;
  final String title;

  const ViewContainerForCerAndBenefits({
    super.key,
    required this.stringList,
    required this.title,
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
            children: stringList
                .map((e) => CustomContainerFoeSkill(title: e, isicon: false))
                .toList(),
          ),
        ],
      ),
    );
  }
}
