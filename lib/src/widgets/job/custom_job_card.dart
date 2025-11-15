// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_home_page_model.dart';
import 'package:job_circle/src/model/job_model/recommend_job_model.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class CustomJobCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                    Constants.darkBlue.withValues(alpha: 0.04),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.network(
                    CustomIconUrl.skillicon,
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                    color: Constants.white,
                  ),
                  const SizedBox(width: 5),
                  const customText(
                    title: "Premium Hiring",
                    color: Constants.white,
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: job.companyIcon != null && job.companyIcon != ""
                  ? CustomNetworkImage(
                      imageUrl:
                          "${GlobalConstants.Image_url}${job.companyIcon}",
                      defaultIcon: Icons.home,
                    )
                  : Image.network(
                      CustomIconUrl.companyicon,
                      fit: BoxFit.contain,
                    ),
            ),
            title: customText(
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
                          final userId = SharedPrefsHelper.getInt(
                            ESharedPreferences.user_id,
                          );

                          if (userId != null) {
                            if (job.id == null ||
                                (job.isFavorite == true &&
                                    job.favJobId == null)) {
                              CustomSnackbar.show("Invalid JobData", true);
                              return;
                            }

                            isLoading.value = true;
                            bool success;
                            String actionMessage;

                            final jobProvider = Provider.of<JobProvider>(
                              context,
                              listen: false,
                            );

                            if (job.isFavorite == true) {
                              final result = await jobProvider
                                  .removeFavoriteJob(favId: job.favJobId ?? 0);

                              success = result['success'] as bool;
                              final wasLastSavedJob =
                                  result['wasLastSavedJob'] as bool;

                              actionMessage = success
                                  ? "Job removed from favorites"
                                  : "Failed to remove job from favorites";

                              if (wasLastSavedJob &&
                                  onLastFavoriteRemoved != null) {
                                onLastFavoriteRemoved!();
                              }
                            } else {
                              success = await jobProvider.saveFavoriteJob(
                                userId: int.parse(userId.toString()),
                                jobId: job.id ?? 0,
                              );
                              actionMessage = success
                                  ? "Job saved to favorites"
                                  : "Failed to save job to favorites";
                            }

                            isLoading.value = false;
                            /* if (success) {
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
                              ? CustomIconUrl.savedicon
                              : CustomIconUrl.saveicon,
                          defaultIcon: job.isFavorite == true
                              ? Icons.bookmark_outlined
                              : Icons.bookmark_border_outlined,
                        ),
                      );
              },
            ),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(
            Icons.work_outline_outlined,
            formatExperience(
              job.experienceRequired.toString().replaceAll('Years', 'yrs'),
            ),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.currency_rupee, _formatSalary(job.salaryRange)),
          const SizedBox(height: 5),
          _buildInfoRow(
            Icons.location_on_outlined,
            job.locationWithWorkType ?? '',
          ),
          const SizedBox(height: 5),
          if (job.languages != null && job.languages != "[]") ...[
            Builder(
              builder: (context) {
                List<String> languages = List<String>.from(
                  jsonDecode(job.languages!),
                );
                List<String> filteredLanguages = languages
                    .map((e) => e.trim())
                    .where(
                      (lang) => ![
                        "english",
                        "hindi",
                        "marathi",
                      ].contains(lang.toLowerCase()),
                    )
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
              const customText(title: "Skills : "),
              ...skills.take(10).toList().asMap().entries.map((entry) {
                final skillIndex = entry.key;
                final value = entry.value;
                final isLast = skillIndex == skills.take(10).length - 1;
                return customText(
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
    return exp;
  }

  String _formatSalary(String? salaryRange) {
    if (salaryRange == null || salaryRange.isEmpty) return '';

    String suffix = '';
    if (salaryRange.endsWith(' 0')) {
      suffix = ' LPA';
      salaryRange = salaryRange.replaceFirst(RegExp(r'\s0$'), '');
    } else if (salaryRange.endsWith(' 1')) {
      suffix = ' per month';
      salaryRange = salaryRange.replaceFirst(RegExp(r'\s1$'), '');
    }

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
        Icon(icon, size: 18, color: Constants.subtitleclr),
        const SizedBox(width: 5),
        Expanded(
          child: customText(
            title: text.replaceAll('(OnSite)', '(Onsite)'),
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
          imageUrl: CustomIconUrl.languageicon,
          defaultIcon: Icons.error_outline,
          height: 14,
        ),
        const SizedBox(width: 3),
        Expanded(
          child: customText(
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

// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison

class CustomRecommendJobcard extends StatelessWidget {
  final Recommendation job;
  final List<String> skills;
  final VoidCallback? onLastFavoriteRemoved;

  const CustomRecommendJobcard({
    super.key,
    required this.job,
    required this.skills,
    this.onLastFavoriteRemoved,
  });

  @override
  Widget build(BuildContext context) {
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
                    Constants.darkBlue.withValues(alpha: 0.04),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.network(
                    CustomIconUrl.skillicon,
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                    color: Constants.white,
                  ),
                  const SizedBox(width: 5),
                  const customText(
                    title: "Premium Hiring",
                    color: Constants.white,
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: job.companyIcon != null && job.companyIcon != ""
                  ? CustomNetworkImage(
                      imageUrl:
                          "${GlobalConstants.Image_url}${job.companyIcon}",
                      defaultIcon: Icons.home,
                    )
                  : Image.network(
                      CustomIconUrl.companyicon,
                      fit: BoxFit.contain,
                    ),
            ),
            title: customText(
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
                          final userId = SharedPrefsHelper.getInt(
                            ESharedPreferences.user_id,
                          );

                          if (userId != null) {
                            if (job.id == null ||
                                (job.isFavorite == true &&
                                    job.favJobId == null)) {
                              CustomSnackbar.show("Invalid JobData", true);
                              return;
                            }

                            isLoading.value = true;
                            bool success;
                            String actionMessage;

                            final jobProvider = Provider.of<JobProvider>(
                              context,
                              listen: false,
                            );

                            if (job.isFavorite == 1) {
                              final result = await jobProvider
                                  .removeFavoriteJob(favId: job.favJobId ?? 0);

                              success = result['success'] as bool;
                              final wasLastSavedJob =
                                  result['wasLastSavedJob'] as bool;

                              actionMessage = success
                                  ? "Job removed from favorites"
                                  : "Failed to remove job from favorites";

                              if (wasLastSavedJob &&
                                  onLastFavoriteRemoved != null) {
                                onLastFavoriteRemoved!();
                              }
                            } else {
                              success = await jobProvider.saveFavoriteJob(
                                userId: int.parse(userId.toString()),
                                jobId: job.id ?? 0,
                              );
                              actionMessage = success
                                  ? "Job saved to favorites"
                                  : "Failed to save job to favorites";
                            }

                            isLoading.value = false;
                            /* if (success) {
                              CustomSnackbar.show(actionMessage, false);
                            } */
                          }
                        },
                        child: CustomNetworkImage(
                          height: 20,
                          width: 20,
                          color: job.isFavorite == 1
                              ? Constants.darkBlue
                              : Constants.subtitleclr,
                          imageUrl: job.isFavorite == 1
                              ? CustomIconUrl.savedicon
                              : CustomIconUrl.saveicon,
                          defaultIcon: job.isFavorite == 1
                              ? Icons.bookmark_outlined
                              : Icons.bookmark_border_outlined,
                        ),
                      );
              },
            ),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(
            Icons.work_outline_outlined,
            formatExperience(
              job.requiredExperience.toString().replaceAll('Years', 'yrs'),
            ),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.currency_rupee, _formatSalary(job.salaryRange)),
          const SizedBox(height: 5),
          _buildInfoRow(
            Icons.location_on_outlined,
            job.locationWithWorkType ?? '',
          ),
          const SizedBox(height: 5),
          if (job.languages != null && job.languages != "[]") ...[
            Builder(
              builder: (context) {
                List<String> languages = List<String>.from((job.languages!));
                List<String> filteredLanguages = languages
                    .map((e) => e.trim())
                    .where(
                      (lang) => ![
                        "english",
                        "hindi",
                        "marathi",
                      ].contains(lang.toLowerCase()),
                    )
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
              const customText(title: "Skills : "),
              ...skills.take(10).toList().asMap().entries.map((entry) {
                final skillIndex = entry.key;
                final value = entry.value;
                final isLast = skillIndex == skills.take(10).length - 1;
                return customText(
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
    return exp;
  }

  String _formatSalary(String? salaryRange) {
    if (salaryRange == null || salaryRange.isEmpty) return '';

    // Normalize and clean input
    salaryRange = salaryRange
        .replaceAll(RegExp(r'[₹$,]'), '') // remove ₹, commas, etc.
        .replaceAll(RegExp(r'\bper\s*month\b', caseSensitive: false), ' PM')
        .replaceAll(RegExp(r'\bper\s*annum\b', caseSensitive: false), ' PA')
        .trim();

    // Determine suffix
    String suffix = '';
    if (RegExp(r'(LPA|PA)', caseSensitive: false).hasMatch(salaryRange)) {
      suffix = ' LPA';
      salaryRange = salaryRange
          .replaceAll(RegExp(r'\s*(LPA|PA)', caseSensitive: false), '')
          .trim();
    } else if (RegExp(r'PM', caseSensitive: false).hasMatch(salaryRange)) {
      suffix = ' per month';
      salaryRange = salaryRange
          .replaceAll(RegExp(r'\s*PM', caseSensitive: false), '')
          .trim();
    }

    // Split range
    List<String> parts = salaryRange.split('-').map((e) => e.trim()).toList();

    String formatAmount(String str) {
      final amount = double.tryParse(str);
      if (amount == null || amount == 0) return '';

      if (suffix == ' LPA') {
        double lacs = amount / 100000;
        return lacs.toStringAsFixed(lacs % 1 == 0 ? 0 : 1);
      } else {
        double thousands = amount / 1000;
        return '${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}k';
      }
    }

    String formattedRange;
    if (parts.length == 2) {
      String start = formatAmount(parts[0]);
      String end = formatAmount(parts[1]);

      if (start.isEmpty && end.isEmpty) return '';
      if (end.isEmpty) {
        formattedRange = '$start$suffix';
      } else if (start.isEmpty) {
        formattedRange = '$end$suffix';
      } else {
        formattedRange = '$start - $end$suffix';
      }
    } else {
      formattedRange = formatAmount(parts[0]) + suffix;
    }

    return formattedRange.trim();
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Constants.subtitleclr),
        const SizedBox(width: 5),
        Expanded(
          child: customText(
            title: text.replaceAll('(OnSite)', '(Onsite)'),
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
          imageUrl: CustomIconUrl.languageicon,
          defaultIcon: Icons.error_outline,
          height: 14,
        ),
        const SizedBox(width: 3),
        Expanded(
          child: customText(
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
