// ignore_for_file: non_constant_identifier_names

class JobLocationModel {
  final int? parentid;
  final int? orderno;
  final String? code;
  final String? value;
  final int? id;
  final String? city;
  final int? active;
  final String? formateData;
  final String? group_name;

  JobLocationModel(
      {required this.id,
      required this.code,
      required this.value,
      required this.active,
      required this.city,
      required this.group_name,
      required this.orderno,
      required this.parentid,
      required this.formateData});

  factory JobLocationModel.fromJson(Map<String, dynamic> json) {
    return JobLocationModel(
        id: json['id'],
        code: json['code'],
        value: json['value'],
        active: json['active'],
        city: json['city'],
        group_name: json['group_name'],
        orderno: json['orderno'],
        formateData: json['formateData'],
        parentid: json[""]);
  }
  @override
  String toString() {
    return 'JobTitleModel{id: $id, code: $code, value: $value, active: $active,city: $city,group_name: $group_name,orderno:$orderno,parentid:$parentid,formateData:$formateData}';
  }
}
