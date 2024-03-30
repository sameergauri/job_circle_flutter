// ignore_for_file: override_on_non_overriding_member, file_names, avoid_print, avoid_unnecessary_containers, use_build_context_synchronously, prefer_typing_uninitialized_variables, unused_result

/* import 'package:flutter/material.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({super.key});

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'INVOICE',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'To,',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '1 Jan 2024',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'JOB CIRCLE',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Office Address',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Invoice No. (UserID/MMM-YY/XXX)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('Candidate Name')),
                DataColumn(label: Text('Co. Name')),
                DataColumn(label: Text('Process')),
                DataColumn(label: Text('DOJ')),
                DataColumn(label: Text('Amt')),
              ],
              rows: [
                _buildDataRow('John Doe', 'ABC Company', 'Process 1',
                    '01 Jan 2024', '100'),
                _buildDataRow('Jane Smith', 'XYZ Company', 'Process 2',
                    '02 Jan 2024', '150'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'XXXX',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Amount in words',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Banking Detail',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Bank Name & Branch',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Account Type',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Name Holder Name (As per Bank Record)',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Account No.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'IFSC Code',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '"I hereby acknowledge and agree that the above invoice, accurately\nrepresents the services provided. I confirm the authenticity of the\ninformation and authorize the processing of the mentioned sum."',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Submit & Send button press
                },
                child: const Text(
                  'Submit & Send',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String candidateName, String companyName,
      String process, String doj, String amount) {
    return DataRow(
      cells: [
        DataCell(Text(candidateName)),
        DataCell(Text(companyName)),
        DataCell(Text(process)),
        DataCell(Text(doj)),
        DataCell(Text(amount)),
      ],
    );
  }
} */

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/invoice_model.dart';
import 'package:job_circle/screens/Billing/list_of_invoice.dart';
import 'package:job_circle/screens/Billing/view_and_generate_invoice.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

final fetchPaymentStatus = FutureProvider<List<InvoiceModel>>((ref) {
  Future.delayed(const Duration(milliseconds: 10));
  return _InvoiceState.fetchPayment();
});

class Invoice extends ConsumerStatefulWidget {
  const Invoice({super.key});

