// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_edit/basic_info_edit.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CvParseLanguage extends StatelessWidget {
  final UserRequest profileData;
  final SignupCreateUserProvider provider;

  const CvParseLanguage({
    Key? key,
    required this.profileData,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header Row
          Row(
            children: [
              CustomNetworkImage(
                imageUrl: CustomIconUrl.languageicon,
                defaultIcon: Icons.language,
              ),
              SizedBox(width: 5),
              const customText(
                title: "Language Known",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        /// 🔹 Add Button if no language found
                        if (profileData.languages == null)
                          InkWell(
                            onTap: () {
                              NavigationService.push(EditBasicInfo());
                            },
                            child: const Icon(
                              Icons.add,
                              color: Constants.subtitleclr,
                              size: 20,
                            ),
                          ),

                        /// 🔹 Edit Button if languages exist
                        if (profileData.languages != null)
                          InkWell(
                            onTap: () {
                              NavigationService.push(EditBasicInfo());
                            },
                            child: CustomNetworkImage(
                              imageUrl: CustomIconUrl.editicon,
                              defaultIcon: Icons.edit,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// 🔹 Languages list
          if (profileData.languages != null)
            Wrap(
              spacing: 3,
              runSpacing: 0.0,
              children: profileData.languages!.asMap().entries.map((entry) {
                final skill = entry.value;
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.lightdull,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: customText(
                    title: skill,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            )
          else
            Container(
              padding: const EdgeInsets.only(left: 6, top: 10),
              child: const customText(
                title: "Add languages you know.",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}
