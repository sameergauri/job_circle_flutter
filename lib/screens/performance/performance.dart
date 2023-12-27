// ignore_for_file: unused_field, use_super_parameters, non_constant_identifier_names, unused_element, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/screens/webview/webview_control.dart';
import 'package:job_circle/service/LeadService.dart';
//import 'package:month_picker_dialog/month_picker_dialog.dart';
//import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

class Performance extends StatefulWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  List items = [];

  bool _sortAscending = true;
  int? _sortColumnIndex;
  final cols_d = [
    {
      "name": true,
      "empid": true,
      "companyName": true,
      "process": true,
      "level": true,
      "doj": true,
      "status": true,
      "payout": true,
      "remark": true,
      "payment_clause": true,
      "bill_status": true
    }
  ];

  DateTime selectedDate = DateTime.now();
  WebViewCtrlController webctrl = WebViewCtrlController();

  String _Date = "";
  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        saveText: "Select",
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _Date = getDate(selectedDate);
    // bindData();
  }

  String getDate(date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Performance"),
          actions: [
            IconButton(
                onPressed: () => {
                      {webctrl.refresh()}
                    },
                icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: (() async {
                 /*  showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1, 5),
                    lastDate: DateTime(DateTime.now().year + 1, 9),
                    initialDate: selectedDate,
                  ).then((date) {
                    if (date != null) {
                      selectedDate = date;
                      _Date = getDate(selectedDate);
                      webctrl.url = GlobalConstants.WEB_Host +
                          "/mobile/performance?date=${_Date}";
                      webctrl.setUrl();
                      webctrl.refresh();

                      setState(() {});

                      // bindData();
                    }
                  }); */
                }),
                icon: const Icon(Icons.calendar_month))
          ],
        ),
        body: WebViewDataCtrl(
            actionbar: false,
            controller: webctrl,
            url: GlobalConstants.WEB_Host + "/mobile/performance?date=$_Date"));
  }

  void bindData() async {
    var usertype = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);
    var role =
        await Utils.getPreferencesValue(null, ESharedPreferences.role.name);
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    var result = await LeadService().getAllLeadsAdvanced({
      "flag": "performance",
      "sourceId": userid,
      "usertype": usertype,
      "role": role,
      "date": selectedDate.toString()
    });
    RequestResult res = Utils.parseResponse(result);
    var list = res.resultData as List;
    items.clear();
    setState(() {
      items.addAll(list);
    });
  }

  _sort(col, columnIndex, ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (ascending) {
        items.sort((dynamic a, dynamic b) => b[col].compareTo(a[col]));
      } else {
        items.sort((dynamic a, dynamic b) => a[col].compareTo(b[col]));
      }
    });
  }
}
