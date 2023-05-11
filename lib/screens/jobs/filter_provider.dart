import 'package:flutter/material.dart';
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
