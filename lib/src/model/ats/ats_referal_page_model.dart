class ATSReferalPageModel {
  final Map<String, List<Application>> applicationData;

  ATSReferalPageModel({required this.applicationData});

  factory ATSReferalPageModel.fromJson(Map<String, dynamic> json) {
    final applicationData = <String, List<Application>>{};

    if (json['atsData'] != null) {
      final atsData = json['atsData'] as Map<String, dynamic>;
      atsData.forEach((key, value) {
        if (value is List) {
          applicationData[key] = value
              .map((e) => Application.fromJson(e))
              .toList();
        }
      });
    }

    return ATSReferalPageModel(applicationData: applicationData);
  }
}

class Application {
  final String applicantName;
  final String lastName;
  final String level;
  final String process;
  final String natureOfWork;
  final String status;
  final String companyName;
  final String referralTab;
  final String referralFeedback1;
  final String referralFeedback2;
  final String jobSalary;
  final String subStatus;
  final int? jobId;
  final int? statusId;

  Application({
    required this.applicantName,
    required this.lastName,
    required this.level,
    required this.process,
    required this.natureOfWork,
    required this.status,
    required this.companyName,
    required this.referralTab,
    required this.referralFeedback1,
    required this.referralFeedback2,
    required this.jobSalary,
    required this.subStatus,
    required this.jobId,
    required this.statusId,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicantName: json['applicantName'] ?? '',
      lastName: json['lastName'] ?? '',
      level: json['level'] ?? '',
      process: json['process'] ?? '',
      natureOfWork: json['natureOfWork'] ?? '',
      status: json['status'] ?? '',
      companyName: json['companyName'] ?? '',
      referralTab: json['referralTab'] ?? '',
      referralFeedback1: json['referralFeedback1'] ?? '',
      referralFeedback2: json['referralFeedback2'] ?? '',
      jobSalary: json['jobSalary'] ?? '',
      subStatus: json['subStatus'] ?? '',
      jobId: json['jobId'] != null
          ? int.tryParse(json['jobId'].toString())
          : null,
      statusId: json['statusId'] != null
          ? int.tryParse(json['statusId'].toString())
          : null,
    );
  }
}
