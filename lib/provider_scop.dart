import 'package:flutter/material.dart';
import 'package:job_circle/src/provider/add_resume/add_resume_provider.dart';
import 'package:job_circle/src/provider/app_theme_provider.dart/app_theme_provider.dart';
import 'package:job_circle/src/provider/ats/ats_applied_job_page_provider.dart';
import 'package:job_circle/src/provider/ats/ats_referal_job_page_provider.dart';
import 'package:job_circle/src/provider/bank_text_field_provider.dart';
import 'package:job_circle/src/provider/business_ats/business_ats_provider.dart';
import 'package:job_circle/src/provider/business_job/business_job_provider.dart';
import 'package:job_circle/src/provider/business_job/master_screening_question_provider.dart';
import 'package:job_circle/src/provider/business_job/screening_question_provider.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/provider/business_page/company_member_provider.dart';
import 'package:job_circle/src/provider/business_page/custom_suggestion_textfield_provider.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/provider/digi_locker/digilocker_status_provider.dart';
import 'package:job_circle/src/provider/faq/faq_provider.dart';
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
        ChangeNotifierProvider(create: (_) => FaqProvider()),
        ChangeNotifierProvider(create: (_) => DigilockerProvider()),
        ChangeNotifierProvider(create: (_) => BusinessCompanyProvider()),
        ChangeNotifierProvider(
          create: (_) => BusinessCompanySuggestionProvider(),
        ),
        ChangeNotifierProvider(create: (_) => BusinessJobProvider()),
        ChangeNotifierProvider(create: (_) => ScreeningQuestionProvider()),
        ChangeNotifierProvider(
          create: (_) => MasterScreeningQuestionProvider(),
        ),
        ChangeNotifierProvider(create: (_) => AtsProvider()),
        ChangeNotifierProvider(create: (_) => CompanyMembershipProvider()),
      ],
      child: child,
    );
  }
}
