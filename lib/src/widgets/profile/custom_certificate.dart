import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_certificate_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CertificationSection extends StatelessWidget {
  final ProfileProvider provider;

  const CertificationSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    Map<String, int> monthMap = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    provider.profile!.certifications!.sort((a, b) {
      var yearA = int.tryParse(a.startYear?.toString() ?? '0') ?? 0;
      var yearB = int.tryParse(b.startYear?.toString() ?? '0') ?? 0;
      if (yearA == yearB) {
        var monthA = monthMap[a.startMonth?.toString() ?? 'January'] ?? 1;
        var monthB = monthMap[b.startMonth?.toString() ?? 'January'] ?? 1;
        return monthB.compareTo(monthA);
      } else {
        return yearB.compareTo(yearA);
      }
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
          /// 🔹 Header Row (Icon + Title + Actions)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CustomNetworkImage(
                    imageUrl: CustomIconUrl.certificateicon,
                    defaultIcon: Icons.celebration_outlined,
                  ),
                ),
                SizedBox(width: 5),
                const customText(
                  title: "Certifications",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Add Button → CertificateEdit
                      InkWell(
                        onTap: () {
                          provider.clearCertificateForm();
                          provider.setShowCertificateForm(true);
                          NavigationService.push(
                            ProfileCertificateEdit(
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

                      /// Edit Button → CertificateList / CertificateEdit
                      if (provider.profile!.certifications!.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (provider.profile!.certifications!.length != 1) {
                              provider.setShowCertificateForm(false);
                              NavigationService.push(
                                ProfileCertificateEdit(
                                  fromEditOrAdd: FromEditOrAdd.edit,
                                ),
                              );
                            } else {
                              provider.editCertificate(0);
                              provider.setShowCertificateForm(true);
                              NavigationService.push(
                                ProfileCertificateEdit(
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
          provider.profile!.certifications!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 10),
                  child: const customText(
                    title: "Add your certification detail.",
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
                      child: const Divider(thickness: 1.0),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.profile!.certifications!.length,
                  itemBuilder: (context, index) {
                    var data = provider.profile!.certifications!;
                    return Column(
                      children: [
                        CustomNewListTile(
                          onTap: () {},
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
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
                                data[index].certLogo != null &&
                                    data[index].certLogo!.trim().isNotEmpty
                                ? Image.network(
                                    "${GlobalConstants.Image_url}${data[index].certLogo}",
                                    fit: BoxFit.contain,
                                  )
                                : CustomNetworkImage(
                                    imageUrl: CustomIconUrl.certificateiicon,
                                    defaultIcon: Icons.cast_for_education,
                                  ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  title: data[index].certificationName
                                      .toString()
                                      .toTitleCase(),
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                customText(
                                  title: data[index].issuingOrganization
                                      .toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          subtitle: customText(
                            monst: true,
                            title:
                                "${MonthNameConverter.getShortMonthName(data[index].startMonth)} - ${data[index].startYear}",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Constants.subtitleclr,
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
