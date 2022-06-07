import 'dart:convert';

class MomsModel {
  int? id;
  String? groupName;
  String? values;
  bool? isActive;
  int? ord;
  MomsModel({
    this.id,
    this.groupName,
    this.values,
    this.isActive,
    this.ord,
  });

  factory MomsModel.fromMap(Map<String, dynamic> map) {
    return MomsModel(
      id: map['id']?.toInt(),
      groupName: map['group_name'],
      values: map['value'],
      isActive: map['active'],
      ord: map['order']?.toInt(),
    );
  }
  factory MomsModel.fromJson(String source) => MomsModel.fromMap(json.decode(source));
}
