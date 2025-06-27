import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Billing/model/payment_status_model.dart';

class InvoiceService {
  Future<PaymentStatusModel> fetchListOfInvoice() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    try {
      final response = await http.post(
        Uri.parse(
            'http://${GlobalConstants.API_Host_one}/leads/v1/getFreelancerInvoiceDetails?referralId=$userid'  ),
      );

      if (response.statusCode == 200) {
        return PaymentStatusModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
