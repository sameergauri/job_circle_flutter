import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/models/momsModel.dart';
import 'package:job_circle/service/masterService.dart';

import '../common/utils.dart';

class MasterOfMasterView extends StatefulWidget {
  const MasterOfMasterView({Key? key}) : super(key: key);

  @override
  State<MasterOfMasterView> createState() => _MasterOfMasterViewState();
}

class _MasterOfMasterViewState extends State<MasterOfMasterView> {
  List list = [];

  @override
  void initState() {
    getMomData();
    super.initState();
  }

  getMomData() async {
    var result =
        await MasterService().getMaster({'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var resultData = Utils.parseResponse(result).resultData;
      for (var i = 0; i < resultData.length; i++) {
        list.add(MomsModel(
          id: resultData['id'],
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Master Of Master View'),
        ),
        body: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          smRatio: 0.75,
          lmRatio: 1.5,
          columns: const [
            DataColumn2(
              size: ColumnSize.S,
              label: Text('Column A'),
            ),
            DataColumn(
              label: Text('Column B'),
            ),
            DataColumn(
              label: Text('Column C'),
            ),
            DataColumn(
              label: Text('Column D'),
            ),
            DataColumn2(
              label: Text('Column NUMBERS'),
              numeric: true,
              size: ColumnSize.L,
            ),
          ],
          rows: List<DataRow>.generate(
            100,
            (index) => DataRow(
              cells: [
                DataCell(Text('A' * (10 - index % 10))),
                DataCell(Text('B' * (10 - (index + 5) % 10))),
                DataCell(Text('C' * (15 - (index + 5) % 10))),
                DataCell(Text('D' * (15 - (index + 10) % 10))),
                DataCell(Text(((index + 0.1) * 25.4).toString()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
