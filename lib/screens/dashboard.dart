import 'package:flutter/material.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _widgetId = 2;
  late Widget previousWidget;
  // List<Step> stepList() => [
  //       Step(
  //           title: const Text('Basic Info'),
  //           isActive: true,
  //           subtitle: const Text("This is subtitle"),
  //           content: Center(
  //             child: basicInfo(),
  //           )),
  //       Step(
  //           title: const Text('Education'),
  //           subtitle: const Text("This is subtitle"),
  //           content: Center(
  //             child: education(),
  //           )),
  //       Step(
  //           title: const Text('Experience'),
  //           subtitle: const Text("This is subtitle"),
  //           content: Center(
  //             child: experience(),
  //           ))
  //     ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("JOB CIRCLE"),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
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
                _widgetId += 1;
                _updateWidget(_widgetId);
              },
              text: "NEXT",
              themeButtonSize: ThemeButtonSize.large,
            ),
          ),
        ),
        backgroundColor: const Color(0xffed2738),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Card(
              //     shape: BeveledRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     elevation: 4,
              //     child: const Padding(
              //       padding: EdgeInsets.all(20.0),
              //       child: SizedBox(
              //         child: Text("teddd"),
              //         height: 50,
              //       ),
              //     )),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      //child:
                      // Card(
                      //     shape: BeveledRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     elevation: 4,
                      //     child: const Padding(
                      //       padding: EdgeInsets.all(20.0),
                      //       child: SizedBox(
                      //         child: Text("teddd"),
                      //         height: 200,
                      //       ),
                      //     )),,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Basic Info",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  _renderWidget(),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // AnimatedSwitcher(
                    //   duration: const Duration(milliseconds: 500),
                    //   switchInCurve: Curves.easeIn,
                    //   switchOutCurve: Curves.easeOut,
                    //   // child: _renderWidget(),

                    //   transitionBuilder: (child, animation) {
                    //     return SlideTransition(
                    //       position: Tween<Offset>(
                    //               begin: Offset(1.2, 0), end: Offset(0, 0))
                    //           .animate(animation),
                    //       child: child,
                    //     );
                    //   },
                    //   // layoutBuilder: (currentChild, _) {
                    //   //   return currentChild!;
                    //   // },
                    //   child: _renderWidget(),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget basicInfo() {
    return Container(
      key: Key('first'),
      width: 150,
      height: 50,
      color: Colors.teal,
      child: const Center(
        child: const Text('basic',
            style: const TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }

  Widget education() {
    return Container(
      key: const Key('second'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: const [
              TextField(
                decoration: InputDecoration(
                  label: Text("Enter your name"),
                  border: OutlineInputBorder(),
                  hintText: 'Please enter first and last name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Job City"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Job city',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Job Location"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Job Location',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Mobile Number"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Mobile Number',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Mobile Number"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Mobile Number',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Mobile Number"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Mobile Number',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Mobile Number"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Mobile Number',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Mobile Number"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Mobile Number',
                ),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }

  Widget experience() {
    return Container(
      key: Key('third'),
      width: 150,
      height: 50,
      color: Colors.teal,
      child: const Center(
        child: const Text('Experience',
            style: const TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
    ;
  }

  Widget _renderWidget() {
    switch (_widgetId) {
      case 1:
        previousWidget = basicInfo();
        break;
      case 2:
        previousWidget = education();
        break;
      case 3:
        previousWidget = experience();
        break;
      default:
        previousWidget = Container();
        break;
    }
    return previousWidget;
  }

  void _updateWidget(int id) {
    setState(() {
      _widgetId = id;
    });
  }
}
