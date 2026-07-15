// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
import 'package:job_circle/web/web_screening_question_preview_page.dart';

class WebScreeningQuestionPage extends StatefulWidget {
  final List<JobDetailScreeningQuestion> questions;
  final ReferAddResumeModel candidateData;
  final int sharerUserId;

  const WebScreeningQuestionPage({
    super.key,
    required this.questions,
    required this.candidateData,
    required this.sharerUserId,
  });

  @override
  State<WebScreeningQuestionPage> createState() =>
      _WebScreeningQuestionPageState();
}

class _WebScreeningQuestionPageState extends State<WebScreeningQuestionPage> {
  int _currentPage = 0;
  static const _perPage = 4;

  final Map<int, List<String>> _selectedOptionsMap = {};
  final Map<int, int> _numericAnswersMap = {};

  static const _bg = Color(0xFFF4F6FB);
  static const _cardBg = Colors.white;
  static const _fieldBg = Color(0xFFF8F9FA);

  List<JobDetailScreeningQuestion> get _chunk {
    final start = _currentPage * _perPage;
    final end = (start + _perPage).clamp(0, widget.questions.length);
    return widget.questions.sublist(start, end);
  }

  bool get _isLastPage =>
      (_currentPage + 1) * _perPage >= widget.questions.length;

  int get _totalPages => (widget.questions.length / _perPage).ceil();

  bool _chunkAnswered() {
    for (final q in _chunk) {
      final qId = q.id ?? 0;
      if (q.questionType == 'NUMERIC') {
        if ((_numericAnswersMap[qId] ?? 0) <= 0) return false;
      } else {
        if ((_selectedOptionsMap[qId] ?? []).isEmpty) return false;
      }
    }
    return true;
  }

  void _onNext() {
    if (!_chunkAnswered()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please answer all questions to proceed.'),
          backgroundColor: Constants.orange,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    if (!_isLastPage) {
      setState(() => _currentPage++);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebScreeningQuestionPreviewPage(
            questions: widget.questions,
            selectedOptionsMap: _selectedOptionsMap,
            numericAnswersMap: _numericAnswersMap,
            candidateData: widget.candidateData,
            sharerUserId: widget.sharerUserId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
              child: Column(
                children: [
                  _buildBranding(),
                  const SizedBox(height: 24),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  ..._chunk.asMap().entries.map((e) {
                    final globalIdx = _currentPage * _perPage + e.key;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildQuestionCard(e.value, globalIdx),
                    );
                  }),
                  const SizedBox(height: 4),
                  _buildNextButton(),
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
            child:
                const Icon(Icons.work_rounded, color: Colors.white, size: 16),
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

  // ── Header card ────────────────────────────────────────────────────────────
  Widget _buildHeader() => Container(
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
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Constants.darkBlue,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.quiz_outlined,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Screening Questions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Page ${_currentPage + 1} of $_totalPages',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Please answer all questions to proceed',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // ── Question card ──────────────────────────────────────────────────────────
  Widget _buildQuestionCard(JobDetailScreeningQuestion q, int globalIdx) {
    final qId = q.id ?? 0;
    final userAnswers = _selectedOptionsMap[qId] ?? [];
    final numericVal = _numericAnswersMap[qId] ?? 0;

    final options = [
      {'key': 'A', 'text': q.optionA},
      {'key': 'B', 'text': q.optionB},
      {'key': 'C', 'text': q.optionC},
      {'key': 'D', 'text': q.optionD},
      {'key': 'E', 'text': q.optionE},
      {'key': 'F', 'text': q.optionF},
      {'key': 'G', 'text': q.optionG},
      {'key': 'H', 'text': q.optionH},
    ]..removeWhere((o) => o['text'] == null || o['text']!.isEmpty);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Constants.darkBlue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${globalIdx + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  q.questionText ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // YES / NO
          if (q.questionType == 'YES_NO')
            Row(
              children: [
                _toggleBtn('Yes', userAnswers.contains('A'),
                    () => setState(() => _selectedOptionsMap[qId] = ['A'])),
                const SizedBox(width: 12),
                _toggleBtn('No', userAnswers.contains('B'),
                    () => setState(() => _selectedOptionsMap[qId] = ['B'])),
              ],
            ),

          // SINGLE SELECT
          if (q.questionType == 'SINGLE_SELECT')
            Column(
              children: options
                  .map((o) => _optionTile(
                        o['key']!,
                        o['text']!,
                        userAnswers.contains(o['key']),
                        () => setState(
                            () => _selectedOptionsMap[qId] = [o['key']!]),
                      ))
                  .toList(),
            ),

          // MULTIPLE SELECT
          if (q.questionType == 'MULTIPLE_SELECT')
            Column(
              children: options
                  .map((o) => _checkboxTile(
                        o['key']!,
                        o['text']!,
                        userAnswers.contains(o['key']),
                        (checked) {
                          final cur = List<String>.from(userAnswers);
                          checked
                              ? cur.add(o['key']!)
                              : cur.remove(o['key']!);
                          setState(() => _selectedOptionsMap[qId] = cur);
                        },
                      ))
                  .toList(),
            ),

          // NUMERIC
          if (q.questionType == 'NUMERIC')
            SizedBox(
              width: 170,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                initialValue: numericVal > 0 ? numericVal.toString() : '',
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF1A1A2E)),
                decoration: InputDecoration(
                  hintText: 'Years of experience',
                  hintStyle: TextStyle(
                      fontSize: 12, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: _fieldBg,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Constants.darkBlue, width: 1.5),
                  ),
                ),
                onChanged: (v) => setState(
                    () => _numericAnswersMap[qId] = int.tryParse(v) ?? 0),
              ),
            ),
        ],
      ),
    );
  }

