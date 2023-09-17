class JobDetailsModel {
  int? id;
  int? is_graduate;
  int? compnayid;
  String? rolename;
  String? isfresher;
  String? ismonthly;
  String? spoc_fname;
  String? spoc_lname;
  int? spoc_contact;
  int? no_of_vacancy;
  String? spoc_designation;
  String? spoc_location;
  String? spoc_profile_pic;
  String? process;
  String? gender;
  int? naturofworkid;
  double? minexperience;
  String? maxexperience;
  String? naturofwork;
  String? shifttime;
  String? shiftdesc;
  List<String>? key_responsible;
  String? client_payout;
  List<String>? eligible;
  int? locationid;
  double? minctc;
  double? maxctc;
  String? ctcdesc;
  List<String>? interviewrounds;
  List<String>? skills;
  String? payout;
  String? paymentclause;
  int? active;
  String? location;
  String? education;
  String? icon;
  String? name;
  String? address;
  String? payoutval;
  int? spoc;
  List<String>? languageknown;
  List<String>? job_benifits;
  List<String>? boundarylimits;
  List<String>? moredetails;
  String? emptype;
  String? salary;
  String? age_group;

  JobDetailsModel({
    this.id,
    this.is_graduate,
    this.compnayid,
    this.age_group,
    this.no_of_vacancy,
    this.ismonthly,
    this.rolename,
    this.spoc_fname,
    this.spoc_lname,
    this.spoc_contact,
    this.isfresher,
    this.spoc_designation,
    this.spoc_location,
    this.spoc_profile_pic,
    this.job_benifits,
    this.process,
    this.gender,
    this.naturofworkid,
    this.minexperience,
    this.maxexperience,
    this.naturofwork,
    this.shifttime,
    this.shiftdesc,
    this.key_responsible,
    this.client_payout,
    this.eligible,
    this.locationid,
    this.minctc,
    this.maxctc,
    this.ctcdesc,
    this.interviewrounds,
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
    this.languageknown,
    this.boundarylimits,
    this.moredetails,
    this.emptype,
    this.salary,
  });

  factory JobDetailsModel.fromMap(Map<String, dynamic> map) {
    List<String>? keyResponsible = map['key_responsible'] != null
        ? parseLanguageKnown(map['key_responsible'])
        : null;

    List<String>? moredetails = map['moredetails'] != null
        ? parseLanguageKnown(map['moredetails'])
        : null;

    List<String>? eligible =
        map['eligible'] != null ? parseLanguageKnown(map['eligible']) : null;

    List<String>? interviewrounds = map['interviewrounds'] != null
        ? parseLanguageKnown(map['interviewrounds'])
        : null;

    List<String>? skills =
        map['skills'] != null ? parseLanguageKnown(map['skills']) : null;

    // ignore: unused_local_variable
    List<String>? languageknown = map['languageknown'] != null
        ? parseLanguageKnown(map['languageknown'])
        : null;

// ...

    List<String>? jobBenifits = map['job_benifits'] != null
        ? parseLanguageKnown(map['job_benifits'])
        : null;

    List<String>? boundarylimits = map['boundarylimits'] != null
        ? parseLanguageKnown(map['boundarylimits'])
        : null;
    // Rest of the code remains the same

    return JobDetailsModel(
      id: map['id'],
      is_graduate: map['is_graduate'],
      isfresher: map['isfresher'],
      compnayid: map['compnayid'],
      ismonthly: map['ismonthly'],
      rolename: map['rolename'],
      no_of_vacancy: map["no_of_vacancy"],
      spoc_fname: map['spoc_fname'],
      spoc_lname: map['spoc_lname'],
      spoc_contact: map['spoc_contact'],
      spoc_designation: map['spoc_designation'],
      spoc_location: map['spoc_location'],
      spoc_profile_pic: map['spoc_profile_pic'],
      process: map['process'],
      gender: map['gender'],
      naturofworkid: map['naturofworkid'],
      minexperience: double.tryParse(map['minexperience']?.toString() ?? ''),
      maxexperience: map['maxexperience'] ?? '',
      naturofwork: map['naturofwork'],
      shifttime: map['shifttime'],
      shiftdesc: map['shiftdesc'],
      key_responsible: keyResponsible,
      client_payout: map['client_payout'],
      eligible: eligible,
      locationid: map['locationid'],
      minctc: double.tryParse(map['minctc']?.toString() ?? ''),
      maxctc: double.tryParse(map['maxctc']?.toString() ?? ''),
      ctcdesc: map['ctcdesc'],
      interviewrounds: interviewrounds,
      skills: skills,
      payout: map['payout'],
      paymentclause: map['paymentclause'],
      active: map['active'],
      location: map['location'],
      education: map['education'],
      icon: map['icon'],
      name: map['name'],
      address: map['address'],
      payoutval: map['payoutval'],
      spoc: map['spoc'],
      age_group: map['age_group'],
      languageknown: languageknown,
      boundarylimits: boundarylimits,
      moredetails: moredetails,
      job_benifits: jobBenifits,
      emptype: map['emptype'],
      salary: map['salary'],
    );
  }
}

List<String>? parseLanguageKnown(String? value) {
  try {
    if (value != null) {
      final RegExp regex = RegExp(r'"([^"]+)"');
      final List<Match> matches = regex.allMatches(value).toList();
      return matches.map((match) => match.group(1)!).toList();
    }
  } catch (e) {
    print('Error parsing languageknown: $e');
  }
  return null;
}





/* import 'dart:convert';

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
 */