// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_edit/projects_list_edit.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/add_bullet_point.dart';
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/expandable_text_widget.dart';

class CvParseProject extends StatelessWidget {
  final SignupCreateUserProvider provider;

  const CvParseProject({super.key, required this.provider});

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
            padding: const EdgeInsets.only(bottom: 4, top: 5),
            child: Row(
              children: [
                CustomNetworkImage(
                  imageUrl: CustomIconUrl.projecticon,
                  defaultIcon: Icons.cast_for_education,
                ),
                SizedBox(width: 5),
                const customText(
                  title: "Projects",
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
                          provider.clearProjectFoorm();
                          provider.setShowProjectForm(true);
                          NavigationService.push(
                            ProjectList(fromEditOrAdd: FromEditOrAdd.add),
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          color: Constants.subtitleclr,
                          size: 20,
                        ),
                      ),

                      /// Edit Education
                      if (provider.projectModel.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (provider.projectModel.length == 1) {
                              provider.editProject(0);
                              provider.setShowProjectForm(true);
                              NavigationService.push(
                                ProjectList(fromEditOrAdd: FromEditOrAdd.edit),
                              );
                            } else {
                              provider.setShowProjectForm(false);
                              NavigationService.push(
                                ProjectList(fromEditOrAdd: FromEditOrAdd.edit),
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
          (provider.projectModel.isEmpty)
              ? Container(
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  child: const Column(
                    children: [
                      customText(
                        title: "Add your project detail.",
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
                  itemCount: provider.projectModel.length,
                  itemBuilder: (context, index) {
                    final data = provider.projectModel[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          CustomNewListTile(
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
                                imageUrl: CustomIconUrl.projectConstantIcon,
                                defaultIcon: Icons.school,
                                color: Constants.subtitleclr,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data.projectTitle != null &&
                                      data.projectTitle != '')
                                    customText(
                                      title: data.projectTitle ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  if (data.description != null &&
                                      data.description != '')
                                    customText(
                                      title: data.description ?? "",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            subtitle:
                                data.duration != null && data.duration != 'null'
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: customText(
                                      title:
                                          MonthRangeFormatter.formatMonthRange(
                                            data.duration!,
                                          ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Constants.subtitleclr,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          if (data.description != null &&
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
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
