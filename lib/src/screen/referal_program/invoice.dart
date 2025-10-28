// screens/Billing/ui/invoice_screen.dart
// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/referal_program/joiners_model.dart';
import 'package:job_circle/src/provider/referal_program/invoice_provider.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class InvoiceScreen extends StatefulWidget {
  final List<JoinerData> joinersdata;

  const InvoiceScreen({super.key, required this.joinersdata});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InvoiceProvider>(context, listen: false);
      provider.initializeData(widget.joinersdata);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        return Stack(
          children: [
            Scaffold(
              bottomNavigationBar: state.selectedOrganization != null
                  ? CustomButtonForSave(
                      onTap: () async {
                        await provider.submitInvoice();
                        if (state.submissionSuccess) {
                          CustomSnackbar.show(
                            'Invoice submitted successfully',
                            false,
                          );
                          Navigator.pop(context);
                        } else if (state.error != null) {
                          CustomSnackbar.show(state.error!, true);
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
                title: const customText(
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInvoiceHeader(state),
                        _buildOrganizationSelector(state, provider),
                        _buildInvoiceNumber(state),
                        _buildInvoiceTable(state),
                        _buildTotalAmount(state),
                        _buildAmountInWords(state),
                        _buildBankingDetails(state),
                        _buildTermsAndConditions(provider, state),
                        _buildFromSection(state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state.isLoading)
               BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildInvoiceHeader(InvoiceState state) {
    final formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        customText(
          title: "Invoice date: $formattedDate",
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Constants.black,
        ),
      ],
    );
  }

  Widget _buildOrganizationSelector(
    InvoiceState state,
    InvoiceProvider provider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const customText(
              title: "To,",
              fontWeight: FontWeight.bold,
            ),
            GestureDetector(
              onTap: () =>
                  _showOrganizationBottomSheet(context, provider, state),
              child: Row(
                children: [
                  customText(
                    title:
                        state.selectedOrganization?.name ??
                        'Select Organization',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: state.selectedOrganization != null
                        ? Colors.black
                        : Constants.orange,
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_drop_down,
                    color: state.selectedOrganization != null
                        ? Constants.orange
                        : Constants.black,
                  ),
                ],
              ),
            ),
            if (state.selectedOrganization != null)
              customText(
                title: _formatAddress(state.selectedOrganization!.address),
                fontSize: 12,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvoiceNumber(InvoiceState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: customText(
        monst: true,
        title: "Invoice No: ${state.invoiceNumber}",
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInvoiceTable(InvoiceState state) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: Constants.lightdull,
          child: const Row(
            children: [
              Expanded(
                flex: 5,
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
                flex: 4,
                child: customText(
                  textAlign: TextAlign.center,
                  title: "PO No.",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 3,
                child: customText(
                  textAlign: TextAlign.center,
                  title: "DOJ",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: customText(
                  textAlign: TextAlign.center,
                  title: "Amount",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...state.filteredJoiners.map(
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
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: customText(
                      title:
                          candidate.candidateName?.toString().replaceAll(
                            ',',
                            '',
                          ) ??
                          'Unknown',
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: customText(
                    textAlign: TextAlign.center,
                    title: candidate.id?.toString() ?? 'Unknown',
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: customText(
                    textAlign: TextAlign.center,
                    title: _formatDate(
                      candidate.dateOfJoining?.toString() ?? "Unknown",
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: customText(
                    textAlign: TextAlign.center,
                    title: candidate.partnerPayout != null
                        ? "₹ ${candidate.partnerPayout!.toStringAsFixed(0)}"
                        : "null",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount(InvoiceState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: customText(
          monst: true,
          title: "Total: ₹ ${state.totalAmount}",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAmountInWords(InvoiceState state) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            const customText(
              title: 'Amount in words: ',
              fontWeight: FontWeight.bold,
            ),
            Expanded(
              child: customText(
                title: '${_amountToWords(state.totalAmount)} only',
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        const Divider(),
      ],
    );
  }

  Widget _buildBankingDetails(InvoiceState state) {
    if (state.filteredJoiners.isEmpty) return const SizedBox();

    final joiner = state.filteredJoiners.first;

    return Column(
      children: [
        SizedBox(height: 10),
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
                customText(title: " : ${joiner.bankName}"),
                customText(title: " : ${joiner.accountType}"),
                customText(title: " : ${joiner.accountHolderName}"),
                customText(
                  monst: true,
                  title: " : ${joiner.accountNumber}",
                  fontWeight: FontWeight.w500,
                  letterspacing: 0.6,
                ),
                customText(
                  monst: true,
                  title: " : ${joiner.ifscCode}",
                  fontWeight: FontWeight.w500,
                  letterspacing: 0.6,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTermsAndConditions(
    InvoiceProvider provider,
    InvoiceState state,
  ) {
    if (state.filteredJoiners.isEmpty) return const SizedBox();

    final joiner = state.filteredJoiners.first;

    return CustomCheckboxRow(
      title:
          'I, ${joiner.accountHolderName!.replaceAll(',', '')}, hereby acknowledge and agree that the above invoice accurately represents the services provided. I confirm the authenticity of the information and authorize the processing of the mentioned sum.',
      value: state.termsAccepted,
      onChanged: (value) {
        provider.setTermsCondition(value!);
      },
    );
  }

  Widget _buildFromSection(InvoiceState state) {
    if (state.filteredJoiners.isEmpty) return const SizedBox();

    final joiner = state.filteredJoiners.first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const customText(
              title: "From,",
              fontWeight: FontWeight.bold,
            ),
            customText(title: joiner.accountHolderName.toString()),
          ],
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime parsedDate = DateFormat('dd MMM yyyy').parse(dateStr);
      return DateFormat('dd MMM yy').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  String _formatAddress(String address) {
    return address
        .replaceAll(', ,', ',')
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && line != ',')
        .join('\n');
  }

  String _amountToWords(int amount) {
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
      'Nine',
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
      'Nineteen',
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
      'Ninety',
    ];

    String words = '';
    if (amount >= 100000) {
      words += '${_amountToWords(amount ~/ 100000)} Lakh ';
      amount %= 100000;
    }
    if (amount >= 1000) {
      words += '${_amountToWords(amount ~/ 1000)} Thousand ';
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

  void _showOrganizationBottomSheet(
    BuildContext context,
    InvoiceProvider provider,
    InvoiceState state,
  ) {
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
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const customText(
                    title: 'Select Organization',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                  TextButton(
                    onPressed: () {
                      provider.filterByOrganization(null);
                      Navigator.pop(context);
                    },
                    child: customText(
                      title: 'Reset',
                      fontSize: 14,
                      color: Constants.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  itemCount: state.organizationList.length,
                  itemBuilder: (context, index) {
                    final org = state.organizationList[index];
                    final isSelected = state.selectedOrganization?.id == org.id;

                    return InkWell(
                      onTap: () {
                        provider.filterByOrganization(org.id);
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
                          left: 20,
                          bottom: 10,
                          top: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              title: org.name,
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            if (isSelected)
                              const CustomNetworkImage(
                                color: Constants.darkBlue,
                                imageUrl:
                                    CustomIconUrl.locicon,
                                defaultIcon: Icons.check,
                              ),
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
}





