// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
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
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class ProfileCertificateEdit extends StatelessWidget {
  final FromEditOrAdd fromEditOrAdd;
  const ProfileCertificateEdit({super.key, required this.fromEditOrAdd});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Constants.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            titleSpacing: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const OnboardingTitle(title: "Certificate", fontSize: 16),
            actions: [
              !provider.showCertificateForm &&
                      provider.profile!.certifications!.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        provider.clearCertificateForm();
                        provider.setShowCertificateForm(true);
                      },
                      icon: const Icon(Icons.add),
                    )
                  : (provider.profile!.certifications != null &&
                        provider.profile!.certifications!.isNotEmpty &&
                        fromEditOrAdd == FromEditOrAdd.edit)
                  ? IconButton(
                      onPressed: () {
                        provider.cancelCertificateEdit();
                        if (provider.profile!.certifications != null &&
                            provider.profile!.certifications!.length == 1) {
                          NavigationService.pop();
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          body: SafeArea(
            child:
                provider.profile!.certifications!.isEmpty ||
                    provider.showCertificateForm
                ? customForm(provider, context)
                : CustomBody(provider),
          ),
        );
      },
    );
  }

  Widget customForm(ProfileProvider provider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const customText(
              title: "Certification Name*",
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
              title: "Issuing Organization*",
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
            const customText(
              title: "Credential ID",
              fontStyle: FontStyle.italic,
            ),
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
                provider.profile!.certifications!.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.removeCertificate(
                        provider.isEditCertificateIndex!,
                      );
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
                  }
                },
                title: /* provider.isEditingCertificate ? "Update" : */ "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomBody(ProfileProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Divider(height: 1),
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: provider.profile!.certifications!.length,
        itemBuilder: (context, index) {
          final data = provider.profile!.certifications![index];
          return Column(
            children: [
              ListTile(
                onTap: () {},
                contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                leading: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Constants.lightdull),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: (data.certLogo != null && data.certLogo!.isNotEmpty)
                      ? CustomNetworkImage(
                          imageUrl:
                              "${GlobalConstants.Image_url}${data.certLogo}",
                          defaultIcon: Icons.business_sharp,
                        )
                      : CustomNetworkImage(
                          imageUrl: CustomIconUrl.certificateiicon,
                          defaultIcon: Icons.cast_for_education,
                        ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        title: data.certificationName.toString(),
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      customText(
                        monst: true,
                        title: data.issuingOrganization.toString(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                subtitle: customText(
                  monst: true,
                  title:
                      "${MonthNameConverter.getShortMonthName(data.startMonth)} - ${data.startYear}",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  color: Constants.subtitleclr,
                ),
                trailing: CustomIconButton(
                  imageUrl: CustomIconUrl.editicon,
                  onTap: () {
                    provider.editCertificate(index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
