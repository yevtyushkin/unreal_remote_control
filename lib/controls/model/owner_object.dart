import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_object.freezed.dart';
part 'owner_object.g.dart';

@freezed
class OwnerObject with _$OwnerObject {
  const factory OwnerObject({
    @Default('') String name,
    @JsonKey(name: 'Class') @Default('') String clazz,
    @Default('') String path,
  }) = _OwnerObject;

  factory OwnerObject.fromJson(Map<String, dynamic> json) =>
      _$OwnerObjectFromJson(json);
}
