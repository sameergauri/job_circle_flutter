class FetchBankDetailModel {
  String? accountNumber;
  String? accountType;
  int? isVerify;
  String? panCardCopy;
  int? mobile;
  String? icon;
  String? lastName;
  String? remark;
  String? panCard;
  String? ifscCode;
  String? cancleCheque;
  int? uid;
  int? bankId;
  String? bankName;
  int? id;
  String? firstName;
  String? status;

  FetchBankDetailModel({
    this.accountNumber,
    this.accountType,
    this.isVerify,
    this.panCardCopy,
    this.mobile,
    this.icon,
    this.lastName,
    this.remark,
    this.panCard,
    this.ifscCode,
    this.cancleCheque,
    this.uid,
    this.bankId,
    this.bankName,
    this.id,
    this.firstName,
    this.status,
  });

  factory FetchBankDetailModel.fromJson(Map<String, dynamic> json) {
    return FetchBankDetailModel(
      accountNumber: json['account_number'] as String?,
      accountType: json['account_type'] as String?,
      isVerify: json['is_verify'] as int?,
      panCardCopy: json['pan_card_copy'] as String?,
      mobile: json['mobile'] as int?,
      icon: json['icon'] as String?,
      lastName: json['last_name'] as String?,
      remark: json['remark'] as String?,
      panCard: json['pan_card'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      cancleCheque: json['cancle_cheque'] as String?,
      uid: json['uid'] as int?,
      bankId: json['bank_id'] as int?,
      bankName: json['bank_name'] as String?,
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'account_type': accountType,
      'is_verify': isVerify,
      'pan_card_copy': panCardCopy,
      'mobile': mobile,
      'icon': icon,
      'last_name': lastName,
      'remark': remark,
      'pan_card': panCard,
      'ifsc_code': ifscCode,
      'cancle_cheque': cancleCheque,
      'uid': uid,
      'bank_id': bankId,
      'bank_name': bankName,
      'id': id,
      'first_name': firstName,
      'status': status,
    };
  }
}
