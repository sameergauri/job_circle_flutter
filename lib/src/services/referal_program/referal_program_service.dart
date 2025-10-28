// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/bank/bank_post_model.dart';
import 'package:job_circle/src/model/bank/fetch_bank_detail_model.dart';
import 'package:job_circle/src/model/referal_program/joiners_model.dart';
import 'package:job_circle/src/model/referal_program/ppayment_status_model.dart';
import 'package:job_circle/src/model/referal_program/submit_invoice_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class ReferalProgramService {
  static Future<JoinersResponseModel?> fetchJoinersData() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    try {
      // Replace with your actual API endpoint
      final response = await http.post(
        Uri.parse('${GlobalConstants.fetchjoinersdataurl}$userid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return JoinersResponseModel.fromJson(data);
      } else {
        throw Exception('Failed to load joiners data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load joiners data: $e');
    }
  }

  static Future<PaymentStatusModel> fetchListOfInvoice() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    try {
      final response = await http.post(
        Uri.parse('${GlobalConstants.fetchinvoiceurl}$userid'),
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

  static Future<List<FetchBankDetailModel>> fetchBankingData() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    final url = Uri.parse(
      '${GlobalConstants.fetchbankdetailurl}$userid&pageNumber=1&pageSize=10',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        List<FetchBankDetailModel> applicants = contentList
            .map((json) => FetchBankDetailModel.fromJson(json))
            .toList();
        return applicants;
      } else {
        print(
          'Failed to fetch banking data. Status Code: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

  static Future<bool> addBankingDetails(PostBankDetailModel jsonData) async {
    try {
      final response = await http.post(
        Uri.parse(GlobalConstants.postbankdetailurl),
        body: jsonEncode(jsonData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to add banking details: $e');
    }
  }

  static Future<bool> submitInvoice(SubmitInvoiceModel model) async {
    const String url = GlobalConstants.submitinvoiceurl;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error submitting invoice: $e');
      return false;
    }
  }
}
