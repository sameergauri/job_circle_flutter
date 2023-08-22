import 'package:flutter/material.dart';
import 'package:job_circle/models/autocompleteModel.dart';

class CustomControls {
  static bool get kDebugMode => false;

  // ignore: non_constant_identifier_names
  static Autocomplete<AutoCompleteModel> AutoCompleteCustom(
      BuildContext context,
      String label,
      String hintText,
      AutocompleteOnSelected<AutoCompleteModel> onSelected,
      AutoCompleteModel selectedItem,
      List<AutoCompleteModel> items,
      IconData _icnos,
      {bool? allowFreeText = false,
      String? Function(String?)? validator,
      Function? onClick}) {
    return Autocomplete(
        initialValue: TextEditingValue(
          text: selectedItem.label,
        ),
        fieldViewBuilder: (BuildContext context,
            TextEditingController controllr,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          controllr.text = selectedItem.label;
          return TextFormField(
              onTap: (() {
                onClick!();
              }),
              controller: controllr,
              focusNode: fieldFocusNode
                ..addListener(() {
                  selectedItem.extra;
                }),
              onEditingComplete: onFieldSubmitted,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.arrow_drop_down),
                icon: Icon(_icnos), // Icons.workspace_premium
                label: Text(label),
                //border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: hintText,
              ),
              validator: validator);
        },
        onSelected: (AutoCompleteModel _selectedItem) {
          if (kDebugMode) {
          //  print(selectedItem.extra);
          }
          onSelected(_selectedItem);
          selectedItem = _selectedItem;
        },
        displayStringForOption: (AutoCompleteModel option) => option.label,
        optionsMaxHeight: double.infinity,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<AutoCompleteModel>.empty();
          }
          return items.where((AutoCompleteModel option) {
            return option.label
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        });
  }
}
