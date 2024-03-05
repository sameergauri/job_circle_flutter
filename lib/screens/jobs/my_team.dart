// ignore_for_file: unused_field, unused_local_variable, depend_on_referenced_packages, avoid_print, use_full_hex_values_for_flutter_colors, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/gobal.dart';
import '../../../models/job_details_model.dart';
import '../../../models/profileSummary.dart';
import '../../../themes/colors.dart';
import '../../models/my_team_model.dart';

class LeadsTable extends StatefulWidget {
  const LeadsTable({super.key});

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
  List<Applicant> filteredData = [];
  String selectedName = '';
  Map<String, List<String>> filterValues = {};

  late Applicant leadsData;
  late ReportTo reportTo;

  List<String> selectedOptions = [];
  List<String> selectedSpoc = [];
  List<ReportTo> allReportTo = [];

  late DataSource _leadsDataSource;

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
      filteredData = filteredLeadsData;

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
    SharedPreferences pref = await Utils.getSharedPreferences();
    var userid =
        await Utils.getPreferencesValue(pref, ESharedPreferences.user_id.name);

    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllLeadsBySourceId?sourceId=$userid&page=1&size=1000');
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

          DateTime nextSixMonthDateTime =
              DateTime(currentDateTime.year, currentDateTime.month + 6, 6);

