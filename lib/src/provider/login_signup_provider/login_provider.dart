// ignore_for_file: curly_braces_in_flow_control_structures, todo, avoid_print, use_build_context_synchronously
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/services/login_and_signup_services/login_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_reader/sim_reader.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();

  bool _isChecked = false;

  bool get isChecked => _isChecked;

  bool isLoading = false;
  bool isLoadingNumbers = false;
  final LoginService _loginService = LoginService();

  // Phone number detection
  List<Map<String, String>> phoneNumbers = [];
  String? selectedPhoneNumber;
  String? appSignature;

  void changeChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  // ================== SIM Reader (Correct Dual SIM Support) ==================
  Future<void> getPhoneNumbers() async {
    isLoadingNumbers = true;
    phoneNumbers = [];
    selectedPhoneNumber = null;
    notifyListeners();

    print("🔄 Starting SIM detection...");

    try {
      final status = await Permission.phone.request();
      print("📱 Phone Permission: $status");

      if (!status.isGranted) {
        CustomSnackbar.show("Phone permission required", true);
        return;
      }

      // Get ALL SIM Cards
      final List<SimInfo> simList = await SimReader.getAllSimInfo();

      if (simList.isNotEmpty) {
        for (var sim in simList) {
          if (sim.phoneNumber != null && sim.phoneNumber!.trim().isNotEmpty) {
            String formatted = _formatPhoneNumber(sim.phoneNumber!);
            phoneNumbers.add({
              'number': formatted,
              'carrier': sim.carrierName ?? 'Unknown Operator',
              'slot': 'Slot ${(sim.simSlotIndex ?? phoneNumbers.length) + 1}',
              'raw': sim.phoneNumber!,
            });
          }
        }
      } else {
        // Fallback to single SIM if getAllSimInfo fails
        final SimInfo? singleSim = await SimReader.getSimInfo();
        if (singleSim != null &&
            singleSim.phoneNumber != null &&
            singleSim.phoneNumber!.trim().isNotEmpty) {
          String formatted = _formatPhoneNumber(singleSim.phoneNumber!);
          phoneNumbers.add({
            'number': formatted,
            'carrier': singleSim.carrierName ?? 'Unknown',
            'slot': 'SIM 1',
            'raw': singleSim.phoneNumber!,
          });
        }
      }

      if (phoneNumbers.isNotEmpty) {
        setSelectedPhoneNumber(phoneNumbers.first['number']!);
        mobileController.text = _extract10Digits(phoneNumbers.first['number']!);
        // CustomSnackbar.show("${phoneNumbers.length} SIM(s) detected", false);
      } else {
        // CustomSnackbar.show(
        //   "No SIM number detected.\nPlease enter manually.",
        //   true,
        // );
      }
    } catch (e) {
      print("SIM Reader Error: $e");
      CustomSnackbar.show("Error while fetching sim info.", true);
    } finally {
      isLoadingNumbers = false;
      notifyListeners();
    }
  }

  String _extract10Digits(String number) {
    String clean = number.replaceAll(RegExp(r'[^0-9]'), '');
    return clean.length > 10 ? clean.substring(clean.length - 10) : clean;
  }

  String _formatPhoneNumber(String number) {
    String clean = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (clean.startsWith('+91'))
      clean = clean.substring(3);
    else if (clean.startsWith('91') && clean.length > 10)
      clean = clean.substring(2);
    else if (clean.startsWith('+'))
      clean = clean.substring(1);

    if (clean.length > 10) clean = clean.substring(clean.length - 10);

    if (clean.length == 10) {
      return '+91 ${clean.substring(0, 5)} ${clean.substring(5)}';
    }
    return '+91 $clean';
  }

  void setSelectedPhoneNumber(String number) {
    selectedPhoneNumber = number;
    notifyListeners();
  }

  /*   /// Format phone number for display
  String _formatPhoneNumber(String number) {
    // Remove all non-digits except +
    String clean = number.replaceAll(RegExp(r'[^\d+]'), '');

    // If has country code
    if (clean.startsWith('+91')) {
      clean = clean.substring(3); // Remove +91
    } else if (clean.startsWith('91') && clean.length > 10) {
      clean = clean.substring(2); // Remove 91
    } else if (clean.startsWith('+')) {
      clean = clean.substring(1); // Remove +
    }

    // Take last 10 digits
    if (clean.length > 10) {
      clean = clean.substring(clean.length - 10);
    }

    // Format: +91 XXXXX XXXXX
    if (clean.length == 10) {
      return '+91 ${clean.substring(0, 5)} ${clean.substring(5)}';
    }

    return '+91 $clean';
  } */

  /// ✅ Generate OTP
  Future<bool> generateOTP(BuildContext context) async {
    if (mobileController.text.length < 10) {
      _showSnack(context, "Enter valid 10 digit mobile number");
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final res = await _loginService.generateOTP(mobileController.text);

      if (res['resultKey'] == 'SUCCESS') {
        final data = res['resultData'];
        final userData = data['userOtpResponse'];
        CustomSnackbar.show("OTP Sent Successfully", false);
        print('OTP${res['resultData']['userOtpResponse']['otp']}');
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_mobile,
          userData['mobile'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.msg,
          data['msg'] ?? 0,
        );
        return true;
      } else {
        CustomSnackbar.show(res['errorMessage'] ?? "Failed to send OTP", true);
        return false;
      }
    } catch (e) {
      CustomSnackbar.show("Failed to send OTP: $e", true);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Verify OTP + Save SharedPrefs
  Future<bool> verifyOtp(
    BuildContext context,
    String mobile,
    String otp,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await _loginService.validateOtp(mobile: mobile, otp: otp);

      if (res['resultKey'] == 'SUCCESS') {
        final data = res['resultData'];
        final userData = data['userOtpResponse'];

        // Save in SharedPrefs
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_mobile,
          userData['mobile'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_id,
          userData['userId'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_firstName,
          userData['firstName'] ?? '',
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.role,
          userData['role'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_type,
          userData['usertype'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_token,
          data['token'],
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_selected_lcoation,
          '',
        );
        if (userData['firstName'] == null || userData['firstName'] == '') {
          CustomSnackbar.show(
            "Verification successful! Let's continue.",
            false,
          );
        } else {
          CustomSnackbar.show(
            "Hi ${userData['firstName']}! Nice seeing you again.",
            false,
          );
        }
        return true;
      } else {
        CustomSnackbar.show(res['errorMessage'] ?? 'Invalid OTP', true);
        return false;
      }
    } catch (e) {
      CustomSnackbar.show("Error verifying OTP: $e", false);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showSnack(BuildContext context, String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    mobileController.dispose();
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    super.dispose();
  }
}
