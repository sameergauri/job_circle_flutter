import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/business_ats/business_ats_model.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class LeadDetail extends StatelessWidget {
  final AtsApplicant applicant;
  const LeadDetail({required this.applicant, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  const customText(
                    title: "Lead ID : ",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  customText(
                    title: applicant.leadId.toString(),
                    fontSize: 14,
                    color: Constants.subtitleclr,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  const customText(
                    title: "Lead Generation Date : ",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  customText(
                    title: /*  applicant.dol != null
                        ? DateFormat("dd MMMM y").format(
                            DateTime.fromMillisecondsSinceEpoch(applicant.dol!))
                        : */ applicant.dotFormatted != null
                        ? applicant.dolFormatted!
                        : "Not Available",
                    fontSize: 14,
                    color: Constants.subtitleclr,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  const customText(
                    title: "Last Update at : ",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  customText(
                    title: /*  applicant.dol != null
                        ? DateFormat("dd MMMM y").format(
                            DateTime.fromMillisecondsSinceEpoch(applicant.dol!))
                        : */ applicant.dolFormatted != null
                        ? applicant.dotFormatted!
                        : "Not Available",
                    fontSize: 14,
                    color: Constants.subtitleclr,
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
