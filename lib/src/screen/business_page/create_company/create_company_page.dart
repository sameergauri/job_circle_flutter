import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/screen/business_job/Job_post_master_page.dart';
import 'package:job_circle/src/screen/business_page/create_company/page1_role_selection.dart';
import 'package:job_circle/src/screen/business_page/create_company/page2_business_detail.dart';
import 'package:job_circle/src/screen/business_page/create_company/page3_register_office.dart';
import 'package:job_circle/src/screen/business_page/create_company/page4_identity_verification.dart';
import 'package:job_circle/src/screen/business_page/create_company/page5_documents.dart';
import 'package:job_circle/src/screen/business_page/create_company/page6_decleration.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class CreateCompanyPage extends StatelessWidget {
  final ForNewJob forNewJob;
  const CreateCompanyPage({super.key, required this.forNewJob});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Consumer<BusinessCompanyProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: colors.bgColor,
              appBar: AppBar(
                backgroundColor: colors.appbarColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: colors.headingColor),
                  onPressed: () {
                    if (provider.currentPageIndex == 0) {
                      Navigator.pop(context);
                    } else {
                      provider.handlePreviousPage();
                    }
                  },
                ),
                title: customText(
                  title: _getAppBarTitle(provider.currentPageIndex),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.headingColor,
                ),
                elevation: 0,
                titleSpacing: 0,
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: _buildBottomButton(context, provider),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  // padding: const EdgeInsets.all(20),
                  child: _buildPageContent(provider.currentPageIndex),
                ),
              ),
            ),
            if (provider.isLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Business Category';
      case 1:
        return 'Business Page';
      case 2:
        return 'Registered Office';
      case 3:
        return 'Identity Verification';
      case 4:
        return 'Documents';
      case 5:
        return 'Declaration';
      default:
        return 'Company Registration';
    }
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return const Page1RoleSelection();
      case 1:
        return const Page2BusinessDetails();
      case 2:
        return const Page3RegisteredOffice();
      case 3:
        return const Page4IdentityVerification();
      case 4:
        return const Page5Documents();
      case 5:
        return const Page6Declaration();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Dynamic Bottom Button based on Page Index
  Widget _buildBottomButton(
    BuildContext context,
    BusinessCompanyProvider provider,
  ) {
    final currentIndex = provider.currentPageIndex;

    final bool isForNewJob = forNewJob == ForNewJob.NEW;
    // For the combined "post job for a new company" flow, Identity
    // Verification, Documents and Declaration (indexes 3, 4, 5) all move to
    // after the job-post form — so Registered Office (OWNER) / Role
    // Selection (non-OWNER) becomes the last step shown here.
    final bool isLastStepForNewJob =
        isForNewJob &&
        _isLastStepBeforeJobPost(currentIndex, provider.memberRole);

    // Default title mapping for pages
    String buttonTitle = 'Save & Continue';
    if (currentIndex == 0) {
      buttonTitle = 'Next';
    } else if (currentIndex == 3 || currentIndex == 4) {
      buttonTitle = 'Submit';
    } else if (currentIndex == 5) {
      buttonTitle = isForNewJob
          ? 'Continue'
          : (provider.isEditMode ? 'Update Company' : 'I Agree');
    }
    if (isLastStepForNewJob) {
      buttonTitle = 'Continue';
    }

    return CustomButtonForSave(
      isPading: false,
      title: buttonTitle,
      // isLoading: provider.isCreating,
      onTap: () async {
        if (isLastStepForNewJob) {
          // Company isn't created yet here — Identity Verification,
          // Documents and Declaration are collected after the job-post form,
          // and everything gets created together when "Post Job" is tapped.
          NavigationService.push(JobPostMasterScreen(forNewJob: ForNewJob.NEW));
          return;
        }
        // Final Page logic
        if (currentIndex == 5) {
          int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
          final success = await provider.submitCompanyForm(userId: userid);
          if (context.mounted && success != null) {
            CustomSnackbar.show(
              provider.isEditMode
                  ? 'Company updated successfully!'
                  : 'Company created successfully! Pending admin approval.',
              false,
            );
            NavigationService.pop();
          } else {
            CustomSnackbar.show(
              provider.isEditMode
                  ? 'Getting error while updating data!'
                  : 'Getting error while creating company.',
              true,
            );
            NavigationService.pop();
          }
        } else {
          // Navigation to next page
          provider.handleNextPage();
        }
      },
    );
  }

  // NEW flow only: after this step, control passes into JobPostMasterScreen
  // (Identity Verification / Documents / Declaration are asked there instead).
  bool _isLastStepBeforeJobPost(int currentIndex, String? memberRole) {
    if (memberRole == 'OWNER') {
      return currentIndex == 2; // after Registered Office
    }
    return currentIndex == 0; // right after role selection
  }
}
