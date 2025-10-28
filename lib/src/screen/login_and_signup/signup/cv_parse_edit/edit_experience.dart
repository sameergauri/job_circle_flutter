/* // ignore_for_file: null_check_always_fails, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jobcircleprovider/src/constants/colors.dart';
import 'package:jobcircleprovider/src/constants/custom_check_box_row.dart';
import 'package:jobcircleprovider/src/constants/custom_snackbar.dart';
import 'package:jobcircleprovider/src/constants/enum.dart';
import 'package:jobcircleprovider/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:jobcircleprovider/src/services/file_upload_service.dart';
import 'package:jobcircleprovider/src/services/navigation/navigation_services.dart';
import 'package:jobcircleprovider/src/utils/date_picker/custom_date_picker.dart';
import 'package:jobcircleprovider/src/utils/upload_file.dart';
import 'package:jobcircleprovider/src/widgets/bottom_sheet/custom_popup_for_location.dart';
import 'package:jobcircleprovider/src/widgets/button/custom_button_for_save.dart';
import 'package:jobcircleprovider/src/widgets/button/custom_document_upload_button.dart';
import 'package:jobcircleprovider/src/widgets/button/custom_full_size_button.dart';
import 'package:jobcircleprovider/src/widgets/container/custom_container_to_view_document.dart';
import 'package:jobcircleprovider/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:jobcircleprovider/src/widgets/text/custom_text.dart';
import 'package:jobcircleprovider/src/widgets/text/custom_text_with_underline.dart';
import 'package:jobcircleprovider/src/widgets/text_field/custom_auto_size_text_field.dart';
import 'package:jobcircleprovider/src/widgets/text_field/custom_suggestion_text_field.dart';
import 'package:jobcircleprovider/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:jobcircleprovider/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class EditExperience extends StatelessWidget {
  final bool isEdit;
  final int? index;
  const EditExperience({super.key, required this.isEdit, this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupCreateUserProvider>(
      builder: (context, provider, child) {
        if (isEdit && index != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.editExperience(index!);
          });
        }
        return Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomButtonForSave(
                isPading: false,
                onTap: () async {
                  if (provider.jobtitle.text.isEmpty) {
                    CustomSnackbar.show("Enter Job Title", true);
                  } else if (provider.companyname.text.isEmpty) {
                    CustomSnackbar.show("Enter Company Name", true);
                  } else if (provider.industry.text.isEmpty) {
                    CustomSnackbar.show("Enter Industry", true);
                  } else if (provider.functionalArea.text.isEmpty) {
                    CustomSnackbar.show("Enter Functional Area", true);
                  } else if (provider.startDate.text.isEmpty) {
                    CustomSnackbar.show("Enter Start date", true);
                  } else if (!provider.currentlyWorking &&
                      provider.lastWorkingDate.text.isEmpty) {
                    CustomSnackbar.show("Enter Last date", true);
                  } else if (provider.anualSalary.text.isEmpty) {
                    CustomSnackbar.show("Enter Anual Salary", true);
                  } else if (!provider.onSite &&
                      !provider.hybrid &&
                      !provider.remote) {
                    CustomSnackbar.show("Select work mode", true);
                  } else if (!provider.fullTime &&
                      !provider.partTime &&
                      !provider.contractual &&
                      !provider.freelancer &&
                      !provider.internship) {
                    CustomSnackbar.show("Select employmentType", true);
                  } else {
                    // Add or update experience in the model
                    provider.addOrUpdateExperience();

                    // Update profile model from controllers
                    provider.updateProfileModelFromControllers();

                    // Navigate back to CV parse profile
                    NavigationService.pop();
                  }
                },
                title: isEdit ? "Update" : "Save",
                buttonColor: Constants.darkBlue,
                textColor: Constants.white,
              ),
            ),
          ),
          appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: customText(title: "Edit Experience"),
          ),
          backgroundColor: Constants.white,
          body: _customBody(context, provider),
        );
      },
    );
  }

  Widget _customBody(BuildContext context, SignupCreateUserProvider provider) {
    var width = MediaQuery.of(context).size.width;
    Widget buildDocumentSection(List<String>? availableDocuments) {
      // If no documents are true, return an empty container or null
      if (availableDocuments == null || availableDocuments.isEmpty) {
        return Container();
      }

      return Wrap(
        spacing: 5.0, // Space between items
        children: availableDocuments.asMap().entries.map((entry) {
          int index = entry.key;
          String title = entry.value;
          return customText(
            // Add comma after each title except the last one
            title: index < availableDocuments.length - 1 ? '$title,' : title,
          );
        }).toList(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWithUnderLine(
                        title: "Add Experience",
                        fontSize: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const customText(
                    title: "Job Title*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForMasterData(
                    contextIn: context,
                    controller: provider.jobtitle,
                    hintText: "Type to search",
                    name: "job_role",
                    title: "Job Title",
                  ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Company Name*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomSuggestionTextField(
                    EnableAddOption: true,
                    type: SuggestionType.company,
                    onIdSelected: (p0) {
                      provider.notifyListeners();
                    },
                    name: "company",
                    title: "Company Name",
                    controller: provider.companyname,
                    onChanged: (p0) {},
                    hintText: "Company Name",
                  ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Industry*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForMasterData(
                    contextIn: context,
                    controller: provider.industry,
                    hintText: "Type to search",
                    name: "industry",
                    title: "Industry",
                  ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Functional Area*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldForMasterData(
                    contextIn: context,
                    controller: provider.functionalArea,
                    hintText: "Type to search",
                    name: "functional_area",
                    title: "Functional Area",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const customText(
                            title: "Start Date*",
                            fontStyle: FontStyle.italic,
                          ),
                          SizedBox(
                            width: width / 2.6,
                            child: CustomTextFieldforAll(
                              controller: provider.startDate,
                              hint: "Select start date",
                              readonly: true,
                              onTab: () async {
                                DateTime? initialDate;
                                if (provider.startDate.text.isNotEmpty) {
                                  try {
                                    initialDate = DateFormat(
                                      'dd MMM yyyy',
                                    ).parse(provider.startDate.text);
                                  } catch (e) {
                                    initialDate = DateTime.now();
                                  }
                                } else {
                                  initialDate = DateTime.now();
                                }

                                // Get lastDate for maxDate constraint
                                DateTime? maxDate;
                                if (provider.lastWorkingDate.text.isNotEmpty) {
                                  try {
                                    maxDate = DateFormat(
                                      'dd MMM yyyy',
                                    ).parse(provider.lastWorkingDate.text);
                                  } catch (e) {
                                    maxDate = null;
                                  }
                                }

                                DateTime? selectedDate =
                                    await CustomDatePickerForWorkSpace.selectDate(
                                      context: context,
                                      initialDate: initialDate,
                                      title: "Select Start Date",
                                      maxDate: maxDate,
                                      isStartDate: true,
                                    );

                                if (selectedDate != null) {
                                  String formattedDate = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(selectedDate);
                                  provider.setStartDate(formattedDate);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      if (!provider.currentlyWorking &&
                          provider.startDate.text.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const customText(
                              title: "Last Date*",
                              fontStyle: FontStyle.italic,
                            ),
                            SizedBox(
                              width: width / 2.6,
                              child: CustomTextFieldforAll(
                                controller: provider.lastWorkingDate,
                                hint: "Select last date",
                                readonly: true,
                                onTab: () async {
                                  DateTime? initialDate;
                                  if (provider
                                      .lastWorkingDate
                                      .text
                                      .isNotEmpty) {
                                    try {
                                      initialDate = DateFormat(
                                        'dd MMM yyyy',
                                      ).parse(provider.lastWorkingDate.text);
                                    } catch (e) {
                                      initialDate = DateTime.now();
                                    }
                                  } else {
                                    initialDate = DateTime.now();
                                  }

                                  // Get startDate for minDate constraint
                                  DateTime? minDate;
                                  if (provider.startDate.text.isNotEmpty) {
                                    try {
                                      minDate = DateFormat(
                                        'dd MMM yyyy',
                                      ).parse(provider.startDate.text);
                                      // Add 1 day to minDate to ensure lastDate is after startDate
                                      minDate = minDate.add(
                                        const Duration(days: 1),
                                      );
                                    } catch (e) {
                                      minDate = null;
                                    }
                                  }

                                  DateTime? selectedDate =
                                      await CustomDatePickerForWorkSpace.selectDate(
                                        context: context,

                                        initialDate:
                                            provider.startDate.text.isNotEmpty
                                            ? DateFormat('dd MMM yyyy')
                                                  .parse(
                                                    provider.startDate.text,
                                                  )
                                                  .add(const Duration(days: 1))
                                            : initialDate,
                                        title: "Select Last Date",
                                        minDate:
                                            provider.startDate.text.isNotEmpty
                                            ? DateFormat('dd MMM yyyy')
                                                  .parse(
                                                    provider.startDate.text,
                                                  )
                                                  .add(const Duration(days: 1))
                                            : minDate,
                                        isStartDate: false,
                                      );

                                  if (selectedDate != null) {
                                    String formattedDate = DateFormat(
                                      'dd MMM yyyy',
                                    ).format(selectedDate);
                                    provider.setLastDate(formattedDate);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomCheckboxRow(
                    title: "Currently Working*",
                    value: provider.currentlyWorking,
                    onChanged: (value) {
                      provider.lastWorkingDate.clear();
                      //  provider.clearExp();
                      provider.setCurrentlyWorking(value!);
                    },
                  ),
                  SizedBox(height: 10),
                  const customText(title: "Job Responsibility"),
                  CustomAutoSizeTextField(
                    controller: provider.jobrole,
                    hintText: "My job profile is",
                    maxline: 4,
                    maxLength: 1200,
                  ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Salary*",
                    fontStyle: FontStyle.italic,
                  ),
                  CustomTextFieldforAll(
                    isGmail: true,
                    maxLength: 7,
                    isNumber: true,
                    controller: provider.anualSalary,
                    hint: "Enter salary",
                  ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Work Mode*",
                    fontStyle: FontStyle.italic,
                  ),
                  Wrap(
                    children: [
                      CustomPopUpForLocation(
                        isWorkspace: true,
                        initiallySelectedItems: provider.onSiteLocation != null
                            ? [provider.onSiteLocation!]
                            : [],
                        onSelectionComplete: (selectedItems) {},
                        isSelect: provider.onSite,
                        title: "On-Site",
                        name: "location",
                        hintText: "Mumbai",
                        onSubmit: (p0) {
                          provider.setWorkType(1, p0);
                        },
                      ),
                      CustomPopUpForLocation(
                        onSelectionComplete: (selectedItems) {},
                        isWorkspace: true,
                        initiallySelectedItems: provider.hybridLocation != null
                            ? [provider.hybridLocation!]
                            : [],
                        onSubmit: (selectedItems) {
                          provider.setWorkType(2, selectedItems);
                        },
                        isSelect: provider.hybrid,
                        title: "Hybrid",
                        name: "location",
                        hintText: "Mumbai",
                      ),
                      CustomPopUpForLocation(
                        onSelectionComplete: (selectedItems) {},
                        isWorkspace: true,
                        initiallySelectedItems: provider.remoteLocation != null
                            ? [provider.remoteLocation!]
                            : [],
                        onSubmit: (selectedItems) {
                          provider.setWorkType(3, selectedItems);
                        },
                        isSelect: provider.remote,
                        title: "Remote",
                        name: "city",
                        hintText: "Mumbai",
                      ),
                      /*  CustomToggleButton(
                          isSelect: provider.remote,
                          title: "Remote",
                          onTap: () {
                            provider.setWorktype(3, null);
                          },
                        ), */
                    ],
                  ),
                  if ((provider.onSiteLocation != null ||
                      provider.hybridLocation != null ||
                      provider.remoteLocation != null))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const customText(title: "Selected Job Location"),
                        CustomToggleButton(
                          isSelect: true,
                          title: provider.onSiteLocation != null
                              ? provider.onSiteLocation!.formateData.toString()
                              : provider.hybridLocation != null
                              ? provider.hybridLocation!.formateData.toString()
                              : provider.remoteLocation != null
                              ? provider.remoteLocation!.formateData.toString()
                              : "",
                          onTap: () {},
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  const customText(
                    title: "Employment Type*",
                    fontStyle: FontStyle.italic,
                  ),
                  Wrap(
                    children: [
                      CustomToggleButton(
                        isSelect: provider.fullTime,
                        title: "Full Time",
                        onTap: () {
                          provider.setEmpType("Full Time");
                        },
                      ),
                      CustomToggleButton(
                        isSelect: provider.partTime,
                        title: "Part Time",
                        onTap: () {
                          provider.setEmpType("Part Time");
                        },
                      ),
                      CustomToggleButton(
                        isSelect: provider.contractual,
                        title: "Contractual",
                        onTap: () {
                          provider.setEmpType("Contractual");
                        },
                      ),
                      CustomToggleButton(
                        isSelect: provider.freelancer,
                        title: "Freelancer",
                        onTap: () {
                          provider.setEmpType("Freelancer");
                        },
                      ),
                      CustomToggleButton(
                        isSelect: provider.internship,
                        title: "Internship",
                        onTap: () {
                          provider.setEmpType("Internship");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  const customText(title: "Profile Headline"),
                  CustomAutoSizeTextField(
                    maxLength: 120,
                    controller: provider.profileHeadline,
                    hintText: "Enter your profile headline",
                    maxline: 3,
                  ),
                  const SizedBox(height: 10),
                  //
                  //
                  //
                  const customText(
                    title: "Career Assets",
                    fontStyle: FontStyle.italic,
                  ),
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  provider.offerLetter != null
                      ? CustomContainerSelectToViewDoc(
                          heading: "",
                          candidateName: "Offer Letter",
                          isDocx:
                              provider.offerLetter!.contains('doocx') ||
                                  provider.offerLetter!.contains('doc')
                              ? true
                              : false,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPDFViewerDialog(
                                  isFromAts: true,
                                  pdfUrl:
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${provider.offerLetter}",
                                  onDelete: () async {
                                    await FileUploadService().deleteSingleFile(
                                      provider.offerLetter!,
                                    );
                                    provider.setOfferLetter("");
                                    // Add your logic for removing here
                                  },
                                );
                              },
                            );
                          },
                          title: "Offer Letter",
                        )
                      : const SizedBox(),

                  provider.appointmentLetter != null
                      ? CustomContainerSelectToViewDoc(
                          heading: "Appointnent Letter ",
                          candidateName: "Appointment Letter",
                          isDocx:
                              provider.appointmentLetter!.contains('doocx') ||
                                  provider.appointmentLetter!.contains('doc')
                              ? true
                              : false,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPDFViewerDialog(
                                  isFromAts: true,
                                  pdfUrl:
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${provider.appointmentLetter}",
                                  onDelete: () async {
                                    await FileUploadService().deleteSingleFile(
                                      provider.appointmentLetter!,
                                    );
                                    provider.setAppointmentLetter("");
                                    // Add your logic for removing here
                                  },
                                );
                              },
                            );
                          },
                          title: "Offer Letter",
                        )
                      : const SizedBox(),
                  provider.salarySlip != null
                      ? CustomContainerSelectToViewDoc(
                          heading: "Salary Slip",
                          candidateName: "Salary Slip",
                          isDocx:
                              provider.salarySlip!.contains('doocx') ||
                                  provider.salarySlip!.contains('doc')
                              ? true
                              : false,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPDFViewerDialog(
                                  isFromAts: true,
                                  pdfUrl:
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${provider.salarySlip}",
                                  onDelete: () async {
                                    await FileUploadService().deleteSingleFile(
                                      provider.salarySlip!,
                                    );
                                    provider.setSalarySlip("");
                                    // Add your logic for removing here
                                  },
                                );
                              },
                            );
                          },
                          title: "Offer Letter",
                        )
                      : const SizedBox(),
                  provider.incrementLetter != null
                      ? CustomContainerSelectToViewDoc(
                          heading: "Increment Letter",
                          candidateName: "Increament Letter",
                          isDocx:
                              provider.incrementLetter!.contains('doocx') ||
                                  provider.incrementLetter!.contains('doc')
                              ? true
                              : false,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPDFViewerDialog(
                                  isFromAts: true,
                                  pdfUrl:
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${provider.incrementLetter}",
                                  onDelete: () async {
                                    await FileUploadService().deleteSingleFile(
                                      provider.incrementLetter!,
                                    );
                                    provider.setIncrementLetter("");
                                    // Add your logic for removing here
                                  },
                                );
                              },
                            );
                          },
                          title: "Offer Letter",
                        )
                      : const SizedBox(),
                  provider.experienceLetter != null
                      ? CustomContainerSelectToViewDoc(
                          heading: "Experience Letter ",
                          candidateName: "Experience Letter",
                          isDocx:
                              provider.experienceLetter!.contains('doocx') ||
                                  provider.experienceLetter!.contains('doc')
                              ? true
                              : false,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPDFViewerDialog(
                                  isFromAts: true,
                                  pdfUrl:
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${provider.experienceLetter}",
                                  onDelete: () async {
                                    await FileUploadService().deleteSingleFile(
                                      provider.experienceLetter!,
                                    );
                                    provider.setExperienceLetter("");
                                    // Add your logic for removing here
                                  },
                                );
                              },
                            );
                          },
                          title: "Offer Letter",
                        )
                      : !provider.currentlyWorking
                      ? const SizedBox()
                      : const SizedBox(),
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  if (provider.offerLetter == null ||
                      provider.appointmentLetter == null ||
                      provider.salarySlip == null ||
                      provider.incrementLetter == null ||
                      (provider.lastWorkingDate.text.isNotEmpty &&
                          provider.experienceLetter == null))
                    CustomDocumentUploadButton(
                      onTab: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return _buildBottomSheetContent(context, provider);
                          },
                        );
                      },
                      title: "Add Document",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO::: Custom bottomsheet for document upload...
  //
  //
  //
  //

  Widget _buildBottomSheetContent(
    BuildContext context,
    SignupCreateUserProvider provider,
  ) {
    final List<String> options = [
      "Offer Letter",
      "Appointment Letter",
      "Salary Slip",
      "Increment Letter",
      "Experience / Relieving Letter",
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Career Assets",
            style: GoogleFonts.varela(
              color: Constants.themeBgColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return GestureDetector(
                onTap: () async {
                  FileUploader fileUploader = FileUploader();
                  if (option == "Offer Letter") {
                    final offer = await fileUploader.uploadFile(context, [
                      'pdf',
                    ], "offerLetter");
                    provider.setOfferLetter(offer!);
                    Navigator.pop(context);
                  } else if (option == "Appointment Letter") {
                    final app = await fileUploader.uploadFile(context, [
                      'pdf',
                    ], "appointmentLetter");
                    provider.setAppointmentLetter(app!);
                    Navigator.pop(context);
                  } else if (option == "Salary Slip") {
                    final sal = await fileUploader.uploadFile(context, [
                      'pdf',
                    ], "alarySlip");
                    provider.setSalarySlip(sal!);
                    Navigator.pop(context);
                  } else if (option == "Increment Letter") {
                    final incrementLetter = await fileUploader.uploadFile(
                      context,
                      ['pdf'],
                      "incrementLetter",
                    );
                    provider.setIncrementLetter(incrementLetter!);
                    Navigator.pop(context);
                  } else if (option == "Experience / Relieving Letter") {
                    final experienceLetter = await fileUploader.uploadFile(
                      context,
                      ['pdf'],
                      "experienceLetter",
                    );
                    provider.setExperienceLetter(experienceLetter!);
                    Navigator.pop(context);
                    /*  experienceLetter = await uploadFile(
                          allowExt: ['pdf'], isexperience: true); */
                  }
                },
                child: provider.offerLetter != null && option == "Offer Letter"
                    ? const SizedBox()
                    : provider.appointmentLetter != null &&
                          option == "Appointment Letter"
                    ? const SizedBox()
                    : provider.salarySlip != null && option == "Salary Slip"
                    ? const SizedBox()
                    : provider.incrementLetter != null &&
                          option == "Increment Letter"
                    ? const SizedBox()
                    : provider.experienceLetter != null &&
                          option == "Experience / Relieving Letter" &&
                          provider.lastWorkingDate.text.isEmpty
                    ? const SizedBox()
                    : option == "Experience / Relieving Letter" &&
                          provider.lastWorkingDate.text.isEmpty
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Constants.subtitleclr,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                          color: Constants.lightdull,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          trailing: const Icon(Icons.add),
                          title: customText(fontSize: 12, title: option),
                        ),
                      ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String calculateDuration(DateTime startDate, [DateTime? endDate]) {
    endDate ??= DateTime.now();

    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;
    int days = endDate.day - startDate.day;

    // Adjust if day is negative (e.g., 5 July - 25 June)
    if (days < 0) {
      months -= 1;
      final previousMonth = DateTime(
        endDate.year,
        endDate.month,
        0,
      ); // last day of previous month
      days += previousMonth.day;
    }

    // Adjust if month is negative (e.g., April - December of last year)
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    if (years == 0 && months == 0) {
      return "$days days";
    } else if (years == 0) {
      return "$months m";
    } else if (months == 0) {
      return "$years y";
    } else {
      return "$years y, $months m";
    }
  }
}
 */