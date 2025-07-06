import 'package:flutter/material.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Billing/model/payment_status_model.dart';
import 'package:job_circle/screens/Billing/widget/custom_invoice_detail_card.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class InvoiceDetail extends StatelessWidget {
  final InvoiceSent invoice;
  final InvoiceTab invoiceTab;

  const InvoiceDetail(
      {super.key, required this.invoice, required this.invoiceTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgColorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Constants.borderColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const OnboardingTitle(
          title: "Invoice",
        ),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: CustomInvoiveDetailCard(
              invoice: invoice,
              invoiceTab: invoiceTab,
            ),
          ),
        ],
      ),
    );
  }
}
