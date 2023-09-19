import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/gobal.dart';
import '../../../models/job_details_model.dart';
import '../../../models/profileSummary.dart';
import '../../../themes/colors.dart';
import '../../models/my_team_model.dart';
import 'my_team_detail.dart';

class LeadsTable extends StatefulWidget {
  final int id;
  const LeadsTable({Key? key, required this.id}) : super(key: key);

  @override
  State<LeadsTable> createState() => _LeadsTableState();
}

class _LeadsTableState extends State<LeadsTable> with TickerProviderStateMixin {
  JobDetailsModel jobDetailsModel = JobDetailsModel();
  ProfileSummaryModel profilemodel = ProfileSummaryModel();
  final TextEditingController _searchController = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController process = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController subStatus = TextEditingController();
  TextEditingController joiningStatus = TextEditingController();

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  List<Applicant> allLeadsData = [];
  List<Applicant> filteredLeadsData = [];
  late Applicant leadsData;
  late ReportTo reportTo;

  List<String> selectedOptions = [];
  List<String> selectedSpoc = [];
  List<ReportTo> allReportTo = [];

  List<DateTime?> dojList = [];

  DateTime tomorrowDate = DateTime.now().add(const Duration(days: 1));
  String todayDate = DateFormat('dd MMM yyyy').format(DateTime.now());

  bool isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();
  int? columnIdx = 0;

  DateTime? selectedDolFrom;
  DateTime? selectedDolTo;

  String selectedCompanyName = '';
  AnimationController? _animationController;
  List<String> formattedDojList = [];

  Set<String> selectedDateOptions = {};
  List<String> dateOptions = [];
  final int _currentPage = 1;
  final int _pageSize = 30000;

  List<dynamic> reportToList = [];

  @override
  void initState() {
    super.initState();
    fetchAllLeadDetails().then((_) {
      filteredLeadsData = allLeadsData;

      _searchController.addListener(_searchData);
      setState(() {});
      // dateOptions = generateDateOptions(formattedDojList);
      // if (dateOptions.isNotEmpty) {
      //   selectedDateOptions.add(dateOptions[0]);
      // }
    });
    fetchReportTo();

    _horizontalController.addListener(() {
      _verticalController.jumpTo(_horizontalController.position.pixels);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _searchData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredLeadsData = allLeadsData.where((lead) {
        final applicantNameMatch =
            lead.applicantName!.toLowerCase().contains(query);
        return applicantNameMatch;
      }).toList();
    });
  }

  // void _filterLeadsData() {
  //   setState(() {
  //     filteredLeadsData = allLeadsData.where((lead) {
  //       final isDolInRange =
  //           (selectedDolFrom == null || selectedDolTo == null) ||
  //               (lead.dol != null &&
  //                   lead.dol!.isAfter(selectedDolFrom!) &&
  //                   lead.dol!
  //                       .isBefore(selectedDolTo!.add(const Duration(days: 1))));

  //       return (lead.dol != null) && isDolInRange;
  //     }).toList();
  //   });
  // }

  Future<void> fetchAllLeadDetails() async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobs?userId1=${widget.id}&userId2=${widget.id}&page=1&size=300');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        List<Applicant> applicants =
            contentList.map((json) => Applicant.fromJson(json)).toList();

        List<Applicant> filteredApplicants = [];

