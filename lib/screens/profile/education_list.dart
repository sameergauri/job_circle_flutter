import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/screen2.dart';
import 'package:job_circle/themes/colors.dart';

class EducationList extends StatefulWidget {
  EducationList({
    super.key,
    this.prevPageModel,
    this.educationList,
    required this.profileskill,
    required this.userid
  });
  late EducationDetail? prevPageModel;
  late List<EducationDetail>? educationList;
   final int userid;
  final List<String> profileskill;

  @override
  State<EducationList> createState() => _EducationListState();
}

class _EducationListState extends State<EducationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Constants.borderColor,
        elevation: 0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const OnboardingTitle(
          title: "Education",
        ),
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(child: CustomBody()),
    );
  }

  Widget CustomBody() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.educationList?.length,
          itemBuilder: (context, index) {
            final data = widget.educationList?[index];
            return Column(
              children: [
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                  leading: SizedBox(
                      width: 70.w,
                      height: 70.h,
                      child: data!.icon != null
                          ? Image.network(
                              "${GlobalConstants.Image_url}${data.icon.toString()}",
                              fit: BoxFit.contain,
                              // color: Constants.themeBgColor,
                            )
                          : Image.asset(
                              "assets/images/education_d.png",
                              fit: BoxFit.contain,
                            )),
                  title: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextForWeather(
                          title:
                              "${data.degree_spc.toString()} in ${data.fieldOfStudy.toString()}",
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        customTextForMonst(
                          title: data.university.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  subtitle: customTextForMonst(
                    title: data.educationPeriod.toString(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    color: Constants.subtitleclr,
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Screen2(
                                  profileskill: widget.profileskill,
                                  userid: widget.userid,
                                      edulength: widget.educationList!.length,
                                      isEdit: true,
                                      isFirst: false,
                                      educationList: [data],
                                      prevPageModel: data,
                                      underGraduate: false,
                                    )));
                      },
                      icon: Image.asset(
                        "assets/images/pencil.png",
                        height: 20.h,
                      )),
                ),
                const Divider(
                  thickness: 1.0,
                )
              ],
            );
          },
        ));
  }
}
