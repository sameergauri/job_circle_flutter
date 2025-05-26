import 'package:flutter/material.dart';
import 'package:job_circle/components/customTextFieldForAll.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class MultiSelectBottomSheetField extends StatefulWidget {
  final String hint;
  final Future<List<String>> Function(String) fetchSuggestions;
  final TextEditingController controller;
  final int maxSelections;

  const MultiSelectBottomSheetField({
    super.key,
    required this.hint,
    required this.fetchSuggestions,
    required this.controller,
    required this.maxSelections,
  });

  @override
  _MultiSelectBottomSheetFieldState createState() =>
      _MultiSelectBottomSheetFieldState();
}

class _MultiSelectBottomSheetFieldState
    extends State<MultiSelectBottomSheetField> {
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize the controller with any existing selected items
    if (widget.controller.text.isNotEmpty) {
      selectedItems = widget.controller.text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
  }

  void _showBottomSheet(BuildContext context) async {
    List<String> tempSelectedItems = List.from(selectedItems);
    List<String> allItems = [];
    List<String> filteredItems = [];
    TextEditingController searchController = TextEditingController();

    // Fetch initial items
    allItems = await widget.fetchSuggestions('');
    filteredItems = List.from(allItems);

    // Sort items initially: selected items first
    filteredItems.sort((a, b) {
      bool isASelected = tempSelectedItems.contains(a);
      bool isBSelected = tempSelectedItems.contains(b);
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
                    hint: "Type to search",
                    onChanged: (value) async {
                      final suggestions = await widget.fetchSuggestions(value);
                      setModalState(() {
                        filteredItems = suggestions
                            .where((item) => item
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                        // Sort items: selected items first
                        filteredItems.sort((a, b) {
                          bool isASelected = tempSelectedItems.contains(a);
                          bool isBSelected = tempSelectedItems.contains(b);
                          if (isASelected && !isBSelected) return -1;
                          if (!isASelected && isBSelected) return 1;
                          return 0;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  // List of Items
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = tempSelectedItems.contains(item);
                        Color backgroundColor =
                            index % 2 == 0 ? Colors.white : Constants.lightdull;
                        return Container(
                          color: backgroundColor,
                          child: ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            title: customTextForWeather(title: item),
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
                                  tempSelectedItems.remove(item);
                                } else {
                                  if (tempSelectedItems.length <
                                      widget.maxSelections) {
                                    tempSelectedItems.add(item);
                                  } else {
                                    Navigator.pop(context);
                                    CustomSnackbar.show(
                                        'Maximum ${widget.maxSelections} selections allowed',
                                        true);
                                  }
                                }
                                // Sort items: selected items first
                                filteredItems.sort((a, b) {
                                  bool isASelected =
                                      tempSelectedItems.contains(a);
                                  bool isBSelected =
                                      tempSelectedItems.contains(b);
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
                        selectedItems = tempSelectedItems;
                        widget.controller.text = selectedItems.join(', ');
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Constants.lightdull, // Underline color
              width: 1.0,
            ),
          ),
        ),
        child: customTextForMonst(
          title: selectedItems.isEmpty ? widget.hint : selectedItems.join(', '),
          color: selectedItems.isEmpty
              ? Constants.subtitleclr // Hint text color
              : Colors.black, // Selected items text color
          fontSize: 14,
          softwrap: true, // Allow unlimited lines
        ),
      ),
    );
  }
}
