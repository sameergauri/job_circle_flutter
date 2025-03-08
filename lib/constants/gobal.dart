// ignore_for_file: constant_identifier_names

class GlobalConstants {
  static final spaceMatch = RegExp(r"^[A-Z][a-z]+\s[A-Z][a-z]+$");

  static const API_Host =
      "ec2-13-200-109-136.ap-south-1.compute.amazonaws.com:9090";
  // "192.168.108.45:8081";

  // "ec2-13-200-109-136.ap-south-1.compute.amazonaws.com:9090"; //Local
  // "ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090"; // AWS

  static const API_Host_one =
      "ec2-13-200-109-136.ap-south-1.compute.amazonaws.com:9090";
  // "192.168.108.45:8081";

  // 'ec2-13-200-109-136.ap-south-1.compute.amazonaws.com:9090';
  //"ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9090";
  //static const API_Host = "localhost:9090";
  //static const API_Host = "192.168.1.9:9090";
  static const ASSET_URL = "https://job-circle.s3.ap-south-1.amazonaws.com/";
  static const Image_url = "https://s3.ap-south-1.amazonaws.com/job-circle-2/";
  static const WEB_Host =
      //  "http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090";  //new url
      //  "http://ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9092";    //old
      "http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9092";
  static const ASSET_DEFAULT_IMAGE = "assets/images/male.png";
  // static const API_Host =
  //     "ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9090";
  //static const API_Host = "localhost:9090";
  static const API_Users_v1_saveStages = "/users/v1/saveStages";
  static const API_Users_v1 = "/users/v1";

  static const API_Users_v1_profileSummary = "/users/v1/profileSummary/";
  static const API_Users_v1_userDetails = "/users/v1/details/";
  static const API_Users_v1_allUserDetails = "/users/v1/allUserDeails";

  static const API_files_v1_multiUpload = "/api/files/v1/multiUpload";

  // static const API_Users_v1_authenticate = "/users/v1/authenticate"; //TODO:: Old OTP generate api...
  static const API_Users_v1_authenticate =
      "/api/otp/v1/generate"; //TODO:: New OTP generate api...

  static const API_Users_v1_verifySession = "/users/v1/verifySession";
  static const API_Users_v1_activity = "/users/v1/userId/activity";

  // static const API_Users_v1_validateOTP = "/users/v1/validateOtp"; //TODO:: Old Validate otp api...

  static const API_Users_v1_validateOTP =
      "/api/otp/v1/validate"; //TODO:: New Validate otp api...
  static const API_Exp_v1 = "/exp/v1";

  static const API_Edu_v1 = "/edu/v1";

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

  static const API_jobs_v1_getAppliedJobDetailsByID =
      "/jobs/v1/getAppliedJobByUserId";

  static const API_jobs_v1_addfav = "/favjob/v1";
  static const API_jobs_v1_getfav = "/favjob/v1";
  static const API_jobs_v1_deletefav = "/favjob/v1/{id}";
  static const API_jobs_v2 = "/jobs/v2";
  static const API_jobs_v2_jobs_13_apply = "jobs/v2/jobs/{jobID}/apply";

  static const API_company_name_v1 = "/company/v1/all";
}
