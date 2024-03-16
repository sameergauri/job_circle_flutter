import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/interviewbay_faq_model.dart';
import 'package:job_circle/screens/faq/interview_bay_faq_detail.dart';
import 'package:job_circle/themes/colors.dart';

final interviewFaqProvider =
    FutureProvider<List<InterviewFaqGetModel>>((ref) async {
  return await _InterviewFaqState._loadCrpf();
});

class InterviewFaq extends ConsumerStatefulWidget {
  const InterviewFaq({super.key});

  @override
  ConsumerState<InterviewFaq> createState() => _InterviewFaqState();
}

class _InterviewFaqState extends ConsumerState<InterviewFaq> {
  List<InterviewFaqGetModel> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  static Future<List<InterviewFaqGetModel>> _loadCrpf() async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/jobCRPF/v1/all?page=1&size=1000'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      final List<dynamic> content = parsedResponse["resultData"]["content"];

      // Map the JSON data to CRPFModel objects
      List<InterviewFaqGetModel> crpfList =
          content.map((json) => InterviewFaqGetModel.fromJson(json)).toList();

      return crpfList;
    } else {
      throw Exception('Failed to load crpf data from API');
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(interviewFaqProvider);
  }

  @override
  Widget build(BuildContext context) {
    final crpfData = ref.watch(interviewFaqProvider);

    return crpfData.when(data: (data) {
      List<InterviewFaqGetModel> filteredData = data
          .where((element) =>
              element.shortCode!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              element.name!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              element.process!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite, kToolbarHeight),
          child: AppBar(
            toolbarHeight: kToolbarHeight * 1.12,
            automaticallyImplyLeading: false,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 24,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: _searchController,
                        enableInteractiveSelection: false,
                        onChanged: (text) {
                          setState(() {});
                        },
                        focusNode: _searchFocusNode,
                        style: GoogleFonts.varela(
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.only(
                            // bottom: 0,
                            left: 5,
                            top: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          hintText: 'Search by company',
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.search,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   mini: true,
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => InterviewFaqForm(),
        //         ));
        //   },
        //   child: const Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.red, // Change this to your desired color
        // ),
        body: Column(
          children: [
            Visibility(
              visible: filteredData.isEmpty,
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "./assets/images/nodata.gif",
                      height: 350.0.h,
                      width: 500.0.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Oops! We couldn't find any results.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.varela(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                displacement: 100.0,
                color: Colors.blue,
                onRefresh: () async {
                  await _onRefresh();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var item = filteredData[index];
                    // : _searchResults[index];b
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InterviewFaqPage(
                              crpfid: item.id!.toInt(),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          bottom: 5.h,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Constants.bgColorWhite,
                                      borderRadius: BorderRadius.circular(8.r),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0.5, 2),
                                            blurRadius: 2,
                                            spreadRadius: 2,
                                            color: Colors.grey.shade200)
                                      ]),
                                  child: Row(
                                    children: [
                                      item.icon != ""
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              height: 30.h,
                                              width: 60.w,
                                              child: CustomImage(
                                                imageUrl:
                                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.icon}",
                                                defaultImageUrl:
                                                    "https://cdn-icons-png.flaticon.com/128/3413/3413246.png",
                                              ))
                                          : const SizedBox(),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.process.toString(),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.varela(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.h,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        item.roleName
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.varela(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        " || ",
                                                        style:
                                                            GoogleFonts.varela(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      Text(
                                                        item.natureOfWork
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.varela(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }, error: (error, stackTrace) {
      return const Scaffold(
        body: Center(
          child: Text("Failed to get faq Data"),
        ),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
