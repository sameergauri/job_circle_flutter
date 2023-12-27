// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class DataModel {
  String? key;
  String? value;

  DataModel({this.key, this.value});

  // ignore: empty_constructor_bodies
  DataModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
