import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/job_provider/job_detail_provider.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class ScreeningQuestionPreviewPage extends StatelessWidget {
  final int? refid;
  const ScreeningQuestionPreviewPage({super.key,this.refid});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final provider = context.watch<JobDetailProvider>();
    final questions = provider.screeningQuestions;
    final userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    final jobId = provider.jobDetail?.id ?? 0;

    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: colors.appbarColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.headingColor),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              title: "Review your Answers",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.headingColor,
            ),
            customText(
              title:
                  // "Page ${_currentPage + 1} of ${(allQuestions.length / _questionsPerPage).ceil()}",
                  "Please check your answers before submitting your application",
              fontSize: 12,
              color: colors.subtitleTextColor,
              fontStyle: FontStyle.italic,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: colors.bgColor,
        child: provider.applyLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomButtonForJobPosting(
                buttonText: "Submit",
                onTap: () {
                  provider.submitApplicationWithScreening(
                    jobId,
                    userId,
                    context,
                    provider.isEligible(),
                    refid,
                  );
                },
              ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          // 1. Check if we have iterated past all items to render the custom trailing element
          if (index == questions.length) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Divider(color: colors.appbarColor, thickness: 6),
                ),
              ],
            );
          }
          final q = questions[index];
          final qId = q.id ?? 0;

          // Data interpretation logic blocks mapping for readable dynamic summary preview text output
          String answerString = "Not Answered";
          if (q.questionType == "NUMERIC") {
            int numAns = provider.numericAnswersMap[qId] ?? 0;
            answerString = numAns > 0 ? numAns.toString() : "Not Answered";
          } else {
            List<String> opts = provider.selectedOptionsMap[qId] ?? [];
            if (opts.isNotEmpty) {
              // Map index array key references keys to exact structural literal choices text strings
              answerString = opts
                  .map((o) {
                    if (o == "A") return q.optionA ?? "Yes";
                    if (o == "B") return q.optionB ?? "No";
                    if (o == "C") return q.optionC ?? "";
                    if (o == "D") return q.optionD ?? "";
                    return o;
                  })
                  .where((element) => element.isNotEmpty)
                  .join(", ");
            }
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.subTitleColor ?? Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title: "Q: ${q.questionText ?? ''}",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.headingColor,
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: "Answer: ",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    Expanded(
                      child: customText(
                        title: answerString,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.headingColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
