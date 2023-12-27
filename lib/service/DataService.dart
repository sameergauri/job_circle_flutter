// ignore_for_file: unused_import, file_names, prefer_generic_function_type_aliases

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RequestResult {
  bool? ok;
  int? resultKey = 0;
  dynamic resultValue;
  RequestResult(this.ok, this.resultKey, this.resultValue);
}

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
var domainIp = "";

Future<RequestResult> httpget(String route, [Map<String, String>? data]) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http(domainIp, (route), data);
    var result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'access-token': prefs.getString("token").toString(),
      },
    );
    Map resultData = jsonDecode(result.body);
    return RequestResult(
        true, resultData["resultKey"], resultData["resultValue"]);
  } catch (ex) {
    return RequestResult(false, 0,
        "Connection failed (OS Error: Network is unreachable, errno = 101)");
  }
}

Future<RequestResult> httppost(String route, [dynamic data]) async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
    var url = "http://$domainIp/$route";
    var datastr = jsonEncode(data);
    var result = await http.post(Uri.parse(url), body: datastr, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'access-token': prefs.getString("token").toString(),
    });
    Map resultData = jsonDecode(result.body);
    return RequestResult(
        true, resultData["resultKey"], resultData["resultValue"]);
  } catch (ex) {
    return RequestResult(false, 0,
        "Connection failed (OS Error: Network is unreachable, errno = 101)");
  }
}

// // Future<RequestResult> httpSingleFile(String route, objFile) async {
// //   SharedPreferences prefs;
// //   try {
// //     var request = http.MultipartRequest('POST',
// //         Uri.parse('http://localhost:9090/files/v1/multiUpload?folder=cv'));

// //     request.headers['Content-Type'] = 'multipart/form-data';
// //     request.files.add(http.MultipartFile(
// //         'files', objFile.readStream, objFile.size,
// //         filename: objFile.name));
// //     // request.files.add(await http.MultipartFile.fromPath(
// //     //   'files', '/Users/admin/Desktop/bcom.jpeg'));

// //     var result = await request.send();

// //     var data = await http.Response.fromStream(result)
// //         .then((response) {
// //           if (response.statusCode == 200) {
// //             // print("Uploaded! ");
// //             // print('response.body ' + response.body);
// //             return jsonDecode(response.body);
// //           }
// //           return response.reasonPhrase;
// //         })
// //         .catchError((err) => err)
// //         .whenComplete(() {});

// //     return RequestResult(true, data["resultKey"], data["resultData"]);
// //     //   // return RequestResult(
// //     //   //     true, response["resultKey"], resultData["resultValue"ß]);
// //   } catch (ex) {
// //     return RequestResult(false, 0,
// //         "Connection failed (OS Error: Network is unreachable, errno = 101)");
// //   }
// }
