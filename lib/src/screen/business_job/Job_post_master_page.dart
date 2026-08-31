// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/business_job/business_job_model.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_company_step_scaffold.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page1.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page2.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page3.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page4.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page5.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page6.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page7.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_page_start_for_consultancy.dart';
import 'package:job_circle/src/screen/business_job/job_post/job_post_preview_page.dart';
import 'package:job_circle/src/screen/business_page/create_company/page4_identity_verification.dart';
import 'package:job_circle/src/screen/business_page/create_company/page5_documents.dart';
import 'package:job_circle/src/screen/business_page/create_company/page6_decleration.dart';
import 'package:provider/provider.dart';

class JobPostMasterScreen extends StatefulWidget {
  final bool isEdit;
  final int? jobId;
  final BusinessJobPostModel? existingJob;
  // When NEW: this job post is being created together with a brand-new
  // company (drawer's "Job Post" entry for a user with no company yet).
  // Identity Verification is shown after all job-post form steps and the
  // final "Post Job" submits both the company and the job together.
  final ForNewJob forNewJob;
  // Old-flow only ("My Jobs" floating action button, existing company):
  // pre-selected company's industry/consultancy status changes step 1.
  final bool hideIndustryFieldOnStep1;
  final bool showHiringForOnStep1;

  const JobPostMasterScreen({
    super.key,
    this.isEdit = false,
    this.jobId,
    this.existingJob,
    this.forNewJob = ForNewJob.OLD,
    this.hideIndustryFieldOnStep1 = false,
    this.showHiringForOnStep1 = false,
  });

  @override
  State<JobPostMasterScreen> createState() => _JobPostMasterScreenState();
}

class _JobPostMasterScreenState extends State<JobPostMasterScreen> {
  // True whenever this instance has a step 0 before the normal job-post
  // form — every combined new-company scenario except Direct-Employer-Owner
  // (who already gave their industry on the Company Profile page).
  bool _hasStepZero = false;
  // Consultancy vs Direct-Employer, for the combined new-company flow only.
  bool _isConsultancy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jobProvider = context.read<BusinessJobProvider>();
      jobProvider.initJobForm(
        isEdit: widget.isEdit,
        existingJob: widget.existingJob,
        jobId: widget.jobId,
      );
      if (widget.forNewJob != ForNewJob.NEW) return;

      final companyProvider = context.read<BusinessCompanyProvider>();
      final isOwner = companyProvider.memberRole == 'OWNER';
      final isConsultancy = companyProvider.companyType == 'CONSULTANT';

      if (isOwner && !isConsultancy) {
        // Direct-Employer-Owner: no step 0 — the job's industry comes
        // straight from the Company Profile page's Industry field instead
        // of being asked again on the (removed) job-post Industry field.
        jobProvider.industryController.text =
            companyProvider.industryController.text;
        return;
      }

      setState(() {
        _hasStepZero = true;
        _isConsultancy = isConsultancy;
      });
      jobProvider.setStep(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<BusinessJobProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: CircularProgressIndicator(color: Constants.darkBlue),
            ),
          );
        }

        return WillPopScope(
          onWillPop: () async {
            // FIX: Allow step back until Step 1 (Step 0 only exists for
            // consultancy's extra pre-step in the combined new-company flow)
            final minStep = _hasStepZero ? 0 : 1;
            if (provider.currentStep > minStep) {
              provider.setStep(provider.currentStep - 1);
              return false;
            }
            return true;
          },
          child: _buildCurrentStepView(context, provider.currentStep, provider),
        );
      },
    );
  }

  Widget _buildCurrentStepView(
    BuildContext context,
    int step,
    BusinessJobProvider provider,
  ) {
    // Combined "post job for a new company" flow: Identity Verification is
    // inserted after all the normal job-post form steps, before the preview.
    if (widget.forNewJob == ForNewJob.NEW) {
      switch (step) {
        case 0:
          return JobPostStartPageForConsultancy(
            isEdit: provider.isEditMode,
            isConsultancy: _isConsultancy,
          );
        case 1:
          return JobPostPageOne(
            isEdit: provider.isEditMode,
            hideIndustryField: true,
          );
        case 2:
          return const JobPostPageTwo();
        case 3:
          return const JobPostPageThree();
        case 4:
          return const JobPostPageFour();
        case 5:
          return const JobPostPageFive();
        case 6:
          return const JobPostPageSix();
        case 7:
          return const JobPostPageSeven();
        case 8:
          return JobPostCompanyStepScaffold(
            title: "Identity Verification",
            onContinue: () => provider.setStep(9),
            child: const Page4IdentityVerification(isForNewJobFlow: true),
          );
        case 9:
          return JobPostCompanyStepScaffold(
            title: "Documents",
            buttonTitle: "Submit",
            onContinue: () => provider.setStep(10),
            child: const Page5Documents(),
          );
        case 10:
          return JobPostCompanyStepScaffold(
            title: "Declaration",
            onContinue: () => provider.setStep(11),
            child: const Page6Declaration(),
          );
        case 11:
          return const JobPostPreviewPage(forNewJob: ForNewJob.NEW);
        default:
          return const SizedBox.shrink();
      }
    }

    switch (step) {
      case 1:
        return JobPostPageOne(
          isEdit: provider.isEditMode,
          hideIndustryField: widget.hideIndustryFieldOnStep1,
          showHiringForField: widget.showHiringForOnStep1,
        );
      case 2:
        return const JobPostPageTwo();
      case 3:
        return const JobPostPageThree();
      case 4:
        return const JobPostPageFour();
      case 5:
        return const JobPostPageFive();
      case 6:
        return const JobPostPageSix();
      case 7:
        return const JobPostPageSeven();
      case 8:
        return const JobPostPreviewPage();
      default:
        return const SizedBox.shrink();
    }
  }
}
