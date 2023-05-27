import 'package:freezed_annotation/freezed_annotation.dart';

part 'underlying_property.freezed.dart';
part 'underlying_property.g.dart';

@freezed
class UnderlyingProperty with _$UnderlyingProperty {
  const factory UnderlyingProperty({
    @Default('') String name,
    @Default('') String type, // TODO: enum?
    @Default('') String description,
    @Default('') String containerType,
    @Default('') String keyType,
    @JsonKey(name: 'MetaData') @Default({}) Map<String, dynamic> metadata,
  }) = _UnderlyingProperty;

  factory UnderlyingProperty.fromJson(Map<String, dynamic> json) =>
      _$UnderlyingPropertyFromJson(json);
}
