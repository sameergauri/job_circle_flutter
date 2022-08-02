import 'package:flutter/material.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/typography.dart';

class PostLogin extends StatefulWidget {
  const PostLogin({Key? key}) : super(key: key);

  @override
  State<PostLogin> createState() => _PostLoginState();
}

class _PostLoginState extends State<PostLogin> {
  bool isManual = false;

  int jobseeker = 1;

  int graduateActive = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 160.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).primaryColor, spreadRadius: 3),
                  ],
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              TypographyStyle.textH3(
                  "Select one of the option before you proceed.", Colors.black),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Utils.setPreference(
                            null,
                            ESharedPreferences.user_type.name,
                            EUserType.jobSeeker.value);
                        Utils.setCacheData(
                            "usertype", EUserType.jobSeeker.value);
                        Navigator.pushNamed(context, ERoute.screen1.value);
                        // showDatePicker(
                        //     context: context,
                        //     initialDate: DateTime.now(),
                        //     firstDate: DateTime.now(),
                        //     lastDate: DateTime.now().add(Duration(days: 1)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: Theme.of(context).primaryColor),
                        height: 100,
                        width: 160,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.find_in_page_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "JOB SEEKER",
                                  style: TextStyle(color: Colors.white),
                                )
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Utils.setPreference(
                            null,
                            ESharedPreferences.user_type.name,
                            EUserType.businessPartner.value);
                        Utils.setCacheData(
                            "usertype", EUserType.businessPartner.value);
                        Navigator.pushNamed(
                            context, ERoute.businesspartner_confirmation.name);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: Theme.of(context).primaryColor),
                        height: 100,
                        width: 160,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.handshake_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "BUSINESS PARTNER",
                                  style: TextStyle(color: Colors.white),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Color.fromARGB(255, 149, 149, 149),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextButton(
                    onPressed: () => {
                          Future.delayed(const Duration(seconds: 0), () async {
                            await AppUtils.clearSession();
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                ERoute.login.value,
                                (Route<dynamic> route) => false);
                            // Navigator.pushReplacementNamed(context, nextRoute.value);
                          })
                        },
                    child: const Text(
                      "Sign Out",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    )),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 110,
                height: 170,
                child: Container(
                  height: 170,
                  width: 170,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/images/job-logo.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -6),
                          color: Color(0xffce3538),
                          spreadRadius: 2,
                          blurStyle: BlurStyle.inner,
                          blurRadius: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Material(
          child: Column(
            children: [
              // const SizedBox(height: 16),
              // _buildImage(),
            ],
          ),
        ),
      ),
    );
  }
}
