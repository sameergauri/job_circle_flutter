import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RequestResult {
  bool? ok;
  int? resultKey = 0;
  dynamic resultValue;
  RequestResult(this.ok, this.resultKey, this.resultValue);
}

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
