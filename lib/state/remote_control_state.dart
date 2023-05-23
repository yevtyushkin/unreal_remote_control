import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/model/exposed_property.dart';
import 'package:unreal_remote_control/model/preset_entry.dart';
import 'package:unreal_remote_control/model/preset_group.dart';
import 'package:unreal_remote_control/state/connection_status.dart';
import 'package:unreal_remote_control/state/selected_preset_group_field.dart';

part 'remote_control_state.freezed.dart';

@freezed
class RemoteControlState with _$RemoteControlState {
  const factory RemoteControlState({
    @Default(ConnectionStatus.disconnected) ConnectionStatus connectionStatus,
    @Default([]) List<PresetEntry> presetEntries,
    PresetEntry? selectedPresetEntry,
    @Default([]) List<PresetGroup> presetGroups,
    SelectedPresetGroupField? selectedPresetGroupField,
  }) = _RemoteControlState;
}
