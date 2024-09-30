import 'dart:async';

class AppListener {
  static final StreamController<Map> _appManageListener =
      StreamController.broadcast();

  static Map<Function, StreamSubscription> listeners = {};

  static void addListener(void Function(dynamic data) onFunc) {
    listeners[onFunc] = _appManageListener.stream.listen(onFunc);
  }

  static void removeListener(void Function(dynamic data) onFunc) {
    StreamSubscription? listener = listeners[onFunc];
    if (listener == null) return;
    listener.cancel();
    listeners.remove(onFunc);
  }

  static void close() {
    _appManageListener.close();
  }

  ///
  //登录成功广播
  static void test(dynamic data) {
    _appManageListener.add(data);
  }
}
