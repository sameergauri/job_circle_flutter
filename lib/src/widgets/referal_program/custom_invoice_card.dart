// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/referal_program/ppayment_status_model.dart';
import 'package:job_circle/src/utils/salary_round_off.dart';
import 'package:job_circle/src/widgets/container/custom_remark_coontainer.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/referal_program/custom_title_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomInvoiceCard extends StatelessWidget {
  const CustomInvoiceCard({
    super.key,
    required this.invoice,
    //required this.invoiceTab,
  });

  final InvoiceSent invoice;
  //final InvoiceTab invoiceTab;

  @override
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      //  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      margin: const EdgeInsets.only(left: 10, right: 10),

      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Constants.lightdull,
                  border: Border.all(color: Constants.lightdull),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const CustomNetworkImage(
                  imageUrl: CustomIconUrl.billicon,
                  height: 6,
                  defaultIcon: Icons.abc,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: invoice.orgizationName,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colors.headingColor,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          monst: true,
                          title: invoice.invoiceNo.toString(),
                          fontSize: 12,
                          color: colors.subTitleColor,
                        ),
                        CustomIconTitleButton(
                          height: 20.0,
                          width: 20.0,
                          imageUrl:
                              "https://cdn-icons-png.flaticon.com/128/9798/9798241.png",
                          onTap: () {},
                          title: SalaryRoundOff.customRoundOff(
                            invoice.invoiceAmount.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (invoice.paymentStatus == "paid")
            Container(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: CustomRemarkConatiner(
                fontsize: 11,
                subtitle:
                    "${invoice.transcationNo.toString()} || ${invoice.invoicePaidDate.toString()}",
                valueColor: colors.subTitleColor!,
                title: "Transaction No & Date",
              ),
            ),
          if (invoice.paymentStatus == "reject")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                CustomRemarkConatiner(
                  fontsize: 11,
                  subtitle: "Does not meet payment processing criteria.",
                  valueColor: colors.subTitleColor!,
                  title: "Decline",
                ),
              ],
            ),
          if (invoice.paymentStatus == "inprocess")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                CustomRemarkConatiner(
                  fontsize: 11,
                  subtitle:
                      "Invoice under validation. Please wait for approval",
                  valueColor: colors.subTitleColor!,
                  title: "Validation",
                ),
              ],
            ),
          if (invoice.paymentStatus == "invoicesent")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                CustomRemarkConatiner(
                  fontsize: 11,
                  subtitle:
                      "Pending by Processing Team will be process shortly.",
                  valueColor: colors.subTitleColor!,
                  title: "Invoice Sent",
                ),
              ],
            ),
          if (invoice.paymentStatus == "Incorrect")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                CustomRemarkConatiner(
                  fontsize: 11,
                  subtitle:
                      "Invoice not approved by finance - please review and resubmit.",
                  valueColor: colors.subTitleColor!,
                  title: "Incorrect",
                ),
              ],
            ),
        ],
      ),
    );
  }
}
