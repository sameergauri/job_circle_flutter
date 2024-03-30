// ignore_for_file: unnecessary_null_comparison, unused_local_variable, non_constant_identifier_names
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/contact_us_model.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

final fetchContactUsInfo = FutureProvider<ContactUsModel>(
    (ref) => _ContactUSState.fetchContactUsFun());

/* final fetchContactUsInfo = FutureProvider<ContactUsModel>((ref) async {
  // Use await to ensure the Future completes before returning
  final contactUsModel = await _ContactUSState.fetchContactUsFun();

  // Use the null-aware operator to provide a default value if contactUsModel is null
  return contactUsModel ?? ContactUsModel(/* provide default values here */);
}); */

class ContactUS extends ConsumerStatefulWidget {
  const ContactUS({super.key});

  @override
  ConsumerState<ContactUS> createState() => _ContactUSState();
}

class _ContactUSState extends ConsumerState<ContactUS> {
  //TODO:: Fetch data api function..
  //
  //
  //
  //
  //
  static Future<ContactUsModel> fetchContactUsFun() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/reportTo/$userid');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final Map<String, dynamic> data = jsonData['resultData'];

        if (data != null) {
          return ContactUsModel.fromJson(data);
        } else {
          throw Exception('Result data is null');
        }
      } else {
        throw Exception('Failed to load report data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while fetching data: $e');
    }
  }
  //
  //
  //
  //
  //

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var ContactUsData = ref.watch(fetchContactUsInfo);
    return ContactUsData != null
        ? ContactUsData.when(data: (data) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text("Level 1",
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.sp)),
                backgroundColor: Constants.blue,
                elevation: 0,
              ),
              body: Column(
                children: [
                  if (data.firstName != null)
                    Container(
                      // height: 300,
                      margin: const EdgeInsets.only(),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Constants.blue,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0.5, 2),
                                blurRadius: 2,
                                spreadRadius: 2,
                                color: Colors.grey.shade200)
                          ],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Constants.borderColor,
                                radius: height / 17.r,
                                child: CircleAvatar(
                                    backgroundColor: Constants.themeBgColor,
                                    radius: height / 18.r,
                                    backgroundImage: data.profilePic != null
                                        ? Image.network(
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profilePic}",
                                            fit: BoxFit.fill,
                                          ).image
                                        : Image.asset(
                                            data.gender != "Male"
                                                ? "assets/images/leadfemal.png"
                                                : "assets/images/leadmale.png",
                                            //  height: 8.h,
                                            fit: BoxFit.fill,
                                          ).image),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.sp,
                          ),
                          Text("Sourcing Manager",
                              style: GoogleFonts.varela(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white)),
                          Text(
                              "${data.firstName.toString()} ${data.lastName.toString()}",
                              style: GoogleFonts.varela(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20.sp)),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    FlutterPhoneDirectCaller.callNumber(
                                        "+91${data.officialNo}");
                                  },
                                  icon: const Icon(Icons.phone,
                                      color: Colors.white)),
                              IconButton(
                                  onPressed: () async {
                                    Uri url = Uri.parse(
                                        "whatsapp://send?phone=91${data.officialNo}");
                                    await canLaunchUrl(url)
                                        ? await launchUrl(url)
                                        : throw "could not launch $url";
                                  },
                                  icon: Image.asset(
                                    "assets/images/whatsapp.png",
                                    color: Colors.white,
                                    height: 25.sp,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    await launchUrl(Uri.parse(
                                        "mailto:${data.officialEmail}?"));
                                  },
                                  icon: Image.asset(
                                    "assets/images/email.png",
                                    color: Colors.white,
                                    height: 25.sp,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  //const Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Constants.blue,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0.5, 2),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.grey.shade200)
                        ],
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Any Escalation${data.firstName != null ? " yam(Level 2)" : ""}",
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 24.sp))
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await launchUrl(
                                Uri.parse("mailto:rahul@jobcirlce.co.in?"));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/email.png",
                                color: Colors.white,
                                height: 25.sp,
                              ),
                              SizedBox(
                                width: 4.sp,
                              ),
                              Text(
                                "rahul@jobcirlce.co.in",
                                style: GoogleFonts.varela(
                                    color: Colors.white, fontSize: 16.sp),
                              ),
                              SizedBox(
                                width: 4.sp,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.sp,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }, error: (error, stackTrace) {
            return const Scaffold(
              body: Center(
                child: Text("Error while fetching the data"),
              ),
            );
          }, loading: () {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          })
        : const Scaffold(
            body: Center(
              child: Text("No Data Found"),
            ),
          );
  }
}
