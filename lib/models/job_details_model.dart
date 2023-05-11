import 'dart:convert';

class JobDetailsModel {
  int? id;
  String? name;
  String? address;
  int? compnayid;
  String? rolename;
  String? spoc_fname;
  String? spoc_lname;
  int? spoc_contact;
  String? spoc_designation;
  String? spoc_locationl;
  String? spoc_profile_pic;
  String? process;
  String? gender;
  int? naturofworkid;
  double? minexperience;
  double? maxexperience;
  String? naturofwork;
  String? shifttime;
  String? shiftdesc;
  String? key_responsible;
  String? client_payout;
  String? eligibility;
  int? locationid;
  double? minctc;
  double? maxctc;
  String? ctcdesc;
  List<String>? inteviewrounds;
  List<String>? skills;
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
  String? salary;
  bool? ismonthly;
  JobDetailsModel(
      {this.id,
      this.compnayid,
      this.ismonthly,
      this.rolename,
      this.process,
      this.gender,
      this.spoc_fname,
      this.spoc_lname,
      this.spoc_contact,
      this.spoc_designation,
      this.spoc_locationl,
      this.spoc_profile_pic,
      this.minexperience,
      this.maxexperience,
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
      this.skills,
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
      this.emptype,
      this.salary});

  factory JobDetailsModel.fromMap(Map<String, dynamic> map) {
    List<String> inteviewrounds = [];
    List<String> skills = [];
    List<String> languageknown = [];
    if (map['inteviewrounds'] != null) {
      inteviewrounds =
          (jsonDecode(map['inteviewrounds']) as List<dynamic>).cast<String>();
    }

    if (map['skills'] != null) {
      skills = (jsonDecode(map['skills']) as List<dynamic>).cast<String>();
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
        ismonthly: map['ismonthly'],
        spoc_fname: map['spoc_fname'],
        spoc_lname: map['spoc_lname'],
        spoc_contact: map['spoc_contact'],
        spoc_designation: map['spoc_designation'],
        spoc_locationl: map['spoc_locationl'],
        spoc_profile_pic: map['spoc_profile_pic'],
        gender: map["gender"],
        naturofworkid: map['naturofworkid']?.toInt(),
        naturofwork: map['naturofwork'],
        shifttime: map['shifttime'],
        shiftdesc: map['shiftdesc'],
        key_responsible: map['key_responsible'],
        client_payout: map['client_payout'],
        eligibility: map['eligibility'],
        minctc: map['minctc'],
        maxctc: map['maxctc'],
        minexperience: map['minexperience'],
        maxexperience: map['maxexperience'],
        ctcdesc: map['ctcdesc'],
        inteviewrounds: inteviewrounds,
        skills: skills,
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
        emptype: map['emptype'],
        salary: map['ctcdesc']);
  }
}
