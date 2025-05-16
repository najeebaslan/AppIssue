import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences
class HelperSharedPreferences {
  static HelperSharedPreferences? _singleton;
  static SharedPreferences? _prefs;
  static Future<HelperSharedPreferences?> getInstance() async {
    if (_singleton == null) {
      if (_singleton == null) {
        // keep local instance till it is fully initialized.
        HelperSharedPreferences singleton = HelperSharedPreferences._();
        await singleton._init();
        _singleton = singleton;
      }
    }
    return _singleton;
  }

  HelperSharedPreferences._();

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveMap(String key, Map<String, dynamic> map) async {
    String jsonString = json.encode(map);
    await _prefs?.setString(key, jsonString);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    String? jsonString = _prefs?.getString('key');

    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null; // Return null if no data is found
  }

  static String getString(String key, {String defValue = ''}) {
    return _prefs?.getString(key) ?? defValue;
  }

  static Future<bool>? putString(String key, String? value) {
    return _prefs!.setString(key, value!);
  }

  static bool getBool(String key, {bool defValue = false}) {
    return _prefs!.getBool(key) ?? defValue;
  }

  static Future<bool>? putBool(String key, bool value) {
    return _prefs!.setBool(key, value);
  }

  static int getInt(String key, {int defValue = 0}) {
    return _prefs!.getInt(key) ?? defValue;
  }

  static Future<bool>? putInt(String key, int value) {
    return _prefs!.setInt(key, value);
  }

  static double getDouble(String key, {double defValue = 0.0}) {
    return _prefs!.getDouble(key) ?? defValue;
  }

  static Future<bool>? putDouble(String key, double value) {
    return _prefs!.setDouble(key, value);
  }

  static List<String> getStringList(String key, {List<String> defValue = const <String>[]}) {
    return _prefs!.getStringList(key) ?? defValue;
  }

  static Future<bool>? putStringList(String key, List<String?> value) {
    return _prefs!.setStringList(key, value as List<String>);
  }

  static dynamic getDynamic(String key, {Object? defValue}) {
    return _prefs!.get(key) ?? defValue;
  }

  static bool? haveKey(String key) {
    return _prefs!.getKeys().contains(key);
  }

  static Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  static Future<bool>? remove(String key) {
    return _prefs!.remove(key);
  }

  static Future<bool> clear() {
    return _prefs!.clear();
  }

  static bool isInitialized() {
    return _prefs != null;
  }
}
