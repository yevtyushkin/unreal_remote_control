import 'dart:async';

import 'package:flutter/cupertino.dart';

/// A [ChangeNotifier]
abstract class PageStateNotifier<State> extends ChangeNotifier {
  /// The page [State] managed by this [ChangeNotifier].
  State _state;

  /// Returns the page [State] managed by this [ChangeNotifier].
  State get state => _state;

  /// Returns a new instance of this [ChangeNotifier] with the given initial
  /// state.
  PageStateNotifier(this._state) {
    recover();
  }

  /// Sets this [ChangeNotifier]'s state to the given [newState] and notifies
  /// the listeners.
  void setState(State newState) {
    final oldState = _state;
    _state = newState;
    notifyListeners();
    onStateChanged(oldState, newState);
  }

  /// Updates this [ChangeNotifier]'s state with the given [f] and notifies
  /// the listeners.
  void updateState(State Function(State state) f) {
    setState(f(_state));
  }

  /// Called when the [State] managed by this [ChangeNotifier] changes from
  /// [oldState] to [newState].
  /// ignore: no_empty_block
  FutureOr<void> onStateChanged(State oldState, State newState) {}

  /// Called when this [ChangeNotifier] is created to recover the [State],
  /// set up state, etc.
  // ignore: no_empty_block
  FutureOr<void> recover() {}
}
