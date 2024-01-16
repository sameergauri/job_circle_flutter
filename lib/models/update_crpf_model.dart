// ignore_for_file: non_constant_identifier_names

class UpdateCRPFModel {
  String? interview_rounds;
  String? client_resume_id;
  String? company_name;
  int? jobid;
  String? level;
  String? natur_of_work;
  String? process;
  int? short_list_for;
  int? spoc;

  UpdateCRPFModel(
      {this.client_resume_id,
      this.company_name,
      this.interview_rounds,
      this.jobid,
      this.level,
      this.natur_of_work,
      this.process,
      this.short_list_for,
      this.spoc});

  Map<String, dynamic> toJson() {
    return {
      "interview_rounds": interview_rounds,
      "client_resume_id": client_resume_id,
      "company_name": company_name,
      "jobid": jobid,
      "level": level,
      "natur_of_work":natur_of_work,
      "process":process,
      "short_list_for":short_list_for,
      "spoc":spoc
    };
  }
}
