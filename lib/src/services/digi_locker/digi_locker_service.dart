import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/digi_locker/digilocker_status_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> startDigiLockerVerification({
  required int userId,
  required BuildContext context,
}) async {
  // Loading dikhane ke liye (optional)
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(color: Constants.darkBlue),
    ),
  );

  try {
    // 1. Backend se Auth URL lo
    final response = await http.get(
      Uri.parse(
        "https://api.jobcircle.co.in/api/v1/digilocker/auth-url?userId=${userId.toString()}",
      ),
      headers: {
        "Content-Type": "application/json",
        // Agar token chahiye to yahan Authorization header add karo
        // "Authorization": "Bearer $token",
      },
    );

    // Loading band karo
    if (context.mounted) Navigator.pop(context);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Aapke backend response structure ke hisaab se adjust karo
      // CommonResponseOld ke hisaab se usually yeh hota hai:
      final String? authUrl = data['resultData'] ?? data['result'];
      final String? message = data['code'];
      final String? status = data['resultKey'];

      if (status == 'ERROR' &&
          message != null &&
          RegExp(r'User \d+ is already verified\.').hasMatch(message)) {
        throw Exception(
          "Previous verification process not completed so please delete that first.",
        );
      }

      if (authUrl == null || authUrl.isEmpty) {
        throw Exception("Auth URL not received from server");
      }

      // 2. Browser mein open karo
      final uri = Uri.parse(authUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Important
        );
      } else {
        throw Exception("Could not open DigiLocker");
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMsg = errorData['message'] ?? "Something went wrong";
      throw Exception(errorMsg);
    }
  } catch (e) {
    // Loading band karo (agar abhi tak open hai)
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Error dikhao
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }

    print("DigiLocker Error: $e");
  }
}

Future<DigilockerStatusModel> getDigilockerStatus(String userId) async {
  final url = Uri.parse(
    '${GlobalConstants.FetchDigiLocker_verificationStatus}$userId',
  );

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // agar token chahiye to yahan add karo
        // 'Authorization': 'Bearer YOUR_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return DigilockerStatusModel.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to load digilocker status. Status code: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Error fetching digilocker status: $e');
  }
}

// digilocker_service.dart

Future<bool> deleteDigilockerDataAPI() async {
  int userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
  final url = Uri.parse(
    '${GlobalConstants.deleteDigiLocker_verificationStatus}$userId',
  );

  try {
    final response = await http.delete(
      // agar backend POST expect karta hai to http.post use karo
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer YOUR_TOKEN', // agar token chahiye
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true; // successfully deleted
    } else {
      throw Exception(
        'Failed to delete digilocker data. Status code: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Error deleting digilocker data: $e');
  }
}

// user_service.dart  (ya jahan aapka user related service hai)

Future<bool> updateVerifiedStatusAPI({required bool isVerified}) async {
  int userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
  final url = Uri.parse(
    '${GlobalConstants.DigiLocker_verificationStatus}$userId/verifiedStatus?isVerified=$isVerified',
  );

  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        // 'Authorization': 'Bearer YOUR_TOKEN', // agar token chahiye
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
        'Failed to update verified status. Status code: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Error updating verified status: $e');
  }
}

Future<Map<String, dynamic>> compareFacesAPI({
  required String digilockerPhotoUrl,
  required String selfiePath,
}) async {
  final uri = Uri.parse(
    '${GlobalConstants.facecomparison_url}'
    '?digilockerPhotoUrl=${Uri.encodeComponent(digilockerPhotoUrl)}',
  );

  final request = http.MultipartRequest('POST', uri);
  request.files.add(await http.MultipartFile.fromPath('selfie', selfiePath));

  final streamed = await request.send();
  final response = await http.Response.fromStream(streamed);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final result = data['resultData'] ?? data;
    return {
      'matched': result['matched'] == true,
      'similarity': (result['similarity'] ?? 0).toDouble(),
      'message': result['message'] ?? '',
    };
  } else {
    throw Exception('Face compare failed: ${response.body}');
  }
}
