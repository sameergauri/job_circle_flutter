import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_basic_info_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomLanguageKnownContainer extends StatelessWidget {
  final ProfileProvider profileProvider;

  const CustomLanguageKnownContainer({
    super.key,
    required this.profileProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
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
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CustomNetworkImage(
                  imageUrl: CustomIconUrl.languageicon,
                  defaultIcon: Icons.language,
                ),
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
                        if (profileProvider.profile!.languagesKnown!.isEmpty)
                          InkWell(
                            onTap: () {
                              profileProvider.assignDataFromModelToController();
                              NavigationService.push(ProfileBasicInforEdit());
                            },
                            child: const Icon(
                              Icons.add,
                              color: Constants.subtitleclr,
                              size: 20,
                            ),
                          ),

                        /// 🔹 Edit Button if languages exist
                        if (profileProvider.profile!.languagesKnown != null &&
                            profileProvider.profile!.languagesKnown!.isNotEmpty)
                          InkWell(
                            onTap: () {
                              profileProvider.assignDataFromModelToController();
                              NavigationService.push(ProfileBasicInforEdit());
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
          if (profileProvider.profile!.languagesKnown != null &&
              profileProvider.profile!.languagesKnown!.isNotEmpty)
            Wrap(
              spacing: 3,
              runSpacing: 0.0,
              children: profileProvider.profile!.languagesKnown!
                  .asMap()
                  .entries
                  .map((entry) {
                    final skill = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(top: 10, right: 4, left: 5),
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
                  })
                  .toList(),
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
