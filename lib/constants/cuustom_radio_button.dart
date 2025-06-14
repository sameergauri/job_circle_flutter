import 'package:flutter/material.dart';
import 'package:job_circle/models/job_detail/job_detail_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart'; // assuming for `customTextForWeather`
import 'package:job_circle/themes/colors.dart'; // update with your actual theme import

class CustomRadioOption extends StatelessWidget {
  final bool isSelected1;
  final bool isSelected2;
  final VoidCallback onTap1;
  final VoidCallback onTap2;
  final PayoutDetails payoutDetails;

  const CustomRadioOption({
    super.key,
    required this.isSelected1,
    required this.isSelected2,
    required this.onTap1,
    required this.onTap2,
    required this.payoutDetails,
  });
  int extractPayoutAsInt(String raw) {
    final m = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(raw);
    if (m == null) throw FormatException("No number found in '$raw'");
    double parsed = double.parse(m.group(1)!);
    return parsed.round();
  }

  String formatSlabLabel(String? input) {
    if (input == null) return '';

    final match = RegExp(r'^(.+?):\s*(\d+)$').firstMatch(input);

    if (match != null) {
      String label = match.group(1)?.trim() ?? '';
      String amount = match.group(2)?.trim() ?? '';

      if (label.contains('-')) {
        final parts = label.split('-');
        if (parts.length == 2 && parts[1] == '0') {
          label = '${parts[0]} & above';
        }
      }

      return '$label: $amount';
    }

    return input;
  }

