// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/bank/bank_list_model.dart';
import 'package:job_circle/src/provider/bank_text_field_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class CustomTextFieldForBank extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;
  final Function(int) onIdSelected;
  final Function(bool) onChanged;
  final FocusNode? focusNode;

  const CustomTextFieldForBank({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    required this.onIdSelected,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final suggestionProvider = Provider.of<BankSuggestionProvider>(context);

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 25,
      //  margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TypeAheadField<BankModel>(
        controller: controller,
        builder: (context, controller, focusNode) {
          return CustomTextFieldforAll(
            controller: controller,
            hint: hintText,
            focusNode: focusNode,
          );
        },
        decorationBuilder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Constants.white,
            ),
            child: child,
          );
        },
        suggestionsCallback: (pattern) async {
          if (pattern.isNotEmpty) {
            await suggestionProvider.fetchSuggestions(pattern);
            return suggestionProvider.suggestions;
          }
          return [];
        },
        itemBuilder: (context, suggestion) {
          List<String> parts = suggestion.name.toString().split(',');
          if (parts.length > 1) {
            parts.removeLast(); // remove last element
          }
          final data = parts.map((e) => e.trim()).join(', ');
          return Container(
            decoration: BoxDecoration(
              color:
                  (suggestionProvider.suggestions.indexOf(suggestion) % 2 == 0)
                  ? colors.bottomsheerCard1Color
                  : colors.bottomsheerCard2Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: customText(
                title: (suggestion.name ?? ''),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors.headingColor,
              ),
            ),
          );
        },
        onSelected: (suggestion) {
          List<String> parts = suggestion.name.toString().split(',');
          if (parts.length > 1) {
            parts.removeLast(); // remove last element
          }
          controller.text = suggestion.name ?? '';
          onChanged(true);
          onIdSelected(suggestion.id ?? 0);
          FocusScope.of(context).unfocus();
        },
        emptyBuilder: (context) {
          if (controller.text.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            decoration: BoxDecoration(
              color: colors.bottomsheerCard1Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: customText(
                monst: true,
                fontSize: 12,
                title: "No result found.",
                fontWeight: FontWeight.w600,
                color: colors.subTitleColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
