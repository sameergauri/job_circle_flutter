// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_onboarding_titlle.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/add_education.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/add_experience.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class SelectExpEducation extends StatelessWidget {
  const SelectExpEducation({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Constants.white,
          appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: customText(
                  title: provider.formattedTime,
                  fontSize: 12,
                  color: Constants.red,
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: CustomButtonForSave(
              isPading: false,
              onTap: () {
                if (!provider.fresher && !provider.experience) {
                  CustomSnackbar.show("Select WorkExperience Type", true);
                } else if (!provider.graduate && !provider.undergraduate) {
                  CustomSnackbar.show("Select Highest Qualification", true);
                } else {
                  if (provider.fresher) {
                    NavigationService.push(AddEducation());
                  } else {
                    NavigationService.push(AddExperience());
                  }
                }
              },
              title: "Next",
              buttonColor: Constants.darkBlue,
              textColor: Constants.white,
            ),
          ),
          body: selectEducationAndExp(provider, width),
        );
      },
    );
  }

  //TODO:: Custom function....

  Widget selectEducationAndExp(
    SignupCreateUserProvider provider,
    double width,
  ) {
    // ignore: avoid_unnecessary_containers
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  provider.setFresher(true);
                },
                child: provider.fresher
                    ? Icon(
                        Icons.radio_button_checked_sharp,
                        color: Constants.blue,
                        size: 22,
                      )
                    : Icon(
                        Icons.circle_outlined,
                        color: Colors.grey.shade400,
                        size: 22,
                      ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customText(
                      title: "Fresher",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 5),
                    customText(
                      title:
                          "I am new to the workforce, with no prior professional experience.",
                      softwrap: true,
                      fontStyle: FontStyle.italic,
                      // wordSpacing: 2.0,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  provider.setExperienceStatus(true);
                },
                child: provider.experience
                    ? Icon(
                        Icons.radio_button_checked_sharp,
                        color: Constants.blue,
                        size: 22,
                      )
                    : Icon(
                        Icons.circle_outlined,
                        color: Colors.grey.shade400,
                        size: 22,
                      ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customText(
                      title: "Experience",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 5),
                    customText(
                      title:
                          "I have previous professional experience in one or more roles.",
                      softwrap: true,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          const Divider(thickness: 1.0),
          SizedBox(height: 20),
          const OnboardingTitle(title: "Highest Qualification"),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomGenderButton(
                width: width / 2.33,
                height: 40,
                onTap: () {
                  provider.setUndergraduate(true);
                },
                title: "Under - Graduate",
                isSelect: provider.undergraduate,
              ),
              CustomGenderButton(
                width: width / 2.33,
                height: 40,
                onTap: () {
                  provider.setGraduate(true);
                },
                title: "Graduate & Above",
                isSelect: provider.graduate,
              ),
            ],
          ),
          SizedBox(height: 30),
          const customText(
            title:
                "This information helps recruiter tailor the application process based on your career background.",
            textAlign: TextAlign.center,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
