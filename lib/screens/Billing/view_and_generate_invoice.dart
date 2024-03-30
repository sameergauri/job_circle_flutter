// ignore_for_file: unnecessary_null_comparison, unused_result, use_full_hex_values_for_flutter_colors, duplicate_ignore
// ignore_for_file: override_on_non_overriding_member, unused_field, unused_local_variable, unused_result, file_names, avoid_print, unused_element, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_null_comparison
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/get_banking_detail_model.dart';
import 'package:job_circle/models/view_and_generate_model.dart';
import 'package:job_circle/screens/Billing/Invoice.dart';
import 'package:job_circle/screens/Billing/banking_detal.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final fetchAllBillingDataProvider =
    FutureProvider<List<ViewAndGenerateBillingModel>>((ref) {
  Future.delayed(const Duration(milliseconds: 10));
  return _GenerateInvoiceState.FetchBillingData();
});

class GenerateInvoice extends ConsumerStatefulWidget {
  final String name;
  final String profilePic;
  final String gender;
  const GenerateInvoice(
      {super.key,
      required this.name,
      required this.profilePic,
      required this.gender});

  @override
  ConsumerState<GenerateInvoice> createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends ConsumerState<GenerateInvoice> {
  static Future<List<ViewAndGenerateBillingModel>> FetchBillingData() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/billingDetailsForReferral?rid=$userid&pageNumber=1&pageSize=1000');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Filter the list based on the condition invoice_no == null
        List<ViewAndGenerateBillingModel> applicants = contentList
            .where((json) => json['invoice_no'] == null)
            .map((json) => ViewAndGenerateBillingModel.fromJson(json))
            .toList();

        return applicants;
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

  //TODO:: Varibale Decl...

  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  int? selectedMonthAndYear;

  //TODO:: Varibale decl end....

  @override
  Widget build(BuildContext context) {
    var fetchBillingData = ref.watch(fetchAllBillingDataProvider);

    return fetchBillingData != null
        ? fetchBillingData.when(data: (fetchData) {
            return Scaffold(
                backgroundColor: Colors.white,
                // extendBody: true,
                //  resizeToAvoidBottomInset: false,
                bottomNavigationBar: selectedMonthAndYear != null
                    ? buildBottomNavigationBar(fetchData)
                    : null,
                appBar: PreferredSize(
                  preferredSize:
                      const Size(double.maxFinite, kTextTabBarHeight),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: fetchData.isNotEmpty
                        ? customSearchField(context)
                        : const Text(""),
                    actions: fetchData.isNotEmpty
                        ? [buildMonthAndYearSelector(fetchData)]
                        : [],
                  ),
                ),
                body: SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: buildFilteredListView(fetchData)));
          }, error: (error, stackTrace) {
            return const Scaffold(
              body: Center(
                child: Text(
                    "Oops! Something went wrong on our end. Our team is working to fix the issue. Please be patient and bear with us as we resolve this. Thank you for your understanding."),
              ),
            );
          }, loading: () {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Constants.themeBgColor,
                strokeWidth: 1,
              )),
            );
          })
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset("assets/images/nodata.jpg"),
            ),
          );
  }

  //TODO:: Function Decl..

  bool shouldDisplayBottomNavBar(List<ViewAndGenerateBillingModel> fetchData) {
    // Filter data based on the selected month
    final selectedMonthData = fetchData
        .where((item) =>
            selectedMonthAndYear != null &&
            DateTime.parse(item.doj.toString()).month ==
                selectedMonthAndYear! % 100 &&
            DateTime.parse(item.doj.toString()).year ==
                selectedMonthAndYear! ~/ 100)
        .toList();

    // Check if there is no lead with a status other than "Payable" in the selected month
    bool allPayable = selectedMonthData.every((item) =>
        item.attrStatus != null &&
        item.attrStatus!.toLowerCase() != 'other source' &&
        item.attrStatus!.toLowerCase() != 'pending' &&
        item.attrStatus!.toLowerCase() != 'under clause');

    return allPayable;
  }

  Widget buildBottomNavigationBar(List<ViewAndGenerateBillingModel> fetchData) {
    // Filter data based on the selected month
    final selectedMonthData = fetchData
        .where((item) =>
            selectedMonthAndYear != null &&
            DateTime.parse(item.doj.toString()).month ==
                selectedMonthAndYear! % 100 &&
            DateTime.parse(item.doj.toString()).year ==
                selectedMonthAndYear! ~/ 100)
        .toList();

    // Calculate the total amount for leads with "Payable" status in the selected month
    double totalAmount = selectedMonthData
        .where((item) =>
            item.attrStatus != null &&
            item.attrStatus!.toLowerCase() == 'payable')
        .fold(0.0, (sum, item) => sum + item.partnerPayout!);

    String formattedTotalAmount = totalAmount
        .toStringAsFixed(0)
        .replaceAll(RegExp(r'(\.0|(?<=\.\d)0+)$'), '');

    return BottomAppBar(
      //... (existing properties)
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Total Amount",
                  style: GoogleFonts.varela(
                      fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_outlined,
                      size: 15.sp,
                    ),
                    Text(
                      formattedTotalAmount.toString().replaceAll('.0', ''),
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ],
                ),
              ],
            ),
            shouldDisplayBottomNavBar(fetchData)
                ? GestureDetector(
                    onTap: () async {
                      try {
                        List<GetBankingModel> data = await ApplicationAPI
                            .fetchBankingDataForBankDetail();
                        if (data.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialogueForAddResume(
                                error: false,
                                subtitle:
                                    "Add banking Detail to generate invoice",
                                onClose: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BankingDetals(
                                            fromInvoice: true,
                                                gender: widget.gender,
                                                name: widget.name,
                                                profilePic: widget.profilePic,
                                              )));
                                },
                              );
                            },
                          );
                        } else if (data.isNotEmpty &&
                            (data.first.isVerify == 0 ||
                                data.first.isVerify == null)) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialogueForAddResume(
                                error: false,
                                subtitle:
                                    "Your banking detail is under review you have to wait.",
                                onClose: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        } else {
                          List<int?>? leadIdList = fetchData
                              .where(
                                  (element) => element.attrStatus != "Payable")
                              .map((e) => e.id)
                              .toList();
                          List<int> filteredLeadIdList = leadIdList
                              .where((id) => id != null)
                              .cast<int>()
                              .toList();

                          try {
                            JobPostApiService api = JobPostApiService();
                            await api.updateInvoiceToMakeNonPayable(
                              partnerInvoiceNo: "Not Applicable",
                              id: filteredLeadIdList,
                            );
                            ref.refresh(fetchAllBillingDataProvider);
                          } catch (e) {
                            print("Error $e");
                            /* ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackbarfinal(
                                title: "Error submitting invoice",
                                error: true,
                              ),
                            ); */
                          }
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Invoice()));
                        }
                      } catch (error) {
                        // Handle errors
                        print('Error fetching banking data: $error');
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Constants.blue,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0.5, 2),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.grey.shade200)
                        ],
                        // border: Border.all(color: Constants.subtitleclr)
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Create Invoice",
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 4.sp,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 13.sp,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
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
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Text(
                      "Generate Invoice",
                      style: GoogleFonts.varela(color: Colors.grey.shade300),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget buildFilteredListView(
    List<ViewAndGenerateBillingModel> fetchData,
  ) {
    // Your filtering condition
    final filteredData = fetchData
        .where((item) =>
            item.applicantName!
                .toLowerCase()
                .toString()
                .contains(_searchController.text.toLowerCase()) ||
            item.lastName!
                .toLowerCase()
                .toString()
                .contains(_searchController.text.toLowerCase()) ||
            item.process!
                .toLowerCase()
                .toString()
                .contains(_searchController.text.toLowerCase()) ||
            item.companyName!
                .toLowerCase()
                .toString()
                .contains(_searchController.text.toLowerCase()))
        .toList();

    final additionalFilteredData = filteredData
        .where((item) => (selectedMonthAndYear == null ||
            DateTime.parse(item.doj.toString()).month ==
                    selectedMonthAndYear! % 100 &&
                DateTime.parse(item.doj.toString()).year ==
                    selectedMonthAndYear! ~/ 100))
        .toList();

    if (fetchData == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Constants.themeBgColor,
          strokeWidth: 1,
        ),
      );
    }

    // Display message when no data is found
    if (additionalFilteredData.isEmpty) {
      return Center(
        child: Image.asset("assets/images/nodata.jpg"),
        /* Text(
          "No results found.",
          style: GoogleFonts.varela(),
        ), */
      );
    }

    // Using ListView.builder with the filtered data
    return ListView.builder(
      shrinkWrap: true,
      itemCount: additionalFilteredData.length,
      itemBuilder: (context, index) {
        final billingData = additionalFilteredData[index];
        return CustomCard(billingData);
      },
    );
  }

  Container CustomCard(ViewAndGenerateBillingModel filteredData) {
    String formattedAmount = filteredData.partnerPayout != null
        ? filteredData.partnerPayout!
            .toStringAsFixed(0)
            .replaceAll(RegExp(r'(\.0|(?<=\.\d)0+)$'), '')
        : "";

    DateTime dateTime = DateTime.parse(filteredData.doj.toString());
    String formattedDate = DateFormat("d MMM yyyy").format(dateTime);
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(filteredData.applicantName.toString(),
                  style: GoogleFonts.varela(
                      fontSize: 14.sp, fontWeight: FontWeight.bold)),
              const Text(" "),
              Text(filteredData.lastName.toString(),
                  style: GoogleFonts.varela(
                      fontSize: 14.sp, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_outlined,
                      size: 15.sp,
                    ),
                    Text(
                      formattedAmount.toString().replaceAll(".0", ""),
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(filteredData.shortCode.toString(),
                  style: GoogleFonts.varela(
                      fontSize: 14.sp, fontWeight: FontWeight.normal)),
              const Text(" || "),
              Text(filteredData.process.toString(),
                  style: GoogleFonts.varela(
                      fontSize: 14.sp, fontWeight: FontWeight.normal)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 4.h),
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8..w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0.5, 2),
                        blurRadius: 2,
                        spreadRadius: 2,
                        color: Colors.grey.shade200)
                  ],
                  borderRadius: BorderRadius.circular(8.r),
                  // border: Border.all(color: Constants.themeBgColor)
                ),
                child: Text(
                  formattedDate,
                  style: GoogleFonts.varela(color: Constants.subtitleclr),
                ),
              ),
              filteredData.attrStatus == "Payable"
                  ? Row(
                      children: [
                        Icon(
                          Icons.done_all,
                          size: 12.sp,
                          color: Constants.green,
                        ),
                        Text(" Payable",
                            style: GoogleFonts.varela(color: Constants.green)),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8..w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0.5, 2),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.grey.shade200)
                        ],
                        borderRadius: BorderRadius.circular(8.r),
                        // border: Border.all(color: Constants.themeBgColor)
                      ),
                      child: Text(
                        filteredData.attrStatus == null
                            ? "Pending"
                            : filteredData.attrStatus.toString(),
                        style: GoogleFonts.varela(color: Constants.subtitleclr),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox customSearchField(BuildContext context) {
    return SizedBox(
      //margin: EdgeInsets.only(top: 10.h),
      height: MediaQuery.of(context).size.height / 24.h,
      child: TextField(
        keyboardType: TextInputType.name,
        //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
        textCapitalization: TextCapitalization.sentences,
        controller: _searchController,
        style:
            GoogleFonts.varela(color: Constants.subtitleclr, fontSize: 14.sp),
        decoration: InputDecoration(
            filled: true,
            fillColor: Constants.borderColor,
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: Constants.themeBgColor,
            contentPadding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            counterText: '',
            // labelText: "Remark",
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
            hintText: "Search",
            hintStyle: GoogleFonts.sourceSansPro(
                color: Constants.hintColor, fontSize: 15.sp)),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllBillingDataProvider);
    // Update the UI with new data

    _refreshController
        .refreshCompleted(); // Call this to end the refresh animation
  }

  Widget buildMonthAndYearSelector(
      List<ViewAndGenerateBillingModel> filteredData) {
    Set<int> uniqueMonthsAndYears = filteredData
        .map((item) => item.doj != null
            ? (DateTime.parse(item.doj.toString()).year * 100) +
                DateTime.parse(item.doj.toString()).month
            : 0)
        .toSet();
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      child: DropdownButton<int>(
        // isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: const SizedBox.shrink(),
        // hint: const Text("All"),
        value: selectedMonthAndYear,
        onChanged: (int? newValue) {
          setState(() {
            selectedMonthAndYear = newValue;
            _searchController.clear();
            // Apply filtering based on the selected month and year
            // You can use the selectedMonthAndYear to filter your data further
          });
        },
        items: [
          DropdownMenuItem<int>(
            value: null,
            child: Text(
              "All",
              style: GoogleFonts.varela(),
            ),
          ),
          ...uniqueMonthsAndYears.map((int monthAndYear) {
            int year = monthAndYear ~/ 100;
            int month = monthAndYear % 100;
            return DropdownMenuItem<int>(
              value: monthAndYear,
              child: Text(
                "${getMonthName(month)}-${year.toString().substring(2)}",
                style: GoogleFonts.varela(),
              ),
            );
          }),
        ],
      ),
    );
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  //TODO:: Function dec end
}
