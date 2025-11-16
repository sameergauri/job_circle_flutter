import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_edit/cv_parse_edit_skills.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CvParseSkills extends StatelessWidget {
  final SignupCreateUserProvider provider;

  const CvParseSkills({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header Row (Icon + Title + Action)
          Row(
            children: [
              Image.asset(CustomAssetUrl.skillicon, height: 20, width: 20),
              SizedBox(width: 5),
              const customText(
                title: "Skills",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// Add Button → SkillsMulti
                    if (provider.profileModel!.userRequest!.skills!.isEmpty)
                      InkWell(
                        onTap: () {
                          NavigationService.push(CvParseEditSkills());
                        },
                        child: const Icon(
                          Icons.add,
                          color: Constants.subtitleclr,
                          size: 20,
                        ),
                      ),

                    /// Edit Button → SkillsMulti
                    if (provider.profileModel!.userRequest!.skills!.isNotEmpty)
                      InkWell(
                        onTap: () {
                          NavigationService.push(CvParseEditSkills());
                        },
                        child: CustomNetworkImage(
                          imageUrl: CustomIconUrl.editicon,
                          defaultIcon: Icons.cast_for_education,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          /// 🔹 Empty State
          provider.profileModel!.userRequest!.skills == null ||
                  provider.profileModel!.userRequest!.skills!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 6, top: 10),
                  child: const customText(
                    title: "Add skills that best define your expertise.",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                  ),
                )
              /// 🔹 Skill Chips
              : Wrap(
                  spacing: 3,
                  runSpacing: 0.0,
                  children: provider.profileModel!.userRequest!.skills!.map((
                    skill,
                  ) {
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
                ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
