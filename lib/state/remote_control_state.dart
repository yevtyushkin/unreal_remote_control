import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/state/connection_status.dart';

part 'remote_control_state.freezed.dart';

@freezed
class RemoteControlState with _$RemoteControlState {
  const factory RemoteControlState({
    required ConnectionStatus connectionStatus,
  }) = _RemoteControlState;
}
