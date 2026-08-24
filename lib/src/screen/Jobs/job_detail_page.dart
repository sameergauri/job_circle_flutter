// screens/new_jobs/job_detail/job_detail_page.dart
// ignore_for_file: todo, prefer_const_constructors, unused_import, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_null_comparison, must_be_immutable, unused_local_variable, unnecessary_string_interpolations, unnecessary_this, duplicate_ignore
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/provider/add_resume/add_resume_provider.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/provider/business_job/screening_question_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_detail_provider.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_container_for_job_benefits.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_container_for_job_elegibility.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_headline.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_overview.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_recruiter_card.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_referal_program_card.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/view_container_for_skills.dart';
import 'package:job_circle/src/screen/business_job/screening_question/screening_question_card.dart';
import 'package:job_circle/src/screen/screening_question/Screening_question_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_bottom_sheet_for_app_theme.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_widget_for_job_post/view_container_for_cerAnd_benefits.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_add_resume.dart';
import 'package:job_circle/src/widgets/sharecode/share_job_card_landscape.dart';
import 'package:job_circle/src/widgets/sharecode/share_job_card_square.dart';
import 'package:job_circle/src/widgets/sharecode/share_job_service.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class JobDetailPage extends StatefulWidget {
  final int jobId;
  final FromWhere fromWhere;
  final String resume;
  final int? referrerUserId;

  const JobDetailPage({
    super.key,
    required this.jobId,
    required this.fromWhere,
    required this.resume,
    this.referrerUserId,
  });

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final jobDetailProvider = Provider.of<JobDetailProvider>(
        context,
        listen: false,
      );
      final businessJobProvider = Provider.of<BusinessJobProvider>(
        context,
        listen: false,
      );
      final screeningQuestionProvider = Provider.of<ScreeningQuestionProvider>(
        context,
        listen: false,
      );

      if (widget.fromWhere == FromWhere.myJobs) {
        jobDetailProvider.clearJobDetails();
        // 1. Await fetching business job details
        await businessJobProvider.fetchAndLoadJobDetails(jobId: widget.jobId);

        // 2. Load screening questions after data arrives
        if (mounted && businessJobProvider.jobPost.screeningQuestions != null) {
          screeningQuestionProvider.loadFromJobDetail(
            businessJobProvider.jobPost.screeningQuestions!,
          );
        }
      } else {
        // Home page job seeker flow
        jobDetailProvider.clearJobDetails();
        await jobDetailProvider.fetchJobDetails(widget.jobId);
      }
    });
  }

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<JobDetailProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: colors.bgColor,
              appBar: AppBar(
                actions: [
                  if (provider.jobDetail != null &&
                      provider.jobDetail!.payoutDetails != null)
                    IconButton(
                      onPressed: /*  () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            insetPadding: const EdgeInsets.all(10),
                            child: InteractiveViewer(
                              // Allows you to pinch and zoom to look closely at details
                              child: SingleChildScrollView(
                                scrollDirection: Axis
                                    .horizontal, // Since width is 1080, allow horizontal scrolling
                                child: ShareJobCardSquare(
                                  job: provider.jobDetail!,
                                  shareUrl:
                                      "https://jobcircle.in/job-detail/${provider.jobDetail!.id!}",
                                ),
                              ),
                            ),
                          ),
                        );
                      }, */ provider.jobDetail == null
                          ? null
                          : () async {
                              final result = await provider.shareJob(
                                jobId: provider.jobDetail!.id!,
                                shareMedium: 'others',
                              );
                              if (result['success'] == true) {
                                await ShareJobService.showOptions(
                                  context: context,
                                  job: provider.jobDetail!,
                                  shareUrl: result['shareUrl'] as String,
                                );
                              } else {
                                CustomSnackbar.show(
                                  result['message'] ?? 'Failed to share',
                                  true,
                                );
                              }
                            },
                      icon: Image.asset(
                        Theme.of(context).brightness == Brightness.light
                            ? CustomAssetUrl.shareIcon
                            : CustomAssetUrl.shareIconDarkMode,
                        height: 50,
                        width: 50,
                        // color: Colors.white,
                      ),
                    ),
                ],
                titleSpacing: 0,
                backgroundColor: colors.appbarColor,
                elevation: 0,
                iconTheme: IconThemeData(color: colors.headingColor),
                title: customText(
                  title: "Job Detail",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.headingColor,
                ),
              ),
              body: widget.fromWhere == FromWhere.myJobs
                  ? _buildMyJobDetailPage()
                  : _buildBody(provider, colors),
            ),
          ],
        );
      },
    );
  }

  Widget _buildJobDetailTabBar(AppColors colors) {
    return Row(
      children: [
        _buildTabItem('Job Description', 0, colors),
        _buildTabItem('Screening', 1, colors),
      ],
    );
  }

  Widget _buildTabItem(String label, int tabIndex, AppColors colors) {
    final isSelected = _selectedTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tabIndex),
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

  Widget _buildMyJobDetailPage() {
    final colors = context.appColors;
    return Consumer<BusinessJobProvider>(
      builder: (context, provider, child) {
        final hasScreening =
            provider.jobPost.screeningQuestions != null &&
            provider.jobPost.screeningQuestions!.isNotEmpty;
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Constants.darkBlue),
          );
        }
        final job = provider.jobPost;
        final screeningQuestions = provider.jobPost.screeningQuestions;

        final jobDescriptionContent = SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomJobHeadline(
                  jobHeadline: job.roleForBusinessHiring.toString(),
                  experience: _experienceText(provider),
                  salary: formatSalaryText(
                    min: job.minSalary,
                    max: job.maxSalary,
                    perMonth: job.perMonth!,
                  ),
                  location: _locationText(provider),
                  empType: job.empType.toString(),
                  companyIcon: '',
                  noVacancy: job.noOfVacancy.toString(),
                ),
                CustomJobOverview(
                  education: job.qualifications.toString(),
                  shifttime: job.shiftTime.toString(),
                  weekoff: job.weekOff.toString(),
                  language: job.languageRequired!.isNotEmpty
                      ? job.languageRequired!
                      : [],
                ),
                if (job.jobBenifits!.isNotEmpty)
                  ViewCerBenefitsForJobPost(
                    job: const [],
                    title: "Job Benefits",
                    type: ConListType.JobBenefits,
                    benefits: job.jobBenifits!,
                  ),
                if (job.certification != null && job.certification!.isNotEmpty)
                  ViewCerBenefitsForJobPost(
                    job: job.certification!,
                    title: "Certificates",
                    type: ConListType.Certificate,
                    benefits: const [],
                  ),
                if (job.keyResponsibities != null &&
                    job.keyResponsibities!.isNotEmpty)
                  CustomContainerForEligibility(
                    heading: "Key Responsibility",
                    stringList: job.keyResponsibities,
                    isList: true,
                  ),
                if ((job.eligibility != null && job.eligibility!.isNotEmpty) ||
                    (job.eligibility2 != null && job.eligibility2!.isNotEmpty))
                  CustomContainerForEligibility(
                    heading: "Eligibility",
                    stringList: job.eligibility! + job.eligibility2!,
                    isList: true,
                  ),
                if (job.boundryLimits != null && job.boundryLimits!.isNotEmpty)
                  CustomContainerForEligibility(
                    heading: "Boundary Limits",
                    stringList: job.boundryLimits!,
                    isList: true,
                  ),
                if (job.additionalDetails != null &&
                    job.additionalDetails!.isNotEmpty)
                  CustomContainerForEligibility(
                    heading: "Additional Detail",
                    stringList: job.additionalDetails,
                    isList: true,
                  ),
                ViewConatinerForSkills(
                  skills: job.skills!,
                  title: "Skills",
                  valueColor: colors.jobdetailGreyColor!,
                ),
              ],
            ),
          ),
        );

        final screeningContent = SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ...screeningQuestions!.asMap().entries.map(
                (entry) => ScreeningQuestionCard(
                  question: entry.value,
                  index: entry.key + 1,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasScreening) _buildJobDetailTabBar(colors),
                Expanded(
                  child: hasScreening && _selectedTab == 1
                      ? screeningContent
                      : jobDescriptionContent,
                ),
              ],
            ),
            if (provider.isLoading) CustomLoadingIndicator(), //Loading
          ],
        );
      },
    );
  }

  Widget _buildBody(JobDetailProvider provider, AppColors colors) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Constants.darkBlue),
      );
    }

    if (provider.error != null) {
      return Center(child: customText(title: provider.error!));
    }

    if (provider.jobDetail == null) {
      return const Center(child: customText(title: 'No job details found'));
    }

    final job = provider.jobDetail!;
    final screeningQuestions = provider.screeningQuestions;

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomJobHeadline(
                  jobHeadline: job.jobHeadline.toString(),
                  experience: job.postedByType == "JOBSEEKER"
                      ? job.requiredExperience!
                      : job.requiredExperience!,
                  salary: formatSalaryText(
                    min: job.minCtc,
                    max: job.maxCtc,
                    perMonth: job.salaryRange!.toUpperCase().contains("PM")
                        ? "1"
                        : "0",
                  ),
                  location: job.locationWithWorkType!,
                  empType: job.employmentType.toString(),
                  companyIcon: job.companyIcon.toString(),
                  noVacancy: job.noOfVacancy.toString(),
                ),
                CustomJobOverview(
                  education: job.requiredEducation.toString(),
                  shifttime: job.shiftTime.toString(),
                  weekoff: job.weekOff.toString(),
                  language: job.language != null && job.language!.isNotEmpty
                      ? job.language!
                      : [],
                ),
                ViewContainerForCerAndBenefits(
                  title: "Job Benefits",
                  job: job,
                  type: ConListType.JobBenefits,
                ),
                if (job.certifications != null &&
                    job.certifications!.isNotEmpty)
                  ViewContainerForCerAndBenefits(
                    title: "Certificate",
                    job: job,
                    type: ConListType.Certificate,
                  ),
                if (job.jobResponsibilities != null &&
                    job.jobResponsibilities!.isNotEmpty)
                  CustomContainerForEligibility(
                    heading: "Key Responsibility",
                    stringList: job.jobResponsibilities!,
                    isList: true,
                  ),
                if ((job.eligibility != null && job.eligibility!.isNotEmpty) ||
                    (job.eligibility2 != null && job.eligibility2!.isNotEmpty))
                  CustomContainerForEligibility(
                    heading: "Eligibility",
                    stringList: job.eligibility! + job.eligibility2!,
                    isList: true,
                  ),
                if (job.boundryLimits != null && job.boundryLimits!.isNotEmpty)
                  CustomContainerForEligibility(
                    heading: "Boundry Limits",
                    stringList: job.boundryLimits!,
                    isList: true,
                  ),
                if (job.additionalDetails != null &&
                    job.additionalDetails!.isNotEmpty)
                  CustomContainerForEligibility(
                    heading: "Additional Details",
                    stringList: job.additionalDetails!,
                    isList: true,
                  ),
                ViewConatinerForSkills(
                  skills: job.skills!,
                  title: "Skills",
                  valueColor: colors.jobdetailGreyColor!,
                ),
                if (FromWhere.homePage == widget.fromWhere)
                  CustomButtonForJobPosting(
                    buttonText: "Apply Now",
                    onTap: () {
                      if (widget.resume.isNotEmpty &&
                          widget.resume != "null" &&
                          widget.resume.trim().isNotEmpty) {
                        handleApplyNow(
                          context,
                          job.id!,
                          provider,
                          screeningQuestions,
                          widget.referrerUserId,
                        );
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CustomDialogueForAddResume(
                              buttonText: "Ok",
                              error: false,
                              onClose: () {
                                NavigationService.pop();
                              },
                              subtitle:
                                  "Your CV is not uploaded in the profile",
                            );
                          },
                        );
                      }
                    },
                  ),
                if (job.active != null && job.active != 0)
                  RecruiterDetailsCard(
                    title: "Posted by / Recruiter Details",
                    email: job.postedByEmail.toString(),
                    recruiterName: job.postedBy.toString(),
                    designation: job.postedByDesignation.toString(),
                    location: job.postedByLocation ?? " ",
                    contactNumber: job.postedByContactNo!,
                    profilepic: job.postedByProfilePic ?? " ",
                    jobTitle: job.roleName.toString(),
                  ),
                if (job.payoutDetails != null)
                  InkWell(
                    onTap: () async {
                      provider.setLoading(true);
                      // provider.setShowExperienceForm(false);
                      FileUploader fileUploader = FileUploader();
                      var data = await fileUploader.pickFileAndUpload(
                        //TODO:: this function is use to return file path and uploaded file name ....
                        needToUpload: true,
                        context,
                        allowedExt: ['pdf', 'doc', 'docx'],
                        folder: "resume",
                      );
                      if (data == null) {
                        provider.setLoading(false);
                        return;
                      }
                      await context.read<ReferResumeProvider>().fetchParseData(
                        File(data.file.path),
                        data.uploadedFileName!,
                        context,
                        job.companyName.toString(),
                        job.roleName.toString(),
                        job.process.toString(),
                        job.functionalArea.toString(),
                        job.companyid!,
                        job.id!,
                        job.spocid!,
                        SharedPrefsHelper.getInt(
                          ESharedPreferences.user_mobile,
                        ),
                        job.payoutDetails!,
                      );
                      Future.delayed(const Duration(milliseconds: 500), () {
                        provider.setLoading(false);
                      });
                      /*  NavigationService.push(
                        AddResume(
                          company_name: job.companyName.toString(),
                          role: job.roleName.toString(),
                          process: job.process.toString(),
                          nature_of_work: job.functionalArea.toString(),
                          company_id: job.companyid!,
                          jobId: job.id!,
                          spocId: job.spocid!,
                          userNumber: SharedPrefsHelper.getInt(
                            ESharedPreferences.user_mobile,
                          ),
                          payoutDetails: provider.jobDetail!.payoutDetails!,
                        ),
                      ); */
                    },
                    child: ReferralProgramCard(
                      payoutDetails: job.payoutDetails!,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (provider.applyLoading)
          CustomLoadingIndicator(), //Loading when user click on apply button
      ],
    );
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

  /*  String formatSalary(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';

    String input = raw.replaceAll(',', '').toLowerCase();

    bool isPerMonth = input.contains('pm');
    bool isLpa = input.contains('lpa');

    // Remove "pm" and "lpa"
    input = input.replaceAll('pm', '').replaceAll('lpa', '').trim();

    // Split by '-'
    List<String> parts = input.split('-').map((e) => e.trim()).toList();

    String formatPart(String str) {
      if (str.isEmpty) return '';

      // If value contains decimal (like 1.8), return as it is
      if (str.contains('.')) return str;

      // If value ends with k or K
      if (str.endsWith('k')) {
        return str; // keep 28k, 15k, etc.
      }

      // If number like 3 or 6 (LPA case)
      return str;
    }

    String start = formatPart(parts[0]);
    String end = parts.length > 1 ? formatPart(parts[1]) : '';

    // Remove 0k or plain 0
    if (end == '0' || end == '0k') end = '';

    // Suffix
    String suffix = isPerMonth ? ' per month' : (isLpa ? ' LPA' : '');

    // Compose output
    if (end.isEmpty) {
      return '$start$suffix';
    } else {
      return '$start - $end$suffix';
    }
  } */

  Future<void> handleApplyNow(
    BuildContext context,
    int jobId,
    JobDetailProvider provider,
    List<JobDetailScreeningQuestion> screeningQuestions,
    int? refid,
  ) async {
    if (screeningQuestions.isNotEmpty && screeningQuestions != null) {
      // Agar screening questions hain, toh pehle unko show karo
      NavigationService.push(ScreeningQuestionPage(refid: refid));
    } else {
      int id = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
      provider.submitApplicationWithScreening(jobId, id, context, true, refid);
    }
  }
}
