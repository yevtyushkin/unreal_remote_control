import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_value.freezed.dart';
part 'property_value.g.dart';

@freezed
class PropertyValue with _$PropertyValue {
  const factory PropertyValue({
    required dynamic propertyValue,
  }) = _PropertyValue;

  factory PropertyValue.fromJson(Map<String, dynamic> json) =>
      _$PropertyValueFromJson(json);
}
