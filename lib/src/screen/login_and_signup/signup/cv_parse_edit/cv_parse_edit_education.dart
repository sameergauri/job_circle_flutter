/* // ignore_for_file: null_check_always_fails, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unused_local_variable

import 'package:flutter/material.dart';
import 'package:jobcircleprovider/global.dart';
import 'package:jobcircleprovider/src/constants/colors.dart';
import 'package:jobcircleprovider/src/constants/custom_check_box_row.dart';
import 'package:jobcircleprovider/src/constants/custom_snackbar.dart';
import 'package:jobcircleprovider/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:jobcircleprovider/src/services/file_upload_service.dart';
import 'package:jobcircleprovider/src/services/navigation/navigation_services.dart';
import 'package:jobcircleprovider/src/utils/upload_file.dart';
import 'package:jobcircleprovider/src/widgets/button/custom_button_for_save.dart';
import 'package:jobcircleprovider/src/widgets/button/custom_document_upload_button.dart';
import 'package:jobcircleprovider/src/widgets/container/custom_container_to_view_document.dart';
import 'package:jobcircleprovider/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:jobcircleprovider/src/widgets/dropdown/month_drop_down.dart';
import 'package:jobcircleprovider/src/widgets/dropdown/year_drop_down.dart';
import 'package:jobcircleprovider/src/widgets/text/custom_text.dart';
import 'package:jobcircleprovider/src/widgets/text/custom_text_with_underline.dart';
import 'package:jobcircleprovider/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:provider/provider.dart';

class CvParseEditEducation extends StatelessWidget {
  final int? index;
  const CvParseEditEducation({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        // If editing existing education, populate the form
        if (index != null &&
            index! >= 0 &&
            index! < provider.educationModel.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.editEducation(index!);
          });
        }

        return Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () {
                  if (provider.schoolCollegeName.text.isEmpty &&
                      !provider.isRemote) {
                    CustomSnackbar.show(
                      "Enter School/College Name to save education",
                      true,
                    );
                  } else if (provider.universityBoardName.text.isEmpty) {
                    CustomSnackbar.show("Enter university name", true);
                  } else if (provider.degree.text.isEmpty) {
                    CustomSnackbar.show("Enter Degree to save education", true);
                  } else if (provider.startmonth.text.isEmpty ||
                      provider.startyear.text.isEmpty) {
                    CustomSnackbar.show("Enter Start Year", true);
                  } else if ((provider.endmonth.text.isEmpty ||
                          provider.endyear.text.isEmpty) &&
                      !provider.currentlyStudying) {
                    CustomSnackbar.show("Enter End Year", true);
                  } else {
                    provider.addOrUpdateEducation();
                    provider.updateProfileModelFromControllers();
                    NavigationService.pop();
                  }
                },
                title: provider.isEditingEducation ? "Update" : "Save",
                buttonColor: Constants.darkBlue,
                textColor: Constants.white,
              ),
            ),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: customText(title: "Edit Education"),
          ),
          backgroundColor: Constants.white,
          body: _customBody(context, provider),
        );
      },
    );
  }

  Widget _customBody(BuildContext context, SignupCreateUserProvider provider) {
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWithUnderLine(
                        title: "Edit Education",
                        fontSize: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const customText(
                    title: "School/College Name",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForMasterData(
                    contextIn: context,
                    controller: provider.schoolCollegeName,
                    hintText: "Type to search",
                    name: "school",
                    title: "School College Name",
                  ),
                  if (provider.schoolCollegeName.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CustomCheckboxRow(
                        title: "Study Remotely",
                        value: provider.isRemote,
                        onChanged: (value) {
                          provider.setIsRemote(value!);
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "University/Board Name*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForMasterData(
                    contextIn: context,
                    controller: provider.universityBoardName,
                    hintText: "Type to search",
                    name: "university",
                    title: "University",
                  ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Degree*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForMasterData(
                    contextIn: context,
                    controller: provider.degree,
                    hintText: "Type to search",
                    name: "degree",
                    title: "Degree",
                  ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Field of Study",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForMasterData(
                    contextIn: context,
                    controller: provider.fieldOFStudy,
                    hintText: "Type to search",
                    name: "field_of_study",
                    title: "Field of study",
                  ),
                  const SizedBox(height: 10),
                  customText(title: "Start Year*"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: MonthDropdown(
                          controller: provider.startmonth,
                          hint: "Select Month",
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: DropDownYear(
                          hint: 'Select Year',
                          controller: provider.startyear,
                          isFirst: true,
                        ),
                      ),
                    ],
                  ),
                  if (!provider.currentlyStudying) const SizedBox(height: 10),
                  if (!provider.currentlyStudying)
                    const customText(title: "End Year*"),
                  if (!provider.currentlyStudying)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: MonthDropdown(
                            controller: provider.endmonth,
                            hint: "Select Month",
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: DropDownYear(
                            hint: "Select Year",
                            controller: provider.endyear,
                            isFirst: false,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  CustomCheckboxRow(
                    title: "Currently Studying",
                    value: provider.currentlyStudying,
                    onChanged: (value) {
                      provider.endmonth.clear();
                      provider.endyear.clear();
                      provider.setCurrentlyStudying(value!);
                    },
                  ),

                  SizedBox(height: 10),
                  if (provider.markSheet == null || provider.markSheet == '')
                    CustomDocumentUploadButton(
                      onTab: () async {
                        FileUploader fileUploader = FileUploader();
                        var data = await fileUploader.uploadFile(context, [
                          'pdf',
                          'docx',
                          'doc',
                        ], "resume");
                        if (data != null) {
                          provider.setMarkSheet(data);
                        }
                      },
                      title: "MarkSheet",
                    ),
                  if (provider.markSheet != null && provider.markSheet != '')
                    CustomContainerSelectToViewDoc(
                      isDocx:
                          provider.markSheet!.contains('.docx') ||
                              provider.markSheet!.contains('.doc')
                          ? true
                          : false,
                      candidateName: 'MarkSheet',
                      heading: "MarkSheet",
                      title: provider.markSheet.toString(),
                      onPressed: () {
                        NavigationService.push(
                          CustomPDFViewerDialog(
                            pdfUrl:
                                "${GlobalConstants.Image_url}${provider.markSheet}",
                            isFromAts: false,
                            onDelete: () async {
                              await FileUploadService().deleteSingleFile(
                                provider.markSheet.toString(),
                              );
                              provider.setMarkSheet('');
                            },
                          ),
                        );
                      },
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
 */