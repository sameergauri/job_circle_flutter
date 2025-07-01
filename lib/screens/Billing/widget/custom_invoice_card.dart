import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Constants.subtitleclr),
                borderRadius: BorderRadius.circular(8)),
            child: const CustomNetworkImage(
              imageUrl:
                  "https://cdn-icons-png.flaticon.com/128/1159/1159679.png",
              height: 24,
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
                  fontSize: 13,
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
    );
  }
}
