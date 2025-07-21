import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/preset.dart';

part 'get_presets_response.freezed.dart';
part 'get_presets_response.g.dart';

/// https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/presets.
@freezed
abstract class GetPresetsResponse with _$GetPresetsResponse {
  const factory GetPresetsResponse({
    required List<Preset> presets,
  }) = _GetPresetsResponse;

  factory GetPresetsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPresetsResponseFromJson(json);
}
