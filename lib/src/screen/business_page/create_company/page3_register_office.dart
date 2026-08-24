import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class Page3RegisteredOffice extends StatelessWidget {
  const Page3RegisteredOffice({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusinessCompanyProvider>();
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title: "Premises / Office No*",
            color: colors.headingColor,
          ),
          CustomTextFieldforAll(
            controller: provider.premisesOfficeNoController,
            hint: "Office no 1",
            isGmail: true,
          ),
          SizedBox(height: 10),
          customText(title: "Street*", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.streetController,
            hint: "Street name",
          ),
          SizedBox(height: 10),
          customText(title: "Landmark*", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.landmarkController,
            hint: "Near by place",
          ),
          SizedBox(height: 10),
          customText(title: "Location*", color: colors.headingColor),
          CustomTextFieldForMasterData(
            contextIn: context,
            controller: provider.locationAreaController,
            hintText: "Type to search",
            name: "location",
            title: "Location",
          ),
          /*  CustomTextFieldforAll(
            controller: provider.locationAreaController,
            hint: "Location",
          ), */
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: "City", color: colors.headingColor),
                    CustomTextFieldForMasterData(
                      contextIn: context,
                      controller: provider.cityController,
                      hintText: "Type to search",
                      name: "city",
                      title: "Location",
                    ),
                    /*  CustomTextFieldforAll(
                      controller: provider.cityController,
                      hint: "City name",
                    ), */
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: "Pin Code", color: colors.headingColor),
                    CustomTextFieldForMasterData(
                      contextIn: context,
                      controller: provider.pinCodeController,
                      hintText: "Type to search",
                      name: "pin_code",
                      title: "Pin Code",
                    ),
                    /* CustomTextFieldforAll(
                      controller: provider.pinCodeController,
                      hint: "421-305",
                    ), */
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: "Sate", color: colors.headingColor),
                    CustomTextFieldforAll(
                      controller: provider.stateController,
                      hint: "Maharashtra",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: "Country", color: colors.headingColor),
                    CustomTextFieldforAll(
                      controller: provider.countryController,
                      hint: "India",
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CustomCheckboxRow(
            title: "Head Office same as Registered Office.",
            value: provider.isHeadOfficeSame,
            onChanged: (value) {
              provider.toggleHeadOfficeSame(value!);
            },
          ),
        ],
      ),
    );
  }
}
