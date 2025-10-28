import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_education_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomEducationContainer extends StatelessWidget {
  final ProfileProvider provider;

  const CustomEducationContainer({super.key, required this.provider});
  @override
  Widget build(BuildContext context) {
    final profileData = provider.profile;

    /// Sorting
    profileData!.educationDetails?.sort((a, b) {
      var isPresentA = a.educationPeriod != null
          ? a.educationPeriod!.toLowerCase().contains('present')
          : false;
      var isPresentB = b.educationPeriod != null
          ? b.educationPeriod!.toLowerCase().contains('present')
          : false;
      if (isPresentA && !isPresentB) return -1;
      if (!isPresentA && isPresentB) return 1;

      var endDateA = a.educationPeriod != null
          ? int.tryParse(a.educationPeriod!.split(' - ').last) ?? 0
          : 0;
      var endDateB = b.educationPeriod != null
          ? int.tryParse(b.educationPeriod!.split(' - ').last) ?? 0
          : 0;
      return endDateB.compareTo(endDateA);
    });

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CustomNetworkImage(
                    imageUrl: CustomIconUrl.profileeducation,
                    defaultIcon: Icons.cast_for_education,
                  ),
                ),
                SizedBox(width: 5),
                const customText(
                  title: "Education",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Add Education
                      InkWell(
                        onTap: () {
                          provider.clearEducationForm();
                          provider.setShowEducationForm(true);
                          NavigationService.push(
                            ProfileEducationEdit(
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

                      /// Edit Education
                      if (provider.profile!.educationDetails!.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (provider.educationModel.length == 1) {
                              provider.editEducation(0);
                              provider.setShowEducationForm(true);
                              NavigationService.push(
                                ProfileEducationEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            } else {
                              provider.setShowEducationForm(false);
                              NavigationService.push(
                                ProfileEducationEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 14),
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
          (profileData.educationDetails == null ||
                  profileData.educationDetails!.isEmpty)
              ? Container(
                  padding: const EdgeInsets.only(left: 6, bottom: 10),
                  child: const Column(
                    children: [
                      customText(
                        title: "Add your education detail.",
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileData.educationDetails!.length,
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 2),
                      child: const Divider(thickness: 1.0),
                    );
                  },
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final data = profileData.educationDetails![index];
                    return Column(
                      children: [
                        CustomNewListTile(
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
                                (data.universityLogo != null &&
                                    data.universityLogo!.trim().isNotEmpty)
                                ? CustomNetworkImage(
                                    imageUrl:
                                        "${GlobalConstants.Image_url}${data.universityLogo}",
                                    defaultIcon: Icons.bungalow_outlined,
                                  )
                                : CustomNetworkImage(
                                    imageUrl: CustomIconUrl.universityicon,
                                    defaultIcon: Icons.school,
                                    color: Constants.subtitleclr,
                                  ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                title: data.degreeSpc ?? "",
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              customText(
                                title: data.university ?? "",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          subtitle: data.isCurrent == 1
                              ? customText(
                                  monst: true,
                                  title: "Pursuing",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.subtitleclr,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : data.passingYear != null
                              ? customText(
                                  monst: true,
                                  title:
                                      data.endMonth != null &&
                                          data.endMonth != "Unknown"
                                      ? '${MonthNameConverter.getShortMonthName(data.endMonth)} - ${data.passingYear.toString()}'
                                      : data.passingYear.toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.subtitleclr,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : customText(
                                  monst: true,
                                  title:
                                      data.startMonth != null &&
                                          data.startMonth != "Unknown"
                                      ? '${MonthNameConverter.getShortMonthName(data.startMonth)} - ${data.firstYear.toString()}'
                                      : data.firstYear.toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.subtitleclr,
                                  overflow: TextOverflow.ellipsis,
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
