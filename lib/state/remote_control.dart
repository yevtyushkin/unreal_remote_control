import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:unreal_remote_control/model/exposed_function.dart';
import 'package:unreal_remote_control/model/exposed_property.dart';
import 'package:unreal_remote_control/model/preset_entry.dart';
import 'package:unreal_remote_control/state/connection_status.dart';
import 'package:unreal_remote_control/state/in.dart';
import 'package:unreal_remote_control/state/out.dart';
import 'package:unreal_remote_control/state/remote_control_state.dart';
import 'package:unreal_remote_control/state/selected_preset_group_field.dart';
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

  RemoteControlState _state = const RemoteControlState();

  RemoteControlState get state => _state;

  void changeConnectionUrl(String? value) {
    _connectionUrl = Uri.tryParse(value ?? '');
  }

  Future<void> toggleConnection() async {
    if (state.connectionStatus == ConnectionStatus.disconnected) {
      final url = _connectionUrl;
      if (url != null) {
        final webSocket = WebSocket(url, binaryType: 'arraybuffer');
        _state = _state.copyWith(connectionStatus: ConnectionStatus.connecting);
        _listen(webSocket);
      }
    } else {
      _state = _state.copyWith(connectionStatus: ConnectionStatus.disconnected);
      await _cleanUp();
    }

    notifyListeners();
  }

  void selectPresetEntry(PresetEntry? entry) {
    if (state.selectedPresetEntry != entry) {
      _state = _state.copyWith(
        selectedPresetEntry: entry,
        presetGroups: [],
        selectedPresetGroupField: null,
      );
      notifyListeners();
      //TODO: unsubscribe from preset
    }

    if (entry != null) {
      _send(getPreset(entry.name));
      // TODO: subscribe to preset updates
    }
  }

  void applyPropertyValue(String value) {
    final preset = _state.selectedPresetEntry;
    final field = _state.selectedPresetGroupField;

    if (preset == null || field is! SelectedProperty) {
      error(
        'Failed to send new property value $value because one of selected preset($preset) or property($field) is null',
      );
      return;
    }

    try {
      final newValue = jsonDecode(value);
      _send(setProperty(preset.name, field.property.displayName, newValue));
    } catch (_) {
      error("Failed to send $value, because it's not a valid JSON / primitive");
    }
  }

  void refreshPropertyValue() {
    final preset = _state.selectedPresetEntry;
    final field = _state.selectedPresetGroupField;

    if (preset == null || field is! SelectedProperty) {
      error(
        'Failed to refresh value because one of selected preset($preset) or property($field) is null',
      );
      return;
    }

    _send(getProperty(preset.name, field.property.displayName));
  }

  void selectExposedProperty(ExposedProperty property) {
    _state = _state.copyWith(
      selectedPresetGroupField: SelectedProperty(property: property, value: null),
    );

    _send(getProperty(_state.selectedPresetEntry?.name ?? '', property.displayName));

    notifyListeners();
  }

  void selectExposedFunction(ExposedFunction function) {
    _state = _state.copyWith(selectedPresetGroupField: SelectedFunction(function: function));

    notifyListeners();
  }

  void refreshTopLevelPresets() => _send(getPresets);

  void _listen(WebSocket socket) {
    _socket = socket;
    _messageSubscription = socket.messages.listen(_onMessage);
    _connectionStateSubscription = socket.connection.listen(_onConnectionState);
  }

  void _onMessage(dynamic value) {
    switch (value) {
      case List<int> codes:
        final asString = String.fromCharCodes(codes);
        info('Received msg: $asString');
        try {
          final json = jsonDecode(asString) as Map<String, dynamic>;

          final handledAsHttp = _tryHandleAsHttp(json);

          if (!handledAsHttp) warn('Unknown msg: $json');
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
          _state = _state.copyWith(presetEntries: [...all.presets]..sort((a, b) => a.name.compareTo(b.name)));
        case GetPreset getPreset:
          _state = _state.copyWith(presetGroups: getPreset.preset.groups);
        case GetExposedProperty getProperty:
          final selectedField = _state.selectedPresetGroupField;
          if (selectedField is SelectedProperty && selectedField.property == getProperty.exposedPropertyDescription) {
            _state = _state.copyWith(
              selectedPresetGroupField: selectedField.copyWith(
                value: getProperty.propertyValues.first.propertyValue,
              ),
            );
          }

        case null:
      }

      notifyListeners();

      return true;
    } catch (e, s) {
      error('$e $s during handling as http');
    }

    return false;
  }

  Future<void> _onConnectionState(ConnectionState state) async {
    final connectionStatus = switch (state) {
      Connecting _ => ConnectionStatus.connecting,
      Reconnecting _ => ConnectionStatus.connecting,
      Connected _ => ConnectionStatus.connected,
      Reconnected _ => ConnectionStatus.connected,
      Disconnecting _ => ConnectionStatus.connecting,
      Disconnected _ => ConnectionStatus.disconnected,
      _ => ConnectionStatus.disconnected
    };

    _state = _state.copyWith(connectionStatus: connectionStatus);

    info('New connection status: $connectionStatus (after received $state)');

    if (connectionStatus == ConnectionStatus.disconnected) {
      await _cleanUp();
    }

    if (connectionStatus == ConnectionStatus.connected) {
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
