// ignore_for_file: unnecessary_null_comparison, unused_result, use_full_hex_values_for_flutter_colors, duplicate_ignore
// ignore_for_file: override_on_non_overriding_member, unused_field, unused_local_variable, unused_result, file_names, avoid_print, unused_element, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_null_comparison
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/components/custom_remark.dart';
import 'package:job_circle/components/custom_title_button.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/view_and_generate_model.dart';
import 'package:job_circle/screens/Billing/Invoice.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
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

class _GenerateInvoiceState extends ConsumerState<GenerateInvoice>
    with TickerProviderStateMixin {
  /* static Future<List<ViewAndGenerateBillingModel>> FetchBillingData() async {
  
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
            //.where((json) => json['invoice_no'] == null)
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
  } */
  static Future<List<ViewAndGenerateBillingModel>> FetchBillingData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      ViewAndGenerateBillingModel(
        doj: "15-04-2024",
        partnerPayout: 12000.50,
        shortCode: "JD101",
        lastName: "Doe",
        companyName: "TechCorp",
        id: 1,
        attrStatus: "Joined",
        process: "BPO Hiring",
        applicantName: "John",
        rid: 101,
        subStatus: "Confirmed",
        invoice_no: null, // Simulate pending invoice
      ),
      ViewAndGenerateBillingModel(
        doj: "22-03-2024",
        partnerPayout: 980.75,
        shortCode: "JS202",
        lastName: "Smith",
        companyName: "FinTech Inc.",
        id: 2,
        attrStatus: "Payable",
        process: "Tech Hiring",
        applicantName: "Jane",
        rid: 102,
        subStatus: "Confirmed",
        invoice_no: null,
      ),
    ];
  }

  //TODO:: Varibale Decl...

  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  int? selectedMonthAndYear;

  FocusNode focusNode = FocusNode();

  late TabController _tabController;

  DateTime? _firstDojDate; // Add this to track first DOJ

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);

    // Delay controller initialization until data is fetched
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //TODO:: Varibale decl end....

  List<ViewAndGenerateBillingModel> _getFilteredData(
      List<ViewAndGenerateBillingModel> allData) {
    return allData.where((item) {
      // 1. Apply search filter
      final searchMatch = _searchController.text.isEmpty ||
          item.applicantName!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          item.lastName!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          item.process!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          item.companyName!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      // 2. Apply date filter
      final dateMatch = selectedMonthAndYear == null ||
          (item.doj != null &&
              DateFormat("dd-MM-yyyy").parse(item.doj!).month ==
                  selectedMonthAndYear! % 100 &&
              DateFormat("dd-MM-yyyy").parse(item.doj!).year ==
                  selectedMonthAndYear! ~/ 100);

      // Only include items that match BOTH filters
      return searchMatch && dateMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var fetchBillingData = ref.watch(fetchAllBillingDataProvider);

    return fetchBillingData != null
        ? fetchBillingData.when(
            data: (fetchData) {
              if (fetchData.isNotEmpty && _firstDojDate == null) {
                final firstItemWithDoj = fetchData.firstWhere(
                  (item) => item.doj != null,
                  orElse: () => fetchData.first,
                );

                if (firstItemWithDoj.doj != null) {
                  _firstDojDate =
                      DateFormat("dd-MM-yyyy").parse(firstItemWithDoj.doj!);
                  selectedMonthAndYear =
                      (_firstDojDate!.year * 100) + _firstDojDate!.month;
                }
              }

              final filteredData = _getFilteredData(fetchData);
              // Get unique statuses
              final visibleStatuses = filteredData
                  .map((e) => e.attrStatus ?? '')
                  .where((status) => status.isNotEmpty)
                  .toSet()
                  .toList();

              if (_tabController.length != visibleStatuses.length) {
                final newIndex = _tabController.index >= visibleStatuses.length
                    ? visibleStatuses.length - 1
                    : _tabController.index;

                _tabController = TabController(
                  length: visibleStatuses.length,
                  vsync: this,
                  initialIndex: visibleStatuses.isNotEmpty
                      ? newIndex.clamp(0, visibleStatuses.length - 1)
                      : 0,
                );
              }

              return Scaffold(
                backgroundColor: Colors.white,
                bottomNavigationBar:
                    selectedMonthAndYear != null && visibleStatuses.isNotEmpty
                        ? buildBottomNavigationBar(filteredData)
                        : null,
                appBar: AppBar(
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Constants.black),
                    titleSpacing: 0.0,
                    backgroundColor: Constants.borderColor,
                    title: Row(
                      //  mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: CustomTextFieldforAll(
                            onChanged: (value) => setState(() {}),
                            isSearch: true,
                            isSearchBar: true,
                            controller: _searchController,
                            hint: "Search",
                            focusNode: focusNode,
                          ),
                        ),
                        filteredData.isNotEmpty
                            ? buildMonthAndYearSelector(fetchData)
                            : const SizedBox(),
                      ],
                    )),
                body: visibleStatuses.isEmpty
                    ? const Center(
                        child: customTextForWeather(
                          title: "No Data Found",
                          fontSize: 16,
                        ),
                      )
                    : DefaultTabController(
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
                                    .where((item) => item.attrStatus == status)
                                    .where((item) =>
                                        selectedMonthAndYear == null ||
                                        (item.doj != null &&
                                            DateFormat("dd-MM-yyyy")
                                                    .parse(item.doj!)
                                                    .month ==
                                                selectedMonthAndYear! % 100 &&
                                            DateFormat("dd-MM-yyyy")
                                                    .parse(item.doj!)
                                                    .year ==
                                                selectedMonthAndYear! ~/ 100))
                                    .toList();
                                return buildFilteredListView(
                                    statusFilteredData);
                              }).toList(),
                            ))
                          ],
                        )),
              );
            },
            error: (error, stackTrace) => const Scaffold(
              body: Center(
                child: Text("Error loading data"),
              ),
            ),
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Image.asset("assets/images/nodata.jpg"),
            ),
          );
  }

  //TODO:: Function Decl..

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
            DateFormat("dd-MM-yyyy").parse(item.doj.toString()).month ==
                    selectedMonthAndYear! % 100 &&
                DateFormat("dd-MM-yyyy").parse(item.doj.toString()).year ==
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
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: additionalFilteredData.length,
      itemBuilder: (context, index) {
        final billingData = additionalFilteredData[index];
        return Column(
          children: [
            CustomCard(billingData),
            if (index != additionalFilteredData.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  //height: 0,
                  thickness: 1.0,
                ),
              ),
          ],
        );
      },
    );
  }

  Container CustomCard(ViewAndGenerateBillingModel filteredData) {
    String formattedAmount = filteredData.partnerPayout != null
        ? filteredData.partnerPayout!
            .toStringAsFixed(0)
            .replaceAll(RegExp(r'(\.0|(?<=\.\d)0+)$'), '')
        : "";

    DateTime dateTime =
        DateFormat("dd-MM-yyyy").parse(filteredData.doj.toString());
    String formattedDate = DateFormat("dd MMM yyyy").format(dateTime);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Container(
              child: CircleAvatar(
                backgroundColor: Constants.borderColor,
                backgroundImage: (filteredData.applicantName == "null" &&
                        filteredData.applicantName!.trim().isNotEmpty)
                    ? NetworkImage(
                        "${GlobalConstants.Image_url}${filteredData.applicantName}",
                      )
                    : (filteredData.applicantName == "null")
                        ? AssetImage(
                            filteredData.applicantName == "Female"
                                ? "assets/images/leadfemal.png"
                                : filteredData.applicantName == "Male"
                                    ? "assets/images/leadmale.png"
                                    : "assets/images/user.png", // fallback
                          )
                        : null as ImageProvider<Object>?,
                child: (filteredData.applicantName != null ||
                            filteredData.applicantName!.trim().isNotEmpty) &&
                        (filteredData.applicantName != null ||
                            filteredData.applicantName!.trim().isEmpty)
                    ? customText(
                        title: filteredData.applicantName != null &&
                                filteredData.applicantName != ""
                            ? filteredData.applicantName
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                ''
                            : "Jc",
                        color: Constants.subtitleclr,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )
                    : null,
              ),
            ),
            title: customTextForWeather(
              title: filteredData.applicantName.toString(),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: customTextForWeather(
              title:
                  "${filteredData.process.toString()} || ${filteredData.process.toString()}",
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 6, bottom: 6, right: 8, left: 8),
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconTitleButton(
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/128/17593/17593863.png",
                  onTap: () {},
                  title: filteredData.companyName.toString(),
                ),
                CustomIconTitleButton(
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/128/16774/16774139.png",
                  onTap: () {},
                  title: DateFormat('d MMM yyyy').format(
                      DateFormat('dd-MM-yyyy')
                          .parse(filteredData.doj.toString())),
                ),
                CustomIconTitleButton(
                    height: 20.0,
                    width: 25.0,
                    imageUrl:
                        "https://cdn-icons-png.flaticon.com/128/9798/9798241.png",
                    onTap: () {},
                    title: formattedAmount)
              ],
            ),
          ),
          CustomRemarkConatiner(
              subtitle: filteredData.companyName.toString(),
              valueColor: Constants.subtitleclr,
              title: "Remark")
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar(List<ViewAndGenerateBillingModel> fetchData) {
    // Calculate total payable amount
    double totalAmount = fetchData
        .where((item) => item.attrStatus?.toLowerCase() == 'payable')
        .fold(0.0, (sum, item) => sum + (item.partnerPayout ?? 0));

    // Format the amount with Indian Rupee symbol and comma separators
    String formattedAmount = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(totalAmount);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                formattedAmount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Invoice()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Create Invoice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
            ? (DateFormat("dd-MM-yyyy").parse(item.doj!).year * 100 +
                DateFormat("dd-MM-yyyy").parse(item.doj!).month)
            : 0)
        .toSet()
      ..remove(0); // remove default 0 if any

    return GestureDetector(
      onTap: () =>
          _showMonthFilterBottomSheet(context, uniqueMonthsAndYears.toList()),
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/128/7602/7602631.png",
              height: 15,
              width: 15,
            ),
            const SizedBox(
              width: 4,
            ),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextForWeather(
                    title: "Filter by Month",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Constants.darkBlue,
                  ),
                  /*  InkWell(
                    onTap: () {
                      setState(() {
                        selectedMonthAndYear = null;
                      });
                      Navigator.pop(context);
                    },
                    child: const customText(
                      title: "Clear all",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Constants.orange,
                    ),
                  ), */
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

  //TODO:: Function dec end
}
