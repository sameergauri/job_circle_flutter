import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_edit/cv_parse_edit_summary.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/expandable_text_widget.dart';

class CvParseSummary extends StatelessWidget {
  final UserRequest profileData;
  final SignupCreateUserProvider provider;

  const CvParseSummary({
    super.key,
    required this.profileData,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -------- Header Row --------
          Row(
            children: [
              CustomNetworkImage(
                imageUrl: CustomIconUrl.summaryicon,
                defaultIcon: Icons.cast_for_education,
              ),
              SizedBox(width: 5),
              const customText(
                title: "Summary",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        provider.assignCvParseDataToControllers();
                        NavigationService.push(CvParseEditSummary());
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

          const SizedBox(height: 10),

          /// -------- Summary Text --------
          Container(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ExpandableTextWidget(
              key: ValueKey(DateTime.now().millisecondsSinceEpoch),
              initialMaxLines: 5,
              text: profileData.bio.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
