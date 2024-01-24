// ignore_for_file: unnecessary_null_comparison, unused_result, use_full_hex_values_for_flutter_colors
// ignore_for_file: override_on_non_overriding_member, unused_field, unused_local_variable, unused_result, file_names, avoid_print, unused_element, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_null_comparison
// ignore_for_file: todo
import 'dart:convert';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/get_banking_detail_model.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

final fetchBankingDetails = FutureProvider<GetBankingModel?>((ref) {
  Future.delayed(const Duration(milliseconds: 10));
  return _BankingDetalsState.fetchBillingData();
});

class BankingDetals extends ConsumerStatefulWidget {
  final String name;
  final String profilePic;
  final String gender;
  const BankingDetals(
      {super.key,
      required this.name,
      required this.profilePic,
      required this.gender});

  @override
  ConsumerState<BankingDetals> createState() => _BankingDetalsState();
}

class _BankingDetalsState extends ConsumerState<BankingDetals> {
  static Future<GetBankingModel?> fetchBillingData() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/$userid/getBankDetailsOfUserByUserId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Check if 'resultData' is a Map
        if (jsonData['resultData'] != null &&
            jsonData['resultData'] is Map<String, dynamic>) {
          GetBankingModel applicants = GetBankingModel.fromJson(jsonData);
          return applicants;
        } else {
          print(
              'Invalid data format. Expected "resultData" as a Map in response.');
          return null;
        }
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return null;
    }
  }

  /*  static Future<GetBankingModel?> FetchBillingData() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/$userid/getBankDetailsOfUserByUserId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData'];

        // Convert the list of Map to a list of Applicant objects
        GetBankingModel applicants = GetBankingModel.fromJson(jsonData);
        return applicants;
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return null;
    }
  } */

  //TODO:: variable Decl..

  TextEditingController _pan_no = TextEditingController();
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

  String cancelCheckCopy = "", panCardCopy = "";
  //TODO:: variable Decl End....

  @override
  Widget build(BuildContext context) {
    var fetchBankingData = ref.watch(fetchBankingDetails);
    return fetchBankingData != null
        ? fetchBankingData.when(
            data: (data) {
              return data!.resultData.accountNumber != null
                  ? Scaffold(
                      appBar: AppBar(
                        centerTitle: false,
                        automaticallyImplyLeading: false,
                        title: Text(
                          "Banking Detail",
                          style: GoogleFonts.varela(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.white,
                      ),
                      body: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 16.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0.5, 2),
                                blurRadius: 2,
                                spreadRadius: 2,
                                color: Colors.grey.shade200)
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Text(data.resultData.bankName.toString(),
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0.5, 2),
                                            blurRadius: 2,
                                            spreadRadius: 2,
                                            color: Colors.grey.shade200)
                                      ],
                                    ),
                                    child: Text(
                                        data.resultData.accountType.toString()),
                                  )
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 15.sp,
                                      ),
                                      Text(data.resultData.accountNumber
                                          .toString()),
                                      const Spacer(),
                                      Text(data.resultData.ifscCode.toString()),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.credit_card_outlined,
                                        size: 15.sp,
                                      ),
                                      Text(data.resultData.panCard.toString()),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                  : Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        title: Text(
                          "Banking Details",
                          style: GoogleFonts.varela(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.white,
                      ),
                      bottomNavigationBar: GestureDetector(
                        onTap: () {
                          addBankingDetails();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Constants.themeBgColor),
                          height: 40.sp,
                          width: double.maxFinite,
                          child: Center(
                              child: Text("Review & Submit",
                                  style: GoogleFonts.varela(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      //TODO:: Ui to send banking detail.......
                      body: customCard(context));
            },
            error: (error, stackTrace) {
              return const Center(
                child: Text(
                    "Oops! Something went wrong on our end. Our team is working to fix the issue. Please be patient and bear with us as we resolve this. Thank you for your understanding."),
              );
            },
            loading: () {
              return const Center(
                  child: CircularProgressIndicator(
                color: Constants.themeBgColor,
                strokeWidth: 1,
              ));
            },
          )
        : const SizedBox(
            child: Text("Error"),
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

  Future<void> addBankingDetails() async {
    try {
      if (_ac_no.text == null || _ac_no.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbarfinal(title: "Specify Account Number", error: true));
      } else if (_ac_no.text != _ac_no_verify.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbarfinal(title: "Account Number mismatch", error: true));
      } else if (_bank_name == null || _bank_name.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbarfinal(title: "Specify Bank Name", error: true));
      } else if (_ifsc_code == null || _ifsc_code.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbarfinal(title: "Specify IFSC Code", error: true));
      } else if (_pan_no == null || _pan_no.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbarfinal(title: "Specify Pan Card Number", error: true));
      } else if (panCardCopy == null || panCardCopy == "") {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackbarfinal(
            title: "Specify The copy of Pan Card", error: true));
      } else if (cancelCheckCopy == null || cancelCheckCopy == "") {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackbarfinal(
            title: "Specify The copy of Cancel Check", error: true));
      } else {
        PostBankingModel postBankingModel = PostBankingModel(
            accountNumber: _ac_no.text,
            accountType: saving
                ? "Saving"
                : current
                    ? "Current"
                    : "",
            bankName: _bank_name.text,
            ifscCode: _ifsc_code.text,
            panCard: _pan_no.text,
            panCardCopy: panCardCopy,
            cancelCheque: cancelCheckCopy);
        Map<String, dynamic> jsonData = postBankingModel.toJson();

        await JobPostApiService.AddBankingDetails(jsonData);

        // Assuming you have access to the ref and fetchBankingDetails in your widget tree
        ref.refresh(fetchBankingDetails);

        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
      // Handle error...
    }
  }

  Container customCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 50.r,
                backgroundColor: Constants.borderColor,
                backgroundImage:
                    widget.profilePic != null && widget.profilePic != "null"
                        ? Image.network(
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.profilePic}",
                            fit: BoxFit.fill,
                          ).image
                        : Image.asset(
                            widget.gender != "Male"
                                ? "assets/images/leadfemal.png"
                                : "assets/images/leadmale.png",
                            //  height: 8.h,
                            fit: BoxFit.fill,
                          ).image),
            SizedBox(
              height: 20.h,
            ),
            customTextfield(
                context: context,
                controller: _ac_type,
                label: widget.name,
                hint: widget.name,
                focusNode: _ac_focus_node,
                textfield_no: 1,
                lock: false,
                obsecText: false,
                icon: const Icon(Icons.person_2_outlined)),
            customTextfield(
                context: context,
                controller: _bank_name,
                label: "Bank Name",
                hint: "Bank of India",
                focusNode: _bank_focus_node,
                textfield_no: 3,
                lock: true,
                obsecText: false,
                icon: const Icon(Icons.account_balance_outlined)),
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Type",
                    style: GoogleFonts.varela(
                        color: Constants.themeBgColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customAccountType(
                          context: context,
                          isSelect: saving,
                          title: "Saving",
                          onTab: () {
                            setState(() {
                              saving = true;
                              current = false;
                            });
                          }),
                      customAccountType(
                          context: context,
                          isSelect: current,
                          title: "Current",
                          onTab: () {
                            setState(() {
                              saving = false;
                              current = true;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
            customTextfield(
                context: context,
                controller: _ac_no,
                label: "A/C Number",
                hint: "021215******",
                focusNode: _ac_focus_node,
                textfield_no: 1,
                lock: true,
                obsecText: true,
                icon: const Icon(Icons.account_balance_wallet_outlined)),
            customTextfield(
                context: context,
                controller: _ac_no_verify,
                label: "Verify A/C Number",
                hint: "021215******",
                focusNode: _ac_verify_focus_node,
                textfield_no: 2,
                lock: true,
                obsecText: true,
                icon: const Icon(Icons.account_balance_wallet_outlined)),
            customTextfield(
                context: context,
                controller: _ifsc_code,
                label: "IFCS code",
                hint: "BK***15D",
                focusNode: _ifsc_focus_node,
                textfield_no: 4,
                lock: true,
                obsecText: false,
                icon: const Icon(Icons.adjust_sharp)),
            customTextfield(
                context: context,
                controller: _pan_no,
                label: "Pan Card Number",
                hint: "MG1**32D4",
                focusNode: _pan_focus_node,
                textfield_no: 5,
                lock: true,
                obsecText: false,
                icon: const Icon(Icons.credit_card)),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload Document",
                    style: GoogleFonts.varela(
                        color: Constants.themeBgColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          panCardCopy == ""
                              ? setState(() async {
                                  panCardCopy = (await uploadFile(['pdf']))!;
                                  setState(() {});
                                })
                              : showPdfUploadDialog(context, "pan");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border:
                                  Border.all(color: Constants.themeBgColor)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("PanCard"),
                              if (panCardCopy != "")
                                SizedBox(
                                  width: 4.sp,
                                ),
                              if (panCardCopy != "")
                                Icon(
                                  Icons.visibility_outlined,
                                  size: 15.sp,
                                )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          cancelCheckCopy == ""
                              ? setState(() async {
                                  cancelCheckCopy =
                                      (await uploadFile(['pdf']))!;
                                  setState(() {});
                                })
                              : showPdfUploadDialog(context, "cancel");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border:
                                  Border.all(color: Constants.themeBgColor)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Cancel Check"),
                              if (cancelCheckCopy != "")
                                SizedBox(
                                  width: 4.sp,
                                ),
                              if (cancelCheckCopy != "")
                                Icon(
                                  Icons.visibility_outlined,
                                  size: 15.sp,
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customAccountType({
    required BuildContext context,
    required Function onTab,
    required bool isSelect,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        onTab();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        width: MediaQuery.of(context).size.width / 2.2.w,
        //  margin: EdgeInsets.symmetric(vertical: 4.h,horizontal: 8.w),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
        decoration: BoxDecoration(
            color: isSelect ? Constants.themeBgColor : Constants.borderColor,
            borderRadius: BorderRadius.circular(8.r)),
        child: Center(
            child: Text(title,
                style: GoogleFonts.varela(
                    color: isSelect ? Colors.white : Colors.grey.shade500))),
      ),
    );
  }

  Widget customTextfield(
      {required String hint,
      required String label,
      required BuildContext context,
      required TextEditingController controller,
      required FocusNode focusNode,
      required int textfield_no,
      required bool lock,
      required bool obsecText,
      required Icon icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      height: MediaQuery.of(context).size.height / 24.h,
      child: TextField(
        enableInteractiveSelection: !obsecText,
        obscureText: obsecText,
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
                      : FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
        ],
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        style:
            GoogleFonts.varela(color: Constants.subtitleclr, fontSize: 14.sp),
        decoration: InputDecoration(
            filled: true,
            fillColor: Constants.borderColor,
            prefixIcon: icon,
            prefixIconColor: Constants.themeBgColor,
            contentPadding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            counterText: '',
            labelText: label,
            labelStyle: const TextStyle(
              color: Constants.themeBgColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xffff0eceb)),
            ),
            focusColor: const Color(0xffff0eceb),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Constants.themeBgColor,
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.sourceSansPro(
                color: Constants.hintColor, fontSize: 15.sp)),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Future<String?> uploadFile(
    allowExt,
  ) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile("salarySlip", result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          print(filename);
          print("Filename: $filePath");

          // Close the loading dialog when the upload is successful
          Navigator.pop(context);
          //save(filename, data);

          return filename;
        } else {
          // Close the loading dialog when there is an error
          Navigator.pop(context);

          // Handle the case where the server returns an error
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error while uploading cv"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
          return null;
        }
      } catch (e) {
        // Close the loading dialog in case of exceptions
        Navigator.pop(context);

        // Handle any exceptions that occur during the upload
        print("Error during file upload: $e");
        return null;
      }
    } else {
      // Close the loading dialog when the user cancels file selection
      Navigator.pop(context);

      // Handle the case where the user cancels file selection
      return null;
    }
  }

  Future<void> showPdfUploadDialog(BuildContext context, String data) async {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    data == "pan" ? panCardCopy = "" : cancelCheckCopy = "";
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Constants.themeBgColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 15.h,
                        color: Constants.themeBgColor,
                      ),
                      SizedBox(width: 4.w),
                      const Text("Remove"),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  setState(() async {
                    data == "pan"
                        ? panCardCopy = (await uploadFile(['pdf']))!
                        : cancelCheckCopy = (await uploadFile(['pdf']))!;
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.w),
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Constants.themeBgColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 15.h,
                        color: Constants.themeBgColor,
                      ),
                      SizedBox(width: 4.w),
                      const Text("Replace"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            child: FutureBuilder<PDFDocument>(
              future: PDFDocument.fromURL(
                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data == "pan" ? panCardCopy : cancelCheckCopy}",
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
