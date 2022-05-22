import 'package:flutter/material.dart';
import 'package:job_circle/models/autocompleteModel.dart';

class CustomControls {
  static Autocomplete<AutoCompleteModel> AutoCompleteCustom(
      BuildContext context,
      String label,
      String hintText,
      AutocompleteOnSelected<AutoCompleteModel> onSelected,
      AutoCompleteModel selectedItem,
      List<AutoCompleteModel> items,
      IconData _icnos) {
    return Autocomplete(
        initialValue: TextEditingValue(
          text: (selectedItem == null ? "" : selectedItem.label),
        ),
        fieldViewBuilder: (BuildContext context,
            TextEditingController controllr,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          controllr.text = selectedItem.label;

          return TextField(
            controller: controllr,
            focusNode: fieldFocusNode,
            onEditingComplete: onFieldSubmitted,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.arrow_drop_down),
              icon: Icon(_icnos), // Icons.workspace_premium
              label: Text(label),
              //border: OutlineInputBorder(),
              border: InputBorder.none,
              hintText: hintText,
            ),
          );
        },
        onSelected: (AutoCompleteModel selectedItem) {
          onSelected(selectedItem);
          selectedItem = selectedItem;
        },
        displayStringForOption: (AutoCompleteModel option) => option.label,
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
