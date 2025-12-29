// ignore_for_file: null_check_always_fails, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unused_local_variable, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_onboarding_titlle.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/custom_get_month.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_icon_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_confirmation.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/dropdown/month_drop_down.dart';
import 'package:job_circle/src/widgets/dropdown/year_drop_down.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text/custom_text_with_underline.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder_kit/resume_builder_kit.dart';

class AddCertificate extends StatelessWidget {
  const AddCertificate({super.key});

  @override
  Widget build(BuildContext context) {
    final jobprovider = Provider.of<JobProvider>(context, listen: false);
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              bottomNavigationBar:
                  (provider.certificateModel.isEmpty &&
                          (!provider.hasCertData)) ||
                      !provider.showCertificateForm
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        child: CustomButtonForSave(
                          isPading: false,
                          onTap: () async {
                            if (provider.certificateModel.isEmpty &&
                                (provider.certificateName.text.isNotEmpty ||
                                    provider.organizationName.text.isNotEmpty ||
                                    provider.issuemonth.text.isNotEmpty ||
                                    provider.issueyear.text.isNotEmpty)) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialogForConfirmation(
                                    title: "Are Sure? wannt to skip",
                                    onYes: () async {
                                      final done = await provider
                                          .saveUserData();
                                      if (done) {
                                        await jobprovider.fetchJobs(
                                          applyCityFilter: false,
                                        );
                                      }
                                    },
                                    subtitle:
                                        "You enter a skip button without saving the certificate data",
                                    button1text: "Yes",
                                    onlysinglebutton: true,
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResumeTemplateSelectionScreen(
                                    userProfileJson: provider
                                        .buildProfileModelFromProvider(
                                          provider,
                                        ).toJson(),
                                    geminiApiKey:
                                        'AIzaSyAnhaXULIUPpgeewuV7_bFZBhZBPL1PLBc', // null = skip AI polishing
                                    onPdfGenerated: (Uint8List pdfBytes) async {
                                      FileUploader fileUploader =
                                          FileUploader();
                                      //TODO:: save the selected resume file path to user profile
                                      String? uploadedFileName =
                                          await fileUploader.uploadGeneratedPdf(
                                            context,
                                            pdfBytes,
                                          );
                                      if (uploadedFileName != null) {
                                        provider.setResume(uploadedFileName);
                                        if (provider.resume != null &&
                                            provider.resume != '') {
                                          final done = await provider
                                              .saveUserData();
                                          if (done) {
                                            await jobprovider.fetchJobs(
                                              applyCityFilter: false,
                                            );
                                          }
                                        }
                                        CustomSnackbar.show(
                                          "Resume Uploaded Successfully",
                                          false,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              );
                            }
                            // NavigationService.push(AddCertificate());
                          },
                          title: provider.certificateModel.isEmpty
                              ? "Skip"
                              : "Submit",
                          buttonColor: Constants.darkBlue,
                          textColor: Constants.white,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              appBar: AppBar(
                titleSpacing: 0.0,
                backgroundColor: Constants.borderColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnboardingAppBarHeading(),
                    OnboardingAppBarSubTitle(),
                  ],
                ),
                actions: [
                  (provider.certificateModel.isNotEmpty &&
                          provider.showCertificateForm)
                      ? IconButton(
                          onPressed: () {
                            provider.cancelCertificateEdit();
                          },
                          icon: const Icon(Icons.cancel_outlined),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              backgroundColor: Constants.white,
              floatingActionButton:
                  !provider.showCertificateForm &&
                      provider.certificateModel.isNotEmpty
                  ? FloatingActionButton(
                      backgroundColor: Constants.borderColor,
                      onPressed: () {
                        provider.clearCertificateForm();
                        provider.setShowCertificateForm(true);
                      },
                      child: const Icon(Icons.add),
                    )
                  : const SizedBox.shrink(),

              body: _customBody(context, provider),
            ),
            if (provider.isLoading) CustomLoadingIndicator(),
          ],
        );
      },
    );
  }

  Widget _customBody(BuildContext context, SignupCreateUserProvider provider) {
    var width = MediaQuery.of(context).size.width;

    // Automatically show form if no certificates are added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.certificateModel.isEmpty && !provider.showCertificateForm) {
        provider.setShowCertificateForm(true);
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show form if needed
            if (provider.showCertificateForm ||
                provider.certificateModel.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWithUnderLine(
                          title: "Certificate",
                          fontSize: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const customText(
                      title: "Certification Name*",
                      fontStyle: FontStyle.italic,
                    ),
                    CustomTextFieldForMasterData(
                      focusNode: provider.certificateNameFocusNode,
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
                      focusNode: provider.organizationNameFocusNode,
                      contextIn: context,
                      controller: provider.organizationName,
                      hintText: "Type to search",
                      name: "issue-cert",
                      title: "Organization",
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
                            onChanged: (value) {
                              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                              provider.notifyListeners();

                              // Also clear the Valid Year because the old value might be invalid now
                              provider.validyear.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                    if (provider.dontHaveExpiry == false)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                                  firstYearController: provider.issueyear,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    CustomCheckboxRow(
                      title: "this Certificate dont have expiry",
                      value: provider.dontHaveExpiry,
                      onChanged: (value) {
                        provider.SetDontHaveExpiry(value!);
                      },
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
                              provider.removeCertificate(
                                provider.certifiEditIndex!,
                              );
                              provider.clearCertificateForm();
                              provider.setShowCertificateForm(false);
                            },
                            child: customText(title: "Delete Certificate"),
                          ),
                        ],
                      ),
                    if (provider.hasCertData)
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
                          title: /* provider.isEditingCertificate
                              ? "Update"
                              : */
                              "Save",
                        ),
                      ),
                  ],
                ),
              ),
            // Display list of certificates if any
            if (provider.certificateModel.isNotEmpty &&
                !provider.showCertificateForm)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(
                  builder: (context) {
                    // Sort the list but keep track of original indices
                    final sortedCertificatesWithIndex = List.generate(
                      provider.certificateModel.length,
                      (index) => {
                        'certificate': provider.certificateModel[index],
                        'originalIndex': index,
                      },
                    );

                    sortedCertificatesWithIndex.sort((a, b) {
                      final certA = a['certificate'] as CertificationRequest;
                      final certB = b['certificate'] as CertificationRequest;

                      // Compare by issue year (descending order)
                      int aYear = certA.startYear ?? 0;
                      int bYear = certB.startYear ?? 0;
                      return bYear.compareTo(aYear);
                    });
                    return ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: const Divider(height: 1),
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedCertificatesWithIndex.length,
                      itemBuilder: (context, index) {
                        final item = sortedCertificatesWithIndex[index];
                        final cert =
                            item['certificate'] as CertificationRequest;
                        final originalIndex = item['originalIndex'] as int;
                        return CustomNewListTile(
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
                              if (cert.credentialId != null &&
                                  cert.credentialId != '')
                                customText(
                                  title: cert.credentialId!,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.subtitleclr,
                                ),
                              if (cert.startMonth != null &&
                                  cert.startYear != null)
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
                              if (cert.credentialUrl != null &&
                                  cert.credentialUrl != '')
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
                              provider.editCertificate(originalIndex);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
