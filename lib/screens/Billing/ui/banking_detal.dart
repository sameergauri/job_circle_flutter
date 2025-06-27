// ignore_for_file: unnecessary_null_comparison, unused_result, use_full_hex_values_for_flutter_colors, duplicate_ignore
// ignore_for_file: override_on_non_overriding_member, unused_field, unused_local_variable, unused_result, file_names, avoid_print, unused_element, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_null_comparison
// ignore_for_file: todo
import 'dart:convert';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/constants/custom_textfield_for_profile.dart';
import 'package:job_circle/constants/customwidget_upload_file.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/get_banking_detail_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_container_for_gender.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

final fetchBankingDetails = FutureProvider<List<GetBankingModel>>((ref) {
  Future.delayed(const Duration(milliseconds: 10));
  return _BankingDetalsState.fetchBankingData();
});

class BankingDetals extends ConsumerStatefulWidget {
  final String name;
  final String profilePic;
  final String gender;
  bool? fromInvoice;
  BankingDetals(
      {super.key,
      this.fromInvoice,
      required this.name,
      required this.profilePic,
      required this.gender});

  @override
  ConsumerState<BankingDetals> createState() => _BankingDetalsState();
}

class _BankingDetalsState extends ConsumerState<BankingDetals> {
  static Future<List<GetBankingModel>> fetchBankingData() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/bankDetails/v1/getBankingDetailsOfUserByUserId?uid=$userid&pageNumber=1&pageSize=10');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        List<GetBankingModel> applicants =
            contentList.map((json) => GetBankingModel.fromJson(json)).toList();
        return applicants;
      } else {
        print(
            'Failed to fetch banking data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

  //TODO:: variable Decl..

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
  //TODO:: variable Decl End....

  //TODO:: isVerify == null :: In Process
  //TODO:: isVerify == 0 :: InActive
  //TODO:: isVerify == 1 :: Active

  @override
  Widget build(BuildContext context) {
    var fetchBankingData = ref.watch(fetchBankingDetails);
    return fetchBankingData != null
        ? fetchBankingData.when(
            data: (data) {
              final allItemsAreNull = data.every(
                // ignore: unrelated_type_equality_checks
                (content) => content.isVerify == 0,
              );
              return !allItemsAreNull
                  ? Scaffold(
                      //TODO:: ui to view banking details...
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        iconTheme: const IconThemeData(color: Constants.black),
                        centerTitle: false,
                        automaticallyImplyLeading: true,
                        title: const customTextForWeather(
                            title: "Banking Detail",
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        elevation: 0,
                        backgroundColor: Constants.borderColor,
                      ),
                      body: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final bankData = data[index];
                          return Column(
                            children: [
                              customCardToViewBank(bankData),
                              if (index != data.length - 1)
                                const Divider(
                                  thickness: 1.0,
                                )
                            ],
                          );
                        },
                      ))
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          hideText = true;
                        });
                      },
                      child: Scaffold(
                          backgroundColor: Colors.white,
                          appBar: AppBar(
                            automaticallyImplyLeading: true,
                            iconTheme:
                                const IconThemeData(color: Constants.black),
                            title: const customTextForWeather(
                                title: "Banking Details",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            elevation: 0,
                            backgroundColor: Constants.borderColor,
                          ),
                          bottomNavigationBar: CustomButtonForSave(
                            onTap: () async {
                              RegExp regex = RegExp(r'^[A-Za-z]{4}0.*$');
                              if (_ac_no.text == null || _ac_no.text == "") {
                                CustomSnackbar.show(
                                    "Specify Account Number", true);
                              } else if (_ac_no.text != _ac_no_verify.text) {
                                CustomSnackbar.show(
                                    "Account Number mismatch", true);
                              } else if (_bank_name.text.isEmpty ||
                                  _bank_name.text == "") {
                                CustomSnackbar.show("Specify Bank Name.", true);
                              } else if (checkBankName == null ||
                                  checkBankName == "") {
                                CustomSnackbar.show(
                                    "Select Bank Name from given list.", true);
                              } else if (_ifsc_code == null ||
                                  _ifsc_code.text == "") {
                                CustomSnackbar.show("Specify IFSC Code", true);
                              } else if (_ifsc_code != null &&
                                  _ifsc_code.text != "" &&
                                  (!regex.hasMatch(_ifsc_code.text))) {
                                CustomSnackbar.show(
                                    "Specify proper IFSC", true);
                              } else if (cancelCheckCopy == null ||
                                  cancelCheckCopy == "") {
                                CustomSnackbar.show("Add Cancel Cheque", true);
                              } else {
                                await addBankingDetails();
                                ref.refresh(fetchBankingDetails);
                              }

                              //
                            },
                            title: "Submit",
                          ),
                          //TODO:: Ui to send banking detail.......
                          body: customCard(context)),
                    );
            },
            error: (error, stackTrace) {
              return const Scaffold(
                body: Center(
                  child: Text(
                      "Oops! Something went wrong on our end. Our team is working to fix the issue. Please be patient and bear with us as we resolve this. Thank you for your understanding."),
                ),
              );
            },
            loading: () {
              return const Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                  color: Constants.darkBlue,
                  strokeWidth: 1,
                )),
              );
            },
          )
        : const SizedBox(
            child: Text("No Data to display."),
          );
  }

  //
  //
  //
  //
  //
  //

  //TODO : custom function......
  //
  //
  //
  //
  //
  //
  //

  Stack customCardToViewBank(GetBankingModel data) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
            trailing: Container(
              margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
              child: GestureDetector(
                onTap: () {
                  showUploadedDocument(context, data.cancelCheque.toString());
                },
                child: Image.asset(
                  "assets/images/cancel_check.png",
                  height: 30,
                ),
              ),
            ),
            leading: data.icon != null
                ? Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 40.h,
                    width: 50.w,
                    child: CustomImage(
                      imageUrl:
                          "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.icon}",
                      defaultImageUrl: "assets/images/bank.png",
                    ))
                : Image.asset(
                    "assets/images/bank.png",
                    height: 30.h,
                    fit: BoxFit.fill,
                  ),
            title: customTextForWeather(
                title: widget.name.toString(),
                fontSize: 14,
                fontWeight: FontWeight.bold),
            subtitle: customTextForMonst(
              title: "${data.accountNumber} || ${data.ifscCode}",
              fontSize: 12,
            ),
          ),
        ),
        if (data.isVerify == 0)
          Padding(
            padding: EdgeInsets.only(top: 4.sp),
            child: customTextForRoboto(
                title: "Reason : ${data.remark}", fontSize: 12),
          ),
        Positioned(
          right: 15.w,
          top: 10,
          child: Text(
            data.isVerify == null
                ? "Under Review"
                : data.isVerify == 0
                    ? "InActive"
                    : "Active",
            style: GoogleFonts.roboto(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: data.isVerify == null
                    ? Constants.yellow
                    : data.isVerify == 0
                        ? Constants.red
                        : Constants.darkBlue),
          ),
        ),
      ],
    );
  }

  Future<void> addBankingDetails() async {
    var id =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    int? userid = int.tryParse(id);
    try {
      if (_ac_no.text == null || _ac_no.text == "") {
        CustomSnackbar.show("Specify Account Number", true);
      } else if (_ac_no.text != _ac_no_verify.text) {
        CustomSnackbar.show("Account Number mismatch", true);
      } else if (_bank_name == null || _bank_name.text == "") {
        CustomSnackbar.show("Specify Bank Name", true);
      } else if (_ifsc_code == null || _ifsc_code.text == "") {
        CustomSnackbar.show("Specify IFSC Code", true);
      } else if (cancelCheckCopy == null || cancelCheckCopy == "") {
        CustomSnackbar.show("Specify The copy of Cancel Check", true);
      } else {
        if (widget.fromInvoice == null || widget.fromInvoice == false) {
          Navigator.pop(context);
        }
        PostBankingModel postBankingModel = PostBankingModel(
            accountNumber: int.tryParse(_ac_no.text),
            uid: userid,
            accountType: saving
                ? "Saving"
                : current
                    ? "Current"
                    : "",
            bankName: _bank_name.text,
            ifscCode: _ifsc_code.text,
            bankId: int.tryParse(bankid), //TODO from all bank dropdown...
            cancleCheque: cancelCheckCopy);
        Map<String, dynamic> jsonData = postBankingModel.toJson();

        await JobPostApiService.AddBankingDetails(jsonData, context);

        // Assuming you have access to the ref and fetchBankingDetails in your widget tree
        ref.refresh(fetchBankingDetails);

        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
      // Handle error...
    }
  }

  Widget customCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          hideText = true;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const customTextForWeather(
                title: "Name as per Bank Record*",
              ),
              customTextfield(
                  primaryfield: true,
                  onTab: () {},
                  context: context,
                  controller: _ac_type,
                  label: widget.name,
                  hint: widget.name,
                  focusNode: _ac_focus_node,
                  textfield_no: 1,
                  lock: false,
                  obsecText: false,
                  limit: 30,
                  icon: const Icon(Icons.person_2_outlined)),
              SizedBox(
                height: 10.h,
              ),
              const customTextForWeather(
                title: "Bank Name*",
              ),
              customTextFieldForBank(
                contextIn: context,
                controller: _bank_name,
                getvalue: (p0) {
                  setState(() {
                    _bank_name.text = p0;
                    checkBankName = p0;
                  });
                },
                getid: (p0) {
                  setState(() {
                    bankid = p0;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const customTextForWeather(
                title: "Bank Account Number*",
              ),
              customTextfield(
                  primaryfield: false,
                  onTab: () {
                    setState(() {
                      hideText = false;
                    });
                  },
                  context: context,
                  controller: _ac_no,
                  label: "A/C Number",
                  hint: "021215******",
                  focusNode: _ac_focus_node,
                  textfield_no: 1,
                  lock: true,
                  obsecText: true,
                  limit: 16,
                  icon: const Icon(Icons.account_balance_wallet_outlined)),
              const SizedBox(
                height: 10,
              ),
              const customTextForWeather(
                title: "Re confirm your Bank Account Number*",
              ),
              customTextfield(
                  primaryfield: false,
                  onTab: () {
                    setState(() {
                      hideText = true;
                    });
                  },
                  context: context,
                  controller: _ac_no_verify,
                  label: "Verify A/C Number",
                  hint: "021215******",
                  focusNode: _ac_verify_focus_node,
                  textfield_no: 2,
                  lock: true,
                  obsecText: false,
                  limit: 16,
                  icon: const Icon(Icons.account_balance_wallet_outlined)),
              const SizedBox(
                height: 10,
              ),
              const customTextForWeather(
                title: "IFSC Code*",
              ),
              customTextfield(
                  primaryfield: false,
                  onTab: () {
                    setState(() {
                      hideText = true;
                    });
                  },
                  context: context,
                  controller: _ifsc_code,
                  label: "IFCS code",
                  hint: "BK***15D",
                  focusNode: _ifsc_focus_node,
                  textfield_no: 4,
                  lock: true,
                  obsecText: false,
                  limit: 11,
                  icon: const Icon(Icons.adjust_sharp)),
              const customTextForWeather(
                title: "Bank Account Type*",
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainerForGender(
                      onPressed: () {
                        setState(() {
                          saving = true;
                          current = false;
                          hideText = true;
                        });
                      },
                      isSelect: saving,
                      title: "Saving"),
                  CustomContainerForGender(
                      onPressed: () {
                        setState(() {
                          saving = false;
                          current = true;
                          hideText = true;
                        });
                      },
                      isSelect: current,
                      title: "Current"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (cancelCheckCopy == null || cancelCheckCopy == "")
                CustomDocumentUploadButton(
                  onTab: () async {
                    FileUploader fileUploader = FileUploader();

                    cancelCheckCopy = (await fileUploader.uploadFile(
                        context, ['pdf'], "cancelcheque"))!;
                    setState(() {});
                  },
                  title: "Upload Cancel Cheque",
                ),
              if (cancelCheckCopy != null && cancelCheckCopy != "")
                CustomContainerSelectToViewDoc(
                  title: "Cancel Cheque",
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return CustomPDFViewerDialog(
                          pdfUrl:
                              "https://s3.ap-south-1.amazonaws.com/job-circle-2/$cancelCheckCopy",
                          onRemove: () async {
                            await FileUploadService()
                                .deleteSingleFile(cancelCheckCopy);
                            setState(() {
                              cancelCheckCopy = "";
                            });
                          },
                          onReplace: () {},
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool hideText = false;

  Widget customTextfield(
      {required String hint,
      required String label,
      required BuildContext context,
      required TextEditingController controller,
      required FocusNode focusNode,
      required int textfield_no,
      required bool lock,
      required bool obsecText,
      required int limit,
      required Function onTab,
      required bool primaryfield,
      required Icon icon}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 24,
      child: TextField(
        onTap: () {
          onTab();
        },
        maxLength: limit,
        enableInteractiveSelection: !obsecText,
        obscureText: obsecText ? hideText : obsecText,
        enabled: lock,

        keyboardType: textfield_no == 1
            ? TextInputType.number
            : textfield_no == 2
                ? TextInputType.number
                : textfield_no == 3
                    ? TextInputType.name
                    : TextInputType.name,
        //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
        inputFormatters: [
          textfield_no == 1
              ? FilteringTextInputFormatter.digitsOnly
              : textfield_no == 2
                  ? FilteringTextInputFormatter.digitsOnly
                  : textfield_no == 3
                      ? FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                      : textfield_no == 4 || textfield_no == 5
                          ? FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9]'))
                          : FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]'),
                            ),
        ],
        onSubmitted: (value) {
          setState(() {
            hideText = true;
          });
        },
        textCapitalization: textfield_no == 4 || textfield_no == 5
            ? TextCapitalization.characters
            : TextCapitalization.sentences,
        controller: controller,
        style: GoogleFonts.montserrat(
            color: Constants.black, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            filled: primaryfield,
            fillColor: Constants.lightdull,
            contentPadding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Constants.subtitleclr),
            ),
            focusColor: const Color(0xffff0eceb),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Constants.black,
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(
                color: primaryfield ? Constants.black : Constants.subtitleclr,
                fontWeight: primaryfield ? FontWeight.w500 : FontWeight.normal,
                fontSize: 14)),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Future<void> showUploadedDocument(BuildContext context, String data) async {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          body: Container(
            child: FutureBuilder<PDFDocument>(
              future: PDFDocument.fromURL(
                "https://s3.ap-south-1.amazonaws.com/job-circle-2/$data",
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return PDFViewer(
                      scrollDirection: Axis.vertical,
                      panLimit: 1.1,
                      document: snapshot.data!,
                      zoomSteps: 3,
                      showNavigation: false,
                      showPicker: false,
                    );
                  } else {
                    return const Center(child: Text('Failed to load PDF'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
      },
    );
  }

  //TODO : custom function end...
}
