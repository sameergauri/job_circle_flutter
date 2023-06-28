class jobPostModel {
  int? active;
  DateTime? activeDate;
  String? ageGroup;
  List<String>? boundry_limits;
  String? category;
  String? clientPayout;
  int? commercial;
  int? companyId;
  DateTime? createdDate;
  String? ctcDesc;
  String? education;
  List<String>? eligible;
  String? empType;
  String? functionalArea;
  String? gender;
  int? id;
  DateTime? inActiveDate;
  String? industry;
  List<String>? interviewRounds;
  List<String>? job_skills;
  String? isFresher;
  String? isMonthly;
  List<String>? jobBenefits;
  String? jobResponsible;
  List<dynamic>? keyResponsible;
  List<String>? languageKnown;
  int? locationId;
  int? maxAge;
  int? maxCtc;
  String? maxExperience;
  int? minAge;
  int? minCtc;
  String? minExperience;
  List<String>? moredetails;
  int? natureOfWorkId;
  int? noOfVacancy;
  String? paymentClause;
  String? payout;
  String? process;
  String? rating;
  String? reasonInActive;
  String? reasonSpocChange;
  String? roleName;
  String? searchKeywords;
  String? shiftDesc;
  String? shiftTime;
  List<dynamic>? skills;
  int? spoc;
  int? spocInactive;
  List<String>? textResponsible;
  String? totalExperience;
  String? totalSalary;
  DateTime? updatedDate;
  int? workCity;
  List<int>? workLocation;
  String? workType;

  jobPostModel({
    this.active,
    this.activeDate,
    this.ageGroup,
    // ignore: non_constant_identifier_names
    this.boundry_limits,
    this.job_skills,
    this.category,
    this.clientPayout,
    this.commercial,
    this.companyId,
    this.createdDate,
    this.ctcDesc,
    this.education,
    this.eligible,
    this.empType,
    this.functionalArea,
    this.gender,
    this.id,
    this.inActiveDate,
    this.industry,
    this.interviewRounds,
    this.isFresher,
    this.isMonthly,
    this.jobBenefits,
    this.jobResponsible,
    this.keyResponsible,
    this.languageKnown,
    this.locationId,
    this.maxAge,
    this.maxCtc,
    this.maxExperience,
    this.minAge,
    this.minCtc,
    this.minExperience,
    this.moredetails,
    this.natureOfWorkId,
    this.noOfVacancy,
    this.paymentClause,
    this.payout,
    this.process,
    this.rating,
    this.reasonInActive,
    this.reasonSpocChange,
    this.roleName,
    this.searchKeywords,
    this.shiftDesc,
    this.shiftTime,
    this.skills,
    this.spoc,
    this.spocInactive,
    this.textResponsible,
    this.totalExperience,
    this.totalSalary,
    this.updatedDate,
    this.workCity,
    this.workLocation,
    this.workType,
  });

  factory jobPostModel.fromJson(Map<String, dynamic> json) => jobPostModel(
        active: json["active"],
        activeDate: json["active_date"] != null
            ? DateTime.parse(json["active_date"])
            : null,
        ageGroup: json["age_group"],
        boundry_limits: json["boundry_limits"] != null
            ? List<String>.from(json["boundry_limits"].map((x) => x))
            : null,
        job_skills: json["job_skills"] != null
            ? List<String>.from(json["job_skills"].map((x) => x))
            : null,
        category: json["category"],
        clientPayout: json["client_payout"],
        commercial: json["commercial"],
        companyId: json["compnayid"],
        createdDate: json["created_date"] != null
            ? DateTime.parse(json["created_date"])
            : null,
        ctcDesc: json["ctcdesc"],
        education: json["education"],
        eligible: json["eligible"] != null
            ? List<String>.from(json["eligible"].map((x) => x))
            : null,
        empType: json["emptype"],
        functionalArea: json["functional_area"],
        gender: json["gender"],
        id: json["id"],
        inActiveDate: json["in_active_date"] != null
            ? DateTime.parse(json["in_active_date"])
            : null,
        industry: json["industry"],
        interviewRounds: json["inteviewrounds"] != null
            ? List<String>.from(json["inteviewrounds"].map((x) => x))
            : null,
        isFresher: json["isfresher"],
        isMonthly: json["ismonthly"],
        jobBenefits: json["job_benifits"] != null
            ? List<String>.from(json["job_benifits"].map((x) => x))
            : null,
        jobResponsible: json["job_responsible"],
        keyResponsible: json["key_responsible"] != null
            ? List<String>.from(json["key_responsible"].map((x) => x))
            : null,
        languageKnown: json["languageknown"] != null
            ? List<String>.from(json["languageknown"].map((x) => x))
            : null,
        locationId: json["locationid"],
        maxAge: json["max_age"],
        maxCtc: json["maxctc"],
        maxExperience: json["maxexperience"],
        minAge: json["min_age"],
        minCtc: json["minctc"],
        minExperience: json["minexperience"],
        moredetails: json["moredetails"] != null
            ? List<String>.from(json["moredetails"].map((x) => x))
            : null,
        natureOfWorkId: json["naturofworkid"],
        noOfVacancy: json["no_of_vacancy"],
        paymentClause: json["paymentclause"],
        payout: json["payout"],
        process: json["process"],
        rating: json["rating"],
        reasonInActive: json["reasonInActive"],
        reasonSpocChange: json["reasonSpocChange"],
        roleName: json["rolename"],
        searchKeywords: json["search_keywords"],
        shiftDesc: json["shiftdesc"],
        shiftTime: json["shifttime"],
        skills: json["skills"] != null
            ? List<String>.from(json["skills"].map((x) => x))
            : null,
        spoc: json["spoc"],
        spocInactive: json["spoc_inactive"],
        textResponsible: json["text_responsible"] != null
            ? List<String>.from(json["text_responsible"].map((x) => x))
            : null,
        totalExperience: json["total_experience"],
        totalSalary: json["total_salary"],
        updatedDate: json["updated_date"] != null
            ? DateTime.parse(json["updated_date"])
            : null,
        workCity: json["work_city"],
        workLocation: json["work_location"] != null
            ? List<int>.from(json["work_location"].map((x) => x))
            : null,
        workType: json["work_type"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "active_date":
            activeDate != null ? activeDate?.toIso8601String() : null,
        "age_group": ageGroup,
        "boundry_limits": boundry_limits != null
            ? List<dynamic>.from(boundry_limits!.map((x) => x))
            : null,
        "category": category,
        "client_payout": clientPayout,
        "commercial": commercial,
        "compnayid": companyId,
        "created_date":
            createdDate != null ? createdDate?.toIso8601String() : null,
        "ctcdesc": ctcDesc,
        "education": education,
        "eligible": eligible != null
            ? List<dynamic>.from(eligible!.map((x) => x))
            : null,
        "emptype": empType,
        "functional_area": functionalArea,
        "gender": gender,
        "id": id,
        "in_active_date":
            inActiveDate != null ? inActiveDate?.toIso8601String() : null,
        "industry": industry,
        "inteviewrounds": interviewRounds != null
            ? List<dynamic>.from(interviewRounds!.map((x) => x))
            : null,
        "job_skills": job_skills != null
            ? List<dynamic>.from(job_skills!.map((x) => x))
            : null,
        "isfresher": isFresher,
        "ismonthly": isMonthly,
        "job_benifits": jobBenefits != null
            ? List<dynamic>.from(jobBenefits!.map((x) => x))
            : null,
        "job_responsible": jobResponsible,
        "key_responsible": keyResponsible != null
            ? List<dynamic>.from(keyResponsible!.map((x) => x))
            : null,
        "languageknown": languageKnown != null
            ? List<dynamic>.from(languageKnown!.map((x) => x))
            : null,
        "locationid": locationId,
        "max_age": maxAge,
        "maxctc": maxCtc,
        "maxexperience": maxExperience,
        "min_age": minAge,
        "minctc": minCtc,
        "minexperience": minExperience,
        "moredetails": moredetails != null
            ? List<dynamic>.from(moredetails!.map((x) => x))
            : null,
        "naturofworkid": natureOfWorkId,
        "no_of_vacancy": noOfVacancy,
        "paymentclause": paymentClause,
        "payout": payout,
        "process": process,
        "rating": rating,
        "reasonInActive": reasonInActive,
        "reasonSpocChange": reasonSpocChange,
        "rolename": roleName,
        "search_keywords": searchKeywords,
        "shiftdesc": shiftDesc,
        "shifttime": shiftTime,
        "skills":
            skills != null ? List<dynamic>.from(skills!.map((x) => x)) : null,
        "spoc": spoc,
        "spoc_inactive": spocInactive,
        "text_responsible": textResponsible,
        "total_experience": totalExperience,
        "total_salary": totalSalary,
        "updated_date":
            updatedDate != null ? updatedDate?.toIso8601String() : null,
        "work_city": workCity,
        "work_location": workLocation != null
            ? List<dynamic>.from(workLocation!.map((x) => x))
            : null,
        "work_type": workType,
      };
}
