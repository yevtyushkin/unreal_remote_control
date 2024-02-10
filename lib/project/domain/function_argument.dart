import 'package:freezed_annotation/freezed_annotation.dart';

part 'function_argument.freezed.dart';
part 'function_argument.g.dart';

/// A model that represents an underlying function argument.
@freezed
class FunctionArgument with _$FunctionArgument {
  /// Returns a new instance of the [FunctionArgument]
  /// with the given [name], [description] and [type].
  const factory FunctionArgument({
    required String name,
    required String description,
    required String type,
  }) = _FunctionArgument;

  /// Returns a new instance of the [FunctionArgument] from the
  /// given [json].
  factory FunctionArgument.fromJson(Map<String, dynamic> json) =>
      _$FunctionArgumentFromJson(json);
}
