// ignore_for_file: constant_identifier_names

enum ThemeButtonSize { xsmall, small, large, medium }

enum ERoute {
  splash('splash'),
  home('home'),
  partnerHome('partnerHome'),
  otpscreen('otpscreen'),
  profile('profile'),
  login('login'),
  screen1('basicInfo'),
  screen2('screen2'),
  screen3('screen3'),
  jobs('jobs'),
  jobsdetail('jobsdetail'),
  businesspartner('businesspartner'),
  application('application'),
  logintype('logintype'),
  businesspartner_confirmation('businesspartner_confirmation'),
  profile_summary('profile_summary'),
  profile_summary_partner('profile_summary_partner'),
  stats('stats'),
  leads('leads'),
  performance('performance');

  const ERoute(this.value);
  final String value;
}

enum AdminERoute { admin_leads }

enum ESharedPreferences {
  user_mobile,
  user_token,
  user_id,
  user_data,
  user_type,
  role,
  user_firstName,
  report_to,
  organization_name,
  user_selected_lcoation,
  email,
  orgnizationId,
  msg,
  theme_mode,
  sim_consent_agreed,
}

enum EPartnerApproval {
  approved(2),
  pending(1),
  reject(3),
  verifying(4);

  const EPartnerApproval(this.value);
  final num value;
}

enum EUserType {
  jobSeeker(1),
  businessPartner(2),
  employee(3);

  const EUserType(this.value);
  final num value;
}

enum FromWhere { homePage, appliedPage, referalPage }

enum InvoiceTab { invoicesent, validation, paid, reject, incorrect }

enum FromCreateAndEditProfile { Create, Edit }

enum FromSignupAndProfile { signup, profile }

enum SuggestionType { jobTitle, company, resideat }

enum FromEditOrAdd { edit, add }

enum PrefTextFieldType { Industry, JobRole, WorkMode, ShiftTime, Location }

enum QuestionType {
    SINGLE_SELECT,MULTIPLE_SELECT,NUMERIC
}

enum JobDetailType {
  education,
  experience,
  language,
  certification,
  diversity,
  shiftWeekOff
}

enum ConListType{
  JobBenefits, Certificate
}
