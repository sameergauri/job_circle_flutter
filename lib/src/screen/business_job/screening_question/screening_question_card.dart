import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ScreeningQuestionCard extends StatelessWidget {
  final JobDetailScreeningQuestion question;
  final int index;

  const ScreeningQuestionCard({
    super.key,
    required this.question,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.appbarColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.subTitleColor!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: customText(
                  title: question.questionText ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.headingColor,
                ),
              ),
              if (question.required == true) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const customText(
                    title: 'Must Qualify',
                    fontSize: 10,
                    color: Color(0xFFD97706),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _buildAnswerSection(),
        ],
      ),
    );
  }

  Widget _buildAnswerSection() {
    final type = (question.questionType ?? '').toUpperCase();
    if (type == 'YES_NO') return _buildBooleanOptions();
    if (type == 'NUMERIC') return _buildNumericOption();
    if (type == 'SINGLE_SELECT') {
      return _buildMcqOptions(false);
    }
    if (type == 'MULTIPLE_SELECT') return _buildMcqOptions(true);
    return _buildMcqOptions(true);
  }

  Widget _buildMcqOptions(bool isMultiple) {
    final labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    final values = [
      question.optionA,
      question.optionB,
      question.optionC,
      question.optionD,
      question.optionE,
      question.optionF,
      question.optionG,
      question.optionH,
    ];

    final options = <MapEntry<String, String>>[];
    for (int i = 0; i < values.length; i++) {
      if (values[i] != null && values[i]!.isNotEmpty) {
        options.add(MapEntry(labels[i], values[i]!));
      }
    }

    if (options.isEmpty) return const SizedBox.shrink();

    return Column(
      children: options
          .map(
            (opt) => isMultiple
                ? _buildOptionRowForMultiple(opt.key, opt.value)
                : _buildOptionRowForSingle(opt.key, opt.value),
          )
          .toList(),
    );
  }

  Widget _buildOptionRowForSingle(String label, String text) {
    final correctList = question.correctOptions ?? [];
    final isCorrect = correctList.contains(label);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isCorrect ? const Color(0xFF10B981) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFD1D5DB),
              ),
            ),
            child: Center(
              child: isCorrect
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : customText(
                      title: label,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: customText(
              title: text,
              fontSize: 13,
              color: isCorrect
                  ? const Color(0xFF065F46)
                  : const Color(0xFF374151),
              fontWeight: isCorrect ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          if (isCorrect)
            const customText(
              title: 'Correct',
              fontSize: 11,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w600,
            ),
        ],
      ),
    );
  }

  Widget _buildOptionRowForMultiple(String label, String text) {
    final correctList = question.correctOptions ?? [];
    final isCorrect = correctList.contains(label);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isCorrect ? const Color(0xFF10B981) : Colors.white,
              border: Border.all(
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFD1D5DB),
              ),
            ),
            child: Center(
              child: isCorrect
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : customText(
                      title: label,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: customText(
              title: text,
              fontSize: 13,
              color: isCorrect
                  ? const Color(0xFF065F46)
                  : const Color(0xFF374151),
              fontWeight: isCorrect ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          if (isCorrect)
            const customText(
              title: 'Correct',
              fontSize: 11,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w600,
            ),
        ],
      ),
    );
  }

  Widget _buildBooleanOptions() {
    final correctList = question.correctOptions ?? [];
    final yesCorrect = correctList.any(
      (e) =>
          e.toLowerCase() == 'yes' ||
          e.toLowerCase() == 'true' ||
          e.toUpperCase() == "A",
    );
    final noCorrect = correctList.any(
      (e) => e.toLowerCase() == 'no' || e.toLowerCase() == 'false',
    );

    return Row(
      children: [
        _buildBoolChip('Yes', yesCorrect),
        const SizedBox(width: 10),
        _buildBoolChip('No', noCorrect),
      ],
    );
  }

  Widget _buildBoolChip(String label, bool isCorrect) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCorrect) ...[
            const Icon(Icons.check_circle, size: 14, color: Color(0xFF10B981)),
            const SizedBox(width: 4),
          ],
          customText(
            title: label,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isCorrect
                ? const Color(0xFF065F46)
                : const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericOption() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF7DD3FC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tag, size: 16, color: Color(0xFF0369A1)),
          const SizedBox(width: 8),
          customText(
            title: question.numericOption != null
                ? question.numericOption! % 1 == 0
                      ? question.numericOption!.toInt().toString()
                      : question.numericOption!.toStringAsFixed(2)
                : 'Numeric Answer',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0369A1),
          ),
        ],
      ),
    );
  }
}
