/*
* @overview: 单Isolate组件
* @Author: rcc 
* @Date: 2022-05-05 15:03:38 
*/

import 'dart:async';
import 'dart:isolate';

class RcIsolate {
  RcIsolate() {
    createIsolate();
  }

  Isolate? _isolate;
  late SendPort _sendPort;

  static void _rcIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final callBack = message[0];
      final argument = message[1];
      final replyPort = message[2];

      _rcIsolateRun(
        callBack: callBack,
        argument: argument,
        replyPort: replyPort,
      );
    });
  }

  static Future<void> _rcIsolateRun<T, R>({
    required Future<T> Function(R argument) callBack,
    required R argument,
    required SendPort replyPort,
  }) async {
    try {
      final result = await callBack(argument);
      replyPort.send([result]);
    } catch (e, t) {
      replyPort.send([e.toString(), t.toString()]);
    }
  }

  Future<void> createIsolate({String debugName = 'RcIsolate'}) async {
    final _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      _rcIsolate,
      _receivePort.sendPort,
      debugName: debugName,
    );

    _sendPort = await _receivePort.first;

    _receivePort.close();
  }

  Future<T> compute<T, R>(
    FutureOr<T> Function(R) function, {
    dynamic argument,
    Duration? timeout,
    FutureOr<T> Function()? onTimeout,
  }) async {
    assert(_isolate != null, 'RcIsolate 未创建');

    final receivePort = RawReceivePort();
    final completer = Completer<T>.sync();

    _singleResultFuture(
      completer,
      receivePort,
      timeout: timeout,
      onTimeout: onTimeout,
    );

    _sendPort.send([function, argument, receivePort.sendPort]);

    return completer.future;
  }

  void _singleResultFuture<T>(
    Completer<T> completer,
    RawReceivePort receivePort, {
    Duration? timeout,
    FutureOr<T> Function()? onTimeout,
  }) async {
    Timer? timer;

    final zone = Zone.current;
    final action = zone.registerUnaryCallback((response) {
      try {
        final List result = response as List;

        /// 处理失败
        if (result.length == 2) {
          completer.completeError(result.first, StackTrace.fromString(result.last));
        } else {
          completer.complete(result.first as T);
        }
      } catch (e, t) {
        completer.completeError(e, t);
      }
    });

    receivePort.handler = (response) {
      timer?.cancel();
      receivePort.close();
      zone.runUnary(action, response);
    };

    if (timeout != null) {
      timer = Timer(timeout, () {
        timer?.cancel();
        receivePort.close();

        if (onTimeout != null) {
          try {
            completer.complete(Future.sync(onTimeout));
          } catch (e, t) {
            completer.completeError(e, t);
          }
        } else {
          completer.completeError(
            'compute 超时',
            StackTrace.current,
          );
        }
      });
    }
  }

  void kill() {
    _isolate?.kill();
  }
}
