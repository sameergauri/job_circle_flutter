import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/business_job/master_screening_question.dart';
import 'package:job_circle/src/provider/business_job/master_screening_question_provider.dart';
import 'package:job_circle/src/screen/business_job/screening_question/add_screening_question.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class ScreeningQuestionHomePage extends StatefulWidget {
  final VoidCallback? afterSave;

  const ScreeningQuestionHomePage({super.key, this.afterSave});

  @override
  State<ScreeningQuestionHomePage> createState() =>
      _SelectQuestionScreenState();
}

class _SelectQuestionScreenState extends State<ScreeningQuestionHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterScreeningQuestionProvider>().fetchAllMasterQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final provider = context.watch<MasterScreeningQuestionProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          CustomIconButton(
            color: colors.headingColor,
            imageUrl: CustomIconUrl.cancelicon,
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
        automaticallyImplyLeading: true,
        backgroundColor: colors.appbarColor,
        elevation: 0,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: colors.headingColor),
        title: customText(
          title: "Screening Questions",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: colors.headingColor,
        ),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator(color: colors.darkBlue))
          : provider.errorMessage != null
          ? Center(
              child: customText(
                title: "Error: ${provider.errorMessage}",
                color: colors.subTitleColor,
              ),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCustomQuestionTile(colors),
                  const SizedBox(height: 16),
                  const customText(
                    title: "Suggested Questions",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 12),
                  ...provider.questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    return Column(
                      children: [
                        _buildQuestionTile(question, colors),
                        if (index != provider.questions.length - 1)
                          const Divider(height: 1, thickness: 1),
                      ],
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildCustomQuestionTile(AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.appbarColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.darkBlue!),
      ),
      child: CustomListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: customText(
          title: "Custom question",
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: colors.headingColor,
        ),
        subtitle: customText(
          title: "Add Your Own Custom Question",
          color: colors.subTitleColor,
          fontSize: 12,
        ),
        trailing: const Icon(
          Icons.add_circle_outline,
          color: Constants.darkBlue,
        ),
        onTap: () {
          NavigationService.push(
            AddScreeningQuestion(afterSave: widget.afterSave),
          );
        },
      ),
    );
  }

  Widget _buildQuestionTile(MasterScreeningQuestion q, AppColors colors) {
    return CustomListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      ),
      title: customText(
        title: q.questionHeading ?? "Question",
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: colors.headingColor,
      ),
      subtitle: customText(
        title: q.questionText,
        maxlines: 2,
        overflow: TextOverflow.ellipsis,
        color: colors.subTitleColor,
        fontSize: 12,
      ),
      onTap: () {
        NavigationService.push(
          AddScreeningQuestion(
            masterScreeningQuestion: q,
            afterSave: widget.afterSave,
          ),
        );
      },
    );
  }
}
