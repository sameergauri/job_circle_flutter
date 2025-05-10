import 'package:flutter/material.dart';
import 'package:job_circle/constants/job_detail/custom_container_for_skill.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';

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
    return Container(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextForWeather(
            title: title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
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
