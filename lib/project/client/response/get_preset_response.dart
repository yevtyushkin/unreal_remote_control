import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/preset.dart';

part 'get_preset_response.freezed.dart';
part 'get_preset_response.g.dart';

/// Represents a /remote/preset/:presetName response from the Remote Control API.
@freezed
class GetPresetResponse with _$GetPresetResponse {
  /// Returns a new instance of the [GetPresetResponse] with the given [preset].
  const factory GetPresetResponse({
    required Preset preset,
  }) = _GetPresetResponse;

  /// Returns a new instance of the [GetPresetResponse] from the
  /// given [json].
  factory GetPresetResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPresetResponseFromJson(json);
}
