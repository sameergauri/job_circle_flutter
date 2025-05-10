// ignore_for_file: must_be_immutable, prefer_if_null_operators, unnecessary_null_comparison, avoid_unnecessary_containers, prefer_typing_uninitialized_variables
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/models/list_of_invoice_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class InvoiceDetail extends StatefulWidget {
  ListOfInvoiceModel invoiceModel;
  InvoiceDetail({super.key, required this.invoiceModel});

  @override
  State<InvoiceDetail> createState() => _InvoiceDetailState();
}

class _InvoiceDetailState extends State<InvoiceDetail> {
  @override
  Widget build(BuildContext context) {
    ListOfInvoiceModel invoicedata = widget.invoiceModel;
    String formattedDate =
        DateFormat('dd MMM yyyy').format(invoicedata.invoice_date);
    //
    //
    //
    List<List<String>> tableData = invoicedata.candidates.map((invoice) {
      return [
        invoice.candidateName,
        (invoice.shortCode != null ? invoice.shortCode : invoice.companyName),
        invoice.process,
        DateFormat('dd-MMM-yy').format(invoice.doj),
        invoice.candidateAmount.toString().replaceAll(".0", "")
      ];
    }).toList();
    //
    //
    //

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        // centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Constants.black),
        backgroundColor: Constants.borderColor,
        elevation: 0,
        title: const customTextForWeather(
            title: 'Invoice',
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      body: customCard(formattedDate, invoicedata, tableData),
    );
    /* Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/nopayment.gif"),
                  Text(
                    "No Invoice",
                    style: GoogleFonts.varela(
                        fontSize: 20.sp, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ) */
  }

  Widget customCard(String formattedDate, ListOfInvoiceModel invoicedata,
      List<List<String>> tableData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customTextForWeather(
                    title: formattedDate,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const customTextForWeather(
                        title: "To,",
                        fontSize: 14,
                      ),
                      const customTextForWeather(
                          title: "Job Circle",
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      const customTextForWeather(
                        title: "Thane ${"(W)"},\nMumbai-400601",
                        fontSize: 14,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      customTextForWeather(
                        title: "Invoice No :  ${invoicedata.invoice_no}",
                        // generateInvoiceNumber(data.first.userId.toString())

                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DynamicDetailTable(
                data: tableData, totalAmount: invoicedata.total_amount),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                const customTextForWeather(
                  title: "Amount in words : ",
                ),
                Expanded(
                  child: customTextForWeather(
                    title:
                        "${amountToWords(invoicedata.total_amount.toInt())} only",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(),
            SizedBox(
              height: 10.h,
            ),
            const customTextForWeather(
              title: "Banking Detail",
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            title: " : ${invoicedata.bank_name}",
                          ),
                          customTextForWeather(
                            title: " : ${invoicedata.account_type}",
                          ),
                          customTextForWeather(
                            title: " : ${invoicedata.referralName}",
                          ),
                          customTextForWeather(
                            title: " : ${invoicedata.account_number}",
                          ),
                          customTextForWeather(
                            title: " : ${invoicedata.ifsc_code}",
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.done_all_outlined,
                  size: 15,
                  color: Constants.darkBlue,
                ),
                SizedBox(
                  width: 4.w,
                ),
                const Expanded(
                  child: customTextForWeather(
                    title:
                        'I hereby acknowledge and agree that the above invoice, accurately represents the services provided. I confirm the authenticity of the information and authorize the processing of the mentioned sum.',
                    color: Constants.subtitleclr,
                  ),
                ),
              ],
            ),
            invoicedata.payment_status == "Paid"
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/images/paymentdone.png",
                          height: 30.sp,
                        ),
                      ],
                    ),
                  )
                : invoicedata.payment_status == "Reject"
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              "assets/images/reject.jpg",
                              height: 20.sp,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox()
          ],
        ),
      ),
    );
  }

  //
  //
  //
  // TODO:: Function dec...
  String amountToWords(int amount) {
    if (amount == 0) {
      return 'Zero';
    }

    final List<String> units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine'
    ];

    final List<String> teens = [
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    final List<String> tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    String words = '';

    if (amount >= 1000) {
      words += '${amountToWords(amount ~/ 1000)} Thousand ';
      amount %= 1000;
    }

    if (amount >= 100) {
      words += '${units[amount ~/ 100]} Hundred ';
      amount %= 100;
    }

    if (amount >= 10 && amount < 20) {
      words += '${teens[amount - 10]} ';
      amount = 0;
    } else if (amount >= 20) {
      words += '${tens[amount ~/ 10]} ';
      amount %= 10;
    }

    if (amount > 0) {
      words += '${units[amount]} ';
    }

    return words.trim();
  }
}

class DynamicDetailTable extends StatelessWidget {
  final List<List<String>> data;
  final totalAmount;

  const DynamicDetailTable(
      {super.key, required this.data, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        // padding: const EdgeInsets.all(20.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(), // Add borders to the table
          columnWidths: const {
            0: FlexColumnWidth(
                1.2), // Set the width of the first column to flex to fit content
            1: FlexColumnWidth(
                1.2), // Set the width of the second column to flex to fit content
            2: FlexColumnWidth(
                1), // Set the width of the third column to flex to fit content
            3: FlexColumnWidth(
                1), // Set the width of the fourth column to flex to fit content
            4: FlexColumnWidth(
                1), // Set the width of the fifth column to flex to fit content
          },
          children: [
            const TableRow(
              // Create a table row for the headings
              children: [
                TableCell(
                  child: Center(
                    child: customTextForWeather(
                      title: 'Candidate Name',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: customTextForWeather(
                      title: 'Co. Name',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: customTextForWeather(
                      title: 'Process',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: customTextForWeather(
                      title: 'DOJ',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: customTextForWeather(
                      title: 'Amt',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ...data.map((row) => TableRow(
                  children: [
                    TableCell(
                        child: Center(
                            child: customTextForWeather(
                                title: row.isNotEmpty ? row[0] : ''))),
                    TableCell(
                        child: Center(
                            child: customTextForWeather(
                                title: row.length > 1 ? row[1] : ''))),
                    TableCell(
                        child: Center(
                            child: customTextForWeather(
                                title: row.length > 2 ? row[2] : ''))),
                    TableCell(
                        child: Center(
                            child: customTextForWeather(
                                title: row.length > 3 ? row[3] : ''))),
                    TableCell(
                        child: Center(
                            child: customTextForWeather(
                                title: row.length > 4 ? row[4] : ''))),
                  ],
                )),
            // Total row
            TableRow(
              decoration: BoxDecoration(
                  color: Colors.grey[
                      300]), // Optional: Add background color to total row
              children: [
                const TableCell(
                    child: SizedBox()), // Leave empty cell for other columns

                const TableCell(
                    child: SizedBox()), // Leave empty cell for other columns
                const TableCell(child: SizedBox()),
                const TableCell(
                  child: Center(
                    child: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ), // Leave empty cell for other columns
                TableCell(
                  child: Center(
                    child: Text(
                      totalAmount.toStringAsFixed(0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            // Add more rows as needed
          ],
        ));
  }
}
