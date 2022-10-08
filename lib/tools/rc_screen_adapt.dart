/*
* @overview: 屏幕适配
* @Author: rcc 
* @Date: 2022-04-28 19:44:49 
*/

import 'dart:math';
import 'package:flutter/material.dart';

class RcScreenAdapt {
  RcScreenAdapt._();

  /// 是否初始化
  static bool _isInit = false;

  /// 设计图宽度及高度
  static const double _uiWidth = 750, _uiHeight = 1334;

  /// 屏幕宽度
  static double screenWidth = 0;

  /// 屏幕高度
  static double screenHeight = 0;

  /// 状态栏高度
  static double statusBarHeight = 0;

  /// 导航栏高度
  static double navigationBarHeight = 0;

  /// 宽度缩放比例
  static double get _scaleWidth => screenWidth / _uiWidth;

  /// 高度缩放比例
  static double get _scaleHeight => screenHeight / _uiHeight;

  /// 缩放比例
  static double get _zoomScale {
    const uiScale = _uiWidth / _uiHeight;
    final screenScale = screenWidth / screenHeight;

    final a = screenScale / uiScale;
    final b = uiScale / screenScale;
    final c = screenScale < uiScale ? min(a, b) : max(a, b);

    return c;
  }

  /// 屏幕适配初始化
  static void init(BuildContext context) {
    _isInit = true;

    if (screenWidth != 0 && statusBarHeight != 0) return;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    navigationBarHeight = MediaQuery.of(context).padding.bottom;
  }

  /// 获取适配宽度
  static double getAdaptWidth(double width) {
    assert(_isInit, 'RcScreenAdapt未初始化');
    return width * _scaleWidth;
  }

  /// 获取适配高度
  static double getAdaptHeight(double height) {
    assert(_isInit, 'RcScreenAdapt未初始化');
    return height * _scaleHeight * _zoomScale;
  }

  /// 获取适配字体大小
  static double getAdaptFontSize(double fontSize) {
    assert(_isInit, 'RcScreenAdapt未初始化');
    return fontSize * _scaleHeight * _zoomScale;
  }
}

extension RcScreenAdaptExtension on num {
  /// 获取适配宽度
  double get w => RcScreenAdapt.getAdaptWidth(toDouble()).toDouble();

  /// 获取适配高度
  double get h => RcScreenAdapt.getAdaptHeight(toDouble()).toDouble();

  /// 获取适配字体
  double get sp => RcScreenAdapt.getAdaptFontSize(toDouble()).toDouble();
}