  @override
  Widget build(BuildContext context) {
    final partnerSlabs = payoutDetails.slabs
        .where((slab) => slab.targetType.toUpperCase() == "PARTNER")
        .toList();

    final partnerpayment = extractPayoutAsInt(
      partnerSlabs.isEmpty ? payoutDetails.formattedPartnerPayout : "1",
    );
    final specialpayment =
        extractPayoutAsInt(payoutDetails.formattedSpecialPayout);
    final days = payoutDetails.paymentCluase;

    return payoutDetails.partnerPayoutType == "FLAT"
        ? Column(
            children: [
              InkWell(
                onTap: onTap1,
                child: Row(
                  children: [
                    Icon(
                      isSelected1
                          ? Icons.radio_button_checked_outlined
                          : Icons.radio_button_off,
                      color: isSelected1
                          ? Constants.themeBgColor
                          : Constants.subtitleclr,
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.currency_rupee_rounded,
                        size: 18, color: Constants.darkBlue),
                    customTextForWeather(
                      title:
                          "${partnerpayment.toString()} if the candidate completes $days of employment",
                      fontSize: 12,
                      color: Constants.black,
                      fontWeight:
                          isSelected1 ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ],
                ),
              ),
              if (payoutDetails.formattedSpecialPayout.isNotEmpty &&
                  specialpayment != 0)
                Container(
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: onTap2,
                        child: Row(
                          children: [
                            Icon(
                              isSelected2
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.radio_button_off,
                              color: isSelected2
                                  ? Constants.themeBgColor
                                  : Constants.subtitleclr,
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.currency_rupee_rounded,
                                size: 18, color: Constants.darkBlue),
                            customTextForWeather(
                              title:
                                  "${specialpayment.toString()} if the candidate completes 30 days of employment",
                              fontSize: 12,
                              color: Constants.black,
                              fontWeight: isSelected2
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              const customTextForWeather(
                  fontStyle: FontStyle.italic,
                  color: Constants.subtitleclr,
                  title:
                      "I hereby confirm that I am referring a candidate under the selected payout scheme and understand that the referral reward will be processed only upon fulfillment of the respective clause."),
            ],
          )
        : payoutDetails.partnerPayoutType == "CTC_BASED"
            ? Column(
                children: [
                  InkWell(
                    onTap: onTap1,
                    child: Row(
                      children: [
                        Icon(
                          isSelected1
                              ? Icons.radio_button_checked_outlined
                              : Icons.radio_button_off,
                          color: isSelected1
                              ? Constants.themeBgColor
                              : Constants.subtitleclr,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: customTextForWeather(
                            title:
                                "${partnerpayment.toString()}% of the candidate’s CTC if the candidate completes $days days of employment",
                            fontSize: 12,
                            color: Constants.black,
                            fontWeight:
                                isSelected1 ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (payoutDetails.formattedSpecialPayout.isNotEmpty &&
                      specialpayment != 0)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: onTap2,
                            child: Row(
                              children: [
                                Icon(
                                  isSelected2
                                      ? Icons.radio_button_checked_outlined
                                      : Icons.radio_button_off,
                                  color: isSelected2
                                      ? Constants.themeBgColor
                                      : Constants.subtitleclr,
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.currency_rupee_rounded,
                                    size: 18, color: Constants.darkBlue),
                                customTextForWeather(
                                  title:
                                      "${specialpayment.toString()} if the candidate completes 30 days of employment",
                                  fontSize: 12,
                                  color: Constants.black,
                                  fontWeight: isSelected2
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const customTextForWeather(
                      fontStyle: FontStyle.italic,
                      color: Constants.subtitleclr,
                      title:
                          "I hereby confirm that I am referring a candidate under the selected payout scheme and understand that the referral reward will be processed only upon fulfillment of the respective clause.")
                ],
              )
            : Column(
                children: [
                  InkWell(
                    onTap: onTap1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isSelected1
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.radio_button_off,
                              color: isSelected1
                                  ? Constants.themeBgColor
                                  : Constants.subtitleclr,
                            ),
                            const SizedBox(width: 10),
                            customTextForWeather(
                              title: "Up to",
                              fontWeight: isSelected1
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            const Icon(Icons.currency_rupee_rounded,
                                size: 18, color: Constants.darkBlue),
                            customTextForWeather(
                              title: partnerSlabs.last.formattedAmount
                                  .split(':')
                                  .last
                                  .trim(),
                              fontSize: 12,
                              color: Constants.black,
                              fontWeight: isSelected1
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            InkWell(
                                onTap: () {
                                  // Show a tooltip-like container above the icon when tapped
                                  OverlayEntry? overlayEntry;
                                  final RenderBox iconRenderBox =
                                      context.findRenderObject() as RenderBox;
                                  final Offset iconPosition =
                                      iconRenderBox.localToGlobal(Offset.zero);

                                  overlayEntry = OverlayEntry(
                                    builder: (context) => Positioned(
                                      left: iconPosition.dx - 10,
                                      top: iconPosition.dy - 120,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Constants.borderColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 8,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const customTextForWeather(
                                                title: "Slab Details (90 days)",
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              const SizedBox(height: 8),
                                              ...partnerSlabs
                                                  .map((slab) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2.0),
                                                        child: customTextForWeather(
                                                            title:
                                                                "${formatSlabLabel(slab.formattedAmount)}/- per candidate",
                                                            fontSize: 10),
                                                      )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );

                                  Overlay.of(context).insert(overlayEntry);

                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    overlayEntry?.remove();
                                  });
                                },
                                child: const Icon(Icons.info_outline,
                                    size: 20, color: Constants.darkBlue)),
                            Expanded(
                              child: customTextForWeather(
                                softwrap: true,
                                title:
                                    "(as per payout slab) if the candidate completes $days days of employment.",
                                fontSize: 12,
                                color: Constants.black,
                                fontWeight: isSelected1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (payoutDetails.formattedSpecialPayout.isNotEmpty &&
                      specialpayment != 0)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: onTap2,
                            child: Row(
                              children: [
                                Icon(
                                  isSelected2
                                      ? Icons.radio_button_checked_outlined
                                      : Icons.radio_button_off,
                                  color: isSelected2
                                      ? Constants.themeBgColor
                                      : Constants.subtitleclr,
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.currency_rupee_rounded,
                                    size: 18, color: Constants.darkBlue),
                                customTextForWeather(
                                  title:
                                      "${specialpayment.toString()} if the candidate completes 30 days of employment",
                                  fontSize: 12,
                                  color: Constants.black,
                                  fontWeight: isSelected2
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const customTextForWeather(
                      fontStyle: FontStyle.italic,
                      color: Constants.subtitleclr,
                      title:
                          "I hereby confirm that I am referring a candidate under the selected payout scheme and understand that the referral reward will be processed only upon fulfillment of the respective clause.")
                ],
              );
  }
}
