// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
import 'package:job_circle/src/model/user_profile/onboarding_cv_parse_model.dart';
import 'package:job_circle/src/screen/referal/add_resume.dart';
import 'package:job_circle/src/services/login_and_signup_services/resume_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/services/referal_and_apply/add_resume_and_apply_services.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_confirmation.dart';

class ReferResumeProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController contactnumber = TextEditingController();
  TextEditingController alternatenumber = TextEditingController();
  bool _graduate = false,
      _underGraduate = false,
      _experience = false,
      _fresher = false,
      _today = false,
      _tomorrow = false,
      _other = false,
      _termandconditionone = false,
      _termandconditiontwo = false;
  String? _resume;
  DateTime? _selectedDate;
  OnBoardCvParseModel? _cvParseModel;
  ReferAddResumeModel? _referAddResumeModel;
  String? _error;

  bool get graduate => _graduate;
  bool get undergraduate => _underGraduate;
  bool get experience => _experience;
  bool get fresher => _fresher;
  bool get today => _today;
  bool get tommorow => _tomorrow;
  bool get other => _other;
  bool get termandconditionone => _termandconditionone;
  bool get termandconditiontwo => _termandconditiontwo;
  String? get resume => _resume;
  DateTime? get selectedDate => _selectedDate;
  OnBoardCvParseModel? get cvParseModel => _cvParseModel;
  ReferAddResumeModel? get referAddResumeModel => _referAddResumeModel;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> postResume({
    required ReferAddResumeModel jsonData,
    required BuildContext context,
    required bool fromDialog,
    required int refId,
  }) async {
    _setLoading(true);

    try {
      final response = await AddResumeAndApplyService.referAndAddResume(
        jsonData: jsonData,
        refId: refId,
      );

      _setLoading(false);

      if (response == "200") {
        CustomSnackbar.show("Resume Submited Successfully", false);
        NavigationService.pop();
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => CustomDialogForConfirmation(
            title: 'Error',
            subtitle: 'Invalid data format. Please check your input.',
            button1text: 'Ok',
            onlysinglebutton: true,
            onYes: () {
              NavigationService.pop();
            },
          ),
        );
      }
    } catch (e) {
      _setLoading(false);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => CustomDialogForConfirmation(
          title: 'Error',
          subtitle: e is FormatException
              ? 'Invalid data format. Please check your input.'
              : 'An error occurred: $e',
          button1text: 'Ok',
          onlysinglebutton: true,
          onYes: () {
            NavigationService.popUntil((p0) => p0.isFirst);
          },
        ),
      );
    }
  }

  /// cv parse fetch function
  // CV Parsing
  Future<void> fetchParseData(
    File pdfFile,
    String cvLink,
    BuildContext context,
    String companyName,
    String role,
    String process,
    String natureOfWork,
    int companyId,
    jobId,
    spocId,
    int userNumber,
    PayoutDetails payoutDetails,
    String contact,
  ) async {
    _isLoading = true;
    _error = null;
    _cvParseModel = null;
    _referAddResumeModel = null;
    clear();
    notifyListeners();
    try {
      _cvParseModel = await ResumeService.onboardingCvParse(
        pdfFile: pdfFile,
        contactno: contact,
      );
      if (_cvParseModel != null && _cvParseModel!.mobileNumber != null) {
        setResume(cvLink);
        firstname.text = _cvParseModel!.firstName ?? '';
        lastname.text = _cvParseModel!.lastName ?? '';
        contactnumber.text = _cvParseModel!.mobileNumber ?? '';
        alternatenumber.text = _cvParseModel!.alternateNumber ?? '';
        // Set education level
        if (_cvParseModel!.educationLevel != null) {
          setEducation(_cvParseModel!.educationLevel!);
        }
        // Set experience level
        if (_cvParseModel!.experience != null &&
            _cvParseModel!.experience!.isNotEmpty) {
          setExperience('fresher');
        } else {
          setExperience('experience');
        }
        notifyListeners();
        NavigationService.push(
          AddResume(
            company_id: companyId,
            jobId: jobId,
            spocId: spocId,
            company_name: companyName,
            role: role,
            process: process,
            nature_of_work: natureOfWork,
            userNumber: userNumber,
            payoutDetails: payoutDetails,
          ),
        );
      } else {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => CustomDialogForConfirmation(
            title: 'Error',
            subtitle: "Upload a valid resume with correct mobile number.",
            button1text: 'Ok',
            onlysinglebutton: true,
            onYes: () {
              NavigationService.pop();
            },
          ),
        );
      }
    } catch (e) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => CustomDialogForConfirmation(
          title: 'Error',
          subtitle:
              e.toString().contains(
                    "Mobile number in CV does not match the provided mobile number",
                  ) ||
                  e.toString().contains("Mobile number")
              ? "Mobile number in Resume does not match the number you entered."
              : "Something went wrong try again",
          button1text: 'Ok',
          onlysinglebutton: true,
          onYes: () {
            NavigationService.pop();
          },
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  //
  // cv parse fetch function end

  void setEducation(String level) {
    if (level == "under") {
      _underGraduate = true;
      _graduate = false;
    } else if (level == "graduate") {
      _graduate = true;
      _underGraduate = false;
    }
    notifyListeners();
  }

  void setTermConditionOne() {
    _termandconditiontwo = false;
    _termandconditionone = !_termandconditionone;
    notifyListeners();
  }

  void setTermConditionTwo() {
    _termandconditionone = false;
    _termandconditiontwo = !_termandconditiontwo;
    notifyListeners();
  }

  void setExperience(String level) {
    if (level == "fresher") {
      _fresher = true;
      _experience = false;
    } else if (level == "experience") {
      _experience = true;
      _fresher = false;
    }
    notifyListeners();
  }

  void setResume(String? resume) {
    if (resume != null) {
      _resume = resume;
    } else {
      _resume = null;
    }
    notifyListeners();
  }

  void clear() {
    firstname.clear();
    lastname.clear();
    contactnumber.clear();
    alternatenumber.clear();
    _underGraduate = false;
    _graduate = false;
    _fresher = false;
    _experience = false;
    _today = false;
    _tomorrow = false;
    _other = false;
    _selectedDate = null;
    _resume = null;
    _termandconditionone = false;
    _termandconditiontwo = false;
  }

  @override
  void dispose() {
    super.dispose();
    firstname.dispose();
    lastname.dispose();
    contactnumber.dispose();
    alternatenumber.dispose();
  }
}
