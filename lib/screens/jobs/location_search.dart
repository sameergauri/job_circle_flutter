// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/models/location_model.dart';
import 'package:job_circle/themes/colors.dart';

class LocationSearchBottomSheet extends StatefulWidget {
  final List<Content> locations;
  final List jobItems;
  final Function(Content) onSelected;

  const LocationSearchBottomSheet({
    super.key,
    required this.locations,
    required this.jobItems,
    required this.onSelected,
  });

  @override
  _LocationSearchBottomSheetState createState() =>
      _LocationSearchBottomSheetState();
}

TextEditingController controller = TextEditingController();

class _LocationSearchBottomSheetState extends State<LocationSearchBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var suggestionList = widget.locations
        .where((element) => element.name!
            .toLowerCase()
            .startsWith(controller.text.toLowerCase()))
        .toList();
    List<Content> filterSuggestions(String userInput) {
      if (userInput.isEmpty) {
        return suggestionList; // Return the original suggestion list when the user input is empty
      } else {
        // Perform filtering based on the user input
        final filteredList = suggestionList.where((suggestion) {
          final suggestionName = suggestion.name.toString().toLowerCase();
          final input = userInput.toLowerCase();
          return suggestionName.contains(input);
        }).toList();

        return filteredList;
      }
    }

    return Container(
      // height: MediaQuery.of(context).size.height / 1.10,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cities we are present in...",
                style: GoogleFonts.varela(
                    fontSize: 18, color: Constants.themeBgColor),
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
          SizedBox(
            height: 35.h,
            //padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Type your city",
                //  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                /* focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey)),
                  
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade100)
                      ) */
              ),
              controller: controller,
              onChanged: (value) {
                setState(() {
                  suggestionList = filterSuggestions(
                      value); // Replace `filterSuggestions` with your own filtering logic
                });
              },
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final suggestion = suggestionList[index];
              final isOddIndex = index % 2 != 0;
              if (suggestion.name.toString() == "Anywhere") {
                return const SizedBox
                    .shrink(); // Return an empty SizedBox to skip rendering the item
              }
              // Check if the index is odd or even

              return InkWell(
                onTap: () {
                  widget.onSelected(suggestion);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.only(
                      right: 20, left: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: isOddIndex ? Colors.blueGrey[100] : Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    suggestion.name.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold
                        // Customize text color based on odd/even index
                        ),
                  ),
                  // Customize background color based on odd/even index
                ),
              );
            },
            itemCount: suggestionList.length,
          )
        ],
      ),
    );
  }
}
