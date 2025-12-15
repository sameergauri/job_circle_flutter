import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/screen/career_preference.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CareerProfileCard extends StatelessWidget {
  String _formatLPA(String? salary) {
    if (salary == null || salary.isEmpty) return '';
    double value = (double.tryParse(salary) ?? 0) / 100000;
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    } else {
      return value.toStringAsFixed(1);
    }
  }

  final CareerPreferenceProvider careerPreferenceProvider;
  const CareerProfileCard({super.key, required this.careerPreferenceProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CustomNetworkImage(
                  imageUrl: CustomIconUrl.careerpreficon,
                  defaultIcon: Icons.language,
                ),
              ),
              SizedBox(width: 5),
              const customText(
                title: "Career Preference",
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        /// 🔹 Add Button if no language found
                        InkWell(
                          onTap: () {
                            NavigationService.push(
                              CareerPreference(isFromDrawer: false),
                            );
                          },
                          child: CustomNetworkImage(
                            imageUrl: CustomIconUrl.editicon,
                            defaultIcon: Icons.edit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildRowSingle(
            label: "Industry",
            value:
                careerPreferenceProvider.model.industry == null ||
                    careerPreferenceProvider.model.industry!.isEmpty
                ? "Add Industry"
                : careerPreferenceProvider.model.industry!.join(", "),
          ),
          _buildDivider(),

          _buildRowSingle(
            label: "Job Role",
            value:
                careerPreferenceProvider.model.role == null ||
                    careerPreferenceProvider.model.role!.isEmpty
                ? "Add Job Role"
                : careerPreferenceProvider.model.role!.join(", "),
          ),

          _buildDivider(),
          _buildRow(
            label1: "Work location",
            value1:
                careerPreferenceProvider.model.location == null ||
                    careerPreferenceProvider.model.location!.isEmpty
                ? "Add Preferred Location"
                : careerPreferenceProvider.model.location!.join(", "),
            label2: "Open to Relocate",
            value2: careerPreferenceProvider.model.openToRelocate == true
                ? "Yes"
                : "No",
          ),

          _buildDivider(),

          _buildRow(
            label1: "Employment type",
            value1: careerPreferenceProvider.model.empType == "partTime"
                ? "Part Time"
                : careerPreferenceProvider.model.empType == "fullTime"
                ? "Full Time"
                : careerPreferenceProvider.model.empType == "freelance"
                ? "Freelance"
                : careerPreferenceProvider.model.empType == "internship"
                ? "Internship"
                : careerPreferenceProvider.model.empType == "contract"
                ? "Contract"
                : careerPreferenceProvider.model.empType == "flexible"
                ? "Flexible"
                : "Add Employment type",
            label2: "Work mode",
            value2:
                (careerPreferenceProvider.model.workMode != null &&
                    careerPreferenceProvider.model.workMode!.isNotEmpty &&
                    careerPreferenceProvider.model.workMode is List)
                ? (careerPreferenceProvider.model.workMode as List)
                      .map((mode) {
                        if (mode == "office") return "Onsite";
                        if (mode == "home") return "Remote";
                        if (mode == "hybrid") return "Hybrid";
                        return mode.toString();
                      })
                      .join(", ")
                : "Add Work mode",
          ),
          _buildDivider(),
          _buildRow(
            label1: "Salary Range",
            value1:
                careerPreferenceProvider.model.startSalary == null ||
                    careerPreferenceProvider.model.startSalary == "0.0" ||
                    careerPreferenceProvider.model.endSalary == "0.0" ||
                    careerPreferenceProvider.model.endSalary == null
                ? "Add Salary"
                : "${_formatLPA(careerPreferenceProvider.model.startSalary)} LPA - ${_formatLPA(careerPreferenceProvider.model.endSalary)} LPA",
            // Only one definition at the end of the class
            label2: "Notice period",
            value2: careerPreferenceProvider.model.noticePeriod == "immediate"
                ? "Immediate Joiner"
                : careerPreferenceProvider.model.noticePeriod == "fifteenDays"
                ? "15 Days"
                : careerPreferenceProvider.model.noticePeriod == "thirtyDays"
                ? "30 Days"
                : careerPreferenceProvider.model.noticePeriod == "fortyFiveDays"
                ? "45 Days"
                : careerPreferenceProvider.model.noticePeriod == "sixtyDays"
                ? "60 Days"
                : careerPreferenceProvider.model.noticePeriod == "ninetyDays"
                ? "90 Days"
                : "Add Notice Period",
          ),
          _buildDivider(),
          _buildRowSingle(
            label: "Shift Time",
            value:
                careerPreferenceProvider.model.shiftTime == null ||
                    careerPreferenceProvider.model.shiftTime == " " ||
                    careerPreferenceProvider.model.shiftTime == ""
                ? "Add Shift Time"
                : careerPreferenceProvider.model.shiftTime
                      .toString()
                      .toTitleCase(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(height: 1, color: Colors.grey.shade200),
    );
  }

  Widget _buildRow({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
  }) {
    bool isAddAction1 = value1.startsWith("Add ");
    bool isAddAction2 = value2.startsWith("Add ");

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                title: label1,
                color: Constants.subtitleclr,
                fontSize: 12,
              ),
              const SizedBox(height: 3),
              InkWell(
                onTap: isAddAction1
                    ? () {
                        NavigationService.push(
                          CareerPreference(isFromDrawer: false),
                        );
                      }
                    : null,
                child: customText(
                  title: value1,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isAddAction1 ? Constants.darkBlue : Colors.black,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                title: label2,
                color: Constants.subtitleclr,
                fontSize: 12,
              ),
              const SizedBox(height: 3),
              InkWell(
                onTap: isAddAction2
                    ? () {
                        NavigationService.push(
                          CareerPreference(isFromDrawer: false),
                        );
                      }
                    : null,
                child: customText(
                  title: value2,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isAddAction2 ? Constants.darkBlue : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRowSingle({required String label, required String value}) {
    bool isAddAction = value.startsWith("Add ");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title: label, color: Constants.subtitleclr, fontSize: 12),
        const SizedBox(height: 4),

        /// clickable only if value is "Add something"
        InkWell(
          onTap: isAddAction
              ? () {
                  NavigationService.push(CareerPreference(isFromDrawer: false));
                }
              : null,
          child: customText(
            title: value,
            color: isAddAction ? Constants.darkBlue : Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
