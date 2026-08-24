import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/upload_file.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class Page2BusinessDetails extends StatelessWidget {
  const Page2BusinessDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusinessCompanyProvider>();
    final height = MediaQuery.of(context).size.height;
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                InkWell(
                  onTap:
                      provider.companyLogo != '' && provider.companyLogo != ' '
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Constants.themeBgColor,
                                      radius: height / 6,
                                      backgroundImage: Image.network(
                                        "${GlobalConstants.Image_url}${provider.companyLogo}",
                                        fit: BoxFit.fill,
                                      ).image,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () async {
                                          NavigationService.pop();
                                          provider.setCompanyLogo('');
                                        },
                                        icon: CustomNetworkImage(
                                          imageUrl: CustomIconUrl.deleteicon,
                                          defaultIcon: Icons.cast_for_education,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      : () {},
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Constants.borderColor,
                    backgroundImage:
                        provider.companyLogo != '' &&
                            provider.companyLogo != " "
                        ? NetworkImage(
                            "${GlobalConstants.Image_url}${provider.companyLogo}",
                          )
                        : NetworkImage(CustomIconUrl.companyicon),
                  ),
                ),
                if (provider.companyLogo == '' || provider.companyLogo == ' ')
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        FileUploader fileUploader = FileUploader();
                        var data1 = await fileUploader.uploadFile(context, [
                          'jpeg',
                          'jpg',
                          "png",
                        ], "companyLogo");
                        if (data1 != null) {
                          provider.setCompanyLogo(data1);
                        }
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          customText(title: "Company Code",color: colors.headingColor,),
          CustomTextFieldforAll(
            controller: provider.companyCodeController,
            hint: "1234567",
            isGmail: true,
          ),
          SizedBox(height: 10),
          customText(title: "Firm Legal Name*", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.firmLegalNameController,
            hint: "ABC solution",
          ),
          SizedBox(height: 10),
          customText(title: "Firm shirt/ Brand name*",
            color: colors.headingColor,
          ),
          CustomTextFieldforAll(
            controller: provider.brandNameController,
            hint: "ABC",
          ),
          SizedBox(height: 10),
          customText(title: "Tagline", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.taglineController,
            hint: "Briefly describe whatt yout organization does.",
          ),
          SizedBox(height: 10),
          customText(title: "Company website", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.websiteController,
            hint: "www.jobcircle.co.in",
            isGmail: true,
          ),
          SizedBox(height: 10),
          const SizedBox(height: 12),
          customText(
            title: 'Type of organization*',color: colors.headingColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Proprietorship', 'Partnership', 'Pvt Ltd', 'Public Ltd']
                .map((type) {
                  final isSelected = provider.organizationType == type;
                  return CustomToggleButton(
                    title: type,
                    onTap: () {
                      provider.setOrganizationType(type);
                    },
                    isSelect: isSelected,
                  );
                })
                .toList(),
          ),
          const SizedBox(height: 12),
          customText(title: "Industry / Nature of Business*",
            color: colors.headingColor,
          ),
          CustomTextFieldForMasterData(
            focusNode: provider.industryFocusNode,
            contextIn: context,
            controller: provider.industryController,
            hintText: "Type to search",
            name: "industry",
            title: "Industry",
          ),
          /*  CustomTextFieldforAll(
            controller: provider.industryController,
            hint: "Select Domain",
          ), */
          SizedBox(height: 10),
          customText(title: "Short brief about firm / Company",
            color: colors.headingColor,
          ),
          CustomTextFieldforAll(
            controller: provider.aboutCompanyController,
            hint: "About us",
            maxline: 3,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: "Incorporation Year*",
                      color: colors.headingColor,
                    ),
                    CustomTextFieldforAll(
                      controller: provider.incorporationYearController,
                      hint: "20XX",
                      isNumber: true,
                      isGmail: true,
                      keyboardType: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: "Company Size*",
                      color: colors.headingColor,
                    ),
                    CustomTextFieldforAll(
                      controller: provider.companySizeController,
                      hint: "1 to 10",
                      isNumber: true,
                      isGmail: true,
                      keyboardType: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
