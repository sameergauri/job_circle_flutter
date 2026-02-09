// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_title_model.dart';
import 'package:job_circle/src/provider/suggestion_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class CustomSuggestionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;
  final String name;
  final SuggestionType type;
  final Function(int) onIdSelected;
  final Function(bool) onChanged;
  final FocusNode? focusNode;
  final bool EnableAddOption;

  const CustomSuggestionTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    required this.name,
    required this.type,
    required this.onIdSelected,
    required this.onChanged,
    required this.EnableAddOption,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final suggestionProvider = Provider.of<SuggestionProvider>(context);

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 25,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TypeAheadField<JobTitleModel1>(
        controller: controller,
        builder: (context, controller, focusNode) {
          return CustomTextFieldforAll(
            controller: controller,
            hint: hintText,
            focusNode: focusNode,
          );

          /* TextField(
            inputFormatters: name == "pin_code"
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            keyboardType: name == "pin_code"
                ? TextInputType.number
                : TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              counterText: "",
              hintText: hintText,
              hintStyle: GoogleFonts.montserrat(
                color: Constants.subtitleclr,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Constants.lightdull),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Constants.lightdull,
                ), // light border
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Constants.lightdull),
              ),
              focusColor: const Color(0x0ff0eceb),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
              //contentPadding: const EdgeInsets.only(left: 15),
            ),
          ); */
        },
        decorationBuilder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colors.bottomsheetbgColor,
            ),
            child: child,
          );
        },
        suggestionsCallback: (pattern) async {
          if (pattern.isNotEmpty) {
            await suggestionProvider.fetchSuggestions(pattern, name, type);
            return suggestionProvider.suggestions;
          }
          return [];
        },
        itemBuilder: (context, suggestion) {
          List<String> parts = suggestion.formateData.toString().split(',');
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
                title: type == SuggestionType.resideat
                    ? (data)
                    : (suggestion.value ?? ''),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors.headingColor,
              ),
            ),
          );
        },
        onSelected: (suggestion) {
          List<String> parts = suggestion.formateData.toString().split(',');
          if (parts.length > 1) {
            parts.removeLast(); // remove last element
          }
          final data = parts.map((e) => e.trim()).join(', ');
          controller.text = type == SuggestionType.resideat
              ? data
              : suggestion.value ?? '';
          onChanged(true);
          onIdSelected(suggestion.id ?? 0);
          FocusScope.of(context).unfocus();
        },
        emptyBuilder: (context) {
          if (controller.text.isEmpty) {
            return const SizedBox.shrink();
          }
          return InkWell(
            onTap: () {
              if (type == SuggestionType.resideat) {
                FocusScope.of(context).unfocus();
                controller.clear();
              }
              if (name == "pin_code" && controller.text.length < 6) {
                CustomSnackbar.show("Add Proper Pin Code", true);
              } else {
                FocusManager.instance.primaryFocus?.unfocus(); // ✅ yeh lagao
                onChanged(true);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: colors.bottomsheetbgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: customText(
                  monst: true,
                  fontSize: 12,
                  title: EnableAddOption ? "Add $title" : "No result found.",
                  fontWeight: FontWeight.w600,
                  color: colors.headingColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
