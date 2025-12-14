// ignore_for_file: constant_identifier_names
// ignore_for_file: todo

class GlobalConstants {
  static final spaceMatch = RegExp(r"^[A-Z][a-z]+\s[A-Z][a-z]+$");
  static const API_Host_one =
      // "ec2-13-200-109-136.ap-south-1.compute.amazonaws.com:9090";
  "10.36.192.234:8081";
  // "10.57.31.234:9090";
  static const ASSET_URL = "https://job-circle.s3.ap-south-1.amazonaws.com/";
  static const Image_url = "https://s3.ap-south-1.amazonaws.com/job-circle-2/";

  // TODO:: CustomApiUrl
  //
  static const _baseurl = "http://$API_Host_one";
  //
  //
  // TODO:: Generate responsibility & Summary using ai
  //
  static const generateResponsibilityUsingAiUrl =
      '$_baseurl/jobs/v/generateJobResponsibilityUsingGPT';
  static const genereteSummaryUsingAI =
      '$_baseurl/api/v1/users/generateProfileSummery?userId=';
  //
  //
  //TODO:: Parse resume
  //
  static const parsecvurl = '$_baseurl/api/v1/cv/gpt4o-mini/parse';
  static const onboardingparsecvurl =
      '$_baseurl/api/v1/cv/gpt4o-mini/parse/user/onboard';
  //
  //
  //TODO:: OTP
  //
  static const generateOtp = "$_baseurl/api/otp/v1/generate?mobile=";
  static const validateOtp = "$_baseurl/api/otp/v1/validate";
  //
  //
  // TODO:: clear cache
  //
  static const cacheclearurl = "$_baseurl/api/v1/cache/clear";
  //
  //
  // TODO:: version check
  //
  static const chechversionurl = "$_baseurl/version/v1/getVersionById?id=1";
  //
  //
  // TODO:: jobs
  //
  static const _jobbaseUrl = '$_baseurl/api/jobs/v1';
  static const getAllJobsUrl = '$_jobbaseUrl/getAllJobs';
  static const getJobDetailUrl = '$_jobbaseUrl/getJobDetailsByJobId?';
  static const recomendedJobUrl = '$_baseurl/api/v1/recommendations/users/';
  //
  //
  //TODO:: Lead
  //
  static const refercvUrl =
      '$_baseurl/leads/v1/referJobWithNewApproach?referralId=';
  static const applyUrl = '$_baseurl/leads/v1/applyJobWithNewApproach';
  static const getAppliedJobDataUrl =
      '$_baseurl/leads/v1/getAtsDataAppliedJobs?userId=';
  static const getReferalJobDataUrl =
      '$_baseurl/leads/v1/getAtsDataReferralJobs?userId=';
  static const fetchjoinersdataurl =
      '$_baseurl/leads/v1/getRefrralsCandidates?referralId=';
  static const fetchinvoiceurl =
      '$_baseurl/leads/v1/getFreelancerInvoiceDetails?referralId=';
  static const submitinvoiceurl = '$_baseurl/leads/v1/createFreelancerInvoice';
  //
  //
  // TODO:: bank
  //
  static const postbankdetailurl = '$_baseurl/bankDetails/v1/saveBankDetails';
  static const fetchbankdetailurl =
      '$_baseurl/bankDetails/v1/getBankingDetailsOfUserByUserId?uid=';
  //
  //
  // TODO:: User
  //
  static const getUserDetailUsinguid = '$_baseurl/api/v1/users/';
  static const postAndUpdateUser = '$_baseurl/api/v1/users/save?token=';
  static const deletUserExpEduCerPro = '$_baseurl/users/v1/deleteById?id=';
  //
  //
  // TODO:: Fiile upload
  //
  static const fileuploadurl = "$_baseurl/api/files/v1/multiUpload";
  //
  //
  // TODO:: Master data
  //
  static const getsuggestionulr = "$_baseurl/master/v1/getByGroup?groupName=";
  static const fetchmasterdatasuggestionurl =
      "$_baseurl/api/master/v1/getMasterDataByGroupName?groupNmae=";
  //
  //
  // TODO:: company
  //
  static const fetchcompanydataurl =
      "$_baseurl/company/v1/all?pageNumber=1&pageSize=10000";
  static const fetchBankList =
      '$_baseurl/company/v1/allBank?pageNumber=1&pageSize=10000';
  //
  //
  // TODO:: fav job
  //
  static const savefavjob = "$_baseurl/favjob/v1/";
  //
  //
  // TODO:: career preference
  // static const careerpreferenceurl =
  static const savejobpreference = '$_baseurl/api/v1/job-preferences/create';
  static const updatejobpreference = '$_baseurl/api/v1/job-preferences/update';
  static const getjobpreferencebyuserid =
      '$_baseurl/api/v1/job-preferences/getByUserId/';
  static const deletejobpreferencebyid =
      '$_baseurl/api/v1/job-preferences/delete/';
}
