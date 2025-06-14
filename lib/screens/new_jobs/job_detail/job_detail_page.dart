// screens/new_jobs/job_detail/job_detail_page.dart

// ignore_for_file: unused_result, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/job_detail/custom_container_for_elegibility.dart';
import 'package:job_circle/constants/job_detail/custom_container_for_job_benefits.dart';
import 'package:job_circle/constants/job_detail/custom_job_headline.dart';
import 'package:job_circle/constants/job_detail/custom_job_overview.dart';
import 'package:job_circle/constants/job_detail/custom_recruiter_card.dart';
import 'package:job_circle/constants/job_detail/custom_referral_card.dart';
import 'package:job_circle/constants/job_detail/view_container_for_skills.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/add_resume.dart';
import 'package:job_circle/screens/new_jobs/job_detail/job_detail_page_provider.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class JobDetailPage extends ConsumerStatefulWidget {
  final int jobId;
  final FromWhere fromWhere;

  const JobDetailPage({
    super.key,
    required this.jobId,
    required this.fromWhere,
  });

  @override
  ConsumerState<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends ConsumerState<JobDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobDetailProvider.notifier).clearJobDetails();
      ref.read(jobDetailProvider.notifier).fetchJobDetails(
            widget.jobId,
          );
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final jobDetailState = ref.watch(jobDetailProvider);

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true, // Add this line
          backgroundColor: Colors.white,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const customTextForWeather(
              title: "Job Detail",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            actions: const [
              /*   IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border_rounded),
              ), */
            ],
          ),
          body: _buildBody(jobDetailState),
        ),
        if (isLoading)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0.2),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Constants.darkBlue,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(JobDetailState state) {
    if (state.isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: Constants.darkBlue,
      ));
    }

    if (state.error != null) {
      return Center(
        child: customTextForWeather(
          title: state.error!,
        ),
      );
    }

    if (state.jobDetail == null) {
      return const Center(
        child: customTextForWeather(
          title: 'No job details found',
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomJobHeadline(
                jobHeadline: state.jobDetail!.jobHeadline.toString(),
                experience: state.jobDetail!.requiredExperience.toString(),
                salary: _formatSalary(state.jobDetail!.salaryRange),
                location: state.jobDetail!.locations!.join(', '),
                empType: state.jobDetail!.employmentType.toString(),
                companyIcon: state.jobDetail!.companyIcon.toString(),
                noVacancy: state.jobDetail!.noOfVacancy.toString()),
            CustomJobOverview(
                education: state.jobDetail!.requiredEducation.toString(),
                shifttime: state.jobDetail!.shiftTime.toString(),
                weekoff: state.jobDetail!.weekOff.toString(),
                language: state.jobDetail!.language != null &&
                        state.jobDetail!.language!.isNotEmpty
                    ? state.jobDetail!.language!
                    : []),
            ViewContainerForCerAndBenefits(
                stringList: state.jobDetail!.jobBenefits!,
                title: "Job Benefits"),
            /*  if(state.jobDetail!.certifications != null &&  //TODO:: For certification..
                    state.jobDetail!.certifications!.isNotEmpty)
            ViewContainerForCerAndBenefits(
                stringList: state.jobDetail!.certifications!,
                title: "Certifications"), */
            if (state.jobDetail!.jobResponsibilities != null &&
                state.jobDetail!.jobResponsibilities!.isNotEmpty)
              CustomContainerForEligibility(
                heading: "Key Responsibility",
                stringList: state.jobDetail!.jobResponsibilities!,
                isList: true,
              ),
            if ((state.jobDetail!.eligibility != null &&
                    state.jobDetail!.eligibility!.isNotEmpty) ||
                (state.jobDetail!.eligibility2 != null &&
                    state.jobDetail!.eligibility2!.isNotEmpty))
              CustomContainerForEligibility(
                heading: "Eligibility",
                stringList: state.jobDetail!.eligibility! +
                    state.jobDetail!.eligibility2!,
                isList: true,
              ),
            if (state.jobDetail!.boundryLimits != null &&
                state.jobDetail!.boundryLimits!.isNotEmpty)
              CustomContainerForEligibility(
                heading: "Boundry Limits",
                stringList: state.jobDetail!.boundryLimits!,
                isList: true,
              ),
            if (state.jobDetail!.additionalDetails != null &&
                state.jobDetail!.additionalDetails!.isNotEmpty)
              CustomContainerForEligibility(
                heading: "Additional Details",
                stringList: state.jobDetail!.additionalDetails!,
                isList: true,
              ),
            ViewConatinerForSkills(
              skills: state.jobDetail!.skills!,
              title: "Skills",
              valueColor: Constants.subtitleclr,
            ),
            if (FromWhere.homePage == widget.fromWhere)
              CustomButtonForJobPosting(
                buttonText: "Apply Now",
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  handleApplyNow(context, ref, widget.jobId);
                },
              ),
            RecruiterDetailsCard(
              title: "Posted by / Recruiter Details",
              email: state.jobDetail!.postedByEmail.toString(),
              recruiterName: state.jobDetail!.postedBy.toString(),
              designation: state.jobDetail!.postedByDesignation
                  .toString(), // replace with actual value
              location: state.jobDetail!.postedByLocation != null
                  ? state.jobDetail!.postedByLocation.toString()
                  : " ", // replace with actual value
              contactNumber: state.jobDetail!.postedByContactNo!,
              profilepic: state.jobDetail!.postedByProfilePic != null
                  ? state.jobDetail!.postedByProfilePic!
                  : " ",
            ),
            if (state.jobDetail!.payoutDetails != null)
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddResume(
                                // report_to: profilemodel.report_to!.toInt(),
                                company_name:
                                    state.jobDetail!.companyName.toString(),
                                role: state.jobDetail!.roleName.toString(),
                                process: state.jobDetail!.process.toString(),
                                nature_of_work:
                                    state.jobDetail!.functionalArea.toString(),
                                company_id: state.jobDetail!.companyid!,
                                jobId: state.jobDetail!.id!,
                                // sourceId: profilemodel.id!.toInt(),
                                // sourceName:
                                //     "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}"
                                spocId: state.jobDetail!.spocid!,
                                is90: true,
                                is30: false,
                                userNumber: 8446062685,
                                useAlternateNumber: 8446062685,
                                interviewRounds: "",
                                payoutDetails: state.jobDetail!.payoutDetails!,
                              )));
                },
                child: ReferralProgramCard(
                  payoutDetails: state.jobDetail!.payoutDetails!,
                ),
              ),
            if (FromWhere.homePage == widget.fromWhere)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Constants.darkBlue),
                        ),
                        // width: 200,
                        child: const customTextForWeather(
                            title: "More Jobs",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Constants.darkBlue)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatSalary(String? rang) {
    String salaryRange = rang!.replaceAll(',', '');
    if (salaryRange.isEmpty) return '';

    // Extract if it ends with " 0" or " 1"
    String suffix = '';
    if (salaryRange.endsWith(' 0')) {
      suffix = ' LPA';
      salaryRange = salaryRange.replaceFirst(RegExp(r'\s0$'), '');
    } else if (salaryRange.endsWith(' 1')) {
      suffix = ' per month';
      salaryRange = salaryRange.replaceFirst(RegExp(r'\s1$'), '');
    }

    // Split range
    List<String> parts = salaryRange.split('-').map((e) => e.trim()).toList();

    String formatAmount(String str) {
      final amount = int.tryParse(str);
      if (amount == null || amount == 0) return '';

      if (amount >= 100000) {
        double lacs = amount / 100000;
        return lacs.toStringAsFixed(lacs % 1 == 0 ? 0 : 1);
      } else if (amount >= 1000) {
        double thousands = amount / 1000;
        return '${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}K';
      } else {
        return amount.toString();
      }
    }

    String formattedRange = '';
    if (parts.length == 2) {
      String start = formatAmount(parts[0]);
      String end = formatAmount(parts[1]);
      if (end.isEmpty) {
        formattedRange = '$start$suffix';
      } else {
        formattedRange = '$start - $end$suffix';
      }
    } else {
      formattedRange = formatAmount(parts[0]) + suffix;
    }

    return formattedRange;
  }

  Future<void> handleApplyNow(
      BuildContext context, WidgetRef ref, int jobId) async {
    String id =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);

    await JobPostApiService.postJobApply(
      addcv: false,
      context: context,
      jobId: jobId,
      userId: int.tryParse(id)!,
    );
    setState(() {
      isLoading = false;
    });
    ref.refresh(fetchAllApplyProvider);
  }
}
