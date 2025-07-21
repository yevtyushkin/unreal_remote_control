import 'package:freezed_annotation/freezed_annotation.dart';

part 'underlying_property.freezed.dart';
part 'underlying_property.g.dart';

/// `UnderlyingProperty` from https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name.
@freezed
abstract class UnderlyingProperty with _$UnderlyingProperty {
  const factory UnderlyingProperty({
    required String name,
    required String displayName,
    required String description,
    required String type,
  }) = _UnderlyingProperty;

  factory UnderlyingProperty.fromJson(Map<String, dynamic> json) =>
      _$UnderlyingPropertyFromJson(json);
}
