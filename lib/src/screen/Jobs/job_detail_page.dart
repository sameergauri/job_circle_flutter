// screens/new_jobs/job_detail/job_detail_page.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/add_resume/add_resume_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_detail_provider.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_container_for_job_benefits.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_container_for_job_elegibility.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_headline.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_job_overview.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_recruiter_card.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/custom_referal_program_card.dart';
import 'package:job_circle/src/screen/Jobs/custom_job_detail_cards/view_container_for_skills.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_add_resume.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class JobDetailPage extends StatefulWidget {
  final int jobId;
  final FromWhere fromWhere;
  final String resume;

  const JobDetailPage({
    super.key,
    required this.jobId,
    required this.fromWhere,
    required this.resume,
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
    return Consumer<JobDetailProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                titleSpacing: 0,
                backgroundColor: Constants.borderColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const customText(
                  title: "Job Detail",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              body: _buildBody(provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(JobDetailProvider provider) {
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

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomJobHeadline(
                  jobHeadline: job.jobHeadline.toString(),
                  experience: job.requiredExperience.toString(),
                  salary: formatSalary(job.salaryRange),
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
                  stringList: job.jobBenefits!,
                  title: "Job Benefits",
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
                  valueColor: Constants.subtitleclr,
                ),
                if (FromWhere.homePage == widget.fromWhere)
                  CustomButtonForJobPosting(
                    buttonText: "Apply Now",
                    onTap: () {
                      if (widget.resume.isNotEmpty &&
                          widget.resume != "null" &&
                          widget.resume.trim().isNotEmpty) {
                        handleApplyNow(context, job.id!, provider);
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CustomDialogueForAddResume(
                              error: false,
                              onClose: () => NavigationService.pop(),
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
                        "8446062685",
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

  String formatSalary(String? raw) {
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
  }

  Future<void> handleApplyNow(
    BuildContext context,
    int jobId,
    JobDetailProvider provider,
  ) async {
    final id = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    provider.applyJob(jobId, id, context);
  }
}
