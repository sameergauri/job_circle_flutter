class StatusListModel {
  String? value;
  int? detailId;
  int? id;
  int? statusId;

  StatusListModel({this.value, this.detailId, this.id, this.statusId});

  factory StatusListModel.fromJson(Map<String, dynamic> json) {
    return StatusListModel(
      value: json['value'],
      detailId: json['detail_id'],
      id: json['id'],
      statusId: json['status_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'detail_id': detailId,
      'id': id,
      'status_id': statusId
    };
  }
}
