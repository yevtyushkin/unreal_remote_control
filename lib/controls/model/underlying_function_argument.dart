import 'package:freezed_annotation/freezed_annotation.dart';

part 'underlying_function_argument.freezed.dart';
part 'underlying_function_argument.g.dart';

@freezed
class UnderlyingFunctionArgument with _$UnderlyingFunctionArgument {
  const factory UnderlyingFunctionArgument({
    @Default('') String name,
    @Default('') String description,
    @Default('') String type,
    @Default('') String containerType,
    @Default('') String keyType,
    @Default({}) Map<String, dynamic> metadata,
  }) = _UnderlyingFunctionArgument;

  factory UnderlyingFunctionArgument.fromJson(Map<String, dynamic> json) => _$UnderlyingFunctionArgumentFromJson(json);
}
