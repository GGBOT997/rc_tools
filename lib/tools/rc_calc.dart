/*
* @overview: 计算工具
* @Author: rcc 
* @Date: 2022-04-28 22:08:04 
*/

import 'package:decimal/decimal.dart';

class RcCalc {
  RcCalc._();

  /// 加法
  static Decimal plus(String a, String b) {
    return Decimal.parse(a) + Decimal.parse(b);
  }

  /// 减法
  static Decimal minus(String a, String b) {
    return Decimal.parse(a) - Decimal.parse(b);
  }

  /// 乘法
  static Decimal times(String a, String b) {
    return Decimal.parse(a) * Decimal.parse(b);
  }

  /// 除法
  static Decimal divide(String a, String b) {
    return (Decimal.parse(a) / Decimal.parse(b)).toDecimal();
  }

  /// 科学计数转数字字符串
  static String toNumStr(String a) {
    return plus(a, '0').toString();
  }
}
