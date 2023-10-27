import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/screens/jobs/filter_provider.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/themes/colors.dart';

final jobDataProvider = FutureProvider(
    (ref) => JobSearchService().getJobSearch({"page": "1", "size": "100"}));

class CustomSheetNew extends ConsumerStatefulWidget {
  const CustomSheetNew({super.key, required this.onDone});

  final Function(Map<String, String>) onDone;

  @override
  ConsumerState<CustomSheetNew> createState() => _CustomSheetNewState();
}

class _CustomSheetNewState extends ConsumerState<CustomSheetNew> {
  String getApiKeys(String filter) {
    switch (filter) {
      case "Company":
        return "company";
      case "Process":
        return "process";
      case "Functional Area":
        return "naturofwork";
      case "Designation":
        return "rolename";
      case "Locality":
        return "s_location";
      default:
        return "";
    }
  }

  final int _tabIndex = 0;
  final _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final jobPro = ref.watch(jobDataProvider);
    final filterPro = ref.watch(filterProvider);
    return jobPro.when(
      data: (response) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // App Bar
              AppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // title: Text('Filter Options'),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // filterPro.selectedData.clear();
                        filterPro.clearAll();
                      });
                    },
                    child: Text(
                      'Clear All',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.h,
                        color: Constants.themeBgColor,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    // Left Pane
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Container(
                        width: 135,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: filterPro.filterData.keys
                              .map(
                                (e) => ListTile(
                                  tileColor: filterPro.selectedKey == e
                                      ? Colors.white
                                      : Colors.grey.shade200,
                                  onTap: () {
                                    filterPro.selectedKey = e;
                                    _controller.jumpToPage(1);
                                  },
                                  title: Text(e.toString()),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    // Right Pane
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _controller,
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: (filterPro.filterData[
                                              filterPro.selectedKey] ??
                                          [])
                                      .map(
                                        (e) => CheckboxListTile(
                                          value: filterPro.selectedData[
                                                      filterPro.selectedKey]
                                                  ?.contains(e) ==
                                              true,
                                          onChanged: (v) {
                                            if (v == true) {
                                              // User is selecting the checkbox
                                              filterPro.toggleSelection(e);
                                            } else {
                                              // User is unselecting the checkbox, display all data
                                              filterPro.clearAll();
                                            }
                                          },
                                          title: Text(e),
                                        ),
                                      )
                                      .toSet()
                                      .toList(),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    Map<String, String> apiData = filterPro
                                        .selectedData
                                        .map((key, value) => MapEntry(
                                            getApiKeys(key), value.join(',')))
                                      ..removeWhere(
                                          (key, value) => value.isEmpty);
                                    widget.onDone(apiData);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constants.themeBgColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    width: 100,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Apply Filters",
                                          style: GoogleFonts.varela(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) =>
          const Center(child: Text("Something went wrong")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class CustomSheet {
  static void customSheet(
      {required BuildContext context,
      required Function(Map<String, String>) onDone}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.white,
      context: context,
      builder: (context) {
        return CustomSheetNew(
          onDone: onDone,
        );
      },
    );
  }
}


/* import 'package:flutter/material.dart';//TODO: untill 26/10/2023
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/screens/jobs/filter_provider.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/themes/colors.dart';


final jobDataProvider = FutureProvider(
    (ref) => JobSearchService().getJobSearch({"page": "1", "size": "100"}));

class CustomSheetNew extends ConsumerStatefulWidget {
  const CustomSheetNew({super.key, required this.onDone});

  final Function(Map<String, String>) onDone;

  @override
  ConsumerState<CustomSheetNew> createState() => _CustomSheetNewState();
}

class _CustomSheetNewState extends ConsumerState<CustomSheetNew> {
  String getApiKeys(String filter) {
    switch (filter) {
      case "Company":
        return "company";
      case "Process":
        return "process";
      case "Functional Area":
        return "naturofwork";
      case "Designation":
        return "rolename";
      case "Locality":
        return "location";
      default:
        return "";
    }
  }

  final int _tabIndex = 0;
  final _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final jobPro = ref.watch(jobDataProvider);
    final filterPro = ref.watch(filterProvider);
    return jobPro.when(
      data: (response) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // App Bar
              AppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // title: Text('Filter Options'),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // filterPro.selectedData.clear();
                        filterPro.clearAll();
                      });
                    },
                    child: Text(
                      'Clear All',
                      style: GoogleFonts.varela(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.h,
                        color: Constants.themeBgColor,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    // Left Pane
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Container(
                        width: 135,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: filterPro.filterData.keys
                              .map(
                                (e) => ListTile(
                                  tileColor: filterPro.selectedKey == e
                                      ? Colors.white
                                      : Colors.grey.shade200,
                                  onTap: () {
                                    filterPro.selectedKey = e;
                                    _controller.jumpToPage(1);
                                  },
                                  title: Text(e.toString()),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    // Right Pane
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _controller,
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: (filterPro.filterData[
                                              filterPro.selectedKey] ??
                                          [])
                                      .map(
                                        (e) => CheckboxListTile(
                                          value: filterPro.selectedData[
                                                      filterPro.selectedKey]
                                                  ?.contains(e) ==
                                              true,
                                          onChanged: (v) {
                                            if (v == true) {
                                              // User is selecting the checkbox
                                              filterPro.toggleSelection(e);
                                            } else {
                                              // User is unselecting the checkbox, display all data
                                              filterPro.clearAll();
                                            }
                                          },
                                          title: Text(e),
                                        ),
                                      )
                                      .toSet()
                                      .toList(),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    Map<String, String> apiData = filterPro
                                        .selectedData
                                        .map((key, value) => MapEntry(
                                            getApiKeys(key), value.join(',')))
                                      ..removeWhere(
                                          (key, value) => value.isEmpty);
                                    widget.onDone(apiData);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constants.themeBgColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    width: 100,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Apply Filters",
                                          style: GoogleFonts.varela(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) =>
          const Center(child: Text("Something went wrong")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class CustomSheet {
  static void customSheet(
      {required BuildContext context,
      required Function(Map<String, String>) onDone}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.white,
      context: context,
      builder: (context) {
        return CustomSheetNew(
          onDone: onDone,
        );
      },
    );
  }
}
 */




/* import 'package:flutter/material.dart';  //TODO: Old code previous before changes done.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_circle/screens/jobs/filter_provider.dart';
import 'package:job_circle/service/JobSearchService.dart';

final jobDataProvider = FutureProvider(
    (ref) => JobSearchService().getJobSearch({"page": "1", "size": "100"}));

class CustomSheetNew extends ConsumerStatefulWidget {
  const CustomSheetNew({super.key, required this.onDone});

  final Function(Map<String, String>) onDone;

  @override
  ConsumerState<CustomSheetNew> createState() => _CustomSheetNewState();
}

class _CustomSheetNewState extends ConsumerState<CustomSheetNew> {
  String getApiKeys(String filter) {
    switch (filter) {
      case "Company":
        return "company";
      case "Process":
        return "process";
      case "Nature Of Work":
        return "naturofwork";
      case "Designation":
        return "rolename";
         case "Locality":
        return "location";
      default:
        return "";
    }
  }

  final int _tabIndex = 0;
  final _controller = PageController(
    // viewportFraction: 0.8,

    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    final jobPro = ref.watch(jobDataProvider);
    final filterPro = ref.watch(filterProvider);

    return jobPro.when(
      data: (response) {
        return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Map<String, String> apiData = filterPro.selectedData
                              .map((key, value) =>
                                  MapEntry(getApiKeys(key), value.join(',')))
                            ..removeWhere((key, value) => value.isEmpty);
                          //?this=map

                          widget.onDone(apiData);
                          Navigator.pop(context);
                        },
                        child: const Text("Done")),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: filterPro.filterData.keys
                        .map((e) => ListTile(
                            onTap: () {
                              filterPro.selectedKey = e;
                              _controller.jumpToPage(1);
                            },
                            title: Text(e.toString())))
                        .toList(),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceIn);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children:
                            (filterPro.filterData[filterPro.selectedKey] ?? [])
                                .map((e) => CheckboxListTile(
                                    value: filterPro
                                            .selectedData[filterPro.selectedKey]
                                            ?.contains(e) ==
                                        true,
                                    onChanged: (v) {
                                      filterPro.toggleSelection(e);
                                      /*  _controller.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.bounceIn); */
                                    },
                                    title: Text(e)))
                                .toSet()
                                .toList()),
                  ),
                ],
              ),
            ]);
      },
      error: (error, stackTrace) =>
          const Center(child: Text("Something went wrong")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class CustomSheet {
  static void customSheet(
      {required BuildContext context,
      required Function(Map<String, String>) onDone}) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CustomSheetNew(
          onDone: onDone,
        );
      },
    );
  }
}
 */