import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/themes/colors.dart';

class CustomBottomSheet {
  final BuildContext context;
  final List<String> items;
  final String title;
  final List<String> initiallySelectedItems;
  final Function(List<String> selectedItems) onSelectionComplete;

  CustomBottomSheet({
    required this.context,
    required this.items,
    required this.title,
    required this.initiallySelectedItems,
    required this.onSelectionComplete,
  });

  TextEditingController controller = TextEditingController();
  late List<String> filteredItems;
  List<String> selectedItems = [];

  void show() {
    final ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);

    filteredItems = items;

    selectedItems = List.from(initiallySelectedItems);
    // Filter function for search

    // Display the modal bottom sheet
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              // Filter function for search
              void filterItems(String query) {
                setState(() {
                  if (query.isEmpty) {
                    filteredItems = items;
                  } else {
                    filteredItems = items
                        .where((item) =>
                            item.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  }
                });
              }

              // Toggle selection for an item
              /*  void toggleSelection(String item) {
                setState(() {
                  if (selectedItems.contains(item)) {
                    selectedItems.remove(item);
                  } else {
                    selectedItems.add(item);
                    onSelectionComplete(selectedItems);
                  }
                });
              } */
              void toggleSelection(String item) {
                setState(() {
                  if (selectedItems.contains(item)) {
                    selectedItems.remove(item);
                  } else {
                    selectedItems.add(item);
                  }

                  // Move the selected item to the top of the filtered list
                  filteredItems.sort((a, b) {
                    if (a == item) return -1; // Place selected item at the top
                    if (b == item) return 1;
                    return 0;
                  });
                });
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    height: MediaQuery.of(context).size.height / 1.16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.varela(
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),

                        // Searchable TextField
                        TextField(
                          controller: controller,
                          onChanged: filterItems,
                          decoration: InputDecoration(
                            hintText: "Type to search",
                            hintStyle: GoogleFonts.varela(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Constants.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Constants.subtitleclr),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.only(left: 15),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Filtered Items
                        filteredItems.isEmpty
                            ? Center(
                                child: Text(
                                  "No items found",
                                  style: GoogleFonts.varela(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Constants.subtitleclr,
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredItems[index];
                                    final isSelected =
                                        selectedItems.contains(item);
                                    final backgroundColor = index % 2 == 0
                                        ? Constants.borderColor
                                        : Colors.white;

                                    return GestureDetector(
                                      onTap: () => toggleSelection(item),
                                      child: Container(
                                        width: double.maxFinite,
                                        margin: EdgeInsets.only(bottom: 8.h),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 12.w),
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Constants.subtitleclr,
                                              blurRadius: 2.1,
                                              offset: Offset(2, 4),
                                            ),
                                          ],
                                          color: backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item,
                                              style: GoogleFonts.varela(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Constants.subtitleclr,
                                              ),
                                            ),
                                            if (isSelected)
                                              Image.asset(
                                                "assets/images/double_check.png",
                                                height: 18.sp,
                                                color: Constants.themeBgColor,
                                              )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                  CustomButtonForJobPosting(
                    buttonText: "Done",
                    onTap: () {
                      onSelectionComplete(selectedItems);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        });
    /*  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: selectedItemsNotifier,
          builder: (context, selectedItems, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              height: MediaQuery.of(context).size.height / 1.16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.varela(
                          color: Constants.themeBgColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  // Searchable List
                  TextField(
                    onChanged: (value) {
                      items.contains(value);
                    },
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Type to search",
                      hintStyle: GoogleFonts.varela(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Constants.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Constants.subtitleclr),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.only(left: 15),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: items.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      Color backgroundColor =
                          index % 2 == 0 ? Constants.borderColor : Colors.white;
                      return Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(bottom: 2.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Constants.subtitleclr,
                                blurRadius: 2.1,
                                offset: Offset(2, 4))
                          ],
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          item,
                          style: GoogleFonts.varela(
                              color: Constants.subtitleclr,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
   */
  }
}
