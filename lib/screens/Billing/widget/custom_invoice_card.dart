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
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            ListTile(
              splashColor: Constants.bgColorWhite,
              dense: true,
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              leading: const CustomNetworkImage(
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/128/1159/1159679.png",
                  height: 24,
                  defaultIcon: Icons.abc),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextForWeather(
                    title: invoice.orgizationName,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    title: invoice.invoiceNo.toString(),
                    fontSize: 12,
                    color: Constants.subtitleclr,
                  ),
                  customText(
                    title:
                        "₹ ${invoice.invoiceAmount.toString().replaceAll('.0', '')}",
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