  @override
  ConsumerState<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends ConsumerState<Invoice> {
  @override

//
//
//
//
  static Future<List<InvoiceModel>> fetchPayment() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getInvoiceDetailsOfReferral?rid=$userid&pageNumber=1&pageSize=100');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        /*   List<InvoiceModel> applicants =
            contentList.map((json) => InvoiceModel.fromJson(json)).toList(); */
        List<InvoiceModel> applicants = contentList
            .map((json) => InvoiceModel.fromJson(json))
            .where((invoice) =>
                invoice.attr_status != null &&
                invoice.attr_status!.toLowerCase() == 'payable')
            .toList();

        return applicants;
      } else {
        print(
            'Failed to fetch banking data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

/* 
  String generateInvoiceNumber(String userId) {
    // Get the current month and year
    DateTime now = DateTime.now();
    String month = DateFormat('MM').format(now);
    String year = DateFormat('yy').format(now);

    // Generate a random sequence number between 1001 and 9999
    int sequenceNumber = Random().nextInt(1111) + 1111;

    // Concatenate the parts to form the invoice number
    return '$userId/$month$year/$sequenceNumber';
  } */
  String nextInvoiceNumber = '';

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now);
    var fetchPaymentStatusData = ref.watch(fetchPaymentStatus);
    return fetchPaymentStatusData != null
        ? fetchPaymentStatusData.when(data: (data) {
            if (data.isNotEmpty) {
              nextInvoiceNumber = InvoiceNumberGenerator.generateInvoiceNumber(
                  data.first.userId.toString());
            }
            double totalAmount = 0.0; // Initialize total amount variable
            List<int?>? leadIdList = data.map((e) => e.id).toList();
            List<int> filteredLeadIdList =
                leadIdList.where((id) => id != null).cast<int>().toList();

            List<List<String>> tableData = data.map((invoice) {
              // Increment total amount with each invoice amount
              totalAmount += invoice.candidateAmount ?? 0.0;

              // Format candidate amount based on whether it's a whole number or not
              String formattedAmount = invoice.candidateAmount != null
                  ? (invoice.candidateAmount! % 1 == 0
                      ? invoice.candidateAmount!
                          .toInt()
                          .toString() // Display as integer if it's a whole number
                      : invoice.candidateAmount!.toStringAsFixed(
                          2)) // Display with 2 decimal places if it's not a whole number
                  : 'Unknown';

              return [
                invoice.candidateName ?? 'Unknown',
                "${invoice.short_code ?? invoice.companyName}",
                invoice.process ?? 'Unknown',
                DateFormat('dd-MMM-yy').format(invoice.doj ?? DateTime.now()),
                formattedAmount,
              ];
            }).toList();
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  'INVOICE',
                  style: GoogleFonts.varela(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formattedDate,
                              style: GoogleFonts.varela(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "To,",
                                    style: GoogleFonts.varela(fontSize: 16.sp),
                                  ),
                                  Text(
                                    "Job Circle",
                                    style: GoogleFonts.varela(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Thane ${"(W)"},\nMumbai-400601",
                                    style: GoogleFonts.varela(fontSize: 16.sp),
                                  ),
                                  Text(
                                    "Invoice No :  $nextInvoiceNumber",
                                    // generateInvoiceNumber(data.first.userId.toString())

                                    style: GoogleFonts.varela(fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        DynamicTable(data: tableData, totalAmount: totalAmount),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              "Amount in words : ",
                              style: GoogleFonts.varela(
                                fontSize: 16.sp,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${amountToWords(totalAmount.toInt())} only",
                                style: GoogleFonts.varela(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Banking Detail",
                              style: GoogleFonts.varela(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bank Name",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        "Account Type",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        "Holder Name(As per Bank Record)",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        "Account No",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        "IFSC Code",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        " : ${data.isNotEmpty ? data.first.bankName ?? 'Unknown' : 'Unknown'}",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        " : ${data.isNotEmpty ? data.first.accountType ?? 'Unknown' : 'Unknown'}",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        " : ${data.isNotEmpty ? data.first.referralName ?? 'Unknown' : 'Unknown'}",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        " : ${data.isNotEmpty ? data.first.accountNumber ?? 'Unknown' : 'Unknown'}",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        " : ${data.isNotEmpty ? data.first.ifscCode ?? 'Unknown' : 'Unknown'}",
                                        style: GoogleFonts.varela(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'I hereby acknowledge and agree that the above invoice, accurately represents the services provided. I confirm the authenticity of the information and authorize the processing of the mentioned sum.',
                          style: TextStyle(fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                try {
                                  Navigator.pop(context);

                                  JobPostApiService api = JobPostApiService();
                                  await api.updateInvoiceDetails(
                                      partnerInvoiceNo: nextInvoiceNumber,
                                      partnerTotalAmount: totalAmount,
                                      invoiceDate: DateTime.now(),
                                      payment_status: "Invoice Submitted",
                                      id: filteredLeadIdList,
                                      context: context);
                                  ref.refresh(fetchAllBillingDataProvider);
                                  ref.refresh(fetchAllInvoice);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                      title: "Error submitting invoice",
                                      error: true,
                                    ),
                                  );
                                }
                              },

                              /* onTap: () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Invoice Submitted",
                                        error: false));
                                Navigator.pop(context);
                                JobPostApiService api = JobPostApiService();
                                api.updateInvoiceDetails(
                                    partnerInvoiceNo: nextInvoiceNumber,
                                    partnerTotalAmount: totalAmount.toInt(),
                                    invoiceDate: DateTime.now(),
                                    payment_status: "Invoice Submited",
                                    id: filteredLeadIdList);
                              }, */
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 10.h),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 12.w),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.blue, width: 2.sp),
                                    borderRadius: BorderRadius.circular(8.r)),
                                child: Text("Submit Invoice",
                                    style: GoogleFonts.varela(
                                        color: Constants.blue,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }, error: (error, stackTrace) {
            return const Scaffold(
              body: Center(
                child: Text(
                    "Oops! Something went wrong on our end. Our team is working to fix the issue. Please be patient and bear with us as we resolve this. Thank you for your understanding."),
              ),
            );
          }, loading: () {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Constants.themeBgColor,
                strokeWidth: 1,
              )),
            );
          })
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
        : Scaffold(
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
          );
  }

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
    if (amount >= 100000) {
      words += '${amountToWords(amount ~/ 100000)} Lakh ';
      amount %= 100000;
    }

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

  /*  String amountToWords(int amount) {
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
      int thousandIndex =
          (amount ~/ 1000) - 1; // Adjusting index to match list index
      if (thousandIndex >= 0 && thousandIndex < units.length) {
        words += '${units[thousandIndex]} Thousand ';
        amount %= 1000;
      } else {
        // Handle case where index is out of range
        // You can print an error message or handle it as per your requirements
        print('Error: Index out of range for "units" list');
      }
    }

    if (amount >= 100) {
      int hundredIndex =
          (amount ~/ 100) - 1; // Adjusting index to match list index
      if (hundredIndex >= 0 && hundredIndex < units.length) {
        words += '${units[hundredIndex]} Hundred ';
        amount %= 100;
      } else {
        // Handle case where index is out of range
        // You can print an error message or handle it as per your requirements
        print('Error: Index out of range for "units" list');
      }
    }

    if (amount >= 10 && amount < 20) {
      int teenIndex = amount - 10;
      if (teenIndex >= 0 && teenIndex < teens.length) {
        words += '${teens[teenIndex]} ';
        amount = 0;
      } else {
        // Handle case where index is out of range
        print('Error: Index out of range for "teens" list');
      }
    } else if (amount >= 20) {
      int tenIndex = (amount ~/ 10) - 2; // Adjusting index to match list index
      if (tenIndex >= 0 && tenIndex < tens.length) {
        words += '${tens[tenIndex]} ';
        amount %= 10;
      } else {
        // Handle case where index is out of range
        print('Error: Index out of range for "tens" list');
      }
    }
    if (amount > 0) {
      int unitIndex = amount;
      if (unitIndex >= 0 && unitIndex < units.length) {
        words += '${units[unitIndex]} ';
      } else {
        // Handle case where index is out of range
        print('Error: Index out of range for "units" list');
      }
    }

    return words.trim();
  }
 */
}

class InvoiceNumberGenerator {
  static int _lastSequenceNumber = 1000; // Initial sequence number

