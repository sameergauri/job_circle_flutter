import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/screens/statistics/statistic.dart';
import 'package:job_circle/service/LeadService.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
    {"name": "label"},
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
    // TODO: implement initState
    super.initState();
    bindData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Performance"),
        actions: [
          IconButton(
              onPressed: (() async {
                showMonthPicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year - 1, 5),
                  lastDate: DateTime(DateTime.now().year + 1, 9),
                  initialDate: selectedDate,
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                    bindData();
                  }
                });
              }),
              icon: const Icon(Icons.calendar_month))
        ],
      ),
      body: DataTable2(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: (150 * 12),
          sortArrowIcon: Icons.arrow_upward,
          columns: [
            DataColumn2(
                fixedWidth: 150,
                label: const Text('Candidate name'),
                onSort: (columnIndex, ascending) =>
                    {_sort('applicantName', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Emp Code'),
                onSort: (columnIndex, ascending) =>
                    {_sort('empid', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Company Name'),
                onSort: (columnIndex, ascending) =>
                    {_sort('companyName', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Process'),
                onSort: (columnIndex, ascending) =>
                    {_sort('process', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Role'),
                onSort: (columnIndex, ascending) =>
                    {_sort('level', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('D.O.J'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    {_sort('doj', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Status'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    {_sort('status', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Payout'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    {_sort('payout', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Remark'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    {_sort('remark', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Payment Clause'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    {_sort('payment_clause', columnIndex, ascending)}),
            DataColumn2(
                fixedWidth: 150,
                label: Text('Billing status'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    {_sort('bill_status', columnIndex, ascending)}),
            // DataColumn2(
            //     fixedWidth: 150,
            //     label: Text('Billing status'),
            //     size: ColumnSize.L,
            //     onSort: (columnIndex, ascending) =>
            //         {_sort('bill_status', columnIndex, ascending)}),
            // DataColumn2(
            //     fixedWidth: 150,
            //     label: Text('Billing status'),
            //     size: ColumnSize.L,
            //     onSort: (columnIndex, ascending) =>
            //         {_sort('bill_status', columnIndex, ascending)})
          ],
          rows: List<DataRow>.generate(
              items.length,
              (index) => DataRow(cells: [
                    DataCell(Text(
                        "${items[index]['applicantName']} ${items[index]['last_name']}")),
                    DataCell(Text(items[index]['empid'])),
                    DataCell(Text(items[index]['companyName'])),
                    DataCell(Text(items[index]['process'])),
                    DataCell(Text(items[index]['level'])),
                    DataCell(Text(items[index]['doj'] ?? '')),
                    DataCell(Text(
                      items[index]['status'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: HexColor("${items[index]['statuscolor']}"),
                          fontWeight: FontWeight.bold),
                    )),
                    DataCell(Text(items[index]['payout'].toString())),
                    DataCell(Text(items[index]['remark'].toString())),
                    DataCell(Text(items[index]['payment_clause'].toString())),
                    DataCell(Text(items[index]['bill_status'].toString()))
                  ]))),
    );
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
