import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/gobal.dart';
import '../../../models/job_details_model.dart';
import '../../../models/profileSummary.dart';
import '../../../themes/colors.dart';
import '../../models/my_team_model.dart';

//import '../../models/fetch_applied_job_model.dart';

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

  List<String> selectedOptions = [];
  List<String> selectedSpoc = [];

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

  void toggleSearchVisibility() {
    setState(() {
      isSearchVisible = !isSearchVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllLeadDetails().then((_) {
      filteredLeadsData = allLeadsData;

      _searchController.addListener(_searchData);
      setState(() {});
      dateOptions = generateDateOptions(formattedDojList);
      if (dateOptions.isNotEmpty) {
        selectedDateOptions.add(dateOptions[0]);
      }
    });

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

  void _filterLeadsData() {
    setState(() {
      filteredLeadsData = allLeadsData.where((lead) {
        final isDolInRange =
            (selectedDolFrom == null || selectedDolTo == null) ||
                (lead.dol != null &&
                    lead.dol!.isAfter(selectedDolFrom!) &&
                    lead.dol!
                        .isBefore(selectedDolTo!.add(const Duration(days: 1))));

        return (lead.dol != null) && isDolInRange;
      }).toList();
    });
  }

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

        List<dynamic> dojDynamicList =
            contentList.map((json) => json['doj'] as dynamic).toList();

        dojList = dojDynamicList.map((dynamicValue) {
          if (dynamicValue is String) {
            try {
              return DateTime.parse(dynamicValue);
            } catch (e) {
              return DateTime.now();
            }
          } else if (dynamicValue is DateTime) {
            return dynamicValue;
          }
        }).toList();

        formattedDojList = dojList
            .where((dateTime) => dateTime != null)
            .map((dateTime) => DateFormat('dd MMM yyyy').format(dateTime!))
            .toList();
        setState(() {
          allLeadsData = applicants;
          dojList = formattedDojList.cast<DateTime?>();
        });
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching data: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
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
                      child: Container(
                        height: 35,
                        padding: const EdgeInsets.only(left: 8, right: 20),
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
                              bottom: 10,
                              left: 5,
                              top: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Constants.borderColor),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            hintText: "search applicant name",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSearchVisible = false;
                                  _animationController?.reverse();
                                  _searchFocusNode.unfocus();
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
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () async {
                  _showSpocDolDialog();
                },
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 156, 202, 232),
                      BlendMode.srcIn,
                    ),
                    child: Image.network(
                      "https://cdn-icons-png.flaticon.com/128/566/566737.png",
                      height: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 15, bottom: 15),
          child: SfDataGrid(
            source: DataSource(leads: filteredLeadsData, context: context),
            selectionMode: SelectionMode.single,
            navigationMode: GridNavigationMode.cell,
            frozenRowsCount: 0,
            allowPullToRefresh: true,
            rowHeight: 35,
            headerRowHeight: 40,
            gridLinesVisibility: GridLinesVisibility.none,
            columnWidthMode: ColumnWidthMode.auto,
            allowColumnsDragging: true,
            allowSorting: true,
            columns: <GridColumn>[
              GridColumn(
                columnName: 'applicantName',
                allowSorting: false,
                label: _getTitleItemWidget(
                  'Applicant Name',
                  false,
                ),
              ),
              GridColumn(
                width: 90,
                columnName: 'companyName',
                allowSorting: false,
                label: _getTitleItemWidget('Company', false),
              ),
              GridColumn(
                columnName: 'process',
                allowSorting: false,
                label: _getTitleItemWidget('Process', false),
              ),
              GridColumn(
                width: 105,
                columnName: 'qualification',
                allowSorting: false,
                label: _getTitleItemWidget('Qualification', false),
              ),
              GridColumn(
                width: 90,
                columnName: 'experience',
                allowSorting: false,
                label: _getTitleItemWidget('Work Status', false),
              ),
              GridColumn(
                columnName: 'status',
                width: 110,
                allowSorting: false,
                label: _getTitleItemWidget('Interview Status', false),
              ),
              GridColumn(
                columnName: 'sub_status',
                allowSorting: false,
                label: _getTitleItemWidget('Sub Status', false),
              ),
              GridColumn(
                width: 90,
                columnName: 'doj',
                label: _getTitleItemWidget('DOJ', false),
              ),
              GridColumn(
                width: 100,
                columnName: 'doc_status',
                allowSorting: false,
                label: _getTitleItemWidget('Doc Status', false),
              ),
              GridColumn(
                width: 80,
                columnName: 'source',
                allowSorting: false,
                label: _getTitleItemWidget('Source', false),
              ),
              GridColumn(
                width: 80,
                columnName: 'referral',
                allowSorting: false,
                label: _getTitleItemWidget('Referral', false),
              ),
            ],
          ),
        ));
  }

  Widget _getTitleItemWidget(String label, bool isLastTitle) {
    Widget titleWidget(String label) {
      if (label == 'DOJ') {
        return GestureDetector(
          onTap: _showDateOptionsDialog,
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      }
      if (label == 'Company') {
        Set<String> companyNamesSet =
            allLeadsData.map((lead) => lead.short_name ?? '').toSet();
        List<String> companyNames = companyNamesSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(companyNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Process') {
        Set<String> processSet =
            allLeadsData.map((lead) => lead.process ?? '').toSet();
        List<String> processNames = processSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(processNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Qualification') {
        Set<String> eduSet =
            allLeadsData.map((lead) => lead.qualification ?? '').toSet();
        List<String> eduNames = eduSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(eduNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Work Status') {
        Set<String> expSet =
            allLeadsData.map((lead) => lead.isExperienced ?? '').toSet();
        List<String> expNames = expSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(expNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Interview Status') {
        Set<String> statusSet =
            allLeadsData.map((lead) => lead.status ?? '').toSet();
        List<String> statusNames = statusSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(statusNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Sub Status') {
        Set<String> subSet =
            allLeadsData.map((lead) => lead.sub_status ?? '').toSet();
        List<String> subNames = subSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(subNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Doc Status') {
        Set<String> docSet =
            allLeadsData.map((lead) => lead.document_status ?? '').toSet();
        List<String> docNames = docSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(docNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Source') {
        Set<String> sourceSet =
            allLeadsData.map((lead) => lead.source_name ?? '').toSet();
        List<String> sourceNames = sourceSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(sourceNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      if (label == 'Referral') {
        Set<String> refSet =
            allLeadsData.map((lead) => lead.referral_name ?? '').toSet();
        List<String> refNames = refSet.toList();
        return Container(
          child: GestureDetector(
            onTap: () => _showCustomOptionsDialog(refNames, label),
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.varela(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
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
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  List<String> generateDateOptions(List<String> formattedDojList) {
    List<String> options = [];
    String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    if (formattedDojList.contains(currentDate)) {
      options.add("Today");
    }
    DateTime tomorrowDate = DateTime.now().add(const Duration(days: 1));
    String formattedTomorrowDate =
        DateFormat('dd MMM yyyy').format(tomorrowDate);
    if (formattedDojList.contains(formattedTomorrowDate)) {
      options.add("Tomorrow");
    }
    options.addAll(formattedDojList.where((date) =>
        date != DateFormat('dd MMM yyyy').format(DateTime.now()) &&
        date != formattedTomorrowDate));
    if (allLeadsData
        .any((lead) => lead.status == 'Select' && lead.doj == null)) {
      options.add("Pending");
    }
    return options.toSet().toList();
  }

  void applyDateFilter(
      List<String> formattedDojList, Set<String> selectedDates) {
    setState(() {
      filteredLeadsData = allLeadsData.where((lead) {
        if (lead.status == 'Select' && lead.doj == null) {
          return selectedDates.contains("Pending");
        }
        if (selectedDates.isEmpty) {
          return true;
        }
        if (lead.doj != null) {
          String formattedLeadDate =
              DateFormat('dd MMM yyyy').format(lead.doj!);
          if (selectedDates.contains("Today") &&
              formattedLeadDate ==
                  DateFormat('dd MMM yyyy').format(DateTime.now())) {
            return true;
          }
          if (selectedDates.contains("Tomorrow")) {
            DateTime tomorrowDate = DateTime.now().add(const Duration(days: 1));
            String formattedTomorrowDate =
                DateFormat('dd MMM yyyy').format(tomorrowDate);
            if (formattedLeadDate == formattedTomorrowDate) {
              return true;
            }
          }
          if (selectedDates.contains("Pending") &&
              lead.status == 'Select' &&
              lead.doj == null) {
            return true;
          }
          return selectedDates.contains(formattedLeadDate);
        }
        return false;
      }).toList();
    });
  }

  void applyCompanyNameFilter(String companyName) {
    setState(() {
      filteredLeadsData = allLeadsData.where((lead) {
        return lead.short_name
                ?.toLowerCase()
                .contains(companyName.toLowerCase()) ??
            false;
      }).toList();
    });
  }

  void _showSpocDolDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select an Option',
            style: GoogleFonts.varela(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Text(
                      'Spoc',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showSpocListDialog();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Text(
                      'DOL',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      _selectDolDateRange();
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  filteredLeadsData = allLeadsData;
                });
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _showDateOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: AlertDialog(
                title: const Text('DOJ'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: dateOptions
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedDateOptions.contains(item)) {
                                      selectedDateOptions.remove(item);
                                    } else {
                                      selectedDateOptions.add(item);
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      child: selectedDateOptions.contains(item)
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.red,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(item),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedDateOptions.clear();
                      });
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCustomOptionsDialog(List<String> options, String title) {
    TextEditingController searchController = TextEditingController();
    String searchText = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                  Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: options
                          .where((item) =>
                              searchText.isEmpty ||
                              item
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()))
                          .map((item) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedOptions.contains(item)) {
                                        selectedOptions.remove(item);
                                      } else {
                                        selectedOptions.add(item);
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        child: selectedOptions.contains(item)
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.red,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(item),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedOptions.clear();
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitButton(title, selectedOptions);
                  },
                  child: const Text('Submit'),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showSpocListDialog() {
    List<String> spocNames =
        allLeadsData.map((lead) => lead.spoc_name ?? '').toSet().toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select a Spoc',
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
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        spocNames = allLeadsData
                            .map((lead) => lead.spoc_name ?? '')
                            .where((spoc) => spoc
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toSet()
                            .toList();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: spocNames
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
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          border: selectedSpoc.contains(spoc)
                                              ? null
                                              : Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: selectedSpoc.contains(spoc)
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                        child: selectedSpoc.contains(spoc)
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(spoc),
                                    ],
                                  ),
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
              onPressed: () {
                setState(() {
                  selectedOptions.clear();
                });
              },
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedSpoc.isEmpty) {
                  setState(() {
                    filteredLeadsData = allLeadsData;
                  });
                } else {
                  _applySpocFilter(selectedSpoc);
                }
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitButton(String title, List<String> selectedOptions) {
    if (selectedOptions.isEmpty) {
      setState(() {
        filteredLeadsData = allLeadsData;
      });
    } else {
      applyFilter(title, selectedOptions);
    }
    Navigator.pop(context);
  }

  void _submit() {
    if (selectedDateOptions.isEmpty) {
      setState(() {
        filteredLeadsData = allLeadsData;
      });
    } else {
      applyDateFilter(formattedDojList, selectedDateOptions);
    }
    Navigator.pop(context);
  }

  void applyFilter(String title, List<String> selectedOptions) {
    setState(() {
      if (title == 'Company') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.short_name != null &&
              lead.short_name!.toLowerCase().contains(option.toLowerCase()));
        }).toList();
      }
      if (title == 'Process') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.process?.toLowerCase().contains(option.toLowerCase()) ??
              false);
        }).toList();
      }
      if (title == 'Qualification') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.qualification
                  ?.toLowerCase()
                  .contains(option.toLowerCase()) ??
              false);
        }).toList();
      }
      if (title == 'Work Status') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.isExperienced
                  ?.toLowerCase()
                  .contains(option.toLowerCase()) ??
              false);
        }).toList();
      }
      if (title == 'Interview Status') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.status?.toLowerCase().contains(option.toLowerCase()) ??
              false);
        }).toList();
      }
      if (title == 'Sub Status') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.isExperienced
                  ?.toLowerCase()
                  .contains(option.toLowerCase()) ??
              false);
        }).toList();
      }
      if (title == 'Doc Status') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.document_status
                  ?.toLowerCase()
                  .contains(option.toLowerCase()) ??
              false);
        }).toList();
      }

      if (title == 'Source') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.source_name?.toLowerCase().contains(option.toLowerCase()) ??
              false);
        }).toList();
      }
      if (title == 'Referral') {
        filteredLeadsData = allLeadsData.where((lead) {
          return selectedOptions.any((option) =>
              lead.referral_name
                  ?.toLowerCase()
                  .contains(option.toLowerCase()) ??
              false);
        }).toList();
      }
    });
  }

  void _applySpocFilter(List<String> selectedSpoc) {
    setState(() {
      filteredLeadsData = allLeadsData
          .where((lead) => selectedSpoc.contains(lead.spoc_name ?? ''))
          .toList();
    });
  }

  void _selectDolDateRange() async {
    final DateTime currentDate = DateTime.now();
    final DateTime oneYearAgo = currentDate.subtract(const Duration(days: 365));
    final DateTime fourMonthsAhead = currentDate.add(const Duration(days: 120));

    DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: oneYearAgo,
      lastDate: fourMonthsAhead,
      initialDateRange: DateTimeRange(
        start: selectedDolFrom ?? currentDate,
        end: selectedDolTo ?? currentDate,
      ),
    );

    if (selectedRange != null) {
      setState(() {
        selectedDolFrom = selectedRange.start;
        selectedDolTo = selectedRange.end;
      });
      _filterLeadsData();
    } else {
      setState(() {
        selectedDolFrom = null;
        selectedDolTo = null;
      });
      filteredLeadsData = allLeadsData;
    }
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
        DataGridCell<String>(
            columnName: 'qualification', value: dataGridRow.qualification),
        DataGridCell<String>(
            columnName: 'experience', value: dataGridRow.isExperienced),
        DataGridCell<String>(columnName: 'status', value: dataGridRow.status),
        DataGridCell<String>(
            columnName: 'sub_status', value: dataGridRow.sub_status),
        DataGridCell<DateTime>(columnName: 'doj', value: dataGridRow.doj),
        DataGridCell<String>(
            columnName: 'doc_status', value: dataGridRow.document_status),
        DataGridCell<String>(
            columnName: 'source', value: dataGridRow.source_name),
        DataGridCell<String>(
            columnName: 'referral', value: dataGridRow.referral_name),
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
          DateTime? doj = dataGridCell.value as DateTime?;
          String status = row
              .getCells()
              .firstWhere(
                (cell) => cell.columnName == 'status',
                orElse: () =>
                    const DataGridCell<String>(columnName: 'status', value: ''),
              )
              .value;

          return Container(
            decoration: BoxDecoration(
              color: (status == 'Select' && doj == null)
                  ? Colors.red
                  : ((doj != null && doj.day == DateTime.now().day)
                      ? Colors.green
                      : (doj != null &&
                              doj.day ==
                                  DateTime.now()
                                      .add(const Duration(days: 1))
                                      .day)
                          ? Colors.orange
                          : null),
              border: const Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              (status == 'Select' && doj == null)
                  ? 'Pending'
                  : ((doj != null && doj.day == DateTime.now().day)
                      ? 'Today'
                      : (doj != null &&
                              doj.day ==
                                  DateTime.now()
                                      .add(const Duration(days: 1))
                                      .day)
                          ? 'Tomorrow'
                          : (doj != null
                              ? formatDate(doj)
                              : 'N/A')), // Handle null case
              style: GoogleFonts.varela(
                color: (status == 'Select' && doj == null) ||
                        (doj != null && doj.day == DateTime.now().day) ||
                        (doj != null &&
                            doj.day ==
                                DateTime.now().add(const Duration(days: 1)).day)
                    ? Colors.white
                    : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        if (dataGridCell.columnName == 'source') {
          String source = dataGridCell.value.toString();

          return Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              extractInitials(source == 'null' ? 'N/A' : source),
              style: GoogleFonts.varela(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        if (dataGridCell.columnName == 'referral') {
          String referral = dataGridCell.value.toString();

          return Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              extractInitials(referral != 'null' ? referral : 'N/A'),
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
              doc == 'null' ? 'N/A' : doc,
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
            : ' ' + (i == nameParts.length - 1 ? part[0] : part[0] + ' ');
      }
    }

    return initials;
  }
}
