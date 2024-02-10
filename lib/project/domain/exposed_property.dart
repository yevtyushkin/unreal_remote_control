import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/underlying_property.dart';

part 'exposed_property.freezed.dart';
part 'exposed_property.g.dart';

/// A model that represents an exposed property of a preset group.
@freezed
class ExposedProperty with _$ExposedProperty {
  /// Returns a new instance of the [ExposedProperty] with the
  /// given [id], [displayName] and [underlyingProperty].
  const factory ExposedProperty({
    @JsonKey(name: 'ID') required String id,
    required String displayName,
    required UnderlyingProperty underlyingProperty,
  }) = _ExposedProperty;

  /// Returns a new instance of the [ExposedProperty] from the
  /// given [json].
  factory ExposedProperty.fromJson(Map<String, dynamic> json) =>
      _$ExposedPropertyFromJson(json);
}
