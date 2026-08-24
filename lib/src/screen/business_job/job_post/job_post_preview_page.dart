// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/business_job/temp_screening_question_model.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart'
    show JobDetailScreeningQuestion, ScreeningQuestion;
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/provider/business_job/screening_question_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_container_for_job_elegibility.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_headline.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_overview.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/view_container_for_skills.dart';
import 'package:job_circle/src/screen/business_job/screening_question/add_screening_question.dart';
import 'package:job_circle/src/screen/business_job/screening_question/screening_question_home_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/custom_widget_for_job_post/view_container_for_cerAnd_benefits.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class JobPostPreviewPage extends StatefulWidget {
  const JobPostPreviewPage({super.key});

  @override
  State<JobPostPreviewPage> createState() => _JobPostPreviewPageState();
}

class _JobPostPreviewPageState extends State<JobPostPreviewPage> {
  int _postSelectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<BusinessJobProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              floatingActionButton: _postSelectedTab == 1
                  ? FloatingActionButton(
                      heroTag: 'btn_add_screening',
                      backgroundColor: Constants.borderColor,
                      child: const Icon(Icons.add, color: Constants.darkBlue),
                      onPressed: () {
                        NavigationService.push(
                          ScreeningQuestionHomePage(
                            afterSave: () {
                              NavigationService.pop();
                              NavigationService.pop();
                            },
                          ),
                        );
                      },
                    )
                  : null,
              backgroundColor: colors.bgColor,
              bottomNavigationBar: SafeArea(
                child: CustomButtonForSave(
                  title: provider.isEditMode ? "Update Job" : "Post Job",
                  onTap: () async {
                    int userid = SharedPrefsHelper.getInt(
                      ESharedPreferences.user_id,
                    );
                    final jobProvider = context.read<JobProvider>();
                    final scq = context.read<ScreeningQuestionProvider>();
                    final success = await provider.submitFinalJob(
                      userId: userid,
                      ScreeningQuestion: convertToScreeningQuestions(
                        tempQuestions: scq.savedQuestions,
                        forJobDetail: true,
                      ),
                    );
                    if (success) {
                      CustomSnackbar.show(
                        provider.isEditMode
                            ? "Job updated successfully!"
                            : "Job posted successfully! Pending admin approval.",
                        false,
                      );
                      await jobProvider.fetchJobs(
                        isRefresh: true,
                        applyCityFilter: false,
                      );
                      NavigationService.pop();
                    } else {
                      CustomSnackbar.show(
                        "Getting error while job post.",
                        true,
                      );
                    }
                  },
                ),
              ),
              appBar: AppBar(
                title: customText(
                  title: "Job Post",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.headingColor,
                ),
                actions: [
                  CustomIconButton(
                    color: colors.headingColor,
                    imageUrl: CustomIconUrl.cancelicon,
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
                backgroundColor: colors.appbarColor,
                elevation: 0,
                titleSpacing: 0,
                iconTheme: IconThemeData(color: colors.headingColor),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostingTabBar(colors),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _postSelectedTab == 0
                          ? customBody(provider, colors)
                          : _buildPostingScreeningContent(provider, context),
                    ),
                  ),
                ],
              ),
            ),
            if (provider.isLoading) const CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  Widget customBody(BusinessJobProvider provider, AppColors colors) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomJobHeadline(
              jobHeadline: provider.jobHeadlineController.text,
              experience: _experienceText(provider),
              salary: formatSalaryText(
                min: provider.minSalController.text,
                max: provider.maxSalController.text,
                perMonth: provider.isPerMonth ? "1" : "0",
              ),
              location: _locationText(provider),
              empType: provider.empType,
              companyIcon: "",
              noVacancy: provider.noOfVacancyController.text,
            ),
            CustomJobOverview(
              education: provider.qualification.toString(),
              shifttime: provider.shiftTime.toString(),
              weekoff: provider.weekOff.toString(),
              language: provider.selectedLanguages.isNotEmpty
                  ? provider.selectedLanguages
                  : [],
            ),
            if (provider.selectedBenefits.isNotEmpty)
              ViewCerBenefitsForJobPost(
                job: const [],
                title: "Job Benefits",
                type: ConListType.JobBenefits,
                benefits: provider.selectedBenefits,
              ),
            if (provider.selectedCertificates.isNotEmpty)
              ViewCerBenefitsForJobPost(
                job: provider.selectedCertificates,
                title: "Certificates",
                type: ConListType.Certificate,
                benefits: const [],
              ),
            if (provider.keyResponsibilitiesController.text.isNotEmpty)
              CustomContainerForEligibility(
                heading: "Key Responsibility",
                stringList: provider.parseBulletTextToList(
                  provider.keyResponsibilitiesController.text,
                ),
                isList: true,
              ),
            if (provider.autoEligibilityList.isNotEmpty)
              CustomContainerForEligibility(
                heading: "Eligibility",
                stringList:
                    provider.autoEligibilityList +
                    provider.parseBulletTextToList(
                      provider.eligibilityController.text,
                    ),
                isList: true,
              ),
            if (provider.boundaryController.text != "• ")
              CustomContainerForEligibility(
                heading: "Boundary Limits",
                stringList: provider.parseBulletTextToList(
                  provider.boundaryController.text,
                ),
                isList: true,
              ),
            if (provider.additionalDetailsController.text != "• ")
              CustomContainerForEligibility(
                heading: "Additional Detail",
                stringList: provider.parseBulletTextToList(
                  provider.additionalDetailsController.text,
                ),
                isList: true,
              ),
            ViewConatinerForSkills(
              skills: provider.selectedSkills,
              title: "Skills",
              valueColor: colors.jobdetailGreyColor!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostingScreeningContent(
    BusinessJobProvider provider,
    BuildContext context,
  ) {
    final sqProvider = Provider.of<ScreeningQuestionProvider>(context);
    final questions = sqProvider.savedQuestions;
    final colors = context.appColors;
    if (questions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: customText(
            title: 'No screening questions added yet.\nTap + to add one.',
            color: colors.subTitleColor,
            fontSize: 14,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: questions.map((question) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: CustomListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              onTap: () {
                sqProvider.loadQuestionForEdit(question);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddScreeningQuestion(
                      afterSave: () => NavigationService.pop(),
                    ),
                  ),
                );
              },
              title: customText(
                title: question.questionText,
                fontWeight: FontWeight.w600,
                color: colors.headingColor,
              ),
              subtitle: customText(
                title:
                    "Ideal answer : ${question.idealAnswers.join(', ')}${question.isMustHave ? '\n☑ Must-have qualification' : ''}",
                fontWeight: FontWeight.w400,
                color: colors.subTitleColor,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: colors.subTitleColor),
                onPressed: () => sqProvider.deleteQuestion(question.id),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostingTabBar(AppColors colors) {
    return Row(
      children: [
        _buildPostingTabItem('Job Description', 0, colors),
        _buildPostingTabItem('Screening', 1, colors),
      ],
    );
  }

  Widget _buildPostingTabItem(String label, int tabIndex, AppColors colors) {
    final isSelected = _postSelectedTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _postSelectedTab = tabIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Constants.orange : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: customText(
            title: label,
            textAlign: TextAlign.center,
            color: isSelected ? colors.headingColor : Constants.subtitleclr,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _experienceText(BusinessJobProvider provider) {
    switch (provider.experienceRequired) {
      case "FRESHER":
        return "Fresher can apply";
      case "SIX_MONTHS":
        return "6 month or above";
      case "OTHERS":
        final min = provider.minYearController.text.trim();
        final max = provider.maxYearController.text.trim();
        if (max.isEmpty) {
          if (provider.isAndAbove) {
            final minNum = int.tryParse(min) ?? 0;
            final yearWord = minNum == 1 ? "Year" : "Years";
            return min.isEmpty ? "" : "$min $yearWord and above";
          }
          return min.isEmpty ? "" : "$min yrs";
        }
        return "$min - $max yrs";
      default:
        return "";
    }
  }

  String _locationText(BusinessJobProvider provider) {
    final List<LocationData> locations = provider.isHybrid
        ? provider.jobLocationListHybrid
        : provider.isOnsite
        ? provider.jobLocationListOnsite
        : provider.jobLocationListRemote;

    if (locations.isEmpty) return "";

    return locations
        .map((location) {
          final text = location.formateData ?? "";
          return "${text.split(',')[0].trim()} ${provider.isRemote
              ? "(Remote)"
              : provider.isOnsite
              ? "(OnSite)"
              : "(Hybrid)"}";
        })
        .where((text) => text.isNotEmpty)
        .join(", ");
  }

  String formatSalaryText({
    required dynamic min,
    required dynamic max,
    required String perMonth,
  }) {
    double minVal = double.tryParse(min.toString()) ?? 0;
    double maxVal = double.tryParse(max.toString()) ?? 0;
    bool isMonthly = perMonth == "1";

    String formatNumber(double value) {
      if (value == 0) return "0";

      double result;
      bool addK = false;

      if (isMonthly) {
        if (value >= 1000) {
          result = value / 1000;
          addK = true;
        } else {
          return value.toInt().toString();
        }
      } else {
        result = value / 100000;
      }

      String finalString;
      if (result % 1 == 0) {
        finalString = result.toInt().toString();
      } else {
        finalString = result
            .toStringAsFixed(2)
            .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
      }

      return addK ? "${finalString}k" : finalString;
    }

    String minStr = formatNumber(minVal);
    String suffix = isMonthly ? "Per Month" : "LPA";

    if (maxVal == 0 || maxVal == minVal) {
      return "$minStr $suffix";
    }

    String maxStr = formatNumber(maxVal);
    return "$minStr - $maxStr $suffix";
  }

  /// Converts List<TempScreeningQuestions> to either ScreeningQuestion or JobDetailScreeningQuestion
  List<T> convertToScreeningQuestions<T>({
    required List<TempScreeningQuestions> tempQuestions,
    required bool
    forJobDetail, // true → JobDetailScreeningQuestion, false → ScreeningQuestion
  }) {
    return tempQuestions.asMap().entries.map<T>((entry) {
      final int index = entry.key;
      final TempScreeningQuestions temp = entry.value;

      // Determine Question Type
      String qType = "SINGLE_SELECT";
      if (temp.answerType == AnswerType.multipleChoice) {
        qType = "MULTIPLE_SELECT";
      } else if (temp.answerType == AnswerType.numeric) {
        qType = "NUMERIC";
      } else if (temp.answerType == AnswerType.yesNo) {
        qType = "YES_NO";
      }

      final bool isNumeric = temp.answerType == AnswerType.numeric;

      // Correct Options → A, B, C...
      final List<String>? correctOpts = isNumeric
          ? null
          : temp.idealAnswers.map((answer) {
              final idx = temp.options.indexOf(answer);
              return idx != -1
                  ? String.fromCharCode('A'.codeUnitAt(0) + idx)
                  : answer;
            }).toList();

      final double? numericVal = isNumeric
          ? double.tryParse(temp.idealAnswers.firstOrNull ?? '')
          : null;

      if (forJobDetail) {
        // ================== JobDetailScreeningQuestion ==================
        return JobDetailScreeningQuestion(
              // id: temp.id,           // Uncomment if you have id in Temp model
              // questionBankId: null,  // Add if needed
              questionText: temp.questionText,
              questionCategory: "SCREENING",
              questionType: qType,
              orderNumber: index + 1,
              required: temp.isMustHave,
              allowToLead: temp.isMustHave,
              correctOptions: correctOpts,
              numericOption: numericVal,
              optionA: isNumeric || temp.options.isEmpty
                  ? null
                  : temp.options[0],
              optionB: isNumeric || temp.options.length <= 1
                  ? null
                  : temp.options[1],
              optionC: isNumeric || temp.options.length <= 2
                  ? null
                  : temp.options[2],
              optionD: isNumeric || temp.options.length <= 3
                  ? null
                  : temp.options[3],
              optionE: isNumeric || temp.options.length <= 4
                  ? null
                  : temp.options[4],
              optionF: isNumeric || temp.options.length <= 5
                  ? null
                  : temp.options[5],
              optionG: isNumeric || temp.options.length <= 6
                  ? null
                  : temp.options[6],
              optionH: isNumeric || temp.options.length <= 7
                  ? null
                  : temp.options[7],
            )
            as T;
      } else {
        // ================== ScreeningQuestion (Original) ==================
        return ScreeningQuestion(
              questionText: temp.questionText,
              questionType: qType,
              questionCategory: "SCREENING",
              required: temp.isMustHave,
              allowToLead: temp.isMustHave,
              correctOptions: correctOpts,
              numericOption: numericVal,
              orderNumber: index + 1,
              optionA: isNumeric || temp.options.isEmpty
                  ? null
                  : temp.options[0],
              optionB: isNumeric || temp.options.length <= 1
                  ? null
                  : temp.options[1],
              optionC: isNumeric || temp.options.length <= 2
                  ? null
                  : temp.options[2],
              optionD: isNumeric || temp.options.length <= 3
                  ? null
                  : temp.options[3],
              optionE: isNumeric || temp.options.length <= 4
                  ? null
                  : temp.options[4],
              optionF: isNumeric || temp.options.length <= 5
                  ? null
                  : temp.options[5],
              optionG: isNumeric || temp.options.length <= 6
                  ? null
                  : temp.options[6],
              optionH: isNumeric || temp.options.length <= 7
                  ? null
                  : temp.options[7],
            )
            as T;
      }
    }).toList();
  }
}
