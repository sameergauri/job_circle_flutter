// ignore_for_file: file_names

class WebJson {
  String func;
  dynamic data;

  WebJson(this.func, this.data);

  factory WebJson.fromJson(dynamic json) {
    return WebJson(json['func'] as String, json['data']);
  }
}
