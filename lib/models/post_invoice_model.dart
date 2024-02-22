class PostInvoiceModel {
  final String partnerInvoiceNo;
  final int partnerTotalAmount;
  final DateTime invoiceDate;
  final int id;

  PostInvoiceModel({
    required this.partnerInvoiceNo,
    required this.partnerTotalAmount,
    required this.invoiceDate,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'partner_invoice_no': partnerInvoiceNo,
      'partner_total_amount': partnerTotalAmount,
      'invoice_date': invoiceDate.toIso8601String(),
      'id': id,
    };
  }
}
