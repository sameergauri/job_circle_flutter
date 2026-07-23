// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/utils/salary_formater.dart';
import 'package:job_circle/src/utils/scan_to_apply_cliper.dart';
import 'package:job_circle/src/widgets/job/custom_job_detail_simple_row.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 1080 × 644 landscape share card.
class ShareJobCardLandscape extends StatelessWidget {
  final JobDetailPageModel job;
  final String shareUrl;

  const ShareJobCardLandscape({
    super.key,
    required this.job,
    required this.shareUrl,
  });

  static const _blue = Constants.darkBlue;

  List<String> get _hashtags {
    final tags = <String>[];
    if (job.skills?.isNotEmpty == true) {
      tags.add('#${job.skills!.map((s) => s.replaceAll(' ', '')).join(' #')}');
    }
    return tags.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: 1080,
      height: 644,
      child: Material(
        color: colors.bgColor,
        child: Stack(
          children: [
            Column(
              children: [
                _header(colors),
                SizedBox(height: 10),
                _blueBanner(),
                Expanded(child: _content()),
                _footer(),
              ],
            ),
          ],
        ),
      ),
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
    // height: 135,
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
              // const SizedBox(height: 8),
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
        // Right side is left empty now so the layout underneath can slide up over it cleanly
      ],
    ),
  );

  // ── Main content ────────────────────────────────────────────────────────────
  Widget _content() {
    final shiftItems = <String>[
      if (job.shiftTime?.isNotEmpty == true) job.shiftTime!,
      if (job.weekOff?.isNotEmpty == true) job.weekOff!,
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 44, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left info
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (job.requiredEducation?.isNotEmpty == true)
                  JobDetailSimpleRow(job: job, type: JobDetailType.education),
                if (job.requiredExperience?.isNotEmpty == true)
                  JobDetailSimpleRow(job: job, type: JobDetailType.experience),
                if (job.language?.isNotEmpty == true ||
                    job.englishComsRating?.isNotEmpty == true)
                  JobDetailSimpleRow(job: job, type: JobDetailType.language),
                if (shiftItems.isNotEmpty && job.weekOff!.isNotEmpty) ...[
                  JobDetailSimpleRow(
                    job: job,
                    type: JobDetailType.shiftWeekOff,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade100, width: 1.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: QrImageView(
              data: shareUrl,
              version: QrVersions.auto,
              size: 275,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer (height 60) ──────────────────────────────────────────────────────
  Widget _footer() => Container(
    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
    padding: const EdgeInsets.only(left: 10, right: 37, bottom: 2),
    decoration: BoxDecoration(
      color: _blue,
      borderRadius: BorderRadius.circular(10),
    ),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 4),
          child: customText(
            title: "Fast-track your professional growth in just one scan.",
            fontSize: 26,
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ),
        ClipPath(
          clipper: ScanToApplyClipper(),
          child: Container(
            width: 260,
            color: Color(0xfffff510a),
            padding: const EdgeInsets.only(top: 14, bottom: 12),
            alignment: Alignment.center,
            child: const customText(
              title: 'Scan to Apply',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
