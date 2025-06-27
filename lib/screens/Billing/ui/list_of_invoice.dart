/* // ignore_for_file: unnecessary_null_comparison, unused_result, avoid_print, use_full_hex_values_for_flutter_colors, non_constant_identifier_names, avoid_unnecessary_containers
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/components/custom_remark.dart';
import 'package:job_circle/models/list_of_invoice_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
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

class _ListOfInvoiceState extends ConsumerState<ListOfInvoice>
    with TickerProviderStateMixin {
  //
  //
  //

  /*  static Future<List<ListOfInvoiceModel>> fetchAllInvoiceDetail() async {
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
  } */

  static Future<List<ListOfInvoiceModel>> fetchAllInvoiceDetail() async {
    try {
      return [
        ListOfInvoiceModel(
          referralName: "John Doe",
          total_amount: 12500.0,
          invoice_date: DateTime.now().subtract(const Duration(days: 10)),
          invoice_no: "INV001",
          bank_name: "Axis Bank",
          ifsc_code: "UTIB0001234",
          account_number: 1234567890,
          account_type: "Savings",
          payment_status: "Invoice Sent",
          remark: "Invoice pending clearance",
          candidates: [
            Candidate(
              id: 1,
              candidateName: "Alice Smith",
              companyName: "TCS",
              process: "HR",
              shortCode: "HR01",
              candidateAmount: 5000.0,
              doj: DateTime.now().subtract(const Duration(days: 30)),
            ),
            Candidate(
              id: 2,
              candidateName: "Bob Johnson",
              companyName: "Infosys",
              process: "Finance",
              shortCode: "FIN02",
              candidateAmount: 7500.0,
              doj: DateTime.now().subtract(const Duration(days: 20)),
            ),
          ],
        ),
        ListOfInvoiceModel(
          referralName: "Jane Roe",
          total_amount: 8900.0,
          invoice_date: DateTime.now().subtract(const Duration(days: 20)),
          invoice_no: "INV002",
          bank_name: "HDFC Bank",
          ifsc_code: "HDFC0009876",
          account_number: 9876543210,
          account_type: "Current",
          payment_status: "Paid",
          remark: "Payment completed successfully",
          candidates: [
            Candidate(
              id: 3,
              candidateName: "Charlie Brown",
              companyName: "Wipro",
              process: "Tech",
              shortCode: "TECH03",
              candidateAmount: 8900.0,
              doj: DateTime.now().subtract(const Duration(days: 45)),
            ),
          ],
        ),
        ListOfInvoiceModel(
          referralName: "Jane Roe",
          total_amount: 8900.0,
          invoice_date: DateTime.now().subtract(const Duration(days: 60)),
          invoice_no: "INV002",
          bank_name: "HDFC Bank",
          ifsc_code: "HDFC0009876",
          account_number: 9876543210,
          account_type: "Current",
          payment_status: "Validation",
          remark: "Payment completed successfully",
          candidates: [
            Candidate(
              id: 3,
              candidateName: "Charlie Brown",
              companyName: "Wipro",
              process: "Tech",
              shortCode: "TECH03",
              candidateAmount: 8900.0,
              doj: DateTime.now().subtract(const Duration(days: 45)),
            ),
          ],
        ),
      ];
    } catch (e) {
      print('Error while fetching invoice data: $e');
      return [];
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 0, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  List<ListOfInvoiceModel> _getFilteredData(List<ListOfInvoiceModel> allData) {
    return allData.where((item) {
      // Apply search filter
      final searchMatch = _searchController.text.isEmpty ||
          (item.bank_name
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ==
                  true ||
              (item.referralName
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ==
                  true));

      // Apply date filter
      bool dateMatch = true;
      if (selectedMonthAndYear != null && item.invoice_date != null) {
        dateMatch = item.invoice_date.month == selectedMonthAndYear! % 100 &&
            item.invoice_date.year == selectedMonthAndYear! ~/ 100;
      }

      return searchMatch && dateMatch;
    }).toList();
  }

  //
  //
  //
  //
  //TODO:: variable dec...

  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  int? selectedMonthAndYear;

  TabController? _tabController;
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
              //
              //
              //
              //
              final filteredData = _getFilteredData(data);

              final visibleStatuses = filteredData
                  .map((e) => e.payment_status)
                  .where((status) => status.isNotEmpty)
                  .toSet()
                  .toList();

              if (_tabController == null ||
                  _tabController!.length != visibleStatuses.length) {
                final newIndex = _tabController == null ||
                        _tabController!.index >= visibleStatuses.length
                    ? visibleStatuses.length - 1
                    : _tabController!.index;

                _tabController = TabController(
                  length: visibleStatuses.length,
                  vsync: this,
                  initialIndex: visibleStatuses.isNotEmpty
                      ? newIndex.clamp(0, visibleStatuses.length - 1)
                      : 0,
                );
              }

              //
              //
              //
              //
              //
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize:
                        const Size(double.maxFinite, kTextTabBarHeight),
                    child: AppBar(
                      titleSpacing: 0.0,
                      // centerTitle: true,
                      automaticallyImplyLeading: true,
                      iconTheme: const IconThemeData(color: Constants.black),
                      backgroundColor: Constants.borderColor,
                      elevation: 0.0,
                      title: const customTextForWeather(
                          title: 'Track Payments',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      // title: customSearchField(context),  //TODO:: Searchbar
                      actions: [
                        buildMonthAndYearSelector(data)
                      ], //TODO:: Filter as per month..
                    ),
                  ),
                  body: DefaultTabController(
                    length: visibleStatuses.length,
                    child: Column(
                      children: [
                        TabBar(
                          dividerHeight: 1.0,
                          controller: _tabController,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          labelColor: Constants.black,
                          unselectedLabelColor: Constants.subtitleclr,
                          indicatorColor: Constants.orange,
                          labelStyle: GoogleFonts.merriweather(
                              fontSize: 12, fontWeight: FontWeight.w700),
                          unselectedLabelStyle: GoogleFonts.merriweather(
                              fontSize: 12, fontWeight: FontWeight.normal),
                          tabs: visibleStatuses
                              .map((status) => Tab(text: status))
                              .toList(),
                        ),
                        Expanded(
                            child: TabBarView(
                          controller: _tabController,
                          children: visibleStatuses.map((status) {
                            final statusFilteredData = filteredData
                                .where((item) => item.payment_status == status)
                                .toList();
                            return buildFilteredListView(statusFilteredData);
                          }).toList(),
                        )),
                      ],
                    ),
                  ));
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
            ? (item.invoice_date.year * 100 + item.invoice_date.month)
            : 0)
        .toSet()
      ..remove(0); // Remove any invalid/default value

    return GestureDetector(
      onTap: () =>
          _showMonthFilterBottomSheet(context, uniqueMonthsAndYears.toList()),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/128/7602/7602631.png",
              height: 15,
              width: 15,
            ),
            const SizedBox(width: 4),
            customTextForWeather(
              title: selectedMonthAndYear != null
                  ? "${getMonthName(selectedMonthAndYear! % 100)}-${(selectedMonthAndYear! ~/ 100).toString().substring(2)}"
                  : "All",
              color: Constants.black,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthFilterBottomSheet(
      BuildContext context, List<int> monthYearList) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const customTextForWeather(
                    title: "Filter by Month",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Constants.darkBlue,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedMonthAndYear = null;
                      });
                      Navigator.pop(context);
                    },
                    child: const customTextForWeather(
                      title: "Clear All",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Constants.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: monthYearList.length,
                itemBuilder: (context, index) {
                  int value = monthYearList[index];
                  int month = value % 100;
                  int year = value ~/ 100;
                  String label =
                      "${getMonthName(month)}-${year.toString().substring(2)}";

                  return RadioListTile<int>(
                    value: value,
                    groupValue: selectedMonthAndYear,
                    title: customTextForWeather(title: label),
                    activeColor: Constants.darkBlue,
                    onChanged: (val) {
                      setState(() {
                        selectedMonthAndYear = val;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
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
            /*  onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InvoiceDetail(
                            invoiceModel: billingData,
                          )));
            }, */
            child: CustomCard(billingData));
      },
    );
  }

  //
  //
  // TODO:: Custom card for card ui of each invoice...
  Container CustomCard(ListOfInvoiceModel filteredData) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Image.network(
              "https://cdn-icons-png.flaticon.com/128/7928/7928355.png",
            ),
            title: const customTextForWeather(
              title: "Organization Name",
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextForWeather(
                  title: filteredData.invoice_no.toString(),
                  fontSize: 12,
                ),
                Container(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.currency_rupee_outlined,
                        size: 12,
                        color: Constants.darkBlue,
                      ),
                      customTextForWeather(
                        title:
                            "${filteredData.total_amount.toString().replaceAll(".0", "")} /-",
                        fontSize: 12,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Constants.lightdull,
              borderRadius: BorderRadius.circular(8.r),
              // border: Border.all(color: Constants.themeBgColor)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomRemarkConatiner(
                    subtitle: filteredData.remark,
                    valueColor: Constants.subtitleclr,
                    title: "Remark")
              ],
            ),
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
 */