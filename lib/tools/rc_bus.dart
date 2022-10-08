/*
* @overview: bus通信
* @Author: rcc 
* @Date: 2022-07-20 16:35:30 
*/

import 'dart:async';
import 'package:event_bus/event_bus.dart';

class RcBus {
  static final EventBus _eventBus = EventBus();

  /// 通知更新
  static void fire(dynamic event) => _eventBus.fire(event);

  final List<StreamSubscription> _streams = [];

  /// 添加流监听
  void listen<T>(void Function(T event)? callBack) {
    final stream = _eventBus.on<T>().listen(callBack);

    _streams.add(stream);
  }

  /// 取消流监听
  void cancel() {
    for (var stream in _streams) {
      stream.cancel();
    }
  }
}
