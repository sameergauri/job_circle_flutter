// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/utils/salary_formater.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/job/custom_job_detail_row.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 1080 × 1080 square share card (also used for 1080 × 2026 option).
class ShareJobCardSquare extends StatelessWidget {
  final JobDetailPageModel job;
  final String shareUrl;

  const ShareJobCardSquare({
    super.key,
    required this.job,
    required this.shareUrl,
  });

  static const _blue = Constants.darkBlue;

  List<String> get _hashtags {
    final tags = <String>[];
    if (job.skills?.isNotEmpty == true) {
      tags.add(
        '#${job.skills!.take(8).map((s) => s.replaceAll(' ', '')).join(' #')}',
      );
    }
    return tags.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: 1080,
      height: 1080,
      child: Material(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                _header(colors), // 80
                SizedBox(height: 10),
                _blueBanner(), // 130
                Expanded(child: _content()), // ~810
                _footer(), // 60
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build standard layout rows for feature points cleanly
  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 4, top: 4),
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: CustomIconUrl.checkWithCircle,
            defaultIcon: Icons.check_box_outlined,
            height: 35,
            width: 34,
            color: Colors.white,
          ),
          /* Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(
                0xffdcdcdc,
              ), // Light grey circle badge icon background placeholder
              shape: BoxShape.circle,
            ),
          ), */
          const SizedBox(width: 12),
          Expanded(
            child: customText(
              monst: false,
              title: text,
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper layout method to inject precise white divider lines between app features
  Widget _buildFeatureDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Divider(color: Colors.white, thickness: 1.5),
    );
  }

