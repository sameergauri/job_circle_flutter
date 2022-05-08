import 'package:flutter/material.dart';
import 'package:job_circle/components/smart_card.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/card_model.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  int _widgetId = 2;
  late Widget previousWidget;
  late TextEditingController educationController = TextEditingController();
  CardModel model = CardModel();
  
  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    model.cardName = preferences.getString('username');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/education.png",
                height: 30,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Education",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Constants.bgPanelColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ThemeButton(
              icon: const Icon(
                Icons.arrow_forward,
                color: Color(0xffffffff),
                size: 25,
              ),
              radious: 0,
              onPressed: () {
                Navigator.pushNamed(context, ERoute.screen3.name);
              },
              text: "NEXT",
              themeButtonSize: ThemeButtonSize.medium,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SmartCard(model: model),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 39, 39, 39),
                              blurRadius: 17.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                          color: Constants.bgPanelColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  _education(),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _education() {
    return Container(
      key: const Key('second'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Autocomplete(fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  onEditingComplete: onFieldSubmitted,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    icon: Icon(Icons.workspace_premium),
                    label: Text("Degree/Specialization"),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Enter lated one',
                  ),
                );
              }, optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<PopupMenuItem> onSelected,
                  Iterable<PopupMenuItem> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: SizedBox(
                      width: 300,
                      child: ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PopupMenuItem option = options.elementAt(index);

                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(option.value['display'],
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }, optionsBuilder: (TextEditingValue textEditingValue) {
                return [
                  {
                    "display": "Graduate",
                    "value": "",
                  },
                  {
                    "display": "HSC",
                    "value": "",
                  },
                  {
                    "display": "SSC",
                    "value": "Climbing",
                  }
                ]
                    .map<PopupMenuItem<Map<String, String>>>((value) {
                      return PopupMenuItem(
                          child: Text(value['display'].toString()),
                          value: value);
                    })
                    .where((PopupMenuItem county) => county.value['display']
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase()))
                    .toList();
              }),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.school),
                  label: Text("Degree/Specialization"),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: 'Enter lated one',
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.location_city),
                  label: Text("Univercity / Institute"),
                  // border: OutlineInputBorder(),
                  hintText: 'Enter Univercity / Institutre name',
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
