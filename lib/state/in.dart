import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/model/exposed_property.dart';
import 'package:unreal_remote_control/model/preset.dart';
import 'package:unreal_remote_control/model/preset_entry.dart';
import 'package:unreal_remote_control/model/property_value.dart';

part 'in.freezed.dart'; // TODO:
part 'in.g.dart';

@freezed
class HttpResponseEnvelope with _$HttpResponseEnvelope {
  const HttpResponseEnvelope._();

  const factory HttpResponseEnvelope({
    required int requestId,
    required int responseCode,
    required Map<String, dynamic>? responseBody,
  }) = _HttpResponseEnvelope;

  HttpResponse? get response {
    final _responseBody = responseBody;

    if (_responseBody == null) return null;

    return HttpResponse.customFromJson(_responseBody);
  }

  factory HttpResponseEnvelope.fromJson(Map<String, dynamic> json) =>
      _$HttpResponseEnvelopeFromJson(json);
}

@freezed
sealed class HttpResponse with _$HttpResponse {
  const factory HttpResponse.allPresets({
    required List<PresetEntry> presets,
  }) = AllPresets;

  const factory HttpResponse.getPreset({
    required Preset preset,
  }) = GetPreset;

  const factory HttpResponse.getExposedProperty({
    required ExposedProperty exposedPropertyDescription,
    required List<PropertyValue> propertyValues,
  }) = GetExposedProperty;

  factory HttpResponse.customFromJson(Map<String, dynamic> json) {
    if (json.containsKey('Presets')) return AllPresets.fromJson(json);
    if (json.containsKey('Preset')) return GetPreset.fromJson(json);
    if (json.containsKey('ExposedPropertyDescription'))
      return GetExposedProperty.fromJson(json);

    throw "Can't parse $json into HttpResponse";
  }

  factory HttpResponse.fromJson(Map<String, dynamic> json) =>
      _$HttpResponseFromJson(json);
}
