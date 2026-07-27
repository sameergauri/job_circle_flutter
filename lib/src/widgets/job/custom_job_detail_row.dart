// ignore_for_file: use_full_hex_values_for_flutter_colors, collection_methods_unrelated_type

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class JobDetailRow extends StatelessWidget {
  final JobDetailPageModel job;
  final JobDetailType type;
  final bool showDivider;

  const JobDetailRow({
    super.key,
    required this.job,
    required this.type,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Resolve configuration based on type
    final config = _getRowConfig();
    if (config == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Constants.darkBlue.withValues(alpha: 0.8),
                child: CustomNetworkImage(
                  imageUrl: config.icon,
                  defaultIcon: Icons.error_outline,
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: config.label,
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      isCambria: true,
                    ),
                    const SizedBox(height: 4),

                    // Language rating text implementation
                    if (type == JobDetailType.language) ...[
                      ..._getLanguageWidgetLines(),
                      const SizedBox(height: 4),
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
                  ],
                ),
              ),
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: 6),
            Divider(color: Colors.grey.shade300, thickness: 1),
          ],
        ],
      ),
    );
  }

  // Helper structure to extract labels, values, and icons
  _RowConfig? _getRowConfig() {
    switch (type) {
      case JobDetailType.education:
        if (job.requiredEducation?.isNotEmpty != true) return null;
        return _RowConfig(
          icon: CustomIconUrl.educationOutlineIcon,
          label: 'Education :',
          value: job.requiredEducation!.replaceAll("or above", ''),
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

      case JobDetailType.certification:
        if (job.certifications?.isNotEmpty != true) return null;
        final allCertificationText = job.certifications!
            .map((e) {
              final name = e.value ?? '';
              if (name.isEmpty) return '';
              return e.mandatory == 1 ? '$name (Mandate)' : name;
            })
            .where((text) => text.isNotEmpty)
            .join(', ');

        if (allCertificationText.isEmpty) return null;
        return _RowConfig(
          icon: CustomIconUrl.certificationOutlineIcon,
          label: 'Certification :',
          value: allCertificationText,
        );

      case JobDetailType.diversity:
        final diversityText = _getDiversityText();
        if (diversityText.isEmpty) return null;
        return _RowConfig(
          icon: CustomIconUrl.certificationOutlineIcon,
          label: 'Diversity :',
          value: diversityText,
        );

      case JobDetailType.shiftWeekOff:
        final shiftOffText = _getShiftAndOffText();
        if (shiftOffText.isEmpty) return null;
        return _RowConfig(
          icon: CustomIconUrl.shitOutlineIcon,
          label: "Shift & Off's :",
          value: shiftOffText,
        );
    }
  }

  // --- Utility Logic Parsers Extracted from UI Context ---

  bool _isUndergradEligible() {
    return job.eligibility2?.contains(
          "Under Graduate with relevent experience can apply.",
        ) ==
        true;
  }

  bool _hasRelevantExperienceBackground() {
    return job.eligibility2?.contains(
          'Candidate should be from relevant experience background.',
        ) ==
        true;
  }

  // Parses combined structure cleanly on separate lines with dynamic dashes
  String _getShiftAndOffText() {
    final List<String> lines = [];

    if (job.shiftTime?.isNotEmpty == true) {
      if (job.shiftTime == "Day" ||
          job.shiftTime == "Night" ||
          job.shiftTime == "US Shift") {
        lines.add("Shift : ${job.shiftTime!}");
      } else if (job.shiftTime == "Day Rotational") {
        lines.add("Shift : ${job.shiftTime!} (9 hrs)");
      } else if (job.shiftTime == "Rotational (24/7)  Rotational Day") {
        lines.add("Shift : Male Rotational, Female Day Rotational (9 hrs)");
      } else if (job.shiftTime == "Rotational (24/7)") {
        lines.add("Shift : Rotational (9 hrs)");
      }
    }
    if (job.weekOff?.isNotEmpty == true) {
      lines.add("Week Off : ${job.weekOff!}");
    }

    if (lines.isEmpty) return "";
    // If multiple lines exist, map them to prepend "- ", otherwise return as-is
    return lines.length > 1
        ? lines.map((line) => "• $line").join('\n')
        : lines.first;
  }

  List<Widget> _getLanguageWidgetLines() {
    final String ratingText = _getEnglishRatingText(
      job.englishComsRating,
    ).trim();
    final String regionalText = job.language?.isNotEmpty == true
        ? job.language!.length == 1
              ? "${job.language!.join(', ')} Language is mandate"
              : "${job.language!.join(', ')} (Any one regional language is mandatory)"
        : "";

    final List<String> lines = [];
    if (ratingText.isNotEmpty) lines.add(ratingText);
    if (regionalText.isNotEmpty) lines.add(regionalText);

    if (lines.isEmpty) return [];

    final bool showDash = lines.length > 1;

    return lines
        .expand(
          (line) => [
            showDash
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align bullet to the top line
                    children: [
                      customText(
                        title: "• ",
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        isCambria: true,
                      ),
                      Expanded(
                        child: customText(
                          title: line,
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          isCambria: true,
                        ),
                      ),
                    ],
                  )
                : customText(
                    title: line,
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    isCambria: true,
                  ),
            const SizedBox(height: 4),
          ],
        )
        .toList()
      ..removeLast(); // Removes trailing extra space
  }

  String _getEnglishRatingText(String? rating) {
    if (rating == "Very Good") {
      return "Good English communication skills are required for effective interaction with customers.";
    } else if (rating == "Average" || rating == "No English") {
      return "A basic level of English proficiency is expected for communication in this role.";
    }
    return "Excellent English written and verbal communication skills required.";
  }

  String _getDiversityText() {
    if (job.eligibility2 == null) return "";
    final dynamic rawE2 = job.eligibility2!;
    final String e2 = rawE2 is List ? rawE2.join(' ') : rawE2.toString();

    final List<String> diversityStatements = [];

    // 1. Check Gender Preferences
    if (e2.contains("This role is exclusively for male candidates.")) {
      diversityStatements.add("This role is exclusively for male candidates");
    } else if (e2.contains("This role is exclusively for female candidates.")) {
      diversityStatements.add("This role is exclusively for female candidates");
    } else if (e2.contains(
      "All candidates are encouraged to apply, and we have a preference for female applicants as part of our diversity initiative.",
    )) {
      diversityStatements.add("Female candidates are preferred for this role");
    }

    // 2. Check Age Range dynamically using the optimized RegExp
    final ageRegex = RegExp(
      r'Candidate age should be in between (\d+)\s*-\s*(\d+)\s*yrs?\.?',
      caseSensitive: false,
    );

    if (ageRegex.hasMatch(e2)) {
      diversityStatements.add(
        "Candidate age should be in between ${job.minAge} - ${job.maxAge} yrs.",
      );
    }

    if (diversityStatements.isEmpty) return "";
    // If multiple statements exist, map them to prepend "- ", otherwise return as-is
    return diversityStatements.length > 1
        ? diversityStatements.map((stmt) => "• $stmt").join('\n')
        : diversityStatements.first;
  }

  String _formatExperience(String experience) {
    final exp = experience.trim();
    if (exp.isEmpty) return '';
    if (RegExp(r'fresher', caseSensitive: false).hasMatch(exp)) return exp;

    final nums = RegExp(
      r'\d+',
    ).allMatches(exp).map((m) => m.group(0)).whereType<String>().toList();

    if (exp.contains('-') && nums.length >= 2) {
      return 'Min ${nums[0]} to ${nums[1]} years of experience required.';
    }

    if (RegExp(r'month', caseSensitive: false).hasMatch(exp) &&
        RegExp(r'above', caseSensitive: false).hasMatch(exp) &&
        nums.isNotEmpty) {
      return 'Min ${nums[0]} month of experience required.';
    }

    if (RegExp(r'above', caseSensitive: false).hasMatch(exp) &&
        nums.isNotEmpty) {
      final n = nums.first;
      return 'Min $n years of experience required.';
    }

    if (nums.length == 1) {
      return 'Min ${nums[0]} years of experience required.';
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
