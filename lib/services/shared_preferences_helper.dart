import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;
  static Map<String, dynamic> _memoryPrefs = Map<String, dynamic>();

  static Future<SharedPreferences> load() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  void setInt(String key, int value) async {
    await load();
    _prefs!.setInt(key, value);
    _memoryPrefs[key] = value;
  }

  Future<int> getInt(String key, {required int def}) async {
    await load();
    int? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs!.getInt(key);
    }
    if (val == null) {
      val = def;
    }
    _memoryPrefs[key] = val;
    return val;
  }
}
