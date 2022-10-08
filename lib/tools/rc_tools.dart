/*
* @overview: 工具类
* @Author: rcc 
* @Date: 2022-04-28 21:44:16 
*/

import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';

class RcTools {
  RcTools._();

  /// 复制到剪切板
  static Future<bool> copyText(String text) {
    final Completer<bool> completer = Completer();

    Clipboard.setData(ClipboardData(text: text)).then((value) {
      completer.complete(true);
    }).catchError((_) {
      completer.completeError(false);
    });

    return completer.future;
  }

  /// 结尾去零
  static String removeZero(String text) {
    String newText = text;

    if (newText.contains('.')) {
      newText = newText.replaceAll(RegExp(r'0+$'), '');
      newText = newText.replaceAll(RegExp(r'\.$'), '');
    }

    return newText;
  }

  /// 时间格式化
  static String timeFormat(int time, [String? format]) {
    final int timestamp = int.parse(time.toString().padRight(13, '0'));
    final DateTime now = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final y = now.year;
    final m = '${now.month}'.padLeft(2, '0');
    final d = '${now.day}'.padLeft(2, '0');
    final h = '${now.hour}'.padLeft(2, '0');
    final min = '${now.minute}'.padLeft(2, '0');
    final s = '${now.second}'.padLeft(2, '0');

    switch (format) {
      case 'YY-MM-DD':
        return '$y-$m-$d';
      case 'MM-DD hh:mm':
        return '$m-$d $h:$min';
      case 'hh-mm-ss':
        return '$h-$min-$s';
      case 'hh:mm:ss':
        return '$h:$min:$s';
      case 'hh:mm':
        return '$h:$min';
      case 'hh:mm MM/DD':
        return '$h:$min $m/$d';
      default:
        return '$y-$m-$d $h:$min:$s';
    }
  }

  /// Duration格式化
  static String formatDuration(Duration duration) {
    final String hours = duration.inHours.toString().padLeft(1, '0');
    final String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours == '0') {
      return "$minutes:$seconds";
    } else {
      return "$hours:$minutes:$seconds";
    }
  }

  /// 获取一个随机id
  static String randomId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomInt = Random().nextInt(500);
    final randomDouble = Random().nextDouble();

    return '$timestamp$randomInt$randomDouble';
  }
}
