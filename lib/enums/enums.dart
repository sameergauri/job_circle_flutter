enum ThemeButtonSize {
  xsmall,
  small,
  large,
  medium,
}

enum ERoute {
  splash,
  home,
  otpscreen,
  profile,
  login,
  screen1,
  screen2,
  screen3,
  jobs,
  jobsdetail,
  businesspartner,
  application,
  logintype,
  businesspartner_confirmation,
  profile_summary
}

enum AdminERoute { admin_leads }

enum ESharedPreferences { user_mobile, user_id, user_data, user_type }

enum EUserType {
  jobSeeker(1),
  businessPartner(2),
  employee(2);

  const EUserType(this.value);
  final num value;
}
