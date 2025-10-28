class PostBankDetailModel {
  int? accountNumber;
  String? accountType;
  int? bankId;
  String? bankName;
  String? branch;
  String? cancleCheque;
  CreatedOn? createdon;
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
    this.createdon,
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
      createdon: json['createdon'] != null
          ? CreatedOn.fromJson(json['createdon'] as Map<String, dynamic>)
          : null,
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
      'createdon': createdon?.toJson(),
      'ifscCode': ifscCode,
      'panCard': panCard,
      'panCardCopy': panCardCopy,
      'uid': uid,
      'updated_date': updatedDate,
    };
  }
}

class CreatedOn {
  int? date;
  int? hours;
  int? minutes;
  int? month;
  int? nanos;
  int? seconds;
  int? time;
  int? year;

  CreatedOn({
    this.date,
    this.hours,
    this.minutes,
    this.month,
    this.nanos,
    this.seconds,
    this.time,
    this.year,
  });

  factory CreatedOn.fromJson(Map<String, dynamic> json) {
    return CreatedOn(
      date: json['date'] as int?,
      hours: json['hours'] as int?,
      minutes: json['minutes'] as int?,
      month: json['month'] as int?,
      nanos: json['nanos'] as int?,
      seconds: json['seconds'] as int?,
      time: json['time'] as int?,
      year: json['year'] as int?,
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
