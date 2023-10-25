import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/screens/jobs/filter.dart';


import '../../models/api_response.dart';

final filterProvider =
    ChangeNotifierProvider((ref) => FilterProvider(ref)..init());

class FilterProvider extends ChangeNotifier {
  List<dynamic> data = [];
  Map<dynamic, List<String>> originalFilterData = {};
  final Ref ref;
  FilterProvider(this.ref);
  Map<dynamic, List<String>> filterData = {};
  String _selectedKey = '';
  String get selectedKey => _selectedKey;
  set selectedKey(String selectedKey) {
    _selectedKey = selectedKey;
    notifyListeners();
  }

  void init() {
    final response = ref.watch(jobDataProvider).whenData((value) {
      RequestResult res = Utils.parseResponse(value);
      data = res.resultData as List;

      filterData = {
        'Company': data
            .where((element) =>
                element['companyname'] != null && element['companyname'] != "")
            .map((e) => e['companyname'].toString())
            .toSet()
            .toList(),
        'Process': data
            .where((element) =>
                element['process'] != null && element['process'] != "")
            .map((e) => e['process'].toString())
            .toSet()
            .toList(),
        'Functional Area': data
            .where((element) =>
                element['naturofwork'] != null && element['naturofwork'] != "")
            .map((e) => e['naturofwork'].toString())
            .toSet()
            .toList(),
        'Designation': data
            .where((element) =>
                element['rolename'] != null && element['rolename'] != "")
            .map((e) => e['rolename'].toString())
            .toSet()
            .toList(),
        'Locality': data
            .where((element) =>
                element['location'] != null && element['location'] != "")
            .map((e) => e['location'].toString())
            .toSet()
            .toList(),

        /*  'Skills': ['Skill1', 'skill2'],
      'process': ['p1', 'p2'], */
      };
      originalFilterData = Map.from(filterData);
      selectedKey = filterData.keys.first;
    });
  }

  Map<String, List<String>> selectedData = {};
  void toggleSelection(String value) {
    if (selectedData.containsKey(selectedKey)) {
      if (selectedData[selectedKey]!.contains(value)) {
        selectedData[selectedKey]!.remove(value);
      } else {
        selectedData[selectedKey]!.add(value);
      }
    } else {
      selectedData[selectedKey] = [value];
    }

    updateOtherCategories(selectedKey, value);
    notifyListeners();
  }

  void updateOtherCategories(String selectedKey, String selectedValue) {
    // Iterate through all categories and update them based on the selected value
    for (String categoryKey in filterData.keys) {
      if (categoryKey != selectedKey) {
        List<String> updatedData = getUpdatedDataForCategory(
          categoryKey,
          selectedKey,
          selectedValue,
        );

        filterData[categoryKey] = updatedData;
      }
    }
  }

