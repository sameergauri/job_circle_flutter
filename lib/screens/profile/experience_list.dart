import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/Manager/constant/add_space_between_location.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/screen3.dart';
import 'package:job_circle/themes/colors.dart';

class ExperienceListEdit extends StatefulWidget {
  ExperienceListEdit(
      {super.key,
      this.prevPageModel,
      this.experiencelist,
      required this.skills,
      required this.userid,
      required this.profileHeadline});
  late Experience? prevPageModel;
  final List<String> skills;
  late List<Experience>? experiencelist;
  final String profileHeadline;
  final int userid;

  @override
  State<ExperienceListEdit> createState() => _ExperienceListEditState();
}

class _ExperienceListEditState extends State<ExperienceListEdit> {
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
          title: "Experience",
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
          itemCount: widget.experiencelist?.length,
          itemBuilder: (context, index) {
            final data = widget.experiencelist?[index];
            return Column(
              children: [
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                  leading: SizedBox(
                      width: 70.w,
                      height: 70.h,
                      child: data!.companyLogo != null
                          ? Image.network(
                              "${GlobalConstants.Image_url}${data.companyLogo.toString()}",
                              fit: BoxFit.contain,
                              // color: Constants.themeBgColor,
                            )
                          : Image.asset(
                              "assets/images/cmpny.png",
                              fit: BoxFit.contain,
                            )),
                  title: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextForWeather(
                          title: data.jobTitle.toString(),
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        customTextForMonst(
                          title:
                              "${data.companyName.toString()} - ${data.empType.toString()}",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextForMonst(
                        title: data.workingPeriod!
                            .split(',')
                            .map((part) => part.trim()) // Trim extra spaces
                            .toList() // Convert map to list
                            .asMap() // Convert list to map with index
                            .map((i, part) {
                              if (i == 1) {
                                // Check if it's the part after comma
                                return MapEntry(
                                    i, '($part)'); // Wrap in parentheses
                              }
                              return MapEntry(i, part); // Keep as is
                            })
                            .values
                            .join(' '),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        color: Constants.subtitleclr,
                      ),
                      customTextForMonst(
                        title: AddSpaceBetween.capitalizeWords(
                          data.jobLocation.toString(),
                        ),
                        fontSize: 12,
                        color: Constants.subtitleclr,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Screen3(
                                      userid: widget.userid,
                                      needpop: true,
                                      skills: widget.skills,
                                      profileHeadline: widget.profileHeadline,
                                      expelength: widget.experiencelist!.length,
                                      id: data.id!,
                                      experiencelist: widget.experiencelist,
                                      prevPageModel: data,
                                      isFirst: false,
                                      isEdit: true,
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
