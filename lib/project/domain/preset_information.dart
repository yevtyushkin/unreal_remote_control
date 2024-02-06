import 'package:freezed_annotation/freezed_annotation.dart';

part 'preset_information.freezed.dart';
part 'preset_information.g.dart';

/// A model that represents a top-level remote preset information.
@freezed
class PresetInformation with _$PresetInformation {
  /// Returns a new instance of the [PresetInformation] with the
  /// given [name] and [path].
  const factory PresetInformation({
    required String name,
    required String path,
  }) = _PresetInformation;

  /// Returns a new instance of the [PresetInformation] from the
  /// given [json].
  factory PresetInformation.fromJson(Map<String, dynamic> json) =>
      _$PresetInformationFromJson(json);
}
