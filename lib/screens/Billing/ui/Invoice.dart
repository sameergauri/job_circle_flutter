// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/customchechbox.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/models/view_and_generate_model.dart';
import 'package:job_circle/screens/Billing/model/submit_invoice_model.dart';
import 'package:job_circle/screens/Billing/provider/view_and_generate_provider.dart';
import 'package:job_circle/screens/Billing/service/generate_bill_service.dart';
import 'package:job_circle/screens/Billing/ui/payment_status_home_page.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class Invoice extends ConsumerStatefulWidget {
  final List<JoinerData> joinersdata;
  const Invoice({super.key, required this.joinersdata});

  @override
  ConsumerState<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends ConsumerState<Invoice> {
  bool terncondition = false;
  List<JoinerData> filteredJoiners = [];
  List<OrganizationInfo> organizationList = [];
  OrganizationInfo? selectedOrganization;
  int totalAmount = 0;
  String invoiceNumber = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    invoiceNumber = InvoiceGenerator.generate(widget.joinersdata.isNotEmpty
        ? widget.joinersdata.first.referralId!.toString()
        : '0000');
    filteredJoiners = widget.joinersdata;

    final uniqueOrgs = <String, OrganizationInfo>{};
    for (var joiner in widget.joinersdata) {
      final String orgId = (joiner.organizationId ?? '').toString();
      final orgName = joiner.organizationName ?? '';
      final orgAddress = joiner.organizationFullAddress ?? '';

      if (orgId.isNotEmpty && !uniqueOrgs.containsKey(orgId)) {
        uniqueOrgs[orgId] = OrganizationInfo(
          id: orgId,
          name: orgName,
          address: orgAddress,
        );
      }
    }
    organizationList = uniqueOrgs.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now);

    totalAmount = 0;
    List<List<String>> tableData = filteredJoiners.map((invoice) {
      totalAmount += (invoice.partnerPayout ?? 0.0).toInt();
      String formattedAmount = invoice.partnerPayout != null
          ? (invoice.partnerPayout! % 1 == 0
              ? invoice.partnerPayout!.toInt().toString()
              : invoice.partnerPayout!.toStringAsFixed(2))
          : '0';

      return [
        invoice.candidateName ?? 'Unknown',
        (invoice.companyShortName ?? invoice.companyName ?? 'Unknown'),
        invoice.designation ?? 'Unknown',
        invoice.dateOfJoining ?? '',
        formattedAmount,
      ];
    }).toList();

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: selectedOrganization != null
              ? CustomButtonForSave(
                  onTap: () async {
                    if (!terncondition) {
                      CustomSnackbar.show(
                          "Acknowledge to submit the invoice", true);
                    } else {
                      submitInvoice();
                    }
                  },
                  title: 'Submit Invoice',
                )
              : null,
          appBar: AppBar(
            titleSpacing: 0.0,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Constants.black),
            backgroundColor: Constants.borderColor,
            elevation: 0,
            title: const customTextForWeather(
              title: 'Invoice',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
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
                          title: "Invoice date: $formattedDate",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Constants.black,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const customTextForWeather(
                              title: "To,",
                              fontWeight: FontWeight.bold,
                            ),
                            GestureDetector(
                              onTap: _showOrganizationBottomSheet,
                              child: Row(
                                children: [
                                  customTextForWeather(
                                    title: selectedOrganization?.name ??
                                        'Select Organization',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: selectedOrganization != null
                                        ? Colors.black
                                        : Constants.orange,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: selectedOrganization != null
                                        ? Constants.orange
                                        : Constants.black,
                                  )
                                ],
                              ),
                            ),
                            if (selectedOrganization != null)
                              customTextForWeather(
                                title: selectedOrganization!.address != ''
                                    ? selectedOrganization!.address
                                        .toString()
                                        .replaceAll(', ,', ',')
                                        .split('\n')
                                        .map((line) =>
                                            line.trim()) // remove extra spaces
                                        .where((line) =>
                                            line.isNotEmpty && line != ',')
                                        .join('\n')
                                    : 'No Address',
                                fontSize: 12,
                              ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: customTextForMonst(
                        title: "Invoice No: $invoiceNumber",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // DynamicTable(data: tableData, totalAmount: totalAmount),
                    //
                    //
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Constants.lightdull,
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 5,
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
                            flex: 4,
                            child: customTextForWeather(
                                textAlign: TextAlign.center,
                                title: "PO No.",
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            flex: 3,
                            child: customTextForWeather(
                                textAlign: TextAlign.center,
                                title: "DOJ",
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            flex: 2,
                            child: customTextForWeather(
                                textAlign: TextAlign.center,
                                title: "Amount",
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ...filteredJoiners.map((candidate) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: customTextForWeather(
                                      title: candidate.candidateName
                                              ?.toString()
                                              .replaceAll(',', '') ??
                                          'Unknown'),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: customTextForWeather(
                                    textAlign: TextAlign.center,
                                    title: candidate.id?.toString() ??
                                        candidate.id?.toString() ??
                                        'Unknown'),
                              ),
                              Expanded(
                                flex: 3,
                                child: customTextForWeather(
                                    textAlign: TextAlign.center,
                                    title: _formatDate(
                                        candidate.dateOfJoining?.toString() ??
                                            "Unknown")),
                              ),
                              Expanded(
                                flex: 2,
                                child: customTextForWeather(
                                    textAlign: TextAlign.center,
                                    title: candidate.partnerPayout != null
                                        ? "₹ ${candidate.partnerPayout!.toStringAsFixed(0)}"
                                        : "null"),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),

                    // Total Amount
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: customTextForMonst(
                          title: "Total: ₹ $totalAmount",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //
                    //
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        const customTextForWeather(
                          title: 'Amount in words: ',
                          fontWeight: FontWeight.bold,
                        ),
                        Expanded(
                          child: customTextForWeather(
                            title: '${amountToWords(totalAmount)} only',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
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
                              title: " : ${widget.joinersdata.first.bankName}",
                            ),
                            customTextForWeather(
                              title:
                                  " : ${widget.joinersdata.first.accountType}",
                            ),
                            customTextForWeather(
                              title:
                                  " : ${widget.joinersdata.first.accountHolderName}",
                            ),
                            customTextForMonst(
                              title:
                                  " : ${widget.joinersdata.first.accountNumber}",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.6,
                            ),
                            customTextForMonst(
                              title: " : ${widget.joinersdata.first.ifscCode}",
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
                          'I, User Name, hereby acknowledge and agree that the above invoice accurately represents the services provided. I confirm the authenticity of the information and authorize the processing of the mentioned sum.',
                      value: terncondition,
                      onChanged: (value) {
                        setState(() {
                          terncondition = value!;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                                title: widget
                                    .joinersdata.first.accountHolderName
                                    .toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5, sigmaY: 5), // Adjust blur intensity as needed
            child: const Center(
              child: AbsorbPointer(
                absorbing: true, // Prevent interaction with elements behind
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime parsedDate = DateFormat('dd MMM yyyy').parse(dateStr);
      return DateFormat('dd MMM yy').format(parsedDate); // e.g., 15 Mar 25
    } catch (e) {
      return ''; // fallback if parsing fails
    }
  }

  void submitInvoice() async {
    setState(() {
      isLoading = true;
    });
    SubmitInvoiceModel invoiceData = SubmitInvoiceModel(
      invoiceAmount: 2000,
      invoiceDate: DateTime.now(),
      invoiceNumber: invoiceNumber,
      leadId:
          filteredJoiners.map((e) => e.id).whereType<int>().toSet().toList(),
      orgId: int.tryParse(selectedOrganization!.id) ?? 0,
      status: 'invoicesent',
    );

    try {
      bool success = await GenrateBillService.submitInvoice(invoiceData);
      if (success) {
        CustomSnackbar.show('Invoice submitted successfully', false);
        ref.read(generateInvoiceProvider.notifier).fetchJoinersData();
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
        ref.refresh(invoiceProvider);
      } else {
        CustomSnackbar.show('Failed to submit invoice', true);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbarfinal(
          title: 'Error submitting invoice',
          error: true,
        ),
      );
    }
  }

  void _showOrganizationBottomSheet() {
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.transparent,
      elevation: 1,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const customTextForWeather(
                    title: 'Select Organization',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedOrganization = null;
                        filteredJoiners = widget.joinersdata;
                      });
                      Navigator.pop(context);
                    },
                    child: customTextForWeather(
                      title: 'Reset',
                      fontSize: 14.sp,
                      color: Constants.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  itemCount: organizationList.length,
                  itemBuilder: (context, index) {
                    final org = organizationList[index];
                    final isSelected = selectedOrganization?.id == org.id;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedOrganization = org;
                          filteredJoiners = widget.joinersdata
                              .where((joiner) =>
                                  joiner.organizationId == int.tryParse(org.id))
                              .toList();
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Constants.lightdull
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 10, top: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextForWeather(
                              title: org.name,
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            if (isSelected)
                              const CustomNetworkImage(
                                  color: Constants.darkBlue,
                                  imageUrl:
                                      "https://cdn-icons-png.flaticon.com/128/7794/7794658.png",
                                  defaultIcon: Icons.check),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String amountToWords(int amount) {
    if (amount == 0) return 'Zero';

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

class InvoiceGenerator {
  static String generate(String userId) {
    final String datePart = DateFormat('ddMM').format(DateTime.now());
    final Random random = Random();
    final int randomCode = 1000 + random.nextInt(9000);
    return '$datePart/$userId/$randomCode';
  }
}

class DynamicTable extends StatelessWidget {
  final List<List<String>> data;
  final int totalAmount;

  const DynamicTable(
      {super.key, required this.data, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        border: TableBorder.all(),
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
        },
        children: [
          const TableRow(
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
                    title: 'Designation',
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
                    child: Center(child: customTextForWeather(title: row[0])),
                  ),
                  TableCell(
                    child: Center(child: customTextForWeather(title: row[1])),
                  ),
                  TableCell(
                    child: Center(child: customTextForWeather(title: row[2])),
                  ),
                  TableCell(
                    child: Center(child: customTextForWeather(title: row[3])),
                  ),
                  TableCell(
                    child: Center(child: customTextForWeather(title: row[4])),
                  ),
                ],
              )),
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              const TableCell(child: SizedBox()),
              const TableCell(child: SizedBox()),
              const TableCell(child: SizedBox()),
              const TableCell(
                child: Center(
                  child: customTextForWeather(
                    title: 'Total',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
        ],
      ),
    );
  }
}

class OrganizationInfo {
  final String id;
  final String name;
  final String address;

  OrganizationInfo(
      {required this.id, required this.name, required this.address});
}
