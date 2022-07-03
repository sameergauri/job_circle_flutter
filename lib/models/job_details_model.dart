import 'dart:convert';

class JobDetailsModel {
  int? id;
  String? name;
  String? address;
  int? compnayid;
  String? rolename;
  String? process;
  int? naturofworkid;
  String? naturofwork;
  String? shifttime;
  String? shiftdesc;
  String? key_responsible;
  String? client_payout;
  String? eligibility;
  int? locationid;
  String? minctc;
  String? maxctc;
  String? ctcdesc;
  List<String>? inteviewrounds;
  String? payout;
  String? payoutval;
  String? paymentclause;
  String? icon;
  String? location;
  String? education;
  int? active;
  int? spoc;
  List<String>? languageKnow;
  String? boundrylmit;
  String? emptype;
  JobDetailsModel(
      {this.id,
      this.compnayid,
      this.rolename,
      this.process,
      this.naturofworkid,
      this.naturofwork,
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
      this.education,
      this.icon,
      this.name,
      this.address,
      this.payoutval,
      this.spoc,
      this.languageKnow,
      this.boundrylmit,
      this.emptype});

  factory JobDetailsModel.fromMap(Map<String, dynamic> map) {
    List<String> inteviewrounds = [];
    List<String> languageknown = [];
    if (map['inteviewrounds'] != null) {
      inteviewrounds =
          (jsonDecode(map['inteviewrounds']) as List<dynamic>).cast<String>();
    }

    if (map['languageknown'] != null) {
      languageknown =
          (jsonDecode(map['languageknown']) as List<dynamic>).cast<String>();
    }

    return JobDetailsModel(
        id: map['id']?.toInt(),
        compnayid: map['compnayid']?.toInt(),
        rolename: map['rolename'],
        process: map['process'],
        naturofworkid: map['naturofworkid']?.toInt(),
        naturofwork: map['naturofwork'],
        shifttime: map['shifttime'],
        shiftdesc: map['shiftdesc'],
        key_responsible: map['key_responsible'],
        client_payout: map['client_payout'],
        eligibility: map['eligibility'],
        minctc: map['minctc'].toString(),
        maxctc: map['maxctc'].toString(),
        ctcdesc: map['ctcdesc'],
        inteviewrounds: inteviewrounds,
        payout: map['payout'],
        paymentclause: map['paymentclause'],
        active: map['active']?.toInt(),
        location: map["location"],
        icon: map['icon'],
        name: map['name'],
        education: map['education'],
        address: map['address'],
        payoutval: map['payoutval'],
        spoc: map['spoc'],
        languageKnow: languageknown,
        boundrylmit: map['boundarylimits'],
        emptype: map['emptype']);
  }
}
