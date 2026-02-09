import 'package:flutter/material.dart';
import 'package:job_circle/src/provider/add_resume/add_resume_provider.dart';
import 'package:job_circle/src/provider/app_theme_provider.dart/app_theme_provider.dart';
import 'package:job_circle/src/provider/ats/ats_applied_job_page_provider.dart';
import 'package:job_circle/src/provider/ats/ats_referal_job_page_provider.dart';
import 'package:job_circle/src/provider/bank_text_field_provider.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_detail_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/provider/login_signup_provider/login_provider.dart';
import 'package:job_circle/src/provider/login_signup_provider/signup_or_create_usre_provider.dart';
import 'package:job_circle/src/provider/referal_program/bank_detail_provider.dart';
import 'package:job_circle/src/provider/referal_program/invoice_provider.dart';
import 'package:job_circle/src/provider/referal_program/joiners_provider.dart';
import 'package:job_circle/src/provider/referal_program/paymet_status_provider.dart';
import 'package:job_circle/src/provider/suggestion_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:provider/provider.dart';

class ProviderScop {
  static Widget setupProviders({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => JobDetailProvider()),
        ChangeNotifierProvider(create: (_) => ReferResumeProvider()),
        ChangeNotifierProvider(create: (_) => AppliedPageProvider()),
        ChangeNotifierProvider(create: (_) => ReferalPageProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => GenerateInvoiceProvider()),
        ChangeNotifierProvider(create: (_) => PaymentStatusProvider()),
        ChangeNotifierProvider(create: (_) => BankingProvider()),
        ChangeNotifierProvider(create: (_) => SignupCreateUserProvider()),
        ChangeNotifierProvider(create: (_) => SuggestionProvider()),
        ChangeNotifierProvider(create: (_) => BankSuggestionProvider()),
        ChangeNotifierProvider(create: (_) => CareerPreferenceProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ],
      child: child,
    );
  }
}
