import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/controls/model/preset_group.dart';

part 'preset.freezed.dart';
part 'preset.g.dart';

@freezed
class Preset with _$Preset {
  const factory Preset({
    required String name,
    required List<PresetGroup> groups,
    @JsonKey(name: 'ID') @Default('') String id,
    @Default('') String path,
  }) = _Preset;

  factory Preset.fromJson(Map<String, dynamic> json) => _$PresetFromJson(json);
}
