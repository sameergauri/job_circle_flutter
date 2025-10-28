// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
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
