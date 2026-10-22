// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/app_theme_provider.dart/app_theme_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_bottom_sheet_for_business_ats.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder_kit/resume_builder_kit.dart';

/// Reusable "Add Resume" bottom sheet offering the two existing ways to add
/// a resume — build one with the template tool, or upload an existing file.
/// Callable from anywhere that has a [ProfileProvider] and [ProfileModel];
/// the behaviour behind each option is unchanged from before.
class CustomBottomSheetForResume {
  static Future<void> show({
    required BuildContext context,
    required ProfileProvider provider,
    required ProfileModel profileData,
  }) {
    final colors = context.appColors;

    return showModalBottomSheet(
      barrierColor: colors.headingColor!.withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      elevation: 1,
      context: context,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: colors.bottomsheetbgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      title: "Add Resume",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.darkBlue,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: colors.headingColor,
                      ),
                    ),
                  ],
                ),
                CustomListTileForBottomSheet(
                  title: "Build Resume",
                  subtitle: "Create a polished resume with our templates",
                  imgurl: CustomIconUrl.buildresumeicon,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _buildResume(context, provider, profileData);
                  },
                ),
                CustomListTileForBottomSheet(
                  title: "Add Resume",
                  subtitle: "Upload an existing PDF or Word file",
                  imgurl: CustomIconUrl.addresumeicon,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _uploadResume(context, provider, profileData);
                  },
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _buildResume(
    BuildContext context,
    ProfileProvider provider,
    ProfileModel profileData,
  ) {
    final themeProvider = context.read<ThemeProvider>();
    final fileUploader = FileUploader();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResumeTemplateSelectionScreen(
          themeMode: themeProvider.themeMode,
          buttonTitle: "Add To Profile",
          userProfileJson: profileData.toJson(),
          geminiApiKey: 'AIzaSyAnhaXULIUPpgeewuV7_bFZBhZBPL1PLBc',
          onPdfGenerated: (Uint8List pdfBytes) async {
            String? uploadedFileName = await fileUploader.uploadGeneratedPdf(
              context,
              pdfBytes,
            );
            if (uploadedFileName != null) {
              await provider.updateResume(profileData, uploadedFileName);
              CustomSnackbar.show("Resume Uploaded Successfully", false);
              NavigationService.pop();
              NavigationService.pop();
            }
          },
        ),
      ),
    );
  }

  static Future<void> _uploadResume(
    BuildContext context,
    ProfileProvider provider,
    ProfileModel profileData,
  ) async {
    provider.setLoading(true);
    FileUploader fileUploader = FileUploader();
    var data = await fileUploader.pickFileAndUpload(
      needToUpload: true,
      context,
      allowedExt: ['pdf', 'doc', 'docx'],
      folder: "resume",
    );
    if (data == null) {
      provider.setLoading(false);
      return;
    }
    provider.fetchParseData(
      File(data.file.path),
      data.uploadedFileName!,
      context,
      profileData,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      provider.setLoading(false);
    });
  }
}
