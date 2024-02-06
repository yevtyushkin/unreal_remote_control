import 'package:freezed_annotation/freezed_annotation.dart';

part 'preset_group.freezed.dart';
part 'preset_group.g.dart';

/// A model that represents a remote preset group.
@freezed
class PresetGroup with _$PresetGroup {
  /// Returns a new instance of the [PresetGroup] with the given [name].
  const factory PresetGroup({
    required String name,
  }) = _PresetGroup;

  /// Returns a new instance of the [PresetGroup] from the given [json].
  factory PresetGroup.fromJson(Map<String, dynamic> json) =>
      _$PresetGroupFromJson(json);
}
