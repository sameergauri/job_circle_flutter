import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/business_ats/business_ats_model.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ScreeningQuestionAnswer extends StatelessWidget {
  final AtsApplicant applicantData;
  const ScreeningQuestionAnswer({super.key, required this.applicantData});

  @override
  Widget build(BuildContext context) {
    final screening = applicantData.screeningAnswers;
    final answers = screening?.answers ?? [];

    // Fallback if there is no screening data available
    if (screening == null || answers.isEmpty) {
      return Scaffold(
        body: Center(child: customText(title: "No screening data available")),
      );
    }

    final bool isPass = screening.isPass ?? false;
    final int score = screening.correctCount ?? 0;
    final int total = screening.totalQuestions ?? answers.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 1. Top Score Summary Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPass
                      ? [
                          const Color.fromARGB(255, 97, 161, 100),
                          const Color.fromARGB(255, 110, 176, 113),
                        ]
                      : [Colors.red.shade600, Colors.red.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (isPass ? Colors.green : Colors.red).withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Screening Assessment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Correct answers: $score out of $total",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Score Circular Progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: total > 0 ? (score / total) : 0,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      Text(
                        total > 0
                            ? "${((score / total) * 100).toInt()}%"
                            : "0%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. Questions List Block
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final currentAnswer = answers[index];
                final bool correct = currentAnswer.isCorrect ?? false;

                // Safely convert string value to matching Type Enum definition
                QuestionType mappedType;
                if (currentAnswer.questionType == "YES_NO") {
                  mappedType = QuestionType.YES_NO;
                } else if (currentAnswer.questionType == "MULTIPLE_SELECT") {
                  mappedType = QuestionType.MULTIPLE_SELECT;
                } else if (currentAnswer.questionType == "SINGLE_SELECT") {
                  mappedType = QuestionType.SINGLE_SELECT;
                } else {
                  mappedType = QuestionType.NUMERIC;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: customText(
                          title:
                              currentAnswer.questionText ??
                              "Missing Question Statement",
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // User's Submitted Answer Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildAnswerSection(
                          contents: _getOptionList(currentAnswer),
                          isSuccessColor: correct,
                          questionType: mappedType,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Returns raw list elements instead of joined string map
  List<String> _getOptionList(AnswerItemDto answer) {
    if (answer.questionType == "NUMERIC") {
      return [
        answer.numericAnswer != null
            ? answer.numericAnswer!.toInt().toString()
            : "No Input Provided",
      ];
    }
    if (answer.selectedOptionTexts.isNotEmpty) {
      return answer.selectedOptionTexts;
    }
    return ["No Answer Marked"];
  }

  // Modified dynamic display renderer containing individual row generators
  Widget _buildAnswerSection({
    required List<String> contents,
    required bool? isSuccessColor,
    required QuestionType questionType,
  }) {
    Color bg = Colors.grey.shade100;
    Color border = Colors.grey.shade200;
    Color textColor = Colors.grey.shade800;

    if (isSuccessColor != null) {
      bg = isSuccessColor
          ? Colors.green.shade50.withValues(alpha: 0.3)
          : Colors.red.shade50.withValues(alpha: 0.3);
      border = isSuccessColor ? Colors.green.shade100 : Colors.red.shade100;
      textColor = isSuccessColor ? Colors.green.shade900 : Colors.red.shade900;
    }

    // Generator function for standard row row layouts
    Widget rowContainer(String itemText) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8), // Margin gap between choices
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                itemText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: isSuccessColor != null && isSuccessColor
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSuccessColor != null && isSuccessColor
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: isSuccessColor != null && isSuccessColor
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isSuccessColor != null && isSuccessColor
                        ? "Qualify"
                        : "Disqualify",
                    style: TextStyle(
                      color: isSuccessColor != null && isSuccessColor
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Conditional processing rule
    if (questionType == QuestionType.MULTIPLE_SELECT) {
      return Column(
        children: contents.map((element) => rowContainer(element)).toList(),
      );
    }

    // Default fallback layout block
    return rowContainer(contents.first);
  }
}
