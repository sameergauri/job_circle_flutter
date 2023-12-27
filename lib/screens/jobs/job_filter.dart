// ignore_for_file: use_super_parameters, non_constant_identifier_names, avoid_types_as_parameter_names
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/service/masterService.dart';

class JobFilter extends StatefulWidget {
  const JobFilter({Key? key}) : super(key: key);

  @override
  State<JobFilter> createState() => _JobFilterState();
}

class _JobFilterState extends State<JobFilter> {
  final List<Map<String, String>> filterItems = [];
  String selectedFilter = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterItems.add({"key": "location", "value": "Location"});
    filterItems.add({"key": "experience", "value": "Experience"});
    filterItems.add({"key": "role", "value": "Role"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: kToolbarHeight / 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 120,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext, index) {
                          return ListTile(
                            title: Text(filterItems[index]['value'].toString()),
                            selectedColor: Colors.blue,
                            selected: (selectedFilter ==
                                filterItems[index]['key'].toString()),
                            onTap: () {
                              selectedFilter =
                                  filterItems[index]['key'].toString();
                              setState(() {});
                              //bottomSheetDialogController.setState(() => {});
                            },
                          );
                        },
                        itemCount: filterItems.length,
                        padding: const EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                      )),
                  Container(
                    width: 2,
                    height: MediaQuery.of(context).size.height,
                    color: const Color.fromARGB(255, 228, 228, 228),
                  ),
                  Expanded(child: Container())
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ThemeButton(
              onPressed: () => {},
              width: MediaQuery.of(context).size.width - 100,
              text: "Apply Filters",
            )
          ],
        ),
      ),
    );
  }

  void bindFilters() async {
    var result = await MasterService().masterGetByGroups(
        {'groupName': 'city', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      dynamic resultValue = Utils.parseResponse(result).resultData['content'];
      for (var i = 0; i < resultValue.length; i++) {}
    }
  }
}
