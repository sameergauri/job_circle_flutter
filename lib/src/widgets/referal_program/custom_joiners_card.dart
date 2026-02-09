// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/referal_program/joiners_model.dart';
import 'package:job_circle/src/utils/salary_round_off.dart';
import 'package:job_circle/src/widgets/container/custom_remark_coontainer.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/referal_program/custom_title_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomJoinerCard extends StatelessWidget {
  final JoinerData joiner;
  final BuildContext context;

  const CustomJoinerCard({
    super.key,
    required this.joiner,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                backgroundColor: colors.circlebgColor,
                child: customText(
                  title: joiner.candidateName!.substring(0, 1),
                  color: Constants.subtitleclr,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customText(
                          title: joiner.candidateName.toString().replaceAll(
                            ',',
                            '',
                          ),
                          fontWeight: FontWeight.bold,
                          color: colors.headingColor,
                          fontSize: 13,
                        ),
                        if (joiner.partnerPayoutMode == "Special" ||
                            joiner.partnerPayoutMode == "SPECIAL")
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: CustomNetworkImage(
                              height: 15,
                              color: Constants.green,
                              imageUrl: CustomIconUrl.lighticon,
                              defaultIcon: Icons.electric_bolt_rounded,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    customText(
                      title: "${joiner.process} || ${joiner.designation}",
                      color: colors.subTitleColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.only(top: 6, bottom: 6, right: 8, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconTitleButton(
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/128/14644/14644423.png",
                onTap: () {},
                title: joiner.companyShortName.toString(),
              ),
              CustomIconTitleButton(
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/128/16774/16774139.png",
                onTap: () {},
                title: joiner.dateOfJoining.toString(),
              ),
              CustomIconTitleButton(
                height: 20.0,
                width: 25.0,
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/128/9798/9798241.png",
                onTap: () {},
                title: SalaryRoundOff.customRoundOff(
                  joiner.partnerPayout.toString(),
                ),
              ),
            ],
          ),
        ),
        if (joiner.attrStatus == "Not Payable")
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: CustomRemarkConatiner(
              subtitle: joiner.remark.toString(),
              valueColor: colors.subTitleColor!,
              title: "Remark",
            ),
          ),
      ],
    );
  }
}
