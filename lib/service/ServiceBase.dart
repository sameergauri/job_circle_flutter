import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceBase {
  callPost(String endpoint, Object params, [Map<String, String>? headers]) {
    Uri url = Uri(host: GlobalConstants.API_Host, path: endpoint);

    SharedPreferences preferences = _getPreference();

    Map<String, String> _headers = {
      "token": preferences.getString("token")!,
      ...headers!
    };
    return http.post(url, body: params, headers: _headers);
  }

  callGet(String endpoint, [Map<String, String>? headers]) async {
    Uri url = Uri.parse(GlobalConstants.API_Host + endpoint);
    print(url);
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
