import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/referal_program/ppayment_status_model.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_bottom_sheet_for_app_theme.dart';
import 'package:job_circle/src/widgets/referal_program/custom_invoice_detail_card.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

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
    final colors = context.appColors;
    return Scaffold(
     
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: colors.appbarColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: colors.headingColor),
        title: customText(
          title: "Invoice",
          fontSize: 14,
          color: colors.headingColor,
          fontWeight: FontWeight.w600,
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
