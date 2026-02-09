// ignore_for_file: must_be_immutable, library_private_types_in_public_api, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_button.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';

class CustomPopUpForLocation extends StatefulWidget {
  final String hintText;
  final bool isSelect;
  final String name;
  final bool? isWorkspace;
  Function(LocationData) onSubmit;
  final String title;
  final List<LocationData> initiallySelectedItems;
  final Function(List<LocationData> selectedItems) onSelectionComplete;

  // final Function(FocusNode) onFocusNodeRequested;

  CustomPopUpForLocation({
    super.key,
    this.isWorkspace,
    required this.hintText,
    required this.onSubmit,
    required this.isSelect,
    required this.title,
    required this.initiallySelectedItems,
    required this.onSelectionComplete,
    required this.name,
  });

  @override
  _CustomPopUpForLocationState createState() => _CustomPopUpForLocationState();
}

class _CustomPopUpForLocationState extends State<CustomPopUpForLocation> {
  List<dynamic>? suggestion;
  List<LocationData> items = []; // API se aaya data store hoga
  List<LocationData> filteredItems = [];
  List<LocationData> selectedItems = [];
  bool isLoading = true;
  TextEditingController controller = TextEditingController();

  String? SelectedValue;

  Future<void> GetLocation() async {
    final response = await http.post(
      Uri.parse(
        '${GlobalConstants.fetchmasterdatasuggestionurl}${widget.name}&pageNumber=1&pageSize=10000',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> content = data['resultData']['masterData']['content'];

      // ✅ Filter karein jisme `formattedData` empty na ho
      List<LocationData> suggestions = content
          .map((entry) => LocationData.fromJson(entry))
          .where((item) => item.formateData!.isNotEmpty) // ❌ Empty ko hatao
          .toList();

      // 🟢 Remove "Hybrid" only if widget.name == "location"
      if (widget.name == 'location') {
        suggestions.removeWhere(
          (item) => item.formateData?.trim().toLowerCase() == 'hybrid',
        );
      }

      items = suggestions; // ✅ Model-based List Store
      filteredItems = List.from(items);
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  void filterItems(String query, StateSetter setState) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(items);
      } else {
        filteredItems = items
            .where(
              (item) =>
                  item.formateData!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void toggleSelection(LocationData item, StateSetter setState) {
    setState(() {
      if (widget.title != "Remote" && widget.isWorkspace == null) {
        if (selectedItems.contains(item)) {
          selectedItems.remove(item);
        } else {
          selectedItems.add(item);
        }
      } else {
        widget.onSubmit(item);
        NavigationService.pop();
      }
    });

    // Separate setState for sorting after selection is updated
    /*   setState(() {
      filteredItems.sort((a, b) => a == item
          ? -1
          : b == item
              ? 1
              : 0);
    }); */
  }

  String formatLocality(String locality) {
    // Split the string by comma
    List<String> parts = locality.split(',');

    if (parts.length >= 2) {
      // Trim any leading or trailing spaces/tabs from both parts
      String part1 = parts[0].trim();
      String part2 = parts[1].trim();

      // Combine the parts with a single space after the comma
      return '$part1, $part2';
    }

    // If there's no comma, return the original string
    return locality;
  }

  late final Function(String) onIDSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return CustomToggleButton(
      title: widget.title,
      onTap: () {
        _showBottomSheet(colors);
      },
      isSelect: widget.isSelect,
    );
  }

  void _showBottomSheet(AppColors colors) {
    selectedItems = List.from(widget.initiallySelectedItems);
    controller.clear();
    filteredItems = List.from(items);

    showModalBottomSheet(
      elevation: 0,
      barrierColor: Colors.black.withOpacity(0.3),
      backgroundColor: colors.bottomsheetbgColor,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          height: MediaQuery.of(context).size.height / 1.5,
          child: StatefulBuilder(
            builder: (context, setState) {
              return FutureBuilder(
                future: isLoading
                    ? GetLocation()
                    : null, // Ek baar hi load hoga
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Constants.darkBlue,
                      ),
                    );
                  }
                  isLoading = false;

                  // API complete hone ke baad false

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => NavigationService.pop(),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Constants.themeBgColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          customText(
                            title: widget.title,
                            color: Constants.themeBgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // **Searchable TextField**
                      CustomTextFieldforAll(
                        controller: controller,
                        hint: "Type to search",
                        onChanged: (val) => filterItems(val, setState),
                        isGmail: true,
                      ),

                      const SizedBox(height: 20),

                      // **Filtered Items**
                      filteredItems.isEmpty
                          ? Center(
                              child: customText(
                                title: "No items found",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colors.subTitleColor,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = filteredItems[index];
                                  final isSelected = selectedItems.any(
                                    (element) => element.id == item.id,
                                  );
                                  final backgroundColor = index % 2 == 0
                                      ? colors.bottomsheerCard1Color
                                      : colors.bottomsheerCard2Color;

                                  return GestureDetector(
                                    onTap: () =>
                                        toggleSelection(item, setState),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        title: customText(
                                          title: item.formateData!,
                                          fontSize: 12,
                                          color: colors.headingColor,
                                        ),
                                        trailing: isSelected
                                            ? Image.asset(
                                                CustomAssetUrl.doublecheckicon,
                                                height: 18,
                                                color: Constants.darkBlue,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      // **Done Button**
                      if (widget.title != "Remote" &&
                          selectedItems.isNotEmpty &&
                          widget.isWorkspace == null)
                        customButton(
                          title: "Done",
                          onTap: () {
                            widget.onSelectionComplete(selectedItems);

                            NavigationService.pop();
                          },
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
