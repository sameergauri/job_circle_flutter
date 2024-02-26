// ignore_for_file: unnecessary_null_comparison, unused_result, avoid_print, use_full_hex_values_for_flutter_colors, non_constant_identifier_names, avoid_unnecessary_containers
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/list_of_invoice_model.dart';
import 'package:job_circle/screens/Billing/invoice_detail.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final fetchAllInvoice = FutureProvider<List<ListOfInvoiceModel>>((ref) {
  Future.delayed(const Duration(milliseconds: 10));
  return _ListOfInvoiceState.fetchAllInvoiceDetail();
});

class ListOfInvoice extends ConsumerStatefulWidget {
  const ListOfInvoice({super.key});

  @override
  ConsumerState<ListOfInvoice> createState() => _ListOfInvoiceState();
}

class _ListOfInvoiceState extends ConsumerState<ListOfInvoice> {
  //
  //
  //
  /* static Future<List<ListOfInvoiceModel>> fetchAllInvoiceDetail() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllInvoiceOfReferral?rid=1231&pageNumber=1&pageSize=100');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['resultData'] != null) {
          final List<dynamic> contentList = jsonData['resultData']['content'];

          // Convert the list of Map to a list of ListOfInvoiceModel objects
          List<ListOfInvoiceModel> invoices = contentList
              .map((json) => ListOfInvoiceModel.fromJson(json))
              .toList();

          return invoices;
        } else {
          print('resultData is null');
          return [];
        }
      } else {
        print(
            'Failed to fetch invoice data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  } */

//
//
//

