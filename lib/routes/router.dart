import 'package:flutter/material.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/splash.dart';
import 'package:job_circle/screens/home.dart' deferred as home;
import 'package:job_circle/screens/profile/profile.dart' deferred as profile;
import 'package:job_circle/screens/profile/screen1.dart' deferred as screen1;
import 'package:job_circle/screens/profile/screen2.dart' deferred as screen2;
import 'package:job_circle/screens/profile/screen3.dart' deferred as screen3;
import 'package:job_circle/screens/login.dart' deferred as login;
import 'package:job_circle/screens/otp.dart' deferred as otp;
import 'package:job_circle/screens/jobs/jobs.dart' deferred as jobs;
import 'package:job_circle/screens/jobs/job_details.dart'
    deferred as jobsdetails;
import 'package:job_circle/screens/profile/businesspartner.dart'
    deferred as businesspartner;
import 'package:job_circle/screens/profile/application.dart'
    deferred as application;
import 'package:job_circle/screens/postlogin.dart' deferred as postlogin;

import 'package:job_circle/screens/profile/businesspartner_confirm.dart'
    deferred as businesspartnerconfirmation;

// future

Future<void> get lazyHome => home.loadLibrary();
Future<void> get lazyProfile => profile.loadLibrary();
Future<void> get lazyScreen1 => screen1.loadLibrary();
Future<void> get lazyScreen2 => screen2.loadLibrary();
Future<void> get lazyScreen3 => screen3.loadLibrary();
Future<void> get lazyLogin => login.loadLibrary();
Future<void> get lazyOTP => otp.loadLibrary();
Future<void> get lazyJobs => jobs.loadLibrary();
Future<void> get lazyJobDetails => jobsdetails.loadLibrary();
Future<void> get lazyBusinessPartner => businesspartner.loadLibrary();
Future<void> get lazyApplication => application.loadLibrary();
Future<void> get lazyPostLogin => postlogin.loadLibrary();
Future<void> get lazyBusinessPartnerConfirmation =>
    businesspartnerconfirmation.loadLibrary();

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
    ERoute.profile.name: (context) => FutureBuilder(
        future: lazyProfile,
        builder: (snapshot, context) {
          return profile.ProfileScreen();
        }),
    ERoute.screen1.name: (context) => FutureBuilder(
        future: lazyScreen1,
        builder: (snapshot, context) {
          return screen1.Screen1();
        }),
    ERoute.screen2.name: (context) => FutureBuilder(
        future: lazyScreen2,
        builder: (snapshot, context) {
          return screen2.Screen2();
        }),
    ERoute.screen3.name: (context) => FutureBuilder(
        future: lazyScreen3,
        builder: (snapshot, context) {
          return screen3.Screen3();
        }),
    ERoute.jobs.name: (context) => FutureBuilder(
        future: lazyJobs,
        builder: (snapshot, context) {
          return jobs.Jobs();
        }),
    ERoute.jobsdetail.name: (context) => FutureBuilder(
        future: lazyScreen3,
        builder: (snapshot, context) {
          return jobsdetails.JobDetails();
        }),
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
  };
}
