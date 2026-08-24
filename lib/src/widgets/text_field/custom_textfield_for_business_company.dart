// ignore_for_file: unused_local_variable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/business_page/company_suggestion_model.dart';
import 'package:job_circle/src/provider/business_page/custom_suggestion_textfield_provider.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class CustomTextFieldForBusinessCompany extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;
  final Function(int) onIdSelected;
  final Function(bool) onChanged;
  final FocusNode? focusNode;

  const CustomTextFieldForBusinessCompany({
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
    final suggestionProvider = Provider.of<BusinessCompanySuggestionProvider>(
      context,
    );

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 25,
      //  margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TypeAheadField<ApprovedCompany>(
        controller: controller,
        builder: (context, controller, focusNode) {
          return CustomTextFieldforAll(
            controller: controller,
            hint: hintText,
            focusNode: this.focusNode ?? focusNode,
          );
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
            await suggestionProvider.fetchSuggestions(pattern);
            return suggestionProvider.suggestions;
          }
          return [];
        },
        itemBuilder: (context, suggestion) {
          List<String> parts = suggestion.companyName.toString().split(',');
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
            child: CustomListTile(
              leading: CircleAvatar(
                backgroundColor: Constants.borderColor,
                radius: 20,
                backgroundImage:
                    suggestion.logoUrl != null && suggestion.logoUrl!.isNotEmpty
                    ? NetworkImage(suggestion.logoUrl!)
                    : NetworkImage(CustomIconUrl.companyicon),
              ),
              title: customText(
                title: (suggestion.companyName),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors.headingColor,
              ),
              subtitle: customText(
                title:
                    "${suggestion.companyCity!} || ${suggestion.industryType}",
                fontSize: 11,
                color: colors.subTitleColor,
              ),
            ),
          );
        },
        onSelected: (suggestion) {
          List<String> parts = suggestion.companyName.toString().split(',');
          if (parts.length > 1) {
            parts.removeLast(); // remove last element
          }
          controller.text = suggestion.companyName;
          onChanged(true);
          onIdSelected(suggestion.id);
        },
        emptyBuilder: (context) {
          if (controller.text.isEmpty) {
            return const SizedBox.shrink();
          }
          return InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                color: colors.bottomsheerCard1Color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomListTile(
                title: customText(
                  monst: true,
                  fontSize: 12,
                  title: "Add $title",
                  fontWeight: FontWeight.w600,
                  color: colors.subTitleColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
