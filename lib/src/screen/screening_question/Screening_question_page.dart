// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/job_provider/job_detail_provider.dart';
import 'package:job_circle/src/screen/screening_question/screening_question_preview_page.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

// ⚡ 1. Isko Stateful banaya taaki local page counter maintain ho sake
class ScreeningQuestionPage extends StatefulWidget {
  const ScreeningQuestionPage({super.key});

  @override
  State<ScreeningQuestionPage> createState() => _ScreeningQuestionPageState();
}

class _ScreeningQuestionPageState extends State<ScreeningQuestionPage> {
  int _currentPage = 0; // Current active page tracker
  final int _questionsPerPage = 4; // Max 4 questions limit rule

  @override
  void initState() {
    super.initState();
    // ⚡ 1. MAGIC LOGIC: Job Detail page se pehli baar yahan aane par saare purane answers reset ho jayenge.
    // WidgetsBinding ka use kiya taaki build cycle ke beech me provider state crash na ho.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<JobDetailProvider>();
      provider.selectedOptionsMap.clear();
      provider.numericAnswersMap.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final provider = context.watch<JobDetailProvider>();
    final allQuestions = provider.screeningQuestions;

    // ⚡ 2. Current page ke mutabik chunk/subset nikalna (Paging Core Logic)
    final int startIndex = _currentPage * _questionsPerPage;
    int endIndex = startIndex + _questionsPerPage;
    if (endIndex > allQuestions.length) {
      endIndex = allQuestions.length;
    }

    final currentQuestionsChunk = allQuestions.sublist(startIndex, endIndex);
    final bool isLastPage = endIndex >= allQuestions.length;

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
              title: "Screening Questions",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.headingColor,
            ),
            customText(
              title:
                  // "Page ${_currentPage + 1} of ${(allQuestions.length / _questionsPerPage).ceil()}",
                  "Please answer all the questions to proceed",
              fontSize: 12,
              color: colors.subtitleTextColor,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: colors.bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: CustomButtonForJobPosting(
          buttonText: isLastPage ? "Next to Review" : "Next",
          onTap: () {
            // ⚡ 2. VALIDATION CHECK: Current chunk ke saare questions verify karo
            bool allAnswered = true;
            for (var q in currentQuestionsChunk) {
              final qId = q.id ?? 0;
              if (q.questionType == "NUMERIC") {
                final numVal = provider.numericAnswersMap[qId] ?? 0;
                if (numVal <= 0) {
                  allAnswered = false;
                  break;
                }
              } else {
                final opts = provider.selectedOptionsMap[qId] ?? [];
                if (opts.isEmpty) {
                  allAnswered = false;
                  break;
                }
              }
            }

            // Agar koi bhi answer khali mila toh alert dekar rok do
            if (!allAnswered) {
              CustomSnackbar.show(
                "Please answer all questions on this page to proceed.",
                true,
              );
              return;
            }

            // Validation clear hone ke baad hi aage ka routing chalega
            if (!isLastPage) {
              setState(() {
                _currentPage++;
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreeningQuestionPreviewPage(),
                ),
              );
            }
          },
        ),
      ),
      /* if (!isLastPage) {
              // 🎯 Agar abhi aur questions bache hain toh naya chunk page kholo
              setState(() {
                _currentPage++;
              });
            } else {
              // 🎯 Agar aakhiri chunk page hai toh direct preview screen route karo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ScreeningQuestionPreviewPage(),
                ),
              );
            } */
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currentQuestionsChunk.length,
        itemBuilder: (context, index) {
          final q = currentQuestionsChunk[index];
          final qId = q.id ?? 0;
          // Global item mapping index system to keep item tags uniform across chunks
          final globalIndex = startIndex + index;
          final userAnswers = provider.selectedOptionsMap[qId] ?? [];
          final numericVal = provider.numericAnswersMap[qId] ?? 0;

          // ⚡ 3. Dynamic options parsing matrix setup up to H (Max 8 Options)
          final List<Map<String, String?>> availableOptions = [
            {"key": "A", "text": q.optionA},
            {"key": "B", "text": q.optionB},
            {"key": "C", "text": q.optionC},
            {"key": "D", "text": q.optionD},
            {"key": "E", "text": q.optionE},
            {"key": "F", "text": q.optionF},
            {"key": "G", "text": q.optionG},
            {"key": "H", "text": q.optionH},
          ]..removeWhere((opt) => opt["text"] == null || opt["text"]!.isEmpty);

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title: "Q ${globalIndex + 1} : ${q.questionText ?? ''}",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.headingColor,
                ),
                const SizedBox(height: 5),

