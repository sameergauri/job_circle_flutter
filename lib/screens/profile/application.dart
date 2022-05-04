import 'package:flutter/material.dart';
import 'package:job_circle/models/autocomplete.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({Key? key}) : super(key: key);

  @override
  State<ApplicationForm> createState() => ApplicationFormState();
}

class ApplicationFormState extends State<ApplicationForm> {
  List typeList = [];
  DropdownModel selectedTyp = DropdownModel();
  int underGradActive = 0;
  int graduateActive = 0;
  int exprinceActive = 0;
  int fresherActive = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('New Resume'),
        actions: [
             IconButton(
              onPressed: () {
                // save();
              },
              icon: const Icon(Icons.clear)
            ),
            IconButton(
              onPressed: () {
               // save();
              },
              icon: const Icon(Icons.save),
            ),
          ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  // icon: Icon(Icons.person),
                  label: Text("Application Name"),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: 'Enter appilcation name',
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  // icon: Icon(Icons.person),
                  label: Text("Contact No"),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: 'Enter conctact no',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.topLeft, child: Text('Qualification')),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            underGradActive = 1;
                            graduateActive = 0;
                          });
                        },
                        child: Text(
                          'Inder-Graduate',
                          style: TextStyle(
                              color: underGradActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: underGradActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            underGradActive = 0;
                            graduateActive = 1;
                          });
                        },
                        child: Text(
                          'Graduate',
                          style: TextStyle(
                              color: graduateActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: graduateActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Work Experience')),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            exprinceActive = 1;
                            fresherActive = 0;
                          });
                        },
                        child: Text(
                          'Exprience',
                          style: TextStyle(
                              color: exprinceActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: exprinceActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            exprinceActive = 0;
                            fresherActive = 1;
                          });
                        },
                        child: Text(
                          'Fresher',
                          style: TextStyle(
                              color: fresherActive == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: fresherActive == 1
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.all(Colors.grey[300]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField<DropdownModel>(
                  // validator: (value) =>
                  //     value == null ? 'Please select any type' : null,
                  hint: const Padding(
                    padding: EdgeInsets.only(
                      left: 11.0,
                    ),
                    child: Text('Shortlist For'),
                  ),
                  isExpanded: true,
                  value: selectedTyp,
                  // isDense: true,
                  items: typeList.map((e) {
                    return DropdownMenuItem<DropdownModel>(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Text(e.name),
                      ),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (DropdownModel? value) {
                    setState(() {
                      // selectedTyp = value;
                    });
                  },
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField<DropdownModel>(
                  // validator: (value) =>
                  //     value == null ? 'Please select any type' : null,
                  hint: const Padding(
                    padding: EdgeInsets.only(
                      left: 11.0,
                    ),
                    child: Text('Process'),
                  ),
                  isExpanded: true,
                  value: selectedTyp,
                  // isDense: true,
                  items: typeList.map((e) {
                    return DropdownMenuItem<DropdownModel>(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Text(e.name),
                      ),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (DropdownModel? value) {
                    setState(() {
                      // selectedTyp = value;
                    });
                  },
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField<DropdownModel>(
                  // validator: (value) =>
                  //     value == null ? 'Please select any type' : null,
                  hint: const Padding(
                    padding: EdgeInsets.only(
                      left: 11.0,
                    ),
                    child: Text('Level'),
                  ),
                  isExpanded: true,
                  value: selectedTyp,
                  // isDense: true,
                  items: typeList.map((e) {
                    return DropdownMenuItem<DropdownModel>(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Text(e.name),
                      ),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (DropdownModel? value) {
                    setState(() {
                      // selectedTyp = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(onPressed: (){},icon: const Icon(Icons.upload), label: const Text('Upload your resume'),)
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
