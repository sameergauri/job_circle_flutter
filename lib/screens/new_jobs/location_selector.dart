// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/screens/new_jobs/filter_jobs.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your Constants class here

class LocationSelector extends ConsumerStatefulWidget {
  final List<String> locationList;
  final void Function(String)? onLocationSelected;

  const LocationSelector({
    Key? key,
    required this.locationList,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends ConsumerState<LocationSelector> {
  late TextEditingController searchController;
  List<String> filteredList = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredList = widget.locationList;
    // Initialize SharedPreferences
    SharedPreferences.getInstance().then((value) {
      prefs = value;
    });
  }

  late FilterDialog filterDialog;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r))),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cities we are present in...",
                style: GoogleFonts.varela(
                  fontSize: 18,
                  color: Constants.themeBgColor, // Use your Constants here
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "assets/images/close.png",
                  height: 13.h,
                ),
              )
            ],
          ),
          TextField(
            controller: searchController,
            onChanged: onSearch,
            decoration: const InputDecoration(
              hintText: "Type to search...",
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final location = filteredList[index];
                return InkWell(
                  onTap: () async {
                    print('Selected Location in LocationSelector: $location');
                    Navigator.pop(context);
                    final selectedLocation = location;
                    await prefs.setString('selectedLocation', selectedLocation);
                    widget.onLocationSelected?.call(selectedLocation);
                    /*  ref.refresh(userJobDataProvider);  //TODO: for future.
                    ref.refresh(jobsProvider); */
                    
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.only(
                        right: 20, left: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.white : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      location,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onSearch(String value) {
    setState(() {
      filteredList = widget.locationList
          .where((location) =>
              location.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
