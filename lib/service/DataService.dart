import 'dart:convert';
import 'dart:html';
import 'package:job_circle/constants/gobal.dart';
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

Future<RequestResult> httpSingleFile(String route, List<int> file) async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
    //var url = "http://$domainIp/$route";
    Uri url = Uri.http(GlobalConstants.API_Host, route);
    // var formdata = FormData();
    // formdata.append("file", file);
    http.MultipartRequest request = http.MultipartRequest("POST", url);

    http.MultipartFile multipartFile =
        http.MultipartFile.fromBytes("files", file);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    // var result = await http.post(Uri.parse(url), body: formdata, headers: {
    //   'Content-Type': 'multipart/form-data',
    //   'access-token': prefs.getString("token").toString(),
    // });

    // Map resultData = jsonDecode(result.body);
    return RequestResult(true, 1, "");
    // return RequestResult(
    //     true, response["resultKey"], resultData["resultValue"]);
  } catch (ex) {
    return RequestResult(false, 0,
        "Connection failed (OS Error: Network is unreachable, errno = 101)");
  }
}
