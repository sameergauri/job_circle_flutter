import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/referal_program/ppayment_status_model.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/referal_program/custom_invoice_detail_card.dart';


class InvoiceDetail extends StatelessWidget {
  final InvoiceSent invoice;
  final InvoiceTab invoiceTab;

  const InvoiceDetail({
    super.key,
    required this.invoice,
    required this.invoiceTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Constants.borderColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const OnboardingTitle(title: "Invoice"),
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
