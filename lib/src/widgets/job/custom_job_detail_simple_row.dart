// ignore_for_file: collection_methods_unrelated_type

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class JobDetailSimpleRow extends StatelessWidget {
  final JobDetailPageModel job;
  final JobDetailType type;

  const JobDetailSimpleRow({super.key, required this.job, required this.type});

  @override
  Widget build(BuildContext context) {
    final config = _getRowConfig();
    if (config == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Constants.darkBlue.withValues(alpha: 0.8),
            child: CustomNetworkImage(
              imageUrl: config.icon,
              defaultIcon: Icons.error_outline,
              width: 20,
              height: 20,
              color: Constants.white,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language rating text implementation
                if (type == JobDetailType.language) ...[
                  ..._getLanguageWidgetLines(),
                  const SizedBox(height: 2),
                ],

                // Main value text block
                if (type != JobDetailType.language)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: config.value,
                          style: GoogleFonts.lora(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        if (type == JobDetailType.experience &&
                            _hasRelevantExperienceBackground())
                          TextSpan(
                            text:
                                " (Candidate should be from relevant experience background)",
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Color(0xfffff510a),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (type == JobDetailType.education &&
                            _isUndergradEligible())
                          TextSpan(
                            text:
                                " (Under Graduate with relevant experience can apply)",
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Color(0xfffff510a),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),

                // Education secondary block
                /*   if (type == JobDetailType.education &&
                    _isUndergradEligible()) ...[
                  const SizedBox(height: 4),
                  customText(
                    title:
                        "(Under Graduate with relevant experience can apply)",
                    fontSize: 16,
                    color: Constants.orange,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ], */
              ],
            ),
          ),
        ],
      ),
    );
  }

  _RowConfig? _getRowConfig() {
    switch (type) {
      case JobDetailType.education:
        if (job.requiredEducation?.isNotEmpty != true) return null;
        return _RowConfig(
          icon: CustomIconUrl.educationOutlineIcon,
          label: 'Education :',
          value: job.requiredEducation!,
        );

      case JobDetailType.experience:
        if (job.requiredExperience?.isNotEmpty != true) return null;
        return _RowConfig(
          icon: CustomIconUrl.experienceOutlineIcon,
          label: 'Experience :',
          value: _formatExperience(job.requiredExperience!),
        );

      case JobDetailType.language:
        if ((job.language == null || job.language!.isEmpty) &&
            (job.englishComsRating == null || job.englishComsRating!.isEmpty)) {
          return null;
        }
        return _RowConfig(
          icon: CustomIconUrl.languageOutlineIcon,
          label: 'Language :',
        );

      case JobDetailType.shiftWeekOff:
        final shiftOffText = _getShiftAndOffText();
        if (shiftOffText.isEmpty) return null;
        return _RowConfig(
          icon: CustomIconUrl.shitOutlineIcon,
          label: "Shift & Off's :",
          value: shiftOffText,
        );

      default:
        return null;
    }
  }

  bool _isUndergradEligible() {
    return job.eligibility2?.contains(
          'Under Graduate with relevant experience can apply.',
        ) ==
        true;
  }

  bool _hasRelevantExperienceBackground() {
    return job.eligibility2?.contains(
          'Candidate should be from relevant experience background.',
        ) ==
        true;
  }

  String _getShiftAndOffText() {
    String? shiftText;
    String? weekOffText;

    if (job.shiftTime?.isNotEmpty == true) {
      if (job.shiftTime == "Day" ||
          job.shiftTime == "Night" ||
          job.shiftTime == "US Shift") {
        shiftText = "Shift : ${job.shiftTime!}";
      } else if (job.shiftTime == "Day Rotational") {
        shiftText = "Shift : ${job.shiftTime!} (9 hrs)";
      } else if (job.shiftTime == "Rotational (24/7)  Rotational Day") {
        shiftText = "Shift : Male Rotational, Female Day Rotational (9 hrs)";
      } else if (job.shiftTime == "Rotational (24/7)") {
        shiftText = "Shift : Rotational (9 hrs)";
      }
    }

    if (job.weekOff?.isNotEmpty == true) {
      weekOffText = "Week Off : ${job.weekOff!}";
    }

    // Combine on a single line if both exist, otherwise return whichever is available
    if (shiftText != null && weekOffText != null) {
      return "$shiftText || $weekOffText";
    } else if (shiftText != null) {
      return shiftText;
    } else if (weekOffText != null) {
      return weekOffText;
    }

    return "";
  }

  List<Widget> _getLanguageWidgetLines() {
    final String ratingText = _getEnglishRatingText(
      job.englishComsRating,
    ).trim();
    final String regionalText = job.language?.isNotEmpty == true
        ? "${job.language!.join(', ')} (Any one regional language is mandatory)"
        : "";

    final List<String> lines = [];
    if (ratingText.isNotEmpty) lines.add(ratingText);
    if (regionalText.isNotEmpty) lines.add(regionalText);

    if (lines.isEmpty) return [];

    final bool showDash = lines.length > 1;

    return lines
        .expand(
          (line) => [
            customText(
              title: showDash ? "• $line" : line,
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              isCambria: true,
            ),
            const SizedBox(height: 4),
          ],
        )
        .toList()
      ..removeLast();
  }

  String _getEnglishRatingText(String? rating) {
    if (rating == "Very Good") {
      return "Good English communication skills are required for effective interaction with customers.";
    } else if (rating == "Average" || rating == "No English") {
      return "A basic level of English proficiency is expected for communication in this role.";
    }
    return "Excellent English written and verbal communication skills required.";
  }

  String _formatExperience(String experience) {
    final exp = experience.trim();
    if (exp.isEmpty) return '';
    if (RegExp(r'fresher', caseSensitive: false).hasMatch(exp)) return exp;

    final nums = RegExp(
      r'\d+',
    ).allMatches(exp).map((m) => m.group(0)).whereType<String>().toList();

    if (exp.contains('-') && nums.length >= 2) {
      return 'Minimum ${nums[0]} to ${nums[1]} years of experience required.';
    }

    if (RegExp(r'month', caseSensitive: false).hasMatch(exp) &&
        RegExp(r'above', caseSensitive: false).hasMatch(exp) &&
        nums.isNotEmpty) {
      return 'Minimum ${nums[0]} month of experience required.';
    }

    if (RegExp(r'above', caseSensitive: false).hasMatch(exp) &&
        nums.isNotEmpty) {
      final n = nums.first;
      return 'Minimum $n years of experience required.';
    }

    if (nums.length == 1) {
      return 'Minimum ${nums[0]} years of experience required.';
    }

    return exp;
  }
}

class _RowConfig {
  final String icon;
  final String label;
  final String? value;
  _RowConfig({required this.icon, required this.label, this.value});
}
