class PostBankDetailModel {
  int? accountNumber;
  String? accountType;
  int? bankId;
  String? bankName;
  String? branch;
  String? cancleCheque;
  String? ifscCode;
  String? panCard;
  String? panCardCopy;
  int? uid;
  String? updatedDate;

  PostBankDetailModel({
    this.accountNumber,
    this.accountType,
    this.bankId,
    this.bankName,
    this.branch,
    this.cancleCheque,
    this.ifscCode,
    this.panCard,
    this.panCardCopy,
    this.uid,
    this.updatedDate,
  });

  factory PostBankDetailModel.fromJson(Map<String, dynamic> json) {
    return PostBankDetailModel(
      accountNumber: json['accountNumber'] as int?,
      accountType: json['accountType'] as String?,
      bankId: json['bankId'] as int?,
      bankName: json['bankName'] as String?,
      branch: json['branch'] as String?,
      cancleCheque: json['cancleCheque'] as String?,
      ifscCode: json['ifscCode'] as String?,
      panCard: json['panCard'] as String?,
      panCardCopy: json['panCardCopy'] as String?,
      uid: json['uid'] as int?,
      updatedDate: json['updated_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'accountType': accountType,
      'bankId': bankId,
      'bankName': bankName,
      'branch': branch,
      'cancleCheque': cancleCheque,
      'ifscCode': ifscCode,
      'panCard': panCard,
      'panCardCopy': panCardCopy,
      'uid': uid,
      'updated_date': updatedDate,
    };
  }
}
