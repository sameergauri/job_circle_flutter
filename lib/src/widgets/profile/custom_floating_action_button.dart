import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:provider/provider.dart';

class CustomFloatingButton extends StatelessWidget {
  final ProfileModel data;

  const CustomFloatingButton({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: Constants.white,
      onPressed: () {
        NavigationService.push(
          CustomPDFViewerDialog(
            title: "Resume",
            isFromAts: false,
            pdfUrl: "${GlobalConstants.Image_url}${data.resume}",
            onDelete: () async {
              await context.read<ProfileProvider>().updateResume(data, "null");
            },
          ),
        );
      },
      child: Image.asset(
        CustomAssetUrl.cvicon,
        height: 30,
        width: 30,
        color: Constants.darkBlue,
      ),
    );
  }
}
