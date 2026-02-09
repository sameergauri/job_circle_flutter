import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_award_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomAwardAchievment extends StatelessWidget {
  final ProfileProvider provider;

  const CustomAwardAchievment({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header Row (Icon + Title + Actions)
          Padding(
            padding: const EdgeInsets.only(bottom: 14, top: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CustomNetworkImage(
                    imageUrl: CustomIconUrl.awatdsIcon,
                    defaultIcon: Icons.celebration_outlined,
                    color: colors.subTitleColor,
                  ),
                ),
                SizedBox(width: 5),
                customText(
                  title: "Awards & Achievements",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.headingColor,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Add Button → CertificateEdit
                      InkWell(
                        onTap: () {
                          provider.clearAwardForm();
                          provider.setShowAwardForm(true);
                          NavigationService.push(
                            ProfileAwardEdit(fromEditOrAdd: FromEditOrAdd.add),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: colors.subTitleColor,
                          size: 20,
                        ),
                      ),

                      if (provider.profile!.awardsAndAchievements != null &&
                          provider.profile!.awardsAndAchievements!.isNotEmpty)
                        const SizedBox(width: 8),

                      /// Edit Button → CertificateList / CertificateEdit
                      if (provider.profile!.awardsAndAchievements != null &&
                          provider.profile!.awardsAndAchievements!.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (provider
                                    .profile!
                                    .awardsAndAchievements!
                                    .length !=
                                1) {
                              provider.setShowAwardForm(false);
                              NavigationService.push(
                                ProfileAwardEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            } else {
                              provider.editAward(0);
                              provider.setShowAwardForm(true);
                              NavigationService.push(
                                ProfileAwardEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: CustomNetworkImage(
                              imageUrl: CustomIconUrl.editicon,
                              defaultIcon: Icons.cast_for_education,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 If Empty → Show Message
          provider.profile!.awardsAndAchievements == null ||
                  provider.profile!.awardsAndAchievements!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 10),
                  child: const customText(
                    title: "Add your awards and achievements here.",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                  ),
                )
              :
                /// 🔹 If Not Empty → Show List
                ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 2),
                      child: SizedBox(),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.profile!.awardsAndAchievements!.length,
                  itemBuilder: (context, index) {
                    var data = provider.profile!.awardsAndAchievements![index];
                    return Column(
                      children: [
                        CustomNewListTile(
                          onTap: () {},
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          /* leading: Container(
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
                            child: CustomNetworkImage(
                              imageUrl: CustomIconUrl.awardConstantIcon,
                              defaultIcon: Icons.cast_for_education,
                            ),
                          ), */
                          title: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Bullet ko top par rakhne ke liye
                                  children: [
                                    // 1. Bullet Point (Alag Widget)
                                    Text(
                                      "• ", // Thoda space extra diya taki chipak na jaye
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: colors.headingColor,
                                      ),
                                    ),

                                    // 2. Main Content (Expanded me wrap kiya taki width restricted rahe)
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            // Part 1: Title (Bold & 14)
                                            TextSpan(
                                              text: "${data.title} : ",
                                              style: GoogleFonts.merriweather(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colors.headingColor,
                                              ),
                                            ),
                                            // Part 2: Description (Normal & 12)
                                            TextSpan(
                                              text: data.description,
                                              style: GoogleFonts.merriweather(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: colors.subTitleColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4, // Text limit
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        /* if (data.description != null &&
                            data.description!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(4),
                            margin: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Constants.lightdull,
                            ),
                            child: ExpandableTextWidget(
                              initialMaxLines: 5,
                              text:
                                  BulletFormatterFromFullStop.formatWithBullets(
                                    data.description!,
                                  ),
                            ),
                          ), */
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }
}
