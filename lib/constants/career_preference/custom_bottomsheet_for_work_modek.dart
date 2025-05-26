import 'package:flutter/material.dart';
import 'package:job_circle/components/customTextFieldForAll.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class WorkModeWithCitySelection extends StatefulWidget {
  final Function(List<String>) onCitySelectionChanged;
  final Function(String) selectedWorkMode;

  const WorkModeWithCitySelection({
    super.key,
    required this.onCitySelectionChanged,
    required this.selectedWorkMode,
  });

  @override
  _WorkModeWithCitySelectionState createState() =>
      _WorkModeWithCitySelectionState();
}

class _WorkModeWithCitySelectionState extends State<WorkModeWithCitySelection> {
  // Boolean flags for confirmed work modes (color change)
  bool isOnSite = false;
  bool isHybrid = false;
  bool isRemote = false;

  // Temporary boolean flags for work mode being edited
  bool tempOnSite = false;
  bool tempHybrid = false;
  bool tempRemote = false;

  // Single list to store selected cities
  List<String> selectedCities = [];

  // List of cities for selection
  final List<String> allCities = [
    "New York",
    "Los Angeles",
    "Chicago",
    "Houston",
    "Phoenix",
    "Philadelphia",
    "San Antonio",
    "San Diego",
    "Dallas",
    "San Jose",
  ];

  void _showCitySelectionBottomSheet(BuildContext context) async {
    List<String> tempSelectedCities = List.from(selectedCities);
    List<String> filteredCities = List.from(allCities);
    TextEditingController searchController = TextEditingController();

    // Sort items initially: selected cities first
    filteredCities.sort((a, b) {
      bool isASelected = tempSelectedCities.contains(a);
      bool isBSelected = tempSelectedCities.contains(b);
      if (isASelected && !isBSelected) return -1;
      if (!isASelected && isBSelected) return 1;
      return 0;
    });

    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.white,
      elevation: 1,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search Bar
                  CustomTextFieldforAll(
                    controller: searchController,
                    hint: "Type to search cities",
                    onChanged: (value) {
                      setModalState(() {
                        filteredCities = allCities
                            .where((item) => item
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                        filteredCities.sort((a, b) {
                          bool isASelected = tempSelectedCities.contains(a);
                          bool isBSelected = tempSelectedCities.contains(b);
                          if (isASelected && !isBSelected) return -1;
                          if (!isASelected && isBSelected) return 1;
                          return 0;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  // List of Cities
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isSelected = tempSelectedCities.contains(city);
                        Color backgroundColor =
                            index % 2 == 0 ? Colors.white : Constants.lightdull;
                        return Container(
                          color: backgroundColor,
                          child: ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            title: customTextForWeather(title: city),
                            trailing: isSelected
                                ? Image.asset(
                                    "assets/images/double_check.png",
                                    color: Constants.darkBlue,
                                    height: 15,
                                  )
                                : null,
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  tempSelectedCities.remove(city);
                                } else {
                                  if (tempSelectedCities.length < 3) {
                                    tempSelectedCities.add(city);
                                  } else {
                                    Navigator.pop(context);
                                    CustomSnackbar.show(
                                        'Maximum 3 cities can be selected',
                                        true);
                                  }
                                }
                                filteredCities.sort((a, b) {
                                  bool isASelected =
                                      tempSelectedCities.contains(a);
                                  bool isBSelected =
                                      tempSelectedCities.contains(b);
                                  if (isASelected && !isBSelected) return -1;
                                  if (!isASelected && isBSelected) return 1;
                                  return 0;
                                });
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Submit Button
                  CustomButtonForSave(
                    onTap: () {
                      setState(() {
                        selectedCities = tempSelectedCities;

                        // Update the confirmed boolean flags only after Submit
                        if (selectedCities.isNotEmpty) {
                          isOnSite = tempOnSite;
                          isHybrid = tempHybrid;
                          isRemote = tempRemote;
                        } else {
                          // If no cities are selected, reset all confirmed work modes
                          isOnSite = false;
                          isHybrid = false;
                          isRemote = false;
                        }
                        widget.onCitySelectionChanged(selectedCities);
                        widget.selectedWorkMode(tempOnSite
                            ? "OnSite"
                            : tempHybrid
                                ? "Hybrid"
                                : tempRemote
                                    ? "Remote"
                                    : "");
                      });
                      Navigator.pop(context);
                    },
                    title: "Submit",
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _selectWorkMode(String workMode) {
    setState(() {
      // Reset previous data
      selectedCities.clear();

      // Reset all confirmed work modes (so color doesn't change yet)
      isOnSite = false;
      isHybrid = false;
      isRemote = false;

      // Reset temporary flags
      tempOnSite = false;
      tempHybrid = false;
      tempRemote = false;

      // Set the temporary flag for the selected work mode
      if (workMode == "OnSite") {
        tempOnSite = true;
      } else if (workMode == "Hybrid") {
        tempHybrid = true;
      } else if (workMode == "Remote") {
        tempRemote = true;
      }

      // Notify parent of the updated selection (cleared cities)
      widget.onCitySelectionChanged(selectedCities);

      // Open the BottomSheet for city selection
      _showCitySelectionBottomSheet(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildWorkModeContainer(context, "OnSite", isOnSite),
              const SizedBox(width: 10),
              _buildWorkModeContainer(context, "Hybrid", isHybrid),
              const SizedBox(width: 10),
              _buildWorkModeContainer(context, "Remote", isRemote),
            ],
          ),
        ),
        // Display selected cities in the next line
        if (selectedCities.isNotEmpty) ...[
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const customTextForWeather(
                title: "Job Location/City*",
                fontSize: 12,
              ),
              const SizedBox(height: 2),
              Container(
                width: double.maxFinite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Constants.lightdull, // Underline color
                      width: 1.0,
                    ),
                  ),
                ),
                child: customTextForWeather(
                  title: selectedCities.join(', '),
                  fontSize: 14,
                  softwrap: true,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildWorkModeContainer(
      BuildContext context, String workMode, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomToggleButton(
          title: workMode,
          onTap: () => _selectWorkMode(workMode),
          isSelect: isSelected,
        ),
      ],
    );
  }
}
