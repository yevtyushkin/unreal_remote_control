import 'package:freezed_annotation/freezed_annotation.dart';

part 'underlying_function.freezed.dart';
part 'underlying_function.g.dart';

/// `UnderlyingFunction` from https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name.
@freezed
abstract class UnderlyingFunction with _$UnderlyingFunction {
  const factory UnderlyingFunction({
    required String name,
    required String description,
    required List<dynamic> arguments,
  }) = _UnderlyingFunction;

  factory UnderlyingFunction.fromJson(Map<String, dynamic> json) =>
      _$UnderlyingFunctionFromJson(json);
}