          if ((doj?.month == currentDateTime.month ||
                  doj?.month == nextSixMonthDateTime.month ||
                  dol?.month == currentDateTime.month) ||
              (applicants[i].status == 'Select' && doj == null) ||
              (applicants[i].status == 'Interview Bay' ||
                  applicants[i].status == 'Application')) {
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

        /* for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].status == 'Interview Bay') {
            filteredApplicants[i].status = 'Interview Schd';
          }
        } */

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Interview Bay') {
            filteredApplicants[i].sub_status = null;
          }
        }
        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Interview Bay') {
            filteredApplicants[i].sub_status = "Interview Bay";
          }
        }
        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Interview Bay') {
            filteredApplicants[i].sub_status = "Interview Bay";
          }
        }

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Confirmation Pending') {
            filteredApplicants[i].sub_status = "Pending";
          }
        }
        spocList = filteredApplicants
            .map((lead) => lead.source_name ?? '')
            .toSet()
            .toList()
            .cast<String>();
        spocList.insert(0, 'All');
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

  List<String> spocList = [];
  double calculateOffset() {
    return -(spocList.length * 62.0);
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
        floatingActionButton: PopupMenuButton<String>(
          // offset: Offset(100, 100),
          itemBuilder: (BuildContext context) {
            List<String> filteredSpocNames = [];

            for (int i = 0; i < filteredData.length; i++) {
              int currentSpocId = filteredData[i].spoc ?? 0;
              int currentReportTo = filteredData[i].reportTo ?? 0;
              int sourceId = filteredData[i].sourceId ?? 0;

              if (currentSpocId == 2 && sourceId == 2) {
                filteredSpocNames.add(filteredData[i].source_name.toString());
              } else if (currentReportTo == 2) {
                filteredSpocNames.add(filteredData[i].source_name.toString());
              } else if (filteredData
                  .where((lead) =>
                      (lead.source_name ?? '') != '' &&
                      lead.reportTo != 2 &&
                      lead.sourceId != 2)
                  .isNotEmpty) {
                filteredSpocNames.add('Other');
              }
            }

            filteredSpocNames.insert(0, 'All');

            List<String> uniqueFilteredSpocNames =
                filteredSpocNames.toSet().toList();

            return uniqueFilteredSpocNames.asMap().entries.map((entry) {
              final String round = entry.value;
              final isOddIndex = entry.key % 2 == 1;
              return PopupMenuItem<String>(
                padding: const EdgeInsets.only(left: 8, right: 8),
                value: round,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isOddIndex ? Colors.white : Constants.borderColor,
                  ),
                  child: Center(
                    child: Text(
                      extractInitials(round),
                      style: GoogleFonts.sourceSansPro(
                        color: isOddIndex
                            ? Constants.subtitleclr
                            : Constants.subtitleclr,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
              );
            }).toList();
          },
          onSelected: (selectedRound) {
            setState(() {
              selectedSpoc.clear();
              if (selectedSpoc.contains(selectedRound)) {
                selectedSpoc.remove(selectedRound);
              } else {
                selectedSpoc.add(selectedRound);
              }
              selectedName = selectedRound;

              // Apply the filter based on selectedSpoc
              _applySpocFilter(selectedSpoc);
            });
          },
          child: GestureDetector(
            onTap: null,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6.w),
              decoration: BoxDecoration(
                color: const Color(0xfff729995),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedSpoc.isNotEmpty ? extractInitials(selectedName) : 'All',
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
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
            : const PreferredSize(preferredSize: Size(0, 0), child: SizedBox()),
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
            ),
            child: SfDataGrid(
              source: _leadsDataSource = DataSource(
                leads: filteredData,
              ),
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
                    'applicantName', // Replace 'applicantName' with the actual column name
                  ),
                ),
                GridColumn(
                  width: 110,
                  columnName: 'companyName',
                  allowSorting: false,
                  label: _getTitleItemWidget(
                    'Company',
                    false,
                    'companyName', // Replace 'applicantName' with the actual column name
                  ),
                ),
                GridColumn(
                  columnName: 'process',
                  allowSorting: false,
                  label: _getTitleItemWidget(
                    'Process',
                    false,
                    'process', // Replace 'applicantName' with the actual column name
                  ),
                ),
                GridColumn(
                  columnName: 'status',
                  width: 150,
                  allowSorting: false,
                  label: _getTitleItemWidget(
                    'Status',
                    false,
                    'status', // Replace 'applicantName' with the actual column name
                  ),
                ),
                GridColumn(
                  width: 100,
                  columnName: 'doj',
                  label: _getTitleItemWidget(
                    'DOJ',
                    false,
                    'doj', // Replace 'applicantName' with the actual column name
                  ),
                ),
                GridColumn(
                  columnName: 'sub_status',
                  // width: 90,
                  allowSorting: false,
                  label: _getTitleItemWidget(
                    'Sub Status',
                    false,
                    'sub_status', // Replace 'applicantName' with the actual column name
                  ),
                ),
                GridColumn(
                  width: 120,
                  columnName: 'doc_status',
                  allowSorting: false,
                  label: _getTitleItemWidget(
                    'Doc Status',
                    false,
                    'doc_status', // Replace 'applicantName' with the actual column name
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> getFilterOptions(String columnName) {
    List<String> options = [];

    switch (columnName) {
      case 'applicantName':
        options = getFilteredOptionsForColumn(columnName);
        break;
      case 'companyName':
        options = getFilteredOptionsForColumn(columnName);
        break;
      case 'process':
        options = getFilteredOptionsForColumn(columnName);
        break;
      case 'status':
        options = getFilteredOptionsForColumn(columnName);
        break;
      case 'doj':
        options = getFilteredOptionsForColumn(columnName);
        break;
      case 'sub_status':
        options = getFilteredOptionsForColumn(columnName);
        break;
      case 'doc_status':
        options = getFilteredOptionsForColumn(columnName);
        break;
      default:
        break;
    }

    return options;
  }

  List<String> getFilteredOptionsForColumn(String columnName) {
    List<String> options = [];

    // Assuming allLeadsData is the full list of leads
    List<Applicant> leadsList = filteredLeadsData;

    // Apply filters based on the current filterValues
    for (String appliedColumn in filterValues.keys) {
      if (appliedColumn != columnName) {
        List<String>? selectedOptions = filterValues[appliedColumn];
        if (selectedOptions != null && selectedOptions.isNotEmpty) {
          leadsList = leadsList.where((lead) {
            String? value = _getColumnValue(lead, appliedColumn);
            return value != null && selectedOptions.contains(value);
          }).toList();
        }
      }
    }

    // Get unique options for the target column
    switch (columnName) {
      case 'applicantName':
        options = leadsList
            .where((lead) =>
                lead.applicantName != null && lead.applicantName!.isNotEmpty)
            .map((lead) => lead.applicantName!)
            .toSet()
            .toList();
        break;
      case 'companyName':
        options = leadsList
            .where((lead) =>
                lead.short_name != null && lead.short_name!.isNotEmpty)
            .map((lead) => lead.short_name!)
            .toSet()
            .toList();
        break;
      case 'process':
        options = leadsList
            .where((lead) => lead.process != null && lead.process!.isNotEmpty)
            .map((lead) => lead.process!)
            .toSet()
            .toList();
        break;
      case 'status':
        options = leadsList
            .where((lead) => lead.status != null && lead.status!.isNotEmpty)
            .map((lead) => lead.status!)
            .toSet()
            .toList();
        break;
      case 'doj':
        options = leadsList
            .where((lead) => lead.doj != null && lead.doj!.isNotEmpty)
            .map((lead) => lead.doj!)
            .map((dateString) => dateString
                .replaceAll('-', '')
                .trim()) // Remove hyphens and trim whitespaces
            .where((trimmedDate) =>
                trimmedDate.isNotEmpty) // Filter out empty strings
            .toSet()
            .toList();
        break;
      case 'sub_status':
        options = leadsList
            .where((lead) =>
                lead.sub_status != null && lead.sub_status!.isNotEmpty)
            .map((lead) => lead.sub_status!)
            .toSet()
            .toList();
        break;
      case 'doc_status':
        options = leadsList
            .where((lead) =>
                lead.document_status != null &&
                lead.document_status!.isNotEmpty)
            .map((lead) => lead.document_status!)
            .toSet()
            .toList();
        break;
      default:
        break;
    }

    return options;
  }

  String? _getColumnValue(Applicant lead, String columnName) {
    switch (columnName) {
      case 'applicantName':
        return lead.applicantName;
      case 'companyName':
        return lead.short_name;
      case 'status':
        return lead.status;
      case 'process':
        return lead.process;
      case 'doj':
        return lead.doj;
      case 'sub_status':
        return lead.sub_status;
      case 'doc_status':
        return lead.document_status;
      case 'source_name':
        return lead.source_name;

      default:
        return null;
    }
  }

  bool matchesFilter(
      Applicant lead, String columnName, List<String>? selectedOptions) {
    if (selectedOptions != null && selectedOptions.isNotEmpty) {
      String? value = _getColumnValue(lead, columnName);

      if (value != null) {
        // For String values, check if the selected options match exactly
        return selectedOptions.contains(value);
      } else {
        // Handle other types or add more cases as needed
        return false;
      }
    }

    // If no options selected or value is null, consider it a match
    return true;
  }

  void _applyFilters() {
    setState(() {
      filteredData = filteredLeadsData.where((lead) {
        return filterValues.entries.every((entry) {
          String columnName = entry.key;
          List<String>? selectedOptions = entry.value;

          return matchesFilter(lead, columnName, selectedOptions);
        });
      }).toList();
    });
  }

  void _applySpocFilter(List<String> selectedSpoc) {
    setState(() {
      if (selectedSpoc.contains('Other')) {
        filteredData = filteredLeadsData
            .where((lead) =>
                (lead.source_name ?? '') != '' &&
                lead.reportTo != 2 &&
                lead.sourceId != 2)
            .toList();
      } else if (selectedSpoc.isEmpty || selectedSpoc.contains('All')) {
        // If 'All' is selected or no sources selected, show all data
        filteredData = filteredLeadsData;
      } else {
        filteredData = filteredLeadsData
            .where((lead) => selectedSpoc.contains(lead.source_name ?? ''))
            .toList();
      }
    });
  }

  void _showFilterDialog(String columnName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    filterValues[columnName]?.clear();
                  });
                  Navigator.pop(context);
                  _showFilterDialog(
                      columnName); // Create a new instance of StatefulBuilder
                },
                child: Text(
                  'Clear All',
                  style: GoogleFonts.varela(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Constants.themeBgColor,
                  ),
                ),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              List<String> allOptions = getFilterOptions(columnName);
              List<String> selectedOptions =
                  filterValues[columnName] ?? <String>[];

              List<Widget> optionsWidgets = [];

              for (String option in allOptions) {
                optionsWidgets.add(
                  ListTile(
                    title: Text(option),
                    leading: Checkbox(
                      value: selectedOptions.contains(option),
                      onChanged: (bool? value) {
                        setState(() {
                          if (filterValues[columnName] == null) {
                            filterValues[columnName] = [];
                          }

                          if (value != null) {
                            if (value) {
                              filterValues[columnName]!.add(option);
                            } else {
                              filterValues[columnName]!.remove(option);
                            }
                          }
                        });
                      },
                    ),
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: optionsWidgets,
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.themeBgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Apply Filters",
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getTitleItemWidget(
      String label, bool isLastTitle, String columnName) {
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
                      color: Colors.white,
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
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            _showFilterDialog(columnName);
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
            child: Text(
              label,
              style: GoogleFonts.varela(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }

    return titleWidget(label);
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

class DataSource extends DataGridSource {
  final BuildContext? context;
  List<Applicant> leads;
  DataSource({required this.leads, this.context}) {
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

        if (dataGridCell.columnName == 'sub_status') {
          String? subStatus = dataGridCell.value.toString();
          return Container(
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
          );
        }

        if (dataGridCell.columnName == 'doc_status') {
          String doc = dataGridCell.value.toString();

          return Container(
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

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: value
              ? const Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.blue,
                )
              : null,
        ),
      ),
    );
  }
}










/* import 'dart:convert';  //TODO : Old my team code before 23/10/2023

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

  List<String> spocList = [];
  double calculateOffset() {
    return -(spocList.length * 62.0);
  }

  Future<void> fetchAllLeadDetails() async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllLeadsBySourceid?userId1=${widget.id}&page=1&size=100');
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

          DateTime nextSixMonthDateTime =
              DateTime(currentDateTime.year, currentDateTime.month + 6, 6);

          if ((doj?.month == currentDateTime.month ||
                  doj?.month == nextSixMonthDateTime.month ||
                  dol?.month == currentDateTime.month) ||
              (applicants[i].status == 'Select' && doj == null) ||
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
          if (filteredApplicants[i].sub_status == 'On-Site Interview') {
            filteredApplicants[i].sub_status = "Face2Face";
          }
        }

        for (int i = 0; i < filteredApplicants.length; i++) {
          if (filteredApplicants[i].sub_status == 'Confirmation Pending') {
            filteredApplicants[i].sub_status = "Pending";
          }
        }
        spocList = filteredApplicants
            .map((lead) => lead.source_name ?? '')
            .toSet()
            .toList()
            .cast<String>();
        spocList.insert(0, 'All');
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

  String selectedRound = '';
  String selectedName = '';
  bool isDropdownOpen = false;
  bool isValueSelected = false;
  String? selectedSpocValue;
  @override
  void dispose() {
    _searchController.dispose();
    _animationController?.dispose();
    super.dispose();
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
        floatingActionButton: PopupMenuButton<String>(
            offset: Offset(0, calculateOffset()),
            itemBuilder: (BuildContext context) {
              return [
                ...spocList.asMap().entries.map((entry) {
                  final String round = entry.value;
                  final isOddIndex = entry.key % 2 == 1;
                  return PopupMenuItem<String>(
                    padding: EdgeInsets.zero,
                    value: round,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            isOddIndex ? Colors.white : Constants.borderColor,
                      ),
                      child: Center(
                        child: Text(
                          extractInitials(round),
                          style: GoogleFonts.sourceSansPro(
                            color: isOddIndex
                                ? Constants.subtitleclr
                                : Constants.subtitleclr,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ];
            },
            onSelected: (selectedRound) {
              setState(() {
                selectedSpoc.clear();
                if (selectedSpoc.contains(selectedRound)) {
                  selectedSpoc.remove(selectedRound);
                } else {
                  selectedSpoc.add(selectedRound);
                }
                selectedName = selectedRound;
                _applySpocFilter(selectedSpoc);
              });
            },
            child: GestureDetector(
              onTap: null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                decoration: BoxDecoration(
                  color: const Color(0xfff729995),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedSpoc.isNotEmpty
                      ? extractInitials(selectedName)
                      : 'All',
                  style: GoogleFonts.varela(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
        backgroundColor: Colors.white,
        appBar: isSearchVisible
            ? AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
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
                headerColor: const Color(0xfff729995),
                filterIconColor: Colors.white,
                sortIconColor: Colors.white),
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
                        color: Colors.white,
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
                        color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  filterPopupMenuOptions: const FilterPopupMenuOptions(
                      canShowSortingOptions: false,
                      canShowClearFilterOption: false,
                      filterMode: FilterMode.checkboxFilter),
                ),
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
                        color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                    filterPopupMenuOptions: const FilterPopupMenuOptions(
                        canShowSortingOptions: false,
                        canShowClearFilterOption: false,
                        filterMode: FilterMode.checkboxFilter),
                    sortIconPosition: ColumnHeaderIconPosition.start),
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
                        color: Colors.white,
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
                      color: Colors.white,
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
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Text(
          label,
          style: GoogleFonts.varela(
              fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
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
      if (selectedSpoc.contains('All')) {
        filteredLeadsData = allLeadsData;
        // selectedSpoc.clear();
      } else {
        filteredLeadsData = allLeadsData
            .where((lead) => selectedSpoc.contains(lead.source_name ?? ''))
            .toList();
        // selectedSpoc.clear();
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
        DataGridCell<String>(
            columnName: 'sub_status', value: dataGridRow.sub_status),
        DataGridCell<String>(columnName: 'doj', value: dataGridRow.doj),
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

                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                ); */
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

                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                ); */
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

                /*  Navigator.push(  //TODO: Navigate to lead detail page.
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                ); */
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

                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTeamDetail(leadModel: clickedLead),
                  ),
                ); */
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
 */