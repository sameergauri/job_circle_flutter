// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/custom_remark.dart';
import 'package:job_circle/constants/customchechbox.dart';
import 'package:job_circle/constants/viewuploadfile.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Billing/model/payment_status_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_view.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class CustomInvoiveDetailCard extends StatelessWidget {
  const CustomInvoiveDetailCard({
    super.key,
    required this.invoice,
    required this.invoiceTab,
  });

  final InvoiceSent invoice;
  final InvoiceTab invoiceTab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Invoice Date
            Align(
              alignment: Alignment.topRight,
              child: customTextForWeather(
                title: "Invoice date: ${invoice.invoiceSubmitDate}",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Constants.black,
              ),
            ),
            const SizedBox(height: 10),

            // Organization Name & Address (Assumed Static)
            const customTextForWeather(
              title: "To,",
              fontWeight: FontWeight.bold,
            ),
            customTextForWeather(
              title: invoice.orgizationName.toString(),
              fontSize: 12,
              // fontWeight: FontWeight.bold,
            ),
            customTextForWeather(
              title: invoice.orgizationAddress
                  .toString()
                  .split(',')
                  .asMap()
                  .entries
                  .map((entry) => entry.key == 2
                      ? '\n${entry.value.trim()}'
                      : entry.value.trim())
                  .where((part) => part.isNotEmpty)
                  .join(', '),
              fontSize: 12,
              color: Constants.subtitleclr,
            ),
            const SizedBox(height: 10),
            // Invoice Number
            customTextForMonst(
              title: "Invoice No: ${invoice.invoiceNo}",
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 16),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Constants.lightdull,
              child: const Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: customTextForWeather(
                        textAlign: TextAlign.center,
                        title: "Candidate Name",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: customTextForWeather(
                        textAlign: TextAlign.center,
                        title: "PO No.",
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 6,
                    child: customTextForWeather(
                        textAlign: TextAlign.center,
                        title: "DOJ",
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 5,
                    child: customTextForWeather(
                        textAlign: TextAlign.center,
                        title: "Amount",
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Candidate Rows
            ...invoice.candidates.map((candidate) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: customTextForWeather(
                              title: candidate.name.toString()),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: customTextForWeather(
                            textAlign: TextAlign.center,
                            title: candidate.id.toString()),
                      ),
                      Expanded(
                        flex: 6,
                        child: customTextForWeather(
                            textAlign: TextAlign.center,
                            title: candidate.doj != null
                                ? _formatDate(candidate.doj.toString())
                                : ""),
                      ),
                      Expanded(
                        flex: 5,
                        child: customTextForWeather(
                            textAlign: TextAlign.center,
                            title: candidate.payoutAmount != null
                                ? "₹ ${candidate.payoutAmount.toStringAsFixed(0)}"
                                : "null"),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 16),

            // Total Amount
            Align(
              alignment: Alignment.centerRight,
              child: customTextForMonst(
                title: "Total: ₹ ${invoice.invoiceAmount.toStringAsFixed(0)}",
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const customTextForWeather(
                  title: "Amount In Words : ",
                  fontWeight: FontWeight.bold,
                ),
                customTextForWeather(
                    title: convertNumberToWords(invoice.invoiceAmount.toInt())),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(
              title: "Banking Detail",
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextForWeather(
                      title: "Bank Name",
                    ),
                    customTextForWeather(
                      title: "Account Type",
                    ),
                    customTextForWeather(
                      title: "Holder Name(As per Bank Record)",
                    ),
                    customTextForWeather(
                      title: "Account No",
                    ),
                    customTextForWeather(
                      title: "IFSC Code",
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextForWeather(
                      title: " : ${invoice.bankName}",
                    ),
                    customTextForWeather(
                      title: " : ${invoice.accountType}",
                    ),
                    customTextForWeather(
                      title: " : ${invoice.accountHolderName}",
                    ),
                    customTextForMonst(
                      title: " : ${invoice.accountNumber}",
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.6,
                    ),
                    customTextForMonst(
                      title: " : ${invoice.ifscCode}",
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.6,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            CustomCheckboxRow(
                title:
                    'I ${invoice.accountHolderName} hereby acknowledge and agree that the above invoice, accurately represents the services provided. I confirm the authenticity of the information and authorize the processing of the mentioned sum.',
                value: true,
                onChanged: (value) {}),

            Row(
              mainAxisAlignment: invoice.paymentStatus == "paid"
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (invoice.paymentStatus == "paid")
                  Image.network(
                      height: 50,
                      "https://cdn-icons-png.flaticon.com/128/4272/4272841.png"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Organization Name & Address (Assumed Static)
                    const customTextForWeather(
                      title: "From,",
                      fontWeight: FontWeight.bold,
                    ),
                    customTextForWeather(
                        title: invoice.accountHolderName.toString()),
                  ],
                ),
              ],
            ),
            if (invoice.paymentStatus == "paid" &&
                invoice.invoicePaymentReciept != null &&
                invoice.invoicePaymentReciept != "" &&
                invoice.invoicePaymentReciept != "null")
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                      title: "Payment Receipt",
                      fontSize: 14,
                    ),
                    CustomContainerSelectToViewDoc(
                      title: invoice.invoicePaymentReciept.toString(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomPDFViewerDialog(
                                      pdfUrl:
                                          "https://s3.ap-south-1.amazonaws.com/job-circle-2/$invoice.invoicePaymentReciept",
                                    )));
                      },
                    ),
                  ],
                ),
              ),
            if (invoice.paymentStatus == "reject")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  CustomRemarkConatiner(
                      titleColor: Constants.red,
                      fontsize: 11,
                      subtitle: invoice.invoiceRemark.toString(),
                      valueColor: Constants.black,
                      title: "Reason of rejection")
                ],
              ),
            if (invoice.paymentStatus == "incorrect")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  CustomRemarkConatiner(
                      titleColor: Constants.red,
                      fontsize: 11,
                      subtitle: invoice.invoiceRemark.toString(),
                      valueColor: Constants.black,
                      title: "Incorrect")
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
          ],
        ),
      ],
    );
  }

  String convertNumberToWords(int number) {
    if (number == 0) return 'zero';

    final List<String> units = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen'
    ];
    final List<String> tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety'
    ];
    final List<String> scales = ['crore', 'lakh', 'thousand', 'hundred', ''];

    final List<int> divisors = [10000000, 100000, 1000, 100, 1];

    String words = '';
    for (int i = 0; i < divisors.length; i++) {
      int divisor = divisors[i];
      if (number >= divisor) {
        int quotient = number ~/ divisor;
        number %= divisor;

        if (quotient > 0) {
          if (quotient < 20) {
            words += '${units[quotient]} ';
          } else {
            words += tens[quotient ~/ 10];
            if (quotient % 10 != 0) {
              words += '-${units[quotient % 10]}';
            }
            words += ' ';
          }
          if (scales[i].isNotEmpty) {
            words += '${scales[i]} ';
          }
        }
      }
    }

    return "${words.trim().toTitleCase()} Only";
  }

  String _formatDate(String dateStr) {
    try {
      DateTime parsedDate = DateFormat('dd MMMM yyyy').parse(dateStr);
      return DateFormat('dd MMM yy').format(parsedDate); // e.g., 15 Mar 25
    } catch (e) {
      return ''; // fallback if parsing fails
    }
  }
}

class BookmarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
