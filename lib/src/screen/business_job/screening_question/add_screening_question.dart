import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/model/business_job/master_screening_question.dart';
import 'package:job_circle/src/model/business_job/temp_screening_question_model.dart';
import 'package:job_circle/src/provider/business_job/screening_question_provider.dart';
import 'package:job_circle/src/screen/business_job/screening_question/custom_suggestion_question.dart';
import 'package:job_circle/src/widgets/button/custom_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class AddScreeningQuestion extends StatefulWidget {
  final MasterScreeningQuestion? masterScreeningQuestion;
  final VoidCallback? afterSave;

  const AddScreeningQuestion({
    super.key,
    this.masterScreeningQuestion,
    this.afterSave,
  });

  @override
  State<AddScreeningQuestion> createState() => _AddScreeningQuestionState();
}

class _AddScreeningQuestionState extends State<AddScreeningQuestion> {
  bool get isFromMaster => widget.masterScreeningQuestion != null;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ScreeningQuestionProvider>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (isFromMaster) {
        provider.loadFromMaster(widget.masterScreeningQuestion!);
      } else if (!provider.isEditing) {
        provider.clearForm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final provider = Provider.of<ScreeningQuestionProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        provider.clearForm();
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: customButton(
          onTap: () {
            provider.saveQuestion(context, afterSave: widget.afterSave);
          },
          title: "Save",
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: colors.bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: colors.appbarColor,
          elevation: 0,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: colors.headingColor),
          title: customText(
            title: provider.isEditing
                ? "Edit Screening Question"
                : "Add Screening Question",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.headingColor,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title: "Question",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.headingColor,
                ),
                const SizedBox(height: 6),
                CustomSuggestionForQuestions(
                  controller: provider.questionController,
                  contextIn: context,
                  isDisabled: !isFromMaster,
                ),
                const SizedBox(height: 16),
                customText(
                  title: "Answer type",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.headingColor,
                ),
                const SizedBox(height: 6),
                IgnorePointer(
                  ignoring:
                      isFromMaster &&
                      widget.masterScreeningQuestion!.questionType == "YES_NO",
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AnswerType>(
                        dropdownColor: colors.bottomsheetbgColor,
                        isDense: true,
                        value: provider.selectedAnswerType,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: AnswerType.yesNo,
                            child: customText(
                              title: "Yes / No",
                              color: colors.headingColor,
                            ),
                          ),
                          DropdownMenuItem(
                            value: AnswerType.singleChoice,
                            child: customText(
                              title: "Single Choice",
                              color: colors.headingColor,
                            ),
                          ),
                          DropdownMenuItem(
                            value: AnswerType.multipleChoice,
                            child: customText(
                              title: "Multiple Choice",
                              color: colors.headingColor,
                            ),
                          ),
                          DropdownMenuItem(
                            value: AnswerType.numeric,
                            child: customText(
                              title: "Numeric",
                              color: colors.headingColor,
                            ),
                          ),
                        ],
                        onChanged: (type) {
                          if (type != null) provider.changeAnswerType(type);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                if (provider.selectedAnswerType == AnswerType.singleChoice ||
                    provider.selectedAnswerType ==
                        AnswerType.multipleChoice) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.currentOptions.length,
                    itemBuilder: (context, index) {
                      final isRowBeingEdited =
                          provider.editingOptionIndex == index;

                      return CustomListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          provider.selectedAnswerType == AnswerType.singleChoice
                              ? Icons.radio_button_off
                              : Icons.check_box_outline_blank,
                        ),
                        title: isRowBeingEdited
                            ? CustomTextFieldforAll(
                                controller: provider.inlineOptionController,
                                hint: "Edit option",
                                onFieldSubmitted: (_) =>
                                    provider.submitInlineOption(),
                              )
                            : InkWell(
                                onTap: () => provider.startEditingOption(index),
                                child: customText(
                                  title: provider.currentOptions[index],
                                  fontSize: 12,
                                  color: colors.headingColor,
                                ),
                              ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isRowBeingEdited)
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                onPressed: () => provider.submitInlineOption(),
                              ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 18,
                              ),
                              onPressed: () => provider.removeOption(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (provider.isAddingNewOption) ...[
                    Row(
                      children: [
                        Icon(
                          provider.selectedAnswerType == AnswerType.singleChoice
                              ? Icons.radio_button_off
                              : Icons.check_box_outline_blank,
                          color: colors.subTitleColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFieldforAll(
                            controller: provider.inlineOptionController,
                            hint: "Type option and press enter",
                            onFieldSubmitted: (_) =>
                                provider.submitInlineOption(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => provider.submitInlineOption(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => provider.cancelInlineEditing(),
                        ),
                      ],
                    ),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => provider.showNewOptionField(),
                      child: const customText(
                        title: "+ Add more choice",
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
                const SizedBox(height: 8),
                customText(
                  title: "Ideal answer*",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colors.headingColor,
                ),
                const SizedBox(height: 8),
                if (provider.selectedAnswerType == AnswerType.yesNo) ...[
                  if (isFromMaster &&
                      widget.masterScreeningQuestion!.questionType == "YES_NO")
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.subTitleColor!),
                      ),
                      width: double.infinity,
                      child: customText(
                        title: 'Yes',
                        color: colors.headingColor,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.subTitleColor!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: customText(
                            title: "Select ideal answer",
                            color: colors.subTitleColor,
                          ),
                          dropdownColor: colors.bottomsheetbgColor,
                          isDense: true,
                          value: provider.selectedIdealAnswers.isNotEmpty
                              ? provider.selectedIdealAnswers.first
                              : 'Yes',
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: 'Yes',
                              child: customText(
                                title: 'Yes',
                                color: colors.headingColor,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'No',
                              child: customText(
                                title: 'No',
                                color: colors.headingColor,
                              ),
                            ),
                          ],
                          onChanged: (val) =>
                              provider.setSingleIdealAnswer(val ?? 'Yes'),
                        ),
                      ),
                    ),
                ] else if (provider.selectedAnswerType ==
                    AnswerType.singleChoice) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: colors.bottomsheetbgColor,
                        isDense: true,
                        value:
                            provider.selectedIdealAnswers.isNotEmpty &&
                                provider.currentOptions.contains(
                                  provider.selectedIdealAnswers.first,
                                )
                            ? provider.selectedIdealAnswers.first
                            : null,
                        isExpanded: true,
                        items: provider.currentOptions.map((opt) {
                          return DropdownMenuItem(
                            value: opt,
                            child: customText(
                              title: opt,
                              color: colors.headingColor,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) provider.setSingleIdealAnswer(val);
                        },
                      ),
                    ),
                  ),
                ] else if (provider.selectedAnswerType ==
                    AnswerType.multipleChoice) ...[
                  Wrap(
                    spacing: 8,
                    children: provider.currentOptions.map((opt) {
                      final isSelected = provider.selectedIdealAnswers.contains(
                        opt,
                      );
                      return CustomToggleButton(
                        title: opt,
                        onTap: () =>
                            provider.toggleIdealMultipleChoiceAnswer(opt),
                        isSelect: isSelected,
                      );
                    }).toList(),
                  ),
                ] else if (provider.selectedAnswerType ==
                    AnswerType.numeric) ...[
                  CustomTextFieldforAll(
                    controller: provider.numericController,
                    hint: "Type minimum ideal value",
                    isNumber: true,
                  ),
                ],
                const SizedBox(height: 16),
                CustomCheckboxRow(
                  title: "Must-have qualifications.",
                  value: provider.isMustHave,
                  onChanged: provider.toggleMustHave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