  List<String> getUpdatedDataForCategory(
    String categoryKey,
    String selectedKey,
    String selectedValue,
  ) {
    // Implement logic to fetch updated data for the given category based on the
    // selected value in another category.

    // Example:
    // Fetch updated data for 'Process' based on selected 'Company'
    // Your logic may involve making API calls or filtering the existing data.

    // Replace this with your actual data fetching logic
    List<String> updatedData = [];

    // Sample logic (you need to modify this based on your data structure)
    switch (categoryKey) {
      case 'Company':
        updatedData = data
            .where((element) =>
                element['process'] == selectedValue ||
                element['naturofwork'] == selectedValue ||
                element['rolename'] == selectedValue ||
                element['location'] == selectedValue &&
                    element['companyname'] != null &&
                    element['companyname'] != "")
            .map((e) => e['companyname'].toString())
            .toSet()
            .toList();
        break;

      case 'Process':
        updatedData = data
            .where((element) =>
                element['companyname'] == selectedValue ||
                element['naturofwork'] == selectedValue ||
                element['rolename'] == selectedValue ||
                element['location'] == selectedValue &&
                    element['process'] != null &&
                    element['process'] != "")
            .map((e) => e['process'].toString())
            .toSet()
            .toList();
        break;
      case 'Functional Area':
        // Fetch updated data for 'Functional Area' based on selected 'Company'
        updatedData = data
            .where((element) =>
                element['companyname'] == selectedValue ||
                element['process'] == selectedValue ||
                element['rolename'] == selectedValue ||
                element['location'] == selectedValue &&
                    element['naturofwork'] != null &&
                    element['naturofwork'] != "")
            .map((e) => e['naturofwork'].toString())
            .toSet()
            .toList();
        break;
      case 'Designation':
        // Fetch updated data for 'Functional Area' based on selected 'Company'
        updatedData = data
            .where((element) =>
                element['companyname'] == selectedValue ||
                element['process'] == selectedValue ||
                element['naturofwork'] == selectedValue ||
                element['location'] == selectedValue &&
                    element['rolename'] != null &&
                    element['rolename'] != "")
            .map((e) => e['rolename'].toString())
            .toSet()
            .toList();
        break;
      case 'Locality':
        // Fetch updated data for 'Functional Area' based on selected 'Company'
        updatedData = data
            .where((element) =>
                element['companyname'] == selectedValue ||
                element['process'] == selectedValue ||
                element['naturofwork'] == selectedValue ||
                element['rolename'] == selectedValue &&
                    element['location'] != null &&
                    element['location'] != "")
            .map((e) => e['location'].toString())
            .toSet()
            .toList();
        break;
      // Add cases for other categories as needed
      // ...
    }

    return updatedData;
  }

  void clearAll() {
    selectedData.clear();

    // Reset all filter categories to their original values
    for (String key in filterData.keys) {
      filterData[key] = originalFilterData[key]?.toList() ?? [];
    }

    notifyListeners();
  }
}


/* import 'package:flutter/material.dart';  //TODO : Old code before changes done.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/screens/jobs/filter.dart';

import '../../models/api_response.dart';

final filterProvider =
    ChangeNotifierProvider((ref) => FilterProvider(ref)..init());


    

class FilterProvider extends ChangeNotifier {
  List<dynamic> data = [];
  final Ref ref;
  FilterProvider(this.ref);
  Map<dynamic, List<String>> filterData = {};
  String _selectedKey = '';
  String get selectedKey => _selectedKey;
  set selectedKey(String selectedKey) {
    _selectedKey = selectedKey;
    notifyListeners();
  }

  void init() {
    final response = ref.watch(jobDataProvider).whenData((value) {
      RequestResult res = Utils.parseResponse(value);
      data = res.resultData as List;

      filterData = {
        'Company': data
            .where((element) =>
                element['companyname'] != null && element['companyname'] != "")
            .map((e) => e['companyname'].toString())
            .toSet()
            .toList(),
        'Process': data
            .where((element) =>
                element['process'] != null && element['process'] != "")
            .map((e) => e['process'].toString())
            .toSet()
            .toList(),
        'Nature Of Work ': data
            .where((element) =>
                element['naturofwork'] != null && element['naturofwork'] != "")
            .map((e) => e['naturofwork'].toString())
            .toSet()
            .toList(),
        'Designation': data
            .where((element) =>
                element['rolename'] != null && element['rolename'] != "")
            .map((e) => e['rolename'].toString())
            .toSet()
            .toList(),
        'Locality': data
            .where((element) =>
                element['location'] != null && element['location'] != "")
            .map((e) => e['location'].toString())
            .toSet()
            .toList(),

        /*  'Skills': ['Skill1', 'skill2'],
      'process': ['p1', 'p2'], */
      };

      selectedKey = filterData.keys.first;
    });
  }

  Map<String, List<String>> selectedData = {};
  void toggleSelection(String value) {
    if (selectedData.containsKey(selectedKey)) {
      if (selectedData[selectedKey]!.contains(value)) {
        selectedData[selectedKey]!.remove(value);
      } else {
        selectedData[selectedKey]!.add(value);
      }
    } else {
      selectedData[selectedKey] = [value];
    }
    notifyListeners();
  }
}
 */