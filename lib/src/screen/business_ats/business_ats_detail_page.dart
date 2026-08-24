// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/business_ats/business_ats_model.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/screen/business_ats/business_ats_detail/ats_screening_anwer.dart';
import 'package:job_circle/src/screen/business_ats/business_ats_detail/attachment.dart';
import 'package:job_circle/src/screen/business_ats/business_ats_detail/lead_detail.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class BusinessAtsDetailPage extends StatefulWidget {
  final AtsApplicant applicant;

  const BusinessAtsDetailPage({super.key, required this.applicant});

  @override
  State<BusinessAtsDetailPage> createState() => _BusinessAtsDetailPageState();
}

class _BusinessAtsDetailPageState extends State<BusinessAtsDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.applicant.userId != null && widget.applicant.userId != 0) {
        context.read<ProfileProvider>().fetchProfile(
          userid: widget.applicant.userId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final applicant = widget.applicant;

    final bool hasScreeningAnswers =
        applicant.screeningAnswers != null &&
        ((applicant.screeningAnswers!.totalQuestions ?? 0) > 0 ||
            (applicant.screeningAnswers!.answers.isNotEmpty));

    final int tabLength = 2 + (hasScreeningAnswers ? 1 : 0);

    return DefaultTabController(
      length: tabLength,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: colors.bgColor,
        appBar: AppBar(
          backgroundColor: colors.appbarColor,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: colors.headingColor),
          titleSpacing: 0,
          title: CustomListTile(
            onTap: () {
              applicant.userId != null && applicant.userId != 0
                  ? CustomSnackbar.show("Not Implemented yet", true)
                  : SizedBox.shrink();
            },
            dense: true,
            contentPadding: EdgeInsets.only(right: 10),
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFC4C4C4),
              backgroundImage:
                  applicant.candidateInfoDto?.profileIcon != null &&
                      applicant.candidateInfoDto!.profileIcon!.trim().isNotEmpty
                  ? NetworkImage(
                      '${GlobalConstants.Image_url}${applicant.candidateInfoDto!.profileIcon}',
                    )
                  : applicant.gender == "Male"
                  ? const AssetImage(CustomAssetUrl.maleicon) as ImageProvider
                  : const AssetImage(CustomAssetUrl.femalicon),
            ),
            title: customText(
              title: applicant.fullName.isNotEmpty
                  ? applicant.fullName
                  : "Candidate Name",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.headingColor,
            ),
            subtitle: customText(
              title:
                  'Applied for : ${applicant.roleForBusinessHiring ?? "Role"} || ${applicant.hiringFor}',
              fontSize: 11,
              color: colors.subTitleColor,
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
          bottom: TabBar(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            labelColor: colors.headingColor,
            unselectedLabelColor: colors.subTitleColor,
            indicatorColor: colors.orangeLine ?? Constants.orange,
            indicatorWeight: 2.5,
            labelStyle: GoogleFonts.merriweather(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: GoogleFonts.merriweather(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              if (hasScreeningAnswers) const Tab(text: "Screening"),
              const Tab(text: "Attachment"),
              const Tab(text: "Lead Detail"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 2. Screening Responses Tab (Conditional)
            if (hasScreeningAnswers)
              ScreeningQuestionAnswer(applicantData: applicant),

            // 3. Attachment Tab
            AtsAttachment(
              contactno: applicant.contactNo?.toString() ?? '',
              candidateName: applicant.fullName,
              resume: applicant.resume ?? '',
            ),

            // 4. Lead Detail Tab
            LeadDetail(applicant: applicant),
          ],
        ),
      ),
    );
  }
}
