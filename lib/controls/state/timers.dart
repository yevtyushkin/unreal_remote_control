import 'dart:async';

import 'package:unreal_remote_control/common/log.dart';
import 'package:uuid/uuid.dart';

class Timers {
  final Map<String, Timer> _timers = {};
  final _uuid = const Uuid();

  String register(Timer timer) {
    final id = _uuid.v1();
    _timers[id] = timer;
    return id;
  }

  bool stop(String id) {
    final timer = _timers[id];
    if (timer == null) return false;
    timer.cancel();
    _timers.remove(id);
    return true;
  }

  void clean() {
    _timers.forEach((id, timer) {
      info('Cancelling timer $id');
      timer.cancel();
    });
    _timers.clear();
  }
}
