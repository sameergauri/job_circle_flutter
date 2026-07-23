// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, avoid_print
// ignore_for_file: todo

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
import 'package:job_circle/src/model/user_profile/refer_cv_parse_model.dart';
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
  TextEditingController dateofbirth = TextEditingController();
  bool _graduate = false,
      _underGraduate = false,
      _experience = false,
      _fresher = false,
      _today = false,
      _tomorrow = false,
      _other = false,
      _termandconditionone = false,
      _termandconditiontwo = false,
      _male = false,
      _female = false;
  TextEditingController email = TextEditingController();
  DateTime? _dob;
  String? _resume;
  DateTime? _selectedDate;
  ReferResumeParseModel? _cvParseModel;
  ReferAddResumeModel? _referAddResumeModel;
  String? _error;
  String? _age;

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
  ReferResumeParseModel? get cvParseModel => _cvParseModel;
  ReferAddResumeModel? get referAddResumeModel => _referAddResumeModel;
  String? get error => _error;
  bool get male => _male;
  bool get female => _female;
  DateTime? get dob => _dob;
  String? get age => _age;

  void setGender(String gender) {
    if (gender == "male") {
      _male = true;
      _female = false;
    } else if (gender == "female") {
      _female = true;
      _male = false;
    }
    notifyListeners();
  }

  void setDob(DateTime date) {
    // _selectedDate = date;
    _dob = date;
    notifyListeners();
  }

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> postResume({
    required ReferAddResumeModel jsonData,
    required BuildContext context,
    required bool fromDialog,
    required int refId,
  }) async {
    setLoading(true);

    try {
      final response = await AddResumeAndApplyService.referAndAddResume(
        jsonData: jsonData,
        refId: refId,
      );

      setLoading(false);

      if (response == "200") {
        CustomSnackbar.show("Resume Submited Successfully", false);
        NavigationService.pop();
      } else if (response == "DUPLICATE") {
        CustomSnackbar.show(
          "You already referred the same candidate in the last 30 days.",
          true,
        );
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
      setLoading(false);

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
  ) async {
    _isLoading = true;
    _error = null;
    _cvParseModel = null;
    _referAddResumeModel = null;
    clear();
    notifyListeners();
    try {
      _cvParseModel = await ResumeService.referAddResumeCVParsing(
        pdfFile: pdfFile,
      );
      if (_cvParseModel != null &&
          _cvParseModel!.contactNumber != null &&
          _cvParseModel!.contactNumber != "" &&
          _cvParseModel!.contactNumber != "null" &&
          _cvParseModel!.contactNumber != " ") {
        setResume(cvLink);
        firstname.text = _cvParseModel!.firstName ?? '';
        lastname.text = _cvParseModel!.lastName ?? '';
        contactnumber.text = _cvParseModel!.contactNumber ?? '';
        alternatenumber.text = _cvParseModel!.alternateNumber ?? '';
        // Set education level
        if (_cvParseModel!.educationLevel != null) {
          setEducation(_cvParseModel!.educationLevel!);
        }
        if (_cvParseModel!.dateOfBirth != null &&
            _cvParseModel!.dateOfBirth != "") {
          try {
            // 1. Define the format that matches "24-OCT-1996"
            String cleanDate = fixDateCasing(_cvParseModel!.dateOfBirth!);
            // 'dd' = 24, 'MMM' = OCT, 'yyyy' = 1996
            DateFormat formatter = DateFormat('dd-MMM-yyyy');

            // 2. Parse the string into DateTime
            DateTime dobDate = formatter.parse(cleanDate);
            setDob(dobDate);
            String formattedDate = DateFormat('dd MMM yyyy').format(dobDate);
            dateofbirth.text = formattedDate;
            // Check output
            print("Parsed Date: $dobDate");
          } catch (e) {
            print("Invalid Date Format: $e");
          }
        }
        if (_cvParseModel!.email != null && _cvParseModel!.email != "") {
          email.text = _cvParseModel!.email!;
        }
        if (_cvParseModel!.gender != null && _cvParseModel!.gender != "") {
          if (_cvParseModel!.gender!.toLowerCase() == "m" ||
              _cvParseModel!.gender!.toLowerCase() == "male") {
            setGender("male");
          } else if (_cvParseModel!.gender!.toLowerCase() == "f" ||
              _cvParseModel!.gender!.toLowerCase() == "female") {
            setGender("female");
          }
        }
        // Set experience level
        if (_cvParseModel!.experienceLevel != null &&
            _cvParseModel!.experienceLevel!.isNotEmpty) {
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
    if (level == "under" ||
        level == "undergraduate" ||
        level == "Undergraduate" ||
        level == "UnderGraduate") {
      _underGraduate = true;
      _graduate = false;
    } else if (level == "graduate" || level == "Graduate") {
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
    email.clear();
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
    _male = false;
    _female = false;
    _dob = null;
    _age = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    firstname.dispose();
    lastname.dispose();
    contactnumber.dispose();
    alternatenumber.dispose();
    dateofbirth.dispose();
    email.dispose();
  }

  String fixDateCasing(String dateStr) {
    //TODO:: new function to fix date casing
    try {
      var parts = dateStr.split('-'); // ["26", "JUN", "1993"]
      if (parts.length == 3) {
        String month = parts[1];
        // Convert "JUN" to "Jun"
        parts[1] = month[0].toUpperCase() + month.substring(1).toLowerCase();
        return parts.join('-'); // Returns "26-Jun-1993"
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}
