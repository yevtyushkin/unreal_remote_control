import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_value.freezed.dart';
part 'property_value.g.dart';

/// `PropertyValues(N)` from https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name/property/insert-property-name.
@freezed
abstract class PropertyValue with _$PropertyValue {
  const factory PropertyValue({
    required dynamic propertyValue,
  }) = _PropertyValue;

  factory PropertyValue.fromJson(Map<String, dynamic> json) =>
      _$PropertyValueFromJson(json);
}
