import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:unreal_remote_control/model/exposed_property.dart';
import 'package:unreal_remote_control/model/preset.dart';
import 'package:unreal_remote_control/model/preset_entry.dart';
import 'package:unreal_remote_control/state/connection_status.dart';
import 'package:unreal_remote_control/state/in.dart';
import 'package:unreal_remote_control/state/out.dart';
import 'package:unreal_remote_control/state/timers.dart';
import 'package:unreal_remote_control/util/log.dart';
import 'package:web_socket_client/web_socket_client.dart';

const _pingInterval = Duration(seconds: 5);

class RemoteControl extends ChangeNotifier {
  Uri? _connectionUrl;
  WebSocket? _socket;
  StreamSubscription<dynamic>? _messageSubscription;
  StreamSubscription<ConnectionState>? _connectionStateSubscription;
  final Timers _timers = Timers();

  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  ConnectionStatus get connectionStatus => _connectionStatus;

  List<PresetEntry> _presetEntries = [];

  List<PresetEntry> get presetEntries => List.unmodifiable(_presetEntries);

  PresetEntry? _presetEntry;

  PresetEntry? get presetEntry => _presetEntry;

  Preset? _preset;

  Preset? get preset => _preset;

  ExposedProperty? _exposedProperty;

  ExposedProperty? get exposedProperty => _exposedProperty;

  final Map<String, dynamic> _propertyValues = {};

  dynamic get currentValue {
    final exposedProperty = this.exposedProperty;
    if (exposedProperty == null) return null;
    return _propertyValues[exposedProperty.displayName];
  }

  void changeConnectionUrl(String? value) {
    _connectionUrl = Uri.tryParse(value ?? '');
  }

  Future<void> toggleConnection() async {
    if (_connectionStatus == ConnectionStatus.disconnected) {
      final url = _connectionUrl;
      if (url != null) {
        final webSocket = WebSocket(url, binaryType: 'arraybuffer');
        _connectionStatus = ConnectionStatus.connecting;
        notifyListeners();
        _listen(webSocket);
      }
    } else {
      _connectionStatus = ConnectionStatus.disconnected;
      await _cleanUp();
      notifyListeners();
    }
  }

  void selectPresetEntry(PresetEntry? entry) {
    if (_presetEntry != entry) {
      _preset = null;
      _exposedProperty = null;
      //TODO: unsubscribe from preset
    }

    _presetEntry = entry;
    if (entry != null) {
      // TODO: subscribe to preset updates
      _send(getPreset(entry.name));
      _send(subscribeToPreset(entry.name));
    }

    notifyListeners();
  }

  void sendNewValue(String value) {
    final preset = _preset;
    final property = _exposedProperty;
    if (preset == null || property == null) {
      error(
        'Failed to send new property value $value because one of selected preset($preset) or property($property) is null',
      );
      return;
    }

    try {
      final newValue = jsonDecode(value);
      _send(setProperty(preset.name, property.displayName, newValue));
    } catch (_) {
      error("Failed to send $value, because it's not a valid JSON / primitive");
    }
  }

  void refreshValue() {
    final preset = _preset;
    final property = _exposedProperty;
    if (preset == null || property == null) {
      error(
        'Failed to refresh value because one of selected preset($preset) or property($property) is null',
      );
      return;
    }

    _send(getProperty(preset.name, property.displayName));
  }

  void selectExposedProperty(ExposedProperty property) {
    _exposedProperty = property;

    if (!_propertyValues.containsKey(property.displayName)) {
      _send(getProperty(_preset?.name ?? '', property.displayName));
    }

    notifyListeners();
  }

  void refreshTopLevelPresets() => _send(getPresets);

  void _listen(WebSocket socket) {
    _socket = socket;
    _messageSubscription = socket.messages.listen(_onMessage);
    _connectionStateSubscription = socket.connection.listen(_onConnectionState);
  }

  void _onMessage(dynamic value) {
    info('Received top-lvl msg: $value');

    switch (value) {
      case List<int> codes:
        final asString = String.fromCharCodes(codes);
        info('Received msg: $asString');
        try {
          final json = jsonDecode(asString) as Map<String, dynamic>;

          final handledAsHttp = _tryHandleAsHttp(json);
          final handledAsPresetEvent = _tryHandleAsPresetEvent(json);

          if (!(handledAsHttp || handledAsPresetEvent))
            warn('Unknown msg: $json');
        } catch (e) {
          error('Failed to process message $asString due to $e');
        }

      case _:
        warn('Received a message with unknown type: $value');
    }
  }

  bool _tryHandleAsHttp(Map<String, dynamic> json) {
    try {
      final envelope = HttpResponseEnvelope.fromJson(json);

      switch (envelope.response) {
        case AllPresets all:
          _presetEntries = [...all.presets]
            ..sort((a, b) => a.name.compareTo(b.name));
          info('New preset entries: $_presetEntries');
        case GetPreset getPreset:
          _preset = getPreset.preset;
          info('Got preset: $_preset');
        case GetExposedProperty getProperty:
          _propertyValues[getProperty.exposedPropertyDescription.displayName] =
              getProperty.propertyValues.first.propertyValue;
          info('Got property: $getProperty');
        case null:
          info('Received empty body response');
      }
      notifyListeners();

      return true;
    } catch (e, s) {
      error('$e $s during handling as http');
    }

    return false;
  }

  bool _tryHandleAsPresetEvent(Map<String, dynamic> json) {
    return false;
  }

  Future<void> _onConnectionState(ConnectionState state) async {
    _connectionStatus = switch (state) {
      Connecting _ => ConnectionStatus.connecting,
      Reconnecting _ => ConnectionStatus.connecting,
      Connected _ => ConnectionStatus.connected,
      Reconnected _ => ConnectionStatus.connected,
      Disconnecting _ => ConnectionStatus.connecting,
      Disconnected _ => ConnectionStatus.disconnected,
      _ => ConnectionStatus.disconnected
    };

    info('New connection status: $_connectionStatus (after received $state)');

    if (_connectionStatus == ConnectionStatus.disconnected) {
      await _cleanUp();
    }

    if (_connectionStatus == ConnectionStatus.connected) {
      _timers.register(
        Timer.periodic(_pingInterval, (_) => _send('ping')),
      );
      _send(getPresets);
    }

    notifyListeners();
  }

  void _send(String msg) {
    info('Sending $msg');
    _socket?.send(msg);
  }

  @override
  Future<void> dispose() async {
    await _cleanUp();
    super.dispose();
  }

  Future<void> _cleanUp() async {
    _socket?.close();
    await _messageSubscription?.cancel();
    await _connectionStateSubscription?.cancel();
    _timers.clean();

    _socket = null;
    _messageSubscription = null;
    _connectionStateSubscription = null;
  }
}
