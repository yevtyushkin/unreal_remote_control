import 'dart:async';

import 'package:flutter/foundation.dart';

/// A class that allows to delay an execution of a function till some fixed
/// delay.
class Debouncer {
  /// Returns a new instance of the [Debouncer].
  Debouncer();

  /// An internal state of this [Debouncer].
  final Map<String, Timer> _state = {};

  /// Registers a new debounce with the given [key], [duration] and [action].
  /// Cancels an existing debounce if there is one with the given [key].
  void debounce(
    String key,
    Duration duration,
    VoidCallback action,
  ) {
    final currentDebounce = _state[key];
    currentDebounce?.cancel();

    final newDebounce = Timer(
      duration,
      () {
        action();
        _state.remove(key);
      },
    );
    _state[key] = newDebounce;
  }

  /// Cancels a debounce with the given [key].
  void cancel(String key) {
    final currentDebounce = _state[key];
    currentDebounce?.cancel();

    _state.remove(key);
  }
}
