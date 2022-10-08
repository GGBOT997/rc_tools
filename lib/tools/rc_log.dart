/*
* @overview: 日志打印
* @Author: rcc 
* @Date: 2022-05-05 13:45:23 
*/

import 'package:logger/logger.dart';

class RcLog {
  RcLog._();

  static final Logger _logger = Logger();

  static void i(
    dynamic message, [
    String? tag,
    StackTrace? t,
  ]) {
    _logger.i(message, tag, t);
  }

  static void e(
    String tag, [
    dynamic e,
    StackTrace? t,
  ]) {
    _logger.e(tag, e, t);
  }
}
