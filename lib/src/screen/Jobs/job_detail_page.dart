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
import 'package:job_circle/src/provider/add_resume/add_resume_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_detail_provider.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_container_for_job_benefits.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_container_for_job_elegibility.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_headline.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_overview.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_recruiter_card.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_referal_program_card.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/view_container_for_skills.dart';
import 'package:job_circle/src/screen/screening_question/Screening_question_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_bottom_sheet_for_app_theme.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
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
    // Fetch job details once the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<JobDetailProvider>(context, listen: false);
      provider.clearJobDetails();
      provider.fetchJobDetails(widget.jobId);
    });
  }

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
              body: _buildBody(provider, colors),
            ),
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
                  experience: job.requiredExperience.toString(),
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

  String formatSalaryText({
    required dynamic min,
    required dynamic max,
    required String perMonth, // "1" for Monthly, "0" for Yearly
  }) {
    double minVal = double.tryParse(min.toString()) ?? 0;
    double maxVal = double.tryParse(max.toString()) ?? 0;
    bool isMonthly = perMonth == "1";

    // Number format karne ka logic
    String formatNumber(double value) {
      if (value == 0) return "0";

      double result;
      bool addK = false;

      if (isMonthly) {
        if (value >= 1000) {
          result = value / 1000; // 1500 => 1.5
          addK = true; // Monthly me 'k' lagana hai
        } else {
          return value
              .toInt()
              .toString(); // Agar 1000 se kam hai to direct return
        }
      } else {
        // Yearly ke liye 1 Lakh se divide
        result = value / 100000; // 300000 => 3.0
      }

      // MAIN LOGIC: Point hatane wala
      String finalString;

      // Check karein ki result poora number hai kya (Jaise 3.0, 5.0)
      if (result % 1 == 0) {
        finalString = result.toInt().toString(); // 3.0 => "3"
      } else {
        // Agar decimal hai (Jaise 1.5, 2.53)
        // toStringAsFixed(2) "1.50" dega, regex us extra 0 ko hata dega
        finalString = result
            .toStringAsFixed(2)
            .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
      }

      return addK ? "${finalString}k" : finalString;
    }

    String minStr = formatNumber(minVal);
    String suffix = isMonthly ? "Per Month" : "LPA";

    // Agar Max Salary 0 hai ya Min aur Max same hai
    if (maxVal == 0 || maxVal == minVal) {
      return "$minStr $suffix";
    }

    String maxStr = formatNumber(maxVal);
    return "$minStr - $maxStr $suffix";
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
