// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
import 'package:job_circle/src/services/referal_and_apply/add_resume_and_apply_services.dart';

class WebScreeningQuestionPreviewPage extends StatefulWidget {
  final List<JobDetailScreeningQuestion> questions;
  final Map<int, List<String>> selectedOptionsMap;
  final Map<int, int> numericAnswersMap;
  final ReferAddResumeModel candidateData;
  final int sharerUserId;

  const WebScreeningQuestionPreviewPage({
    super.key,
    required this.questions,
    required this.selectedOptionsMap,
    required this.numericAnswersMap,
    required this.candidateData,
    required this.sharerUserId,
  });

  @override
  State<WebScreeningQuestionPreviewPage> createState() =>
      _WebScreeningQuestionPreviewPageState();
}

class _WebScreeningQuestionPreviewPageState
    extends State<WebScreeningQuestionPreviewPage> {
  bool _isSubmitting = false;
  bool _submitted = false;

  static const _bg = Color(0xFFF4F6FB);
  static const _cardBg = Colors.white;
  static const _successGreen = Color(0xFF2E7D32);
  static const _successGreenBg = Color(0xFFE8F5E9);

  // ── Eligibility check (mirrors JobDetailProvider.isEligible) ──────────────
  bool _isEligible() {
    for (final q in widget.questions) {
      if (q.allowToLead != true) continue;
      final qId = q.id ?? 0;
      if (q.questionType == 'NUMERIC') {
        final userAnswer = widget.numericAnswersMap[qId] ?? 0;
        final threshold = q.numericOption ?? 0;
        if (userAnswer <= threshold) return false;
      } else {
        final userSelected = widget.selectedOptionsMap[qId] ?? [];
        final correct = q.correctOptions ?? [];
        final allCorrect = correct.every((c) => userSelected.contains(c));
        if (!allCorrect) return false;
      }
    }
    return true;
  }

  String _answerText(JobDetailScreeningQuestion q) {
    final qId = q.id ?? 0;
    if (q.questionType == 'NUMERIC') {
      final val = widget.numericAnswersMap[qId] ?? 0;
      return val > 0 ? '$val year${val == 1 ? '' : 's'}' : 'Not answered';
    }
    final opts = widget.selectedOptionsMap[qId] ?? [];
    if (opts.isEmpty) return 'Not answered';
    return opts
        .map((o) {
          if (o == 'A') return q.optionA ?? 'Yes';
          if (o == 'B') return q.optionB ?? 'No';
          if (o == 'C') return q.optionC ?? '';
          if (o == 'D') return q.optionD ?? '';
          if (o == 'E') return q.optionE ?? '';
          if (o == 'F') return q.optionF ?? '';
          if (o == 'G') return q.optionG ?? '';
          if (o == 'H') return q.optionH ?? '';
          return o;
        })
        .where((s) => s.isNotEmpty)
        .join(', ');
  }

  Map<String, dynamic> _buildScreeningPayload() {
    final answers = widget.questions.map((q) {
      final qId = q.id ?? 0;
      return {
        'screeningQuestionId': qId,
        'selectedOptions': widget.selectedOptionsMap[qId] ?? [],
        'numericAnswer': widget.numericAnswersMap[qId] ?? 0,
      };
    }).toList();

    return {'isEligible': _isEligible(), 'answers': answers};
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final modelWithScreening = widget.candidateData.copyWithScreeningAnswer(
        _buildScreeningPayload(),
      );

      final res = await AddResumeAndApplyService.referAndAddResume(
        jsonData: modelWithScreening,
        refId: widget.sharerUserId,
      );
      if (!mounted) return;
      if (res == '200') {
        setState(() => _submitted = true);
      } else {
        _snack('Submission failed. Please try again.', isError: true);
      }
    } catch (e) {
      if (mounted) _snack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Constants.red : Constants.darkBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final eligible = _isEligible();

    if (_submitted) return _successScreen(eligible);

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
              child: Column(
                children: [
                  _buildBranding(),
                  const SizedBox(height: 24),
                  /*  _buildEligibilityCard(eligible),
                  const SizedBox(height: 20), */
                  _buildAnswersCard(),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                  const SizedBox(height: 32),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Branding ───────────────────────────────────────────────────────────────
  Widget _buildBranding() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Constants.darkBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.work_rounded, color: Colors.white, size: 16),
      ),
      const SizedBox(width: 8),
      const Text(
        'Job Circle',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Constants.darkBlue,
        ),
      ),
    ],
  );

  /*   // ── Eligibility banner ─────────────────────────────────────────────────────
  Widget _buildEligibilityCard(bool eligible) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: eligible ? _successGreenBg : const Color(0xFFFFF3E0),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: eligible
            ? _successGreen.withValues(alpha: 0.35)
            : Constants.orange.withValues(alpha: 0.5),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: eligible ? _successGreen : Constants.orange,
            shape: BoxShape.circle,
          ),
          child: Icon(
            eligible ? Icons.check_circle_outline : Icons.info_outline,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eligible ? "You're Eligible!" : 'Review Your Answers',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: eligible ? _successGreen : Constants.orange,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                eligible
                    ? 'Your answers meet the job requirements. Submit to apply.'
                    : 'Some answers may not meet the criteria, but you can still apply.',
                style: TextStyle(
                  fontSize: 12,
                  color: eligible
                      ? _successGreen.withValues(alpha: 0.8)
                      : Colors.orange.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ); */

  // ── Answers review card ────────────────────────────────────────────────────
  Widget _buildAnswersCard() => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: _cardBg,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // Header bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Constants.darkBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: const Row(
            children: [
              Icon(Icons.rate_review_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text(
                'Review Your Answers',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Q&A list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: widget.questions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final q = widget.questions[index];
            final answer = _answerText(q);
            final notAnswered = answer == 'Not answered';

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Constants.darkBlue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          q.questionText ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Answer: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          answer,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: notAnswered
                                ? Constants.red
                                : Constants.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // ── Submit button ──────────────────────────────────────────────────────────
  Widget _buildSubmitButton() => GestureDetector(
    onTap: _isSubmitting ? null : _submit,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isSubmitting
              ? [Colors.grey.shade400, Colors.grey.shade400]
              : [Constants.darkBlue, const Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isSubmitting
            ? []
            : [
                BoxShadow(
                  color: Constants.darkBlue.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _isSubmitting
            ? [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ]
            : [
                const Icon(Icons.send_rounded, color: Colors.white, size: 17),
                const SizedBox(width: 8),
                const Text(
                  'Submit Application',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
      ),
    ),
  );

  Widget _buildFooter() => Text(
    '© Job Circle 2026 · All rights reserved',
    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
  );

  // ── Success screen ─────────────────────────────────────────────────────────
  Widget _successScreen(bool isEligible) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: _successGreenBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEligible
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: isEligible ? _successGreen : Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isEligible ? 'Application Submitted!' : 'Not Shortlisted',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              isEligible
                  ? "We've received your application.\nSomeone will get in touch with you soon."
                  : "Thank you for your interest in this opportunity. Based on your screening responses, you have not been shortlisted for this position. We appreciate your interest and wish you success in your job search.",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Powered by Job Circle',
                style: TextStyle(
                  color: Constants.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
