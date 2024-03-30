// ignore_for_file: library_prefixes, unused_import
// ignore_for_file: todo

import 'package:flutter/material.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/routes/admin_router.dart';
import 'package:job_circle/screens/home.dart' deferred as home;
import 'package:job_circle/screens/jobs/job_details.dart'
    deferred as jobsdetails;
import 'package:job_circle/screens/leads/leads.dart' deferred as leads;
import 'package:job_circle/screens/login.dart' deferred as login;
import 'package:job_circle/screens/otp.dart' deferred as otp;
import 'package:job_circle/screens/partnerhome.dart' deferred as partnerhome;
import 'package:job_circle/screens/performance/performance.dart'
    deferred as performance;
import 'package:job_circle/screens/postlogin.dart' deferred as postlogin;
import 'package:job_circle/screens/profile/application.dart'
    deferred as application;
import 'package:job_circle/screens/profile/businesspartner.dart'
    deferred as businesspartner;
import 'package:job_circle/screens/profile/businesspartner_confirm.dart'
    deferred as businesspartnerconfirmation;
import 'package:job_circle/screens/profile/profile.dart' deferred as profile;
import 'package:job_circle/screens/profile/profile_summary.dart'
    deferred as profileSummary;
import 'package:job_circle/screens/profile/profile_summary_partner.dart'
    deferred as profileSummaryPartner;
import 'package:job_circle/screens/splash.dart';
import 'package:job_circle/screens/statistics/statistic.dart'
    deferred as statistic;

// future

Future<void> get lazyHome => home.loadLibrary();
Future<void> get lazyPartnerHome => partnerhome.loadLibrary();
Future<void> get lazyProfile => profile.loadLibrary();
//Future<void> get lazyScreen1 => screen1.loadLibrary();
//Future<void> get lazyScreen2 => screen2.loadLibrary();
//Future<void> get lazyScreen3 => screen3.loadLibrary();
Future<void> get lazyLogin => login.loadLibrary();
Future<void> get lazyOTP => otp.loadLibrary();

Future<void> get lazyJobDetails => jobsdetails.loadLibrary();
Future<void> get lazyBusinessPartner => businesspartner.loadLibrary();
Future<void> get lazyApplication => application.loadLibrary();
Future<void> get lazyPostLogin => postlogin.loadLibrary();
Future<void> get lazyBusinessPartnerConfirmation =>
    businesspartnerconfirmation.loadLibrary();
Future<void> get lazyProfileSummary => profileSummary.loadLibrary();
Future<void> get lazyStatistic => statistic.loadLibrary();
Future<void> get lazyProfileSummaryPartner =>
    profileSummaryPartner.loadLibrary();
Future<void> get lazyLeads => leads.loadLibrary();
Future<void> get lazyPerformance => performance.loadLibrary();

class ApplicationRouter {
  static var appRouter = {
    '/': (context) => const SplashScreen(),
    ERoute.splash.name: (context) => const SplashScreen(),
    ERoute.otpscreen.name: (context) => FutureBuilder(
        future: lazyOTP,
        builder: (snapshot, context) {
          return otp.OTPScreen();
        }),
    ERoute.login.name: (context) => FutureBuilder(
        future: lazyLogin,
        builder: (snapshot, context) {
          return login.Login();
        }),
    ERoute.home.name: (context) => FutureBuilder(
        future: lazyHome,
        builder: (snapshot, context) {
          return home.HomeScreen();
        }),
    ERoute.partnerHome.name: (context) => FutureBuilder(
        future: lazyPartnerHome,
        builder: (snapshot, context) {
          return partnerhome.PartnerHomeScreen();
        }),
    ERoute.profile.name: (context) => FutureBuilder(
        future: lazyProfile,
        builder: (snapshot, context) {
          return profile.ProfileScreen();
        }),
    /* ERoute.screen1.value: (context) => FutureBuilder(
        future: lazyScreen1,
        builder: (snapshot, context) {
          return screen1.Screen1(isfirst: false,);
        }), */
    /*  ERoute.screen2.value: (context) => FutureBuilder(
        future: lazyScreen2,
        builder: (snapshot, context) {
          return screen2.Screen2();
        }), */
    /*   ERoute.screen3.value: (context) => FutureBuilder(
        future: lazyScreen3,
        builder: (snapshot, context) {
          return screen3.Screen3(
            expirieanceFlag: false,
          );
        }), */

    /*  ERoute.jobsdetail.name: (context) => FutureBuilder(  //TODO:: Navigate to jobDetails page...
        future: lazyJobDetails,
        builder: (snapshot, context) {
          return jobsdetails.JobDetails(Applies: false, referal: false, is_freelancer: 0,);
        }), */
    ERoute.businesspartner.name: (context) => FutureBuilder(
        future: lazyBusinessPartner,
        builder: (snapshot, context) {
          return businesspartner.BusinessPartner();
        }),
    ERoute.application.name: (context) => FutureBuilder(
        future: lazyApplication,
        builder: (snapshot, context) {
          return application.ApplicationForm();
        }),
    ERoute.logintype.name: (context) => FutureBuilder(
        future: lazyPostLogin,
        builder: (snapshot, context) {
          return postlogin.PostLogin();
        }),
    ERoute.businesspartner_confirmation.name: (context) => FutureBuilder(
        future: lazyBusinessPartnerConfirmation,
        builder: (snapshot, context) {
          return businesspartnerconfirmation.BusinessPartnerConfirmation();
        }),
    ERoute.profile_summary.name: (context) => FutureBuilder(
        future: lazyProfileSummary,
        builder: (snapshot, context) {
          return profileSummary.ProfileSummary();
        }),
    /*   ERoute.profile_summary_partner.name: (context) => FutureBuilder(
        future: lazyProfileSummaryPartner,
        builder: (snapshot, context) {
          return profileSummaryPartner.ProfileSummaryPartner();
        }), */
    ERoute.stats.name: (context) => FutureBuilder(
        future: lazyStatistic,
        builder: (snapshot, context) {
          return statistic.Statestics();
        }),
    ERoute.leads.name: (context) => FutureBuilder(
        future: lazyLeads,
        builder: (snapshot, context) {
          return leads.Leads();
        }),
    ERoute.performance.name: (context) => FutureBuilder(
        future: lazyPerformance,
        builder: (snapshot, context) {
          return performance.Performance();
        }),
    ...ApplicationAdminRouter.appAdminRouter
  };
}
