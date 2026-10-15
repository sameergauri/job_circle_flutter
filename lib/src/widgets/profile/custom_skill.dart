import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_skills_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class SkillsSection extends StatelessWidget {
  final ProfileProvider provider;

  const SkillsSection({super.key, required this.provider});

  /// Merges profile-level skills with every experience's own skills
  /// (case-insensitive dedupe), so the chip list reflects all of them.
  List<String> _mergedSkills() {
    final merged = <String>[];
    final seenLower = <String>{};
    void addSkill(String skill) {
      final trimmed = skill.trim();
      if (trimmed.isEmpty) return;
      if (seenLower.add(trimmed.toLowerCase())) {
        merged.add(trimmed);
      }
    }

    for (final skill in provider.profile!.allSkills ?? <String>[]) {
      addSkill(skill);
    }
    for (final exp in provider.profile!.experiences ?? <Experience>[]) {
      for (final skill in exp.skillsExp ?? <String>[]) {
        addSkill(skill);
      }
    }
    return merged;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skills = _mergedSkills();
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header Row (Icon + Title + Action)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Image.asset(
                  CustomAssetUrl.skillicon,
                  height: 20,
                  width: 20,
                  color: colors.subTitleColor,
                ),
              ),
              SizedBox(width: 5),
              customText(
                title: "Skills",
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: colors.headingColor,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// Add Button → SkillsMulti
                    if (provider.profile!.allSkills!.isEmpty)
                      InkWell(
                        onTap: () {
                          NavigationService.push(ProfileAddSkill(
                            skills: skills,
                          ));
                        },
                        child: Icon(
                          Icons.add,
                          color: colors.subTitleColor,
                          size: 20,
                        ),
                      ),

                    /// Edit Button → SkillsMulti
                    if (provider.profile!.allSkills!.isNotEmpty)
                      InkWell(
                        onTap: () {
                          NavigationService.push(ProfileAddSkill(
                            skills: skills,
                          ));
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
          skills.isEmpty
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
                  children: skills.map((skill) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10, right: 4, left: 5),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.bottomsheerCard1Color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: customText(
                        title: skill,
                        color: colors.headingColor,
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
