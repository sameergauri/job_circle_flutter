import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/Billing/model/submit_invoice_model.dart';

class GenrateBillService {
  static Future<bool> submitInvoice(SubmitInvoiceModel model) async {
    const String url =
        'http://${GlobalConstants.API_Host_one}/leads/v1/createFreelancerInvoice';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        print('Invoice submitted successfully.');
        return true;
      } else {
        print('Failed to submit invoice: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error submitting invoice: $e');
      return false;
    }
  }
}
