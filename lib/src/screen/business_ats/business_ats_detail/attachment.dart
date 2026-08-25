import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';

class AtsAttachment extends StatelessWidget {
  final String resume;
  final String candidateName;
  final String? contactno;
  final String? alternateno;
  const AtsAttachment({
    super.key,
    required this.resume,
    required this.candidateName,
    this.contactno,
    this.alternateno,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resume != "")
              CustomContainerSelectToViewDoc(
                isDocx: resume.contains('.docx') ? true : false,
                candidateName: candidateName,
                heading: "Resume",
                // date: dol,
                title: resume.replaceAll('cv', '').replaceAll('/', ''),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomPDFViewerDialog(
                        // contact_no: contactno,
                        pdfUrl:
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/$resume",
                        isFromAts: true,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
