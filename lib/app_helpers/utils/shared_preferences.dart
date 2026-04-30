// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  //pref- value
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String IS_SLIDER_SHOWN = 'IS_SLIDER';
  static const String ACCESS_TOKEN = "access_token";
  static const String ROLE = "role";
  static const String MEMBER_TOKEN = "member_token";
  static const String USERNAME = "userName";
  static const String MEMBER_ID = "member_id";
  static const String FCM_TOKEN = 'fcm_token';
  static const String EMPLOYEE_ID = "employeeId";
  static const String ORGANIZATION_ID = "organizationId";

  static const String DARK_MODE = "dark";

  static SpUtil? _instance;

  static Future<SpUtil> get instance async {
    return await getInstance();
  }

  static SharedPreferences? _spf;

  SpUtil._();

  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<SpUtil> getInstance() async {
    _instance ??= SpUtil._();
    if (_spf == null) {
      await _instance!._init();
    }
    return _instance!;
  }

  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    return _spf!.getKeys();
  }

  Object? get(String key) {
    return _spf!.get(key);
  }

  String? getString(String key) {
    return _spf!.getString(key);
  }

  Future<bool> putString(String key, String value) {
    return _spf!.setString(key, value);
  }

  bool? getBool(String key) {
    return _spf!.getBool(key);
  }

  Future<bool> putBool(String key, bool value) {
    return _spf!.setBool(key, value);
  }

  int? getInt(String key) {
    return _spf!.getInt(key);
  }

  Future<bool> putInt(String key, int value) {
    return _spf!.setInt(key, value);
  }

  double? getDouble(String key) {
    return _spf!.getDouble(key);
  }

  Future<bool> putDouble(String key, double value) {
    return _spf!.setDouble(key, value);
  }

  List<String>? getStringList(String key) {
    return _spf!.getStringList(key);
  }

  Future<bool> putStringList(String key, List<String> value) {
    return _spf!.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    return _spf!.get(key);
  }

  Future<bool> remove(String key) {
    return _spf!.remove(key);
  }

  Future<bool> clear() {
    return _spf!.clear();
  }

  void clearImportantKeys() {
    remove(IS_SLIDER_SHOWN);
    remove(ACCESS_TOKEN);
    remove(MEMBER_TOKEN);
    remove(IS_LOGGED_IN);
    remove(MEMBER_ID);
    remove(USERNAME);
    remove(ROLE);
  }
}

// final sp = await SpUtil.getInstance();

// int employeeId = sp.getInt(SpUtil.EMPLOYEE_ID) ?? 0;
// int organizationId = sp.getInt(SpUtil.ORGANIZATION_ID) ?? 0;
