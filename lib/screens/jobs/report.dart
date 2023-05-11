import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/themes/colors.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController noResponse = TextEditingController();
  TextEditingController incorrectJob = TextEditingController();
  TextEditingController hrmisbehave = TextEditingController();
  TextEditingController recruitermoney1 = TextEditingController();
  TextEditingController recruitermoney2 = TextEditingController();
  TextEditingController other = TextEditingController();

  final bool _show = true;
  int? _radioValue;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
    print("first" + value.toString() + "radiovalue" + _radioValue.toString());
  }

  String dropdownvalue = 'recruiter 1';
  bool num = false;

  // List of items in our dropdown menu
  var items = [
    'recruiter 1',
    'recruiter 2',
    'recruiter 3',
    'recruiter 4',
    'other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(top: kToolbarHeight / 2),
                //height: MediaQuery.of(context).size.height,
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height / 6.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Constants.borderColor),
                                color: Constants.borderColor),
                          ),
                          Positioned(
                            top: 10.h,
                            left: 30.w,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 6.h,
                              child: Image.asset(
                                "assets/images/help.png",
                                // fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height / 6.h,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 6.h,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Constants.borderColor.withOpacity(0.5),
                            ),
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel_sharp,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Report an issue",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.sp),
                        )
                      ],
                    ),
                    customRadio(setState, "No Response from HR", 0),
                    if (_radioValue == 0)
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(left: 24),
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          controller: noResponse,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(),
                            hintText: 'Tell us what happened',
                          ),
                        ),
                      ),
                    customRadio(setState, "Incorrect Job Information", 1),
                    if (_radioValue == 1)
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(left: 24),
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          controller: incorrectJob,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(),
                            hintText: 'Which info do you think incorrect',
                          ),
                        ),
                      ),
                    customRadio(setState, "HR Misbehaved", 2),
                    if (_radioValue == 2)
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(left: 24),
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          controller: hrmisbehave,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(),
                            hintText: 'Brief about misbehavior',
                          ),
                        ),
                      ),
                    customRadio(setState, "Recruiter asked for money", 3),
                    if (_radioValue == 3)
                      Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(left: 24),
                          padding: const EdgeInsets.only(
                            left: 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /* Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    // color: Colors.amber,
                                    width: 100.w,
                                    height: 20,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        borderRadius: BorderRadius.circular(10),
                                        value: dropdownvalue,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: items.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropdownvalue = newValue.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  dropdownvalue == "other"
                                      ? SizedBox(
                                          width: 200.w,
                                          child: TextField(
                                            maxLength: 10,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.phone_android_outlined),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                              border: OutlineInputBorder(),
                                              labelText:
                                                  "Recruiter Contact Number",
                                              hintText:
                                                  'Please Enter the contact number of that recruiter',
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ), */
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    //left: 40,
                                    right: 40),
                                child: TextField(
                                  controller: recruitermoney1,
                                  //maxLength: 10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.currency_rupee_sharp),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    border: OutlineInputBorder(),
                                    labelText: "How much money Recruiter asked",
                                    hintText: 'Enter the amount',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                  // width: 200.w,
                                  padding: const EdgeInsets.only(
                                      //left: 40,
                                      right: 40),
                                  child: TextField(
                                    controller: recruitermoney2,
                                    //maxLength: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      border: OutlineInputBorder(),
                                      labelText: 'Short brief about issue',
                                      hintText: 'Short brief about issue',
                                    ),
                                  ))
                            ],
                          )),
                    customRadio(setState, "Other", 4),
                    if (_radioValue == 4)
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(left: 24),
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          controller: other,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(),
                            hintText: 'Tell me about your issue',
                          ),
                        ),
                      ),
                    /*  RadioListTile(
                                      title: const Text(
                                          "Recruiter Asked for money"),
                                      value: Issue.recruiter,
                                      groupValue: _issue,
                                      onChanged: handleSelection,
                                    ),
                                    RadioListTile(
                                      title: const Text("Other"),
                                      value: Issue.other,
                                      groupValue: _issue,
                                      onChanged: handleSelection,
                                    ), */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    Future.delayed(const Duration(seconds: 5),
                                        () {
                                      Navigator.of(context)
                                        ..pop()
                                        ..pop();
                                    });
                                    return AlertDialog(
                                      title: const Text("Feedback Submitted"),
                                      //  titlePadding: EdgeInsets.zero,
                                      content: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Text(
                                            "Representative will contact you shortly"),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx)
                                              ..pop()
                                              ..pop();
                                          },
                                          child: Container(
                                            color: Constants.borderColor,
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("okay"),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: _radioValue != null
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 20, top: 20, right: 10),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Constants.themeBgColor),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: const Text(
                                      "Submit issue",
                                      style: TextStyle(
                                          color: Constants.themeBgColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : const SizedBox())
                      ],
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget customRadio(
    StateSetter setState,
    String title,
    int value,
  ) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      title: Text(title),
      leading: Radio(
        value: value,
        groupValue: _radioValue,
        onChanged: (value) {
          setState(() {
            _radioValue = value as int;
          });
          _handleRadioValueChange(value as int);
        },
      ),
    );
  }
}
