// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/service/partnerService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../components/autocompletecustom.dart';
import '../../components/card_number_formatter.dart';
import '../../components/common.dart';
import '../../models/autocomplete.dart';
import '../../models/autocompleteModel.dart';
import '../../models/businesspartnerModel.dart';
import '../../models/profileSummary.dart';
import '../../service/FileUploadService.dart';
import '../../service/UserDataService.dart';

class BusinessPartner extends StatefulWidget {
  const BusinessPartner({Key? key}) : super(key: key);

  @override
  State<BusinessPartner> createState() => _BusinessPartnerState();
}

class _BusinessPartnerState extends State<BusinessPartner> {
  // Screen Load Event
  int businessid = 0;
  final TextEditingController panno = TextEditingController();
  final TextEditingController adharno = TextEditingController();
  final TextEditingController acholdername = TextEditingController();
  final TextEditingController bankname = TextEditingController();
  final TextEditingController actype = TextEditingController();
  final TextEditingController acno = TextEditingController();
  final TextEditingController reacno = TextEditingController();
  final TextEditingController ifsccode = TextEditingController();
  final TextEditingController emailid = TextEditingController();
  final TextEditingController mobno = TextEditingController();
  final TextEditingController adr1 = TextEditingController();
  final TextEditingController adr2 = TextEditingController();
  final TextEditingController landmark = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController levelmobno1 = TextEditingController();
  final TextEditingController levelemail1 = TextEditingController();
  final TextEditingController levelmobno2 = TextEditingController();
  final TextEditingController levelemail2 = TextEditingController();
  final GlobalKey<FormState> formField = GlobalKey<FormState>();

  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  var profile_final_pic = "";
  var profile_cv_link = "";
  var profile_cv_file = "";

  //Upload Veriable
  BusinessPartnerFileUploadModel filemodel = BusinessPartnerFileUploadModel();

  // Auto Completed Dropdown
  late List<AutoCompleteModel> countryList = [];
  AutoCompleteModel selectedCountry = AutoCompleteModel("", "", {});

  late List<AutoCompleteModel> stateList = [];
  AutoCompleteModel selectedState = AutoCompleteModel("", "", {});

  late List<AutoCompleteModel> cityList = [];
  AutoCompleteModel selectedCity = AutoCompleteModel("", "", {});

  List typeList = [];
  DropdownModel selectedTyp = DropdownModel();
  var ddlValues;
  dynamic addressDetails;
  dynamic escalationDesk;

  @override
  void initState() {
    getCountryList();
    getStateList();
    getCityList();
    getPartnerDetails();
    super.initState();
  }

