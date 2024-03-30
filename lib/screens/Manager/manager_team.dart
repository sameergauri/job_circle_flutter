// ignore_for_file: unnecessary_null_comparison, unused_field, unused_local_variable, depend_on_referenced_packages, avoid_print, use_full_hex_values_for_flutter_colors
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/custom_dialogue_for_team.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/cc_team_data_model.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

final fetchAllTeamData = FutureProvider<List<CCTeamModel>>((
  ref,
) {
  Future.delayed(const Duration(seconds: 2));
  return _ManagerMyTeamState.fetchAllTeamFunction();
});

class ManagerMyTeam extends ConsumerStatefulWidget {
  const ManagerMyTeam({super.key});

  @override
  ConsumerState<ManagerMyTeam> createState() => _ManagerMyTeamState();
}

class _ManagerMyTeamState extends ConsumerState<ManagerMyTeam> {
  // TODO :: data fetch apifunction to fetch team data.

  //
  //
  //
  //
  //
  static Future<List<CCTeamModel>> fetchAllTeamFunction() async {
    SharedPreferences pref = await Utils.getSharedPreferences();
    var userid =
        await Utils.getPreferencesValue(pref, ESharedPreferences.user_id.name);

    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllTeamDataByManagerId?userId=$userid&pageNumber=1&pageSize=100');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        List<CCTeamModel> applicants =
            contentList.map((json) => CCTeamModel.fromJson(json)).toList();

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

  late DataSource _leadsDataSource;

  FocusNode searchNode = FocusNode();

  final TextEditingController _searchController = TextEditingController();

  final List<String> items = [];
  String? selectedItem = "All";
  String? selectedCompany = "All";
  String? selectedMonth = "All";

  int? selectedMonthAndYear;

  List<String?> selectedCompanies =
      []; //TODO:: list to store selected company from filter.
  List<String?> selectedStatus =
      []; //TODO:: list to store selected status from filter.

  //
  Widget buildMonthAndYearSelector(List<CCTeamModel> filteredData) {
    Set<int> uniqueMonthsAndYears = filteredData
        .where((element) => element.doj != null)
        .map((item) =>
            (DateTime.parse(item.doj.toString()).year * 100) +
            DateTime.parse(item.doj.toString()).month)
        .toSet();
    return Container(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      height: MediaQuery.of(context).size.height / 28.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade400)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            child: Row(
              children: [
                Text(
                  "All",
                  style: GoogleFonts.varela(),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 15.sp,
                )
              ],
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
  //
  //
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var fetchData = ref.watch(fetchAllTeamData);
    return fetchData != null
        ? fetchData.when(data: (data) {
//
//
//
//
            List<CCTeamModel> leads =
                data //TODO:: Main List which is use to store all data..
                    .where((element) =>
                        element.applicantName!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        element.process!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        element.companyName!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        element.shortCode!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                    .where((item) => (selectedMonthAndYear == null ||
                        item.doj == null &&
                            DateTime.parse(DateTime.now().toString()).month ==
                                selectedMonthAndYear! % 100 &&
                            DateTime.parse(DateTime.now().toString()).year ==
                                selectedMonthAndYear! ~/ 100 ||
                        item.doj != null &&
                            DateTime.parse(item.doj.toString()).month ==
                                selectedMonthAndYear! % 100 &&
                            DateTime.parse(item.doj.toString()).year ==
                                selectedMonthAndYear! ~/ 100))
                    .where(
                        (element) => selectedItem == "All" || element.spoc_name == selectedItem)
                    .where((element) =>
                        selectedCompanies.isEmpty || // Check if no companies are selected
                        selectedCompanies.contains(element.shortCode))
                    .where((element) =>
                        selectedStatus.isEmpty || // Check if no companies are selected
                        selectedStatus.contains(element.hrSubStatus))
                    .toList();
//
//
//
//
            int totalPayout = leads
                .where((lead) =>
                    lead.hrSubStatus == "Join" &&
                    lead.partner_payout != null &&
                    lead.partner_payout != "")
                .map<int>((lead) => lead.partner_payout!.toInt())
                .fold<int>(
                    0, (previousValue, payout) => previousValue + payout);

            int totalPayable = leads
                .where((lead) =>
                    lead.attr_status == "Payable" &&
                    lead.partner_payout != null &&
                    lead.partner_payout != "")
                .map<int>((lead) => lead.partner_payout!.toInt())
                .fold<int>(
                    0, (previousValue, payout) => previousValue + payout);

            /* List<String?> MonthList =
                data //TODO:: List of all company in data as per selected source.
                    .where((element) =>
                        selectedItem == "All" ||
                        element.doj!.month ==
                            int.tryParse(selectedMonth.toString()))
                    .map((e) => e.doj != null
                        ? DateFormat("MMMM yy").format(e.doj!)
                        : "")
                    .toSet()
                    .toList(); */
//
//
//
//

            List<String?> items =
                data //TODO:: List of all source_name and freelancer_name
                    .map((element) => [
                          element.spoc_name != null && element.spoc_name != ""
                              ? element.spoc_name
                              : "All",
                        ]) // Map both sourceName and refername
                    .expand((element) => element) // Flatten the list of lists
                    .toSet()
                    .toList();
//
//
//
//
            List<String?> companyList =
                data //TODO:: List of all company in data as per selected source.
                    .where((element) =>
                        selectedItem == "All" ||
                        element.sourceName == selectedItem ||
                        element.referralSource == selectedItem)
                    .map((e) => e.shortCode)
                    .toSet()
                    .toList();
//
//
//
//
            List<String?> statusList =
                data //TODO:: List of all status in data as per selected source.
                    .where((element) =>
                        selectedItem == "All" ||
                        element.sourceName == selectedItem ||
                        element.referralSource == selectedItem)
                    .map((e) => e.hrSubStatus)
                    .toSet()
                    .toList();
//
//
//
//
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                      const Size(double.maxFinite, kTextTabBarHeight),
                  child: AppBar(
                    title: Row(
                      children: [
                        customSearchField(context),
                        buildMonthAndYearSelector(data)
                        /*   DropdownButton<String>(
                              style: GoogleFonts.varela(color: Colors.black),
                              elevation: 0,
                              isDense: false,
                              value: selectedMonth,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMonth = newValue;
                                });
                              },
                              items: [
                                // Default item to display when nothing is selected
                                DropdownMenuItem<String>(
                                  value: "All",
                                  child: Text(
                                    'All',
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Other items
                                ...MonthList.map<DropdownMenuItem<String>>(
                                    (String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value ?? value!,
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                }),
                              ],
                            ) */
                      ],
                    ),
                    elevation: 0,
                    backgroundColor: Constants.bgColorWhite,
                  )),

              /*  floatingActionButton: DraggableFab(
                securityBottom: 0.0,
                child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Icon(
                      Icons.search,
                      size: 30.sp,
                      color: Constants.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearchEnable = !isSearchEnable;
                        _searchController.clear();
                      });
                      if (isSearchEnable) {
                        searchNode.requestFocus();
                      }
                    }),
              ), */
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      /* left: 10.w,
                      right: 10.w, */
                      bottom: 30.h,
                    ),
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerColor: Constants.blue,
                      ),
                      child: SfDataGrid(
                        footerHeight: height / 10,
                        footer: Container(
                            margin: EdgeInsets.only(
                                top: 6.h, left: 10.w, right: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Constants.navyblue)),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Join",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  "Awaiting",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  "Selects",
                                                  style: GoogleFonts.varela(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  " : ${leads.where((element) => element.hrSubStatus == "Ready to Join" || element.hrSubStatus == "" || element.hrSubStatus == null).length} (Rs: $totalPayout)",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  " : ${leads.where((element) => element.hrSubStatus == "Join").length}",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  " : ${leads.length}",
                                                  style: GoogleFonts.varela(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "OfferDecline",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  "Not Join",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  "Training DropOut",
                                                  style: GoogleFonts.varela(),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  " : ${leads.where((element) => element.hrSubStatus == "Offer Decline").length}",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  " : ${leads.where((element) => element.hrSubStatus == "Not Join").length}",
                                                  style: GoogleFonts.varela(),
                                                ),
                                                Text(
                                                  " : ${leads.where((element) => element.hrSubStatus == "Training Dropout").length}",
                                                  style: GoogleFonts.varela(),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payable : ${leads.where((element) => element.attr_status == "Payable").length} (Rs: $totalPayable)",
                                      style: GoogleFonts.varela(
                                          color: Constants.green),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        source: _leadsDataSource = DataSource(leads: leads),
                        selectionMode: SelectionMode.single,
                        //    navigationMode: GridNavigationMode.cell,
                        frozenRowsCount: 0,
                        allowPullToRefresh: true,
                        showHorizontalScrollbar: false,
                        horizontalScrollPhysics:
                            const AlwaysScrollableScrollPhysics(),
                        rowHeight: 35,
                        headerRowHeight: 40,
                        gridLinesVisibility: GridLinesVisibility.none,
                        headerGridLinesVisibility: GridLinesVisibility.none,
                        columnWidthMode: ColumnWidthMode.auto,
                        allowColumnsDragging: true,
                        allowSorting: true,
                        showSortNumbers: true,
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'applicantName',
                            allowSorting: false,
                            allowFiltering: false,
                            // width: 150.w,
                            label: _getTitleItemWidget(
                                label: "Applicant",
                                columnName: "applicantName",
                                compnyList: companyList),
                          ),
                          GridColumn(
                            // width: 100.w,
                            columnName: 'companyName',
                            allowSorting: false,
                            label: _getTitleItemWidget(
                                label: "Company",
                                columnName: "companyName",
                                compnyList:
                                    companyList // Replace 'applicantName' with the actual column name
                                ),
                          ),
                          GridColumn(
                            columnName: 'process',
                            allowSorting: false,
                            label: _getTitleItemWidget(
                                label: "Process",
                                columnName: "process",
                                compnyList:
                                    companyList // Replace 'applicantName' with the actual column name
                                ),
                          ),
                          GridColumn(
                            //width: 100,
                            columnName: 'doj',
                            label: _getTitleItemWidget(
                                label: "DOJ",
                                columnName: "doj",
                                compnyList:
                                    companyList // Replace 'applicantName' with the actual column name
                                ),
                          ),
                          GridColumn(
                            columnName: 'status',
                            // width: 150,
                            allowSorting: false,
                            label: _getTitleItemWidget(
                                label: "Status",
                                columnName: "status",
                                compnyList:
                                    statusList // Replace 'applicantName' with the actual column name
                                ),
                          ),
                          GridColumn(
                            columnName: 'attrStatus',
                            // width: 150,
                            allowSorting: false,
                            label: _getTitleItemWidget(
                                label: "Attration Status",
                                columnName: "attrStatus",
                                compnyList:
                                    companyList // Replace 'applicantName' with the actual column name
                                ),
                          ),
                          GridColumn(
                            columnName: 'payout',
                            // width: 150,
                            allowSorting: false,
                            label: _getTitleItemWidget(
                                label: "PayOut",
                                columnName: "payout",
                                compnyList:
                                    companyList // Replace 'applicantName' with the actual column name
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      left: 20,
                      bottom: 0,
                      child: DropdownButton<String>(
                        style: GoogleFonts.varela(color: Colors.black),
                        elevation: 0,
                        isDense: false,
                        value: selectedItem,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedItem = newValue;
                          });
                        },
                        items: [
                          // Default item to display when nothing is selected
                          DropdownMenuItem<String>(
                            value: "All",
                            child: Text(
                              'All',
                              style: GoogleFonts.varela(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Other items
                          ...items
                              .map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value ?? value!,
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.normal),
                              ),
                            );
                          }),
                        ],
                      ))
                ],
              ), /* ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].hr_status.toString() ??
                        data[index].s2HrStatus.toString()),
                  );
                },
              ), */
            );
          }, error: (error, stackTrace) {
            return const Scaffold(
              body: Center(
                child: Text("Error while fetching the data"),
              ),
            );
          }, loading: () {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          })
        : Scaffold(
            body: Center(
              child: Image.asset("assets/images/nodata.png"),
            ),
          );
  }

