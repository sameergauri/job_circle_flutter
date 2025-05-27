// screens/new_jobs/job_detail/job_detail_page.dart

// ignore_for_file: unused_result, use_build_context_synchronously, avoid_unnecessary_containers

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

  const JobDetailPage({
    super.key,
    required this.jobId,
  });

  @override
  ConsumerState<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends ConsumerState<JobDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobDetailProvider.notifier).fetchJobDetails(
            widget.jobId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobDetailState = ref.watch(jobDetailProvider);

    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 200,
              child: CustomButtonForJobPosting(
                buttonText: "Similar Jobs",
                buttonColor: Constants.bgColorWhite,
                isBorder: false,
                textColor: Constants.darkBlue,
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          SizedBox(
              width: 200,
              child: CustomButtonForJobPosting(
                buttonText: "Refer Now",
                buttonColor: Constants.darkBlue,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddResume(
                              // report_to: profilemodel.report_to!.toInt(),
                              company_name: jobDetailState
                                  .jobDetail!.companyName
                                  .toString(),
                              role:
                                  jobDetailState.jobDetail!.roleName.toString(),
                              process:
                                  jobDetailState.jobDetail!.process.toString(),
                              nature_of_work: jobDetailState
                                  .jobDetail!.functionalArea
                                  .toString(),
                              company_id: jobDetailState.jobDetail!.companyid!,
                              jobId: jobDetailState.jobDetail!.id!,
                              // sourceId: profilemodel.id!.toInt(),
                              // sourceName:
                              //     "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                              isRefer: true,
                              spocId: jobDetailState.jobDetail!.spocid!,
                              is90: true,
                              is30: false,
                              userNumber: 8446062685,
                              useAlternateNumber: 8446062685,
                              interviewRounds: "")));
                },
              )),
        ],
      ),
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
        ],
      ),
      body: _buildBody(jobDetailState),
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
    String salaryText = state.jobDetail!.salaryRange.toString();

    String formattedSalary = '';
    if (salaryText.endsWith('0')) {
      formattedSalary = salaryText.replaceFirst(RegExp(r'\s*0$'), ' PA');
    } else if (salaryText.endsWith('1')) {
      formattedSalary = salaryText.replaceFirst(RegExp(r'\s*1$'), ' PM');
    } else {
      formattedSalary = salaryText; // fallback if no valid suffix
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
                salary: formattedSalary,
                location: state.jobDetail!.locations!.join(', '),
                empType: state.jobDetail!.employmentType.toString(),
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
            if (state.jobDetail!.eligibility != null &&
                state.jobDetail!.eligibility!.isNotEmpty)
              CustomContainerForEligibility(
                heading: "Eligibility",
                stringList: state.jobDetail!.eligibility!,
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
            CustomButtonForJobPosting(
              buttonText: "Apply Now",
              onTap: () => handleApplyNow(context, ref, widget.jobId),
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
            const ReferralProgramCard(
              imageUrl:
                  "https://cdn-icons-png.flaticon.com/256/14356/14356000.png",
              subtitle: "Refer and Earn",
              title: "Referral Program",
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
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

    ref.refresh(fetchAllApplyProvider);
  }
}