                // ── CASE 1: YES / NO OPTION FLOW ──
                if (q.questionType == "YES_NO") ...[
                  Row(
                    children: [
                      CustomToggleButton(
                        isSelect: userAnswers.contains("A"),
                        title: "Yes",
                        onTap: () {
                          provider.updateOptionAnswer(qId, ["A"]);
                        },
                      ),
                      CustomToggleButton(
                        isSelect: userAnswers.contains("B"),
                        title: "No",
                        onTap: () {
                          provider.updateOptionAnswer(qId, ["B"]);
                        },
                      ),
                    ],
                  ),
                  Divider(color: colors.tabBorderColor),
                ],

                // ── CASE 2: SINGLE SELECT FLOW (Dynamic Options Loop) ──
                if (q.questionType == "SINGLE_SELECT") ...[
                  RadioGroup<String>(
                    groupValue: userAnswers.isNotEmpty ? userAnswers.first : '',
                    onChanged: (String? val) {
                      if (val != null) {
                        provider.updateOptionAnswer(qId, [val]);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: availableOptions.map((opt) {
                        return _buildNewOptionRow(
                          opt["key"]!,
                          opt["text"]!,
                          colors,
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(color: colors.tabBorderColor),
                ],

                // ── CASE 3: MULTIPLE SELECT FLOW (Dynamic Options Loop) ──
                if (q.questionType == "MULTIPLE_SELECT") ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: availableOptions.map((opt) {
                      return _buildCheckboxRow(
                        opt["key"]!,
                        opt["text"]!,
                        userAnswers,
                        (list) => provider.updateOptionAnswer(
                          qId,
                          list,
                          isMultiple: true,
                        ),
                        colors,
                      );
                    }).toList(),
                  ),
                  Divider(color: colors.tabBorderColor),
                ],

                // ── CASE 4: NUMERIC TEXTFIELD FLOW ──
                if (q.questionType == "NUMERIC") ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 150,
                    height: MediaQuery.of(context).size.height / 24,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      initialValue: numericVal > 0 ? numericVal.toString() : "",
                      style: TextStyle(color: colors.textfieldTextColor),
                      decoration: InputDecoration(
                        hintText: "Enter Experience in years",
                        hintStyle: TextStyle(
                          color: colors.subtitleTextColor,
                          fontSize: 12,
                        ),
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.bottomsheerCard1Color!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.bottomsheerCard1Color!,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.bottomsheerCard1Color!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.headingColor!),
                        ),
                      ),
                      onChanged: (val) {
                        int parsed = int.tryParse(val.trim()) ?? 0;
                        provider.updateNumericAnswer(qId, parsed);
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Radio tile builder for Single selection
  Widget _buildNewOptionRow(
    String optionKey,
    String? optionText,
    dynamic colors,
  ) {
    if (optionText == null || optionText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: optionKey,
            activeColor: colors.accentBlue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
          const SizedBox(width: 6),
          customText(
            title: optionText,
            fontSize: 13,
            color: colors.textPrimary,
          ),
        ],
      ),
    );
  }

  // Checkbox list compiler node logic block helper for multi select options
  Widget _buildCheckboxRow(
    String optionKey,
    String? optionText,
    List<String> currentAnswers,
    Function(List<String>) onUpdate,
    dynamic colors,
  ) {
    if (optionText == null || optionText.isEmpty) {
      return const SizedBox.shrink();
    }

    bool isChecked = currentAnswers.contains(optionKey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isChecked,
            activeColor: colors.accentBlue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            onChanged: (bool? val) {
              List<String> newList = List.from(currentAnswers);
              if (val == true) {
                newList.add(optionKey);
              } else {
                newList.remove(optionKey);
              }
              onUpdate(newList);
            },
          ),
          const SizedBox(width: 6),
          customText(
            title: optionText,
            fontSize: 13,
            color: colors.textPrimary,
          ),
        ],
      ),
    );
  }
}
