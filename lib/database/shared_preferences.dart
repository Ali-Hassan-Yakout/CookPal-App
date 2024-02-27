import 'package:shared_preferences/shared_preferences.dart';

enum PrefKeys { isLoggedIn, onBoarding, theme}

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> _instance() async {
    return _prefsInstance ??= await SharedPreferences.getInstance();
  }

  static Future<void> init() async {
    _prefsInstance = await _instance();
  }

  static String getString(PrefKeys key, [String defValue = '']) {
    return _prefsInstance!.getString(key.name) ?? defValue;
  }

  static Future<bool> setString(PrefKeys key, String value) async {
    return _prefsInstance!.setString(key.name, value);
  }

  static bool getBool(PrefKeys key, [bool defValue = false]) {
    return _prefsInstance!.getBool(key.name) ?? defValue;
  }

  static Future<bool> setBool(PrefKeys key, bool value) async {
    return _prefsInstance!.setBool(key.name, value);
  }

  static double getDouble(PrefKeys key, [double defValue = 0]) {
    return _prefsInstance!.getDouble(key.name) ?? defValue;
  }

  static Future<bool> setDouble(PrefKeys key, double value) async {
    return _prefsInstance!.setDouble(key.name, value);
  }

  static int getInt(PrefKeys key, [int defValue = 0]) {
    return _prefsInstance!.getInt(key.name) ?? defValue;
  }

  static Future<bool> setInt(PrefKeys key, int value) async {
    return _prefsInstance!.setInt(key.name, value);
  }

  static List<String>? getStringList(PrefKeys key,
      [List<String> defValue = const []]) {
    return _prefsInstance!.getStringList(key.name) ?? defValue;
  }

  static Future<bool> setStringList(PrefKeys key, List<String> value) async {
    return _prefsInstance!.setStringList(key.name, value);
  }
}