//
//
//
//
//
//
  //TODO:: Custom Function
  //
  //
  //
  //
  //
  //
  //
  //
  //

  _showCompanySelectionDialog(List<String?> compnyList) async {
    //TODO :: filter dialogue for company filter
    List<String?>? result = await showDialog<List<String?>>(
      context: context,
      builder: (context) {
        return CompanySelectionDialogForFilter(
          compnyList: compnyList,
          selectedCompanies: selectedCompanies,
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCompanies = result;
      });
    }
  }

  _showProcessSelectiondialog(List<String?> statusList) async {
    //TODO :: filter dialogue for status filter
    List<String?>? result = await showDialog<List<String?>>(
      context: context,
      builder: (context) {
        return CustomDialogueForStatusTeam(
          statusList: statusList,
          selectedStatusList: selectedStatus,
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedStatus = result;
      });
    }
  }

  Widget _getTitleItemWidget(
      {required label,
      required columnName,
      required List<String?> compnyList}) {
    return GestureDetector(
      onTap: () {
        if (columnName == "companyName") {
          _showCompanySelectionDialog(compnyList);
        } else if (columnName == "status") {
          _showProcessSelectiondialog(compnyList);
        }
      },
      child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.transparent,
                width: 0.5,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          height: 30,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: columnName == "companyName"
              ? Text(
                  selectedCompanies.isNotEmpty ? "$label ▼" : label,
                  style: GoogleFonts.varela(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                )
              : columnName == "status"
                  ? Text(
                      selectedStatus.isNotEmpty ? "$label ▼" : label,
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    )),
    );
  }

  Widget customSearchField(BuildContext context) {
    return Expanded(
      child: SizedBox(
        // margin: EdgeInsets.only(top: 10.h),
        height: MediaQuery.of(context).size.height / 26.h,
        //width: MediaQuery.of(context).size.width / 2.w,
        child: TextField(
          focusNode: searchNode,
          keyboardType: TextInputType.name,
          //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
          textCapitalization: TextCapitalization.sentences,
          controller: _searchController,
          style:
              GoogleFonts.varela(color: Constants.subtitleclr, fontSize: 14.sp),
          cursorColor: Colors.grey.shade600,
          decoration: InputDecoration(
              filled: false,
              fillColor: Constants.borderColor,
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.grey.shade400,
              contentPadding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              counterText: '',
              // labelText: "Remark",
              labelStyle: const TextStyle(
                color: Constants.themeBgColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusColor: const Color(0xffff0eceb),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              hintText: "Search",
              hintStyle: GoogleFonts.sourceSansPro(
                  color: Constants.hintColor, fontSize: 15.sp)),
          onSubmitted: (value) {},
          onChanged: (value) {
            // setState(() {});
            _searchController.text.isEmpty ? setState(() {}) : setState(() {});
          },
        ),
      ),
    );
  }
}

