// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:job_circle/components/custom_remark.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/screens/Billing/model/payment_status_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

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
                    border: Border.all(color: Constants.lightdull),
                    borderRadius: BorderRadius.circular(8)),
                child: const CustomNetworkImage(
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/128/11354/11354707.png",
                  height: 6,
                  defaultIcon: Icons.abc,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextForWeather(
                      title: invoice.orgizationName,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextForMonst(
                          title: invoice.invoiceNo.toString(),
                          fontSize: 12,
                          color: Constants.subtitleclr,
                        ),
                        customTextForMonst(
                          title:
                              "₹ ${invoice.invoiceAmount.toString().replaceAll('.0', '')}",
                          fontWeight: FontWeight.bold,
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
                  valueColor: Constants.black,
                  title: "Transaction No & Date"),
            ),
          if (invoice.paymentStatus == "reject")
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                CustomRemarkConatiner(
                    fontsize: 11,
                    subtitle: "Does not meet payment processing criteria.",
                    valueColor: Constants.black,
                    title: "Decline")
              ],
            ),
          if (invoice.paymentStatus == "inprocess")
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                CustomRemarkConatiner(
                    fontsize: 11,
                    subtitle:
                        "Invoice under validation. Please wait for approval",
                    valueColor: Constants.black,
                    title: "Validation")
              ],
            ),
          if (invoice.paymentStatus == "invoicesent")
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                CustomRemarkConatiner(
                    fontsize: 11,
                    subtitle:
                        "Pending by Processing Team will be process shortly.",
                    valueColor: Constants.black,
                    title: "Invoice Sent")
              ],
            ),
          if (invoice.paymentStatus == "Incorrect")
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                CustomRemarkConatiner(
                    fontsize: 11,
                    subtitle:
                        "Invoice not approved by finance - please review and resubmit.",
                    valueColor: Constants.black,
                    title: "Incorrect")
              ],
            ),
        ],
      ),
    );
  }
}
