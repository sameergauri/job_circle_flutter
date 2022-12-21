// ignore_for_file: constant_identifier_names

class GlobalConstants {
  static final spaceMatch = RegExp(r"^[A-Z][a-z]+\s[A-Z][a-z]+$");

  static const API_Host =
      "ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9090";
  //static const API_Host = "localhost:9090";
  //static const API_Host = "192.168.1.9:9090";
  static const ASSET_URL = "https://job-circle.s3.ap-south-1.amazonaws.com/";
  static const WEB_Host =
      "http://ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9092";
  static const ASSET_DEFAULT_IMAGE = "assets/images/male.png";
  // static const API_Host =
  //     "ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9090";
  //static const API_Host = "localhost:9090";
  static const API_Users_v1_saveStages = "/users/v1/saveStages";

  static const API_Users_v1_profileSummary = "/users/v1/profileSummary/";
  static const API_files_v1_multiUpload = "/files/v1/multiUpload";

  static const API_Users_v1_authenticate = "/users/v1/authenticate";
  static const API_Users_v1_verifySession = "/users/v1/verifySession";

  static const API_Users_v1_validateOTP = "/users/v1/validateOtp";

  static const API_master_group = "/master/v1/getByGroup";
  static const API_master_groups = "/master/v1/getByGroups";
  static const API_master_getByGroupParentId = "/master/v1/getByGroupParentId";

  static const API_lead_counts = "/leads/v1/getLeads";
  static const API_leads_v1 = "/leads/v1";

  static const API_master_v1 = "/master/v1";

  static const API_jobs_v1_search = "/jobs/v1/search";

  static const API_jobs_v1_getJobDetailsById = "/jobs/v1/getJobDetailsById";

  static const API_partner_v1 = "/partner/v1";

  static const API_partner_get_v1 = "/partner/v1/";

  static const API_partner_v1_user = "partner/v1/user/";

  static const API_company_v1_all = "/company/v1/all";

  static const API_leads_v1_getAllLeadsAdvanced =
      "/leads/v1/getAllLeadsAdvanced";

  static const API_jobs_v1_getDistinctProcessAndLevels =
      "jobs/v1/getDistinctProcessAndLevels";
}
