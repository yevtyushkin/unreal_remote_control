import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/underlying_property.dart';

part 'exposed_property.freezed.dart';
part 'exposed_property.g.dart';

/// `ExposedProperty` from https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name.
@freezed
abstract class ExposedProperty with _$ExposedProperty {
  const factory ExposedProperty({
    @JsonKey(name: 'ID') required String id,
    required String displayName,
    required UnderlyingProperty underlyingProperty,
    @Default({}) Map<String, dynamic> metaData,
  }) = _ExposedProperty;

  factory ExposedProperty.fromJson(Map<String, dynamic> json) =>
      _$ExposedPropertyFromJson(json);
}