  // ── Header (height 90) ──────────────────────────────────────────────────────
  Widget _header(AppColors colors) => SizedBox(
    height: 90,
    child: Padding(
      padding: const EdgeInsets.only(left: 25, right: 0),
      child: Row(
        children: [
          IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'JOB',
                        style: GoogleFonts.signika(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: colors.darkBlue ?? Constants.sharlogoColor,
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: 'CIRCLE',
                        style: GoogleFonts.signika(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF000000),
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.translate(
                    offset: const Offset(0, -4),
                    child: const customText(
                      monst: true,
                      title: 'The Uber of Recruitment',
                      fontSize: 18,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Image.asset(CustomAssetUrl.playstoreicon, height: 104, width: 300),
        ],
      ),
    ),
  );

  // ── Blue banner (height 135) ────────────────────────────────────────────────
  Widget _blueBanner() => Container(
    decoration: BoxDecoration(
      color: _blue,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 10),
    margin: const EdgeInsets.only(left: 25, right: 25),
    child: Row(
      children: [
        // Left elements occupy the available banner row space cleanly
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customText(
                title: job.roleName ?? job.jobHeadline ?? '',
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  customText(
                    title:
                        '${job.locations?.firstOrNull ?? job.locationWithWorkType}'
                        '   ₹ ${SalaryFormatter.format(min: job.minCtc, max: job.maxCtc, perMonth: job.salaryRange!.toUpperCase().contains("PM") ? "1" : "0")}',
                    fontSize: 22,
                    color: Colors.white,
                    maxlines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              customText(
                title: _hashtags.isNotEmpty
                    ? _hashtags.join(' ')
                    : '#CustomerService #Inbound #Domestic #BankingProcess',
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── Main content ────────────────────────────────────────────────────────────
  Widget _content() => Padding(
    padding: const EdgeInsets.only(left: 44, right: 44, top: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (job.jobSummary?.isNotEmpty == true) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: "Job Summary :",
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 5),
                    customText(
                      title: job.jobSummary!,
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      isCambria: true,
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
              // Cleaned up the separate Divider lines here
              if (job.requiredEducation?.isNotEmpty == true)
                JobDetailRow(
                  job: job,
                  showDivider:
                      job.requiredExperience?.isNotEmpty == true ||
                      job.certifications?.isNotEmpty == true ||
                      job.language?.isNotEmpty == true ||
                      job.shiftTime?.isNotEmpty == true ||
                      job.weekOff?.isNotEmpty == true,
                  type: JobDetailType.education,
                ),

              if (job.requiredExperience?.isNotEmpty == true)
                JobDetailRow(
                  job: job,
                  showDivider:
                      job.certifications?.isNotEmpty == true ||
                      job.language?.isNotEmpty == true ||
                      job.shiftTime?.isNotEmpty == true ||
                      job.weekOff?.isNotEmpty == true,
                  type: JobDetailType.experience,
                ),

              if (job.language?.isNotEmpty == true ||
                  job.englishComsRating?.isNotEmpty == true)
                JobDetailRow(
                  job: job,
                  showDivider:
                      job.language?.isNotEmpty == true ||
                      job.englishComsRating?.isNotEmpty == true,
                  type: JobDetailType.language,
                ),

              if (job.certifications?.isNotEmpty == true)
                JobDetailRow(
                  job: job,
                  showDivider:
                      job.language?.isNotEmpty == true ||
                      job.shiftTime?.isNotEmpty == true ||
                      job.weekOff?.isNotEmpty == true,
                  type: JobDetailType.certification,
                ),

              if (job.eligibility2 != null &&
                  ((job.eligibility2!.contains(
                            "This role is exclusively for male candidates.",
                          ) ||
                          job.eligibility2!.contains(
                            "This role is exclusively for female candidates.",
                          ) ||
                          job.eligibility2!.contains(
                            "All candidate are encouraged to apply, and we have a preference for female applicants as part of our diversity initiative",
                          )) ||
                      job.eligibility2!.contains(
                        // ignore: collection_methods_unrelated_type
                        RegExp(
                          r'Candidate age should be in between (\d+)\s*-\s*(\d+)\s*yrs?\.?',
                          caseSensitive: false,
                        ),
                      )))
                JobDetailRow(
                  job: job,
                  showDivider: true,
                  type: JobDetailType.diversity,
                ),

              if (job.shiftTime?.isNotEmpty == true &&
                  job.weekOff?.isNotEmpty == true)
                JobDetailRow(
                  job: job,
                  showDivider: false,
                  type: JobDetailType.shiftWeekOff,
                ),
            ],
          ),
        ),

        Container(
          width: 300,
          height: 650,
          margin: EdgeInsets.only(right: 10, left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: Colors.black, width: 5),
            boxShadow: const [
              // Main shadow (bottom)
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: Offset(8, 20),
                spreadRadius: 2,
              ),
              // Soft inner shadow for depth
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(4, 8),
              ),
              // Highlight on top-left (for 3D raised effect)
              BoxShadow(
                color: Colors.white70,
                blurRadius: 20,
                offset: Offset(-6, -6),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phone Top Notch / Camera Area
              Center(
                child: Container(
                  height: 20,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 75,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Scan to Apply Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: const customText(
                  monst: false,
                  title: 'Scan to Apply',
                  fontSize: 24,
                  color: Color(0xfffff510a),
                  fontWeight: FontWeight.bold,
                ),
              ),

              // QR Code
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: QrImageView(
                  data: shareUrl,
                  version: QrVersions.auto,
                  size: 275,
                  backgroundColor: Colors.white,
                ),
              ),

              // Features Section
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Constants.darkBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    _buildFeatureRow('Real-Time interview feedback tracking'),
                    _buildFeatureDivider(),
                    _buildFeatureRow('AI & ATS-Friendly Resume Builder'),
                    _buildFeatureDivider(),
                    _buildFeatureRow('Stable Career Growth'),
                    SizedBox(height: 13),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── Footer (height 60) ──────────────────────────────────────────────────────
  Widget _footer() => Container(
    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
    padding: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: _blue,
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: customText(
      title: "Fast-track your professional growth in just one scan.",
      fontSize: 26,
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      textAlign: TextAlign.center,
    ),
  );
}
