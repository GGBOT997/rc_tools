/*
* @overview: 本地存储
* @Author: rcc 
* @Date: 2022-04-28 19:41:06 
*/

import 'package:shared_preferences/shared_preferences.dart';

class RcStorage {
  RcStorage._();

  /// 设置本地存储
  static Future<bool> setValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final status = await prefs.setString(key, value);

    return status;
  }

  /// 获取本地存储
  static Future<String> getValue(String key, [String defaultValue = '']) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);

    return value ?? defaultValue;
  }

  /// 清除本地存储
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final status = await prefs.remove(key);

    return status;
  }

  /// 清除所有本地存储
  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final status = await prefs.clear();

    return status;
  }
}

class RcStorageKey {
  RcStorageKey._();

  /// token标识
  static const String token = 'token_key';

  /// 主题标识
  static const String theme = 'theme_key';

  /// 语言标识
  static const String language = 'language_key';
}
