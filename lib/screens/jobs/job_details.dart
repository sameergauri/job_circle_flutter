import 'package:flutter/material.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({Key? key}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  ScrollController _scrollController = ScrollController();
  final Color appBgColor = Constants.themeBgColor;
  final Color appBgScrolledColor = Constants.bgPanelColor;
  late Color currentAppBarColor = appBgColor;
  late double appBarElevate = 0;
  late Color appBarIconColor = Colors.white;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.extentBefore > 0 && appBarElevate == 0) {
        appBarElevate = 3;
        setState(() {});
      } else if (_scrollController.position.extentBefore == 0 &&
          appBarElevate > 0) {
        appBarElevate = 0;
        setState(() {});
      }

      ///
      if (_scrollController.position.extentBefore > 230 &&
          currentAppBarColor == appBgColor) {
        currentAppBarColor = appBgScrolledColor;

        appBarIconColor = Colors.black;
        setState(() {});
      } else if (_scrollController.position.extentBefore <= 230 &&
          currentAppBarColor == appBgScrolledColor) {
        currentAppBarColor = appBgColor;
        appBarIconColor = Colors.white;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""),
        // bottom: const PreferredSize(
        //     child: Text(
        //       "Search New Jobs",
        //       style:
        //           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //     ),
        //     preferredSize: Size.zero),
        elevation: appBarElevate,
        backgroundColor: currentAppBarColor,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: appBarIconColor, //change your color here
        ),
        //backgroundColor: Theme.of(context).primaryColor,
        actions: [
          SizedBox(
            width: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(
                Icons.share_outlined,
                color: appBarIconColor,
              ),
              const SizedBox(
                width: 15,
              ),
              Icon(
                Icons.favorite_border_outlined,
                color: appBarIconColor,
              ),
              const SizedBox(
                width: 20,
              ),
            ]),
          ),
        ],
      ),
      backgroundColor: Constants.bgPanelColor,
      bottomNavigationBar: Container(
        color: Constants.bgPanelColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ThemeButton(
            // icon: const Icon(
            //   Icons.arrow_forward,
            //   color: Color(0xffffffff),
            //   size: 25,
            // ),
            radious: 0,
            onPressed: () {
              Navigator.pushNamed(context, ERoute.application.name);
            },
            text: "APPLY",
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 230,
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.only(top: 0),
                decoration: const BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color.fromARGB(255, 245, 245, 245),
                    //     blurRadius: 10.0,
                    //     offset: Offset(2, 2),
                    //   ),
                    // ],
                    //color: Theme.of(context).primaryColor,
                    color: Constants.themeBgColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Constants.bgPanelColor,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 213, 213, 213),
                              spreadRadius: 1),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.network(
                            'https://www.adityabirla.com/Assets/images/our-download-logo.png',
                            errorBuilder: ((context, error, stackTrace) =>
                                Image.asset("assets/images/male.png",
                                    height: 100,
                                    width: 120,
                                    fit: BoxFit.contain)),
                            height: 100,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Aditya Birla Private LTD",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "Roboto"),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "CRT(Service)",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.location_city,
                                size: 17,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Andheri",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width - 50,
                  ),
                ],
              ),
            ]),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: Constants.bgPanelColor,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: keyPair(Icons.admin_panel_settings,
                                      "Role", "Exceutive")),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: keyPair(Icons.share_location,
                                      "Work Location", "Thane-Kasarvadavali")),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          keyPair(Icons.engineering, "Key Responsiblility",
                              "-Handling renewal of ABHI Policy of existing customers on call. \n-To ensure the most efficient caller and will be responsible forachieving standard targets relating to Renewal/Persistency and service improvement."),
                          const SizedBox(
                            height: 25,
                          ),
                          keyPair(Icons.work_outline, "Eligibility",
                              "-Graduate\n-Fresher\n-Age 21-28 years.\n-English,Hindi.\n-Candidate should be from nearby Thane only."),
                          const SizedBox(
                            height: 25,
                          ),
                          keyPair(Icons.schedule, "Shift Timing",
                              "-Day Rotational\n-One day rotational Week-off"),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: keyPair(Icons.account_tree, "Process",
                                      "Renewal")),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: keyPair(Icons.grading,
                                      "Interview Rounds", "HR, TL & Manager")),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: keyPair(Icons.payments, "CTC/Inhand",
                                      "15000 / Take Home")),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: keyPair(Icons.credit_score,
                                      "Payment Clause", "90 Days")),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Column keyPair(IconData icon, String key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 17,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              key,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 1,
        )
      ],
    );
  }
}
