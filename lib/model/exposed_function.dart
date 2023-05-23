import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/model/underlying_function.dart';

part 'exposed_function.freezed.dart';
part 'exposed_function.g.dart';

@freezed
class ExposedFunction with _$ExposedFunction {
  const factory ExposedFunction({
    required String displayName,
    required UnderlyingFunction underlyingFunction,
  }) = _ExposedFunction;

  factory ExposedFunction.fromJson(Map<String, dynamic> json) => _$ExposedFunctionFromJson(json);
}
