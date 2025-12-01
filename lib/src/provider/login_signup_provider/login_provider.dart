// ignore_for_file: todo, avoid_print
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/services/login_and_signup_services/login_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();

  bool isLoading = false;
  final LoginService _loginService = LoginService();

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
