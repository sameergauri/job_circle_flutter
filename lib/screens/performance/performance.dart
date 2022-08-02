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
              icon: Icon(Icons.calendar_month))
        ],
      ),
      body: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: (150 * 8),
          columns: const [
            DataColumn2(
              fixedWidth: 150,
              label: Text('Application Name'),
            ),
            DataColumn2(
              fixedWidth: 150,
              label: Text('Company Name'),
            ),
            DataColumn2(
              fixedWidth: 150,
              label: Text('Process'),
            ),
            DataColumn2(
              fixedWidth: 150,
              label: Text('Level'),
            ),
            DataColumn2(
              fixedWidth: 150,
              label: Text('D.O.J'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              fixedWidth: 150,
              label: Text('Joining Status'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              fixedWidth: 150,
              label: Text('Payout'),
              size: ColumnSize.L,
            ),
          ],
          rows: List<DataRow>.generate(
              items.length,
              (index) => DataRow(cells: [
                    DataCell(Text(items[index]['last_name'])),
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
                    DataCell(Text(items[index]['payout'].toString()))
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
}
