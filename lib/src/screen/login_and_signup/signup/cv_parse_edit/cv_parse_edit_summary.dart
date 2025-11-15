// ignore_for_file: unused_result, must_be_immutable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:provider/provider.dart';

class CvParseEditSummary extends StatelessWidget {
  const CvParseEditSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              bottomNavigationBar: CustomButtonForSave(
                title:
                    "Save",
                onTap: () async {
                  if (provider.bio.text.isEmpty) {
                    CustomSnackbar.show("Enter Summary to submit", true);
                    return;
                  }
                  provider.updateSummaryFromControllerToModel(
                    provider.profileModel!,
                  );
                  NavigationService.pop();
                },
              ),
              resizeToAvoidBottomInset: true, // Add this line
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                titleSpacing: 0.0,
                automaticallyImplyLeading: true,
                backgroundColor: Constants.borderColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [OnboardingTitle(title: "Summary")],
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAutoSizeTextField(
                        controller: provider.bio,
                        hintText:
                            "Boost visibility with a compelling career summary.",
                        maxline: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (provider.isLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }
}
