class RefeLeadModel {
  final Map<String, List<Application>> applicationData;

  RefeLeadModel({required this.applicationData});

  factory RefeLeadModel.fromJson(Map<String, dynamic> json) {
    final applicationData = <String, List<Application>>{};

    if (json['atsData'] != null) {
      final atsData = json['atsData'] as Map<String, dynamic>;
      atsData.forEach((key, value) {
        if (value is List) {
          applicationData[key] =
              value.map((e) => Application.fromJson(e)).toList();
        }
      });
    }

    return RefeLeadModel(applicationData: applicationData);
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
    );
  }
}
