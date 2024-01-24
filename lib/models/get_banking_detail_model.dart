class GetBankingModel {
  final String resultKey;
  final ResultData resultData;
  final String code;
  final String errorMessage;

  GetBankingModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory GetBankingModel.fromJson(Map<String, dynamic> json) {
    return GetBankingModel(
      resultKey: json['resultKey'] ?? '',
      resultData: ResultData.fromJson(json['resultData'] ?? {}),
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}

class ResultData {
  final String? ifscCode;
  final int id;
  final String? accountNumber;
  final String? cancelCheque;
  final String lastName;
  final String? accountType;
  final bool? isVerify;
  final String? panCardCopy;
  final int mobile;
  final String? bankName;
  final String firstName;
  final String? panCard;

  ResultData({
    required this.ifscCode,
    required this.id,
    required this.accountNumber,
    required this.cancelCheque,
    required this.lastName,
    required this.accountType,
    required this.isVerify,
    required this.panCardCopy,
    required this.mobile,
    required this.bankName,
    required this.firstName,
    required this.panCard,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      ifscCode: json['ifsc_code'],
      id: json['id'] ?? 0,
      accountNumber: json['account_number'],
      cancelCheque: json['cancle_cheque'],
      lastName: json['last_name'] ?? '',
      accountType: json['account_type'],
      isVerify: json['is_verify'],
      panCardCopy: json['pan_card_copy'],
      mobile: json['mobile'] ?? 0,
      bankName: json['bank_name'],
      firstName: json['first_name'] ?? '',
      panCard: json['pan_card'],
    );
  }
}


/* class GetBankingModel {
  final String? ifscCode;
  final int id;
  final String? accountNumber;
  final String? cancelCheque;
  final String lastName;
  final String? accountType;
  final bool? isVerify;
  final String? panCardCopy;
  final int mobile;
  final String? bankName;
  final String firstName;
  final String? panCard;

  GetBankingModel({
    required this.ifscCode,
    required this.id,
    required this.accountNumber,
    required this.cancelCheque,
    required this.lastName,
    required this.accountType,
    required this.isVerify,
    required this.panCardCopy,
    required this.mobile,
    required this.bankName,
    required this.firstName,
    required this.panCard,
  });

  factory GetBankingModel.fromJson(Map<String, dynamic> json) {
    return GetBankingModel(
      ifscCode: json['ifsc_code'],
      id: json['id'] ?? 0,
      accountNumber: json['account_number'],
      cancelCheque: json['cancle_cheque'],
      lastName: json['last_name'] ?? '',
      accountType: json['account_type'],
      isVerify: json['is_verify'],
      panCardCopy: json['pan_card_copy'],
      mobile: json['mobile'] ?? 0,
      bankName: json['bank_name'],
      firstName: json['first_name'] ?? '',
      panCard: json['pan_card'],
    );
  }
} */

class PostBankingModel {
  final String? accountNumber;
  final String? accountType;
  final String? bankName;
  final String? ifscCode;
  final String? cancelCheque;
  final String? panCard;
  final String? panCardCopy;

  PostBankingModel({
    this.accountNumber,
    this.accountType,
    this.bankName,
    this.ifscCode,
    this.cancelCheque,
    this.panCard,
    this.panCardCopy,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'accountType': accountType,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'cancleCheque': cancelCheque,
      'panCard': panCard,
      'panCardCopy': panCardCopy,
    };
  }
}
