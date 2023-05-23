import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/model/exposed_function.dart';
import 'package:unreal_remote_control/model/exposed_property.dart';

part 'selected_preset_group_field.freezed.dart';

@freezed
sealed class SelectedPresetGroupField with _$SelectedPresetGroupField {
  const factory SelectedPresetGroupField.selectedProperty({
    required ExposedProperty property,
    required dynamic value,
  }) = SelectedProperty;

  const factory SelectedPresetGroupField.selectedFunction({
    required ExposedFunction function,
  }) = SelectedFunction;
}
