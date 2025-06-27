import 'package:flutter/material.dart';
import 'package:job_circle/constants/customchechbox.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Billing/model/payment_status_model.dart';
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
                color: Constants.subtitleclr,
              ),
            ),
            const SizedBox(height: 10),

            // Organization Name & Address (Assumed Static)
            const customText(
              title: "To,",
              fontWeight: FontWeight.bold,
            ),
            customText(
              title: invoice.orgizationName.toString(),
              fontSize: 12,
              // fontWeight: FontWeight.bold,
            ),
            customText(
              title: invoice.orgizationAddress.toString(),
              fontSize: 12,
              color: Constants.subtitleclr,
            ),
            const SizedBox(height: 10),

            // Invoice Number
            customText(
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
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("Candidate Name",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text("Company",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("Designation",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("Amount",
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: customText(title: candidate.name.toString()),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: customText(title: candidate.level.toString()),
                      ),
                      Expanded(
                        flex: 3,
                        child: customText(title: candidate.process.toString()),
                      ),
                      Expanded(
                        flex: 2,
                        child: customText(
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
              child: customText(
                title: "Total: ₹ ${invoice.invoiceAmount.toStringAsFixed(0)}",
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const customText(
                  title: "Amount In Words : ",
                  fontWeight: FontWeight.bold,
                ),
                customText(
                    title: convertNumberToWords(invoice.invoiceAmount.toInt())),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
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
                    customText(
                      title: "Bank Name",
                    ),
                    customText(
                      title: "Account Type",
                    ),
                    customText(
                      title: "Holder Name(As per Bank Record)",
                    ),
                    customText(
                      title: "Account No",
                    ),
                    customText(
                      title: "IFSC Code",
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: " : ${invoice.bankName}",
                    ),
                    customText(
                      title: " : ${invoice.accountType}",
                    ),
                    customText(
                      title: " : ${invoice.accountHolderName}",
                    ),
                    customText(
                      title: " : ${invoice.accountNumber}",
                    ),
                    customText(
                      title: " : ${invoice.ifscCode}",
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
              mainAxisAlignment: invoiceTab == InvoiceTab.paid
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (invoiceTab == InvoiceTab.paid)
                  Image.network(
                      height: 50,
                      "https://cdn-icons-png.flaticon.com/128/4272/4272841.png"),
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

    return words.trim();
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
