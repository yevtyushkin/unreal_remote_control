import 'dart:ui' as ui;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/data/get_property_value_response.dart';
import 'package:unreal_remote_control/util/color_helper.dart';

part 'property_value_with_metadata.freezed.dart';

/// State of the exposed property value with some optional metadata.
@freezed
sealed class PropertyValueWithMetaData with _$PropertyValueWithMetaData {
  const factory PropertyValueWithMetaData.loading() = Loading;

  /// FLinearColor => isLinear == true.
  /// FColor => isLinear == false.
  const factory PropertyValueWithMetaData.color(
    ui.Color color, {
    required bool isLinear,
  }) = Color;

  const factory PropertyValueWithMetaData.floatOrDouble(
    double value, {
    double? min,
    double? max,
  }) = FloatOrDouble;

  /// Property which does not support yet nice UI representation.
  const factory PropertyValueWithMetaData.dynamic(dynamic value) = Dynamic;

  factory PropertyValueWithMetaData.fromResponse(
    GetPropertyValueResponse response,
  ) {
    final type = response.exposedPropertyDescription.underlyingProperty.type;
    final value = response.propertyValues[0].propertyValue;

    try {
      if (type == 'FColor') {
        final {
          'A': int a,
          'R': int r,
          'G': int g,
          'B': int b,
        } = value as Map;
        return PropertyValueWithMetaData.color(
          ui.Color.fromARGB(a, r, g, b),
          isLinear: false,
        );
      }

      if (type == 'FLinearColor') {
        final {
          'A': num a,
          'R': num r,
          'G': num g,
          'B': num b,
        } = value as Map;
        return PropertyValueWithMetaData.color(
          ColorHelper.colorLinear(
            r: r.toDouble(),
            g: g.toDouble(),
            b: b.toDouble(),
            a: a.toDouble(),
          ),
          isLinear: true,
        );
      }

      if (type == 'double' || type == 'float') {
        final min = double.tryParse(
          response.exposedPropertyDescription.metaData['Min']?.toString() ?? '',
        );
        final max = double.tryParse(
          response.exposedPropertyDescription.metaData['Max']?.toString() ?? '',
        );

        return PropertyValueWithMetaData.floatOrDouble(
          (value as num).toDouble(),
          min: min,
          max: max,
        );
      }
    } catch (_) {}

    return PropertyValueWithMetaData.dynamic(value);
  }
}
