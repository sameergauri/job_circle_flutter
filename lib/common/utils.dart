import 'dart:convert';
import '../models/api_response.dart';

class Utils {
  static RequestResult parseResponse(response) {
    Map resultData = jsonDecode(response.body);
    return RequestResult(resultData["code"], resultData["resultKey"],
        resultData["errorMessage"], resultData["resultData"]);
  }
}
