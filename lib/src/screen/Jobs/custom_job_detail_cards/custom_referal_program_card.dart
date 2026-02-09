// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ReferralProgramCard extends StatelessWidget {
  final PayoutDetails payoutDetails;

  const ReferralProgramCard({super.key, required this.payoutDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title: "Talent Referral Program",
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Constants.darkBlue,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 4,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Constants.yelloLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Left side - Text
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildPayoutContainer(payoutDetails, context),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 5),
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                          left: 25,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // width: 200,
                        child: const customText(
                          title: "Refer Now",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Constants.darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side - Image
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      payoutDetails.partnerPayoutType == "FLAT"
                          ? Image.asset(
                              CustomAssetUrl.refericon,
                              height: 120,
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              CustomIconUrl.refericon,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                      const SizedBox(height: 4),
                      customText(
                        title: "T&C apply",
                        fontSize: 8,
                        color: Constants.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  String extractAmount(String text) {
    final regex = RegExp(r'(\d+)(?:\.00)?');
    final match = regex.firstMatch(text);
    return match != null ? match.group(1)! : '';
  }

  Widget buildPayoutContainer(
    PayoutDetails payoutDetails,
    BuildContext context,
  ) {
    final String payoutType = payoutDetails.partnerPayoutType;
    final String partner = payoutDetails.formattedPartnerPayout;
    final String special = payoutDetails.formattedSpecialPayout;
    final int paymentClause = payoutDetails.paymentCluase;
    final partnerSlabs = payoutDetails.slabs
        .where((slab) => slab.targetType.toUpperCase() == "PARTNER")
        .toList();
    final String partnerpayment = extractAmount(
      payoutDetails.formattedPartnerPayout,
    );
    final String specialpayment = extractAmount(
      payoutDetails.formattedSpecialPayout,
    );
    final int days = payoutDetails.paymentCluase;

    if (payoutType == "FLAT" &&
        special.isNotEmpty &&
        partner.isNotEmpty &&
        specialpayment != "0") {
      // Both flat and special payouts are available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const customText(
            title: "Earn more when they stay!",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 22,
                color: Constants.darkBlue,
              ),
              customText(
                monst: false,
                title: "${partnerpayment}/-",
                color: Constants.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customText(
                title: " (${days} days)",
                color: Constants.black,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 22,
                color: Constants.darkBlue,
              ),
              customText(
                monst: false,
                title: "${specialpayment}/-",
                color: Constants.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customText(
                title: " (30 days)",
                color: Constants.black,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),
        ],
      );
    } else if (payoutType == "FLAT" &&
        (special.isEmpty || specialpayment == "0")) {
      // Only flat payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title: "We’re hiring! You’re earning",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          customText(
            title: "refer someone & get",
            color: Constants.black,
            fontSize: 14,
          ),
          Row(
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 22,
                color: Constants.darkBlue,
              ),
              customText(
                title: "${partnerpayment}/-",
                color: Constants.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customText(
                title: " per candidate",
                color: Constants.black,
                fontSize: 14,
              ),
            ],
          ),
        ],
      );
    } else if (partner.isEmpty && special.isNotEmpty && specialpayment != "0") {
      // Only special payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title: "We’re hiring! You’re earning",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          customText(
            title: "refer someone & get",
            color: Constants.black,
            fontSize: 14,
          ),
          Row(
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 22,
                color: Constants.darkBlue,
              ),
              customText(
                monst: false,
                title: "${specialpayment}/-",
                color: Constants.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customText(
                title: " per candidate",
                color: Constants.black,
                fontSize: 14,
              ),
            ],
          ),
        ],
      );
    } else if (payoutType == "SLAB") {
      // Payout type is Slab
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title: "Refer talent. Get rewarded",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              customText(
                title: "Earn up to",
                color: Constants.black,
                fontSize: 14,
              ),
              const Icon(
                Icons.currency_rupee_rounded,
                size: 22,
                color: Constants.darkBlue,
              ),
              customText(
                monst: false,
                title: partnerSlabs.isNotEmpty
                    ? "${partnerSlabs.last.formattedAmount.split(':').last.trim()}/-"
                    : "N/A",
                color: Constants.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 3),
              InkWell(
                onTap: () {
                  // Show a tooltip-like container above the icon when tapped
                  OverlayEntry? overlayEntry;
                  final RenderBox iconRenderBox =
                      context.findRenderObject() as RenderBox;
                  final Offset iconPosition = iconRenderBox.localToGlobal(
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    title: "Slab Details ($days days)",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...partnerSlabs.map(
                                (slab) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: customText(
                                    title:
                                        "${formatSlabLabel(slab.formattedAmount)}/- Per Joiner",
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (specialpayment.isNotEmpty &&
                                  specialpayment != "0")
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Icon(Icons.linear_scale_sharp),
                                    ),
                                  ],
                                ),
                              if (specialpayment.isNotEmpty &&
                                  specialpayment != "0")
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      const customText(
                                        title: "Special Payout (30 days)",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 8),
                                      customText(
                                        title: "${specialpayment}/- Per Joiner",
                                        fontSize: 10,
                                      ),
                                    ],
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
                  size: 20,
                  color: Constants.darkBlue,
                ),
              ),
              customText(
                title: "for each successful referral!",
                color: Constants.black,
                fontSize: 14,
              ),
            ],
          ),
        ],
      );
    } else if (payoutType == "CTC_BASED" &&
        (special.isEmpty || specialpayment == "0")) {
      // Payout type is CTC Based and no special payout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title: "Refer top talent and earn big",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          customText(
            title: "we’ll pay you a ",
            color: Constants.black,
            fontSize: 14,
          ),
          Row(
            children: [
              customText(
                title: "${partnerpayment}%",
                color: Constants.darkBlue,
                fontSize: 20,
              ),
              customText(
                title: "of their CTC!",
                color: Constants.black,
                fontSize: 14,
              ),
            ],
          ),
        ],
      );
    } else if (payoutType == "CTC_BASED" &&
        special.isNotEmpty &&
        specialpayment != "0") {
      // Payout type is CTC Based and special payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title: "Two Ways to Earn from Referrals",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 22,
                color: Constants.darkBlue,
              ),
              customText(
                monst: false,
                title: "${partnerpayment}%",
                color: Constants.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customText(
                title: " of the CTC ($days days)",
                color: Constants.black,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 22,
                color: Constants.darkBlue,
              ),
              customText(
                monst: false,
                title: "${specialpayment}/-",
                color: Constants.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customText(
                title: " (30 days)",
                color: Constants.black,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),

          /* const customText(
            title:
                "Earn ₹1,000 for quick closures in 30 days\nOr go big with 5% of the CTC for long-term in 90 days.",
            color: Constants.darkBlack,
            fontSize: 14,
          ), */
        ],
      );
    } else if (payoutType == "SHARING_RATIO" && special.isEmpty) {
      // Payout type is Ratio and no special payout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title:
                "Refer talent. Get rewarded. Earn up to ₹2,000 ℹ for each successful referral!",
            color: Constants.darkBlue,
            fontSize: 16,
          ),
          customText(
            title: "Referral program active under $payoutType payout type",
            color: Constants.black,
            fontSize: 14,
          ),
        ],
      );
    } else if (payoutType == "SHARING_RATIO" && special.isNotEmpty) {
      // Payout type is Ratio and special payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title:
                "Refer talent. Get rewarded. Earn up to ₹2,000 ℹ for each successful referral!",
            color: Constants.darkBlue,
            fontSize: 16,
          ),
          customText(
            title: "Referral program active under $payoutType payout type",
            color: Constants.black,
            fontSize: 14,
          ),
        ],
      );
    }

    // Default fallback
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          title: "Heading to the referral",
          color: Constants.orange,
          fontSize: 18,
        ),
        customText(
          title: "Default referral message",
          color: Constants.black,
          fontSize: 14,
        ),
      ],
    );
  }
}
