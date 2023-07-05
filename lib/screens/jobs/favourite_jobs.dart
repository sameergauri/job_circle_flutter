import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';

import '../../models/favorite_job_model.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  List<JobData> jobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  NumberFormat format = NumberFormat.compact();

  Future<void> fetchJobs() async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/favjob/v1/all?pageNumber=1&pageSize=100');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      final jobModel = JobModel.fromJson(data);

      setState(() {
        jobs.addAll(jobModel.resultData);
        print(jobs);
      });
    } else {
      print('Something went wrong');
      // handle error
    }
  }

  /* Future<void> fetchJobs() async {
    Uri url = Uri.parse(
        'http://192.168.1.110:9090/favjob/v1/all?pageNumber=1&pageSize=100');
    final response = await http.get(
      url,
    ); // replace with your API endpoint
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      //  var list = ;

      setState(() {
        jobs.addAll(data as List);
        print(jobs);
      });
    } else {
      print("Somthing Wrong");
      // handle error
    }
  } */

  Future<void> deleteResource(int id) async {
    final url = 'http://${GlobalConstants.API_Host_one}/favjob/v1/$id';

    final response = await http
        .delete(Uri.parse(url), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      print('Resource deleted successfully');
    } else {
      final error = jsonDecode(response.body)['error'];
      print('Failed to delete resource: $error');
    }
  }

  //Ye to list me display karna hai na?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job List'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          //   final job = jobs[index];
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var jobData = jobs[index];

              return ListTile(
                title: Text('Job ID: ${jobData.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location: ${jobData.jobDetails.location}'),
                    Text(
                        'Min Experience: ${jobData.jobDetails.minExperience ?? "N/A"}'),
                    Text(
                        'Max Experience: ${jobData.jobDetails.maxExperience ?? "N/A"}'),
                    Text('Min CTC: ${jobData.jobDetails.minCtc ?? "N/A"}'),
                    Text('Max CTC: ${jobData.jobDetails.maxCtc ?? "N/A"}'),
                    Text('Company Name: ${jobData.jobDetails.companyName}'),
                    Text('Process: ${jobData.jobDetails.process}'),
                    Text('Role Name: ${jobData.jobDetails.roleName}'),
                    if (jobData.jobDetails.skills != null)
                      Text('Skills: ${jobData.jobDetails.skills}'),
                    Text('Nature of Work: ${jobData.jobDetails.natureOfWork}'),
                  ],
                ),
              );
            },
          );

          /* ListView(
            shrinkWrap: true,
            children: [
              Text(jobs[index]['id'].toString()),
              if (jobs[index]["jobDetails"]["rolename"] != " ")
                Text(jobs[index]["jobDetails"]["rolename"]),
              Text(jobs[index]["jobDetails"]["process"]),
              ElevatedButton(
                  onPressed: () {
                    deleteResource(jobs[index]["id"]);
                  },
                  child: const Text("Delete"))
            ],
          ); */
        },
      ),
    );
  }

  Widget listViewItem_new(BuildContext context, int index, item, bool isTrue) {
    List<String>? myStrings;
    bool stopIteration = false;
    if (item['skills'] != null) {
      myStrings = item['skills'].split(",");
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        //set border radius more than 50% of height and width to make circle
      ),
      shadowColor: Constants.themeBgColor,
      elevation: 4,
      // padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['rolename'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/proces.png",
                          height: 12.h,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (item['process'] != null)
                          Text(
                            item['process'],
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          "|",
                          style: GoogleFonts.varela(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        if (item["0"] != null)
                          Text(
                            item['naturofwork'].toString(),
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500, fontSize: 14.sp),
                          )
                      ],
                    ),
                  ],
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                            /*   jobs[index]["id"].toString() ==
                                    item[index]["id"].toString() */
                            Icons.bookmark,
                            size: 18.h,
                            color: Constants.themeBgColor)),
                  ],
                )),
              ],
            ),
            /*  const SizedBox(
              height: 15,
            ),
            Text(
              item['salary'] ?? '',
              style: const GoogleFonts.varela(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 15,
            ), */
            SizedBox(
              height: 5.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  if (item['companyname'] != null) //&&
                // item['process'] != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Icon(
                        Icons.business_outlined,
                        size: 12.h,
                        color: Constants.subtitleclr,
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      item['companyname'],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.varela(
                          // color: Colors.black54,
                          color: Constants.subtitleclr,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),

                if (item["total_experience"] != null)
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/bag.png",
                        height: 10.h,
                        color: Constants.subtitleclr,
                      ),
                      SizedBox(
                        width: 4.2.w,
                      ),
                      Text(
                        item["total_experience"],
                        style: GoogleFonts.varela(
                            // color: Colors.black54,
                            color: Constants.subtitleclr,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp),
                      )
                    ],
                  ),
                SizedBox(
                  height: 2.h,
                ),

                if (item['maxctc'] != null &&
                    item['minctc'] != null &&
                    item['minctc'] != 0.0 &&
                    item['maxctc'] != 0.0)
                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: 13.h,
                        color: Constants.subtitleclr,
                      ),
                      SizedBox(
                        width: 1.8.w,
                      ),
                      Text(
                        format.format(double.parse(
                          item['minctc'].toString().replaceAll(".0", ""),
                        )),
                        style: GoogleFonts.varela(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      ),
                      const Text(" - "),
                      Text(
                        format.format(double.parse(
                          item['maxctc'].toString().replaceAll(".0", ""),
                        )),
                        style: GoogleFonts.varela(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      ),
                      const Text(" "),
                      item['ismonthly'] == true
                          ? Text(
                              "Per Year",
                              style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            )
                          : Text(
                              "Per Month",
                              style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            )
                    ],
                  ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 15,
                      color: Constants.subtitleclr,
                    ),
                    SizedBox(
                      width: 3.4.w,
                    ),
                    Text(
                      item['location'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.varela(
                        fontSize: 12.sp,
                        color: Constants.subtitleclr,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            if (myStrings != null)
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: stopIteration == false ? 3 : myStrings.length,
                      itemBuilder: (context, index) {
                        if (index == 3) {
                          stopIteration = true;
                        }
                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: Text(myStrings![index]
                                .replaceAll('"', '')
                                .replaceAll('[', '')
                                .replaceAll(']', '')));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  const Text("+2")
                ],
              ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              color: Colors.grey.shade400,
              width: double.maxFinite,
              height: 0.5.h,
            ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/verified.png",
                            height: 16.h,
                            color: Constants.themeBgColor,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            //𝘧𝘳𝘦𝘦 𝘢𝘯𝘥 𝘷𝘦𝘳𝘪𝘧𝘪𝘦𝘥 𝘑𝘰𝘣
                            "100% free and verified Job",
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500,
                                color: Constants.subtitleclr),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ERoute.application.name,
                        arguments: {
                          "isnew": false,
                          //  "prevModel": jobDetailsModel,
                          "refer": true,
                          "cmpnyname": item['companyname'].toString()
                        });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Constants.themeBgColor),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "Apply Now",
                      style: GoogleFonts.varela(
                          color: Constants.themeBgColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                /* ThemeButton(
                  color: Constants.themeBgColor,
                  width: 90.w,
                  radious: 30.r,
                  themeButtonSize: ThemeButtonSize.small,
                  onPressed: () {
                    Navigator.pushNamed(context, ERoute.application.name,
                        arguments: {
                          "isnew": false,
                          "prevModel": jobDetailsModel,
                        });
                  },
                  fontsize: 11.sp,
                  text: "Apply Now ",
                ), */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
