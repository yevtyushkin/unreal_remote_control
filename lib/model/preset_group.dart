import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/model/exposed_property.dart';

part 'preset_group.freezed.dart';
part 'preset_group.g.dart';

@freezed
class PresetGroup with _$PresetGroup {
  const factory PresetGroup({
    required String name,
    required List<ExposedProperty> exposedProperties,
    // TODO: exposed ExposedFunctions, ExposedActors
  }) = _PresetGroup;

  factory PresetGroup.fromJson(Map<String, dynamic> json) =>
      _$PresetGroupFromJson(json);
}
