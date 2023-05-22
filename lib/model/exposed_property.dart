import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/model/owner_object.dart';
import 'package:unreal_remote_control/model/underlying_property.dart';

part 'exposed_property.freezed.dart';
part 'exposed_property.g.dart';

@freezed
class ExposedProperty with _$ExposedProperty {
  const factory ExposedProperty({
    required String displayName,
    @Default(UnderlyingProperty()) UnderlyingProperty underlyingProperty,
    @JsonKey(name: 'ID') @Default('') String id,
    @JsonKey(name: 'MetaData') @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<OwnerObject> ownerObjects,
  }) = _ExposedProperty;

  factory ExposedProperty.fromJson(Map<String, dynamic> json) =>
      _$ExposedPropertyFromJson(json);
}
