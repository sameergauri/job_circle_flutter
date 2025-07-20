// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:job_circle/components/custom_remark.dart';
import 'package:job_circle/components/custom_title_button.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/constants/salary_round_off.dart';
import 'package:job_circle/models/view_and_generate_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                backgroundColor: Constants.borderColor,
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
                          title: joiner.candidateName
                              .toString()
                              .replaceAll(',', ''),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        if (joiner.partnerPayoutMode == "Special"||
                            joiner.partnerPayoutMode == "SPECIAL")
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: CustomNetworkImage(
                                height: 15,
                                color: Constants.green,
                                imageUrl:
                                    "https://cdn-icons-png.flaticon.com/128/6853/6853811.png",
                                defaultIcon: Icons.electric_bolt_rounded),
                          )
                      ],
                    ),
                    const SizedBox(height: 2),
                    customTextForWeather(
                      title: "${joiner.process} || ${joiner.designation}",
                      color: Constants.subtitleclr,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        /* ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          leading: CircleAvatar(
            backgroundColor: Constants.borderColor,
            child: customText(
              title: joiner.candidateName!.substring(0, 1),
              color: Constants.subtitleclr,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customText(
                title: joiner.candidateName.toString().replaceAll(',', ''),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              if (joiner.partnerPayoutMode == "Special")
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: CustomNetworkImage(
                      height: 15,
                      color: Constants.green,
                      imageUrl:
                          "https://cdn-icons-png.flaticon.com/128/6853/6853811.png",
                      defaultIcon: Icons.electric_bolt_rounded),
                )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              customTextForWeather(
                title: "${joiner.process} || ${joiner.designation}",
                color: Constants.subtitleclr,
              ),
            ],
          ),
        ), */
        Container(
          padding: const EdgeInsets.only(top: 6, bottom: 6, right: 8, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconTitleButton(
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/128/14644/14644423.png",
                  onTap: () {},
                  title: joiner.companyShortName.toString()),
              CustomIconTitleButton(
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/128/16774/16774139.png",
                  onTap: () {},
                  title: joiner.dateOfJoining.toString()),
              CustomIconTitleButton(
                height: 20.0,
                width: 25.0,
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/128/9798/9798241.png",
                onTap: () {},
                title: SalaryRoundOff.customRoundOff(
                    joiner.partnerPayout.toString()),
              ),
            ],
          ),
        ),
        if (joiner.attrStatus == "Not Payable")
          CustomRemarkConatiner(
            subtitle: joiner.companyName.toString(),
            valueColor: Constants.subtitleclr,
            title: "Remark",
          ),
      ],
    );
  }
}
