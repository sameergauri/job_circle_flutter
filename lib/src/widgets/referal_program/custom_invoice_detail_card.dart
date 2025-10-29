// ignore_for_file: unnecessary_null_comparison, dead_code, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/referal_program/ppayment_status_model.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/salary_round_off.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:job_circle/src/widgets/container/custom_container_to_view_document.dart';
import 'package:job_circle/src/widgets/container/custom_remark_coontainer.dart';
import 'package:job_circle/src/widgets/dialogue/custom_pdf_view_dialogue.dart';
import 'package:job_circle/src/widgets/referal_program/custom_title_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

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
              child: customText(
                title: "Invoice date: ${invoice.invoiceSubmitDate}",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Constants.black,
              ),
            ),
            const SizedBox(height: 10),

            // Organization Name & Address (Assumed Static)
            const customText(title: "To,", fontWeight: FontWeight.bold),
            customText(
              title: invoice.orgizationName.toString(),
              fontSize: 12,
              // fontWeight: FontWeight.bold,
            ),
            customText(
              title: invoice.orgizationAddress
                  .toString()
                  .split(',')
                  .asMap()
                  .entries
                  .map(
                    (entry) => entry.key == 2
                        ? '\n${entry.value.trim()}'
                        : entry.value.trim(),
                  )
                  .where((part) => part.isNotEmpty)
                  .join(', '),
              fontSize: 12,
              color: Constants.subtitleclr,
            ),
            const SizedBox(height: 10),
            // Invoice Number
            customText(
              monst: true,
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
                      child: customText(
                        textAlign: TextAlign.center,
                        title: "Candidate Name",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: customText(
                      textAlign: TextAlign.center,
                      title: "PO No.",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: customText(
                      textAlign: TextAlign.center,
                      title: "DOJ",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: customText(
                      textAlign: TextAlign.center,
                      title: "Amount",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Candidate Rows
            ...invoice.candidates.map(
              (candidate) => Container(
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
                        child: customText(title: candidate.name.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: customText(
                        textAlign: TextAlign.center,
                        title: candidate.id.toString(),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: customText(
                        textAlign: TextAlign.center,
                        title: candidate.doj != null
                            ? _formatDate(candidate.doj.toString())
                            : "",
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomIconTitleButton(
                        height: 20.0,
                        width: 20.0,
                        imageUrl:
                            "https://cdn-icons-png.flaticon.com/128/9798/9798241.png",
                        onTap: () {},
                        title: SalaryRoundOff.customRoundOff(
                          candidate.payoutAmount.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const customText(
                  monst: true,
                  title: "Total: ₹ ",
                  fontWeight: FontWeight.bold,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const customText(
                  title: "Amount In Words : ",
                  fontWeight: FontWeight.bold,
                ),
                customText(
                  title: convertNumberToWords(invoice.invoiceAmount.toInt()),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const customText(
              title: "Banking Detail",
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: "Bank Name"),
                    customText(title: "Account Type"),
                    customText(title: "Holder Name(As per Bank Record)"),
                    customText(title: "Account No"),
                    customText(title: "IFSC Code"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(title: " : ${invoice.bankName}"),
                    customText(title: " : ${invoice.accountType}"),
                    customText(title: " : ${invoice.accountHolderName}"),
                    customText(
                      monst: true,
                      title: " : ${invoice.accountNumber}",
                      fontWeight: FontWeight.w500,
                      letterspacing: 0.6,
                    ),
                    customText(
                      monst: true,
                      title: " : ${invoice.ifscCode}",
                      fontWeight: FontWeight.w500,
                      letterspacing: 0.6,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            CustomCheckboxRow(
              title:
                  'I ${invoice.accountHolderName} hereby acknowledge and agree that the above invoice, accurately represents the services provided. I confirm the authenticity of the information and authorize the processing of the mentioned sum.',
              value: true,
              onChanged: (value) {},
            ),

            Row(
              mainAxisAlignment: invoice.paymentStatus == "paid"
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (invoice.paymentStatus == "paid")
                  Image.network(height: 50, CustomIconUrl.paidicon),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Organization Name & Address (Assumed Static)
                    const customText(
                      title: "From,",
                      fontWeight: FontWeight.bold,
                    ),
                    customText(title: invoice.accountHolderName.toString()),
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
                    const customText(title: "Payment Receipt", fontSize: 14),
                    CustomContainerSelectToViewDoc(
                      heading: '',
                      candidateName: '',
                      isDocx:
                          invoice.invoicePaymentReciept!.contains('docx') ||
                              invoice.invoicePaymentReciept!.contains('doc')
                          ? true
                          : false,
                      title: invoice.invoicePaymentReciept.toString(),
                      onPressed: () {
                        NavigationService.push(
                          CustomPDFViewerDialog(
                            isFromAts: true,
                            pdfUrl:
                                "${GlobalConstants.Image_url}${invoice.invoicePaymentReciept}",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            if (invoice.paymentStatus == "reject")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  CustomRemarkConatiner(
                    titleColor: Constants.red,
                    fontsize: 11,
                    subtitle: invoice.invoiceRemark.toString(),
                    valueColor: Constants.black,
                    title: "Reason of rejection",
                  ),
                ],
              ),
            if (invoice.paymentStatus == "incorrect")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  CustomRemarkConatiner(
                    titleColor: Constants.red,
                    fontsize: 11,
                    subtitle: invoice.invoiceRemark.toString(),
                    valueColor: Constants.black,
                    title: "Incorrect",
                  ),
                ],
              ),
            if (invoice.paymentStatus == "invoicesent")
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  CustomRemarkConatiner(
                    fontsize: 11,
                    subtitle:
                        "Pending by Processing, Team will be process shortly.",
                    valueColor: Constants.black,
                    title: "Invoice Sent",
                  ),
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
      'nineteen',
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
      'ninety',
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
