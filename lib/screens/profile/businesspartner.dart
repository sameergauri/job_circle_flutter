// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/card_number_formatter.dart';
import '../../components/common.dart';
import '../../models/autocomplete.dart';

class BusinessPartner extends StatefulWidget {
  const BusinessPartner({Key? key}) : super(key: key);

  @override
  State<BusinessPartner> createState() => _BusinessPartnerState();
}

class _BusinessPartnerState extends State<BusinessPartner> {
  // Screen Load Event
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formField = GlobalKey<FormState>();
  List typeList = [];
  DropdownModel selectedTyp = DropdownModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          // elevation: 0,
          title: const Text('Business Partner'),
          actions: [
            IconButton(
                onPressed: () {
                  // save();
                },
                icon: const Icon(Icons.clear)),
            IconButton(
              onPressed: () {
                save();
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formField,
              child: Column(
                children: [
                  Row(children: const [
                    Expanded(child: Divider()),
                    Text("IDENTITY"),
                    Expanded(child: Divider()),
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: UserTextFormField.textBox(
                            controller,
                            'Enter pan no *',
                            'Please PAN No',
                            Icons.credit_card,
                            'Please enter pan no',
                            true),
                        // TextField(
                        //   decoration: InputDecoration(
                        //     icon: Icon(Icons.credit_card),
                        //     label: Text("Enter pan no"),
                        //     //border: OutlineInputBorder(),
                        //     border: InputBorder.none,
                        //     hintText: 'Please PAN No',
                        //   ),
                        // ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload pan card'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 14,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CardNumberFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          // inputFormatters: [
                          // ],
                          decoration: const InputDecoration(
                            counterText: "",
                            icon: Icon(Icons.card_membership_outlined),
                            label: Text("Aadhar card"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Please Enter Adhar No',
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload aadhar card'),
                      ),
                    ],
                  ),
                  Row(children: const [
                    Expanded(child: Divider()),
                    Text("BANK ACCOUNT DETAILS"),
                    Expanded(child: Divider()),
                  ]),
                  Row(
                    children: const [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person_outline),
                            label: Text("Account holder name"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter account name',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: UserTextFormField.textBox(
                            controller,
                            'Bank name',
                            'Please enter bank name',
                            Icons.business,
                            'Please enter bank name',
                            true),
                        // TextField(
                        //   decoration: InputDecoration(
                        //     icon: Icon(Icons.business),
                        //     label: Text("Bank Name"),
                        //     //border: OutlineInputBorder(),
                        //     border: InputBorder.none,
                        //     hintText: 'Select Bank Name',
                        //   ),
                        // ),
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            label: Text("Ac. Type"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Please Account Type',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock_outline_rounded),
                            label: Text("Account No."),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Bank account no',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock_outline_rounded),
                            label: Text("Retype account no."),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Retype account',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: UserTextFormField.textBox(
                            controller,
                            'IFSC Code',
                            'Bank Ifsc code',
                            Icons.balcony_outlined,
                            'Please enter ifsc code',
                            true),
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.picture_as_pdf),
                      //   tooltip: 'Cancel cheque attachment',
                      //   onPressed: () {},
                      // ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload cancel cheque'),
                      )
                    ],
                  ),
                  Row(children: const [
                    Expanded(child: Divider()),
                    Text("CONTACT / ADDRESS DETAILS"),
                    Expanded(child: Divider()),
                  ]),
                  Row(
                    children: const [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.email_outlined),
                            label: Text("Email"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter email id',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            icon: Icon(Icons.mobile_friendly),
                            label: Text("Mobile"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter primary Mobile',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.text_fields_outlined),
                            label: Text("Address Line 1"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter Address Line 1',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.text_fields_outlined),
                            label: Text("Address Line 2"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter Address Line 2',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.masks_sharp),
                            label: Text("Landmark"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter landmark',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.code),
                            label: Text("Pincode"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter Pincode',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<DropdownModel>(
                            // validator: (value) =>
                            //     value == null ? 'Please select any type' : null,
                            hint: const Padding(
                              padding: EdgeInsets.only(
                                left: 11.0,
                              ),
                              child: Text('Country'),
                            ),
                            isExpanded: false,
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
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<DropdownModel>(
                            // validator: (value) =>
                            //     value == null ? 'Please select any type' : null,
                            hint: const Padding(
                              padding: EdgeInsets.only(
                                left: 11.0,
                              ),
                              child: Text('State'),
                            ),
                            isExpanded: false,
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
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<DropdownModel>(
                            // validator: (value) =>
                            //     value == null ? 'Please select any type' : null,
                            hint: const Padding(
                              padding: EdgeInsets.only(
                                left: 11.0,
                              ),
                              child: Text('City'),
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
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.email_outlined),
                            label: Text("Email"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter Email',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  save() {
    if (formField.currentState!.validate()) {}
  }
}
