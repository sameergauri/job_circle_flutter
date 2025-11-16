import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/add_space_between.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_edit/experience_list_edit.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/add_bullet_point.dart';
import 'package:job_circle/src/utils/date_formater.dart';
import 'package:job_circle/src/utils/duration_calculator.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/expandable_text_widget.dart';

class CvParseExperience extends StatelessWidget {
  final SignupCreateUserProvider provider;
  const CvParseExperience({super.key, required this.provider});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Padding(
            padding: const EdgeInsets.only(bottom: 4, top: 5),
            child: Row(
              children: [
                Image.asset(CustomAssetUrl.jobicon, height: 20, width: 20),
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
                          provider.clearExperienceForm();
                          provider.setShowExperienceForm(true);
                          NavigationService.push(
                            ExperienceListEdit(
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
                      if (provider.experiencesModel.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (provider.experiencesModel.length == 1) {
                              provider.editExperience(0);
                              provider.setShowExperienceForm(true);
                              NavigationService.push(
                                ExperienceListEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            } else {
                              provider.setShowExperienceForm(false);
                              NavigationService.push(
                                ExperienceListEdit(
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
          (provider.experiencesModel.isEmpty)
              ? Container(
                  padding: const EdgeInsets.only(left: 5),
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
                  padding: EdgeInsets.only(top: 5),
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 2),
                      child: const Divider(thickness: 1.0),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.experiencesModel.length,
                  itemBuilder: (context, index) {
                    final data = provider.experiencesModel[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: CustomNewListTile(
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Constants.lightdull),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const CustomNetworkImage(
                                height: 24,
                                color: Constants.subtitleclr,
                                imageUrl: CustomIconUrl.companyicon,
                                defaultIcon: Icons.home_work_outlined,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
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
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      customText(
                                        title: data.isCurrent == 1
                                            ? "${CvParseExpDateFormatter.formatDate(data.joiningDate.toString(),true)} - Present"
                                            : "${CvParseExpDateFormatter.formatDate(data.joiningDate.toString(),true)} - ${CvParseExpDateFormatter.formatDate(data.lastWorkingDate,true)}",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Constants.subtitleclr,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (data.joiningDate != null)
                                        customText(
                                          title:
                                              ' ${CvDurationCalculator.calculateDuration(data.joiningDate!, data.lastWorkingDate)}',
                                          fontWeight: FontWeight.w500,
                                          color: Constants.subtitleclr,
                                        ),
                                    ],
                                  ),
                                  if (data.jobLocation != null)
                                    customText(
                                      title: AddSpaceBetween.capitalizeWords(
                                        data.jobLocation.toString(),
                                      ),
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
                                        provider.editExperience(index);
                                        provider.setShowExperienceForm(true);
                                        NavigationService.push(
                                          ExperienceListEdit(
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
                          ),
                        ),

                        /// Job Role (Expandable)
                        if (data.jobRole != null && data.jobRole!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(4),
                            margin: EdgeInsets.only(top: 4),
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

  String cleanLocation(String location) {
    List<String> parts = location.split(",").map((e) => e.trim()).toList();
    List<String> uniqueParts = [];
    for (String part in parts) {
      if (!uniqueParts.contains(part)) {
        uniqueParts.add(part);
      }
    }
    return uniqueParts.join(", ");
  }
}
