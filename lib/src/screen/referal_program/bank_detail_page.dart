// screens/Banking/ui/banking_details.dart
// ignore_for_file: unnecessary_null_comparison, must_be_immutable, unused_field, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, camel_case_types, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/referal_program/banking_model.dart';
import 'package:job_circle/src/provider/referal_program/bank_detail_provider.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/button/custom_document_upload_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:provider/provider.dart';

class BankingDetails extends StatefulWidget {
  final String name;
  final String profilePic;
  final String gender;
  bool? fromInvoice;

  BankingDetails({
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
  TextEditingController _bank_name = TextEditingController();
  TextEditingController _ac_type = TextEditingController();
  TextEditingController _ac_no = TextEditingController();
  TextEditingController _ifsc_code = TextEditingController();
  TextEditingController _ac_no_verify = TextEditingController();

  FocusNode _pan_focus_node = FocusNode();
  FocusNode _bank_focus_node = FocusNode();
  FocusNode _ac_focus_node = FocusNode();
  FocusNode _ifsc_focus_node = FocusNode();
  FocusNode _ac_verify_focus_node = FocusNode();

  bool saving = false, current = false;
  String cancelCheckCopy = "";
  String checkBankName = "";
  String bankid = "";
  bool hideText = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BankingProvider>(context, listen: false);
      provider.fetchBankingData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankingProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        if (state.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Constants.darkBlue,
                strokeWidth: 1,
              ),
            ),
          );
        }

        if (state.error != null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Oops! Something went wrong on our end. Our team is working to fix the issue. Please be patient and bear with us as we resolve this. Thank you for your understanding.",
              ),
            ),
          );
        }

        return state.bankingData.isNotEmpty
            ? _buildBankingListView(state.bankingData)
            : _buildBankingForm(context, provider);
      },
    );
  }

  Widget _buildBankingListView(List<GetBankingModel> bankingData) {
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
      onTap: () {
        setState(() {
          hideText = true;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Constants.borderColor,
          elevation: 0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const OnboardingTitle(title: "Banking Detail", fontSize: 16),
        ),
        bottomNavigationBar: CustomButtonForSave(
          onTap: () async {
            await _submitBankingDetails(provider);
          },
          title: "Submit",
        ),
        body: _buildBankingFormContent(context),
      ),
    );
  }

  Widget _buildBankingFormContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const customText(
              title: "Name as per Bank Record*",
              fontStyle: FontStyle.italic,
            ),
            _buildTextField(
              context: context,
              controller: _ac_type,
              label: widget.name,
              hint: widget.name,
              focusNode: _ac_focus_node,
              textfieldNo: 1,
              lock: false,
              obsecText: false,
              limit: 30,
              icon: const Icon(Icons.person_2_outlined),
            ),
            SizedBox(height: 15),
            const customText(title: "Bank Name*", fontStyle: FontStyle.italic),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: _bank_name,
              hintText: "Type to search",
              name: "bank",
              title: "Bank Name",
            ),
            /*   customTextFieldForBank(
              contextIn: context,
              controller: _bank_name,
              getvalue: (value) {
                setState(() {
                  _bank_name.text = value;
                  checkBankName = value;
                });
              },
              getid: (id) {
                setState(() {
                  bankid = id;
                });
              },
            ), */
            const SizedBox(height: 15),
            const customText(
              title: "Bank Account Number*",
              fontStyle: FontStyle.italic,
            ),
            _buildTextField(
              context: context,
              controller: _ac_no,
              label: "A/C Number",
              hint: "021215******",
              focusNode: _ac_focus_node,
              textfieldNo: 1,
              lock: true,
              obsecText: true,
              limit: 16,
              icon: const Icon(Icons.account_balance_wallet_outlined),
              onTap: () {
                setState(() {
                  hideText = false;
                });
              },
            ),
            const SizedBox(height: 15),
            const customText(
              title: "Re confirm your Bank Account Number*",
              fontStyle: FontStyle.italic,
            ),
            _buildTextField(
              context: context,
              controller: _ac_no_verify,
              label: "Verify A/C Number",
              hint: "021215******",
              focusNode: _ac_verify_focus_node,
              textfieldNo: 2,
              lock: true,
              obsecText: false,
              limit: 16,
              icon: const Icon(Icons.account_balance_wallet_outlined),
              onTap: () {
                setState(() {
                  hideText = true;
                });
              },
            ),
            const SizedBox(height: 15),
            const customText(title: "IFSC Code*", fontStyle: FontStyle.italic),
            _buildTextField(
              context: context,
              controller: _ifsc_code,
              label: "IFCS code",
              hint: "BK***15D",
              focusNode: _ifsc_focus_node,
              textfieldNo: 4,
              lock: true,
              obsecText: false,
              limit: 11,
              icon: const Icon(Icons.adjust_sharp),
              onTap: () {
                setState(() {
                  hideText = true;
                });
              },
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
                  onTap: () {
                    setState(() {
                      saving = true;
                      current = false;
                      hideText = true;
                    });
                  },
                  isSelect: saving,
                  title: "Saving",
                ),
                CustomGenderButton(
                  width: MediaQuery.of(context).size.width / 2.33,
                  height: 40,
                  onTap: () {
                    setState(() {
                      saving = false;
                      current = true;
                      hideText = true;
                    });
                  },
                  isSelect: current,
                  title: "Current",
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildCancelChequeUpload(),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelChequeUpload() {
    if (cancelCheckCopy.isEmpty) {
      return CustomDocumentUploadButton(
        subTitle: "Supported format : PDF",
        onTab: () async {
          FileUploader fileUploader = FileUploader();
          cancelCheckCopy = (await fileUploader.uploadFile(context, [
            'pdf',
          ], "cancelcheque"))!;
          setState(() {});
        },
        title: "Upload Cancel Cheque",
      );
    } else {
      return CustomContainerSelectToViewDoc(
        isDocx:
            cancelCheckCopy.contains('docx') || cancelCheckCopy.contains('doc')
            ? true
            : false,
        title: "Cancel Cheque",
        heading: "",
        candidateName: "",
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return CustomPDFViewerDialog(
                isFromAts: true,
                pdfUrl:
                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$cancelCheckCopy",
                onDelete: () async {
                  await FileUploadService().deleteSingleFile(cancelCheckCopy);
                  setState(() {
                    cancelCheckCopy = "";
                  });
                },
              );
            },
          );
        },
      );
    }
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required FocusNode focusNode,
    required int textfieldNo,
    required bool lock,
    required bool obsecText,
    required int limit,
    required Icon icon,
    Function()? onTap,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 24,
      child: TextField(
        onTap: onTap,
        maxLength: limit,
        enableInteractiveSelection: !obsecText,
        obscureText: obsecText ? hideText : obsecText,
        enabled: lock,
        keyboardType: textfieldNo == 1 || textfieldNo == 2
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: [
          if (textfieldNo == 1 || textfieldNo == 2)
            FilteringTextInputFormatter.digitsOnly
          else if (textfieldNo == 3)
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          else
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
        ],
        onSubmitted: (value) {
          setState(() {
            hideText = true;
          });
        },
        textCapitalization: textfieldNo == 4 || textfieldNo == 5
            ? TextCapitalization.characters
            : TextCapitalization.sentences,
        controller: controller,
        style: GoogleFonts.montserrat(
          color: Constants.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 10,
            right: 10,
          ),
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Constants.subtitleclr),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Constants.black),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(
            color: Constants.subtitleclr,
            fontSize: 14,
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildBankingCard(GetBankingModel data) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
            trailing: Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  _showUploadedDocument(context, data.cancelCheque.toString());
                },
                child: Image.network(CustomIconUrl.documenticon, height: 30),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 40,
              width: 50,
              child: CustomNetworkImage(
                imageUrl: "${GlobalConstants.Image_url}${data.icon}",
                defaultIcon: Icons.balance,
              ),
            ),
            title: customTextForWeather(
              title: widget.name.toString(),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            subtitle: customTextForMonst(
              title: "${data.accountNumber} || ${data.ifscCode}",
              fontSize: 12,
            ),
          ),
        ),
        if (data.isVerify == 0)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: customTextForRoboto(
              title: "Reason : ${data.remark}",
              fontSize: 12,
            ),
          ),
        Positioned(
          right: 15,
          top: 10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.borderColor),
              borderRadius: BorderRadius.circular(8),
              color: Constants.white,
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
        ),
      ],
    );
  }

  Future<void> _submitBankingDetails(BankingProvider provider) async {
    RegExp regex = RegExp(r'^[A-Za-z]{4}0.*$');

    if (_ac_no.text.isEmpty) {
      CustomSnackbar.show("Specify Account Number", true);
    } else if (_ac_no.text != _ac_no_verify.text) {
      CustomSnackbar.show("Account Number mismatch", true);
    } else if (_bank_name.text.isEmpty) {
      CustomSnackbar.show("Specify Bank Name.", true);
    } else if (checkBankName.isEmpty) {
      CustomSnackbar.show("Select Bank Name from given list.", true);
    } else if (_ifsc_code.text.isEmpty) {
      CustomSnackbar.show("Specify IFSC Code", true);
    } else if (!regex.hasMatch(_ifsc_code.text)) {
      CustomSnackbar.show("Specify proper IFSC", true);
    } else if (cancelCheckCopy.isEmpty) {
      CustomSnackbar.show("Add Cancel Cheque", true);
    } else {
      try {
        final id = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
        int? userid = id;

        Map<String, dynamic> jsonData = {
          "accountNumber": int.tryParse(_ac_no.text),
          "uid": userid,
          "accountType": saving
              ? "Saving"
              : current
              ? "Current"
              : "",
          "bankName": _bank_name.text,
          "ifscCode": _ifsc_code.text,
          "bankId": int.tryParse(bankid),
          "cancleCheque": cancelCheckCopy,
        };

        await provider.addBankingDetails(jsonData);

        if (widget.fromInvoice == null || widget.fromInvoice == false) {
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error: $e');
        CustomSnackbar.show("Failed to add banking details", true);
      }
    }
  }

  Future<void> _showUploadedDocument(BuildContext context, String data) async {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Document Viewer"),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: Container(
            child: const Center(
              child: Text("PDF Viewer would be implemented here"),
            ),
          ),
        );
      },
    );
  }
}

// Helper widget for text with weather style
class customTextForWeather extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;

  const customTextForWeather({
    Key? key,
    required this.title,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

// Helper widget for Montserrat text
class customTextForMonst extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const customTextForMonst({
    Key? key,
    required this.title,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

// Helper widget for Roboto text
class customTextForRoboto extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const customTextForRoboto({
    Key? key,
    required this.title,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
