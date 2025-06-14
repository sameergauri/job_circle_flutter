// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_home_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/themes/colors.dart';

class CustomJobCard extends ConsumerWidget {
  final JobContent job;
  final List<String> skills;
  final VoidCallback? onLastFavoriteRemoved;

  const CustomJobCard({
    super.key,
    required this.job,
    required this.skills,
    this.onLastFavoriteRemoved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ValueNotifier<bool>(false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (job.jobPostType != null &&
              (job.jobPostType == 2 || job.jobPostType == 3))
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Constants.darkBlue,
                    Constants.darkBlue.withOpacity(0.03),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/128/17511/17511707.png',
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                    color: Constants.bgColorWhite,
                  ),
                  const SizedBox(width: 5),
                  const customTextForWeather(
                    title: "Premium Hiring",
                    color: Constants.bgColorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Container(
                padding: const EdgeInsets.all(4),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Constants.lightdull),
                    borderRadius: BorderRadius.circular(8)),
                child: job.companyIcon != null && job.companyIcon != ""
                    ? Image.network(
                        "${GlobalConstants.Image_url}${job.companyIcon}",
                        fit: BoxFit.fitWidth,
                      )
                    : Image.network(
                        "https://cdn-icons-png.flaticon.com/128/14644/14644423.png",
                      )),
            title: customTextForWeather(
              title: job.jobHeadline ?? '',
              fontWeight: FontWeight.w700,
              maxlines: 2,
              overflow: TextOverflow.ellipsis,
              fontSize: job.jobHeadline != null
                  ? job.jobHeadline!.length < 30
                      ? 16
                      : 14
                  : 14,
            ),
            trailing: ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, loading, child) {
                return loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Constants.darkBlue,
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          final userId = await Utils.getPreferencesValue(
                              null, ESharedPreferences.user_id.name);

                          if (userId != null) {
                            if (job.id == null ||
                                (job.isFavorite == true &&
                                    job.favJobId == null)) {
                              CustomSnackbar.show("Inavlid JobData", true);
                              return;
                            }

                            isLoading.value = true;
                            bool success;
                            String actionMessage;

                            if (job.isFavorite == true) {
                              final result = await ref
                                  .read(jobListProvider.notifier)
                                  .removeFavoriteJob(favid: job.favJobId ?? 0);

                              success = result['success'] as bool;
                              final wasLastSavedJob =
                                  result['wasLastSavedJob'] as bool;

                              actionMessage = success
                                  ? "Job removed from favorites"
                                  : "Failed to remove job from favorites";

                              // Call the callback if this was the last saved job
                              if (wasLastSavedJob &&
                                  onLastFavoriteRemoved != null) {
                                onLastFavoriteRemoved!();
                              }
                            } else {
                              success = await ref
                                  .read(jobListProvider.notifier)
                                  .saveFavoriteJob(
                                    userId: int.parse(userId),
                                    jobId: job.id ?? 0,
                                  );
                              actionMessage = success
                                  ? "Job saved to favorites"
                                  : "Failed to save job to favorites";
                            }

                            isLoading.value = false;
                            /*  if (success) {
                              CustomSnackbar.show(actionMessage, false);
                            } */
                          }
                        },
                        child: CustomNetworkImage(
                          height: 20,
                          width: 20,
                          color: job.isFavorite == true
                              ? Constants.darkBlue
                              : Constants.subtitleclr,
                          imageUrl: job.isFavorite == true
                              ? 'https://cdn-icons-png.flaticon.com/128/3916/3916594.png'
                              : 'https://cdn-icons-png.flaticon.com/128/18561/18561365.png',
                          defaultIcon: job.isFavorite == true
                              ? Icons.bookmark_outlined
                              : Icons.bookmark_border_outlined,
                        ));
              },
            ),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(
              Icons.work_outline_outlined,
              formatExperience(job.experienceRequired
                  .toString()
                  .replaceAll('Years', 'yrs'))),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.currency_rupee, _formatSalary(job.salaryRange)),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.location_on_outlined, job.location ?? ''),
          const SizedBox(height: 5),
          if (job.languages != null && job.languages != "[]") ...[
            Builder(
              builder: (context) {
                List<String> languages =
                    List<String>.from(jsonDecode(job.languages!));
                List<String> filteredLanguages = languages
                    .map((e) => e.trim())
                    .where((lang) => !["english", "hindi", "marathi"]
                        .contains(lang.toLowerCase()))
                    .toList();
                if (filteredLanguages.isNotEmpty) {
                  return _buildLanguageRow(filteredLanguages);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: [
              const customTextForWeather(title: "Skills : "),
              ...skills.take(10).toList().asMap().entries.map((entry) {
                final skillIndex = entry.key;
                final value = entry.value;
                final isLast = skillIndex == skills.take(10).length - 1;
                return customTextForWeather(
                  title: isLast
                      ? value + (skills.length > 10 ? '...' : '.')
                      : '$value, ',
                  overflow: TextOverflow.ellipsis,
                  fontStyle: FontStyle.italic,
                  softwrap: true,
                  color: Constants.subtitleclr,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  String formatExperience(String exp) {
    final regex = RegExp(r'^(\d+)\s*-\s*& above yrs$');
    final match = regex.firstMatch(exp);

    if (exp.contains("6 months & Above")) {
      return "6 months and above";
    }

    if (match != null) {
      final number = match.group(1);
      return "${number}yrs and above";
    }
    return exp; // default return if pattern doesn't match
  }

  String _formatSalary(String? salaryRange) {
    if (salaryRange == null || salaryRange.isEmpty) return '';

    // Extract if it ends with " 0" or " 1"
    String suffix = '';
    if (salaryRange.endsWith(' 0')) {
      suffix = ' LPA';
      salaryRange = salaryRange.replaceFirst(RegExp(r'\s0$'), '');
    } else if (salaryRange.endsWith(' 1')) {
      suffix = ' per month';
      salaryRange = salaryRange.replaceFirst(RegExp(r'\s1$'), '');
    }

    // Split range
    List<String> parts = salaryRange.split('-').map((e) => e.trim()).toList();

    String formatAmount(String str) {
      final amount = int.tryParse(str);
      if (amount == null || amount == 0) return '';

      if (amount >= 100000) {
        double lacs = amount / 100000;
        return lacs.toStringAsFixed(lacs % 1 == 0 ? 0 : 1);
      } else if (amount >= 1000) {
        double thousands = amount / 1000;
        return '${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}K';
      } else {
        return amount.toString();
      }
    }

    String formattedRange = '';
    if (parts.length == 2) {
      String start = formatAmount(parts[0]);
      String end = formatAmount(parts[1]);
      if (end.isEmpty) {
        formattedRange = '$start$suffix';
      } else {
        formattedRange = '$start - $end$suffix';
      }
    } else {
      formattedRange = formatAmount(parts[0]) + suffix;
    }

    return formattedRange;
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Constants.subtitleclr,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: customTextForWeather(
            title: text,
            fontSize: 12,
            color: Constants.subtitleclr,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageRow(List<String> language) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomNetworkImage(
          imageUrl: "https://cdn-icons-png.flaticon.com/128/17390/17390484.png",
          defaultIcon: Icons.error_outline,
          height: 14,
        ),
        const SizedBox(width: 3),
        Expanded(
          child: customTextForWeather(
            title: language.length == 1
                ? language
                    .join(', ')
                    .replaceAll('"', '')
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                : language
                    .join(', ')
                    .replaceAll('"', '')
                    .replaceAll('[', '')
                    .replaceAll(']', ''),
            softwrap: true,
            overflow: TextOverflow.visible,
            fontSize: 12,
            color: Constants.subtitleclr,
          ),
        ),
      ],
    );
  }
}
