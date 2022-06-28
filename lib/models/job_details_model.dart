import 'dart:convert';

class JobDetailsModel {
  int? id;
  String? name;
  String? address;
  int? compnayid;
  String? rolename;
  String? process;
  int? naturofworkid;
  String? shifttime;
  String? shiftdesc;
  String? key_responsible;
  String? client_payout;
  String? eligibility;
  int? locationid;
  String? minctc;
  String? maxctc;
  String? ctcdesc;
  List? inteviewrounds;
  int? payout;
  String? payoutval;
  String? paymentclause;
  String? icon;
  String? location;
  int? active;
  int? spoc;
  JobDetailsModel(
      {this.id,
      this.compnayid,
      this.rolename,
      this.process,
      this.naturofworkid,
      this.shifttime,
      this.shiftdesc,
      this.key_responsible,
      this.client_payout,
      this.eligibility,
      this.locationid,
      this.minctc,
      this.maxctc,
      this.ctcdesc,
      this.inteviewrounds,
      this.payout,
      this.paymentclause,
      this.active,
      this.location,
      this.icon,
      this.name,
      this.address,
      this.payoutval,
      this.spoc});

  factory JobDetailsModel.fromMap(Map<String, dynamic> map) {
    List inteviewrounds = [];
    if (map['inteviewrounds'] != null) {
      inteviewrounds = jsonDecode(map['inteviewrounds']);
    }

    return JobDetailsModel(
      id: map['id']?.toInt(),
      compnayid: map['compnayid']?.toInt(),
      rolename: map['rolename'],
      process: map['process'],
      naturofworkid: map['naturofworkid']?.toInt(),
      shifttime: map['shifttime'],
      shiftdesc: map['shiftdesc'],
      key_responsible: map['key_responsible'],
      client_payout: map['client_payout'],
      eligibility: map['eligibility'],
      locationid: map['locationid']?.toInt(),
      minctc: map['minctc'].toString(),
      maxctc: map['maxctc'].toString(),
      ctcdesc: map['ctcdesc'],
      inteviewrounds: inteviewrounds,
      payout: map['payout']?.toInt(),
      paymentclause: map['paymentclause'],
      active: map['active']?.toInt(),
      location: map['location'],
      icon: map['icon'],
      name: map['name'],
      address: map['address'],
      payoutval: map['payoutval'],
      spoc: map['spoc'],
    );
  }
}
