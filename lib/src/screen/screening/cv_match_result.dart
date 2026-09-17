import 'package:flutter/material.dart';
import 'package:job_circle/src/model/screening/cv_match_response_model.dart';
import 'package:job_circle/src/provider/screening/cv_screening_provider.dart';
import 'package:provider/provider.dart';

class CvMatchResultsScreen extends StatelessWidget {
  const CvMatchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = context.watch<CvScreeningProvider>().matchedJobs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Matched Jobs (${jobs.length})',
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: jobs.isEmpty
          ? const Center(
              child: Text(
                'No active jobs passed hard filtering criteria.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _JobMatchCard(job: jobs[index]),
            ),
    );
  }
}

class _JobMatchCard extends StatelessWidget {
  final CvJobMatchItem job;
  const _JobMatchCard({required this.job});

  Color _getScoreColor(double score) {
    if (score >= 70) return const Color(0xFF10B981);
    if (score >= 40) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(job.matchPercentage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.jobTitle ?? 'Job Role',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.companyName ?? 'Direct Employer',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt, color: scoreColor, size: 16),
                    Text(
                      '${job.matchPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: scoreColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (job.whyMatched.isNotEmpty ||
              job.missingRequirements.isNotEmpty) ...[
            const Divider(height: 20),
            if (job.whyMatched.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.whyMatched
                    .map(
                      (w) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '✔ $w',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            if (job.missingRequirements.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.missingRequirements
                    .take(3)
                    .map(
                      (m) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '✖ $m',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFB91C1C),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
