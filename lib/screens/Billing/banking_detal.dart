// ignore_for_file: unnecessary_null_comparison, unused_result, use_full_hex_values_for_flutter_colors, duplicate_ignore
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
import 'package:job_circle/constants/custom_textfield_for_profile.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/get_banking_detail_model.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:super_banners/super_banners.dart';

final fetchBankingDetails = FutureProvider<List<GetBankingModel>>((ref) {
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
  static Future<List<GetBankingModel>> fetchBillingData() async {
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
                      body: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final bankData = data[index];
                          return customCardToViewBank(bankData);
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
                              if (_ac_no.text == null || _ac_no.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Specify Account Number",
                                        error: true));
                              } else if (_ac_no.text != _ac_no_verify.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Account Number mismatch",
                                        error: true));
                              } else if (_bank_name.text.isEmpty ||
                                  _bank_name.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Specify Bank Name.",
                                        error: true));
                              } else if (checkBankName == null ||
                                  checkBankName == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title:
                                            "Select Bank Name from given list.",
                                        error: true));
                              } else if (_ifsc_code == null ||
                                  _ifsc_code.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Specify IFSC Code",
                                        error: true));
                              } else if (_pan_no == null ||
                                  _pan_no.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Specify Pan Card Number",
                                        error: true));
                              } else if (panCardCopy == null ||
                                  panCardCopy == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Specify The copy of Pan Card",
                                        error: true));
                              } else if (cancelCheckCopy == null ||
                                  cancelCheckCopy == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title:
                                            "Specify The copy of Cancel Check",
                                        error: true));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Bank Details Confirmation"),
                                          ],
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Bank Name :- ${_bank_name.text}"),
                                            Text(
                                                "Account Type :- ${saving ? "Saving" : "Current"}"),
                                            Text(
                                                "A/C Number :- ${_ac_no.text}"),
                                            Text(
                                                "A/C Holder Name :- ${widget.name}"),
                                            Text(
                                                "IFSC code :- ${_ifsc_code.text.toUpperCase()}"),
                                            Text(
                                                "Pan Card :- ${_pan_no.text.toUpperCase()}"),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await addBankingDetails();
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.h,
                                                            horizontal: 8.w),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6.h,
                                                            horizontal: 12.w),
                                                    decoration: BoxDecoration(
                                                        color: Constants.blue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r)),
                                                    child:
                                                        const Text("Confirm"),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _bank_name.clear();
                                                    checkBankName = "";
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.h,
                                                            horizontal: 8.w),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6.h,
                                                            horizontal: 12.w),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Constants.lightdull,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r)),
                                                    child: const Text("Edit"),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ));
                                  },
                                );
                              }

                              //
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
                  color: Constants.themeBgColor,
                  strokeWidth: 1,
                )),
              );
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

  Stack customCardToViewBank(GetBankingModel data) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/images/bank.png",
                        height: 30.h,
                        fit: BoxFit.fill,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.bankName.toString(),
                          style:
                              GoogleFonts.varela(fontWeight: FontWeight.bold)),
                      Text("${data.accountType} Account".toString(),
                          style: GoogleFonts.varela()),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Text("Holder Name:- ${widget.name.toTitleCase()}",
                  style: GoogleFonts.varela()),
              Text("A/C:- ${data.accountNumber}", style: GoogleFonts.varela()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("IFSC:- ${data.ifscCode}", style: GoogleFonts.varela()),
                  /* data.isVerify == null
                      ? Container(
                          child: const Text("Under Review"),
                        )
                      : data.isVerify == 0
                          ? Container(
                              child: const Text("InActive"),
                            )
                          : Container(
                              child: const Text("Active"),
                            ) */
                ],
              ),
            ],
          ),
        ),
        /* if (data.isVerify != 1 || data.isVerify != 0)
          Positioned(
              child: data.isVerify == null
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 30.h, horizontal: 16.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 16.w),
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Under Review",
                              style: GoogleFonts.varela(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            )
                          ],
                        ),
                      ),
                    )
                    
                  : const SizedBox())
                  
 */

        Positioned(
          right: 15.w,
          top: 10,
          child: CornerBanner(
              bannerPosition: CornerBannerPosition.topRight,
              elevation: 1,
              bannerColor: data.isVerify == null
                  ? Colors.orange
                  : data.isVerify == 0
                      ? Colors.red
                      : Colors.green,
              child: Text(
                data.isVerify == null
                    ? "Under Review"
                    : data.isVerify == 0
                        ? "InActive"
                        : "Active",
                style: GoogleFonts.roboto(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
        ),
        Positioned(
            right: 15.w,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showUploadedDocument(
                          context, data.panCardCopy.toString());
                    },
                    child: Image.asset(
                      "assets/images/pancard.png",
                      height: 30,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      showUploadedDocument(
                          context, data.panCardCopy.toString());
                    },
                    child: Image.asset(
                      "assets/images/cancel_check.png",
                      height: 30,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> addBankingDetails() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
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
            accountNumber: int.tryParse(_ac_no.text),
            uid: userid,
            accountType: saving
                ? "Saving"
                : current
                    ? "Current"
                    : "",
            bankName: _bank_name.text,
            ifscCode: _ifsc_code.text,
            panCard: _pan_no.text,
            panCardCopy: panCardCopy,
            bankId: int.tryParse(bankid), //TODO from all bank dropdown...
            cancelCheque: cancelCheckCopy);
        Map<String, dynamic> jsonData = postBankingModel.toJson();

        await JobPostApiService.AddBankingDetails(jsonData, context);

        // Assuming you have access to the ref and fetchBankingDetails in your widget tree
        ref.refresh(fetchBankingDetails);
        Navigator.pop(context);
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
              /*  customTextfield(
                  context: context,
                  controller: _bank_name,
                  label: "Bank Name",
                  hint: "Bank of India",
                  focusNode: _bank_focus_node,
                  textfield_no: 3,
                  lock: true,
                  obsecText: false,
                  icon: const Icon(Icons.account_balance_outlined)), */
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
                                hideText = true;
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
                                hideText = true;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              customTextfield(
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
              customTextfield(
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
              customTextfield(
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
                  limit: 12,
                  icon: const Icon(Icons.adjust_sharp)),
              customTextfield(
                  onTab: () {
                    setState(() {
                      hideText = true;
                    });
                  },
                  context: context,
                  controller: _pan_no,
                  label: "Pan Card Number",
                  hint: "MG1**32D4",
                  focusNode: _pan_focus_node,
                  textfield_no: 5,
                  lock: true,
                  obsecText: false,
                  limit: 10,
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
                                const Text("Cancel Cheque"),
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
      required Icon icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      height: MediaQuery.of(context).size.height / 24.h,
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
                      : FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
        ],
        onSubmitted: (value) {
          setState(() {
            hideText = true;
          });
        },
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