  getPartnerDetails() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    int userid =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    var result = await PartnerService().getPartnerUser(userid);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      if (ddlValues != null) {
        businessid = ddlValues['id'];
        panno.text = ddlValues['panNo'].toString();
        adharno.text = ddlValues['aadhaarno'].toString();
        acholdername.text = ddlValues['bankAccHolderName'].toString();
        bankname.text = ddlValues['bankName'].toString();
        actype.text = ddlValues['bankAccType'].toString();
        ifsccode.text = ddlValues['bankIFSC'].toString();
        acno.text = ddlValues['bankAccNo'].toString();
        reacno.text = ddlValues['bankAccNo'].toString();
        addressDetails = jsonDecode(ddlValues['addressDetails']);
        emailid.text = addressDetails['email'].toString();
        pincode.text = addressDetails['pincode'].toString();
        landmark.text = addressDetails['landmark'].toString();
        mobno.text = addressDetails['mobileNo'].toString();
        adr1.text = addressDetails['addressLine1'].toString();
        adr2.text = addressDetails['addressLine2'].toString();
        selectedCountry = AutoCompleteModel(
            addressDetails['countryId'].toString(),
            addressDetails['country'].toString(), {});
        selectedState = AutoCompleteModel(addressDetails['stateId'].toString(),
            addressDetails['state'].toString(), {});
        selectedCity = AutoCompleteModel(addressDetails['cityId'].toString(),
            addressDetails['city'].toString(), {});
        escalationDesk = jsonDecode(ddlValues['escalationDesk']);
        levelmobno1.text = escalationDesk[0]['mobileNo'].toString();
        levelemail1.text = escalationDesk[0]['emailAddress'].toString();

        filemodel.panCardLink = ddlValues['panDoc'].toString();
        filemodel.panFileName = getFileName(filemodel.panCardLink);
        filemodel.panDateTime =
            DateFormat('MMM dd, yyyy').format(DateTime.now());

        filemodel.adharCardLink = ddlValues['aadhaarDoc'].toString();
        filemodel.adharCardFileName = getFileName(filemodel.adharCardLink);
        filemodel.adharCardDateTime =
            DateFormat('MMM dd, yyyy').format(DateTime.now());

        filemodel.cancelChequeLink = ddlValues['bankCancelCheckDoc'].toString();
        filemodel.cancelChequeFileName = getFileName(filemodel.adharCardLink);
        filemodel.cancelChequeDateTime =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else {
        // Navigator.pop(context);
      }
    } else {
      // Navigator.pop(context);
    }
    setState(() {});
  }

  getCountryList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'country', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      countryList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();
    }
    setState(() {});
  }

  getStateList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'state', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      stateList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();
    }
    setState(() {});
  }

  getCityList() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'city', 'pageNumber': '1', 'pageSize': '10'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      cityList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Business Partner'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formField,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: ThemeButton(
                            width: 100,
                            radious: 100,
                            onPressed: () async {
                              var data = await uploadFile(['jpeg', 'jpg']);
                              var payload = {
                                "stage": "profile_pic",
                                "data": {
                                  "id": await Utils.getPreferencesValue(
                                      null, ESharedPreferences.user_id.name),
                                  "profile_pic": data['fileName']
                                }
                              };
                              await saveFile(
                                  data['fileName'], payload, 'profile_pic');
                            },
                            text: "EDIT",
                            themeButtonSize: ThemeButtonSize.xsmall,
                          ),
                        ),
                        backgroundImage: const NetworkImage(
                          "https://cdn1.iconfinder.com/data/icons/avatars-1-5/136/87-512.png",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: const [
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                    Text(
                      "IDENTITY",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: UserTextFormField.textBox(
                            panno,
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
                      // TextButton.icon(
                      //   onPressed: () async {
                      //     var data = await uploadFile(['pdf']);
                      //     var payload = {
                      //       "stage": "upload_cv",
                      //       "data": {
                      //         "id": await Utils.getPreferencesValue(
                      //             null, ESharedPreferences.user_id.name),
                      //         "cv_link": data['fileName']
                      //       }
                      //     };
                      //     await saveFile(data['fileName'], payload);
                      //   },
                      //   icon: const Icon(Icons.upload),
                      //   label: const Text('Upload pan card'),
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: uploadCV('pandcard', filemodel.panCardLink,
                              filemodel.panFileName, filemodel.panDateTime))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter adhar no';
                            }
                            return null;
                          },
                          controller: adharno,
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
                            label: Text("Aadhar card *"),
                            border: InputBorder.none,
                            hintText: 'Please Enter Adhar No',
                          ),
                        ),
                      ),
                      // TextButton.icon(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.upload),
                      //   label: const Text('Upload aadhar card'),
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: uploadCV(
                              'adharcard',
                              filemodel.adharCardLink,
                              filemodel.adharCardFileName,
                              filemodel.adharCardDateTime))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: const [
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                    Text(
                      "BANK ACCOUNT DETAILS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter holder name';
                            }
                            return null;
                          },
                          controller: acholdername,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person_outline),
                            label: Text("Account holder name *"),
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
                            bankname,
                            'Bank name *',
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
                      Expanded(
                        child: TextFormField(
                          controller: actype,
                          decoration: const InputDecoration(
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
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account no';
                            }
                            return null;
                          },
                          controller: acno,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock_outline_rounded),
                            label: Text("Account No. *"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Bank account no',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter retype account no';
                            }
                            return null;
                          },
                          controller: reacno,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock_outline_rounded),
                            label: Text("Retype account no. *"),
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
                            ifsccode,
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
                      // TextButton.icon(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.upload),
                      //   label: const Text('Upload cancel cheque'),
                      // )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: uploadCV(
                              'cancelChq',
                              filemodel.cancelChequeLink,
                              filemodel.cancelChequeFileName,
                              filemodel.cancelChequeDateTime))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: const [
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                    Text("CONTACT / ADDRESS DETAILS"),
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: emailid,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email_outlined),
                            label: Text("Email"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter email id',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: mobno,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
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
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: adr1,
                          decoration: const InputDecoration(
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
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: adr2,
                          decoration: const InputDecoration(
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
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: landmark,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.masks_sharp),
                            label: Text("Landmark"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter landmark',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: pincode,
                          decoration: const InputDecoration(
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
                        child: CustomControls.AutoCompleteCustom(
                          context,
                          "Country",
                          "Select Country",
                          ((AutoCompleteModel item) => {
                                setState(() {
                                  selectedCountry = item;
                                }),
                                // print(selectedLocation.label),
                              }),
                          selectedCountry,
                          countryList,
                          Icons.location_city,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty && !value.contains(' ')) {
                              return 'Please select any country';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Expanded(
                      //     child: Autocomplete(fieldViewBuilder: (BuildContext
                      //             context,
                      //         TextEditingController fieldTextEditingController,
                      //         FocusNode fieldFocusNode,
                      //         VoidCallback onFieldSubmitted) {
                      //   return TextField(
                      //     controller: fieldTextEditingController,
                      //     focusNode: fieldFocusNode,
                      //     onEditingComplete: onFieldSubmitted,
                      //     decoration: const InputDecoration(
                      //       suffixIcon: Icon(Icons.arrow_drop_down),
                      //       icon: Icon(Icons.workspace_premium),
                      //       label: Text("Country"),
                      //       //border: OutlineInputBorder(),
                      //       border: InputBorder.none,
                      //       hintText: 'Select Country',
                      //     ),
                      //   );
                      // }, optionsViewBuilder: (BuildContext context,
                      //         AutocompleteOnSelected<PopupMenuItem> onSelected,
                      //         Iterable<PopupMenuItem> options) {
                      //   return Align(
                      //     alignment: Alignment.topLeft,
                      //     child: Material(
                      //       child: SizedBox(
                      //         width: 300,
                      //         child: ListView.builder(
                      //           padding: EdgeInsets.all(10.0),
                      //           itemCount: options.length,
                      //           itemBuilder: (BuildContext context, int index) {
                      //             final PopupMenuItem option =
                      //                 options.elementAt(index);

                      //             return GestureDetector(
                      //               onTap: () {
                      //                 onSelected(option);
                      //               },
                      //               child: ListTile(
                      //                 title: Text(option.value['display'],
                      //                     style: const TextStyle(
                      //                         color: Colors.black)),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // }, optionsBuilder: (TextEditingValue textEditingValue) {
                      //   return [
                      //     {
                      //       "display": "India",
                      //       "value": "India",
                      //     }
                      //   ]
                      //       .map<PopupMenuItem<Map<String, String>>>((value) {
                      //         return PopupMenuItem(
                      //             child: Text(value['display'].toString()),
                      //             value: value);
                      //       })
                      //       .where((PopupMenuItem county) => county
                      //           .value['display']
                      //           .toLowerCase()
                      //           .startsWith(
                      //               textEditingValue.text.toLowerCase()))
                      //       .toList();
                      // })),

                      Expanded(
                        child: CustomControls.AutoCompleteCustom(
                          context,
                          "State",
                          "Select State",
                          ((AutoCompleteModel item) => {
                                setState(() {
                                  selectedState = item;
                                }),
                                // print(selectedLocation.label),
                              }),
                          selectedState,
                          stateList,
                          Icons.workspace_premium,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty && !value.contains(' ')) {
                              return 'Please select any state';
                            }
                            return null;
                          },
                        ),
                        //Autocomplete(fieldViewBuilder: (BuildContext
                        //         context,
                        //     TextEditingController fieldTextEditingController,
                        //     FocusNode fieldFocusNode,
                        //     VoidCallback onFieldSubmitted) {
                        //   return TextField(
                        //     controller: fieldTextEditingController,
                        //     focusNode: fieldFocusNode,
                        //     onEditingComplete: onFieldSubmitted,
                        //     decoration: const InputDecoration(
                        //       suffixIcon: Icon(Icons.arrow_drop_down),
                        //       icon: Icon(Icons.workspace_premium),
                        //       label: Text("State"),
                        //       //border: OutlineInputBorder(),
                        //       border: InputBorder.none,
                        //       hintText: 'Select State',
                        //     ),
                        //   );
                        // }, optionsViewBuilder: (BuildContext context,
                        //     AutocompleteOnSelected<PopupMenuItem> onSelected,
                        //     Iterable<PopupMenuItem> options) {
                        //   return Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Material(
                        //       child: SizedBox(
                        //         width: 300,
                        //         child: ListView.builder(
                        //           padding: EdgeInsets.all(10.0),
                        //           itemCount: options.length,
                        //           itemBuilder:
                        //               (BuildContext context, int index) {
                        //             final PopupMenuItem option =
                        //                 options.elementAt(index);

                        //             return GestureDetector(
                        //               onTap: () {
                        //                 onSelected(option);
                        //               },
                        //               child: ListTile(
                        //                 title: Text(option.value['display'],
                        //                     style: const TextStyle(
                        //                         color: Colors.black)),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }, optionsBuilder: (TextEditingValue textEditingValue) {
                        //   return [
                        //     {
                        //       "display": "India",
                        //       "value": "India",
                        //     }
                        //   ]
                        //       .map<PopupMenuItem<Map<String, String>>>((value) {
                        //         return PopupMenuItem(
                        //             child: Text(value['display'].toString()),
                        //             value: value);
                        //       })
                        //       .where((PopupMenuItem county) => county
                        //           .value['display']
                        //           .toLowerCase()
                        //           .startsWith(
                        //               textEditingValue.text.toLowerCase()))
                        //       .toList();
                        // }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomControls.AutoCompleteCustom(
                          context,
                          "City",
                          "Select City",
                          ((AutoCompleteModel item) => {
                                setState(() {
                                  selectedCity = item;
                                }),
                                // print(selectedLocation.label),
                              }),
                          selectedCity,
                          cityList,
                          Icons.workspace_premium,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty && !value.contains(' ')) {
                              return 'Please select any city';
                            }
                            return null;
                          },
                        ),
                        //Autocomplete(fieldViewBuilder: (BuildContext
                        //             context,
                        //         TextEditingController fieldTextEditingController,
                        //         FocusNode fieldFocusNode,
                        //         VoidCallback onFieldSubmitted) {
                        //   return TextField(
                        //     controller: fieldTextEditingController,
                        //     focusNode: fieldFocusNode,
                        //     onEditingComplete: onFieldSubmitted,
                        //     decoration: const InputDecoration(
                        //       suffixIcon: Icon(Icons.arrow_drop_down),
                        //       icon: Icon(Icons.workspace_premium),
                        //       label: Text("City"),
                        //       //border: OutlineInputBorder(),
                        //       border: InputBorder.none,
                        //       hintText: 'Select City',
                        //     ),
                        //   );
                        // }, optionsViewBuilder: (BuildContext context,
                        //         AutocompleteOnSelected<PopupMenuItem> onSelected,
                        //         Iterable<PopupMenuItem> options) {
                        //   return Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Material(
                        //       child: SizedBox(
                        //         width: 300,
                        //         child: ListView.builder(
                        //           padding: EdgeInsets.all(10.0),
                        //           itemCount: options.length,
                        //           itemBuilder: (BuildContext context, int index) {
                        //             final PopupMenuItem option =
                        //                 options.elementAt(index);

                        //             return GestureDetector(
                        //               onTap: () {
                        //                 onSelected(option);
                        //               },
                        //               child: ListTile(
                        //                 title: Text(option.value['display'],
                        //                     style: const TextStyle(
                        //                         color: Colors.black)),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }, optionsBuilder: (TextEditingValue textEditingValue) {
                        //   return [
                        //     {
                        //       "display": "India",
                        //       "value": "India",
                        //     }
                        //   ]
                        //       .map<PopupMenuItem<Map<String, String>>>((value) {
                        //         return PopupMenuItem(
                        //             child: Text(value['display'].toString()),
                        //             value: value);
                        //       })
                        //       .where((PopupMenuItem county) => county
                        //           .value['display']
                        //           .toLowerCase()
                        //           .startsWith(
                        //               textEditingValue.text.toLowerCase()))
                        //       .toList();
                        // }),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: const [
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                    Text(
                      "ESCALATION DESK",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: const [
                    Text("Level1"),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: levelmobno1,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.mobile_friendly),
                            label: Text("Mobile"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter primary Mobile',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: levelemail1,
                          decoration: const InputDecoration(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: const [
                    Text("Level2"),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: levelmobno2,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.mobile_friendly),
                            label: Text("Mobile"),
                            //border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: 'Enter primary Mobile',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: levelemail2,
                          decoration: const InputDecoration(
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
                  const SizedBox(
                    height: 30,
                  ),
                  ThemeButton(
                    width: 200,
                    radious: 0,
                    onPressed: () {
                      save();
                    },
                    text: "SUBMIT",
                    themeButtonSize: ThemeButtonSize.small,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //

  save() async {
    if (formField.currentState!.validate()) {
      SharedPreferences prefs = await Utils.getSharedPreferences();
      var params = {
        "uid": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "aadhaarDoc": filemodel.adharCardLink,
        "aadhaarno": adharno.text,
        "addressDetail": {
          "addressLine1": adr1.text,
          "addressLine2": adr2.text,
          "city": selectedCity.label,
          "cityId": selectedCity.value,
          "country": selectedCountry.label,
          "countryId": selectedCountry.value,
          "email": emailid.text,
          "landmark": landmark.text,
          "mobileNo": mobno.text,
          "pincode": pincode.text,
          "state": selectedState.label,
          "stateId": selectedState.value
        },
        "bankAccHolderName": acholdername.text,
        "bankAccNo": acno.text,
        "bankAccType": actype.text,
        "bankCancelCheckDoc": filemodel.cancelChequeLink,
        "bankIFSC": ifsccode.text,
        "bankName": bankname.text,
        "escalationDesks": [
          {
            "emailAddress": levelemail1.text,
            "level": "string",
            "mobileNo": levelmobno1.text,
            "name": "string"
          }
        ],
        "id": businessid,
        "panDoc": filemodel.panCardLink,
        "panNo": panno.text,
        "profilepic": profilemodel.profile_pic
      };
      showLoaderDialog(context);
      var result = await PartnerService().savePartner(params);
      if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
        var returnData = Utils.parseResponse(result).resultData;
        businessid = returnData['id'];
        Navigator.pop(context);
        const SnackBar(
          content: Text('Data Save Successfully'),
          // action: SnackBarAction(
          //   label: 'Undo',
          //   onPressed: () {
          //     // Some code to undo the change.
          //   },
          // ),
        );
        setState(() {});
      } else {
        Navigator.pop(context);
      }
    }
  }

  uploadFile(allowExt) async {
    showLoaderDialog(context);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowExt,
        withReadStream: true);

    if (result != null) {
      var res =
          await FileUploadService().uploadSingleFile("cv", result.files.single);
      var resultD = Utils.parseResponse(res);
      Navigator.pop(context);
      if (resultD.resultKey == 'SUCCESS') {
        return resultD.resultData[0];
      }
      // File file = File(result.files.single.readStream.first!);
    } else {
      return null;
      // User canceled the picker
    }
    Navigator.pop(context);
  }

  showLoaderDialog(BuildContext context) {
    // const spinkit = SpinKitRotatingCircle(
    //   color: Colors.white,
    //   size: 50.0,
    // );
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  saveFile(filePath, data, typeOfuplaod) async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'profile_pic') {
        profilemodel.profile_pic = filePath;
        profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      } else if (data['stage'] == 'upload_cv') {
        String pathOfFile = filePath;
        if (typeOfuplaod == 'pandcard') {
          // filemodel.panCardLink = Utils.resolveImage(pathOfFile);
          filemodel.panCardLink = pathOfFile;
          filemodel.panFileName = getFileName(filemodel.panCardLink);
          filemodel.panDateTime =
              DateFormat('MMM dd, yyyy').format(DateTime.now());
        } else if (typeOfuplaod == 'adharcard') {
          // filemodel.adharCardLink = Utils.resolveImage(pathOfFile);
          filemodel.adharCardLink = pathOfFile;
          filemodel.adharCardFileName = getFileName(filemodel.adharCardLink);
          filemodel.adharCardDateTime =
              DateFormat('MMM dd, yyyy').format(DateTime.now());
        } else {
          // filemodel.cancelChequeLink = Utils.resolveImage(pathOfFile);
          filemodel.cancelChequeLink = pathOfFile;
          filemodel.cancelChequeFileName =
              getFileName(filemodel.cancelChequeLink);
          filemodel.cancelChequeDateTime =
              DateFormat('MMM dd, yyyy').format(DateTime.now());
        }
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }

  getFileName(fileName) {
    if (fileName == null) return "";
    var fileNamea = "";
    var extention = "";
    try {
      var index = fileName.lastIndexOf("_");
      fileNamea = fileName.substring(fileName.lastIndexOf("/") + 1, index);
      extention = Utils.getExtention(fileName);
    } catch (ex) {}
    return fileNamea + extention;
  }

  Widget uploadCV(String typeOfUpload, fileLink, fileName, fileDateTime) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CardCustom(
              isedit: false,
              icon: Icons.file_copy,
              title: "",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (fileLink != null && fileLink != "")
                    Image.asset('./assets/images/cv_doc.png', height: 50),
                  if (fileLink != null && fileLink != "")
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fileName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 16)),
                          Text("Last Updated On ${fileDateTime.toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14))
                        ],
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () async {
                      var data = await uploadFile(['pdf']);
                      var payload = {
                        "stage": "upload_cv",
                        "data": {
                          "id": await Utils.getPreferencesValue(
                              null, ESharedPreferences.user_id.name),
                          "cv_link": data['fileName']
                        }
                      };
                      await saveFile(data['fileName'], payload, typeOfUpload);
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card CardCustom(
      {required String title,
      IconData? icon,
      Widget? child,
      bool? isedit = true,
      Function()? onPress}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isedit == true)
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: onPress,
                          )
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 10),
            Container(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
