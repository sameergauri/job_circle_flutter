// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/models/new_job_model.dart';

 // Import your JobsModel class
import 'package:job_circle/themes/colors.dart';

class FilterDialog {
  List<JobsModel> filteredjobs;
  List<JobsModel> alljobs;
  Function(List<JobsModel> filteredData) onFilterApplied;
  List<String> storedSelectedOptions = [];
  String storedSelectedCategory = '';
  List<String> storedSelectedColumn = [];
  Function(List<String> selectedOptions, String selectedCategory,
      List<String> selectedColumn) onDialogClosed;

  FilterDialog(
    this.filteredjobs,
    this.alljobs,
    this.onFilterApplied,
    this.storedSelectedOptions,
    this.storedSelectedCategory,
    this.storedSelectedColumn,
    this.onDialogClosed,
  );

  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _FilterDialogContent(
          filteredjobs,
          alljobs,
          onFilterApplied,
          storedSelectedOptions,
          storedSelectedCategory,
          storedSelectedColumn,
          onDialogClosed,
        );
      },
    );
  }
}

class _FilterDialogContent extends StatefulWidget {
  List<JobsModel> filteredjobs;
  List<JobsModel> alljobs;
  Function(List<JobsModel> filteredData) onFilterApplied;
  List<String> storedSelectedOptions = [];
  String storedSelectedCategory = '';
  List<String> storedSelectedColumn = [];
  Function(List<String> selectedOptions, String selectedCategory,
      List<String> selectedColumn) onDialogClosed;

  _FilterDialogContent(
    this.filteredjobs,
    this.alljobs,
    this.onFilterApplied,
    this.storedSelectedOptions,
    this.storedSelectedCategory,
    this.storedSelectedColumn,
    this.onDialogClosed,
  );

  @override
  __FilterDialogContentState createState() => __FilterDialogContentState();
}

class __FilterDialogContentState extends State<_FilterDialogContent> {
  late Map<String, List<String>> filterData;
  late Map<String, List<String>> originalFilterData;
  late String selectedKey;
  Map<String, List<String>> selectedData = {};

  late PageController _controller;
  Map<String, List<String>> selectedOptionsMap = {};

