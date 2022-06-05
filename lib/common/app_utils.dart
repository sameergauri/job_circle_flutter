import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  static clearSession() async {
    SharedPreferences refs = await Utils.getSharedPreferences();
    for (var value in ESharedPreferences.values) {
      Utils.clearAllSharedPreference(refs, value.name);
    }
  }
}
