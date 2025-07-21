import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/preset.dart';

part 'get_preset_response.freezed.dart';
part 'get_preset_response.g.dart';

/// https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name.
@freezed
abstract class GetPresetResponse with _$GetPresetResponse {
  const factory GetPresetResponse({
    required Preset preset,
  }) = _GetPresetResponse;

  factory GetPresetResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPresetResponseFromJson(json);
}