  /* static Future<List<ListOfInvoiceModel>> fetchAllInvoiceDetail() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllInvoiceOfReferral?rid=$userid&pageNumber=1&pageSize=100');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData'];

        // Convert the list of Map to a list of Applicant objects
        List<ListOfInvoiceModel> applicants = contentList
                .map((json) => ListOfInvoiceModel.fromJson(json))
                .toList() ??
            [];

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
  } */
  static Future<List<ListOfInvoiceModel>> fetchAllInvoiceDetail() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllInvoiceOfReferral?rid=$userid&pageNumber=1&pageSize=100');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData'];

        // Convert the list of Map to a list of ListOfInvoiceModel objects
        List<ListOfInvoiceModel> applicants = contentList
                .map((json) => ListOfInvoiceModel.fromJson(json))
                .toList();

        // Sort the list based on invoice date in descending order (most recent first)
        applicants.sort((a, b) => b.invoice_date.compareTo(a.invoice_date));

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

  //
  //
  //
  //
  //TODO:: variable dec...

  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  int? selectedMonthAndYear;
  //
  //
  //
  //
  @override
  Widget build(BuildContext context) {
    var fetchAllInvoiceData = ref.watch(fetchAllInvoice);
    return fetchAllInvoiceData != null
        ? fetchAllInvoiceData.when(
            data: (data) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize:
                        const Size(double.maxFinite, kTextTabBarHeight),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      centerTitle: true,
                      title: Row(
                        children: [
                          Image.asset(
                            "assets/images/invoice.png",
                            height: 24.sp,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            "Track Invoice",
                            style: GoogleFonts.varela(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // title: customSearchField(context),  //TODO:: Searchbar
                      // actions: [buildMonthAndYearSelector(data)],//TODO:: Filter as per month..
                    ),
                  ),
                  body: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: buildFilteredListView(data)));
            },
            error: (error, stackTrace) {
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Oops! Something went wrong on our end. Our team is working to fix the issue. Please be patient and bear with us as we resolve this. Thank you for your understanding.",
                  ),
                ),
              );
            },
            loading: () {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Constants.themeBgColor,
                    strokeWidth: 1,
                  ),
                ),
              );
            },
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/nopayment.gif"),
                  Text(
                    "No Invoice",
                    style: GoogleFonts.varela(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
  //TODO:: Function dec....
  //
  //
  //
  // TODO:: Custom Search Field at the top ...

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllInvoice);
    // Update the UI with new data

    _refreshController
        .refreshCompleted(); // Call this to end the refresh animation
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

  //
  //
  //
  //
  // TODO:: Month filter....
  //
  //
  Widget buildMonthAndYearSelector(List<ListOfInvoiceModel> filteredData) {
    Set<int> uniqueMonthsAndYears = filteredData
        .map((item) => item.invoice_date != null
            ? (DateTime.parse(item.invoice_date.toString()).year * 100) +
                DateTime.parse(item.invoice_date.toString()).month
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

  //
  //
  // TODO: Filtered List..
  Widget buildFilteredListView(
    List<ListOfInvoiceModel> fetchData,
  ) {
    // Your filtering condition
    final filteredData = fetchData
        .where((item) =>
            item.bank_name
                .toLowerCase()
                .toString()
                .contains(_searchController.text.toLowerCase()) ||
            item.referralName
                .toLowerCase()
                .toString()
                .contains(_searchController.text.toLowerCase()))
        .toList();

    final additionalFilteredData = filteredData
        .where((item) => (selectedMonthAndYear == null ||
            DateTime.parse(item.invoice_date.toString()).month ==
                    selectedMonthAndYear! % 100 &&
                DateTime.parse(item.invoice_date.toString()).year ==
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
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InvoiceDetail(
                            invoiceModel: billingData,
                          )));
            },
            child: CustomCard(billingData));
      },
    );
  }

  //
  //
  // TODO:: Custom card for card ui of each invoice...
  Container CustomCard(ListOfInvoiceModel filteredData) {
    DateTime dateTime = DateTime.parse(filteredData.invoice_date.toString());
    String formattedDate = DateFormat("d MMM yyyy").format(dateTime);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.grey.shade300,
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "INVOICE",
                      style: GoogleFonts.varela(
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To,",
                            style: GoogleFonts.varela(fontSize: 10.sp),
                          ),
                          Text(
                            formattedDate,
                            style: GoogleFonts.varela(
                                fontSize: 10.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "Job Circle",
                        style: GoogleFonts.varela(
                            fontSize: 10.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Thane ${"(W)"},\nMumbai-400601",
                        style: GoogleFonts.varela(fontSize: 10.sp),
                      ),
                      Text(
                        "Invoice No :  ${filteredData.invoice_no}",
                        // generateInvoiceNumber(data.first.userId.toString())

                        style: GoogleFonts.varela(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
                /* Row(
                  children: [
                    Text("Invoice No : ${filteredData.invoice_no.toString()}",
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
                            filteredData.total_amount.toString(),
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
                    Text("A/C No : ${filteredData.ifsc_code.toString()}",
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
                        "Billing Status:-${filteredData.payment_status}",
                        style: GoogleFonts.varela(color: Constants.subtitleclr),
                      ),
                    ),
                  ],
                ) */
              ],
            ),
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
                child: Row(
                  children: [
                    filteredData.payment_status == "" ||
                            filteredData.payment_status == null
                        ? Icon(
                            Icons.done,
                            size: 15.sp,
                          )
                        : filteredData.payment_status == "Under Process"
                            ? Image.asset(
                                "assets/images/inprocess.png",
                                height: 13.sp,
                              )
                            : Icon(
                                Icons.done_all_outlined,
                                size: 15.sp,
                                color: Constants.green,
                              ),
                    SizedBox(width: 4.w),
                    Text(
                      filteredData.payment_status != ""
                          ? filteredData.payment_status
                          : "Invoice Submited",
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold,
                          color: filteredData.payment_status == "" ||
                                  filteredData.payment_status == null
                              ? Constants.subtitleclr
                              : filteredData.payment_status == "Under Process"
                                  ? Colors.orange
                                  : Constants.green),
                    ),
                  ],
                ),
              ),
              Container(
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.currency_rupee_outlined,
                        size: 13.sp,
                      ),
                      Text(
                        filteredData.total_amount
                            .toString()
                            .replaceAll(".0", ""),
                        style: GoogleFonts.varela(
                            fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  //
  //
  //
  //TODO:: Function dec end
}
