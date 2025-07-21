import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/exposed_property.dart';
import 'package:unreal_remote_control/logic/property_value.dart';

part 'get_property_value_response.freezed.dart';
part 'get_property_value_response.g.dart';

/// https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name/property/insert-property-name.
@freezed
abstract class GetPropertyValueResponse with _$GetPropertyValueResponse {
  const factory GetPropertyValueResponse({
    required ExposedProperty exposedPropertyDescription,
    required List<PropertyValue> propertyValues,
  }) = _GetPropertyValueResponse;

  factory GetPropertyValueResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPropertyValueResponseFromJson(json);
}
