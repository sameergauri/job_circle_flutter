// ignore_for_file: override_on_non_overriding_member, file_names, avoid_print, avoid_unnecessary_containers, use_build_context_synchronously, prefer_typing_uninitialized_variables, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/customchechbox.dart';
import 'package:job_circle/models/invoice_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
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
  bool terncondition = false;

  @override

//
//
//
//
  static Future<List<InvoiceModel>> fetchPayment() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data that matches InvoiceModel structure
    return [
      InvoiceModel(
        candidateAmount: 12500.00,
        attr_status: "Payable",
        candidateName: "John Doe",
        companyName: "Tech Solutions Inc.",
        referralName: "John Doe",
        userId: 123,
        process: "Software Development",
        accountNumber: "1234567890",
        accountType: "Savings",
        bankName: "ABC Bank",
        id: 1,
        ifscCode: "ABC123456",
      ),
      InvoiceModel(
        candidateAmount: 12500.00,
        attr_status: "Payable",
        candidateName: "John Doe",
        companyName: "Tech Solutions Inc.",
        referralName: "John Doe",
        userId: 123,
        process: "Software Development",
        accountNumber: "1234567890",
        accountType: "Savings",
        bankName: "ABC Bank",
        id: 1,
        ifscCode: "ABC123456",
      ),
      InvoiceModel(
        candidateAmount: 12500.00,
        attr_status: "Payable",
        candidateName: "John Doe",
        companyName: "Tech Solutions Inc.",
        referralName: "John Doe",
        userId: 123,
        process: "Software Development",
        accountNumber: "1234567890",
        accountType: "Savings",
        bankName: "ABC Bank",
        id: 1,
        ifscCode: "ABC123456",
      ),
      InvoiceModel(
        candidateAmount: 12500.00,
        attr_status: "Payable",
        candidateName: "John Doe",
        companyName: "Tech Solutions Inc.",
        referralName: "John Doe",
        userId: 123,
        process: "Software Development",
        accountNumber: "1234567890",
        accountType: "Savings",
        bankName: "ABC Bank",
        id: 1,
        ifscCode: "ABC123456",
      ),
      InvoiceModel(
        candidateAmount: 12500.00,
        attr_status: "Payable",
        candidateName: "John Doe",
        companyName: "Tech Solutions Inc.",
        referralName: "John Doe",
        userId: 123,
        process: "Software Development",
        accountNumber: "1234567890",
        accountType: "Savings",
        bankName: "ABC Bank",
        id: 1,
        ifscCode: "ABC123456",
      ),
    ]
        .where((invoice) =>
            invoice.attr_status != null &&
            invoice.attr_status!.toLowerCase() == 'payable')
        .toList();
  }
  /* static Future<List<InvoiceModel>> fetchPayment() async {
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
              bottomNavigationBar: CustomButtonForSave(
                  onTap: () async {
                    try {
                      Navigator.pop(context);
                      JobPostApiService api = JobPostApiService();
                      /*     await api.updateInvoiceDetails(
                        partnerInvoiceNo: nextInvoiceNumber,
                        partnerTotalAmount: totalAmount,
                        invoiceDate: DateTime.now(),
                        payment_status: "Invoice Submitted",
                        id: filteredLeadIdList,
                        context: context);
                    ref.refresh(fetchAllBillingDataProvider);
                    ref.refresh(fetchAllInvoice); */
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbarfinal(
                          title: "Error submitting invoice",
                          error: true,
                        ),
                      );
                    }
                  },
                  title: "Submit Invoice"),
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
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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
                                    title: "Invoice No :  $nextInvoiceNumber",
                                    // generateInvoiceNumber(data.first.userId.toString())

                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        DynamicTable(data: tableData, totalAmount: totalAmount),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            const customTextForWeather(
                              title: "Amount in words : ",
                              fontSize: 12,
                            ),
                            Expanded(
                              child: customTextForWeather(
                                title:
                                    "${amountToWords(totalAmount.toInt())} only",
                                fontSize: 12,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextForWeather(
                                        title: "Bank Name",
                                      ),
                                      customTextForWeather(
                                        title: "Account Type",
                                      ),
                                      customTextForWeather(
                                        title:
                                            "Holder Name(As per Bank Record)",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextForWeather(
                                        title:
                                            " : ${data.isNotEmpty ? data.first.bankName ?? 'Unknown' : 'Unknown'}",
                                      ),
                                      customTextForWeather(
                                        title:
                                            " : ${data.isNotEmpty ? data.first.accountType ?? 'Unknown' : 'Unknown'}",
                                      ),
                                      customTextForWeather(
                                        title:
                                            " : ${data.isNotEmpty ? data.first.referralName ?? 'Unknown' : 'Unknown'}",
                                      ),
                                      customTextForWeather(
                                        title:
                                            " : ${data.isNotEmpty ? data.first.accountNumber ?? 'Unknown' : 'Unknown'}",
                                      ),
                                      customTextForWeather(
                                        title:
                                            " : ${data.isNotEmpty ? data.first.ifscCode ?? 'Unknown' : 'Unknown'}",
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        CustomCheckboxRow(
                            title:
                                'I ${"User Name"} hereby acknowledge and agree that the above invoice, accurately represents the services provided. I confirm the authenticity of the information and authorize the processing of the mentioned sum.',
                            value: terncondition,
                            onChanged: (value) {
                              setState(() {
                                terncondition = value!;
                              });
                            }),
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
                    child: customTextForWeather(
                      title: 'Candidate Name',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: customTextForWeather(
                        title: 'Co. Name', fontWeight: FontWeight.bold),
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
                    child: customTextForWeather(
                      title: 'Total',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), // Leave empty cell for other columns
                TableCell(
                  child: Center(
                    child: customTextForWeather(
                      title: totalAmount.toStringAsFixed(0),
                      fontWeight: FontWeight.bold,
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
