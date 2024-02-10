import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/preset_group.dart';

part 'preset.freezed.dart';
part 'preset.g.dart';

/// A model that represents a remote preset information.
@freezed
class Preset with _$Preset {
  /// Returns a new instance of the [Preset] with the
  /// given [name], [path], and [groups].
  const factory Preset({
    @JsonKey(name: 'ID') required String id,
    required String name,
    required String path,
    @Default([]) List<PresetGroup> groups,
  }) = _Preset;

  /// Returns a new instance of the [Preset] from the
  /// given [json].
  factory Preset.fromJson(Map<String, dynamic> json) => _$PresetFromJson(json);
}
