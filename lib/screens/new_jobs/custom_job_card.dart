// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_home_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/themes/colors.dart';

class CustomJobCard extends ConsumerWidget {
  final JobContent job;
  final List<String> skills;

  const CustomJobCard({
    super.key,
    required this.job,
    required this.skills,
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
                gradient: LinearGradient(
                  colors: [
                    Constants.orange,
                    Constants.orange.withOpacity(0.03),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.network(
                    'https://assets.api.uizard.io/api/cdn/stream/a8ac9b17-39f2-4c95-a432-2d18cd35abd4.png',
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                    color: Constants.bgColorWhite,
                  ),
                  const SizedBox(width: 5),
                  const customTextForWeather(
                    title: "Urgent Hiring",
                    color: Constants.bgColorWhite,
                  ),
                ],
              ),
            ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.lightdull,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/128/14644/14644423.png",
                height: 25,
                width: 25,
                fit: BoxFit.cover,
              ),
            ),
            title: customTextForWeather(
              title: job.jobHeadline ?? '',
              fontWeight: FontWeight.w700,
              maxlines: 2,
              overflow: TextOverflow.ellipsis,
              fontSize: job.jobHeadline!.length < 30 ? 16 : 14,
            ),
            trailing: ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, loading, child) {
                return loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Constants.orange,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Invalid job data")),
                              );
                              return;
                            }

                            isLoading.value = true; // Start loading
                            bool success;
                            String actionMessage;
                            if (job.isFavorite == true) {
                              success = await ref
                                  .read(jobListProvider.notifier)
                                  .removeFavoriteJob(favid: job.favJobId ?? 0);
                              actionMessage = success
                                  ? "Job removed from favorites"
                                  : "Failed to remove job from favorites";
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
                            isLoading.value = false; // Stop loading
                          } else {}
                        },
                        child: Icon(
                          job.isFavorite == true
                              ? Icons.bookmark_outlined
                              : Icons.bookmark_border_outlined,
                          color: job.isFavorite == true
                              ? Constants.darkBlue
                              : Constants.subtitleclr,
                        ),
                      );
              },
            ),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(
              Icons.work_outline_outlined, job.experienceRequired.toString()),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.currency_rupee, _formatSalary(job.salaryRange)),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.location_on_outlined, job.location ?? ''),
          const SizedBox(height: 5),
          if (job.languages != null && job.languages != "[]")
            _buildLanguageRow(
                job.languages!.split(',').map((e) => e.trim()).toList()),
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

  String _formatSalary(String? salaryRange) {
    if (salaryRange == null) return '';

    String cleanedSalary = salaryRange;

    // Remove " - 0" from range
    if (cleanedSalary.contains('- 0')) {
      cleanedSalary = cleanedSalary.replaceFirst(RegExp(r'\s*-\s*0'), '');
    }

    // Trim trailing " 0" or " 1" and append appropriate suffix
    if (cleanedSalary.endsWith(' 0')) {
      cleanedSalary = cleanedSalary.replaceFirst(RegExp(r'\s0$'), ' PA');
    } else if (cleanedSalary.endsWith(' 1')) {
      cleanedSalary = cleanedSalary.replaceFirst(RegExp(r'\s1$'), ' PM');
    }

    return cleanedSalary;
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
          height: 16,
        ),
        const SizedBox(width: 8),
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
