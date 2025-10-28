// ignore_for_file: type_literal_in_constant_pattern
import 'package:job_circle/src/constants/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static final SharedPrefsHelper _instance = SharedPrefsHelper._internal();
  static SharedPreferences? _prefs;

  factory SharedPrefsHelper() {
    return _instance;
  }

  SharedPrefsHelper._internal();

  /// **Initialize SharedPreferences (Call this in `main.dart` before runApp)**
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// **Set Preference Without `await`**
  static Future<void> setPreference(
    ESharedPreferences key,
    dynamic value,
  ) async {
    if (_prefs == null) {
      throw Exception(
        "SharedPreferences not initialized. Call SharedPrefsHelper.init() first.",
      );
    }

    switch (value.runtimeType) {
      case String:
        await _prefs!.setString(key.name, value);
        break;
      case bool:
        await _prefs!.setBool(key.name, value);
        break;
      case int:
        await _prefs!.setInt(key.name, value);
        break;
      case double:
        await _prefs!.setDouble(key.name, value);
        break;
      default:
        throw Exception("Unsupported data type for SharedPreferences");
    }
  }

  /// **Get Preference Methods**
  static String getString(ESharedPreferences key, {String defaultValue = ''}) =>
      _prefs?.getString(key.name) ?? defaultValue;

  static int getInt(ESharedPreferences key, {int defaultValue = 0}) =>
      _prefs?.getInt(key.name) ?? defaultValue;

  static bool getBool(ESharedPreferences key, {bool defaultValue = false}) =>
      _prefs?.getBool(key.name) ?? defaultValue;

  static double getDouble(
    ESharedPreferences key, {
    double defaultValue = 0.0,
  }) => _prefs?.getDouble(key.name) ?? defaultValue;

  /// **Remove Specific Key**
  static void remove(ESharedPreferences key) => _prefs?.remove(key.name);

  /// **Clear All SharedPreferences Data**
  static void clearAllPreferences() => _prefs?.clear();
}