  @override
  void initState() {
    super.initState();
    filterData = {};
    originalFilterData = {};
    selectedKey = '';
    selectedData = {};
    for (var column in widget.storedSelectedColumn) {
      selectedOptionsMap[column] = widget.storedSelectedOptions;
    }
    if (widget.storedSelectedOptions.isNotEmpty) {
      selectedKey = widget.storedSelectedCategory;
      selectedData[selectedKey] = widget.storedSelectedOptions;
    }
    _controller = PageController(initialPage: 0);
    showFilterOption();
    for (var column in widget.storedSelectedColumn) {
      if (widget.storedSelectedOptions.isNotEmpty) {
        selectedData[column] = widget.storedSelectedOptions
            .where((value) => filterData[column]?.contains(value) ?? false)
            .toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Bar
          AppBar(
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
                    clearAll();
                    Navigator.pop(context);
                    widget.onDialogClosed(
                      [],
                      '',
                      [],
                    );
                  });
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
          Expanded(
            child: Row(
              children: [
                // Left Pane (Column Names)
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: SizedBox(
                    width: 135,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: filterData.keys
                          .map(
                            (e) => ListTile(
                              tileColor: selectedKey == e
                                  ? Colors.white
                                  : Colors.grey.shade200,
                              onTap: () {
                                setState(() {
                                  selectedKey = e;
                                  _controller.jumpToPage(1);
                                });
                              },
                              title: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                // Right Pane (Options)
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: (filterData[selectedKey] ?? [])
                                  .map(
                                    (e) => CheckboxListTile(
                                      value: selectedData[selectedKey]
                                              ?.contains(e) ==
                                          true,
                                      onChanged: (v) {
                                        toggleSelection(e);
                                      },
                                      title: Text(e),
                                    ),
                                  )
                                  .toSet()
                                  .toList(),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                _applyFilters();
                                Navigator.pop(context);
                                widget.onDialogClosed(
                                  selectedData[selectedKey] ?? [],
                                  selectedKey,
                                  selectedData.keys.toList(),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Constants.themeBgColor,
                                    borderRadius: BorderRadius.circular(15)),
                                width: 100,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Apply Filters",
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    bool isCategorySelected = widget.storedSelectedColumn.contains(selectedKey);
    bool isFirstCategory = widget.storedSelectedColumn.isNotEmpty &&
        widget.storedSelectedColumn[0] == selectedKey;

    setState(() {
      if (widget.storedSelectedColumn.isNotEmpty) {
        widget.filteredjobs = widget.alljobs.where((job) {
          return filterData.entries
              .every((entry) => matchesFilter(job, selectedData));
        }).toList();
      } else {
        widget.filteredjobs = widget.filteredjobs.where((job) {
          return filterData.entries
              .every((entry) => matchesFilter(job, selectedData));
        }).toList();
      }

      widget.storedSelectedOptions = selectedData[selectedKey] ?? [];
      widget.storedSelectedCategory = selectedKey;
      widget.storedSelectedColumn = selectedData.keys.toList();
    });

    widget.onFilterApplied(widget.filteredjobs);
  }

  bool matchesFilter(JobsModel job, Map<String, List<String>> selectedData) {
    return selectedData.entries.every((entry) {
      String columnName = entry.key;
      List<String>? selectedOptions = entry.value;
      if (selectedOptions.isNotEmpty) {
        List<String?> values = selectedOptions
            .map((selectedOption) => _getColumnValue(job, columnName))
            .toList();
        return values.every((value) {
          return value != null && selectedOptions.contains(value);
        });
      }
      return true;
    });
  }

  String? _getColumnValue(JobsModel job, String columnName) {
    switch (columnName) {
      case 'Company':
        return job.companyName;
      case 'Process':
        return job.process;
      case 'Designation':
        return job.roleName;
      case 'Functional Area':
        return job.natureOfWork;
      case 'Locality':
        return job.location;
      case 'Shift':
        return job.shiftTime;
      default:
        return null;
    }
  }

  void showFilterOption() {
    filterData = {
      'Company': getOptionsToShow('Company'),
      'Process': getOptionsToShow('Process'),
      'Functional Area': getOptionsToShow('Functional Area'),
      'Designation': getOptionsToShow('Designation'),
      'Locality': getOptionsToShow('Locality'),
      'Shift': getOptionsToShow('Shift'),
    };
    originalFilterData = Map.from(filterData);
    selectedKey = filterData.keys.first;
  }

  List<String> getFilterOptions(String columnName) {
    List<String> options = [];

    switch (columnName) {
      case 'Company':
        options = getOptionsToShow(columnName);
        break;
      case 'Process':
        options = getOptionsToShow(columnName);
        break;
      case 'Functional Area':
        options = getOptionsToShow(columnName);
        break;
      case 'Designation':
        options = getOptionsToShow(columnName);
        break;

      case 'Locality':
        options = getOptionsToShow(columnName);
        break;
      case 'Shift':
        options = getOptionsToShow(columnName);
        break;

      default:
        break;
    }

    return options;
  }

  List<String> getOptionsToShow(String columnName) {
    List<String> options = [];

    // Assuming allLeadsData is the full list of leads
    List<JobsModel> leadsList = [];
    // List<JobsModel> filteredList = widget.filteredjobs;

    bool isCategorySelected = widget.storedSelectedColumn.contains(columnName);
    bool isFirstCategory = widget.storedSelectedColumn.isNotEmpty &&
        widget.storedSelectedColumn[0] == columnName;

    // Apply filters based on the current filterValues
    if (widget.storedSelectedColumn.isEmpty) {
      leadsList = widget.filteredjobs
          .where((element) => _getColumnValue(element, columnName) != null)
          .toList();
    } else {
      // Apply filters based on the current filterValues inside the loop
      for (String appliedColumn in widget.storedSelectedColumn) {
        if (isCategorySelected && isFirstCategory) {
          leadsList = widget.alljobs
              .where((element) => _getColumnValue(element, columnName) != null)
              .toList();
        } else if (appliedColumn != columnName &&
            widget.storedSelectedColumn.isNotEmpty) {
          List<String>? selectedOptions = widget.storedSelectedOptions;
          if (selectedOptions.isNotEmpty) {
            leadsList = widget.alljobs.where((lead) {
              String? value = _getColumnValue(lead, appliedColumn);
              return value != null && selectedOptions.contains(value);
            }).toList();
          }
        }
      }
    }

    // Get unique options for the target column
    switch (columnName) {
      case 'Company':
        options = leadsList
            .where((lead) =>
                lead.companyName != null && lead.companyName!.isNotEmpty)
            .map((lead) => lead.companyName!)
            .toSet()
            .toList();
        break;
      case 'Process':
        options = leadsList
            .where((lead) => lead.process != null && lead.process!.isNotEmpty)
            .map((lead) => lead.process!)
            .toSet()
            .toList();
        break;
      case 'Designation':
        options = leadsList
            .where((lead) => lead.roleName != null && lead.roleName!.isNotEmpty)
            .map((lead) => lead.roleName!)
            .toSet()
            .toList();
        break;
      case 'Functional Area':
        options = leadsList
            .where((lead) =>
                lead.natureOfWork != null && lead.natureOfWork!.isNotEmpty)
            .map((lead) => lead.natureOfWork!)
            .toSet()
            .toList();
        break;

      case 'Locality':
        options = leadsList
            .where((lead) => lead.location != null && lead.location!.isNotEmpty)
            .map((lead) => lead.location!)
            .toSet()
            .toList();
        break;
      case 'Shift':
        options = leadsList
            .where(
                (lead) => lead.shiftTime != null && lead.shiftTime!.isNotEmpty)
            .map((lead) => lead.shiftTime!)
            .toSet()
            .toList();
        break;

      default:
        break;
    }

    return options;
  }

  // List<String> getOptionsToShow(String categoryKey) {
  //   List<String> optionsToShow = [];

  //   bool isCategorySelected = widget.storedSelectedColumn.contains(categoryKey);
  //   bool isFirstCategory = widget.storedSelectedColumn.isNotEmpty &&
  //       widget.storedSelectedColumn[0] == categoryKey;

  //   for (String appliedColumn in widget.storedSelectedColumn) {
  //     if (isCategorySelected && isFirstCategory) {
  //       optionsToShow.addAll(widget.alljobs
  //           .where((element) => _getColumnValue(element, categoryKey) != null)
  //           .map((e) => _getColumnValue(e, categoryKey)!)
  //           .expand((value) => value.split(',').map((e) => e.trim()))
  //           .toSet()
  //           .toList());
  //     } else if (appliedColumn != categoryKey) {
  //       List<String>? selectedOptions = widget.storedSelectedOptions;
  //       if (selectedOptions != null && selectedOptions.isNotEmpty) {
  //         optionsToShow.addAll(widget.alljobs.where((lead) {
  //           String? value = _getColumnValue(lead, appliedColumn);
  //           return value != null && selectedOptions.contains(value);
  //         }).toList());
  //       }
  //     } else {
  //       optionsToShow.addAll(widget.filteredjobs
  //           .where((element) => _getColumnValue(element, categoryKey) != null)
  //           .map((e) => _getColumnValue(e, categoryKey)!)
  //           .expand((value) => value.split(',').map((e) => e.trim()))
  //           .toSet()
  //           .toList());
  //     }
  //   }

  //   return optionsToShow.toSet().toList();
  // }

  void toggleSelection(String value) {
    setState(() {
      List<String> currentSelection =
          selectedData[selectedKey] ?? widget.storedSelectedColumn;

      if (currentSelection.contains(value)) {
        currentSelection.remove(value);
      } else {
        currentSelection.add(value);
      }

      selectedData[selectedKey] = currentSelection;
    });

    updateOtherCategories(selectedKey, value);
  }

  void updateOtherCategories(String selectedKey, String selectedValue) {
    setState(() {
      for (String categoryKey in filterData.keys) {
        if (categoryKey != selectedKey) {
          filterData[categoryKey] = getUpdatedDataForCategory(
            categoryKey,
            selectedKey,
            selectedData[selectedKey] ?? [],
          );
        }
      }
    });
  }

  List<String> getUpdatedDataForCategory(
    String categoryKey,
    String selectedKey,
    List<String> selectedValues,
  ) {
    if (selectedValues.isEmpty) {
      // If no options are selected, return the original data for the category
      return originalFilterData[categoryKey] ?? [];
    }

    List<String> updatedData = [];

    switch (categoryKey) {
      case 'Company':
        updatedData = widget.filteredjobs
            .where((element) =>
                selectedValues.contains(element.process) ||
                selectedValues.contains(element.natureOfWork) ||
                selectedValues.contains(element.roleName) ||
                selectedValues.contains(element.location) ||
                selectedValues.contains(element.shiftTime) &&
                    element.companyName != null &&
                    element.companyName != "")
            .map((e) => e.companyName!)
            .toSet()
            .toList();
        break;

      case 'Process':
        updatedData = widget.filteredjobs
            .where((element) =>
                selectedValues.contains(element.companyName) ||
                selectedValues.contains(element.natureOfWork) ||
                selectedValues.contains(element.roleName) ||
                selectedValues.contains(element.location) ||
                selectedValues.contains(element.shiftTime) &&
                    element.process != null &&
                    element.process != "")
            .map((e) => e.process!)
            .toSet()
            .toList();
        break;

      case 'Functional Area':
        updatedData = widget.filteredjobs
            .where((element) =>
                selectedValues.contains(element.companyName) ||
                selectedValues.contains(element.process) ||
                selectedValues.contains(element.roleName) ||
                selectedValues.contains(element.location) ||
                selectedValues.contains(element.shiftTime) &&
                    element.natureOfWork != null &&
                    element.natureOfWork != "")
            .map((e) => e.natureOfWork!)
            .toSet()
            .toList();
        break;

      case 'Designation':
        updatedData = widget.filteredjobs
            .where((element) =>
                selectedValues.contains(element.companyName) ||
                selectedValues.contains(element.process) ||
                selectedValues.contains(element.natureOfWork) ||
                selectedValues.contains(element.location) ||
                selectedValues.contains(element.shiftTime) &&
                    element.roleName != null &&
                    element.roleName != "")
            .map((e) => e.roleName!)
            .toSet()
            .toList();
        break;

      case 'Locality':
        updatedData = widget.filteredjobs
            .where((element) =>
                selectedValues.contains(element.companyName) ||
                selectedValues.contains(element.process) ||
                selectedValues.contains(element.natureOfWork) ||
                selectedValues.contains(element.roleName) ||
                selectedValues.contains(element.shiftTime) &&
                    element.location != null &&
                    element.location != "")
            .map((e) => e.location!)
            .expand((locations) => locations.split(',').map((e) => e.trim()))
            .toSet()
            .toList();
        break;

      case 'Shift':
        updatedData = widget.filteredjobs
            .where((element) =>
                selectedValues.contains(element.companyName) ||
                selectedValues.contains(element.process) ||
                selectedValues.contains(element.natureOfWork) ||
                selectedValues.contains(element.roleName) ||
                selectedValues.contains(element.location) &&
                    element.shiftTime != null &&
                    element.shiftTime != "")
            .map((e) => e.shiftTime!)
            .toSet()
            .toList();
        break;
    }

    return updatedData;
  }

  void clearAll() {
    selectedData.clear();
    widget.onFilterApplied(widget.alljobs);
  }
}