  // ── Option widgets ─────────────────────────────────────────────────────────
  Widget _toggleBtn(String label, bool selected, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Constants.darkBlue : _fieldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  selected ? Constants.darkBlue : Colors.grey.shade200,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      );

  Widget _optionTile(
    String key,
    String text,
    bool selected,
    VoidCallback onTap,
  ) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 8),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: selected
                ? Constants.darkBlue.withValues(alpha: 0.07)
                : _fieldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  selected ? Constants.darkBlue : Colors.grey.shade200,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? Constants.darkBlue
                      : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? Constants.darkBlue
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.circle,
                        color: Colors.white, size: 8)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    color: selected
                        ? Constants.darkBlue
                        : Colors.grey.shade800,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _checkboxTile(
    String key,
    String text,
    bool checked,
    void Function(bool) onChange,
  ) =>
      GestureDetector(
        onTap: () => onChange(!checked),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 8),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: checked
                ? Constants.darkBlue.withValues(alpha: 0.07)
                : _fieldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  checked ? Constants.darkBlue : Colors.grey.shade200,
              width: checked ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: checked
                      ? Constants.darkBlue
                      : Colors.transparent,
                  border: Border.all(
                    color: checked
                        ? Constants.darkBlue
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: checked
                    ? const Icon(Icons.check,
                        color: Colors.white, size: 12)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    color: checked
                        ? Constants.darkBlue
                        : Colors.grey.shade800,
                    fontWeight:
                        checked ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  // ── Bottom button ──────────────────────────────────────────────────────────
  Widget _buildNextButton() => GestureDetector(
        onTap: _onNext,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Constants.darkBlue, Color(0xFF1565C0)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Constants.darkBlue.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLastPage ? 'Review Answers' : 'Next',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isLastPage
                    ? Icons.rate_review_rounded
                    : Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 17,
              ),
            ],
          ),
        ),
      );

  Widget _buildFooter() => Text(
        '© Job Circle 2026 · All rights reserved',
        style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
      );
}