class DataSource extends DataGridSource {
  final BuildContext? context;
  List<CCTeamModel> leads;
  DataSource({required this.leads, this.context}) {
    dataGridRows = leads.map<DataGridRow>((dataGridRow) {
      String fullName = '${dataGridRow.applicantName} ${dataGridRow.lastName}';
      DateTime? doj = dataGridRow.doj;
      String formattedDate = doj != null
          ? DateFormat('dd MMM yy').format(doj)
          : dataGridRow.hrSubStatus == "Join" ||
                  dataGridRow.hrSubStatus == null ||
                  dataGridRow.hrSubStatus == "Ready to Join"
              ? "Pending"
              : "NA";
      String status =
          dataGridRow.hrSubStatus != null && dataGridRow.hrSubStatus != ""
              ? dataGridRow.hrSubStatus.toString()
              : "Select";
      String attStatus = dataGridRow.attr_status.toString();
      String payout =
          dataGridRow.partner_payout != null && dataGridRow.partner_payout != ""
              ? dataGridRow.partner_payout!.toStringAsFixed(0)
              : "Pending";
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'applicantName', value: fullName),
        DataGridCell<String>(
            columnName: 'companyName', value: dataGridRow.shortCode),
        DataGridCell<String>(columnName: 'process', value: dataGridRow.process),
        DataGridCell<String>(columnName: 'doj', value: formattedDate),
        DataGridCell<String>(columnName: 'status', value: status),
        DataGridCell<String>(columnName: 'attrStatus', value: attStatus),
        DataGridCell<String>(columnName: 'Payout', value: payout),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

//final id = leads.map((e) => e.rid!=null&&e.rid!=0).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'doj') {
          String? doj = dataGridCell.value as String?;

          return GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                doj ?? ' - ',
                style: GoogleFonts.varela(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }
        if (dataGridCell.columnName == 'status') {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              dataGridCell.value.toString(),
              style: GoogleFonts.varela(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        } else if (dataGridCell.columnName == "applicantName") {
          return Container(
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_2_outlined,
                  size: 15.sp,
                ),
                Text(
                  dataGridCell.value.toString(),
                  style: GoogleFonts.varela(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              dataGridCell.value.toString(),
              style: GoogleFonts.varela(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  String extractInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String initials = '';

    for (var i = 0; i < nameParts.length; i++) {
      String part = nameParts[i];
      if (part.isNotEmpty) {
        initials += i == 0
            ? part
            : ' ${i == nameParts.length - 1 ? part[0] : '${part[0]} '}';
      }
    }

    return initials;
  }
}
