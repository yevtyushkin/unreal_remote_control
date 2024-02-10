import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/preset.dart';

part 'get_presets_response.freezed.dart';
part 'get_presets_response.g.dart';

/// Represents a /remote/presets response from the Remote Control API.
@freezed
class GetPresetsResponse with _$GetPresetsResponse {
  /// Returns a new instance of the [GetPresetsResponse] with the given
  /// [presets].
  const factory GetPresetsResponse({
    required List<Preset> presets,
  }) = _GetPresetsResponse;

  /// Returns a new instance of the [GetPresetsResponse] from the
  /// given [json].
  factory GetPresetsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPresetsResponseFromJson(json);
}
