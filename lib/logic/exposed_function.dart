import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/underlying_function.dart';

part 'exposed_function.freezed.dart';
part 'exposed_function.g.dart';

/// `ExposedFunction` from https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name.
@freezed
abstract class ExposedFunction with _$ExposedFunction {
  const factory ExposedFunction({
    @JsonKey(name: 'ID') required String id,
    required String displayName,
    required UnderlyingFunction underlyingFunction,
    @Default({}) Map<String, dynamic> metaData,
  }) = _ExposedFunction;

  factory ExposedFunction.fromJson(Map<String, dynamic> json) =>
      _$ExposedFunctionFromJson(json);
}
