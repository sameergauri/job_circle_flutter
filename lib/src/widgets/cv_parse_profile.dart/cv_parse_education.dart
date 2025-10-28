import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_edit/education_list_edit.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CvParseEducation extends StatelessWidget {
  final SignupCreateUserProvider provider;

  const CvParseEducation({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    /// Sorting

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                CustomNetworkImage(
                  imageUrl: CustomIconUrl.profileeducation,
                  defaultIcon: Icons.cast_for_education,
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
                            EducationList(fromEditOrAdd: FromEditOrAdd.add),
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          color: Constants.subtitleclr,
                          size: 20,
                        ),
                      ),

                      /// Edit Education
                      if (provider.educationModel.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (provider.educationModel.length == 1) {
                              provider.editEducation(0);
                              provider.setShowEducationForm(true);
                              NavigationService.push(
                                EducationList(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            } else {
                              provider.setShowEducationForm(false);
                              NavigationService.push(
                                EducationList(
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
          (provider.educationModel.isEmpty)
              ? Container(
                  padding: const EdgeInsets.only(left: 5, top: 10),
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
                  padding: EdgeInsets.only(top: 5),
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 2),
                      child: const Divider(thickness: 1.0),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.educationModel.length,
                  itemBuilder: (context, index) {
                    final data = provider.educationModel[index];
                    return Padding(
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
                          child: CustomNetworkImage(
                            imageUrl: CustomIconUrl.schoolicon,
                            defaultIcon: Icons.school,
                            color: Constants.subtitleclr,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (data.degreeSpc != null)
                                customText(
                                  title: data.degreeSpc!,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              if (data.university != null)
                                customText(
                                  title: data.university!,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        subtitle:
                            data.endMonth != null && data.passingYear != null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: customText(
                                  monst: true,
                                  title: data.passingYear != null
                                      ? data.endMonth != null
                                            ? '${DateUtilsHelper.getMonthName(data.endMonth)} - ${data.passingYear.toString()}'
                                            : data.passingYear.toString()
                                      : '',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.subtitleclr,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : data.isCurrent == 1
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: customText(
                                  title: "Pursuing",
                                  fontWeight: FontWeight.w500,
                                  color: Constants.subtitleclr,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
