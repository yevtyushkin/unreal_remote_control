import 'package:freezed_annotation/freezed_annotation.dart';

part 'underlying_property.freezed.dart';
part 'underlying_property.g.dart';

/// A model that represents an underlying property of the exposed property.
@freezed
class UnderlyingProperty with _$UnderlyingProperty {
  /// Returns a new instance of the [UnderlyingProperty] with the given [name],
  /// [description] and [type].
  const factory UnderlyingProperty({
    required String name,
    required String description,
    required String type,
  }) = _UnderlyingProperty;

  /// Returns a new instance of the [UnderlyingProperty] from the
  /// given [json].
  factory UnderlyingProperty.fromJson(Map<String, dynamic> json) =>
      _$UnderlyingPropertyFromJson(json);
}
