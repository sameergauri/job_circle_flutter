import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';

class CvParseFAB extends StatelessWidget {
  final UserRequest data;
  final SignupCreateUserProvider provider;

  const CvParseFAB({super.key, required this.data, required this.provider});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Constants.white,
      onPressed: () {
        NavigationService.push(
          CustomPDFViewerDialog(
            isFromAts: false,
            pdfUrl: "${GlobalConstants.Image_url}${data.cvLink}",
            onDelete: () async {},
          ),
        );
      },
      child: CustomNetworkImage(
        imageUrl: CustomIconUrl.documenticon,
        defaultIcon: Icons.cast_for_education,
      ),
    );
  }
}
