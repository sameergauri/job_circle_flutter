// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:job_circle/components/custom_remark.dart';
import 'package:job_circle/components/custom_title_button.dart';
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
    return SizedBox(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          customText(
                            title: joiner.candidateName.toString(),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                         
                        ],
                      ),
                      
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
                ),
              ),
              if (joiner.partnerPayoutMode == "Special")
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0, // this is key
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                )
            ],
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 6, bottom: 6, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                  title: joiner.clientPayout.toString().replaceAll('.0', ''),
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
      ),
    );
  }
}
