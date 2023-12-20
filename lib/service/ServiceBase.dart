import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceBase {
  callPost(String endpoint, Object params,
      [Map<String, String>? headers]) async {
    Uri url = Uri.http(GlobalConstants.API_Host, endpoint);
    try {
      SharedPreferences preferences = await Utils.getSharedPreferences();
      //Object? token = await Utils.getPreferencesValue(preferences, "token");

      Map<String, String> _headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'token': token != null ? token.toString() : ''
      };
      return http.post(url,
          body: const JsonEncoder().convert(params), headers: _headers);
          
    } catch (ex) {
      print(ex);
    }
  }

  callPostLocal(String endpoint, Object params,
      [Map<String, String>? headers]) async {
    Uri url = Uri.http(GlobalConstants.API_Host_one, endpoint);
    try {
      SharedPreferences preferences = await Utils.getSharedPreferences();
      //Object? token = await Utils.getPreferencesValue(preferences, "token");

      Map<String, String> _headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'token': token != null ? token.toString() : ''
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
    if (kDebugMode) {
      print(url);
    }
    SharedPreferences preferences = await Utils.getSharedPreferences();
    Object? token = await Utils.getPreferencesValue(preferences, "token");

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token.toString() : ''
    };
    return http.get(url, headers: _headers);
  }

  Future<http.Response> callGetLocal(String endpoint,
      {Map<String, String>? param, Map<String, String>? headers}) async {
    Uri url = Uri.http(GlobalConstants.API_Host_one, endpoint, param ?? {});
    if (kDebugMode) {
      //  print(url);
    }
    SharedPreferences preferences = await Utils.getSharedPreferences();
    Object? token = await Utils.getPreferencesValue(preferences, "token");

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token.toString() : ''
    };
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      return response;
    } else {
      print(response.statusCode);
    }
    return response;
  }

  Future httpSingleFile(String endpoint, objFile) async {
    SharedPreferences prefs;
    Uri url = Uri.parse("http://" + GlobalConstants.API_Host + endpoint);
    var request = http.MultipartRequest('POST', url);
    var mimtype = Utils.getMimType(objFile.name);
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(http.MultipartFile(
        'files', objFile.readStream, objFile.size,
        filename: objFile.name, contentType: MediaType.parse(mimtype)));
    // request.files.add(await http.MultipartFile.fromPath(
    //   'files', '/Users/admin/Desktop/bcom.jpeg'));

    var result = await request.send();

    return http.Response.fromStream(result)
        .then((response) {
          if (response.statusCode == 200) {
            // print("Uploaded! ");
            // print('response.body ' + response.body);
            return response;
          }
          return response;
        })
        .catchError((err) => err)
        .whenComplete(() {});
  }
}
