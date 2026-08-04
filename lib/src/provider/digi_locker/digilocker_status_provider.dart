// digilocker_provider.dart
import 'package:flutter/foundation.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/digi_locker/digilocker_status_model.dart';
import 'package:job_circle/src/services/digi_locker/digi_locker_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class DigilockerProvider with ChangeNotifier {
  DigilockerStatusModel? _statusData;
  bool _isLoading = false;
  String? _error;
  bool _isVerified = false; // final verification status

  DigilockerStatusModel? get statusData => _statusData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isVerified => _isVerified;

  // Convenience getters
  String get name => _statusData?.resultData?.name ?? '';
  String get dob => _statusData?.resultData?.dob ?? '';
  String get gender => _statusData?.resultData?.gender ?? '';
  String get status => _statusData?.resultData?.status ?? '';
  String get userId => _statusData?.resultData?.userId ?? '';
  String get verifiedAt => _statusData?.resultData?.verifiedAt ?? '';
  bool get isSuccess => _statusData?.resultKey == 'SUCCESS';

  Future<void> fetchDigilockerStatus() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _statusData = await getDigilockerStatus(userid.toString());
      _error = null;
    } catch (e) {
      _error = e.toString();
      _statusData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteDigilockerData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool isDeleted = await deleteDigilockerDataAPI();
      if (isDeleted) {
        _statusData = null; // Clear the status data on successful deletion
      }
      return isDeleted;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateVerifiedStatus({required bool isVerified}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await updateVerifiedStatusAPI(isVerified: isVerified);
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Compare local user data with DigiLocker data
  bool verifyWithLocalData({
    required String localName,
    required String localDob,
    required String localGender,
  }) {
    if (_statusData == null || _statusData!.resultData == null) {
      _isVerified = false;
      notifyListeners();
      return false;
    }

    final digi = _statusData!.resultData!;

    // DOB convert
    final convertedDob = convertDobToDigilockerFormat(localDob);

    // Name flexible match
    final nameMatch = isNameMatching(digi.name, localName);

    // Gender normalize karke match
    final genderMatch =
        normalizeGender(digi.gender) == normalizeGender(localGender);

    // DOB match
    final dobMatch = digi.dob == convertedDob;

    _isVerified = nameMatch && dobMatch && genderMatch;
    notifyListeners();
    return _isVerified;
  }

  void clear() {
    _statusData = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Converts "10th June 2008" / "1st August 2008" → "10062008" / "01082008"
  String convertDobToDigilockerFormat(String dob) {
    try {
      String cleaned = dob.toLowerCase().trim();

      // Sirf day ke ordinal hatao (th, st, nd, rd)
      cleaned = cleaned.replaceAllMapped(RegExp(r'(\d+)(st|nd|rd|th)'), (
        match,
      ) {
        return match.group(1)!; // sirf number rakho
      });

      // Ab "10 june 2008" ya "1 august 2008" ban gaya
      final parts = cleaned.split(RegExp(r'\s+'));
      if (parts.length != 3) return '';

      final day = parts[0].padLeft(2, '0');
      final monthName = parts[1];
      final year = parts[2];

      const monthMap = {
        'january': '01',
        'february': '02',
        'march': '03',
        'april': '04',
        'may': '05',
        'june': '06',
        'july': '07',
        'august': '08',
        'september': '09',
        'october': '10',
        'november': '11',
        'december': '12',
      };

      final month = monthMap[monthName];
      if (month == null) return '';

      return '$day$month$year';
    } catch (e) {
      return '';
    }
  }

  /// Flexible name matching
  /// Handles:
  /// - Different order (Surname first / last)
  /// - Extra spaces
  /// - Case difference
  bool isNameMatching(String digiName, String localName) {
    // Clean & lowercase
    final digiParts = digiName
        .toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    final localParts = localName
        .toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (digiParts.isEmpty || localParts.isEmpty) return false;

    // Dono sides ke saare words ko sort karke compare karo
    // Order matter nahi karega
    digiParts.sort();
    localParts.sort();

    // Agar exactly same words hain
    if (digiParts.length == localParts.length) {
      return listEquals(digiParts, localParts);
    }

    // Agar DigiLocker mein zyada words hain (middle name extra),
    // to check karo ki local ke saare words digi mein maujood hain
    if (digiParts.length > localParts.length) {
      return localParts.every((part) => digiParts.contains(part));
    }

    // Agar local mein zyada words hain
    return digiParts.every((part) => localParts.contains(part));
  }

  /// Converts "Male" / "Female" / "M" / "F" → "M" or "F"
  String normalizeGender(String gender) {
    final g = gender.trim().toLowerCase();

    if (g == 'male' || g == 'm') return 'M';
    if (g == 'female' || g == 'f') return 'F';

    return ''; // unknown
  }
}
