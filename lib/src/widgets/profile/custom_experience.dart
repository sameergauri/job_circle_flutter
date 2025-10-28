import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/add_bullet_point.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_experience_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/expandable_text_widget.dart';

class CustomExperienceContainer extends StatelessWidget {
  final ProfileProvider profileProvider;

  const CustomExperienceContainer({super.key, required this.profileProvider});
  @override
  Widget build(BuildContext context) {
    final profileData = profileProvider.profile;

    /// Sorting logic for experiences
    profileData!.experiences?.sort((a, b) {
      var workingPeriodA = a.workingPeriod?.toLowerCase() ?? "";
      var workingPeriodB = b.workingPeriod?.toLowerCase() ?? "";
      var isPresentA = workingPeriodA.contains('present');
      var isPresentB = workingPeriodB.contains('present');

      if (isPresentA && !isPresentB) return -1;
      if (!isPresentA && isPresentB) return 1;

      int extractYear(String period) {
        var parts = period.split(' - ');
        if (parts.length < 2) return 0;
        var lastPart = parts.last;
        var yearMatch = RegExp(r'\b\d{4}\b').firstMatch(lastPart);
        return yearMatch != null ? int.parse(yearMatch.group(0)!) : 0;
      }

      var endDateA = extractYear(a.workingPeriod ?? "");
      var endDateB = extractYear(b.workingPeriod ?? "");
      return endDateB.compareTo(endDateA);
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Image.asset(
                    CustomAssetUrl.jobicon,
                    height: 20,
                    width: 20,
                  ),
                ),
                SizedBox(width: 5),
                const customText(
                  title: "Experience",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Add Experience
                      InkWell(
                        onTap: () {
                          profileProvider.clearExperienceForm();
                          profileProvider.setShowExperienceForm(true);
                          NavigationService.push(
                            ProfileExperienceEdit(
                              fromEditOrAdd: FromEditOrAdd.add,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          color: Constants.subtitleclr,
                          size: 20,
                        ),
                      ),

                      /// Edit Experience
                      if (profileProvider.profile!.experiences!.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (profileProvider.profile!.experiences!.length ==
                                1) {
                              profileProvider.editExperience(0);
                              profileProvider.setShowExperienceForm(true);
                              NavigationService.push(
                                ProfileExperienceEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            } else {
                              profileProvider.setShowExperienceForm(false);
                              NavigationService.push(
                                ProfileExperienceEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 14),
                            child: CustomNetworkImage(
                              imageUrl: CustomIconUrl.editicon,
                              defaultIcon: Icons.edit,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Body
          (profileData.experiences == null || profileData.experiences!.isEmpty)
              ? Container(
                  padding: const EdgeInsets.only(left: 6, bottom: 10),
                  child: const Column(
                    children: [
                      customText(
                        title: "Fresher.",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 2),
                      child: const Divider(thickness: 1.0),
                    );
                  },
                  itemCount: profileData.experiences!.length,
                  itemBuilder: (context, index) {
                    final data = profileData.experiences![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Experience Tile
                        CustomNewListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Constants.lightdull),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 50,
                            height: 50,
                            child:
                                (data.companyLogo != null &&
                                    data.companyLogo!.isNotEmpty)
                                ? CustomNetworkImage(
                                    imageUrl:
                                        "${GlobalConstants.Image_url}${data.companyLogo}",
                                    defaultIcon: Icons.home,
                                  )
                                : CustomNetworkImage(
                                    imageUrl: CustomIconUrl.companyicon,
                                    defaultIcon: Icons.business,
                                    color: Constants.subtitleclr,
                                  ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                title: data.jobTitle ?? "",
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              customText(
                                title:
                                    "${data.companyName ?? ""} - ${data.empType ?? ""}",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                title:
                                    data.workingPeriod
                                        ?.split(',')
                                        .map((part) => part.trim())
                                        .toList()
                                        .asMap()
                                        .map(
                                          (i, part) => i == 1
                                              ? MapEntry(i, '($part)')
                                              : MapEntry(i, part),
                                        )
                                        .values
                                        .join(' ')
                                        .replaceAll('months', 'mos') ??
                                    "",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Constants.subtitleclr,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (data.jobLocation != null &&
                                  data.jobLocation!.isNotEmpty &&
                                  data.jobLocation != "")
                                customText(
                                  title:
                                      '${data.jobLocation ?? ""} • ${data.workType!}',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.subtitleclr,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (data.jobLocation == null ||
                                  data.jobLocation!.isEmpty ||
                                  data.jobLocation == "null" ||
                                  data.jobLocation == "")
                                InkWell(
                                  onTap: () {
                                    profileProvider.editExperience(index);
                                    profileProvider.setShowExperienceForm(true);
                                    NavigationService.push(
                                      ProfileExperienceEdit(
                                        fromEditOrAdd: FromEditOrAdd.edit,
                                      ),
                                    );
                                  },
                                  child: customText(
                                    title: "Add Work Mode",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Constants.darkBlue,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        /// Job Role (Expandable)
                        if (data.jobRole != null &&
                            data.jobRole!.isNotEmpty &&
                            data.jobRole != "")
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Constants.lightdull,
                            ),
                            child: ExpandableTextWidget(
                              initialMaxLines: 5,
                              text: BulletFormatter.formatWithBullets(
                                data.jobRole!,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }
}
