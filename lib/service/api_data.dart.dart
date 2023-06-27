class ApiData {
  static final ApiData _instance = ApiData._internal();

  int userId;
  String userDetails;

  factory ApiData() {
    return _instance;
  }

  ApiData._internal() : userId = 0, userDetails = '';
}
