import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class Page6Declaration extends StatelessWidget {
  const Page6Declaration({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BusinessCompanyProvider>();
    final colors = context.appColors;

    final firmName = provider.firmLegalNameController.text.trim().isNotEmpty
        ? provider.firmLegalNameController.text.trim()
        : provider.brandNameController.text.trim();
    final userName =
        Provider.of<JobProvider>(
          context,
          listen: false,
        ).userData?.userName.toString() ??
        '';

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.memberRole == "OWNER")
            customTextContainer(
              'Legal & Authority Declaration',
              firstStmt(firmName),
              false,
              colors,
            ),
          customTextContainer(
            'Candidate Fee & Ethical Hiring',
            secondStmt,
            false,
            colors,
          ),
          customTextContainer(
            'Job Posting & Client Disclosure',
            thirdStmt,
            false,
            colors,
          ),
          customTextContainer(
            'Data Protection & Confidentiality',
            fourthStmt,
            false,
            colors,
          ),
          customTextContainer(
            'Compliance & Liability',
            fifthStmt,
            false,
            colors,
          ),
          customTextContainer('Prohibited Activities', sixStmt, false, colors),
          customTextContainer('Fraud', sevnthStmt(userName), false, colors),
          /*   const SizedBox(height: 32),
          CustomButtonForSave(
            title: provider.isEditMode ? 'Update Company' : 'I Agree',
            isPading: false,
            onTap: () async {
              final success = await provider.submitCompanyForm(userId: userId);
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      provider.isEditMode
                          ? 'Company updated successfully!'
                          : 'Company created successfully! Pending admin approval.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
          ), */
        ],
      ),
    );
  }

  Widget customTextContainer(
    String title,
    String subtitle,
    bool haveFirmName,
    AppColors colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          title: title,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colors.headingColor,
        ),
        const SizedBox(height: 8),
        customText(title: subtitle, fontSize: 12, color: colors.subTitleColor),
        SizedBox(height: 10),
      ],
    );
  }

  String firstStmt(String firmName) =>
      "I, ${firmName.isNotEmpty ? firmName : 'the undersigned'}, hereby declare that I am a legally registered entity authorized to conduct recruitment and hiring activities. I confirm that I am duly authorized to represent the hiring companies or clients for the job positions that I post on the portal. I agree to provide valid documentation, including client authorization proof, company registration documents, and any additional verification documents, if requested by the portal for compliance purposes.";
  final String secondStmt =
      "I solemnly declare that I will not charge any registration fee, placement fee, security deposit, training fee, or any other monetary consideration from candidates for recruitment purposes through this portal. I agree that recruitment activities conducted through the portal will comply with all applicable labor laws, employment regulations, and industry standards.";
  final String thirdStmt =
      "I affirm that all company details, job descriptions, and information submitted by me are true, accurate, and not misleading. I confirm that all job postings will clearly disclose the actual hiring company name unless otherwise approved by the portal. I further declare that job postings will only be made after receiving a confirmed mandate or authorization from the client company, and no fake, speculative, or duplicate job openings will be posted.";
  final String fourthStmt =
      "I undertake to use candidate data solely for legitimate recruitment purposes and agree not to sell, share, misuse, or distribute candidate information to unauthorized parties. I acknowledge my responsibility to comply with applicable data protection and privacy laws and to maintain confidentiality of candidate information at all times.";
  final String fifthStmt =
      "I accept full responsibility for the authenticity and legality of all job postings made through my account. I understand and agree that the job portal shall not be held liable for disputes arising between the consultant, employer, or candidate. I further agree that any fraudulent activity, misrepresentation, policy violation, or verified complaint may result in immediate suspension or permanent termination of my account, and may lead to legal action where applicable.";
  final String sixStmt =
      "I confirm that I will not post any prohibited or misleading opportunities, including but not limited to work-from-home scams, investment-based jobs, network marketing schemes (unless clearly disclosed), visa-related scams, adult content, or any unlawful employment activities.";
  String sevnthStmt(String userName) =>
      "I understand that any fraud, misrepresentation, or policy violation may result in immediate suspension and legal action.\n\nI, ${userName.isNotEmpty ? userName : 'the undersigned'}, hereby declare that all information provided during registration is true and correct to the best of my knowledge. I understand that submission of false, inaccurate, or incomplete information may result in immediate account suspension, blacklisting, and possible legal consequences.";
}
