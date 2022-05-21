import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ServiceBase {
  callPost(String endpoint, Object params,
      [Map<String, String>? headers]) async {
    Uri url = Uri.http(GlobalConstants.API_Host, endpoint);
    try {
      SharedPreferences preferences = await _getPreference();
      Object? token = preferences.get("token");

      Map<String, String> _headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'token': token != null ? token.toString() : ''
      };
      return http.post(url,
          body: const JsonEncoder().convert(params), headers: _headers);
    } catch (ex) {
      print(ex);
    }
  }

  Future<http.Response> callGet(String endpoint,
      {Map<String, String>? param, Map<String, String>? headers}) async {
    Uri url = Uri.http(GlobalConstants.API_Host, endpoint, param ?? {});

    SharedPreferences preferences = await _getPreference();
    Object? token = preferences.get("token");

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token.toString() : ''
    };
    return http.get(url, headers: _headers);
  }

  _getPreference() async {
    return await SharedPreferences.getInstance();
  }
}
