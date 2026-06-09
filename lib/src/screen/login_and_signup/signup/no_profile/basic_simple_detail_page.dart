// ignore_for_file: annotate_overrides, todo
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_onboarding_titlle.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class SimpleBasicDetail extends StatefulWidget {
  const SimpleBasicDetail({super.key});

  @override
  State<SimpleBasicDetail> createState() => _SimpleBasicDetailState();
}

class _SimpleBasicDetailState extends State<SimpleBasicDetail> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SignupCreateUserProvider>(
        context,
        listen: false,
      ).initializeController(
        SharedPrefsHelper.getInt(ESharedPreferences.user_mobile).toString(),
      );
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final jobprovider = Provider.of<JobProvider>(context, listen: false);
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () async {
                  if (provider.firstname.text.isEmpty) {
                    CustomSnackbar.show("Enter First Name", true);
                  } else if (provider.lastname.text.isEmpty) {
                    CustomSnackbar.show("Enter Last Name", true);
                  } else if (provider.location.text.isEmpty) {
                    CustomSnackbar.show("Enter your location city", true);
                  } else if (!provider.male && !provider.female) {
                    CustomSnackbar.show("Select Gender", true);
                  } else if (!provider.graduate && !provider.undergraduate) {
                    CustomSnackbar.show("Select level of education", true);
                  } else if (!provider.fresher && !provider.experience) {
                    CustomSnackbar.show("Select Work status", true);
                  } else {
                    final done = await provider.saveUserDataWithoutProfile();
                    if (done) {
                      await jobprovider.fetchJobs(applyCityFilter: false);
                    }
                  }
                },
                title: "Submit",
                buttonColor: Constants.darkBlue,
                textColor: Constants.white,
              ),
            ),
          ),
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
          backgroundColor: Constants.white,
          body: _customBody(provider),
        );
      },
    );
  }

  Widget _customBody(SignupCreateUserProvider provider) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const customText(title: "First Name*", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.firstname,
              hint: "Enter First Name",
            ),
            const SizedBox(height: 15),
            const customText(title: "Middle Name", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.middlename,
              hint: "Enter Middle Name",
            ),
            const SizedBox(height: 15),
            const customText(title: "Last Name*", fontStyle: FontStyle.italic),
            CustomTextFieldforAll(
              controller: provider.lastname,
              hint: "Enter Last Name",
            ),
            const SizedBox(height: 15),
            const customText(title: "City*", fontStyle: FontStyle.italic),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: provider.location,
              hintText: "Type to search",
              name: "city",
              title: "Location",
            ),
            const SizedBox(height: 15),
            const customText(title: "Gender*", fontStyle: FontStyle.italic),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomGenderButton(
                  width: MediaQuery.of(context).size.width / 2.33,
                  height: 40,
                  title: "  Male  ",
                  isSelect: provider.male,
                  onTap: () {
                    provider.setGender('male');
                  },
                ),
                CustomGenderButton(
                  width: MediaQuery.of(context).size.width / 2.33,
                  height: 40,
                  title: "  Female  ",
                  isSelect: provider.female,
                  onTap: () {
                    provider.setGender('female');
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Level of education*",
              fontStyle: FontStyle.italic,
            ),
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
            const SizedBox(height: 15),
            const customText(
              title: "Work status*",
              fontStyle: FontStyle.italic,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomGenderButton(
                  width: width / 2.33,
                  height: 40,
                  onTap: () {
                    provider.setFresher(true);
                  },
                  title: "Fresher",
                  isSelect: provider.fresher,
                ),
                CustomGenderButton(
                  width: width / 2.33,
                  height: 40,
                  onTap: () {
                    provider.setExperienceStatus(true);
                  },
                  title: "Experience",
                  isSelect: provider.experience,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
