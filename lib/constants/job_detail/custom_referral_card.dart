// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:job_circle/models/job_detail/job_detail_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class ReferralProgramCard extends StatelessWidget {
  final PayoutDetails payoutDetails;

  const ReferralProgramCard({
    super.key,
    required this.payoutDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "Talent Referral Program",
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          Container(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Constants.lightyellow,
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
                              bottom: 10, top: 10, left: 25, right: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // width: 200,
                          child: const customTextForWeather(
                              title: "Refer Now",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Constants.darkBlue)),
                    ],
                  ),
                ),

                // Right side - Image
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.network(
                        "https://cdn-icons-png.flaticon.com/256/14356/14356000.png",
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const customTextForWeather(
                        title: "T&C apply",
                        fontSize: 8,
                        color: Constants.darkBlack,
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

  String extractAmount(String text) {
    final regex = RegExp(r'(\d+)(?:\.00)?');
    final match = regex.firstMatch(text);
    return match != null ? match.group(1)! : '';
  }

  Widget buildPayoutContainer(
      PayoutDetails payoutDetails, BuildContext context) {
    final String payoutType = payoutDetails.partnerPayoutType;
    final String partner = payoutDetails.formattedPartnerPayout;
    final String special = payoutDetails.formattedSpecialPayout;
    final int paymentClause = payoutDetails.paymentCluase;
    final List<Slab> slabs = payoutDetails.slabs;
    final String partnerpayment =
        extractAmount(payoutDetails.formattedPartnerPayout);
    final String specialpayment =
        extractAmount(payoutDetails.formattedSpecialPayout);
    final int days = payoutDetails.paymentCluase;

    if (payoutType == "FLAT" && special.isNotEmpty && partner.isNotEmpty) {
      // Both flat and special payouts are available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "Earn more when they stay!",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.currency_rupee_rounded,
                  size: 22, color: Constants.darkBlue),
              customTextForSignika(
                title: "${partnerpayment}/-",
                color: Constants.darkBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customTextForWeather(
                title: " (${days} days)",
                color: Constants.darkBlack,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.currency_rupee_rounded,
                  size: 22, color: Constants.darkBlue),
              customTextForSignika(
                title: "${specialpayment}/-",
                color: Constants.darkBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const customTextForWeather(
                title: " (30 days)",
                color: Constants.darkBlack,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),
        ],
      );
    } else if (payoutType == "FLAT" && special.isEmpty) {
      // Only flat payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "We’re hiring! You’re earning",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          const customTextForWeather(
            title: "refer someone & get",
            color: Constants.darkBlack,
            fontSize: 14,
          ),
          Row(
            children: [
              const Icon(Icons.currency_rupee_rounded,
                  size: 22, color: Constants.darkBlue),
              customTextForSignika(
                title: "${partnerpayment}/-",
                color: Constants.darkBlack,
                fontSize: 20,
              ),
              const customTextForWeather(
                title: " per candidate",
                color: Constants.darkBlack,
                fontSize: 14,
              ),
            ],
          )
        ],
      );
    } else if (partner.isEmpty && special.isNotEmpty) {
      // Only special payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "We’re hiring! You’re earning",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          const customTextForWeather(
            title: "refer someone & get",
            color: Constants.darkBlack,
            fontSize: 14,
          ),
          Row(
            children: [
              const Icon(Icons.currency_rupee_rounded,
                  size: 22, color: Constants.darkBlue),
              customTextForSignika(
                title: "${specialpayment}/-",
                color: Constants.darkBlack,
                fontSize: 20,
              ),
              const customTextForWeather(
                title: " per candidate",
                color: Constants.darkBlack,
                fontSize: 14,
              ),
            ],
          )
        ],
      );
    } else if (payoutType == "SLAB") {
      // Payout type is Slab
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "Refer talent. Get rewarded",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              const customTextForWeather(
                title: "Earn up to",
                color: Constants.darkBlack,
                fontSize: 14,
              ),
              const Icon(Icons.currency_rupee_rounded,
                  size: 22, color: Constants.darkBlue),
              customTextForSignika(
                title: slabs.isNotEmpty
                    ? "${slabs.last.formattedAmount.split(':').last.trim()}/-"
                    : "N/A",
                color: Constants.darkBlack,
                fontSize: 20,
              ),
              const SizedBox(
                width: 3,
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
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customTextForWeather(
                                  title: "Slab Details ($days days)",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 8),
                                ...slabs.map((slab) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: customTextForWeather(
                                          title:
                                              "${slab.formattedAmount}/- per candidate",
                                          fontSize: 14),
                                    )),
                                const SizedBox(height: 8),
                                Stack(
                                  children: [
                                    const Divider(
                                      color: Constants.darkBlack,
                                      thickness: 1,
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            color: Colors.white,
                                            child: const customTextForWeather(
                                                title: "OR")))
                                  ],
                                ),
                                if (specialpayment.isNotEmpty)
                                  SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        const customTextForWeather(
                                          title: "Special Payout (30 days)",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 8),
                                        customTextForWeather(
                                          title:
                                              "${specialpayment}/- per candidate",
                                          fontSize: 14,
                                        ),
                                      ],
                                    ),
                                  )
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
                  child: const Icon(Icons.info_outline,
                      size: 20, color: Constants.subtitleclr)),
              const customTextForWeather(
                title: "for each successful referral!",
                color: Constants.darkBlack,
                fontSize: 14,
              ),
            ],
          ),
        ],
      );
    } else if (payoutType == "CTC Based" && special.isEmpty) {
      // Payout type is CTC Based and no special payout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "Refer top talent and earn big",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          const customTextForWeather(
            title: "we’ll pay you a ",
            color: Constants.darkBlack,
            fontSize: 14,
          ),
          Row(
            children: [
              customTextForWeather(
                title: "${partnerpayment} ",
                color: Constants.darkBlue,
                fontSize: 20,
              ),
              const customTextForWeather(
                title: "of their CTC!",
                color: Constants.darkBlack,
                fontSize: 14,
              ),
            ],
          ),
        ],
      );
    } else if (payoutType == "CTC Based" && special.isNotEmpty) {
      // Payout type is CTC Based and special payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title: "Two Ways to Earn from Referrals",
            color: Constants.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.currency_rupee_rounded,
                  size: 22, color: Constants.darkBlue),
              customTextForSignika(
                title: "${specialpayment}/-",
                color: Constants.darkBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const customTextForWeather(
                title: " (30 days)",
                color: Constants.darkBlack,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.currency_rupee_rounded,
                  size: 22, color: Constants.darkBlue),
              customTextForSignika(
                title: partnerpayment,
                color: Constants.darkBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              customTextForWeather(
                title: "of the CTC ($days days)",
                color: Constants.darkBlack,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ],
          ),
          /* const customTextForWeather(
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
          const customTextForWeather(
            title:
                "Refer talent. Get rewarded. Earn up to ₹2,000 ℹ for each successful referral!",
            color: Constants.darkBlue,
            fontSize: 16,
          ),
          customTextForWeather(
            title: "Referral program active under $payoutType payout type",
            color: Constants.darkBlack,
            fontSize: 14,
          ),
        ],
      );
    } else if (payoutType == "SHARING_RATIO" && special.isNotEmpty) {
      // Payout type is Ratio and special payout is available
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customTextForWeather(
            title:
                "Refer talent. Get rewarded. Earn up to ₹2,000 ℹ for each successful referral!",
            color: Constants.darkBlue,
            fontSize: 16,
          ),
          customTextForWeather(
            title: "Referral program active under $payoutType payout type",
            color: Constants.darkBlack,
            fontSize: 14,
          ),
        ],
      );
    }

    // Default fallback
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextForWeather(
          title: "Heading to the referral",
          color: Constants.orange,
          fontSize: 18,
        ),
        customTextForWeather(
          title: "Default referral message",
          color: Constants.darkBlack,
          fontSize: 14,
        ),
      ],
    );
  }
}
