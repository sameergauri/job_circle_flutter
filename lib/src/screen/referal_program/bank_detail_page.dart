// screens/Banking/ui/banking_details.dart
// ignore_for_file: avoid_print, camel_case_types, use_super_parameters
import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/bank/fetch_bank_detail_model.dart';
import 'package:job_circle/src/provider/referal_program/bank_detail_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/container/custom_remark_coontainer.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_bank.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_bank_detail_page.dart';
import 'package:provider/provider.dart';

class BankingDetails extends StatefulWidget {
  final String name;
  final String profilePic;
  final String gender;
  final bool? fromInvoice;

  const BankingDetails({
    super.key,
    this.fromInvoice,
    required this.name,
    required this.profilePic,
    required this.gender,
  });

  @override
  State<BankingDetails> createState() => _BankingDetailsState();
}

class _BankingDetailsState extends State<BankingDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BankingProvider>(context, listen: false);
      provider.fetchBankingData();
      provider.setAccountHolderName(widget.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Constants.darkBlue,
                strokeWidth: 1,
              ),
            ),
          );
        }
        return provider.fetchBankDetail != null &&
                provider.fetchBankDetail!.isNotEmpty
            ? _buildBankingListView(provider.fetchBankDetail!)
            : _buildBankingForm(context, provider);
      },
    );
  }

  Widget _buildBankingListView(List<FetchBankDetailModel> bankingData) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Constants.borderColor,
        elevation: 0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const OnboardingTitle(title: "Banking Detail", fontSize: 16),
      ),
      body: ListView.builder(
        itemCount: bankingData.length,
        itemBuilder: (context, index) {
          final bankData = bankingData[index];
          return Column(
            children: [
              _buildBankingCard(bankData),
              if (index != bankingData.length - 1)
                const Divider(thickness: 1.0),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBankingForm(BuildContext context, BankingProvider provider) {
    return GestureDetector(
      onTap: provider.hideAccountNumber,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Constants.borderColor,
              elevation: 0,
              titleSpacing: 0.0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const OnboardingTitle(
                title: "Banking Detail",
                fontSize: 16,
              ),
            ),
            bottomNavigationBar: CustomButtonForSave(
              onTap: () {
                RegExp regex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                if (provider.acNoController.text.isEmpty) {
                  CustomSnackbar.show("Specify Account Number", true);
                } else if (provider.acNoController.text !=
                    provider.acNoVerifyController.text) {
                  CustomSnackbar.show("Account Number mismatch", true);
                } else if (provider.bankNameController.text.isEmpty) {
                  CustomSnackbar.show("Specify Bank Name.", true);
                } else if (provider.selectedBankName.isEmpty) {
                  CustomSnackbar.show(
                    "Select Bank Name from given list.",
                    true,
                  );
                } else if (provider.ifscCodeController.text.isEmpty) {
                  CustomSnackbar.show("Specify IFSC Code", true);
                } else if (!regex.hasMatch(provider.ifscCodeController.text)) {
                  CustomSnackbar.show("Specify proper IFSC", true);
                } else if (provider.cancelChequePath.isEmpty) {
                  CustomSnackbar.show("Add Cancel Cheque", true);
                } else if (!provider.isSavingAccount &&
                    !provider.isCurrentAccount) {
                  CustomSnackbar.show("Select Bank Account Type", true);
                } else {
                  provider.submitBankingDetails();
                  /*  if (widget.fromInvoice == null ||
                      widget.fromInvoice == false) {
                   NavigationService.pop();
                  } */
                }
              },
              title: "Submit",
            ),
            body: _buildBankingFormContent(context, provider),
          ),
          if (provider.isLoading) CustomLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildBankingFormContent(
    BuildContext context,
    BankingProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const customText(
              title: "Name as per Bank Record*",
              fontStyle: FontStyle.italic,
            ),
            CustomBankTextField(
              controller: provider.accountHolderNameController,
              hint: widget.name,
              textfieldNo: 3,
              enabled: false,
              obscureText: false,
              maxLength: 30,
            ),
            const SizedBox(height: 15),
            const customText(title: "Bank Name*", fontStyle: FontStyle.italic),
            CustomTextFieldForBank(
              controller: provider.bankNameController,
              hintText: "Type to search",
              title: "Bank Name",
              onIdSelected: provider.setSelectedBankId,
              onChanged: (p0) {},
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Bank Account Number*",
              fontStyle: FontStyle.italic,
            ),
            CustomBankTextField(
              controller: provider.acNoController,
              hint: "021215******",
              textfieldNo: 1,
              enabled: true,
              obscureText: provider.obscureAccountNumber,
              maxLength: 16,
              onTap: provider.showAccountNumber,
              onSubmitted: (_) => provider.hideAccountNumber(),
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Re confirm your Bank Account Number*",
              fontStyle: FontStyle.italic,
            ),
            CustomBankTextField(
              controller: provider.acNoVerifyController,
              hint: "021215******",
              textfieldNo: 2,
              enabled: true,
              obscureText: false,
              maxLength: 16,
            ),
            const SizedBox(height: 15),
            const customText(title: "IFSC Code*", fontStyle: FontStyle.italic),
            CustomBankTextField(
              controller: provider.ifscCodeController,
              hint: "BK***15D",
              textfieldNo: 4,
              enabled: true,
              obscureText: false,
              maxLength: 11,
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Bank Account Type*",
              fontStyle: FontStyle.italic,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomGenderButton(
                  width: MediaQuery.of(context).size.width / 2.33,
                  height: 40,
                  onTap: provider.selectSavingAccount,
                  isSelect: provider.isSavingAccount,
                  title: "Saving",
                ),
                CustomGenderButton(
                  width: MediaQuery.of(context).size.width / 2.33,
                  height: 40,
                  onTap: provider.selectCurrentAccount,
                  isSelect: provider.isCurrentAccount,
                  title: "Current",
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildCancelChequeUpload(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelChequeUpload(
    BuildContext context,
    BankingProvider provider,
  ) {
    if (provider.cancelChequePath.isEmpty) {
      return CustomDocumentUploadButton(
        subTitle: "Supported format : PDF",
        onTab: () async {
          FileUploader fileUploader = FileUploader();
          final path = await fileUploader.uploadFile(context, [
            'pdf',
          ], "cancelcheque");
          if (path != null) {
            provider.setCancelChequePath(path);
          }
        },
        title: "Upload Cancel Cheque",
      );
    } else {
      return CustomContainerSelectToViewDoc(
        isDocx: false,
        title: "Cancel Cheque",
        heading: "Cancel Cheque",
        candidateName: "",
        onPressed: () {
          NavigationService.push(
            CustomPDFViewerDialog(
              isFromAts: true,
              pdfUrl:
                  "${GlobalConstants.Image_url}${provider.cancelChequePath}",
              onDelete: () async {
                await FileUploadService().deleteSingleFile(
                  provider.cancelChequePath,
                );
                provider.setCancelChequePath("");
              },
            ),
          );
        },
      );
    }
  }

  Widget _buildBankingCard(FetchBankDetailModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNewListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            trailing: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  NavigationService.push(
                    CustomPDFViewerDialog(
                      pdfUrl:
                          '${GlobalConstants.Image_url}${data.cancleCheque}',
                      isFromAts: false,
                    ),
                  );
                },
                child: Image.network(CustomIconUrl.documenticon, height: 30),
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Constants.lightdull),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomNetworkImage(
                imageUrl: "${GlobalConstants.Image_url}${data.icon}",
                defaultIcon: Icons.balance,
              ),
            ),
            title: customText(
              title: widget.name.toString(),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            subtitle: customText(
              title: "${data.accountNumber} || ${data.ifscCode}",
              fontSize: 12,
            ),
          ),
          if (data.isVerify != 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Constants.borderColor),
                    borderRadius: BorderRadius.circular(8),
                    color: Constants.borderColor,
                  ),
                  child: customText(
                    title: data.isVerify == null
                        ? "Under Review"
                        : data.isVerify == 0
                        ? "InActive"
                        : "Active",
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: data.isVerify == null
                        ? Constants.yellow
                        : data.isVerify == 0
                        ? Constants.red
                        : Constants.darkBlue,
                  ),
                ),
              ],
            ),
          if (data.isVerify == 0)
            CustomRemarkConatiner(
              subtitle: data.remark!,
              valueColor: Constants.subtitleclr,
              title: "Rejected",
            ),
        ],
      ),
    );
  }
}
