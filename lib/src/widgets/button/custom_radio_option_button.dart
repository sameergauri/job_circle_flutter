import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';


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
    final specialpayment = extractPayoutAsInt(
      payoutDetails.formattedSpecialPayout,
    );
    final days = payoutDetails.paymentCluase;

    return payoutDetails.partnerPayoutType == "FLAT"
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: onTap1,
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          isSelected1
                              ? Icons.radio_button_checked_outlined
                              : Icons.radio_button_off,
                          color: isSelected1
                              ? Constants.darkBlue
                              : Constants.subtitleclr,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 8)),
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.currency_rupee_rounded,
                          size: 16,
                          color: Constants.darkBlue,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text:
                            "$partnerpayment if the candidate completes $days of employment",
                        style: GoogleFonts.merriweather(
                          fontSize: 12,
                          color: Constants.black,
                          fontWeight: isSelected1
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
              if (payoutDetails.formattedSpecialPayout.isNotEmpty &&
                  specialpayment != 0)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: onTap2,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              isSelected2
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.radio_button_off,
                              color: isSelected2
                                  ? Constants.themeBgColor
                                  : Constants.subtitleclr,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 8)),
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.currency_rupee_rounded,
                              size: 16,
                              color: Constants.darkBlue,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(
                            text:
                                "$specialpayment if the candidate completes 30 days of employment",
                            style: GoogleFonts.merriweather(
                              fontSize: 12,
                              color: Constants.black,
                              fontWeight: isSelected2
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              const customText(
                fontStyle: FontStyle.italic,
                color: Constants.subtitleclr,
                title:
                    "I hereby confirm that I am referring a candidate under the selected payout scheme and understand that the referral reward will be processed only upon fulfillment of the respective clause.",
              ),
            ],
          )
        : payoutDetails.partnerPayoutType == "CTC_BASED"
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: onTap1,
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          isSelected1
                              ? Icons.radio_button_checked_outlined
                              : Icons.radio_button_off,
                          color: isSelected1
                              ? Constants.themeBgColor
                              : Constants.subtitleclr,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 8)),
                      TextSpan(
                        text:
                            "$partnerpayment% of the candidate’s CTC if the candidate completes $days days of employment",
                        style: GoogleFonts.merriweather(
                          fontSize: 12,
                          color: Constants.black,
                          fontWeight: isSelected1
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
              if (payoutDetails.formattedSpecialPayout.isNotEmpty &&
                  specialpayment != 0)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: onTap2,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              isSelected2
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.radio_button_off,
                              color: isSelected2
                                  ? Constants.themeBgColor
                                  : Constants.subtitleclr,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 8)),
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.currency_rupee_rounded,
                              size: 16,
                              color: Constants.darkBlue,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(
                            text:
                                "$specialpayment if the candidate completes 30 days of employment",
                            style: GoogleFonts.merriweather(
                              fontSize: 12,
                              color: Constants.black,
                              fontWeight: isSelected2
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              const customText(
                fontStyle: FontStyle.italic,
                color: Constants.subtitleclr,
                title:
                    "I hereby confirm that I am referring a candidate under the selected payout scheme and understand that the referral reward will be processed only upon fulfillment of the respective clause.",
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: onTap1,
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          isSelected1
                              ? Icons.radio_button_checked_outlined
                              : Icons.radio_button_off,
                          color: isSelected1
                              ? Constants.themeBgColor
                              : Constants.subtitleclr,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 6)),
                      TextSpan(
                        text: "Up to ",
                        style: GoogleFonts.merriweather(
                          fontWeight: isSelected1
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: Constants.black,
                          fontSize: 12,
                        ),
                      ),
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.currency_rupee_rounded,
                          size: 16,
                          color: Constants.darkBlue,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${partnerSlabs.last.formattedAmount.split(':').last.trim()} ",
                        style: GoogleFonts.merriweather(
                          fontWeight: isSelected1
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: Constants.black,
                          fontSize: 12,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {
                            OverlayEntry? overlayEntry;
                            final RenderBox renderBox =
                                context.findRenderObject() as RenderBox;
                            final Offset iconPosition = renderBox.localToGlobal(
                              Offset.zero,
                            );

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
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const customText(
                                          title: "Slab Details (90 days)",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 8),
                                        ...partnerSlabs.map(
                                          (slab) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 2.0,
                                            ),
                                            child: customText(
                                              title:
                                                  "${formatSlabLabel(slab.formattedAmount)}/- per candidate",
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );

                            Overlay.of(context).insert(overlayEntry);
                            Future.delayed(const Duration(seconds: 3), () {
                              overlayEntry?.remove();
                            });
                          },
                          child: const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Constants.darkBlue,
                          ),
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text:
                            "(as per payout slab) if the candidate completes $days days of employment.",
                        style: GoogleFonts.merriweather(
                          fontWeight: isSelected1
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: Constants.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
              if (payoutDetails.formattedSpecialPayout.isNotEmpty &&
                  specialpayment != 0)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: onTap2,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              isSelected2
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.radio_button_off,
                              color: isSelected2
                                  ? Constants.themeBgColor
                                  : Constants.subtitleclr,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 8)),
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.currency_rupee_rounded,
                              size: 16,
                              color: Constants.darkBlue,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(
                            text:
                                "$specialpayment if the candidate completes 30 days of employment",
                            style: GoogleFonts.merriweather(
                              fontSize: 12,
                              color: Constants.black,
                              fontWeight: isSelected2
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              const customText(
                fontStyle: FontStyle.italic,
                color: Constants.subtitleclr,
                title:
                    "I hereby confirm that I am referring a candidate under the selected payout scheme and understand that the referral reward will be processed only upon fulfillment of the respective clause.",
              ),
            ],
          );
  }
}
