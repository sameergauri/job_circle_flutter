// ignore_for_file: file_names, prefer_adjacent_string_concatenation, avoid_print
// ignore_for_file: todo
import 'package:http/http.dart' as http;

class HttpClientInterceptor extends http.BaseClient{

  // SharedPreferences sharedPref;
  // AuthenticatedHttpClient({this.sharedPref});

  // // Use a memory cache to avoid local storage access in each call
  // String _inMemoryToken = '';
  // String get userAccessToken {
  //   // use in memory token if available
  //   if (_inMemoryToken.isNotEmpty) return _inMemoryToken;

  //   // otherwise load it from local storage
  //   _inMemoryToken = _loadTokenFromSharedPreference();

  //   return _inMemoryToken;
  // }
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // TODO: implement send
   request.headers.putIfAbsent("Authorization", () => "Bearer " + "put token");
  print("Inetrceptor call >>> ");
  print(request.url);




    return request.send();
  }

  //  String _loadTokenFromSharedPreference() {
  //   var accessToken = '';
  //   final user = sharedPref.getString(CACHED_USER);

  //   // If user is already authenticated, we can load his token from cache
  //   if (user != null) {
  //     accessToken = user.accessToken;
  //   }
  //   return accessToken;
  // }

  // // Don't forget to reset the cache when logging out the user
  // void reset() {
  //   _inMemoryToken = '';
  // }
  

}