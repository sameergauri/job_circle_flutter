// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously
// ignore_for_file: todo

import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/basic_profile_detail.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class ResumeParsePage extends StatefulWidget {
  const ResumeParsePage({super.key});

  @override
  State<ResumeParsePage> createState() => _ResumeParsePageState();
}

class _ResumeParsePageState extends State<ResumeParsePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SignupCreateUserProvider>().startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                leadingWidth: 25,
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Constants.white,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: customText(
                      title: "Timer : ${provider.formattedTime}",
                      fontSize: 12,
                      color: Constants.red,
                    ),
                  ),
                ],
              ),
              backgroundColor: Constants.white,
              body: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: kToolbarHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(
                      title: "Your Career Quest Begins",
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Constants.winecolor,
                    ),
                    SizedBox(height: 10),
                    customText(
                      title: "Let's level up your professional profile",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Image.asset(CustomAssetUrl.onboardingicon),
                    ),
                    customButton(
                      CustomIconUrl.ailogo,
                      "Upload Your Resume",
                      "Our AI will build your profile in seconds",
                      () async {
                        provider.setLoading(true);
                        provider.setShowExperienceForm(false);
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
                        await provider.fetchParseData(
                          File(data.file.path),
                          data.uploadedFileName!,
                          context,
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          provider.setLoading(false);
                        });
                      },
                      Constants.diffblue,
                      Constants.indigo,
                      Constants.white,
                      Constants.white,
                      Constants.white,
                    ),
                    SizedBox(height: 10),
                    customButton(
                      CustomIconUrl.updatedetailicon,
                      "Build it yourself",
                      "No resume? No problem. We'll guide you",
                      () {
                        provider.clearAll();
                        NavigationService.push(BasicProfileDetail());
                      },
                      Constants.borderColor,
                      Constants.borderColor,
                      /*  Constants.skyblue,
                      Constants.dullgreen, */
                      Constants.subtitleclr,
                      Constants.subtitleclr,
                      Constants.subtitleclr,
                    ),
                  ],
                ),
              ),
            ),
            if (provider.isLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  InkWell customButton(
    String img,
    String title,
    String subtitle,
    Function onTab,
    Color clrone,
    Color clrtwo,
    Color titleColor,
    Color subtitleColor,
    Color iconcolor,
  ) {
    return InkWell(
      onTap: () {
        onTab();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Constants.lightBlue,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [clrone, clrtwo],
          ),
        ),
        child: Row(
          children: [
            Column(
              children: [
                CustomNetworkImage(
                  imageUrl: img,
                  defaultIcon: Icons.error,
                  height: 50,
                  width: 50,
                  color: iconcolor,
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customText(
                    title: title,
                    fontSize: 18,
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 6),
                  customText(
                    title: subtitle,
                    fontSize: 14,
                    color: subtitleColor,
                    fontStyle: FontStyle.italic,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
