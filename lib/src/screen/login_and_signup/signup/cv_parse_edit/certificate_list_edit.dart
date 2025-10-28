// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart'
    show NavigationService;
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/dropdown/month_drop_down.dart';
import 'package:job_circle/src/widgets/dropdown/year_drop_down.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class CertificateList extends StatelessWidget {
  final FromEditOrAdd fromEditOrAdd;
  const CertificateList({super.key, required this.fromEditOrAdd});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Constants.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            titleSpacing: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const OnboardingTitle(title: "Certificate"),
            actions: [
              !provider.showCertificateForm &&
                      provider.certificateModel.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        provider.clearCertificateForm();
                        provider.setShowCertificateForm(true);
                      },
                      icon: const Icon(Icons.add),
                    )
                  : (provider.certificateModel.isNotEmpty &&
                        fromEditOrAdd == FromEditOrAdd.edit)
                  ? IconButton(
                      onPressed: () {
                        provider.cancelCertificateEdit();
                        if (provider.certificateModel.length == 1) {
                          NavigationService.pop();
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          body: SafeArea(
            child:
                provider.certificateModel.isEmpty ||
                    provider.showCertificateForm
                ? customForm(provider, context)
                : CustomBody(provider),
          ),
        );
      },
    );
  }

  Widget customForm(SignupCreateUserProvider provider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title: "Certificate Name",
            fontStyle: FontStyle.italic,
          ),
          CustomTextFieldForMasterData(
            contextIn: context,
            controller: provider.certificateName,
            hintText: "Type to search",
            name: "certificate",
            title: "Certificate Name",
          ),
          const SizedBox(height: 15),
          const customText(
            title: "Issue Organization Name*",
            fontStyle: FontStyle.italic,
          ),
          CustomTextFieldForMasterData(
            contextIn: context,
            controller: provider.organizationName,
            hintText: "Type to search",
            name: "organization",
            title: "Organization Name",
          ),
          const SizedBox(height: 15),
          const customText(title: "Credential ID", fontStyle: FontStyle.italic),
          CustomTextFieldforAll(
            controller: provider.credentialId,
            hint: "Enter credential ID (optional)",
          ),
          const SizedBox(height: 15),
          const customText(
            title: "Credential URL",
            fontStyle: FontStyle.italic,
          ),
          CustomTextFieldforAll(
            controller: provider.credentialUrl,
            hint: "Enter credential URL (optional)",
          ),
          const SizedBox(height: 15),
          const customText(title: "Issue Date*"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: MonthDropdown(
                  controller: provider.issuemonth,
                  hint: "Select Month",
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: DropDownYear(
                  hint: "Select Year",
                  controller: provider.issueyear,
                  isFirst: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          const customText(title: "Valid till"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: MonthDropdown(
                  controller: provider.validmonth,
                  hint: "Select Month",
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: DropDownYear(
                  hint: "Select Year",
                  controller: provider.validyear,
                  isFirst: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(height: 10),
          if (provider.certificateFile == null ||
              provider.certificateFile == '')
            CustomDocumentUploadButton(
              subTitle: "Supported format : PDF",
              onTab: () async {
                FileUploader fileUploader = FileUploader();
                var data = await fileUploader.uploadFile(context, [
                  'pdf',
                ], "resume");
                if (data != null) {
                  provider.setCertificateDocument(data);
                }
              },
              title: "Certificate",
            ),
          if (provider.certificateFile != null &&
              provider.certificateFile != '')
            CustomContainerSelectToViewDoc(
              isDocx:
                  provider.certificateFile!.contains('.docx') ||
                      provider.certificateFile!.contains('.doc')
                  ? true
                  : false,
              candidateName: 'Certificate',
              heading: "Certificate",
              title: provider.certificateFile.toString(),
              onPressed: () {
                NavigationService.push(
                  CustomPDFViewerDialog(
                    title: 'Certificate',
                    pdfUrl:
                        "${GlobalConstants.Image_url}${provider.certificateFile}",
                    isFromAts: false,
                    onDelete: () async {
                      await FileUploadService().deleteSingleFile(
                        provider.certificateFile.toString(),
                      );
                      provider.setCertificateDocument('');
                    },
                  ),
                );
              },
            ),

          const SizedBox(height: 15),
          if (provider.isEditingCertificate &&
              provider.certificateModel.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    provider.removeCertificate(provider.certifiEditIndex!);
                    provider.clearCertificateForm();
                    provider.setShowCertificateForm(false);
                  },
                  child: customText(title: "Delete Certificate"),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomButtonForSave(
              isPading: false,
              onTap: () {
                if (provider.certificateName.text.isEmpty) {
                  CustomSnackbar.show(
                    "Enter Certification Name to save certificate",
                    true,
                  );
                } else if (provider.organizationName.text.isEmpty) {
                  CustomSnackbar.show(
                    "Enter Issuing Organization to save certificate",
                    true,
                  );
                } else if (provider.issuemonth.text.isEmpty ||
                    provider.issueyear.text.isEmpty) {
                  CustomSnackbar.show("Enter Issue date", true);
                } else {
                  provider.addOrUpdateCertificate();
                  if (provider.certificateModel.length == 1) {
                    NavigationService.pop();
                  }
                }
              },
              title:
                  /*  provider.isEditingCertificate &&
                      fromEditOrAdd == FromEditOrAdd.edit
                  ? "Update"
                  : */
                  "Save",
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomBody(SignupCreateUserProvider provider) {
    return ListView.separated(
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: const Divider(height: 1),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.certificateModel.length,
      itemBuilder: (context, index) {
        final sortedCertificates = [...provider.certificateModel];

        sortedCertificates.sort((a, b) {
          // Compare by issue year (descending order)
          int aYear = a.startYear ?? 0;
          int bYear = b.startYear ?? 0;
          return bYear.compareTo(aYear);
        });
        var cert = sortedCertificates[index];
        return Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: CustomNewListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Constants.lightdull),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CustomNetworkImage(
                height: 24,
                imageUrl: CustomIconUrl.certificateiicon,
                defaultIcon: Icons.workspace_premium_outlined,
              ),
            ),
            title: customText(
              title: cert.certificationName ?? '',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cert.issuingOrganization != null &&
                    cert.issuingOrganization != '')
                  customText(
                    title: cert.issuingOrganization ?? '',
                    fontWeight: FontWeight.w500,
                    color: Constants.subtitleclr,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (cert.credentialId != null && cert.credentialId != '')
                  customText(
                    title: cert.credentialId!,
                    fontWeight: FontWeight.w500,
                    color: Constants.subtitleclr,
                  ),
                if (cert.startMonth != null && cert.startYear != null)
                  Row(
                    children: [
                      customText(
                        monst: true,
                        title:
                            "${MonthNameConverter.getShortMonthName(cert.startMonth)} - ${cert.startYear}",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        color: Constants.subtitleclr,
                      ),
                    ],
                  ),
                if (cert.credentialUrl != null && cert.credentialUrl != '')
                  customText(
                    title: cert.credentialUrl!,
                    fontWeight: FontWeight.w500,
                    color: Constants.subtitleclr,
                    fontSize: 12,
                  ),
              ],
            ),
            trailing: CustomIconButton(
              imageUrl: CustomIconUrl.editicon,
              onTap: () {
                provider.editCertificate(index);
              },
            ),
          ),
        );
      },
    );
  }
}
