import 'dart:convert';

import 'package:http/http.dart';

class Utils {
  static parseResponse(response) {
    return jsonDecode(response.body);
  }
}