        for (int i = 0; i < applicants.length; i++) {
          DateTime currentDateTime = DateTime.now();

          DateTime? doj;
          if (applicants[i].doj != null && applicants[i].doj!.isNotEmpty) {
            try {
              doj = DateTime.parse(applicants[i].doj!);
            } catch (e) {
              print('Invalid date format for doj: ${applicants[i].doj}');
              continue;
            }
          }

          DateTime? dol;
          if (applicants[i].dol != null && applicants[i].dol!.isNotEmpty) {
            try {
              dol = DateTime.parse(applicants[i].dol!);
            } catch (e) {
              print('Invalid date format for dol: ${applicants[i].dol}');
              continue; // Skip this applicant if date parsing fails
            }
          }

          DateTime lastMonthDateTime =
              DateTime(currentDateTime.year, currentDateTime.month - 1, 1);
          DateTime nextMonthDateTime =
              DateTime(currentDateTime.year, currentDateTime.month + 1, 1);

          if ((dol?.month == currentDateTime.month &&
                  doj?.month == currentDateTime.month) ||
              (doj?.month == currentDateTime.month &&
                  dol?.month == lastMonthDateTime.month) ||
              (applicants[i].status == 'Select' && doj == null) ||
              (dol?.month == currentDateTime.month &&
                  doj?.month == nextMonthDateTime.month) ||
              (applicants[i].status == 'In-Process' ||
                  applicants[i].status == 'New')) {
            filteredApplicants.add(applicants[i]);
          }
        }

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].status == 'Select' &&
              filteredApplicants[i].doj == null) {
            filteredApplicants[i].doj = 'Pending';
          } else if (filteredApplicants[i].doj != null) {
            DateTime doj = DateTime.parse(filteredApplicants[i].doj.toString());
            String formattedDoj = DateFormat('dd MMM yyyy').format(doj);
            filteredApplicants[i].doj = formattedDoj;
            // ignore: unrelated_type_equality_checks
          } else if (filteredApplicants[i].doj ==
              DateTime.now().add(const Duration(days: 1)).day) {
            filteredApplicants[i].doj = 'Tomorrow';
            // ignore: unrelated_type_equality_checks
          } else if (filteredApplicants[i].doj == DateTime.now().day) {
            filteredApplicants[i].doj = 'Today';
          } else if (filteredApplicants[i].doj == null) {
            filteredApplicants[i].doj = ' - ';
          }
        }

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].document_status == 'Schedule F2F') {
            filteredApplicants[i].document_status = 'Schd F2F';
          }
        }

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].status == 'In-Process') {
            filteredApplicants[i].status = 'Interview Schd';
          }
        }

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Shortlist') {
            filteredApplicants[i].sub_status = null;
          }
        }
        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Virtual Interview') {
            filteredApplicants[i].sub_status = "Virtual";
          }
        }

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Confirmation Pending') {
            filteredApplicants[i].sub_status = "Pending";
          }
        }

        setState(() {
          allLeadsData = filteredApplicants;
          dojList = formattedDojList.cast<DateTime?>();
        });
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching data: $e');
    }
  }

  Future<void> fetchReportTo() async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/allReportTo?page=1&size=100000');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        List<ReportTo> reportto =
            contentList.map((json) => ReportTo.fromJson(json)).toList();

        setState(() {
          allReportTo = reportto;
        });
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching data: $e');
    }
  }

  bool isDropdownOpen = false;
  bool isValueSelected = false;
  String? selectedSpocValue;
  @override
  void dispose() {
    _searchController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _searchFocusNode.requestFocus(),
      onDoubleTap: () {
        if (isSearchVisible) {
          setState(() {
            isSearchVisible = false;
            _animationController!.reverse();
            _searchFocusNode.unfocus();
          });
        }
      },
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            _showSpocListDialog();
          },
          child: Text(
            'ALL',
            style: GoogleFonts.varela(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(70, 30),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: isSearchVisible
            ? AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchFocusNode.requestFocus();
                          });
                        },
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: isSearchVisible ? 1.0 : 0.0,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-1, 0),
                              end: const Offset(0, 0),
                            ).animate(CurvedAnimation(
                              parent: _animationController!,
                              curve: Curves.easeInOut,
                            )),
                            child: SizedBox(
                              height: 35,
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                style: GoogleFonts.varela(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Constants.themeBgColorLight,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(
                                    // bottom: 0,
                                    left: 5,
                                    top: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  hintText:
                                      "${allLeadsData.first.applicantName} "
                                      "${allLeadsData.first.last_name}",
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSearchVisible = false;
                                        _animationController?.reverse();
                                        // _searchFocusNode.unfocus();
                                        filteredLeadsData = allLeadsData;
                                        _searchController.clear();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.search,
                                      size: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const PreferredSize(child: SizedBox(), preferredSize: Size(0, 0)),
        body: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 15,
            top: !isSearchVisible ? kToolbarHeight / 1.5 : 0,
          ),
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: const Color.fromARGB(255, 163, 235, 229),
              filterIconColor: const Color.fromARGB(255, 39, 27, 31),
            ),
            child: SfDataGrid(
              source: DataSource(leads: filteredLeadsData, context: context),
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.cell,
              frozenRowsCount: 0,
              allowPullToRefresh: true,
              rowHeight: 35,
              headerRowHeight: 40,
              gridLinesVisibility: GridLinesVisibility.none,
              headerGridLinesVisibility: GridLinesVisibility.none,
              columnWidthMode: ColumnWidthMode.auto,
              allowColumnsDragging: true,
              allowSorting: true,
              allowFiltering: true,
              showSortNumbers: true,
              columns: <GridColumn>[
                GridColumn(
                  columnName: 'applicantName',
                  allowSorting: false,
                  allowFiltering: false,
                  width: 180,
                  label: _getTitleItemWidget(
                    'Applicant Name',
                    false,
                  ),
                ),
                GridColumn(
                  width: 110,
                  columnName: 'companyName',
                  filterPopupMenuOptions: const FilterPopupMenuOptions(
                      canShowSortingOptions: false,
                      canShowClearFilterOption: false,
                      filterMode: FilterMode.checkboxFilter),
                  allowSorting: false,
                  label: Container(
                    child: Text(
                      'Company',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'process',
                  allowSorting: false,
                  label: Container(
                    child: Text(
                      'Process',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  filterPopupMenuOptions: const FilterPopupMenuOptions(
                      canShowSortingOptions: false,
                      canShowClearFilterOption: false,
                      filterMode: FilterMode.checkboxFilter),
                ),
                GridColumn(
                  columnName: 'status',
                  width: 150,
                  allowSorting: false,
                  label: Container(
                    child: Text(
                      'Status',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  filterPopupMenuOptions: const FilterPopupMenuOptions(
                      canShowSortingOptions: false,
                      canShowClearFilterOption: false,
                      filterMode: FilterMode.checkboxFilter),
                ),
                GridColumn(
                    width: 100,
                    columnName: 'doj',
                    label: Text(
                      'DOJ',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    filterPopupMenuOptions: const FilterPopupMenuOptions(
                        canShowSortingOptions: false,
                        canShowClearFilterOption: false,
                        filterMode: FilterMode.checkboxFilter),
                    sortIconPosition: ColumnHeaderIconPosition.start),
                GridColumn(
                  columnName: 'sub_status',
                  // width: 90,
                  allowSorting: false,
                  label: Container(
                    child: Text(
                      'Sub Status',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  filterPopupMenuOptions: const FilterPopupMenuOptions(
                      canShowSortingOptions: false,
                      canShowClearFilterOption: false,
                      filterMode: FilterMode.checkboxFilter),
                ),
                GridColumn(
                  width: 120,
                  columnName: 'doc_status',
                  allowSorting: false,
                  label: Container(
                    child: Text(
                      'Doc Status',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  filterPopupMenuOptions: const FilterPopupMenuOptions(
                      canShowSortingOptions: false,
                      canShowClearFilterOption: false,
                      filterMode: FilterMode.checkboxFilter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTitleItemWidget(String label, bool isLastTitle) {
    Widget titleWidget(String label) {
      if (label == 'Applicant Name') {
        return Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (!isSearchVisible) {
                    setState(() {
                      isSearchVisible = true;
                      _animationController?.forward();
                      _searchFocusNode.requestFocus();
                    });
                  }
                },
                child: Visibility(
                  visible: !isSearchVisible,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  label,
                  style: GoogleFonts.varela(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Text(
          label,
          style: GoogleFonts.varela(fontWeight: FontWeight.bold, fontSize: 13),
        );
      }
    }

    return Container(
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
      child: titleWidget(label),
      height: 30,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  void _showSpocListDialog() {
    List<String> filteredSpocNames = [];

    for (int i = 0; i < allLeadsData.length; i++) {
      int currentSpocId = allLeadsData[i].spoc ?? 0;
      int currentReportTo = allLeadsData[i].reportTo ?? 0;
      int sourceId = allLeadsData[i].sourceId ?? 0;

      if (currentSpocId == 2 && sourceId == 2) {
        filteredSpocNames.add(allLeadsData[i].source_name.toString());
      } else if (currentReportTo == 2) {
        filteredSpocNames.add(allLeadsData[i].source_name.toString());
      }
    }

    // Add "Other" to the end of the list
    filteredSpocNames.add('Other');

    List<String> uniqueFilteredSpocNames = filteredSpocNames.toSet().toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select a Source',
            style: GoogleFonts.varela(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: uniqueFilteredSpocNames
                          .map((spoc) => Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedSpoc.contains(spoc)) {
                                        selectedSpoc.remove(spoc);
                                      } else {
                                        selectedSpoc.add(spoc);
                                      }
                                      if (selectedSpoc.isEmpty) {
                                        filteredLeadsData = allLeadsData;
                                      } else {
                                        _applySpocFilter(selectedSpoc);
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(spoc),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: _submitButton,
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _submitButton() {
    if (selectedOptions.isEmpty) {
      setState(() {
        selectedSpoc.clear();

        filteredLeadsData = allLeadsData;
      });
    }
    // Navigator.pop(context);
  }

  void _applySpocFilter(List<String> selectedSpoc) {
    setState(() {
      if (selectedSpoc.contains('Other')) {
        filteredLeadsData = allLeadsData
            .where((lead) =>
                (lead.source_name ?? '') != '' &&
                lead.reportTo != 2 &&
                lead.sourceId != 2)
            .toList();
      } else {
        filteredLeadsData = allLeadsData
            .where((lead) => selectedSpoc.contains(lead.source_name ?? ''))
            .toList();
      }
    });
  }
}

class DataSource extends DataGridSource {
  final BuildContext context;
  List<Applicant> leads;
  DataSource({required this.leads, required this.context}) {
    dataGridRows = leads.map<DataGridRow>((dataGridRow) {
      String fullName = '${dataGridRow.applicantName} ${dataGridRow.last_name}';
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'applicantName', value: fullName),
        DataGridCell<String>(
            columnName: 'companyName', value: dataGridRow.short_name),
        DataGridCell<String>(columnName: 'process', value: dataGridRow.process),
        DataGridCell<String>(columnName: 'status', value: dataGridRow.status),
        DataGridCell<String>(columnName: 'doj', value: dataGridRow.doj),
        DataGridCell<String>(
            columnName: 'sub_status', value: dataGridRow.sub_status),
        DataGridCell<String>(
            columnName: 'doc_status', value: dataGridRow.document_status),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'doj') {
          String? doj = dataGridCell.value as String?;

          return InkWell(
            onDoubleTap: () {
              int rowIndex = dataGridRows.indexOf(row);

              if (rowIndex >= 0 && rowIndex < leads.length) {
                Applicant clickedLead = leads[rowIndex];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                );
              }
            },
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

        if (dataGridCell.columnName == 'sub_status') {
          String? subStatus = dataGridCell.value.toString();
          return InkWell(
            onDoubleTap: () {
              int rowIndex = dataGridRows.indexOf(row);

              if (rowIndex >= 0 && rowIndex < leads.length) {
                Applicant clickedLead = leads[rowIndex];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Text(
                (subStatus == 'null') ? ' - ' : subStatus,
                // Handle null case
                style: GoogleFonts.varela(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }

        if (dataGridCell.columnName == 'doc_status') {
          String doc = dataGridCell.value.toString();

          return InkWell(
            onDoubleTap: () {
              int rowIndex = dataGridRows.indexOf(row);

              if (rowIndex >= 0 && rowIndex < leads.length) {
                Applicant clickedLead = leads[rowIndex];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Text(
                doc == 'null' ? ' - ' : doc,
                style: GoogleFonts.varela(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        } else {
          return InkWell(
            onDoubleTap: () {
              int rowIndex = dataGridRows.indexOf(row);

              if (rowIndex >= 0 && rowIndex < leads.length) {
                Applicant clickedLead = leads[rowIndex];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                );
              }
            },
            child: Container(
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
            : ' ' + (i == nameParts.length - 1 ? part[0] : part[0] + ' ');
      }
    }

    return initials;
  }
}
