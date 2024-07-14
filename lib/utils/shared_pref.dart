import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setValueBool(String key, bool value) async =>
      await _preferences.setBool(key, value);
  static Future setValueString(String key, String value) async =>
      await _preferences.setString(key, value);
  static bool? getValue(String key) => _preferences.getBool(key);
  static String? getString(String key) => _preferences.getString(key);
}
