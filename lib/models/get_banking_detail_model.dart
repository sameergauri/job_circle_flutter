class GetBankingModel {
  final String bankName;
  final String lastName;
  final String panCard;
  final int? isVerify;
  final String? panCardCopy;
  final String accountType;
  final String firstName;
  final String? cancelCheque;
  final String accountNumber;
  final int mobile;
  final int id;
  final int uid;
  final String ifscCode;
  final String icon;
  final String remark;

  GetBankingModel(
      {required this.bankName,
      required this.lastName,
      required this.panCard,
      required this.isVerify,
      required this.panCardCopy,
      required this.accountType,
      required this.firstName,
      required this.cancelCheque,
      required this.accountNumber,
      required this.mobile,
      required this.id,
      required this.uid,
      required this.ifscCode,
      required this.icon,
      required this.remark});

  factory GetBankingModel.fromJson(Map<String, dynamic> json) {
    return GetBankingModel(
      bankName: json['bank_name'],
      lastName: json['last_name'],
      panCard: json['pan_card'] ?? "",
      isVerify: json['is_verify'],
      panCardCopy: json['pan_card_copy'],
      accountType: json['account_type'],
      firstName: json['first_name'],
      cancelCheque: json['cancle_cheque'],
      accountNumber: json['account_number'],
      mobile: json['mobile'],
      id: json['id'],
      uid: json['uid'],
      ifscCode: json['ifsc_code'],
      icon: json['icon'],
      remark: json['remark'] ?? "Incorrect data",
    );
  }
}

/* class GetBankingModel {
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
} */

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

/* class PostBankingModel {
  final int? id;
  final int? uid;
  final String? bankName;
  final String? branch;
  final String? accountType;
  final int? accountNumber;
  final String? ifscCode;
  final String? cancelCheque;
  final int? isVerify;
  final String? panCard;
  final String? panCardCopy;
  final String? createdOn;
  final DateTime? updatedDate;
  final int? bankId;

  PostBankingModel({
    this.id,
    this.uid,
    this.bankName,
    this.branch,
    this.accountType,
    this.accountNumber,
    this.ifscCode,
    this.cancelCheque,
    this.isVerify,
    this.panCard,
    this.panCardCopy,
    this.createdOn,
    this.updatedDate,
    this.bankId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'bankName': bankName,
      'branch': branch,
      'accountType': accountType,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'cancelCheque': cancelCheque,
      'isVerify': isVerify,
      'panCard': panCard,
      'panCardCopy': panCardCopy,
      'createdOn': createdOn,
      'updatedDate': updatedDate!.toIso8601String(),
      'bankId': bankId,
    };
  }
} */

// Date Model
class CustomDate {
  final int date;
  final int hours;
  final int minutes;
  final int month;
  final int nanos;
  final int seconds;
  final int time;
  final int year;

  CustomDate({
    required this.date,
    required this.hours,
    required this.minutes,
    required this.month,
    required this.nanos,
    required this.seconds,
    required this.time,
    required this.year,
  });

  factory CustomDate.fromJson(Map<String, dynamic> json) {
    return CustomDate(
      date: json['date'],
      hours: json['hours'],
      minutes: json['minutes'],
      month: json['month'],
      nanos: json['nanos'],
      seconds: json['seconds'],
      time: json['time'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hours': hours,
      'minutes': minutes,
      'month': month,
      'nanos': nanos,
      'seconds': seconds,
      'time': time,
      'year': year,
    };
  }
}

// Bank Account Model
class PostBankingModel {
  final int? accountNumber;
  final String? accountType;
  final int? bankId;
  final String? bankName;
  final String? branch;
  final String? cancleCheque;
  final CustomDate? createdon;
  final String? ifscCode;
  final String? panCard;
  final String? panCardCopy;
  final int? uid;
  final String? updatedDate;

  PostBankingModel({
    this.accountNumber,
    this.accountType,
    this.bankId,
    this.bankName,
    this.branch,
    this.cancleCheque,
    this.createdon,
    this.ifscCode,
    this.panCard,
    this.panCardCopy,
    this.uid,
    this.updatedDate,
  });

  factory PostBankingModel.fromJson(Map<String, dynamic> json) {
    return PostBankingModel(
      accountNumber: json['accountNumber'],
      accountType: json['accountType'],
      bankId: json['bankId'],
      bankName: json['bankName'],
      branch: json['branch'],
      cancleCheque: json['cancleCheque'],
      createdon: CustomDate.fromJson(json['createdon']),
      ifscCode: json['ifscCode'],
      panCard: json['panCard'],
      panCardCopy: json['panCardCopy'],
      uid: json['uid'],
      updatedDate: json['updated_date'],
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
      'createdon': createdon?.toJson(),
      'ifscCode': ifscCode,
      'panCard': panCard,
      'panCardCopy': panCardCopy,
      'uid': uid,
      'updated_date': updatedDate,
    };
  }
}
