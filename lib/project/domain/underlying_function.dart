import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/function_argument.dart';

part 'underlying_function.freezed.dart';
part 'underlying_function.g.dart';

/// A model that represents an underlying function of the exposed function.
@freezed
class UnderlyingFunction with _$UnderlyingFunction {
  /// Returns a new instance of the [UnderlyingFunction] with the given
  /// [name], [description] and [arguments].
  const factory UnderlyingFunction({
    required String name,
    required String description,
    required List<FunctionArgument> arguments,
  }) = _UnderlyingFunction;

  /// Returns a new instance of the [UnderlyingFunction] from the
  /// given [json].
  factory UnderlyingFunction.fromJson(Map<String, dynamic> json) =>
      _$UnderlyingFunctionFromJson(json);
}
