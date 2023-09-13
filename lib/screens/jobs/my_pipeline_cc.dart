import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/gobal.dart';
import '../../models/fetch_applied_job_model.dart';

class MyPipeLineCC extends StatefulWidget {
  const MyPipeLineCC({super.key});

  @override
  _MyPipeLineCCState createState() => _MyPipeLineCCState();
}

class _MyPipeLineCCState extends State<MyPipeLineCC> {
  Future<List<Applicant>>? _futureApplicants;

  Future<List<Applicant>> fetchAllApplicants(int userId) async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobs?userId1=$userId&userId2=$userId&page=1&size=1000');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        List<Applicant> applicants =
            contentList.map((json) => Applicant.fromJson(json)).toList();
        return applicants;
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _futureApplicants =
        fetchAllApplicants(2); // Replace userId with your user ID
  }

  int _selectedRowIndex = 0;
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override

  //TODO: old working code.
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Applicant>>(
        future: _futureApplicants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator while data is being fetched
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Display an error message if fetching data fails
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle the case where there is no data to display
            return const Center(
              child: Text('No data available.'),
            );
          } else {
            // Display data in a DataTable
            return SingleChildScrollView(
              controller: _verticalScrollController,
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Applicant Name')),
                      DataColumn(label: Text('Company')),

                      DataColumn(label: Text('Process')),
                      DataColumn(label: Text('Qualification')),
                      DataColumn(label: Text('Work Status')),
                      DataColumn(label: Text('Interview Status')),
                      DataColumn(label: Text('Sub Status')),
                      DataColumn(label: Text('DOJ')),
                      DataColumn(label: Text('Document Status')),
                      DataColumn(label: Text('Source Name')),

                      // Add more DataColumn widgets for other fields
                    ],
                    rows: snapshot.data!.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Applicant applicant = entry.value;
                      return DataRow(
                        color: MaterialStateColor.resolveWith((states) {
                          // Check if the current row is selected
                          return _selectedRowIndex == index
                              ? Colors.grey.shade400
                              : Colors.transparent;
                        }),
                        /*  onSelectChanged: (isSelected) {
                          setState(() {
                            // Update the selected row index when the row is selected or unselected
                            _selectedRowIndex = int.parse(isSelected == true
                                ? index.toString()
                                : null.toString());
                          });
                        }, */
                        cells: <DataCell>[
                          DataCell(GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Handle row selection here
                                  _selectedRowIndex = index;
                                });
                              },
                              child: Text(applicant.applicantName.toString()))),
                          DataCell(GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Handle row selection here
                                  _selectedRowIndex = index;
                                });
                              },
                              child: Text(applicant.short_name.toString()))),

                          DataCell(GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Handle row selection here
                                  _selectedRowIndex = index;
                                });
                              },
                              child: Text(applicant.process.toString()))),
                          DataCell(Text(applicant.qualification.toString())),
                          DataCell(Text(applicant.isExperienced.toString() == 1
                              ? "Experience"
                              : "Fresher")),
                          DataCell(Text(applicant.interview_rounds.toString())),
                          DataCell(Text(applicant.sub_status.toString())),
                          DataCell(Text(applicant.doj.toString())),
                          DataCell(Text(applicant.document_status.toString())),
                          const DataCell(Text("Source Name")),

                          // Add more DataCell widgets for other fields
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
