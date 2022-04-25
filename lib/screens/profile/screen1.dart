import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/profile/screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late Widget previousWidget;

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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Screen2()));
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
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 208, 208, 208),
                              blurRadius: 10.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                          color: Color(0xfffef1e9),
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
                          const SizedBox(
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
                                  basicInfo(),
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
      key: const Key('second'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  label: Text("Enter your name"),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: 'Please enter first and last name',
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.location_city),
                  label: Text("Job City"),
                  // border: OutlineInputBorder(),
                  hintText: 'Enter Job city',
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.maps_home_work),
                  label: Text("Job Location"),
                  //border: OutlineInputBorder(),
                  hintText: 'Enter Job Location',
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.phone_android),
                  label: Text("Mobile Number"),
                  //border: OutlineInputBorder(),
                  hintText: 'Enter Mobile Number',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 150.0,
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.green,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/male.png',
                              scale: 11,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: "MALE",
                                  groupValue: "1",
                                  onChanged: (value) {
                                    // setState(() {
                                    //   _site = value;
                                    // });
                                  },
                                ),
                                const Text(
                                  "MALE",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 100,
                    width: 150.0,
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.green,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/female.png',
                              scale: 11,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: "FEMALE",
                                  groupValue: "1",
                                  onChanged: (value) {
                                    // setState(() {
                                    //   _site = value;
                                    // });
                                  },
                                ),
                                const Text(
                                  "FEMALE",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
