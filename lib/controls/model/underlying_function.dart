import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/controls/model/underlying_function_argument.dart';

part 'underlying_function.freezed.dart';
part 'underlying_function.g.dart';

@freezed
class UnderlyingFunction with _$UnderlyingFunction {
  const factory UnderlyingFunction({
    required String name,
    @Default('') String description,
    @Default([]) List<UnderlyingFunctionArgument> arguments,
  }) = _UnderlyingFunction;

  factory UnderlyingFunction.fromJson(Map<String, dynamic> json) => _$UnderlyingFunctionFromJson(json);
}
