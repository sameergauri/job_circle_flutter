// ignore_for_file: todo, avoid_print
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/services/login_and_signup_services/login_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_reader/sim_reader.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();

  bool isLoading = false;
  bool isLoadingNumbers = false;
  final LoginService _loginService = LoginService();

  // Phone number detection
  List<Map<String, String>> phoneNumbers = [];
  String? selectedPhoneNumber;
  String? appSignature;

  /// ✅ Get REAL Phone Numbers from SIM Cards using mobile_number package
  Future<void> getPhoneNumbers() async {
    isLoadingNumbers = true;
    notifyListeners();

    try {
      // 1. Permission request (sim_reader requires READ_PHONE_STATE)
      var phonePermission = await Permission.phone.request();

      if (phonePermission.isGranted) {
        // Get app signature (Same as before)
        try {
          appSignature = await SmsAutoFill().getAppSignature;
          print('📱 App Signature: $appSignature');
        } catch (e) {
          print('⚠️ Signature Error: $e');
        }

        // 2. Fetch SIM Cards using sim_reader
        // sim_reader returns List<SimCard>
        List<SimInfo>? simCards = await SimReader.getAllSimInfo();

        List<Map<String, String>> detectedNumbers = [];

        if (simCards.isNotEmpty) {
          print('🔍 Found ${simCards.length} SIM card(s)');

          for (var sim in simCards) {
            // Debug prints to see what we are getting
            print(
              '📱 Found SIM: ${sim.phoneNumber} | Carrier: ${sim.carrierName}',
            );

            // sim_reader uses .phoneNumber instead of .number
            if (sim.phoneNumber != null && sim.phoneNumber!.isNotEmpty) {
              detectedNumbers.add({
                'number': _formatPhoneNumber(sim.phoneNumber!),
                'carrier': sim.carrierName ?? 'Unknown',
                'slot': "SIM ${sim.simSlotIndex ?? detectedNumbers.length + 1}",
                'slotIndex': '${sim.simSlotIndex ?? 0}',
              });
            }
          }
        }

        phoneNumbers = detectedNumbers;

        if (phoneNumbers.isEmpty) {
          print(
            '⚠️ SIM cards found but numbers are empty (Carrier restriction)',
          );
          // Option: Yahan aap SmsAutoFill().hint call kar sakte hain fallback ke liye
        }
      } else {
        print('❌ Permission Denied');
        CustomSnackbar.show("Phone permission required", true);
      }
    } catch (e) {
      print('❌ sim_reader Error: $e');
      phoneNumbers = [];
    } finally {
      isLoadingNumbers = false;
      notifyListeners();
    }
  }

  /// Format phone number for display
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
  }

  /// Set selected phone number
  void setSelectedPhoneNumber(String number) {
    selectedPhoneNumber = number;
    notifyListeners();
  }

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
