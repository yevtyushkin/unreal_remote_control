import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/underlying_function.dart';

part 'exposed_function.freezed.dart';
part 'exposed_function.g.dart';

/// A model that represents an exposed function of a preset group.
@freezed
class ExposedFunction with _$ExposedFunction {
  /// Returns a new instance of the [ExposedFunction] with the
  /// given [id], [displayName] and [underlyingFunction].
  const factory ExposedFunction({
    @JsonKey(name: 'ID') required String id,
    required String displayName,
    required UnderlyingFunction underlyingFunction,
  }) = _ExposedFunction;

  /// Returns a new instance of the [ExposedFunction] from the
  /// given [json].
  factory ExposedFunction.fromJson(Map<String, dynamic> json) =>
      _$ExposedFunctionFromJson(json);
}