  // Function to generate the next sequence number
  static int _getNextSequenceNumber() {
    return ++_lastSequenceNumber; // Increment and return the last sequence number
  }

  // Generate the invoice number
  static String generateInvoiceNumber(String userId) {
    // Get the current month and year
    DateTime now = DateTime.now();
    String month = DateFormat('MM').format(now);
    String year = DateFormat('yy').format(now);

    // Get the next sequence number
    int sequenceNumber = _getNextSequenceNumber();

    // Concatenate the parts to form the invoice number
    return '$userId/$month$year/$sequenceNumber';
  }
}

class DynamicTable extends StatelessWidget {
  final List<List<String>> data;
  final totalAmount;

  const DynamicTable(
      {super.key, required this.data, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        // padding: const EdgeInsets.all(20.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.top,

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
                    child: Text(
                      'Candidate Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      'Co. Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      'Process',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      'DOJ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      'Amt',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            ...data.map((row) => TableRow(
                  children: [
                    TableCell(
                        child:
                            Center(child: Text(row.isNotEmpty ? row[0] : ''))),
                    TableCell(
                        child:
                            Center(child: Text(row.length > 1 ? row[1] : ''))),
                    TableCell(
                        child:
                            Center(child: Text(row.length > 2 ? row[2] : ''))),
                    TableCell(
                        child:
                            Center(child: Text(row.length > 3 ? row[3] : ''))),
                    TableCell(
                        child:
                            Center(child: Text(row.length > 4 ? row[4] : ''))),
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
    /* DataTable( 
      border:
          TableBorder.symmetric(outside: const BorderSide(color: Colors.black)),
      columnSpacing: 5,
      horizontalMargin: 5, // Add horizontal margin to the DataTable

      columns: const [
        DataColumn(
          label: Center(child: Text('Candidate Name')),
        ),
        DataColumn(
          label: Center(child: Text('Co. Name')),
        ),
        DataColumn(
          label: Center(child: Text('Process')),
        ),
        DataColumn(
          label: Center(child: Text('DOJ')),
        ),
        DataColumn(
          label: Center(child: Text('Amt')),
        ),
      ],
      // Enable horizontal scrolling for the DataTable

      rows: [
        ...data.map((row) => DataRow(
              cells: [
                DataCell(Text(row.isNotEmpty ? row[0] : '')),
                DataCell(Text(row.length > 1 ? row[1] : '')),
                DataCell(Text(row.length > 2 ? row[2] : '')),
                DataCell(Text(row.length > 3 ? row[3] : '')),
                DataCell(Text(row.length > 4 ? row[4] : '')),
              ],
            )),
        DataRow(
          // Additional row for total amount
          cells: [
            const DataCell(Text('')),
            const DataCell(Text('Total',
                style: TextStyle(
                    fontWeight: FontWeight
                        .bold))), // Leave empty cells for other columns
            const DataCell(Text('')),
            const DataCell(Text('')),
            DataCell(Text(totalAmount.toStringAsFixed(
                0))), // Display total amount with 2 decimal places
          ],
        ),
      ],
    ); */
  }
}
