import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/profile/profile_edit.dart/profile_summary_edit.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/expandable_text_widget.dart';

class CustomSummaryContainer extends StatelessWidget {
  final ProfileProvider provider;

  const CustomSummaryContainer({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
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
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CustomNetworkImage(
                  imageUrl: CustomIconUrl.summaryicon,
                  defaultIcon: Icons.cast_for_education,
                ),
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
                        provider.assignSummaryToController();
                        NavigationService.push(ProfileSummaryEdit());
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
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.only(right: 4, top: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ExpandableTextWidget(
              isSummary: true,
              key: ValueKey(DateTime.now().millisecondsSinceEpoch),
              initialMaxLines: 5,
              text: provider.profile!.bio.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
